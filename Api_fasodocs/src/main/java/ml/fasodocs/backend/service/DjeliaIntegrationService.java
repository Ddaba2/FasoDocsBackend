package ml.fasodocs.backend.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.util.HashMap;
import java.util.Map;

/**
 * Service d'intégration avec l'API Djelia AI
 */
@Service
public class DjeliaIntegrationService {

    private static final Logger logger = LoggerFactory.getLogger(DjeliaIntegrationService.class);

    @Value("${djelia.backend.url:http://localhost:5000}")
    private String djeliaBackendUrl;

    @Value("${djelia.api.key:}")
    private String djeliaApiKey;

    private final RestTemplate restTemplate;
    private final ObjectMapper objectMapper;

    public DjeliaIntegrationService() {
        this.restTemplate = new RestTemplate();
        this.objectMapper = new ObjectMapper();
    }

    /**
     * Traduit un texte du français vers le bambara ou vice versa
     */
    public String traduireTexte(String texte, String langueSource, String langueCible) {
        try {
            logger.info("🔄 Traduction: {} -> {} : {}", langueSource, langueCible, texte);

            String url = djeliaBackendUrl + "/translate";
            
            Map<String, Object> requestBody = new HashMap<>();
            requestBody.put("text", texte);
            requestBody.put("source_lang", langueSource);
            requestBody.put("target_lang", langueCible);

            HttpHeaders headers = createHeaders();
            HttpEntity<Map<String, Object>> request = new HttpEntity<>(requestBody, headers);

            ResponseEntity<Map> response = restTemplate.exchange(
                url, HttpMethod.POST, request, Map.class);

            if (response.getStatusCode() == HttpStatus.OK && response.getBody() != null) {
                String translation = (String) response.getBody().get("translation");
                logger.info("✅ Traduction réussie: {}", translation);
                return translation;
            } else {
                logger.error("❌ Erreur traduction: {}", response.getStatusCode());
                return texte; // Retourne le texte original en cas d'erreur
            }

        } catch (Exception e) {
            logger.error("❌ Erreur lors de la traduction: {}", e.getMessage());
            return texte; // Retourne le texte original en cas d'erreur
        }
    }

    /**
     * Génère une synthèse vocale en bambara
     */
    public String genererSynthèseVocale(String texte, String langue) {
        try {
            logger.info("🎤 Génération synthèse vocale: {} en {}", texte, langue);

            String url = djeliaBackendUrl + "/api/speak";
            
            Map<String, Object> requestBody = new HashMap<>();
            requestBody.put("text", texte);
            requestBody.put("language", langue);
            requestBody.put("speaker", 1); // Locuteur par défaut

            HttpHeaders headers = createHeaders();
            HttpEntity<Map<String, Object>> request = new HttpEntity<>(requestBody, headers);

            ResponseEntity<String> response = restTemplate.exchange(
                url, HttpMethod.POST, request, String.class);

            if (response.getStatusCode() == HttpStatus.OK) {
                // Le backend retourne maintenant un fichier audio WAV
                // On retourne une URL pour indiquer que l'audio est généré
                String audioUrl = djeliaBackendUrl + "/api/speak";
                logger.info("✅ Synthèse vocale générée: {}", audioUrl);
                return audioUrl;
            } else {
                logger.error("❌ Erreur synthèse vocale: {}", response.getStatusCode());
                return null;
            }

        } catch (Exception e) {
            logger.error("❌ Erreur lors de la synthèse vocale: {}", e.getMessage());
            return null;
        }
    }

    /**
     * Chat avec Djelia AI
     * Le backend utilise maintenant /api/conversation pour le chat complet
     */
    public String chatAvecDjelia(String message, String langue) {
        try {
            logger.info("💬 Chat Djelia: {} en {}", message, langue);

            // Le nouveau backend utilise /api/conversation qui gère STT + Chat + TTS
            // Pour une réponse texte simple, on peut utiliser /chat (si disponible)
            // Sinon, on traduit le message et retourne une réponse de base
            
            String url = djeliaBackendUrl + "/chat";
            
            Map<String, Object> requestBody = new HashMap<>();
            requestBody.put("message", message);
            requestBody.put("language", langue);
            requestBody.put("context", "fasodocs");

            HttpHeaders headers = createHeaders();
            HttpEntity<Map<String, Object>> request = new HttpEntity<>(requestBody, headers);

            ResponseEntity<Map> response = restTemplate.exchange(
                url, HttpMethod.POST, request, Map.class);

            if (response.getStatusCode() == HttpStatus.OK && response.getBody() != null) {
                String responseText = (String) response.getBody().get("response");
                logger.info("✅ Réponse Djelia: {}", responseText);
                return responseText;
            } else {
                logger.error("❌ Erreur chat Djelia: {}", response.getStatusCode());
                return "Désolé, je ne peux pas répondre pour le moment.";
            }

        } catch (Exception e) {
            logger.error("❌ Erreur lors du chat avec Djelia: {}", e.getMessage());
            return "Désolé, je ne peux pas répondre pour le moment.";
        }
    }

    /**
     * Vérifie la connectivité avec le backend Djelia
     */
    public boolean verifierConnexion() {
        try {
            String url = djeliaBackendUrl + "/health";
            HttpHeaders headers = createHeaders();
            HttpEntity<String> request = new HttpEntity<>(headers);

            ResponseEntity<Map> response = restTemplate.exchange(
                url, HttpMethod.GET, request, Map.class);

            boolean isConnected = response.getStatusCode() == HttpStatus.OK;
            logger.info("🔍 Connexion Djelia: {}", isConnected ? "✅ OK" : "❌ KO");
            return isConnected;

        } catch (Exception e) {
            logger.error("❌ Impossible de se connecter à Djelia: {}", e.getMessage());
            return false;
        }
    }

    /**
     * Crée les headers HTTP avec l'API key
     */
    private HttpHeaders createHeaders() {
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        
        if (djeliaApiKey != null && !djeliaApiKey.isEmpty()) {
            headers.set("Authorization", "Bearer " + djeliaApiKey);
        }
        
        return headers;
    }
}
