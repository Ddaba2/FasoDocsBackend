package ml.fasodocs.backend.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import ml.fasodocs.backend.dto.request.QuizParticipationRequest;
import ml.fasodocs.backend.dto.response.*;
import ml.fasodocs.backend.dto.response.QuizProgressionUtilisateurResponse;
import ml.fasodocs.backend.service.QuizService;
import ml.fasodocs.backend.service.QuizGenerationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

/**
 * Contrôleur REST pour la gestion des quiz
 */
@Tag(name = "Quiz", description = "API pour les quiz quotidiens")
@RestController
@RequestMapping("/quiz")
@CrossOrigin(origins = "*", maxAge = 3600)
public class QuizController {

    @Autowired
    private QuizService quizService;

    @Autowired
    private QuizGenerationService quizGenerationService;

    /**
     * Récupère tous les quiz du jour avec leurs niveaux de déblocage
     */
    @Operation(summary = "Récupère tous les quiz quotidiens avec leurs niveaux")
    @GetMapping("/aujourdhui")
    public ResponseEntity<?> obtenirTousQuizAujourdhui(
            @RequestHeader(value = "Accept-Language", defaultValue = "fr") String langue) {
        try {
            String lang = langue != null && langue.startsWith("en") ? "en" : "fr";
            return ResponseEntity.ok(quizService.obtenirTousQuizAujourdhui(lang));
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                    .body(MessageResponse.error("Erreur: " + e.getMessage()));
        }
    }

    /**
     * Récupère TOUS les quiz disponibles pour un niveau spécifique
     */
    @Operation(summary = "Récupère tous les quiz disponibles pour un niveau (FACILE, MOYEN, DIFFICILE)")
    @GetMapping("/aujourdhui/{niveau}")
    public ResponseEntity<?> obtenirQuizParNiveau(
            @PathVariable String niveau,
            @RequestHeader(value = "Accept-Language", defaultValue = "fr") String langue) {
        try {
            String lang = langue != null && langue.startsWith("en") ? "en" : "fr";
            List<QuizJournalierResponse> responses = quizService.obtenirQuizAujourdhui(lang, niveau.toUpperCase());
            return ResponseEntity.ok(responses);
        } catch (Exception e) {
            // Si aucun quiz n'existe, essayer de générer tous les quiz automatiquement
            if (e.getMessage() != null && e.getMessage().contains("Aucun quiz")) {
                try {
                    quizGenerationService.genererTousLesQuiz();
                    // Réessayer après génération
                    String lang = langue != null && langue.startsWith("en") ? "en" : "fr";
                    List<QuizJournalierResponse> responses = quizService.obtenirQuizAujourdhui(lang, niveau.toUpperCase());
                    return ResponseEntity.ok(responses);
                } catch (Exception genEx) {
                    return ResponseEntity.badRequest()
                            .body(MessageResponse.error("Erreur lors de la génération des quiz: " + genEx.getMessage()));
                }
            }
            return ResponseEntity.badRequest()
                    .body(MessageResponse.error("Erreur: " + e.getMessage()));
        }
    }

    /**
     * Génère manuellement un quiz pour aujourd'hui (pour les tests)
     * Endpoint admin ou public pour faciliter les tests
     */
    @Operation(summary = "Génère manuellement un quiz pour aujourd'hui")
    @PostMapping("/generer")
    public ResponseEntity<?> genererQuizManuellement() {
        try {
            quizGenerationService.genererQuizQuotidien();
            return ResponseEntity.ok(MessageResponse.success("Quiz généré avec succès pour aujourd'hui"));
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                    .body(MessageResponse.error("Erreur lors de la génération: " + e.getMessage()));
        }
    }

    /**
     * Endpoint de diagnostic pour vérifier l'état de déblocage des niveaux
     */
    @Operation(summary = "Diagnostic: Vérifie l'état de déblocage des niveaux pour l'utilisateur")
    @GetMapping("/diagnostic/deblocage")
    public ResponseEntity<?> diagnosticDeblocage() {
        try {
            Map<String, Object> diagnostic = quizService.diagnosticDeblocage();
            return ResponseEntity.ok(diagnostic);
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                    .body(MessageResponse.error("Erreur: " + e.getMessage()));
        }
    }

    /**
     * Soumet les réponses d'un utilisateur à un quiz
     */
    @Operation(summary = "Soumet les réponses d'un quiz")
    @PostMapping("/participer")
    public ResponseEntity<?> participerAuQuiz(@Valid @RequestBody QuizParticipationRequest request) {
        try {
            QuizParticipationResponse response = quizService.participerAuQuiz(request);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                    .body(MessageResponse.error("Erreur: " + e.getMessage()));
        }
    }

    /**
     * Récupère les statistiques de l'utilisateur connecté
     */
    @Operation(summary = "Récupère les statistiques de quiz de l'utilisateur")
    @GetMapping("/statistiques")
    public ResponseEntity<QuizStatistiqueResponse> obtenirStatistiques() {
        return ResponseEntity.ok(quizService.obtenirStatistiques());
    }

    /**
     * Récupère la progression de l'utilisateur connecté pour tous les niveaux
     */
    @Operation(summary = "Récupère la progression de l'utilisateur dans tous les niveaux de quiz")
    @GetMapping("/progression")
    public ResponseEntity<QuizProgressionUtilisateurResponse> obtenirProgression() {
        return ResponseEntity.ok(quizService.obtenirProgression());
    }

    /**
     * Récupère le classement hebdomadaire
     */
    @Operation(summary = "Récupère le classement hebdomadaire")
    @GetMapping("/classement/hebdomadaire")
    public ResponseEntity<ClassementResponse> obtenirClassementHebdomadaire() {
        return ResponseEntity.ok(quizService.obtenirClassementHebdomadaire());
    }

    /**
     * Récupère le classement mensuel
     */
    @Operation(summary = "Récupère le classement mensuel")
    @GetMapping("/classement/mensuel")
    public ResponseEntity<ClassementResponse> obtenirClassementMensuel() {
        return ResponseEntity.ok(quizService.obtenirClassementMensuel());
    }
}

