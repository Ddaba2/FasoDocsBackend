package ml.fasodocs.backend.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import ml.fasodocs.backend.dto.request.CategorieRequest;
import ml.fasodocs.backend.dto.response.CategorieResponse;
import ml.fasodocs.backend.dto.response.MessageResponse;
import ml.fasodocs.backend.service.CategorieService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * Contrôleur REST pour la gestion des catégories
 */
@Tag(name = "Catégories", description = "API pour la gestion des catégories")
@RestController
@RequestMapping("/categories")
@CrossOrigin(origins = "*", maxAge = 3600)
public class CategorieController {

    @Autowired
    private CategorieService categorieService;

    /**
     * Récupère toutes les catégories
     */
    @Operation(summary = "Récupère toutes les catégories")
    @GetMapping
    public ResponseEntity<List<CategorieResponse>> obtenirToutesCategories() {
        return ResponseEntity.ok(categorieService.obtenirToutesCategories());
    }

    /**
     * Récupère une catégorie par ID
     */
    @Operation(summary = "Récupère une catégorie par son ID")
    @GetMapping("/{id}")
    public ResponseEntity<?> obtenirCategorieParId(@PathVariable Long id) {
        try {
            CategorieResponse response = categorieService.obtenirCategorieParId(id);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                    .body(MessageResponse.error("Catégorie non trouvée: " + e.getMessage()));
        }
    }

    /**
     * Crée une nouvelle catégorie (Admin uniquement)
     */
    @Operation(summary = "Crée une nouvelle catégorie (Admin)")
    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping
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
     * Met à jour une catégorie (Admin uniquement)
     */
    @Operation(summary = "Met à jour une catégorie (Admin)")
    @PreAuthorize("hasRole('ADMIN')")
    @PutMapping("/{id}")
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
     * Supprime une catégorie (Admin uniquement)
     */
    @Operation(summary = "Supprime une catégorie (Admin)")
    @PreAuthorize("hasRole('ADMIN')")
    @DeleteMapping("/{id}")
    public ResponseEntity<?> supprimerCategorie(@PathVariable Long id) {
        try {
            MessageResponse response = categorieService.supprimerCategorie(id);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                    .body(MessageResponse.error("Erreur lors de la suppression: " + e.getMessage()));
        }
    }
}
