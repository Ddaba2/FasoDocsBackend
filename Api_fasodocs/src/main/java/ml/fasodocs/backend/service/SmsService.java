package ml.fasodocs.backend.service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.util.Random;

/**
 * Service pour l'envoi de SMS
 */
@Service
public class SmsService {

    private static final Logger logger = LoggerFactory.getLogger(SmsService.class);
    private final Random random = new Random();
    
    @Value("${orange.sms.enabled:false}")
    private boolean orangeSmsEnabled;
    
    @Autowired(required = false)
    private OrangeSmsService orangeSmsService;

    /**
     * Génère un code de vérification à 4 chiffres
     */
    public String genererCodeVerification() {
        int code = 1000 + random.nextInt(9000);
        return String.valueOf(code);
    }

    /**
     * Envoie un SMS de vérification
     */
    public void envoyerSmsVerification(String telephone, String code) {
        if (orangeSmsEnabled && orangeSmsService != null && orangeSmsService.isSmsEnabled()) {
            // Utiliser le service Orange SMS
            orangeSmsService.envoyerSmsConnexion(telephone, code);
        } else {
            // Mode développement: log le code
            logger.info("📱 SMS envoyé au {} - Code: {}", telephone, code);
            logger.info("⚠️  Mode développement: Intégrez un vrai service SMS en production");
        }
    }

    /**
     * Envoie un SMS de confirmation de connexion
     */
    public void envoyerSmsConnexion(String telephone, String code) {
        if (orangeSmsEnabled && orangeSmsService != null && orangeSmsService.isSmsEnabled()) {
            // Utiliser le service Orange SMS
            orangeSmsService.envoyerSmsConnexion(telephone, code);
        } else {
            // Mode développement: log le code
            logger.info("📱 SMS de connexion envoyé au {} - Code: {}", telephone, code);
            logger.info("Message: Votre code de connexion FasoDocs est: {}. Valide 5 minutes.", code);
        }
    }
}