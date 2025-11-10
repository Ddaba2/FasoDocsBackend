package ml.fasodocs.backend.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import ml.fasodocs.backend.dto.request.TextToSpeechRequest;
import ml.fasodocs.backend.dto.request.TranslateAndSpeakRequest;
import ml.fasodocs.backend.dto.request.TranslationRequest;
import ml.fasodocs.backend.dto.response.*;
import ml.fasodocs.backend.service.DjeliaAIService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

/**
 * Contrôleur REST pour les fonctionnalités Djelia AI
 * 
 * Endpoints:
 * - POST /djelia/translate : Traduction français -> bambara
 * - POST /djelia/text-to-speech : Synthèse vocale
 * - POST /djelia/translate-and-speak : Traduction + Synthèse vocale
 * - GET /djelia/cache/stats : Statistiques du cache
 * - DELETE /djelia/cache/clear : Vider le cache
 * 
 * @author FasoDocs Team
 */
@RestController
@RequestMapping("/djelia")
@Tag(name = "Djelia AI", description = "API de traduction et synthèse vocale en Bambara")
public class DjeliaAIController {

    private static final Logger logger = LoggerFactory.getLogger(DjeliaAIController.class);
    
    private final DjeliaAIService djeliaService;

    public DjeliaAIController(DjeliaAIService djeliaService) {
        this.djeliaService = djeliaService;
    }

    /**
     * Traduit du français vers le bambara
     * 
     * @param request Requête de traduction
     * @return Texte traduit en bambara
     */
    @PostMapping("/translate")
    @Operation(
        summary = "Traduire du français vers le bambara",
        description = "Traduit un texte français en bambara en utilisant l'API Djelia AI. Les traductions sont mises en cache pour améliorer les performances."
    )
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Traduction réussie"),
        @ApiResponse(responseCode = "400", description = "Requête invalide"),
        @ApiResponse(responseCode = "401", description = "Clé API invalide"),
        @ApiResponse(responseCode = "429", description = "Quota API dépassé"),
        @ApiResponse(responseCode = "500", description = "Erreur serveur")
    })
    public ResponseEntity<TranslationResponse> translate(@Valid @RequestBody TranslationRequest request) {
        logger.info("Requête de traduction reçue: {}", request.getText());
        
        TranslationResponse response = djeliaService.translateToBambara(request);
        
        return ResponseEntity.ok(response);
    }

    /**
     * Convertit du texte bambara en audio (Text-to-Speech)
     * 
     * @param request Requête de synthèse vocale
     * @return Audio en Base64
     */
    @PostMapping("/text-to-speech")
    @Operation(
        summary = "Synthèse vocale (Text-to-Speech)",
        description = "Convertit du texte bambara en audio. L'audio est retourné en Base64 au format WAV."
    )
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Synthèse vocale réussie"),
        @ApiResponse(responseCode = "400", description = "Requête invalide"),
        @ApiResponse(responseCode = "401", description = "Clé API invalide"),
        @ApiResponse(responseCode = "500", description = "Erreur serveur")
    })
    public ResponseEntity<TextToSpeechResponse> textToSpeech(@Valid @RequestBody TextToSpeechRequest request) {
        logger.info("Requête de synthèse vocale reçue: {}", request.getText());
        
        TextToSpeechResponse response = djeliaService.textToSpeech(request);
        
        return ResponseEntity.ok(response);
    }

    /**
     * Traduit du français vers le bambara ET génère l'audio
     * Endpoint optimisé pour Flutter
     * 
     * @param request Requête de traduction + synthèse vocale
     * @return Traduction + Audio en Base64
     */
    @PostMapping("/translate-and-speak")
    @Operation(
        summary = "Traduction + Synthèse vocale (combo)",
        description = "Traduit du français vers le bambara et génère immédiatement l'audio. " +
                      "Endpoint optimisé pour les applications mobiles Flutter. " +
                      "L'audio est retourné en Base64 et peut être joué directement."
    )
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Traduction et synthèse vocale réussies"),
        @ApiResponse(responseCode = "400", description = "Requête invalide"),
        @ApiResponse(responseCode = "401", description = "Clé API invalide"),
        @ApiResponse(responseCode = "429", description = "Quota API dépassé"),
        @ApiResponse(responseCode = "500", description = "Erreur serveur")
    })
    public ResponseEntity<TranslateAndSpeakResponse> translateAndSpeak(
            @Valid @RequestBody TranslateAndSpeakRequest request) {
        
        logger.info("Requête de traduction + synthèse vocale reçue: {}", request.getText());
        
        TranslateAndSpeakResponse response = djeliaService.translateAndSpeak(request);
        
        return ResponseEntity.ok(response);
    }

    /**
     * Récupère les statistiques du cache de traductions
     * 
     * @return Statistiques du cache
     */
    @GetMapping("/cache/stats")
    @Operation(
        summary = "Statistiques du cache",
        description = "Retourne les statistiques d'utilisation du cache de traductions: " +
                      "taille, nombre de requêtes, taux de hit/miss."
    )
    @ApiResponse(responseCode = "200", description = "Statistiques récupérées")
    public ResponseEntity<DjeliaCacheStatsResponse> getCacheStats() {
        logger.info("Requête de statistiques du cache");
        
        DjeliaCacheStatsResponse stats = djeliaService.getCacheStats();
        
        return ResponseEntity.ok(stats);
    }

    /**
     * Vide le cache de traductions
     * Endpoint réservé aux administrateurs
     * 
     * @return Message de confirmation
     */
    @DeleteMapping("/cache/clear")
    @Operation(
        summary = "Vider le cache",
        description = "Supprime toutes les traductions du cache. " +
                      "Utile pour forcer le rafraîchissement ou libérer de la mémoire."
    )
    @ApiResponse(responseCode = "200", description = "Cache vidé avec succès")
    public ResponseEntity<MessageResponse> clearCache() {
        logger.info("Requête de vidage du cache");
        
        djeliaService.clearCache();
        
        return ResponseEntity.ok(
            MessageResponse.success("Cache Djelia vidé avec succès")
        );
    }

    /**
     * Endpoint alias pour le chatbot - Lecture rapide (Quick Read)
     * Compatible avec l'ancienne route /chatbot/read-quick
     * Redirige vers translate-and-speak
     * 
     * @param request Requête de traduction + synthèse vocale
     * @return Traduction + Audio en Base64
     */
    @PostMapping("/read-quick")
    @Operation(
        summary = "Lecture rapide (Quick Read)",
        description = "Traduit et génère l'audio en une seule requête. Alias pour translate-and-speak."
    )
    public ResponseEntity<TranslateAndSpeakResponse> readQuick(
            @Valid @RequestBody TranslateAndSpeakRequest request) {
        
        logger.info("Requête quick read reçue: {}", request.getText());
        
        // Utilise le même service que translate-and-speak
        TranslateAndSpeakResponse response = djeliaService.translateAndSpeak(request);
        
        return ResponseEntity.ok(response);
    }

    /**
     * Vérifie l'état du service Djelia AI
     * 
     * @return État du service
     */
    @GetMapping("/health")
    @Operation(
        summary = "Vérifier l'état du service",
        description = "Endpoint de health check pour vérifier que le service Djelia AI est opérationnel."
    )
    @ApiResponse(responseCode = "200", description = "Service opérationnel")
    public ResponseEntity<MessageResponse> healthCheck() {
        logger.debug("Health check Djelia AI");
        
        return ResponseEntity.ok(
            MessageResponse.success("Service Djelia AI opérationnel")
        );
    }
}
