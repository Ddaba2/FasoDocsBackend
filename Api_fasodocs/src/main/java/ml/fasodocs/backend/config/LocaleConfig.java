package ml.fasodocs.backend.config;

import org.springframework.context.MessageSource;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.support.ResourceBundleMessageSource;
import org.springframework.web.servlet.LocaleResolver;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
import org.springframework.web.servlet.i18n.AcceptHeaderLocaleResolver;
import org.springframework.web.servlet.i18n.LocaleChangeInterceptor;

import java.util.Arrays;
import java.util.Locale;

/**
 * Configuration de l'internationalisation (i18n) pour FasoDocs
 * 
 * Supporte 3 langues :
 * - Français (fr) - par défaut
 * - Anglais (en)
 * - Bambara (bm)
 * 
 * La langue peut être spécifiée :
 * 1. Via le header HTTP "Accept-Language"
 * 2. Via le paramètre de requête "?lang=en"
 * 3. Via la langue préférée du citoyen stockée en base de données
 * 
 * @author FasoDocs Team
 * @version 2.0
 */
@Configuration
public class LocaleConfig implements WebMvcConfigurer {

    /**
     * Configure le LocaleResolver pour gérer les langues
     * Utilise le header Accept-Language par défaut
     */
    @Bean
    public LocaleResolver localeResolver() {
        AcceptHeaderLocaleResolver resolver = new AcceptHeaderLocaleResolver();
        
        // Langue par défaut : français
        resolver.setDefaultLocale(Locale.FRENCH);
        
        // Langues supportées : fr, en, bm
        resolver.setSupportedLocales(Arrays.asList(
            Locale.FRENCH,           // fr
            Locale.ENGLISH,          // en
            new Locale("bm")         // bm (bambara)
        ));
        
        return resolver;
    }

    /**
     * Configure la source des messages de traduction
     * Charge les fichiers messages_*.properties depuis resources/
     */
    @Bean
    public MessageSource messageSource() {
        ResourceBundleMessageSource messageSource = new ResourceBundleMessageSource();
        
        // Nom de base des fichiers de traduction
        // Cherchera : messages.properties, messages_fr.properties, messages_en.properties, etc.
        messageSource.setBasenames("messages", "validation");
        
        // Encodage UTF-8 pour supporter les caractères spéciaux (français, bambara, etc.)
        messageSource.setDefaultEncoding("UTF-8");
        
        // Ne pas lancer d'exception si une clé de traduction est manquante
        // Retourne le code de la clé à la place (ex: "error.not.found")
        messageSource.setUseCodeAsDefaultMessage(true);
        
        // Cache les messages pour améliorer les performances
        messageSource.setCacheSeconds(30); // 1 heure
        
        return messageSource;
    }

    /**
     * Intercepteur pour permettre le changement de langue via paramètre de requête
     * Exemple : GET /api/procedures?lang=en
     */
    @Bean
    public LocaleChangeInterceptor localeChangeInterceptor() {
        LocaleChangeInterceptor interceptor = new LocaleChangeInterceptor();
        
        // Nom du paramètre de requête pour changer la langue
        interceptor.setParamName("lang");
        
        return interceptor;
    }

    /**
     * Enregistre l'intercepteur de changement de langue
     */
    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(localeChangeInterceptor());
    }
}

