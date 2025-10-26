package ml.fasodocs.backend.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.util.HashMap;
import java.util.Map;
import java.util.Random;

/**
 * Service pour l'envoi de SMS via Orange SMS API (Mali)
 * 
 * Ce service gère l'envoi de SMS via l'API Orange pour l'authentification
 * par SMS et les notifications dans l'application FasoDocs.
 * 
 * Fonctionnalités :
 * - Envoi de codes de vérification par SMS
 * - Génération de codes aléatoires à 6 chiffres
 * - Support du format international (+223XXXXXXXX)
 * - Configuration flexible via application.properties
 * 
 * Configuration requise dans application.properties :
 * - orange.sms.enabled : Active/désactive l'envoi de SMS
 * - orange.sms.base.url : URL de base de l'API Orange
 * - orange.sms.authorization.header : Token d'autorisation
 * - orange.sms.sender.address : Numéro de l'expéditeur
 * - orange.sms.application.id : ID de l'application Orange
 * 
 * @see ml.fasodocs.backend.service.AuthService
 * @see application.properties
 */
@Service
public class OrangeSmsService {

    private static final Logger logger = LoggerFactory.getLogger(OrangeSmsService.class);

    /** Active ou désactive l'envoi de SMS (configurable dans application.properties) */
    @Value("${orange.sms.enabled:true}")
    private boolean smsEnabled;

    /** URL de base de l'API Orange SMS */
    @Value("${orange.sms.base.url:https://api.orange.com/smsmessaging/v1}")
    private String baseUrl;

    /** Header d'autorisation Bearer pour l'API Orange */
    @Value("${orange.sms.authorization.header}")
    private String authorizationHeader;

    /** Numéro de l'expéditeur (sender) des SMS */
    @Value("${orange.sms.sender.address:tel:+2230000}")
    private String senderAddress;

    /** ID de l'application Orange */
    @Value("${orange.sms.application.id}")
    private String applicationId;

    /** RestTemplate pour les appels HTTP à l'API Orange */
    private final RestTemplate restTemplate;
    
    /** ObjectMapper pour la sérialisation/désérialisation JSON */
    private final ObjectMapper objectMapper;

    /**
     * Constructeur par défaut pour initialiser les dépendances
     */
    public OrangeSmsService() {
        this.restTemplate = new RestTemplate();
        this.objectMapper = new ObjectMapper();
    }

    /**
     * Génère un code de vérification à 6 chiffres
     * 
     * Génère un code aléatoire entre 100000 et 999999.
     * Utilisé pour l'authentification par SMS.
     * 
     * @return Code de vérification à 6 chiffres
     */
    public String genererCodeVerification() {
        Random random = new Random();
        // Génère un nombre entre 100000 et 999999
        int code = 100000 + random.nextInt(900000); 
        return String.valueOf(code);
    }

    /**
     * Convertit un numéro de téléphone au format Orange (tel:+...)
     * 
     * L'API Orange nécessite le format "tel:+XX..." pour les numéros.
     * Cette méthode normalise tous les formats possibles.
     * 
     * @param telephone Numéro de téléphone à formater
     * @return Numéro formaté avec le préfixe "tel:"
     */
    private String formatTelephone(String telephone) {
        // Si le numéro commence par +, ajouter tel:
        if (telephone.startsWith("+")) {
            return "tel:" + telephone;
        }
        // Si le numéro commence par tel:, retourner tel
        if (telephone.startsWith("tel:")) {
            return telephone;
        }
        // Sinon, ajouter tel:+
        return "tel:+" + telephone;
    }

    /**
     * Envoie un SMS via Orange SMS API
     * 
     * Envoie un SMS à un numéro de téléphone via l'API Orange.
     * Gère automatiquement le formatage du numéro et les headers requis.
     * 
     * Si l'envoi de SMS est désactivé (orange.sms.enabled=false),
     * se contente de logger le message sans l'envoyer.
     * 
     * @param telephone Numéro de téléphone du destinataire
     * @param message Contenu du SMS à envoyer
     */
    public void envoyerSms(String telephone, String message) {
        if (!smsEnabled) {
            logger.warn("Orange SMS désactivé. Message: {}", message);
            logger.warn("Destinataire: {}, Code: {}", telephone, extractCode(message));
            return;
        }

        try {
            String formatedTelephone = formatTelephone(telephone);
            
            // URL de l'endpoint Orange - extraire seulement le numéro sans "tel:"
            String senderNumber = senderAddress.replace("tel:", "");
            String url = baseUrl + "/outbound/" + encodeUrl("tel:" + senderNumber) + "/requests";

            // Headers
            HttpHeaders headers = new HttpHeaders();
            headers.set("Authorization", "Bearer " + authorizationHeader);
            headers.set("Content-Type", "application/json");

            // Body selon la documentation Swagger
            Map<String, Object> outboundSMSMessageRequest = new HashMap<>();
            outboundSMSMessageRequest.put("address", formatedTelephone);
            outboundSMSMessageRequest.put("senderAddress", senderAddress);
            
            Map<String, Object> outboundSMSTextMessage = new HashMap<>();
            outboundSMSTextMessage.put("message", message);
            outboundSMSMessageRequest.put("outboundSMSTextMessage", outboundSMSTextMessage);

            Map<String, Object> requestBody = new HashMap<>();
            requestBody.put("outboundSMSMessageRequest", outboundSMSMessageRequest);

            String jsonBody = objectMapper.writeValueAsString(requestBody);

            // Envoi de la requête
            HttpEntity<String> entity = new HttpEntity<>(jsonBody, headers);
            ResponseEntity<String> response = restTemplate.exchange(url, HttpMethod.POST, entity, String.class);

            if (response.getStatusCode().is2xxSuccessful()) {
                logger.info("SMS Orange envoyé avec succès à {}. Réponse: {}", telephone, response.getBody());
            } else {
                logger.error("Erreur lors de l'envoi SMS Orange à {}. Code: {}, Réponse: {}", 
                            telephone, response.getStatusCode(), response.getBody());
                throw new RuntimeException("Erreur lors de l'envoi du SMS: " + response.getStatusCode());
            }

        } catch (Exception e) {
            logger.error("Erreur lors de l'envoi du SMS Orange à {}: {}", telephone, e.getMessage());
            throw new RuntimeException("Erreur lors de l'envoi du SMS: " + e.getMessage());
        }
    }

    /**
     * Encode l'URL pour le senderAddress
     */
    private String encodeUrl(String url) {
        try {
            return java.net.URLEncoder.encode(url, "UTF-8").replace("+", "%20");
        } catch (java.io.UnsupportedEncodingException e) {
            return url.replace(":", "%3A").replace("+", "%2B");
        }
    }

    /**
     * Extrait le code du message pour les logs
     */
    private String extractCode(String message) {
        if (message.contains("code de vérification FasoDocs est: ")) {
            String[] parts = message.split("code de vérification FasoDocs est: ");
            if (parts.length > 1) {
                String codePart = parts[1].split("\n")[0].trim();
                return codePart;
            }
        }
        return "N/A";
    }

    /**
     * Envoie un SMS de connexion avec le code de vérification
     */
    public void envoyerSmsConnexion(String telephone, String code) {
        if (!smsEnabled) {
            logger.warn("Orange SMS désactivé. Code de vérification: {}", code);
            logger.warn("Destinataire: {}", telephone);
            return; // Ne pas lever d'exception en mode développement
        }
        
        String message = String.format(
            "Votre code de vérification FasoDocs est: %s\n\nCe code expire dans 5 minutes.\n\nNe partagez jamais ce code avec personne.",
            code
        );
        envoyerSms(telephone, message);
    }

    /**
     * Envoie un SMS d'inscription avec le code de vérification
     */
    public void envoyerSmsInscription(String telephone, String code) {
        if (!smsEnabled) {
            logger.warn("Orange SMS désactivé. Code d'inscription: {}", code);
            logger.warn("Destinataire: {}", telephone);
            return;
        }
        
        String message = String.format(
            "Bienvenue sur FasoDocs!\n\nVotre code de vérification est: %s\n\nCe code expire dans 5 minutes.\n\nMerci de votre confiance!",
            code
        );
        envoyerSms(telephone, message);
    }

    /**
     * Envoie un SMS de réinitialisation de mot de passe
     */
    public void envoyerSmsReinitialisation(String telephone, String code) {
        if (!smsEnabled) {
            logger.warn("Orange SMS désactivé. Code de réinitialisation: {}", code);
            logger.warn("Destinataire: {}", telephone);
            return;
        }
        
        String message = String.format(
            "Réinitialisation de mot de passe FasoDocs\n\nVotre code de vérification est: %s\n\nCe code expire dans 5 minutes.\n\nSi vous n'avez pas demandé cette réinitialisation, ignorez ce message.",
            code
        );
        envoyerSms(telephone, message);
    }

    /**
     * Vérifie si le service SMS est activé
     */
    public boolean isSmsEnabled() {
        return smsEnabled;
    }
}
