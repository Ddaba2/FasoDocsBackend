package ml.fasodocs.backend.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import ml.fasodocs.backend.dto.request.ConnexionRequest;
import ml.fasodocs.backend.dto.request.ConnexionTelephoneRequest;
import ml.fasodocs.backend.dto.request.InscriptionRequest;
import ml.fasodocs.backend.dto.request.MiseAJourProfilRequest;
import ml.fasodocs.backend.dto.request.UploadPhotoRequest;
import ml.fasodocs.backend.dto.request.VerificationSmsRequest;
import ml.fasodocs.backend.dto.response.JwtResponse;
import ml.fasodocs.backend.dto.response.MessageResponse;
import ml.fasodocs.backend.dto.response.CitoyenProfilResponse;
import ml.fasodocs.backend.entity.Citoyen;
import ml.fasodocs.backend.security.UserDetailsImpl;
import ml.fasodocs.backend.service.AuthService;
import ml.fasodocs.backend.service.OrangeSmsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

/**
 * Contrôleur REST pour l'authentification et la gestion du profil
 */
@Tag(name = "Authentification", description = "API pour l'inscription, la connexion et la gestion du profil")
@RestController
@RequestMapping("/auth")
@CrossOrigin(origins = "*", maxAge = 3600)
public class AuthController {

    @Autowired
    private AuthService authService;
    
    @Autowired
    private OrangeSmsService orangeSmsService;

    /**
     * Inscription d'un nouveau citoyen
     */
    @Operation(summary = "Inscription d'un nouveau citoyen")
    @PostMapping("/inscription")
    public ResponseEntity<?> inscrire(@Valid @RequestBody InscriptionRequest request) {
        try {
            MessageResponse response = authService.inscrireCitoyen(request);
            if (response.isSuccess()) {
                return ResponseEntity.ok(response);
            } else {
                return ResponseEntity.badRequest().body(response);
            }
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                    .body(MessageResponse.error("Erreur lors de l'inscription: " + e.getMessage()));
        }
    }

    /**
     * Connexion par téléphone uniquement - Envoie un code SMS
     */
    @Operation(summary = "Connexion par téléphone - Envoie un code SMS")
    @PostMapping("/connexion-telephone")
    public ResponseEntity<?> connecterParTelephone(@Valid @RequestBody ConnexionTelephoneRequest request) {
        try {
            MessageResponse response = authService.connecterParTelephone(request);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                    .body(MessageResponse.error("Erreur de connexion: " + e.getMessage()));
        }
    }

    /**
     * Connexion d'un citoyen - Envoie un code SMS (ancienne méthode)
     */
    @Operation(summary = "Connexion d'un citoyen - Envoie un code SMS")
    @PostMapping("/connexion")
    public ResponseEntity<?> connecter(@Valid @RequestBody ConnexionRequest request) {
        try {
            MessageResponse response = authService.connecterCitoyen(request);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                    .body(MessageResponse.error("Erreur de connexion: " + e.getMessage()));
        }
    }

    /**
     * Vérification du code SMS et connexion
     */
    @Operation(summary = "Vérification du code SMS et connexion")
    @PostMapping("/verifier-sms")
    public ResponseEntity<?> verifierCodeSms(@Valid @RequestBody VerificationSmsRequest request) {
        try {
            JwtResponse response = authService.verifierCodeSms(request);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                    .body(MessageResponse.error("Erreur de vérification: " + e.getMessage()));
        }
    }

    /**
     * Vérification de l'email
     */
    @Operation(summary = "Vérification de l'email via code")
    @GetMapping("/verify")
    public ResponseEntity<?> verifierEmail(@RequestParam String code) {
        try {
            MessageResponse response = authService.verifierEmail(code);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                    .body(MessageResponse.error("Code de vérification invalide"));
        }
    }

    /**
     * Récupération du profil du citoyen connecté (VERSION CORRIGÉE)
     */
    @Operation(summary = "Récupération du profil du citoyen connecté")
    @GetMapping("/profil")
    public ResponseEntity<?> obtenirProfil(@AuthenticationPrincipal UserDetailsImpl userDetails) {
        // Grâce à @AuthenticationPrincipal, Spring injecte l'objet utilisateur authentifié.
        // Cela élimine le risque de ClassCastException.

        if (userDetails == null) {
            // Sécurité : si la route est mal configurée et accessible sans token, on renvoie une erreur claire.
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED) // 401 Unauthorized
                    .body(MessageResponse.error("Authentification requise pour accéder au profil."));
        }

        try {
            // On utilise l'ID de l'utilisateur authentifié (stocké dans UserDetailsImpl)
            // pour récupérer l'entité Citoyen complète depuis la base de données.
            // NOTE : Vous devez avoir une méthode dans votre service qui permet de faire cela.

            Citoyen citoyen = authService.trouverCitoyenParId(userDetails.getId()); // ou getCitoyenById, etc.
            
            // Convertir l'entité en DTO pour éviter les problèmes de sérialisation JSON
            CitoyenProfilResponse response = new CitoyenProfilResponse(
                citoyen.getId(),
                citoyen.getNom(),
                citoyen.getPrenom(),
                citoyen.getTelephone(),
                citoyen.getEmail(),
                citoyen.getEstActif(),
                citoyen.getEmailVerifie(),
                citoyen.getTelephoneVerifie(),
                citoyen.getLanguePreferee(),
                citoyen.getPhotoProfil(),
                citoyen.getDateCreation(),
                citoyen.getDateModification()
            );

            return ResponseEntity.ok(response);

        } catch (Exception e) {
            // Cette exception sera levée si l'ID n'est pas trouvé, par exemple.
            return ResponseEntity.badRequest()
                    .body(MessageResponse.error("Erreur lors de la récupération des détails du profil: " + e.getMessage()));
        }
    }

    /**
     * Mise à jour du profil
     */
    @Operation(summary = "Mise à jour du profil du citoyen connecté")
    @PutMapping("/profil")
    public ResponseEntity<?> mettreAJourProfil(@Valid @RequestBody MiseAJourProfilRequest request) {
        try {
            MessageResponse response = authService.mettreAJourProfil(request);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                    .body(MessageResponse.error("Erreur lors de la mise à jour du profil: " + e.getMessage()));
        }
    }

    /**
     * Upload de photo de profil
     */
    @Operation(summary = "Upload de la photo de profil du citoyen connecté")
    @PostMapping("/profil/photo")
    public ResponseEntity<?> uploadPhotoProfil(@Valid @RequestBody UploadPhotoRequest request) {
        try {
            MessageResponse response = authService.uploadPhotoProfil(request);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                    .body(MessageResponse.error("Erreur lors de l'upload de la photo: " + e.getMessage()));
        }
    }

    /**
     * Suppression de la photo de profil
     */
    @Operation(summary = "Suppression de la photo de profil du citoyen connecté")
    @DeleteMapping("/profil/photo")
    public ResponseEntity<?> supprimerPhotoProfil() {
        try {
            MessageResponse response = authService.supprimerPhotoProfil();
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                    .body(MessageResponse.error("Erreur lors de la suppression de la photo: " + e.getMessage()));
        }
    }

    /**
     * Déconnexion
     */
    @Operation(summary = "Déconnexion du citoyen")
    @PostMapping("/deconnexion")
    public ResponseEntity<?> deconnecter() {
        try {
            MessageResponse response = authService.deconnecter();
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                    .body(MessageResponse.error("Erreur lors de la déconnexion: " + e.getMessage()));
        }
    }
}
