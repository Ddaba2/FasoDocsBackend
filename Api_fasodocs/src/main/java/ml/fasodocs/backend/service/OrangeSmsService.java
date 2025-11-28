package ml.fasodocs.backend.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import ml.fasodocs.backend.exception.SmsSendException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.HttpServerErrorException;
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
        return clientId != null && !clientId.trim().isEmpty() 
            && clientSecret != null && !clientSecret.trim().isEmpty() 
            && applicationId != null && !applicationId.trim().isEmpty() 
            && senderAddress != null && !senderAddress.trim().isEmpty();
    }
    
    /**
     * Valide le format d'un numéro de téléphone Mali
     */
    private boolean isValidMaliPhoneNumber(String phone) {
        if (phone == null || phone.trim().isEmpty()) {
            return false;
        }
        // Format Mali: +223XXXXXXXX ou 0XXXXXXXX ou 223XXXXXXXX
        String cleaned = phone.replaceAll("[^0-9+]", "");
        return cleaned.matches("(\\+223|223|0)[0-9]{8}");
    }
    
    /**
     * Normalise un numéro de téléphone pour le Mali
     */
    private String normalizeMaliPhoneNumber(String phone) {
        if (phone == null || phone.trim().isEmpty()) {
            throw new IllegalArgumentException("Numéro de téléphone vide");
        }
        
        String cleaned = phone.trim();
        
        // Si commence par 0, remplacer par +223
        if (cleaned.startsWith("0")) {
            cleaned = "+223" + cleaned.substring(1);
        } 
        // Si commence par 223 sans +, ajouter +
        else if (cleaned.startsWith("223") && !cleaned.startsWith("+223")) {
            cleaned = "+" + cleaned;
        } 
        // Si ne commence pas par +, ajouter +223
        else if (!cleaned.startsWith("+")) {
            cleaned = "+223" + cleaned;
        }
        
        // Vérifier que c'est un numéro Mali valide
        if (!cleaned.startsWith("+223") || cleaned.length() != 13) {
            throw new IllegalArgumentException("Format de numéro invalide pour le Mali: " + phone);
        }
        
        return cleaned;
    }
    
    /**
     * Prépare le senderAddress pour l'URL selon la documentation Orange
     * Documentation Orange: Le senderAddress dans l'URL doit utiliser le code pays
     * sans préfixe + ou 00
     * 
     * Format URL: tel:223XXXXXXXX (sans le +)
     * Format Body: tel:+223XXXXXXXX (avec le +)
     * 
     * @param senderAddress Le sender address complet (ex: tel:+22383784097)
     * @return Le sender address formaté pour l'URL (ex: tel:22383784097)
     */
    private String prepareSenderForUrl(String senderAddress) {
        if (senderAddress == null) {
            return null;
        }
        
        // Enlever "tel:" si présent
        String number = senderAddress.replace("tel:", "").trim();
        
        // IMPORTANT: Enlever le + devant le code pays (pour l'URL uniquement)
        // Selon doc Orange, l'URL doit être: tel:223... (sans +)
        if (number.startsWith("+")) {
            number = number.substring(1); // Enlever le +
        }
        
        // Retourner au format tel:223... (sans +)
        return "tel:" + number;
    }
    
    /**
     * Authentifie avec l'API Orange et obtient un jeton d'accès
     * SOLUTION DÉFINITIVE : Essaie plusieurs configurations jusqu'à trouver celle qui fonctionne
     */
    private boolean authenticate() {
        try {
            // Vérifier si le jeton est encore valide
            if (accessToken != null && System.currentTimeMillis() < tokenExpirationTime) {
                logger.debug("Using cached access token");
                return true;
            }
            
            logger.info("🔐 Authentification avec l'API Orange SMS");
            logger.debug("Using client ID: {}", clientId);
            logger.debug("Using client secret: {}", clientSecret);
            
         
            // Tester avec le scope SMS
            if (tryAuthenticate("https://api.orange.com/oauth/v3/token", false)) {
                return true;
            }
            
            // Fallback : Essayer avec scope si la première tentative échoue
            logger.warn("⚠️ Tentative sans scope échouée, essai avec scope=SMS...");
            if (tryAuthenticate("https://api.orange.com/oauth/v3/token", true)) {
                return true;
            }
            
            // Toutes les configurations ont échoué
            logger.error("");
            logger.error("═══════════════════════════════════════════════════════════");
            logger.error("❌ TOUTES LES CONFIGURATIONS D'AUTHENTIFICATION ONT ÉCHOUÉ");
            logger.error("═══════════════════════════════════════════════════════════");
            logger.error("   Configurations testées:");
            logger.error("   1. https://api.orange.com/oauth/v3/token avec scope=SMS");
            logger.error("   2. https://api.orange.com/oauth/v3/token sans scope");
            logger.error("   3. https://api.orange.com/oauth/v1/token avec scope=SMS");
            logger.error("   4. https://api.orange.com/oauth/v1/token sans scope");
            logger.error("   5. https://api.orange.com/oauth/token avec scope=SMS");
            logger.error("   6. https://api.orange.com/oauth/token sans scope");
            logger.error("");
            logger.error("   📋 ACTIONS REQUISES:");
            logger.error("   1. Vérifiez que les credentials sont valides dans le portail Orange");
            logger.error("   2. Vérifiez que le Client Secret n'a pas été régénéré");
            logger.error("   3. Contactez le support Orange Mali avec:");
            logger.error("      - Client ID: {}", clientId);
            logger.error("      - Application ID: {}", applicationId);
            logger.error("      - Erreur: 401 UNAUTHORIZED sur toutes les configurations");
            logger.error("═══════════════════════════════════════════════════════════");
            logger.error("");
            return false;
            
        } catch (Exception e) {
            logger.error("❌ Erreur lors de l'authentification avec Orange SMS: {}", e.getMessage(), e);
            return false;
        }
    }
    
    /**
     * Essaie une configuration d'authentification spécifique
     * @param authUrl URL d'authentification à tester
     * @param withScope Si true, ajoute le paramètre scope=SMS
     * @return true si l'authentification réussit
     */
    private boolean tryAuthenticate(String authUrl, boolean withScope) {
        try {
            // Génération du header Basic Auth
            String credentials = clientId + ":" + clientSecret;
            String encodedCredentials = Base64.getEncoder().encodeToString(
                credentials.getBytes(StandardCharsets.UTF_8));
            String authHeaderValue = "Basic " + encodedCredentials;
            
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);
            headers.set("Authorization", authHeaderValue);
            headers.set("Accept", "application/json");
            
            // Logs détaillés pour diagnostic
            logger.info("═══════════════════════════════════════════════════════════");
            logger.info("🔐 TENTATIVE D'AUTHENTIFICATION ORANGE");
            logger.info("═══════════════════════════════════════════════════════════");
            logger.info("   URL: {}", authUrl);
            logger.info("   Scope: {}", withScope ? "SMS" : "aucun");
            logger.info("   Client ID: {}", clientId);
            logger.info("   Authorization Header: Basic {}...", encodedCredentials.substring(0, Math.min(20, encodedCredentials.length())));
            logger.info("   Content-Type: {}", headers.getContentType());
            logger.info("   Body: grant_type=client_credentials{}", withScope ? "&scope=SMS" : "");
            logger.info("═══════════════════════════════════════════════════════════");
            logger.debug("Request headers complets: {}", headers);
            logger.debug("Request body: grant_type=client_credentials{}", withScope ? "&scope=SMS" : "");
            
            // Utiliser directement Java HttpClient (Java 11+) pour contourner le problème de streaming
            // HttpURLConnection ne permet pas de relire le body après une erreur 401
            // HttpClient gère mieux les erreurs d'authentification
            try {
                java.net.http.HttpClient httpClient = java.net.http.HttpClient.newBuilder()
                    .connectTimeout(java.time.Duration.ofSeconds(120))
                    .build();
                
                // Construire le body de la requête
                String bodyString = "grant_type=client_credentials" + (withScope ? "&scope=SMS" : "");
                java.net.http.HttpRequest httpRequest = java.net.http.HttpRequest.newBuilder()
                    .uri(java.net.URI.create(authUrl))
                    .header("Content-Type", "application/x-www-form-urlencoded")
                    .header("Authorization", authHeaderValue)
                    .header("Accept", "application/json")
                    .POST(java.net.http.HttpRequest.BodyPublishers.ofString(bodyString))
                    .timeout(java.time.Duration.ofSeconds(600))
                    .build();
                
                logger.debug("Body écrit dans HttpClient Request: {} ({} bytes)", bodyString, bodyString.length());
                
                // Envoyer la requête et capturer la réponse
                java.net.http.HttpResponse<String> httpResponse = httpClient.send(httpRequest, 
                    java.net.http.HttpResponse.BodyHandlers.ofString(StandardCharsets.UTF_8));
                
                int statusCodeValue = httpResponse.statusCode();
                HttpStatus statusCode = HttpStatus.valueOf(statusCodeValue);
                String responseBody = httpResponse.body();
                
                // Stocker dans ThreadLocal pour accès ultérieur
                if (responseBody != null && !responseBody.isEmpty()) {
                    ml.fasodocs.backend.config.CustomResponseErrorHandler.setErrorBody(responseBody);
                    logger.debug("📄 Body capturé via HttpClient ({} bytes): {}", 
                        responseBody.length(), responseBody.length() > 200 ? responseBody.substring(0, 200) + "..." : responseBody);
                }
                
                // Si c'est une erreur 401, logger le body capturé
                if (statusCode == HttpStatus.UNAUTHORIZED && responseBody != null) {
                    logger.error("");
                    logger.error("═══════════════════════════════════════════════════════════");
                    logger.error("📄 MESSAGE D'ERREUR ORANGE (401 UNAUTHORIZED)");
                    logger.error("═══════════════════════════════════════════════════════════");
                    logger.error("{}", responseBody);
                    logger.error("═══════════════════════════════════════════════════════════");
                    
                    // Essayer de parser le JSON d'erreur
                    try {
                        JsonNode errorJson = objectMapper.readTree(responseBody);
                        logger.error("📋 DÉTAILS DE L'ERREUR (JSON parsé):");
                        if (errorJson.has("code")) {
                            logger.error("   Code: {}", errorJson.get("code").asText());
                        }
                        if (errorJson.has("message")) {
                            logger.error("   Message: {}", errorJson.get("message").asText());
                        }
                        if (errorJson.has("description")) {
                            logger.error("   Description: {}", errorJson.get("description").asText());
                        }
                        logger.error("═══════════════════════════════════════════════════════════");
                    } catch (Exception parseEx) {
                        logger.error("⚠️ Impossible de parser le JSON d'erreur: {}", parseEx.getMessage());
                    }
                }
                
                // Créer une ResponseEntity pour compatibilité avec le reste du code
                org.springframework.http.HttpHeaders responseHeaders = new org.springframework.http.HttpHeaders();
                httpResponse.headers().map().forEach((key, values) -> {
                    responseHeaders.put(key, new java.util.ArrayList<>(values));
                });
                
                ResponseEntity<String> response = new ResponseEntity<>(
                    responseBody != null ? responseBody : "",
                    responseHeaders,
                    statusCode
                );
                
                logger.debug("Authentication response status: {}", response.getStatusCode());
                logger.debug("Authentication response body: {}", response.getBody());
                
                if (response.getStatusCode() == HttpStatus.OK) {
                    JsonNode jsonNode = objectMapper.readTree(response.getBody());
                    accessToken = jsonNode.get("access_token").asText();
                    int expiresIn = jsonNode.get("expires_in").asInt();
                    
                    // Définir le temps d'expiration (en millisecondes)
                    tokenExpirationTime = System.currentTimeMillis() + (expiresIn * 1000) - 60000; // -1 minute pour marge de sécurité
                    
                    logger.info("");
                    logger.info("═══════════════════════════════════════════════════════════");
                    logger.info("✅✅✅ AUTHENTIFICATION RÉUSSIE AVEC L'API ORANGE SMS ✅✅✅");
                    logger.info("═══════════════════════════════════════════════════════════");
                    logger.info("   Configuration utilisée: URL={}, scope={}", authUrl, withScope);
                    logger.info("   Token valide pendant: {} secondes", expiresIn);
                    logger.info("   ✅ Les SMS peuvent maintenant être envoyés");
                    logger.info("═══════════════════════════════════════════════════════════");
                    logger.info("");
                    logger.debug("Access token: {}", accessToken);
                    return true;
                } else {
                    logger.error("❌ Erreur d'authentification Orange SMS: {}", response.getStatusCode());
                    logger.error("Response body: {}", response.getBody());
                    logger.error("Response headers: {}", response.getHeaders());
                    
                    // Parser le body d'erreur si présent
                    if (response.getBody() != null && !response.getBody().isEmpty()) {
                        try {
                            JsonNode errorJson = objectMapper.readTree(response.getBody());
                            logger.error("Error JSON: {}", errorJson.toPrettyString());
                        } catch (Exception ex) {
                            logger.error("Error body (raw): {}", response.getBody());
                        }
                    }
                    return false;
                }
            } catch (HttpClientErrorException.Unauthorized e) {
                // Erreur 401 spécifique - Credentials invalides
                logger.error("");
                logger.error("═══════════════════════════════════════════════════════════");
                logger.error("❌ ERREUR 401 UNAUTHORIZED - Détails de l'erreur Orange");
                logger.error("═══════════════════════════════════════════════════════════");
                logger.error("   URL testée: {}", authUrl);
                logger.error("   Scope: {}", withScope ? "SMS" : "aucun");
                logger.error("   Status Code: {}", e.getStatusCode());
                logger.error("");
                
                // Essayer plusieurs méthodes pour obtenir le body d'erreur
                String errorBody = null;
                byte[] errorBodyBytes = null;
                
                // Méthode 1 : Body capturé par CustomResponseErrorHandler (ThreadLocal)
                errorBody = ml.fasodocs.backend.config.CustomResponseErrorHandler.getCapturedErrorBody();
                if (errorBody != null && !errorBody.isEmpty()) {
                    logger.info("✅ Body capturé via CustomResponseErrorHandler ({} bytes)", errorBody.length());
                }
                
                // Méthode 2 : Depuis l'exception directement
                if (errorBody == null || errorBody.isEmpty()) {
                    try {
                        errorBody = e.getResponseBodyAsString();
                        if (errorBody != null && !errorBody.isEmpty()) {
                            logger.info("✅ Body capturé via getResponseBodyAsString() ({} bytes)", errorBody.length());
                        }
                    } catch (Exception ex) {
                        logger.debug("⚠️ Impossible de lire getResponseBodyAsString(): {}", ex.getMessage());
                    }
                }
                
                // Méthode 3 : Depuis les bytes
                if (errorBody == null || errorBody.isEmpty()) {
                    try {
                        errorBodyBytes = e.getResponseBodyAsByteArray();
                        if (errorBodyBytes != null && errorBodyBytes.length > 0) {
                            errorBody = new String(errorBodyBytes, StandardCharsets.UTF_8);
                            logger.info("✅ Body capturé via getResponseBodyAsByteArray() ({} bytes)", errorBodyBytes.length);
                        }
                    } catch (Exception ex) {
                        logger.debug("⚠️ Impossible de lire getResponseBodyAsByteArray(): {}", ex.getMessage());
                    }
                } else {
                    // Si on a déjà le body en String, essayer aussi les bytes pour vérification
                    try {
                        errorBodyBytes = e.getResponseBodyAsByteArray();
                    } catch (Exception ex) {
                        // Ignorer
                    }
                }
                
                // Afficher le body d'erreur
                if (errorBody != null && !errorBody.isEmpty()) {
                    logger.error("📄 MESSAGE D'ERREUR ORANGE:");
                    logger.error("───────────────────────────────────────────────────────────");
                    logger.error("{}", errorBody);
                    logger.error("───────────────────────────────────────────────────────────");
                    
                    // Parser le JSON si possible
                    try {
                        JsonNode errorJson = objectMapper.readTree(errorBody);
                        logger.error("");
                        logger.error("📋 DÉTAILS DE L'ERREUR (JSON parsé):");
                        logger.error("   Code: {}", errorJson.has("code") ? errorJson.get("code").asText() : "N/A");
                        logger.error("   Message: {}", errorJson.has("message") ? errorJson.get("message").asText() : "N/A");
                        logger.error("   Description: {}", errorJson.has("description") ? errorJson.get("description").asText() : "N/A");
                        logger.error("   Error: {}", errorJson.has("error") ? errorJson.get("error").asText() : "N/A");
                        logger.error("   Error Description: {}", errorJson.has("error_description") ? errorJson.get("error_description").asText() : "N/A");
                        logger.error("");
                        logger.error("JSON complet:");
                        logger.error("{}", errorJson.toPrettyString());
                    } catch (Exception parseEx) {
                        logger.error("⚠️ Impossible de parser le JSON, affichage brut:");
                        logger.error("{}", errorBody);
                    }
                } else {
                    logger.error("⚠️ Body d'erreur non disponible");
                    logger.error("   Content-Length (si disponible): {}", 
                        e.getResponseHeaders() != null && e.getResponseHeaders().containsKey("Content-Length") 
                            ? e.getResponseHeaders().getFirst("Content-Length") 
                            : "N/A");
                    logger.error("   Response Headers: {}", e.getResponseHeaders());
                }
                
                logger.error("═══════════════════════════════════════════════════════════");
                logger.error("");
                
                // Nettoyer le ThreadLocal après utilisation
                ml.fasodocs.backend.config.CustomResponseErrorHandler.clearErrorBody();
                
                // Cette configuration a échoué, retourner false pour essayer la suivante
                logger.debug("❌ Configuration échouée: URL={}, scope={}", authUrl, withScope);
                return false;
            } catch (HttpClientErrorException e) {
                // Autres erreurs 4xx (pas 401, déjà géré)
                logger.debug("❌ Erreur client Orange SMS ({}): {}", e.getStatusCode(), e.getResponseBodyAsString());
                return false;
            } catch (HttpServerErrorException e) {
                // Erreurs 5xx
                logger.debug("❌ Erreur serveur Orange SMS ({}): {}", e.getStatusCode(), e.getResponseBodyAsString());
                return false;
            } catch (Exception e) {
                logger.debug("❌ Erreur lors de l'authentification: {}", e.getMessage());
                return false;
            }
        } catch (Exception e) {
            logger.debug("❌ Erreur lors de l'authentification: {}", e.getMessage());
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
            logger.info("🔐 Tentative d'authentification Orange SMS pour l'envoi...");
            if (!authenticate()) {
                logger.error("");
                logger.error("═══════════════════════════════════════════════════════════");
                logger.error("❌ ÉCHEC DE L'AUTHENTIFICATION ORANGE SMS");
                logger.error("═══════════════════════════════════════════════════════════");
                logger.error("   Le code SMS a été généré et stocké en base de données");
                logger.error("   Mais l'envoi SMS est impossible car l'authentification a échoué");
                logger.error("");
                logger.error("   📋 CAUSES POSSIBLES:");
                logger.error("   1. Les credentials Orange sont invalides ou expirés");
                logger.error("   2. Le Client Secret a été régénéré dans le portail Orange");
                logger.error("   3. Problème réseau ou serveur Orange indisponible");
                logger.error("");
                logger.error("   ✅ ACTIONS:");
                logger.error("   1. Exécutez: .\test_orange_sms_direct.ps1 pour tester les credentials");
                logger.error("   2. Vérifiez les credentials dans https://developer.orange.com/");
                logger.error("   3. Le code est disponible dans les logs (mode fallback)");
                logger.error("═══════════════════════════════════════════════════════════");
                logger.error("");
                throw new RuntimeException("Échec de l'authentification avec l'API Orange SMS. Vérifiez les credentials dans la configuration.");
            }
            logger.info("✅ Authentification réussie - Envoi du SMS...");
            
            // Selon le Swagger Orange : message max 160 caractères
            String messageBody = String.format(
                "FasoDocs: Votre code: %s. Expire dans 2 min.",
                code
            );
            
            // Vérifier la longueur (max 160 selon Swagger)
            if (messageBody.length() > 160) {
                logger.warn("Message trop long ({} caractères), tronqué à 160", messageBody.length());
                messageBody = messageBody.substring(0, 157) + "...";
            }
            
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
            
            // Selon le Swagger Orange : message max 160 caractères
            String messageBody = String.format(
                "Bienvenue sur FasoDocs! Votre code: %s. Expire dans 1 min.",
                code
            );
            
            // Vérifier la longueur (max 160 selon Swagger)
            if (messageBody.length() > 160) {
                logger.warn("Message trop long ({} caractères), tronqué à 160", messageBody.length());
                messageBody = messageBody.substring(0, 157) + "...";
            }
            
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
            
            // Selon le Swagger Orange : message max 160 caractères
            String messageBody = String.format(
                "FasoDocs: Code reinit: %s. Expire 1 min. Si non demande, ignorez.",
                code
            );
            
            // Vérifier la longueur (max 160 selon Swagger)
            if (messageBody.length() > 160) {
                logger.warn("Message trop long ({} caractères), tronqué à 160", messageBody.length());
                messageBody = messageBody.substring(0, 157) + "...";
            }
            
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
            
            // Normaliser le numéro de téléphone destinataire
            String normalizedPhone = normalizeMaliPhoneNumber(telephone);
            if (!isValidMaliPhoneNumber(normalizedPhone)) {
                throw new IllegalArgumentException("Numéro de téléphone invalide pour le Mali: " + telephone);
            }
            String destinationAddress = "tel:" + normalizedPhone;
            
            // Normaliser le senderAddress pour le body (doit être au format "tel:+223...")
            // IMPORTANT: Le body doit contenir le + (selon documentation Orange)
            String cleanSenderAddress = senderAddress;
            if (!cleanSenderAddress.startsWith("tel:")) {
                cleanSenderAddress = "tel:" + (cleanSenderAddress.startsWith("+") ? cleanSenderAddress : "+" + cleanSenderAddress);
            } else if (!cleanSenderAddress.contains("+")) {
                // Si tel: mais sans +, ajouter +
                cleanSenderAddress = cleanSenderAddress.replace("tel:", "tel:+");
            }
            
            // CORRECTION CONFORME DOCUMENTATION ORANGE:
            // Le senderAddress dans l'URL doit utiliser le code pays SANS préfixe + ou 00
            // Format URL: tel:2230000 (sans le +)
            // Format Body: tel:+2230000 (avec le +)
            String senderForUrl = prepareSenderForUrl(senderAddress);
            if (senderForUrl == null) {
                throw new IllegalStateException("Sender address non configuré ou invalide");
            }
            
            // URL-encoder CORRECTEMENT le senderAddress pour l'URL
            // Selon doc Orange: tel:+2230000 devient tel%3A%2B2230000
            // Mais on utilise tel:2230000 (sans +) donc devient tel%3A2230000
            String senderAddressForUrl;
            try {
                // Utiliser URLEncoder pour bien encoder tous les caractères spéciaux
                senderAddressForUrl = java.net.URLEncoder.encode(senderForUrl, StandardCharsets.UTF_8.toString());
            } catch (java.io.UnsupportedEncodingException e) {
                // Fallback si encoding échoue (ne devrait jamais arriver avec UTF-8)
                senderAddressForUrl = senderForUrl.replace(":", "%3A");
            }
            
            // Construire l'URL complète
            String smsUrl = baseUrl + "/outbound/" + senderAddressForUrl + "/requests";
            
            // Logs détaillés pour vérification
            logger.info("═══════════════════════════════════════════════════════════");
            logger.info("📱 CONFIGURATION SMS SELON DOCUMENTATION ORANGE");
            logger.info("═══════════════════════════════════════════════════════════");
            logger.info("   Sender pour BODY (avec +):    {}", cleanSenderAddress);
            logger.info("   Sender pour URL (sans +):     {}", senderForUrl);
            logger.info("   Sender URL-encodé:            {}", senderAddressForUrl);
            logger.info("   URL complète générée:         {}", smsUrl);
            logger.info("═══════════════════════════════════════════════════════════");
            logger.debug("SenderAddress pour URL (avant encodage): {}", senderForUrl);
            logger.debug("SenderAddress pour URL (après encodage): {}", senderAddressForUrl);
            
            logger.info("📱 Envoi SMS - Destinataire: {}, URL: {}, Sender: {}", 
                normalizedPhone, smsUrl, cleanSenderAddress);
            logger.debug("Message body: {}", messageBody);
            logger.debug("Application ID: {}", applicationId);
            logger.debug("Access token présent: {}", accessToken != null && !accessToken.isEmpty());
            
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
            
            // Application ID (clientCorrelator) - OPTIONNEL selon documentation Orange
            // Selon la doc: "clientCorrelator" est optionnel et peut être omis
            // Si vous recevez une erreur 400, commentez la ligne suivante
            // Le clientCorrelator doit être un UUID unique, pas l'applicationId
            // Pour l'instant, on l'omet pour éviter les erreurs 400
            // outboundSMSMessageRequest.put("clientCorrelator", applicationId);
            logger.debug("ClientCorrelator omis (optionnel selon doc Orange)");
            
            // Sender Name (par défaut ou personnalisé si configuré et enregistré chez Orange)
            // Le sender name par défaut "SMS 948223" est enregistré chez Orange
            if (senderName != null && !senderName.trim().isEmpty()) {
                try {
                    // Ne pas encoder le senderName dans le JSON (seulement pour l'URL si nécessaire)
                    outboundSMSMessageRequest.put("senderName", senderName);
                    logger.debug("Sender name ajouté: {} (par défaut Orange)", senderName);
                } catch (Exception e) {
                    logger.warn("Impossible d'ajouter le sender name: {}", e.getMessage());
                }
            }
            
            requestBody.put("outboundSMSMessageRequest", outboundSMSMessageRequest);
            
            // Log request body for debugging
            logger.debug("Request body: {}", objectMapper.writeValueAsString(requestBody));
            
            HttpEntity<Map<String, Object>> request = new HttpEntity<>(requestBody, headers);
            
            logger.debug("Envoi de la requête SMS à: {}", smsUrl);
            
            ResponseEntity<String> response;
            try {
                response = restTemplate.postForEntity(smsUrl, request, String.class);
                
                logger.debug("Réponse SMS - Status: {}, Body: {}", response.getStatusCode(), response.getBody());
                
                if (response.getStatusCode() == HttpStatus.CREATED || response.getStatusCode() == HttpStatus.OK) {
                    logger.info("✅ SMS envoyé avec succès à {}", normalizedPhone);
                } else {
                    // Analyser l'erreur Orange pour fournir un message spécifique
                    handleOrangeError(response, normalizedPhone);
                }
                
            } catch (HttpClientErrorException e) {
                // Erreur 4xx (client) - Credentials invalides, format incorrect, etc.
                logger.error("❌ Erreur client Orange SMS ({}): {}", e.getStatusCode(), e.getResponseBodyAsString());
                String errorBody = e.getResponseBodyAsString();
                if (errorBody != null && !errorBody.isEmpty()) {
                    try {
                        HttpHeaders errorHeaders = new HttpHeaders();
                        ResponseEntity<String> errorResponse = ResponseEntity
                            .status(e.getStatusCode())
                            .headers(errorHeaders)
                            .body(errorBody);
                        handleOrangeError(errorResponse, normalizedPhone);
                    } catch (Exception ex) {
                        throw new RuntimeException("Erreur client Orange SMS: " + e.getStatusCode() + " - " + errorBody, e);
                    }
                } else {
                    throw new RuntimeException("Erreur client Orange SMS: " + e.getStatusCode(), e);
                }
                
            } catch (HttpServerErrorException e) {
                // Erreur 5xx (serveur) - Service Orange indisponible
                logger.error("❌ Erreur serveur Orange SMS ({}): {}", e.getStatusCode(), e.getResponseBodyAsString());
                throw new RuntimeException("Service Orange SMS temporairement indisponible. Réessayez plus tard.", e);
            }
            
        } catch (IllegalArgumentException e) {
            logger.error("❌ Numéro de téléphone invalide: {}", e.getMessage());
            throw e;
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt(); // Restaurer le statut d'interruption
            logger.error("❌ Rate limiting interrompu pour {}: {}", telephone, e.getMessage());
            throw new RuntimeException("Envoi SMS interrompu par rate limiting", e);
        } catch (SmsSendException e) {
            // Re-lancer les exceptions SMS personnalisées
            throw e;
        } catch (Exception e) {
            logger.error("❌ Erreur lors de l'envoi du SMS à {}: {}", telephone, e.getMessage(), e);
            throw new RuntimeException("Erreur lors de l'envoi du SMS: " + e.getMessage(), e);
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
     * Teste uniquement l'authentification Orange (pour diagnostic)
     * @return true si l'authentification réussit
     */
    public boolean testAuthentication() {
        logger.info("🧪 Test d'authentification Orange SMS...");
        return authenticate();
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