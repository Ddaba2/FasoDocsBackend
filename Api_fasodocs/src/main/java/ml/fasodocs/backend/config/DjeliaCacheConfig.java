package ml.fasodocs.backend.config;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;

import jakarta.annotation.PostConstruct;

/**
 * Configuration du cache pour Djelia AI
 * 
 * Le cache est géré en mémoire via ConcurrentHashMap dans le DjeliaAIService.
 * Cette configuration initialise et valide les paramètres du cache.
 * 
 * @author FasoDocs Team
 */
@Configuration
public class DjeliaCacheConfig {

    private static final Logger logger = LoggerFactory.getLogger(DjeliaCacheConfig.class);

    @Value("${djelia.ai.cache.enabled:true}")
    private boolean cacheEnabled;

    @Value("${djelia.ai.cache.duration:24h}")
    private String cacheDuration;

    @PostConstruct
    public void init() {
        if (cacheEnabled) {
            logger.info("✅ Cache Djelia AI activé - Durée: {}", cacheDuration);
            logger.info("Les traductions seront mises en cache pour améliorer les performances");
        } else {
            logger.warn("⚠️ Cache Djelia AI désactivé - Toutes les traductions appelleront l'API");
        }
    }
}

