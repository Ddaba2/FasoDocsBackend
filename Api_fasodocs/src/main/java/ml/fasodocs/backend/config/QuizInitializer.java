package ml.fasodocs.backend.config;

import ml.fasodocs.backend.repository.QuizJournalierRepository;
import ml.fasodocs.backend.service.QuizGenerationService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;

/**
 * Initialise les quiz au démarrage de l'application
 * Génère les 3 quiz (FACILE, MOYEN, DIFFICILE) pour aujourd'hui s'ils n'existent pas
 * Seul le niveau FACILE est débloqué par défaut (géré par la migration SQL)
 */
@Component
@Order(100) // S'exécute après DataLoader et DataInitializer
public class QuizInitializer implements CommandLineRunner {

    private static final Logger logger = LoggerFactory.getLogger(QuizInitializer.class);

    @Autowired
    private QuizGenerationService quizGenerationService;

    @Autowired
    private QuizJournalierRepository quizJournalierRepository;

    @Override
    @Transactional(noRollbackFor = {Exception.class})
    public void run(String... args) throws Exception {
        try {
            // Compter les quiz existants par niveau
            long nombreQuizFacile = quizJournalierRepository.findAll()
                    .stream()
                    .filter(q -> "FACILE".equals(q.getNiveau()))
                    .count();
            long nombreQuizMoyen = quizJournalierRepository.findAll()
                    .stream()
                    .filter(q -> "MOYEN".equals(q.getNiveau()))
                    .count();
            long nombreQuizDifficile = quizJournalierRepository.findAll()
                    .stream()
                    .filter(q -> "DIFFICILE".equals(q.getNiveau()))
                    .count();
            
            // Vérifier si tous les quiz sont déjà générés (30 par niveau)
            if (nombreQuizFacile >= 30 && nombreQuizMoyen >= 30 && nombreQuizDifficile >= 30) {
                logger.info("✅ Tous les quiz sont déjà générés: {} FACILE, {} MOYEN, {} DIFFICILE", 
                    nombreQuizFacile, nombreQuizMoyen, nombreQuizDifficile);
                return;
            }
            
            logger.info("🎯 Initialisation des quiz...");
            logger.info("📝 Génération de 30 quiz par niveau (FACILE, MOYEN, DIFFICILE)...");
            logger.info("📊 État actuel: {} FACILE, {} MOYEN, {} DIFFICILE", 
                nombreQuizFacile, nombreQuizMoyen, nombreQuizDifficile);
            
            // Générer tous les quiz (30 par niveau)
            quizGenerationService.genererTousLesQuiz();
            
            logger.info("✅ Tous les quiz ont été générés avec succès (30 par niveau)");
            logger.info("ℹ️  Seul le niveau FACILE est débloqué par défaut pour les utilisateurs");
            logger.info("ℹ️  Les niveaux MOYEN et DIFFICILE seront débloqués après avoir complété 30 quiz du niveau précédent");
            
        } catch (Exception e) {
            logger.error("❌ Erreur lors de l'initialisation des quiz: {}", e.getMessage(), e);
            // Ne pas bloquer le démarrage de l'application en cas d'erreur
            // L'erreur peut être due à une contrainte unique - les quiz seront générés plus tard
            logger.warn("⚠️ L'application continuera de démarrer. Les quiz pourront être générés manuellement si nécessaire.");
        }
    }
}

