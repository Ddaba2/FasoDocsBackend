package ml.fasodocs.backend.config;

import ml.fasodocs.backend.service.ChatbotService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

/**
 * Vérifie la connectivité avec Djelia AI au démarrage de l'application
 * 
 * Cette classe s'exécute automatiquement au démarrage et vérifie si
 * le backend Djelia AI est accessible et fonctionnel.
 * 
 * @author FasoDocs Team
 * @version 1.0
 */
@Component
public class DjeliaHealthChecker implements CommandLineRunner {

    private static final Logger logger = LoggerFactory.getLogger(DjeliaHealthChecker.class);

    @Autowired
    private ChatbotService chatbotService;

    /**
     * S'exécute au démarrage de l'application
     * Vérifie la connectivité avec Djelia AI
     */
    @Override
    public void run(String... args) throws Exception {
        logger.info("🔍 Vérification de la connectivité avec Djelia AI...");
        
        boolean isDjeliaAvailable = chatbotService.verifierConnectivité();
        
        if (isDjeliaAvailable) {
            logger.info("✅ Djelia AI est accessible et fonctionnel");
            logger.info("   → Traduction FR↔BM : Disponible");
            logger.info("   → Synthèse vocale : Disponible");
            logger.info("   → Chat : Disponible");
        } else {
            logger.warn("⚠️ Djelia AI n'est pas accessible");
            logger.warn("   → Vérifiez que le backend Python Djelia est démarré sur http://localhost:5000");
            logger.warn("   → Les fonctionnalités de traduction et synthèse vocale ne seront pas disponibles");
            logger.warn("   → Pour démarrer Djelia AI, exécutez : python app dans le dossier Djelia-AI-Backend");
        }
        
        logger.info("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
    }
}

