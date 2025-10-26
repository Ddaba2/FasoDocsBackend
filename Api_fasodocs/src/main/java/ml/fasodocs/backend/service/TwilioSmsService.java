package ml.fasodocs.backend.service;

import com.twilio.Twilio;
import com.twilio.rest.api.v2010.account.Message;
import com.twilio.type.PhoneNumber;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import jakarta.annotation.PostConstruct;
import java.util.Random;

/**
 * Service pour l'envoi de SMS via Twilio
 * 
 * DÉSACTIVÉ - Remplacé par OrangeSmsService
 */
// @Service
public class TwilioSmsService {

    private static final Logger logger = LoggerFactory.getLogger(TwilioSmsService.class);

    @Value("${twilio.account.sid}")
    private String accountSid;

    @Value("${twilio.auth.token}")
    private String authToken;

    @Value("${twilio.phone.number}")
    private String twilioPhoneNumber;

    @Value("${twilio.sms.enabled:true}")
    private boolean smsEnabled;

    @PostConstruct
    public void init() {
        if (smsEnabled && accountSid != null && authToken != null) {
            try {
                Twilio.init(accountSid, authToken);
                logger.info("Twilio initialisé avec succès");
            } catch (Exception e) {
                logger.error("Erreur lors de l'initialisation de Twilio: {}", e.getMessage());
            }
        } else {
            logger.warn("Twilio désactivé ou mal configuré");
        }
    }

    /**
     * Génère un code de vérification à 6 chiffres
     */
    public String genererCodeVerification() {
        Random random = new Random();
        int code = 100000 + random.nextInt(900000); // Génère un nombre entre 100000 et 999999
        return String.valueOf(code);
    }

    /**
     * Envoie un SMS de connexion avec le code de vérification
     */
    public void envoyerSmsConnexion(String telephone, String code) {
        if (!smsEnabled) {
            logger.warn("SMS désactivé. Code généré: {}", code);
            return;
        }

        try {
            String messageBody = String.format(
                "Votre code de vérification FasoDocs est: %s\n\nCe code expire dans 5 minutes.\n\nNe partagez jamais ce code avec personne.",
                code
            );

            Message message = Message.creator(
                    new PhoneNumber(telephone),
                    new PhoneNumber(twilioPhoneNumber),
                    messageBody
            ).create();

            logger.info("SMS envoyé avec succès. SID: {}, Téléphone: {}", message.getSid(), telephone);

        } catch (Exception e) {
            logger.error("Erreur lors de l'envoi du SMS à {}: {}", telephone, e.getMessage());
            throw new RuntimeException("Erreur lors de l'envoi du SMS: " + e.getMessage());
        }
    }

    /**
     * Envoie un SMS d'inscription avec le code de vérification
     */
    public void envoyerSmsInscription(String telephone, String code) {
        if (!smsEnabled) {
            logger.warn("SMS désactivé. Code généré: {}", code);
            return;
        }

        try {
            String messageBody = String.format(
                "Bienvenue sur FasoDocs!\n\nVotre code de vérification est: %s\n\nCe code expire dans 5 minutes.\n\nMerci de votre confiance!",
                code
            );

            Message message = Message.creator(
                    new PhoneNumber(telephone),
                    new PhoneNumber(twilioPhoneNumber),
                    messageBody
            ).create();

            logger.info("SMS d'inscription envoyé avec succès. SID: {}, Téléphone: {}", message.getSid(), telephone);

        } catch (Exception e) {
            logger.error("Erreur lors de l'envoi du SMS d'inscription à {}: {}", telephone, e.getMessage());
            throw new RuntimeException("Erreur lors de l'envoi du SMS: " + e.getMessage());
        }
    }

    /**
     * Envoie un SMS de réinitialisation de mot de passe
     */
    public void envoyerSmsReinitialisation(String telephone, String code) {
        if (!smsEnabled) {
            logger.warn("SMS désactivé. Code généré: {}", code);
            return;
        }

        try {
            String messageBody = String.format(
                "Réinitialisation de mot de passe FasoDocs\n\nVotre code de vérification est: %s\n\nCe code expire dans 5 minutes.\n\nSi vous n'avez pas demandé cette réinitialisation, ignorez ce message.",
                code
            );

            Message message = Message.creator(
                    new PhoneNumber(telephone),
                    new PhoneNumber(twilioPhoneNumber),
                    messageBody
            ).create();

            logger.info("SMS de réinitialisation envoyé avec succès. SID: {}, Téléphone: {}", message.getSid(), telephone);

        } catch (Exception e) {
            logger.error("Erreur lors de l'envoi du SMS de réinitialisation à {}: {}", telephone, e.getMessage());
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
     * Vérifie si Twilio est correctement configuré
     */
    public boolean isTwilioConfigured() {
        return accountSid != null && authToken != null && twilioPhoneNumber != null;
    }
}
