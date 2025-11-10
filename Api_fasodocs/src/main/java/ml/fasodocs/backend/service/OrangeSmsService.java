package ml.fasodocs.backend.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import ml.fasodocs.backend.exception.SmsSendException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;

import java.nio.charset.StandardCharsets;
import java.util.Base64;
import java.util.HashMap;
import java.util.Map;
import java.util.Random;
import java.util.concurrent.Semaphore;
import java.util.concurrent.TimeUnit;

/**
 * Service pour l'envoi de SMS via l'API Orange SMS du Mali
 */
@Service
public class OrangeSmsService {

    private static final Logger logger = LoggerFactory.getLogger(OrangeSmsService.class);
    private final ObjectMapper objectMapper = new ObjectMapper();
    
    @Value("${orange.sms.enabled:false}")
    private boolean smsEnabled;
    
    @Value("${orange.sms.base.url}")
    private String baseUrl;
    
    @Value("${orange.sms.client.id}")
    private String clientId;
    
    @Value("${orange.sms.client.secret}")
    private String clientSecret;
    
    @Value("${orange.sms.application.id}")
    private String applicationId;
    
    @Value("${orange.sms.sender.address}")
    private String senderAddress;
    
    @Value("${orange.sms.sender.name:}")
    private String senderName;
    
    private String accessToken;
    private long tokenExpirationTime = 0;
    
    // Rate Limiting: Maximum 5 SMS par seconde (limite Orange)
    private final Semaphore rateLimiter = new Semaphore(5);
    private long lastResetTime = System.currentTimeMillis();
    
    private final RestTemplate restTemplate;
    
    public OrangeSmsService(RestTemplate restTemplate) {
        this.restTemplate = restTemplate;
    }
    
    /**
     * Génère un code de vérification à 4 chiffres
     */
    public String genererCodeVerification() {
        Random random = new Random();
        int code = 1000 + random.nextInt(9000);
        return String.valueOf(code);
    }
    
    /**
     * Vérifie si le service SMS Orange est correctement configuré
     */
    public boolean isOrangeSmsConfigured() {
        return clientId != null && clientSecret != null && applicationId != null && senderAddress != null;
    }
    
    /**
     * Authentifie avec l'API Orange et obtient un jeton d'accès
     */
    private boolean authenticate() {
        try {
            // Vérifier si le jeton est encore valide
            if (accessToken != null && System.currentTimeMillis() < tokenExpirationTime) {
                logger.debug("Using cached access token");
                return true;
            }
            
            logger.info("Authentification avec l'API Orange SMS");
            logger.debug("Using client ID: {}", clientId);
            logger.debug("Using client secret: {}", clientSecret);
            
            String authUrl = "https://api.orange.com/oauth/v3/token";
            
            // CORRECTION : Génération dynamique du header Basic avec encodage UTF-8 explicite
            String credentials = clientId + ":" + clientSecret;
            String encodedCredentials = Base64.getEncoder().encodeToString(
                credentials.getBytes(StandardCharsets.UTF_8));
            String authHeaderValue = "Basic " + encodedCredentials;
            
            logger.debug("Generated credentials string: {}", credentials);
            logger.debug("Encoded credentials: {}", encodedCredentials);
            logger.debug("Authorization header: {}", authHeaderValue);
            
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);
            headers.set("Authorization", authHeaderValue);
            
            MultiValueMap<String, String> body = new LinkedMultiValueMap<>();
            body.add("grant_type", "client_credentials");
            
            HttpEntity<MultiValueMap<String, String>> request = new HttpEntity<>(body, headers);
            
            logger.debug("Sending authentication request to: {}", authUrl);
            logger.debug("Request headers: {}", headers);
            logger.debug("Request body: {}", body);
            
            ResponseEntity<String> response = restTemplate.postForEntity(authUrl, request, String.class);
            
            logger.debug("Authentication response status: {}", response.getStatusCode());
            logger.debug("Authentication response body: {}", response.getBody());
            
            if (response.getStatusCode() == HttpStatus.OK) {
                JsonNode jsonNode = objectMapper.readTree(response.getBody());
                accessToken = jsonNode.get("access_token").asText();
                int expiresIn = jsonNode.get("expires_in").asInt();
                
                // Définir le temps d'expiration (en millisecondes)
                tokenExpirationTime = System.currentTimeMillis() + (expiresIn * 1000) - 60000; // -1 minute pour marge de sécurité
                
                logger.info("Authentification réussie avec l'API Orange SMS");
                logger.debug("Access token: {}", accessToken);
                logger.debug("Token expires in: {} seconds", expiresIn);
                return true;
            } else {
                logger.error("Erreur d'authentification Orange SMS: {}", response.getStatusCode());
                logger.error("Response body: {}", response.getBody());
                return false;
            }
        } catch (Exception e) {
            logger.error("Erreur lors de l'authentification avec Orange SMS: {}", e.getMessage(), e);
            return false;
        }
    }
    
    /**
     * Envoie un SMS de connexion avec le code de vérification
     */
    public void envoyerSmsConnexion(String telephone, String code) {
        if (!smsEnabled) {
            logger.warn("SMS Orange désactivé. Code généré: {}", code);
            return;
        }
        
        if (!isOrangeSmsConfigured()) {
            logger.error("Service Orange SMS mal configuré");
            return;
        }
        
        try {
            if (!authenticate()) {
                logger.error("Échec de l'authentification avec Orange SMS");
                throw new RuntimeException("Échec de l'authentification avec l'API Orange SMS. Vérifiez les credentials dans la configuration.");
            }
            
            String messageBody = String.format(
                "Votre code de vérification FasoDocs est: %s\n\nCe code expire dans 5 minutes.\n\nNe partagez jamais ce code avec personne.",
                code
            );
            
            sendSms(telephone, messageBody);
            
        } catch (Exception e) {
            logger.error("Erreur lors de l'envoi du SMS à {}: {}", telephone, e.getMessage(), e);
            throw new RuntimeException("Erreur lors de l'envoi du SMS: " + e.getMessage());
        }
    }
    
    /**
     * Envoie un SMS d'inscription avec le code de vérification
     */
    public void envoyerSmsInscription(String telephone, String code) {
        if (!smsEnabled) {
            logger.warn("SMS Orange désactivé. Code généré: {}", code);
            return;
        }
        
        if (!isOrangeSmsConfigured()) {
            logger.error("Service Orange SMS mal configuré");
            return;
        }
        
        try {
            if (!authenticate()) {
                logger.error("Échec de l'authentification avec Orange SMS");
                throw new RuntimeException("Échec de l'authentification avec l'API Orange SMS. Vérifiez les credentials dans la configuration.");
            }
            
            String messageBody = String.format(
                "Bienvenue sur FasoDocs!\n\nVotre code de vérification est: %s\n\nCe code expire dans 5 minutes.\n\nMerci de votre confiance!",
                code
            );
            
            sendSms(telephone, messageBody);
            
        } catch (Exception e) {
            logger.error("Erreur lors de l'envoi du SMS d'inscription à {}: {}", telephone, e.getMessage(), e);
            throw new RuntimeException("Erreur lors de l'envoi du SMS: " + e.getMessage());
        }
    }
    
    /**
     * Envoie un SMS de réinitialisation de mot de passe
     */
    public void envoyerSmsReinitialisation(String telephone, String code) {
        if (!smsEnabled) {
            logger.warn("SMS Orange désactivé. Code généré: {}", code);
            return;
        }
        
        if (!isOrangeSmsConfigured()) {
            logger.error("Service Orange SMS mal configuré");
            return;
        }
        
        try {
            if (!authenticate()) {
                logger.error("Échec de l'authentification avec Orange SMS");
                throw new RuntimeException("Échec de l'authentification avec l'API Orange SMS. Vérifiez les credentials dans la configuration.");
            }
            
            String messageBody = String.format(
                "Réinitialisation de mot de passe FasoDocs\n\nVotre code de vérification est: %s\n\nCe code expire dans 5 minutes.\n\nSi vous n'avez pas demandé cette réinitialisation, ignorez ce message.",
                code
            );
            
            sendSms(telephone, messageBody);
            
        } catch (Exception e) {
            logger.error("Erreur lors de l'envoi du SMS de réinitialisation à {}: {}", telephone, e.getMessage(), e);
            throw new RuntimeException("Erreur lors de l'envoi du SMS: " + e.getMessage());
        }
    }
    
    /**
     * Vérifie et applique le rate limiting (5 SMS/seconde maximum)
     */
    private void checkRateLimit() throws InterruptedException {
        synchronized (this) {
            long now = System.currentTimeMillis();
            
            // Reset le compteur chaque seconde
            if (now - lastResetTime >= 1000) {
                int toRelease = 5 - rateLimiter.availablePermits();
                if (toRelease > 0) {
                    rateLimiter.release(toRelease);
                }
                lastResetTime = now;
                logger.debug("Rate limiter reset - {} permits disponibles", rateLimiter.availablePermits());
            }
        }
        
        // Attend si la limite est atteinte (timeout de 5 secondes)
        if (!rateLimiter.tryAcquire(5, TimeUnit.SECONDS)) {
            logger.warn("Rate limit atteint (5 SMS/s), timeout après 5 secondes d'attente");
            throw new RuntimeException("Rate limit dépassé - Impossible d'acquérir un permit après 5 secondes");
        }
        
        logger.debug("Rate limit check OK - {} permits restants", rateLimiter.availablePermits());
    }
    
    /**
     * Envoie un SMS générique
     */
    private void sendSms(String telephone, String messageBody) {
        try {
            // IMPORTANT: Vérifier le rate limiting AVANT d'envoyer
            checkRateLimit();
            // CORRECTION: L'URL doit utiliser le senderAddress, pas le numéro du destinataire
            // Format de l'endpoint Orange SMS: /outbound/{senderAddress}/requests
            String smsUrl = baseUrl + "/outbound/" + senderAddress + "/requests";
            logger.debug("Preparing to send SMS to URL: {}", smsUrl);
            logger.debug("Message body: {}", messageBody);
            logger.debug("Sender address: {}", senderAddress);
            logger.debug("Application ID: {}", applicationId);
            logger.debug("Access token: {}", accessToken);
            
            // CORRECTION: Nettoyer le format du téléphone pour éviter les doubles +
            String cleanTelephone = telephone.startsWith("+") ? telephone : "+" + telephone;
            String destinationAddress = "tel:" + cleanTelephone;
            
            // Vérifier que le senderAddress est correctement formaté
            String cleanSenderAddress = senderAddress;
            if (!senderAddress.startsWith("tel:")) {
                cleanSenderAddress = "tel:" + (senderAddress.startsWith("+") ? senderAddress : "+" + senderAddress);
            }
            
            // Créer les en-têtes
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);
            headers.set("Authorization", "Bearer " + accessToken);
            headers.set("Accept", "application/json");
            
            // Log headers for debugging
            logger.debug("Request headers: Content-Type={}, Authorization=Bearer ***, Accept={}", 
                headers.getContentType(), headers.getAccept());
            
            // Créer le corps de la requête
            Map<String, Object> requestBody = new HashMap<>();
            Map<String, Object> outboundSMSMessageRequest = new HashMap<>();
            
            // Message
            Map<String, Object> outboundSMSTextMessage = new HashMap<>();
            outboundSMSTextMessage.put("message", messageBody);
            outboundSMSMessageRequest.put("outboundSMSTextMessage", outboundSMSTextMessage);
            
            // Destinataire - CORRECTION: utiliser le format nettoyé
            outboundSMSMessageRequest.put("address", destinationAddress);
            
            // Expéditeur - CORRECTION: utiliser le senderAddress nettoyé
            outboundSMSMessageRequest.put("senderAddress", cleanSenderAddress);
            
            // Application ID
            outboundSMSMessageRequest.put("clientCorrelator", applicationId);
            
            // Sender Name personnalisé (si configuré et enregistré chez Orange)
            if (senderName != null && !senderName.trim().isEmpty()) {
                try {
                    String encodedSenderName = java.net.URLEncoder.encode(senderName, "UTF-8");
                    outboundSMSMessageRequest.put("senderName", encodedSenderName);
                    logger.debug("Sender name personnalisé: {}", senderName);
                } catch (java.io.UnsupportedEncodingException e) {
                    logger.warn("Impossible d'encoder le sender name: {}", e.getMessage());
                }
            }
            
            requestBody.put("outboundSMSMessageRequest", outboundSMSMessageRequest);
            
            // Log request body for debugging
            logger.debug("Request body: {}", objectMapper.writeValueAsString(requestBody));
            
            HttpEntity<Map<String, Object>> request = new HttpEntity<>(requestBody, headers);
            
            logger.debug("Sending SMS request to: {}", smsUrl);
            
            ResponseEntity<String> response = restTemplate.postForEntity(smsUrl, request, String.class);
            
            logger.debug("SMS response status: {}", response.getStatusCode());
            logger.debug("SMS response body: {}", response.getBody());
            
            if (response.getStatusCode() == HttpStatus.CREATED || response.getStatusCode() == HttpStatus.OK) {
                logger.info("SMS envoyé avec succès à {}", telephone);
            } else {
                // Analyser l'erreur Orange pour fournir un message spécifique
                handleOrangeError(response, telephone);
            }
            
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt(); // Restaurer le statut d'interruption
            logger.error("Rate limiting interrompu pour {}: {}", telephone, e.getMessage());
            throw new RuntimeException("Envoi SMS interrompu par rate limiting", e);
        } catch (Exception e) {
            logger.error("Erreur lors de l'envoi du SMS à {}: {}", telephone, e.getMessage(), e);
            throw new RuntimeException("Erreur lors de l'envoi du SMS: " + e.getMessage());
        }
    }
    
    /**
     * Vérifie si le service SMS est activé
     */
    public boolean isSmsEnabled() {
        return smsEnabled;
    }
    
    /**
     * Retourne le nombre de SMS disponibles dans la fenêtre actuelle (pour monitoring)
     */
    public int getAvailablePermits() {
        return rateLimiter.availablePermits();
    }
    
    /**
     * Gère les erreurs spécifiques de l'API Orange SMS
     */
    private void handleOrangeError(ResponseEntity<String> response, String telephone) {
        int statusCode = response.getStatusCode().value();
        String responseBody = response.getBody();
        
        logger.error("Erreur Orange SMS pour {} - Status: {}", telephone, statusCode);
        logger.error("Réponse complète: {}", responseBody);
        
        try {
            JsonNode error = objectMapper.readTree(responseBody);
            
            // Extraire le code d'erreur Orange
            JsonNode requestError = error.path("requestError");
            JsonNode exception = requestError.path("serviceException").isMissingNode() 
                                    ? requestError.path("policyException")
                                    : requestError.path("serviceException");
            
            String messageId = exception.path("messageId").asText("UNKNOWN");
            String text = exception.path("text").asText("Erreur inconnue");
            
            logger.error("Code erreur Orange: {} - Message: {}", messageId, text);
            
            // Messages utilisateur selon le code d'erreur
            String userMessage = switch (messageId) {
                case "SVC0001" -> "Erreur du service SMS Orange";
                case "SVC0002", "SVC0003" -> "Format de message invalide";
                case "SVC0004" -> "Numéro de téléphone invalide: " + telephone;
                case "SVC0280" -> "Message trop long (maximum 160 caractères par SMS)";
                case "SVC0005" -> "ID de corrélation déjà utilisé (message déjà envoyé)";
                case "SVC1000" -> "Service temporairement indisponible, réessayez plus tard";
                case "POL0001" -> "Crédit SMS insuffisant ou restriction du compte";
                case "POL0003" -> "Trop de destinataires dans le message";
                case "POL0007" -> "Groupes imbriqués non autorisés";
                case "POL0010" -> "Information non disponible (délai de rétention expiré)";
                case "POL0011" -> "Type de média non supporté";
                default -> "Erreur d'envoi SMS: " + text;
            };
            
            throw new SmsSendException(userMessage, messageId, statusCode);
            
        } catch (SmsSendException e) {
            throw e; // Re-lancer l'exception personnalisée
        } catch (Exception e) {
            logger.error("Impossible de parser l'erreur Orange: {}", e.getMessage());
            throw new RuntimeException("Erreur d'envoi SMS (status " + statusCode + ")", e);
        }
    }
}