package ml.fasodocs.backend.service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import java.util.Random;

/**
 * Service pour l'envoi de SMS
 */
@Service
public class SmsService {

    private static final Logger logger = LoggerFactory.getLogger(SmsService.class);
    private final Random random = new Random();

    /**
     * Génère un code de vérification à 6 chiffres
     */
    public String genererCodeVerification() {
        int code = 100000 + random.nextInt(900000);
        return String.valueOf(code);
    }

    /**
     * Envoie un SMS de vérification
     * TODO: Intégrer un fournisseur SMS (Twilio, Orange SMS API, etc.)
     */
    public void envoyerSmsVerification(String telephone, String code) {
        // Pour l'instant, on log le code (à remplacer par une vraie intégration SMS)
        logger.info("📱 SMS envoyé au {} - Code: {}", telephone, code);
        logger.info("⚠️  Mode développement: Intégrez un vrai service SMS en production");
        
        // TODO: Intégrer avec un service SMS réel
        // Exemple avec Twilio:
        // twilioClient.messages.create(
        //     new PhoneNumber(telephone),
        //     new PhoneNumber(numeroExpéditeur),
        //     "Votre code FasoDocs: " + code
        // );
    }

    /**
     * Envoie un SMS de confirmation de connexion
     */
    public void envoyerSmsConnexion(String telephone, String code) {
        logger.info("📱 SMS de connexion envoyé au {} - Code: {}", telephone, code);
        logger.info("Message: Votre code de connexion FasoDocs est: {}. Valide 5 minutes.", code);
        
        // TODO: Intégrer avec un service SMS réel
    }
}

