package ml.fasodocs.backend.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import ml.fasodocs.backend.dto.request.ProcedureRequest;
import ml.fasodocs.backend.dto.request.ProcedureUpdateRequest;
import ml.fasodocs.backend.dto.response.AudioResponse;
import ml.fasodocs.backend.dto.response.MessageResponse;
import ml.fasodocs.backend.dto.response.ProcedureResponse;
import ml.fasodocs.backend.service.AudioService;
import ml.fasodocs.backend.service.ProcedureService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * Contrôleur REST pour la gestion des procédures administratives
 */
@Tag(name = "Procédures", description = "API pour la gestion des procédures administratives")
@RestController
@RequestMapping("/procedures")
@CrossOrigin(origins = "*", maxAge = 3600)
public class ProcedureController {

    @Autowired
    private ProcedureService procedureService;

    @Autowired
    private AudioService audioService;

    /**
     * Récupère toutes les procédures
     */
    @Operation(summary = "Récupère toutes les procédures")
    @GetMapping
    public ResponseEntity<List<ProcedureResponse>> obtenirToutesProcedures() {
        return ResponseEntity.ok(procedureService.obtenirToutesProcedures());
    }

    /**
     * Récupère une procédure par ID
     */
    @Operation(summary = "Récupère une procédure par son ID")
    @GetMapping("/{id}")
    public ResponseEntity<?> obtenirProcedureParId(@PathVariable Long id) {
        try {
            ProcedureResponse response = procedureService.obtenirProcedureParId(id);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                    .body(MessageResponse.error("Procédure non trouvée: " + e.getMessage()));
        }
    }

    /**
     * Récupère les procédures par catégorie
     */
    @Operation(summary = "Récupère les procédures d'une catégorie")
    @GetMapping("/categorie/{categorieId}")
    public ResponseEntity<List<ProcedureResponse>> obtenirProceduresParCategorie(@PathVariable Long categorieId) {
        return ResponseEntity.ok(procedureService.obtenirProceduresParCategorie(categorieId));
    }

    /**
     * Récupère les procédures par sous-catégorie
     */
    @Operation(summary = "Récupère les procédures d'une sous-catégorie")
    @GetMapping("/sous-categorie/{sousCategorieId}")
    public ResponseEntity<List<ProcedureResponse>> obtenirProceduresParSousCategorie(@PathVariable Long sousCategorieId) {
        return ResponseEntity.ok(procedureService.obtenirProceduresParSousCategorie(sousCategorieId));
    }

    /**
     * Recherche des procédures
     */
    @Operation(summary = "Recherche des procédures par nom ou titre")
    @GetMapping("/rechercher")
    public ResponseEntity<List<ProcedureResponse>> rechercherProcedures(@RequestParam String q) {
        return ResponseEntity.ok(procedureService.rechercherProcedures(q));
    }

    /**
     * Crée une nouvelle procédure (Admin uniquement)
     */
    @Operation(summary = "Crée une nouvelle procédure (Admin)")
    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping
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
     * Met à jour une procédure (Admin uniquement)
     */
    @Operation(summary = "Met à jour une procédure (Admin)")
    @PreAuthorize("hasRole('ADMIN')")
    @PutMapping("/{id}")
    public ResponseEntity<?> mettreAJourProcedure(@PathVariable Long id, 
                                                  @RequestBody ProcedureUpdateRequest request) {
        try {
            ProcedureResponse response = procedureService.mettreAJourProcedure(id, request);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                    .body(MessageResponse.error("Erreur lors de la mise à jour: " + e.getMessage()));
        }
    }

    /**
     * Supprime une procédure (Admin uniquement)
     */
    @Operation(summary = "Supprime une procédure (Admin)")
    @PreAuthorize("hasRole('ADMIN')")
    @DeleteMapping("/{id}")
    public ResponseEntity<?> supprimerProcedure(@PathVariable Long id) {
        try {
            MessageResponse response = procedureService.supprimerProcedure(id);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                    .body(MessageResponse.error("Erreur lors de la suppression: " + e.getMessage()));
        }
    }

    /**
     * Récupère le fichier audio d'une procédure (fichier binaire) avec amplification du volume
     */
    @Operation(summary = "Récupère le fichier audio d'une procédure (fichier binaire) avec amplification du volume")
    @GetMapping("/{id}/audio")
    public ResponseEntity<?> obtenirAudioProcedure(@PathVariable Long id) {
        try {
            byte[] audioBytes = audioService.getAudioBytes(id);
            
            if (audioBytes == null) {
                return ResponseEntity.notFound().build();
            }

            // Récupérer le nom du fichier pour déterminer le type MIME
            Resource originalResource = audioService.getAudioFile(id);
            String filename = originalResource != null && originalResource.getFilename() != null 
                    ? originalResource.getFilename() 
                    : "audio.wav";
            
            // Déterminer le type MIME
            String contentType = "audio/wav"; // Par défaut
            String lowerFilename = filename.toLowerCase();
            if (lowerFilename.endsWith(".mp3")) {
                contentType = "audio/mpeg";
            } else if (lowerFilename.endsWith(".wav")) {
                contentType = "audio/wav";
            } else if (lowerFilename.endsWith(".ogg")) {
                contentType = "audio/ogg";
            } else if (lowerFilename.endsWith(".aac")) {
                contentType = "audio/aac";
            }

            // Créer une Resource à partir des bytes amplifiés
            ByteArrayResource resource = new ByteArrayResource(audioBytes);

            return ResponseEntity.ok()
                    .contentType(MediaType.parseMediaType(contentType))
                    .header(HttpHeaders.CONTENT_DISPOSITION, "inline; filename=\"" + filename + "\"")
                    .body(resource);
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                    .body(MessageResponse.error("Erreur lors de la récupération de l'audio: " + e.getMessage()));
        }
    }

    /**
     * Récupère l'audio d'une procédure en Base64 (pour Flutter)
     */
    @Operation(summary = "Récupère l'audio d'une procédure en Base64 (pour Flutter)")
    @GetMapping("/{id}/audio/base64")
    public ResponseEntity<?> obtenirAudioProcedureBase64(@PathVariable Long id) {
        try {
            String audioBase64 = audioService.getAudioBase64(id);
            
            if (audioBase64 == null) {
                return ResponseEntity.status(404)
                        .body(MessageResponse.error("Aucun fichier audio disponible pour cette procédure"));
            }

            // Récupérer les infos de la procédure
            ProcedureResponse procedure = procedureService.obtenirProcedureParId(id);
            
            // Déterminer le format depuis le nom du fichier
            String format = "wav";
            String filename = procedure.getAudioUrl();
            if (filename != null) {
                String lowerFilename = filename.toLowerCase();
                if (lowerFilename.endsWith(".mp3")) {
                    format = "mp3";
                } else if (lowerFilename.endsWith(".wav")) {
                    format = "wav";
                } else if (lowerFilename.endsWith(".ogg")) {
                    format = "ogg";
                } else if (lowerFilename.endsWith(".aac")) {
                    format = "aac";
                }
            }

            // Calculer la taille approximative
            long fileSize = (audioBase64.length() * 3) / 4; // Approximation Base64

            AudioResponse response = AudioResponse.builder()
                    .procedureId(id)
                    .procedureNom(procedure.getNom())
                    .audioBase64(audioBase64)
                    .format(format)
                    .filename(filename)
                    .fileSize(fileSize)
                    .build();

            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                    .body(MessageResponse.error("Erreur lors de la récupération de l'audio: " + e.getMessage()));
        }
    }
}
