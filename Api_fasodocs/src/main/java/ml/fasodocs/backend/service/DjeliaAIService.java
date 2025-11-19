package ml.fasodocs.backend.service;

import ml.fasodocs.backend.dto.request.TextToSpeechRequest;
import ml.fasodocs.backend.dto.request.TranslateAndSpeakRequest;
import ml.fasodocs.backend.dto.request.TranslationRequest;
import ml.fasodocs.backend.dto.response.DjeliaCacheStatsResponse;
import ml.fasodocs.backend.dto.response.TextToSpeechResponse;
import ml.fasodocs.backend.dto.response.TranslateAndSpeakResponse;
import ml.fasodocs.backend.dto.response.TranslationResponse;
import ml.fasodocs.backend.exception.DjeliaAPIException;
import ml.fasodocs.backend.exception.DjeliaAuthenticationException;
import ml.fasodocs.backend.exception.DjeliaCacheException;
import ml.fasodocs.backend.exception.DjeliaQuotaExceededException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.HttpServerErrorException;
import org.springframework.web.client.RestTemplate;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.time.LocalDateTime;
import java.util.Base64;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicLong;

/**
 * Service pour interagir avec l'API Djelia AI
 * 
 * Fonctionnalités:
 * - Traduction Français -> Bambara
 * - Synthèse vocale (Text-to-Speech)
 * - Traduction + Synthèse vocale combinées
 * - Cache intelligent pour éviter les requêtes redondantes
 * 
 * @author FasoDocs Team
 */
@Service
public class DjeliaAIService {

    private static final Logger logger = LoggerFactory.getLogger(DjeliaAIService.class);

    private final RestTemplate restTemplate;

    @Autowired(required = false)
    private AudioService audioService;

    @Value("${djelia.ai.api.key}")
    private String apiKey;

    @Value("${djelia.ai.base.url}")
    private String baseUrl;

    @Value("${djelia.ai.enabled:true}")
    private boolean enabled;

    @Value("${djelia.ai.cache.enabled:true}")
    private boolean cacheEnabled;

    // Cache en mémoire pour les traductions
    private final Map<String, CachedTranslation> translationCache = new ConcurrentHashMap<>();
    
    // Statistiques du cache
    private final AtomicLong totalRequests = new AtomicLong(0);
    private final AtomicLong cacheHits = new AtomicLong(0);
    private final AtomicLong cacheMisses = new AtomicLong(0);

    public DjeliaAIService(RestTemplate restTemplate) {
        this.restTemplate = restTemplate;
    }

    /**
     * Traduit du français vers le bambara
     * 
     * @param request Requête de traduction
     * @return Réponse de traduction
     */
    public TranslationResponse translateToBambara(TranslationRequest request) {
        if (!enabled) {
            throw new DjeliaAPIException("Le service Djelia AI est désactivé");
        }

        totalRequests.incrementAndGet();
        logger.info("Traduction demandée: '{}' de {} vers {}", 
                request.getText(), request.getSourceLang(), request.getTargetLang());

        // Vérifier le cache
        if (cacheEnabled) {
            String cacheKey = generateCacheKey(request.getText(), request.getSourceLang(), request.getTargetLang());
            CachedTranslation cached = translationCache.get(cacheKey);
            
            if (cached != null && !cached.isExpired()) {
                cacheHits.incrementAndGet();
                logger.info("Traduction trouvée dans le cache");
                
                return TranslationResponse.builder()
                        .originalText(request.getText())
                        .translatedText(cached.translatedText)
                        .sourceLang(request.getSourceLang())
                        .targetLang(request.getTargetLang())
                        .fromCache(true)
                        .timestamp(LocalDateTime.now())
                        .build();
            }
        }

        cacheMisses.incrementAndGet();

        // Appeler le backend Flask pour la traduction
        try {
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);
            
            Map<String, Object> requestBody = Map.of(
                    "text", request.getText(),
                    "source", request.getSourceLang() != null ? request.getSourceLang() : "fra_Latn",
                    "target", request.getTargetLang() != null ? request.getTargetLang() : "bam_Latn"
            );

            HttpEntity<Map<String, Object>> entity = new HttpEntity<>(requestBody, headers);
            
            // Appeler Flask /api/translate pour obtenir uniquement le texte traduit
            String url = baseUrl + "/translate";
            logger.debug("🌐 Appel Flask Translation: POST {}", url);
            
            @SuppressWarnings("rawtypes")
            ResponseEntity<Map> response = restTemplate.exchange(
                    url,
                    HttpMethod.POST,
                    entity,
                    Map.class
            );

            if (response.getStatusCode() == HttpStatus.OK && response.getBody() != null) {
                @SuppressWarnings("unchecked")
                Map<String, Object> body = response.getBody();
                
                // Vérifier le champ success
                Boolean success = (Boolean) body.get("success");
                if (success == null || !success) {
                    String error = (String) body.get("error");
                    throw new DjeliaAPIException("Erreur traduction Flask: " + (error != null ? error : "Erreur inconnue"));
                }
                
                String translatedText = (String) body.get("translated_text");

                if (translatedText == null || translatedText.isEmpty()) {
                    throw new DjeliaAPIException("Réponse API invalide: texte traduit manquant");
                }

                // Mettre en cache
                if (cacheEnabled) {
                    String cacheKey = generateCacheKey(request.getText(), request.getSourceLang(), request.getTargetLang());
                    translationCache.put(cacheKey, new CachedTranslation(translatedText));
                    logger.debug("Traduction mise en cache");
                }

                logger.info("Traduction réussie: '{}'", translatedText);

                return TranslationResponse.builder()
                        .originalText(request.getText())
                        .translatedText(translatedText)
                        .sourceLang(request.getSourceLang())
                        .targetLang(request.getTargetLang())
                        .fromCache(false)
                        .timestamp(LocalDateTime.now())
                        .build();
            } else {
                throw new DjeliaAPIException("Réponse API invalide: " + response.getStatusCode());
            }

        } catch (HttpClientErrorException e) {
            handleHttpClientError(e);
            throw new DjeliaAPIException("Erreur inattendue", e);
        } catch (HttpServerErrorException e) {
            logger.error("Erreur serveur Djelia AI: {}", e.getMessage());
            throw new DjeliaAPIException("Le serveur Djelia AI rencontre des problèmes. Veuillez réessayer plus tard.", e);
        } catch (Exception e) {
            logger.error("Erreur lors de la traduction", e);
            throw new DjeliaAPIException("Erreur lors de la traduction: " + e.getMessage(), e);
        }
    }

    /**
     * Convertit du texte bambara en audio (Text-to-Speech)
     * 
     * @param request Requête de synthèse vocale
     * @return Réponse avec audio en Base64
     */
    public TextToSpeechResponse textToSpeech(TextToSpeechRequest request) {
        if (!enabled) {
            throw new DjeliaAPIException("Le service Djelia AI est désactivé");
        }

        logger.info("Synthèse vocale demandée pour: '{}'", request.getText());

        try {
            HttpHeaders headers = createHeaders();
            
            Map<String, Object> requestBody = Map.of(
                    "text", request.getText(),
                    "description", request.getDescription(),
                    "chunk_size", request.getChunkSize()
            );

            HttpEntity<Map<String, Object>> entity = new HttpEntity<>(requestBody, headers);
            
            String url = baseUrl + "/v2/tts";
            logger.debug("Appel API Djelia TTS: POST {}", url);
            
            // Récupérer la réponse en tant que tableau de bytes (audio)
            ResponseEntity<byte[]> response = restTemplate.exchange(
                    url,
                    HttpMethod.POST,
                    entity,
                    byte[].class
            );

            if (response.getStatusCode() == HttpStatus.OK && response.getBody() != null) {
                byte[] audioBytes = response.getBody();
                String audioBase64 = Base64.getEncoder().encodeToString(audioBytes);

                logger.info("Synthèse vocale réussie, taille audio: {} bytes", audioBytes.length);

                return TextToSpeechResponse.builder()
                        .text(request.getText())
                        .audioBase64(audioBase64)
                        .format("wav")
                        .voiceDescription(request.getDescription())
                        .build();
            } else {
                throw new DjeliaAPIException("Réponse API TTS invalide: " + response.getStatusCode());
            }

        } catch (HttpClientErrorException e) {
            handleHttpClientError(e);
            throw new DjeliaAPIException("Erreur inattendue", e);
        } catch (HttpServerErrorException e) {
            logger.error("Erreur serveur Djelia AI TTS: {}", e.getMessage());
            throw new DjeliaAPIException("Le serveur Djelia AI TTS rencontre des problèmes.", e);
        } catch (Exception e) {
            logger.error("Erreur lors de la synthèse vocale", e);
            throw new DjeliaAPIException("Erreur lors de la synthèse vocale: " + e.getMessage(), e);
        }
    }

    /**
     * Traduit du français vers le bambara ET génère l'audio
     * Fonction optimisée utilisant le backend Flask (SDK Djelia Python)
     * 
     * @param request Requête de traduction + synthèse vocale
     * @return Réponse avec traduction et audio
     */
    public TranslateAndSpeakResponse translateAndSpeak(TranslateAndSpeakRequest request) {
        logger.info("Traduction + Synthèse vocale demandée pour: '{}'", request.getText());

        // Vérifier si un ID de procédure est fourni pour le fallback audio
        Long procedureId = request.getProcedureId();
        
        try {
            // Appeler Flask /speak qui fait TRADUCTION + TTS
            // Flask traduit automatiquement FR → BM puis génère l'audio bambara
            TranslateAndSpeakFlaskResponse flaskResponse = callFlaskTranslateAndSpeak(request.getText());
            
            return TranslateAndSpeakResponse.builder()
                    .originalText(request.getText())
                    .translatedText(flaskResponse.getTranslatedText())
                    .audioBase64(flaskResponse.getAudioBase64())
                    .format("wav")
                    .fromCache(false)
                    .voiceDescription(request.getVoiceDescription())
                    .timestamp(LocalDateTime.now())
                    .build();
                    
        } catch (Exception e) {
            logger.error("❌ Erreur translateAndSpeak: {}", e.getMessage());
            
            // FALLBACK : Utiliser l'audio de la procédure si disponible
            if (procedureId != null && audioService != null) {
                logger.info("🔄 Tentative de fallback audio pour la procédure {}", procedureId);
                String fallbackAudio = audioService.getAudioBase64(procedureId);
                
                if (fallbackAudio != null) {
                    logger.info("✅ Audio de fallback trouvé pour la procédure {}", procedureId);
                    return TranslateAndSpeakResponse.builder()
                            .originalText(request.getText())
                            .translatedText(request.getText()) // Pas de traduction en fallback
                            .audioBase64(fallbackAudio)
                            .format("wav")
                            .fromCache(false)
                            .voiceDescription("Audio de fallback")
                            .timestamp(LocalDateTime.now())
                            .build();
                } else {
                    logger.warn("⚠️ Aucun audio de fallback disponible pour la procédure {}", procedureId);
                }
            }
            
            throw new DjeliaAPIException("Erreur lors de la traduction et synthèse: " + e.getMessage(), e);
        }
    }
    
    /**
     * Classe interne pour la réponse Flask avec traduction
     */
    private static class TranslateAndSpeakFlaskResponse {
        private String translatedText;
        private String audioBase64;
        
        public String getTranslatedText() { return translatedText; }
        public void setTranslatedText(String translatedText) { this.translatedText = translatedText; }
        public String getAudioBase64() { return audioBase64; }
        public void setAudioBase64(String audioBase64) { this.audioBase64 = audioBase64; }
    }
    
    /**
     * Appelle Flask pour traduction + TTS
     */
    private TranslateAndSpeakFlaskResponse callFlaskTranslateAndSpeak(String text) {
        try {
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);
            
            // Demander JSON avec texte traduit et audio en Base64
            Map<String, Object> requestBody = Map.of(
                "text", text,
                "speaker", 1,
                "return_json", true  // Demander JSON au lieu d'audio WAV
            );
            
            HttpEntity<Map<String, Object>> entity = new HttpEntity<>(requestBody, headers);
            
            String url = baseUrl + "/speak";
            logger.debug("🔊 Appel Flask TTS avec JSON: POST {}", url);
            
            @SuppressWarnings("rawtypes")
            ResponseEntity<Map> response = restTemplate.exchange(
                url,
                HttpMethod.POST,
                entity,
                Map.class
            );
            
            if (response.getStatusCode() == HttpStatus.OK && response.getBody() != null) {
                @SuppressWarnings("unchecked")
                Map<String, Object> body = response.getBody();
                
                // Vérifier le champ success
                Boolean success = (Boolean) body.get("success");
                if (success == null || !success) {
                    String error = (String) body.get("error");
                    throw new DjeliaAPIException("Erreur Flask TTS: " + (error != null ? error : "Erreur inconnue"));
                }
                
                // Extraire le texte traduit et l'audio
                String translatedText = (String) body.get("translated_text");
                String audioBase64 = (String) body.get("audio_base64");
                
                if (translatedText == null || translatedText.isEmpty()) {
                    logger.warn("⚠️ Texte traduit manquant dans la réponse Flask, utilisation du texte original");
                    translatedText = text;
                }
                
                if (audioBase64 == null || audioBase64.isEmpty()) {
                    throw new DjeliaAPIException("Audio Base64 manquant dans la réponse Flask");
                }
                
                logger.info("✅ Audio et traduction reçus de Flask: {} bytes, texte: '{}'", 
                           audioBase64.length(), translatedText.substring(0, Math.min(50, translatedText.length())));
                
                TranslateAndSpeakFlaskResponse flaskResponse = new TranslateAndSpeakFlaskResponse();
                flaskResponse.setTranslatedText(translatedText);
                flaskResponse.setAudioBase64(audioBase64);
                
                return flaskResponse;
                
            } else {
                throw new DjeliaAPIException("Erreur Flask TTS: " + response.getStatusCode());
            }
            
        } catch (Exception e) {
            logger.error("❌ Erreur Flask translate+speak: {}", e.getMessage());
            throw new DjeliaAPIException("Erreur backend Flask: " + e.getMessage(), e);
        }
    }
    
    /**
     * Appelle le backend Flask pour Text-to-Speech (retourne uniquement l'audio)
     * Méthode utilisée uniquement pour textToSpeech() qui n'a pas besoin du texte traduit
     */
    private byte[] callFlaskTTS(String text) {
        try {
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);
            
            Map<String, Object> requestBody = Map.of(
                "text", text,
                "speaker", 1,
                "return_json", false  // Retourner audio WAV (comportement par défaut)
            );
            
            HttpEntity<Map<String, Object>> entity = new HttpEntity<>(requestBody, headers);
            
            String url = baseUrl + "/speak";
            logger.debug("🔊 Appel Flask TTS (audio WAV): POST {}", url);
            
            ResponseEntity<byte[]> response = restTemplate.exchange(
                url,
                HttpMethod.POST,
                entity,
                byte[].class
            );
            
            if (response.getStatusCode() == HttpStatus.OK && response.getBody() != null) {
                logger.info("✅ Audio reçu de Flask: {} bytes", response.getBody().length);
                return response.getBody();
            } else {
                throw new DjeliaAPIException("Erreur Flask TTS: " + response.getStatusCode());
            }
            
        } catch (Exception e) {
            logger.error("❌ Erreur appel Flask TTS: {}", e.getMessage());
            throw new DjeliaAPIException("Backend Flask non disponible. Lancez: python backend_djelia.py", e);
        }
    }

    /**
     * Récupère les statistiques du cache
     */
    public DjeliaCacheStatsResponse getCacheStats() {
        long total = totalRequests.get();
        long hits = cacheHits.get();
        double hitRate = total > 0 ? (hits * 100.0) / total : 0.0;

        return DjeliaCacheStatsResponse.builder()
                .cacheSize(translationCache.size())
                .totalRequests(total)
                .cacheHits(hits)
                .cacheMisses(cacheMisses.get())
                .hitRate(Math.round(hitRate * 100.0) / 100.0)
                .build();
    }

    /**
     * Vide le cache de traductions
     */
    public void clearCache() {
        try {
            int size = translationCache.size();
            translationCache.clear();
            logger.info("Cache vidé: {} entrées supprimées", size);
        } catch (Exception e) {
            logger.error("Erreur lors du vidage du cache", e);
            throw new DjeliaCacheException("Impossible de vider le cache: " + e.getMessage(), e);
        }
    }

    /**
     * Crée les headers HTTP pour l'API Djelia
     */
    private HttpHeaders createHeaders() {
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        headers.setBearerAuth(apiKey);
        return headers;
    }

    /**
     * Génère une clé de cache unique basée sur le texte et les langues
     */
    private String generateCacheKey(String text, String sourceLang, String targetLang) {
        try {
            String input = text + "|" + sourceLang + "|" + targetLang;
            MessageDigest digest = MessageDigest.getInstance("MD5");
            byte[] hash = digest.digest(input.getBytes(StandardCharsets.UTF_8));
            
            StringBuilder hexString = new StringBuilder();
            for (byte b : hash) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) hexString.append('0');
                hexString.append(hex);
            }
            return hexString.toString();
        } catch (NoSuchAlgorithmException e) {
            // Fallback: utiliser le hashCode
            return String.valueOf((text + sourceLang + targetLang).hashCode());
        }
    }

    /**
     * Gère les erreurs HTTP client (4xx)
     */
    private void handleHttpClientError(HttpClientErrorException e) {
        logger.error("Erreur HTTP client: {} - {}", e.getStatusCode(), e.getMessage());
        
        switch (e.getStatusCode().value()) {
            case 401:
                throw new DjeliaAuthenticationException("Clé API Djelia invalide ou expirée");
            case 429:
                throw new DjeliaQuotaExceededException("Quota API Djelia dépassé. Veuillez réessayer plus tard.");
            case 400:
                throw new DjeliaAPIException("Requête invalide: " + e.getMessage(), 400);
            case 404:
                throw new DjeliaAPIException("Endpoint API non trouvé", 404);
            default:
                throw new DjeliaAPIException("Erreur API: " + e.getMessage(), e.getStatusCode().value());
        }
    }

    /**
     * Classe interne pour stocker les traductions en cache
     */
    private static class CachedTranslation {
        private final String translatedText;
        private final LocalDateTime createdAt;
        private final long ttlHours = 24; // Durée de vie: 24 heures

        public CachedTranslation(String translatedText) {
            this.translatedText = translatedText;
            this.createdAt = LocalDateTime.now();
        }

        public boolean isExpired() {
            return LocalDateTime.now().isAfter(createdAt.plusHours(ttlHours));
        }
    }
}
