package ml.fasodocs.backend.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import ml.fasodocs.backend.dto.request.ModifierSignalementRequest;
import ml.fasodocs.backend.dto.request.SignalementRequest;
import ml.fasodocs.backend.dto.response.MessageResponse;
import ml.fasodocs.backend.dto.response.SignalementResponse;
import ml.fasodocs.backend.dto.response.SignalementSimpleResponse;
import ml.fasodocs.backend.entity.Signalement;
import ml.fasodocs.backend.service.SignalementService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * Contrôleur REST pour la gestion des signalements
 */
@Tag(name = "Signalements", description = "API pour la gestion des signalements")
@RestController
@RequestMapping("/signalements")
@CrossOrigin(origins = "*", maxAge = 3600)
public class SignalementController {

    @Autowired
    private SignalementService signalementService;

    /**
     * Crée un nouveau signalement
     */
    @Operation(summary = "Crée un nouveau signalement")
    @PostMapping
    public ResponseEntity<?> creerSignalement(@Valid @RequestBody SignalementRequest request) {
        MessageResponse response = signalementService.creerSignalement(request);
        if (response.isSuccess()) {
            return ResponseEntity.ok(response);
        } else {
            return ResponseEntity.badRequest().body(response);
        }
    }

    /**
     * Récupère tous les signalements du citoyen connecté
     */
    @Operation(summary = "Récupère tous les signalements du citoyen connecté")
    @GetMapping
    public ResponseEntity<List<SignalementSimpleResponse>> obtenirMesSignalements() {
        List<SignalementSimpleResponse> signalements = signalementService.obtenirMesSignalements();
        return ResponseEntity.ok(signalements);
    }

    /**
     * Récupère les types de signalements disponibles
     */
    @Operation(summary = "Récupère les types de signalements disponibles")
    @GetMapping("/types")
    public ResponseEntity<Signalement.TypeSignalement[]> obtenirTypesSignalements() {
        return ResponseEntity.ok(Signalement.TypeSignalement.values());
    }

    /**
     * Récupère un signalement spécifique
     */
    @Operation(summary = "Récupère un signalement spécifique")
    @GetMapping("/{id}")
    public ResponseEntity<?> obtenirSignalement(@PathVariable Long id) {
        SignalementResponse signalement = signalementService.obtenirSignalement(id);
        if (signalement != null) {
            return ResponseEntity.ok(signalement);
        } else {
            return ResponseEntity.notFound().build();
        }
    }

    /**
     * Modifie un signalement (seulement si moins de 15 minutes)
     */
    @Operation(summary = "Modifie un signalement (seulement si moins de 15 minutes)")
    @PutMapping("/{id}")
    public ResponseEntity<?> modifierSignalement(@PathVariable Long id, @Valid @RequestBody ModifierSignalementRequest request) {
        MessageResponse response = signalementService.modifierSignalement(id, request);
        if (response.isSuccess()) {
            return ResponseEntity.ok(response);
        } else {
            return ResponseEntity.badRequest().body(response);
        }
    }

    /**
     * Supprime un signalement (seulement si moins de 15 minutes)
     */
    @Operation(summary = "Supprime un signalement (seulement si moins de 15 minutes)")
    @DeleteMapping("/{id}")
    public ResponseEntity<?> supprimerSignalement(@PathVariable Long id) {
        MessageResponse response = signalementService.supprimerSignalement(id);
        if (response.isSuccess()) {
            return ResponseEntity.ok(response);
        } else {
            return ResponseEntity.badRequest().body(response);
        }
    }
}