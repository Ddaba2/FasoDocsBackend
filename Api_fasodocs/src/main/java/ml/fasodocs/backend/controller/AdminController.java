package ml.fasodocs.backend.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import ml.fasodocs.backend.dto.request.CategorieRequest;
import ml.fasodocs.backend.dto.request.CreerUtilisateurRequest;
import ml.fasodocs.backend.dto.request.ProcedureRequest;
import ml.fasodocs.backend.dto.request.SousCategorieRequest;
import ml.fasodocs.backend.dto.response.*;
import ml.fasodocs.backend.entity.Citoyen;
import ml.fasodocs.backend.entity.Role;
import ml.fasodocs.backend.repository.CitoyenRepository;
import ml.fasodocs.backend.repository.RoleRepository;
import ml.fasodocs.backend.service.*;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;

import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

/**
 * Contrôleur REST pour les opérations d'administration
 */
@Tag(name = "Administration", description = "API pour les opérations d'administration")
@RestController
@RequestMapping("/admin")
@CrossOrigin(origins = "*", maxAge = 3600)
public class AdminController {

    @Autowired
    private CategorieService categorieService;

    @Autowired
    private SousCategorieService sousCategorieService;

    @Autowired
    private ProcedureService procedureService;

    @Autowired
    private CitoyenRepository citoyenRepository;

    @Autowired
    private RoleRepository roleRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;
    
    @Autowired
    private OrangeSmsService orangeSmsService;

    // ==============================
    // GESTION DES UTILISATEURS
    // ==============================

    /**
     * Liste tous les utilisateurs enregistrés dans la base de données
     */
    @Operation(summary = "Liste tous les utilisateurs (Admin)")
    @PreAuthorize("hasRole('ADMIN')")
    @GetMapping("/utilisateurs")
    public ResponseEntity<List<CitoyenResponse>> listerTousLesUtilisateurs() {
        List<Citoyen> utilisateurs = citoyenRepository.findAll();
        List<CitoyenResponse> responses = utilisateurs.stream()
                .map(CitoyenResponse::new)
                .collect(Collectors.toList());
        return ResponseEntity.ok(responses);
    }

    /**
     * Crée un nouvel utilisateur
     */
    @Operation(summary = "Crée un nouvel utilisateur (Admin)")
    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping("/utilisateurs")
    public ResponseEntity<?> creerUtilisateur(@Valid @RequestBody CreerUtilisateurRequest request) {
        try {
            // Vérifier si l'email existe déjà
            if (citoyenRepository.findByEmail(request.getEmail()).isPresent()) {
                return ResponseEntity.badRequest()
                        .body(MessageResponse.error("Cet email est déjà utilisé"));
            }

            // Vérifier si le téléphone existe déjà
            if (citoyenRepository.findByTelephone(request.getTelephone()).isPresent()) {
                return ResponseEntity.badRequest()
                        .body(MessageResponse.error("Ce numéro de téléphone est déjà utilisé"));
            }

            // Créer le nouvel utilisateur
            Citoyen nouvelUtilisateur = new Citoyen();
            nouvelUtilisateur.setNom(request.getNom());
            nouvelUtilisateur.setPrenom(request.getPrenom());
            nouvelUtilisateur.setEmail(request.getEmail());
            nouvelUtilisateur.setTelephone(request.getTelephone());
            nouvelUtilisateur.setMotDePasse(passwordEncoder.encode(request.getMotDePasse()));
            nouvelUtilisateur.setEstActif(true);
            nouvelUtilisateur.setEmailVerifie(true);
            nouvelUtilisateur.setTelephoneVerifie(true);
            nouvelUtilisateur.setLanguePreferee("fr");

            // Assigner le rôle
            Set<Role> roles = new HashSet<>();
            Role.NomRole nomRole;
            try {
                nomRole = Role.NomRole.valueOf(request.getRole());
            } catch (IllegalArgumentException e) {
                return ResponseEntity.badRequest()
                        .body(MessageResponse.error("Rôle invalide. Utilisez ROLE_CITOYEN ou ROLE_ADMIN"));
            }

            Role role = roleRepository.findByNom(nomRole)
                    .orElseThrow(() -> new RuntimeException("Rôle non trouvé: " + request.getRole()));
            roles.add(role);
            nouvelUtilisateur.setRoles(roles);

            // Sauvegarder l'utilisateur
            Citoyen utilisateurCree = citoyenRepository.save(nouvelUtilisateur);

            return ResponseEntity.status(HttpStatus.CREATED)
                    .body(new CitoyenResponse(utilisateurCree));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(MessageResponse.error("Erreur lors de la création de l'utilisateur: " + e.getMessage()));
        }
    }

    /**
     * Obtient le statut du service SMS Orange
     */
    @Operation(summary = "Statut du service SMS Orange (Admin)")
    @PreAuthorize("hasRole('ADMIN')")
    @GetMapping("/sms/status")
    public ResponseEntity<?> getSmsStatus() {
        try {
            Map<String, Object> status = new java.util.HashMap<>();
            status.put("enabled", orangeSmsService.isSmsEnabled());
            status.put("configured", orangeSmsService.isOrangeSmsConfigured());
            status.put("rateLimitAvailable", orangeSmsService.getAvailablePermits());
            status.put("rateLimitMax", 5);
            status.put("info", "Rate limit: 5 SMS par seconde (limite Orange)");
            
            return ResponseEntity.ok(status);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(MessageResponse.error("Erreur lors de la récupération du statut SMS: " + e.getMessage()));
        }
    }

    /**
     * Supprime un utilisateur
     */
    @Operation(summary = "Supprime un utilisateur (Admin)")
    @PreAuthorize("hasRole('ADMIN')")
    @DeleteMapping("/utilisateurs/{id}")
    public ResponseEntity<?> supprimerUtilisateur(@PathVariable Long id) {
        try {
            // Vérifier si l'utilisateur existe
            Citoyen utilisateur = citoyenRepository.findById(id)
                    .orElseThrow(() -> new RuntimeException("Utilisateur non trouvé avec l'ID: " + id));

            // Empêcher la suppression du dernier admin
            Role roleAdmin = roleRepository.findByNom(Role.NomRole.ROLE_ADMIN)
                    .orElseThrow(() -> new RuntimeException("Rôle ADMIN non trouvé"));

            if (utilisateur.getRoles().contains(roleAdmin)) {
                long nombreAdmins = citoyenRepository.findAll().stream()
                        .filter(c -> c.getRoles().contains(roleAdmin))
                        .count();

                if (nombreAdmins <= 1) {
                    return ResponseEntity.badRequest()
                            .body(MessageResponse.error("Impossible de supprimer le dernier administrateur"));
                }
            }

            // Supprimer l'utilisateur
            citoyenRepository.deleteById(id);

            return ResponseEntity.ok(MessageResponse.success("Utilisateur supprimé avec succès"));
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest()
                    .body(MessageResponse.error(e.getMessage()));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(MessageResponse.error("Erreur lors de la suppression de l'utilisateur: " + e.getMessage()));
        }
    }

    // ==============================
    // GESTION DES CATÉGORIES
    // ==============================

    /**
     * Liste toutes les catégories
     */
    @Operation(summary = "Liste toutes les catégories (Admin)")
    @PreAuthorize("hasRole('ADMIN')")
    @GetMapping("/categories")
    public ResponseEntity<List<CategorieResponse>> listerToutesLesCategories() {
        return ResponseEntity.ok(categorieService.obtenirToutesCategories());
    }

    /**
     * Crée une nouvelle catégorie
     */
    @Operation(summary = "Crée une nouvelle catégorie (Admin)")
    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping("/categories")
    public ResponseEntity<?> creerCategorie(@Valid @RequestBody CategorieRequest request) {
        try {
            CategorieResponse response = categorieService.creerCategorie(request);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                    .body(MessageResponse.error("Erreur lors de la création: " + e.getMessage()));
        }
    }

    /**
     * Met à jour une catégorie
     */
    @Operation(summary = "Met à jour une catégorie (Admin)")
    @PreAuthorize("hasRole('ADMIN')")
    @PutMapping("/categories/{id}")
    public ResponseEntity<?> mettreAJourCategorie(@PathVariable Long id, 
                                                 @Valid @RequestBody CategorieRequest request) {
        try {
            CategorieResponse response = categorieService.mettreAJourCategorie(id, request);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                    .body(MessageResponse.error("Erreur lors de la mise à jour: " + e.getMessage()));
        }
    }

    /**
     * Supprime une catégorie
     */
    @Operation(summary = "Supprime une catégorie (Admin)")
    @PreAuthorize("hasRole('ADMIN')")
    @DeleteMapping("/categories/{id}")
    public ResponseEntity<?> supprimerCategorie(@PathVariable Long id) {
        try {
            MessageResponse response = categorieService.supprimerCategorie(id);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                    .body(MessageResponse.error("Erreur lors de la suppression: " + e.getMessage()));
        }
    }

    // ==============================
    // GESTION DES SOUS-CATÉGORIES
    // ==============================

    /**
     * Liste toutes les sous-catégories
     */
    @Operation(summary = "Liste toutes les sous-catégories (Admin)")
    @PreAuthorize("hasRole('ADMIN')")
    @GetMapping("/sous-categories")
    public ResponseEntity<List<SousCategorieResponse>> listerToutesLesSousCategories() {
        return ResponseEntity.ok(sousCategorieService.obtenirToutesSousCategories());
    }

    /**
     * Crée une nouvelle sous-catégorie
     */
    @Operation(summary = "Crée une nouvelle sous-catégorie (Admin)")
    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping("/sous-categories")
    public ResponseEntity<?> creerSousCategorie(@Valid @RequestBody SousCategorieRequest request) {
        try {
            SousCategorieResponse response = sousCategorieService.creerSousCategorie(request);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                    .body(MessageResponse.error("Erreur lors de la création: " + e.getMessage()));
        }
    }

    /**
     * Met à jour une sous-catégorie
     */
    @Operation(summary = "Met à jour une sous-catégorie (Admin)")
    @PreAuthorize("hasRole('ADMIN')")
    @PutMapping("/sous-categories/{id}")
    public ResponseEntity<?> mettreAJourSousCategorie(@PathVariable Long id, 
                                                     @Valid @RequestBody SousCategorieRequest request) {
        try {
            SousCategorieResponse response = sousCategorieService.mettreAJourSousCategorie(id, request);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                    .body(MessageResponse.error("Erreur lors de la mise à jour: " + e.getMessage()));
        }
    }

    /**
     * Supprime une sous-catégorie
     */
    @Operation(summary = "Supprime une sous-catégorie (Admin)")
    @PreAuthorize("hasRole('ADMIN')")
    @DeleteMapping("/sous-categories/{id}")
    public ResponseEntity<?> supprimerSousCategorie(@PathVariable Long id) {
        try {
            MessageResponse response = sousCategorieService.supprimerSousCategorie(id);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                    .body(MessageResponse.error("Erreur lors de la suppression: " + e.getMessage()));
        }
    }

    // ==============================
    // GESTION DES PROCÉDURES
    // ==============================

    /**
     * Liste toutes les procédures
     */
    @Operation(summary = "Liste toutes les procédures (Admin)")
    @PreAuthorize("hasRole('ADMIN')")
    @GetMapping("/procedures")
    public ResponseEntity<List<ProcedureResponse>> listerToutesLesProcedures() {
        return ResponseEntity.ok(procedureService.obtenirToutesProcedures());
    }

    /**
     * Crée une nouvelle procédure
     */
    @Operation(summary = "Crée une nouvelle procédure (Admin)")
    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping("/procedures")
    public ResponseEntity<?> creerProcedure(@Valid @RequestBody ProcedureRequest request) {
        try {
            ProcedureResponse response = procedureService.creerProcedure(request);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                    .body(MessageResponse.error("Erreur lors de la création: " + e.getMessage()));
        }
    }

    /**
     * Met à jour une procédure
     */
    @Operation(summary = "Met à jour une procédure (Admin)")
    @PreAuthorize("hasRole('ADMIN')")
    @PutMapping("/procedures/{id}")
    public ResponseEntity<?> mettreAJourProcedure(@PathVariable Long id, 
                                                 @Valid @RequestBody ProcedureRequest request) {
        try {
            ProcedureResponse response = procedureService.mettreAJourProcedure(id, request);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                    .body(MessageResponse.error("Erreur lors de la mise à jour: " + e.getMessage()));
        }
    }

    /**
     * Supprime une procédure
     */
    @Operation(summary = "Supprime une procédure (Admin)")
    @PreAuthorize("hasRole('ADMIN')")
    @DeleteMapping("/procedures/{id}")
    public ResponseEntity<?> supprimerProcedure(@PathVariable Long id) {
        try {
            MessageResponse response = procedureService.supprimerProcedure(id);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                    .body(MessageResponse.error("Erreur lors de la suppression: " + e.getMessage()));
        }
    }
}