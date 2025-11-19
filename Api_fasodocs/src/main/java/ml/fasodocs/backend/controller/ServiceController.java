package ml.fasodocs.backend.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import ml.fasodocs.backend.dto.request.CreerDemandeServiceRequest;
import ml.fasodocs.backend.dto.response.DemandeServiceResponse;
import ml.fasodocs.backend.dto.response.MessageResponse;
import ml.fasodocs.backend.dto.response.TarifServiceResponse;
import ml.fasodocs.backend.service.ServiceService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * Contrôleur REST pour la gestion des services de procédures
 */
@Tag(name = "Services", description = "API pour les services de procédures administratives")
@RestController
@RequestMapping("/services")
@CrossOrigin(origins = "*", maxAge = 3600)
public class ServiceController {

    @Autowired
    private ServiceService serviceService;

    /**
     * Récupère le tarif de service pour une procédure
     */
    @Operation(summary = "Récupère le tarif de service pour une procédure")
    @GetMapping("/procedures/{procedureId}/tarif")
    public ResponseEntity<?> obtenirTarifService(
            @PathVariable Long procedureId,
            @RequestParam String commune) {
        try {
            TarifServiceResponse response = serviceService.obtenirTarifService(procedureId, commune);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                    .body(MessageResponse.error("Erreur lors de la récupération du tarif: " + e.getMessage()));
        }
    }

    /**
     * Crée une nouvelle demande de service
     */
    @Operation(summary = "Crée une nouvelle demande de service")
    @PostMapping("/demandes")
    public ResponseEntity<?> creerDemandeService(@Valid @RequestBody CreerDemandeServiceRequest request) {
        try {
            DemandeServiceResponse response = serviceService.creerDemandeService(request);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                    .body(MessageResponse.error("Erreur lors de la création de la demande: " + e.getMessage()));
        }
    }

    /**
     * Récupère les demandes de l'utilisateur connecté
     */
    @Operation(summary = "Récupère les demandes de l'utilisateur connecté")
    @GetMapping("/mes-demandes")
    public ResponseEntity<?> obtenirMesDemandes() {
        try {
            List<DemandeServiceResponse> demandes = serviceService.obtenirMesDemandes();
            return ResponseEntity.ok(demandes);
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                    .body(MessageResponse.error("Erreur lors de la récupération des demandes: " + e.getMessage()));
        }
    }

    /**
     * Récupère une demande spécifique
     */
    @Operation(summary = "Récupère une demande de service par son ID")
    @GetMapping("/demandes/{id}")
    public ResponseEntity<?> obtenirDemandeParId(@PathVariable Long id) {
        try {
            DemandeServiceResponse response = serviceService.obtenirDemandeParId(id);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                    .body(MessageResponse.error("Erreur lors de la récupération de la demande: " + e.getMessage()));
        }
    }

    /**
     * Annule une demande de service
     */
    @Operation(summary = "Annule une demande de service (uniquement si statut = EN_ATTENTE)")
    @PutMapping("/demandes/{id}/annuler")
    public ResponseEntity<?> annulerDemande(
            @PathVariable Long id,
            @RequestParam(required = false) String raison) {
        try {
            MessageResponse response = serviceService.annulerDemande(id, raison);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                    .body(MessageResponse.error("Erreur lors de l'annulation: " + e.getMessage()));
        }
    }
}

