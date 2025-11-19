package ml.fasodocs.backend.service;

import org.springframework.context.MessageSource;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.stereotype.Component;

import java.util.Locale;

/**
 * Utilitaire pour faciliter l'accès aux messages internationalisés
 * 
 * Simplifie l'utilisation de MessageSource dans les contrôleurs et services.
 * Récupère automatiquement la locale courante depuis le contexte de la requête HTTP.
 * 
 * Utilisation :
 * <pre>
 * // Sans paramètres
 * String message = messageHelper.get("error.not.found");
 * 
 * // Avec paramètres
 * String message = messageHelper.get("error.user.not.found", "john@example.com");
 * 
 * // Avec locale spécifique
 * String message = messageHelper.get("success.registration", Locale.ENGLISH);
 * </pre>
 * 
 * @author FasoDocs Team
 * @version 1.0
 */
@Component
public class MessageHelper {

    private final MessageSource messageSource;

    public MessageHelper(MessageSource messageSource) {
        this.messageSource = messageSource;
    }

    /**
     * Récupère un message traduit selon la locale courante
     * 
     * @param code Clé du message (ex: "error.not.found")
     * @return Message traduit
     */
    public String get(String code) {
        return messageSource.getMessage(code, null, getCurrentLocale());
    }

    /**
     * Récupère un message traduit avec des paramètres
     * 
     * @param code Clé du message (ex: "error.user.not.found")
     * @param args Arguments à insérer dans le message (ex: email)
     * @return Message traduit avec paramètres interpolés
     */
    public String get(String code, Object... args) {
        return messageSource.getMessage(code, args, getCurrentLocale());
    }

    /**
     * Récupère un message traduit dans une locale spécifique
     * 
     * @param code Clé du message
     * @param locale Locale spécifique (ex: Locale.ENGLISH)
     * @return Message traduit
     */
    public String get(String code, Locale locale) {
        return messageSource.getMessage(code, null, locale);
    }

    /**
     * Récupère un message traduit avec paramètres dans une locale spécifique
     * 
     * @param code Clé du message
     * @param locale Locale spécifique
     * @param args Arguments à insérer
     * @return Message traduit
     */
    public String get(String code, Locale locale, Object... args) {
        return messageSource.getMessage(code, args, locale);
    }

    /**
     * Récupère un message avec valeur par défaut si la clé n'existe pas
     * 
     * @param code Clé du message
     * @param defaultMessage Message par défaut si clé introuvable
     * @param args Arguments optionnels
     * @return Message traduit ou message par défaut
     */
    public String getOrDefault(String code, String defaultMessage, Object... args) {
        return messageSource.getMessage(code, args, defaultMessage, getCurrentLocale());
    }

    /**
     * Récupère la locale courante depuis le contexte de la requête HTTP
     * 
     * Spring la définit automatiquement via :
     * - Le header Accept-Language
     * - Le paramètre ?lang=xx
     * - La configuration par défaut (français)
     * 
     * @return Locale courante (fr, en, bm, etc.)
     */
    public Locale getCurrentLocale() {
        return LocaleContextHolder.getLocale();
    }

    /**
     * Récupère le code de langue actuel (ex: "fr", "en", "bm")
     * 
     * @return Code ISO de la langue courante
     */
    public String getCurrentLanguageCode() {
        return getCurrentLocale().getLanguage();
    }

    /**
     * Vérifie si une clé de message existe dans les ressources
     * 
     * @param code Clé du message à vérifier
     * @return true si la clé existe, false sinon
     */
    public boolean hasMessage(String code) {
        try {
            messageSource.getMessage(code, null, getCurrentLocale());
            return true;
        } catch (Exception e) {
            return false;
        }
    }
}

