package ml.fasodocs.backend.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import ml.fasodocs.backend.dto.request.TranslateAndSpeakRequest;
import ml.fasodocs.backend.dto.response.TranslateAndSpeakResponse;
import ml.fasodocs.backend.service.DjeliaAIService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

/**
 * Contrôleur REST pour les fonctionnalités Chatbot / Lecture rapide
 * Alias vers DjeliaAIController pour compatibilité avec le frontend
 */
@RestController
@RequestMapping("/chatbot")
@Tag(name = "Chatbot", description = "Endpoints de compatibilité pour la lecture rapide")
@CrossOrigin(origins = "*", maxAge = 3600)
public class ChatbotController {

    private static final Logger logger = LoggerFactory.getLogger(ChatbotController.class);
    
    private final DjeliaAIService djeliaService;

    public ChatbotController(DjeliaAIService djeliaService) {
        this.djeliaService = djeliaService;
    }

    /**
     * Lecture rapide d'une procédure avec traduction et audio
     * Compatible avec le frontend Flutter/Angular
     * 
     * @param request Requête contenant le texte à traduire et lire
     * @return Traduction en bambara + Audio en Base64
     */
    @PostMapping("/read-quick")
    @Operation(
        summary = "Lecture rapide avec traduction et audio",
        description = "Traduit du français vers le bambara et génère l'audio en une seule requête. " +
                      "Endpoint de compatibilité pour le frontend (alias de /djelia/translate-and-speak)."
    )
    public ResponseEntity<TranslateAndSpeakResponse> readQuick(
            @Valid @RequestBody TranslateAndSpeakRequest request) {
        
        logger.info("========================================");
        logger.info("🎤 Requête chatbot/read-quick REÇUE");
        logger.info("📝 Text: '{}'", request.getText());
        logger.info("🔊 VoiceDescription: '{}'", request.getVoiceDescription());
        logger.info("📊 ChunkSize: {}", request.getChunkSize());
        logger.info("========================================");
        
        try {
            // Déléguer à DjeliaAIService
            TranslateAndSpeakResponse response = djeliaService.translateAndSpeak(request);
            
            logger.info("✅ Réponse read-quick: traduction='{}', audio={} bytes", 
                        response.getTranslatedText(), 
                        response.getAudioBase64() != null ? response.getAudioBase64().length() : 0);
            
            return ResponseEntity.ok(response);
            
        } catch (Exception e) {
            logger.error("❌ ERREUR dans chatbot/read-quick: {}", e.getMessage(), e);
            throw e;
        }
    }
}
