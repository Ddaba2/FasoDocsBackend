package ml.fasodocs.backend.service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.time.LocalDate;

/**
 * Scheduler pour les tâches planifiées du système de quiz
 */
@Component
public class QuizScheduler {

    private static final Logger logger = LoggerFactory.getLogger(QuizScheduler.class);

    @Autowired
    private QuizGenerationService quizGenerationService;

    @Autowired
    private QuizNotificationService quizNotificationService;

    /**
     * Vérifie et complète les quiz si nécessaire (30 quiz par niveau)
     * S'exécute tous les jours à minuit pour s'assurer que tous les quiz sont disponibles
     */
    @Scheduled(cron = "0 0 0 * * ?") // Tous les jours à 00:00
    public void verifierEtGenererQuiz() {
        try {
            logger.info("Vérification des quiz disponibles...");
            // Génère les quiz manquants si nécessaire (pour atteindre 30 par niveau)
            quizGenerationService.genererTousLesQuiz();
            logger.info("Vérification des quiz terminée");
        } catch (Exception e) {
            logger.error("Erreur lors de la vérification des quiz: {}", e.getMessage(), e);
        }
    }

    /**
     * Envoie les notifications de quiz à 8h du matin (08:00)
     */
    @Scheduled(cron = "0 0 8 * * ?") // Tous les jours à 08:00
    public void envoyerNotificationsQuiz() {
        try {
            logger.info("Envoi des notifications de quiz quotidien");
            quizNotificationService.envoyerNotificationsQuizQuotidien();
            logger.info("Notifications de quiz envoyées avec succès");
        } catch (Exception e) {
            logger.error("Erreur lors de l'envoi des notifications de quiz: {}", e.getMessage(), e);
        }
    }

    /**
     * Envoie les rappels de streak à 18h (18:00)
     */
    @Scheduled(cron = "0 0 18 * * ?") // Tous les jours à 18:00
    public void envoyerRappelsStreak() {
        try {
            logger.info("Envoi des rappels de streak");
            quizNotificationService.envoyerRappelsStreak();
            logger.info("Rappels de streak envoyés avec succès");
        } catch (Exception e) {
            logger.error("Erreur lors de l'envoi des rappels de streak: {}", e.getMessage(), e);
        }
    }
}

