package ml.fasodocs.backend.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import ml.fasodocs.backend.dto.request.SousCategorieRequest;
import ml.fasodocs.backend.dto.response.MessageResponse;
import ml.fasodocs.backend.dto.response.SousCategorieResponse;
import ml.fasodocs.backend.service.SousCategorieService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * Contrôleur REST pour la gestion des sous-catégories
 */
@Tag(name = "Sous-Catégories", description = "API pour la gestion des sous-catégories")
@RestController
@RequestMapping("/sous-categories")
@CrossOrigin(origins = "*", maxAge = 3600)
public class SousCategorieController {

    @Autowired
    private SousCategorieService sousCategorieService;

    /**
     * Récupère toutes les sous-catégories
     */
    @Operation(summary = "Récupère toutes les sous-catégories")
    @GetMapping
    public ResponseEntity<List<SousCategorieResponse>> obtenirToutesSousCategories() {
        return ResponseEntity.ok(sousCategorieService.obtenirToutesSousCategories());
    }

    /**
     * Récupère une sous-catégorie par ID
     */
    @Operation(summary = "Récupère une sous-catégorie par son ID")
    @GetMapping("/{id}")
    public ResponseEntity<?> obtenirSousCategorieParId(@PathVariable Long id) {
        try {
            SousCategorieResponse response = sousCategorieService.obtenirSousCategorieParId(id);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                    .body(MessageResponse.error("Sous-catégorie non trouvée: " + e.getMessage()));
        }
    }

    /**
     * Récupère les sous-catégories d'une catégorie
     */
    @Operation(summary = "Récupère les sous-catégories d'une catégorie")
    @GetMapping("/categorie/{categorieId}")
    public ResponseEntity<List<SousCategorieResponse>> obtenirSousCategoriesParCategorie(@PathVariable Long categorieId) {
        return ResponseEntity.ok(sousCategorieService.obtenirSousCategoriesParCategorie(categorieId));
    }

    /**
     * Crée une nouvelle sous-catégorie (Admin uniquement)
     */
    @Operation(summary = "Crée une nouvelle sous-catégorie (Admin)")
    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping
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
     * Met à jour une sous-catégorie (Admin uniquement)
     */
    @Operation(summary = "Met à jour une sous-catégorie (Admin)")
    @PreAuthorize("hasRole('ADMIN')")
    @PutMapping("/{id}")
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
     * Supprime une sous-catégorie (Admin uniquement)
     */
    @Operation(summary = "Supprime une sous-catégorie (Admin)")
    @PreAuthorize("hasRole('ADMIN')")
    @DeleteMapping("/{id}")
    public ResponseEntity<?> supprimerSousCategorie(@PathVariable Long id) {
        try {
            MessageResponse response = sousCategorieService.supprimerSousCategorie(id);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                    .body(MessageResponse.error("Erreur lors de la suppression: " + e.getMessage()));
        }
    }
}
