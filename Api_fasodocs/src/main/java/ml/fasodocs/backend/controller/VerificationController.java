package ml.fasodocs.backend.controller;

import ml.fasodocs.backend.service.VerificationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

/**
 * Contrôleur pour les vérifications de complétude des procédures
 */
@RestController
@RequestMapping("/verification")
public class VerificationController {

    @Autowired
    private VerificationService verificationService;

    @GetMapping("/rapport-complet")
    public ResponseEntity<Map<String, Object>> getRapportComplet() {
        return ResponseEntity.ok(verificationService.getRapportComplet());
    }

    @GetMapping("/resume-global")
    public ResponseEntity<Map<String, Object>> getResumeGlobal() {
        return ResponseEntity.ok(verificationService.getResumeGlobal());
    }

    @GetMapping("/statistiques-par-categorie")
    public ResponseEntity<?> getStatistiquesParCategorie() {
        return ResponseEntity.ok(verificationService.getStatistiquesParCategorie());
    }

    @GetMapping("/sous-categories-incompletes")
    public ResponseEntity<?> getSousCategoriesIncompletes() {
        return ResponseEntity.ok(verificationService.getSousCategoriesIncompletes());
    }

    @GetMapping("/procedures-incompletes")
    public ResponseEntity<?> getProceduresIncompletes() {
        return ResponseEntity.ok(verificationService.getProceduresIncompletes());
    }

    @GetMapping("/sous-categories-sans-procedure")
    public ResponseEntity<?> getSousCategoriesSansProcedure() {
        return ResponseEntity.ok(verificationService.getSousCategoriesSansProcedure());
    }
}

