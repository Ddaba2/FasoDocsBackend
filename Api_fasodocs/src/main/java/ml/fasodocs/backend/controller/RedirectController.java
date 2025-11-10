package ml.fasodocs.backend.controller;

import io.swagger.v3.oas.annotations.Hidden;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import ml.fasodocs.backend.entity.Signalement;
import org.springframework.http.ResponseEntity;

/**
 * Contrôleur pour gérer les redirections d'anciens endpoints
 */
@RestController
@Hidden // Cacher ce contrôleur dans la documentation Swagger
public class RedirectController {

    /**
     * Redirige l'ancien endpoint /signalement-types vers le nouvel endpoint
     * pour assurer la compatibilité avec les versions antérieures du frontend
     */
    @GetMapping("/signalement-types")
    public ResponseEntity<Signalement.TypeSignalement[]> getSignalementTypes() {
        return ResponseEntity.ok(Signalement.TypeSignalement.values());
    }
}