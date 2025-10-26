package ml.fasodocs.backend.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import ml.fasodocs.backend.dto.request.ChatRequest;
import ml.fasodocs.backend.dto.request.TranslationRequest;
import ml.fasodocs.backend.dto.request.SpeakRequest;
import ml.fasodocs.backend.dto.response.ChatResponse;
import ml.fasodocs.backend.dto.response.TranslationResponse;
import ml.fasodocs.backend.dto.response.SpeakResponse;
import ml.fasodocs.backend.service.ChatbotService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

/**
 * Contrôleur REST pour le chatbot Djelia AI
 */
@Tag(name = "Chatbot Djelia", description = "API pour l'intégration avec Djelia AI - Chat, traduction et synthèse vocale")
@RestController
@RequestMapping("/chatbot")
@CrossOrigin(origins = "*", maxAge = 3600)
public class ChatbotController {

    @Autowired
    private ChatbotService chatbotService;

    /**
     * Chat simple avec Djelia AI
     */
    @Operation(summary = "Chat avec Djelia AI", description = "Permet de discuter avec Djelia AI dans différentes langues")
    @PostMapping("/chat")
    public ResponseEntity<ChatResponse> chat(@Valid @RequestBody ChatRequest request) {
        ChatResponse response = chatbotService.traiterChat(request);
        return ResponseEntity.ok(response);
    }

    /**
     * Chat avec synthèse vocale en bambara
     */
    @Operation(summary = "Chat avec synthèse vocale", description = "Chat avec Djelia AI + génération audio en bambara")
    @PostMapping("/chat-audio")
    public ResponseEntity<ChatResponse> chatAvecAudio(@Valid @RequestBody ChatRequest request) {
        ChatResponse response = chatbotService.chatAvecSynthèseVocale(request);
        return ResponseEntity.ok(response);
    }

    /**
     * Traduction de texte
     */
    @Operation(summary = "Traduction de texte", description = "Traduit un texte du français vers le bambara ou vice versa")
    @PostMapping("/translate")
    public ResponseEntity<TranslationResponse> traduire(@Valid @RequestBody TranslationRequest request) {
        TranslationResponse response = chatbotService.traduireTexte(request);
        return ResponseEntity.ok(response);
    }

    /**
     * Génération de synthèse vocale
     */
    @Operation(summary = "Synthèse vocale", description = "Génère un audio à partir d'un texte en bambara")
    @PostMapping("/speak")
    public ResponseEntity<SpeakResponse> parler(@Valid @RequestBody SpeakRequest request) {
        SpeakResponse response = chatbotService.genererSynthèseVocale(request);
        return ResponseEntity.ok(response);
    }

    /**
     * Traduction rapide français vers bambara
     */
    @Operation(summary = "Traduction FR->BM", description = "Traduction rapide du français vers le bambara")
    @PostMapping("/translate/fr-to-bm")
    public ResponseEntity<TranslationResponse> traduireFrVersBm(@RequestBody String texte) {
        TranslationRequest request = new TranslationRequest();
        request.setText(texte);
        request.setSourceLang("fr");
        request.setTargetLang("bm");
        
        TranslationResponse response = chatbotService.traduireTexte(request);
        return ResponseEntity.ok(response);
    }

    /**
     * Traduction rapide bambara vers français
     */
    @Operation(summary = "Traduction BM->FR", description = "Traduction rapide du bambara vers le français")
    @PostMapping("/translate/bm-to-fr")
    public ResponseEntity<TranslationResponse> traduireBmVersFr(@RequestBody String texte) {
        TranslationRequest request = new TranslationRequest();
        request.setText(texte);
        request.setSourceLang("bm");
        request.setTargetLang("fr");
        
        TranslationResponse response = chatbotService.traduireTexte(request);
        return ResponseEntity.ok(response);
    }

    /**
     * Vérification de la connectivité avec Djelia AI
     */
    @Operation(summary = "Vérification connectivité", description = "Vérifie si le service Djelia AI est accessible")
    @GetMapping("/health")
    public ResponseEntity<?> verifierConnectivité() {
        boolean isConnected = chatbotService.verifierConnectivité();
        
        if (isConnected) {
            return ResponseEntity.ok().body("{\"status\": \"OK\", \"message\": \"Djelia AI est accessible\"}");
        } else {
            return ResponseEntity.status(503).body("{\"status\": \"KO\", \"message\": \"Djelia AI n'est pas accessible\"}");
        }
    }

    /**
     * Lecture audio automatique - Traduit et lit en bambara un texte français
     */
    @Operation(summary = "Lecture audio automatique", description = "Traduit un texte français et le lit en bambara")
    @PostMapping("/read-audio")
    public ResponseEntity<SpeakResponse> lireAudio(@RequestBody String texteFrancais) {
        try {
            // 1. Traduire le texte français vers le bambara
            TranslationRequest translationRequest = new TranslationRequest();
            translationRequest.setText(texteFrancais);
            translationRequest.setSourceLang("fr");
            translationRequest.setTargetLang("bm");
            
            TranslationResponse translationResponse = chatbotService.traduireTexte(translationRequest);
            
            if (!translationResponse.isSuccess()) {
                return ResponseEntity.badRequest().body(
                    new SpeakResponse(texteFrancais, "fr", null, false, "Erreur de traduction")
                );
            }
            
            // 2. Générer l'audio en bambara
            SpeakRequest speakRequest = new SpeakRequest();
            speakRequest.setText(translationResponse.getTranslatedText());
            speakRequest.setSpeaker(1);
            
            SpeakResponse speakResponse = chatbotService.genererSynthèseVocale(speakRequest);
            
            // 3. Retourner la réponse avec le texte original et traduit
            SpeakResponse finalResponse = new SpeakResponse();
            finalResponse.setText(texteFrancais); // Texte original français
            finalResponse.setLanguage("fr");
            finalResponse.setAudioUrl(speakResponse.getAudioUrl());
            finalResponse.setSuccess(speakResponse.isSuccess());
            finalResponse.setErrorMessage(speakResponse.getErrorMessage());
            
            return ResponseEntity.ok(finalResponse);
            
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(
                new SpeakResponse(texteFrancais, "fr", null, false, "Erreur: " + e.getMessage())
            );
        }
    }

    /**
     * Lecture audio rapide - Version simplifiée pour l'icône audio
     */
    @Operation(summary = "Lecture audio rapide", description = "Version simplifiée pour l'icône audio du frontend")
    @PostMapping("/read-quick")
    public ResponseEntity<?> lireAudioRapide(@RequestBody String texteFrancais) {
        try {
            // Traduction rapide FR -> BM
            TranslationRequest translationRequest = new TranslationRequest();
            translationRequest.setText(texteFrancais);
            translationRequest.setSourceLang("fr");
            translationRequest.setTargetLang("bm");
            
            TranslationResponse translationResponse = chatbotService.traduireTexte(translationRequest);
            String texteBambara = translationResponse.getTranslatedText();
            
            // Génération audio
            SpeakRequest speakRequest = new SpeakRequest();
            speakRequest.setText(texteBambara);
            speakRequest.setSpeaker(1);
            
            SpeakResponse speakResponse = chatbotService.genererSynthèseVocale(speakRequest);
            String audioUrl = speakResponse.getAudioUrl();
            
            // Réponse simplifiée pour le frontend
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("audioUrl", audioUrl);
            response.put("originalText", texteFrancais);
            response.put("translatedText", texteBambara);
            
            return ResponseEntity.ok(response);
            
        } catch (Exception e) {
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("error", "Impossible de générer l'audio: " + e.getMessage());
            return ResponseEntity.badRequest().body(errorResponse);
        }
    }
}
