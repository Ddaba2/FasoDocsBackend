package ml.fasodocs.backend.service;

import ml.fasodocs.backend.entity.*;
import ml.fasodocs.backend.repository.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * Service pour l'envoi de notifications de quiz multilingues
 */
@Service
@Transactional
public class QuizNotificationService {

    private static final Logger logger = LoggerFactory.getLogger(QuizNotificationService.class);

    @Autowired
    private NotificationRepository notificationRepository;

    @Autowired
    private CitoyenRepository citoyenRepository;

    @Autowired
    private QuizStatistiqueRepository quizStatistiqueRepository;

    // EmailService et MessageSource réservés pour futures améliorations

    /**
     * Envoie les notifications de quiz quotidien à tous les utilisateurs actifs
     */
    public void envoyerNotificationsQuizQuotidien() {
        List<Citoyen> citoyensActifs = citoyenRepository.findAllActifs();
        
        logger.info("Envoi des notifications de quiz quotidien à {} utilisateurs", citoyensActifs.size());

        for (Citoyen citoyen : citoyensActifs) {
            try {
                // Vérifier si l'utilisateur a activé les notifications de quiz
                if (citoyen.getNotificationsQuizActives() == null || citoyen.getNotificationsQuizActives()) {
                    envoyerNotificationQuizQuotidien(citoyen);
                } else {
                    logger.debug("Notifications de quiz désactivées pour {}", citoyen.getEmail());
                }
            } catch (Exception e) {
                logger.error("Erreur lors de l'envoi de notification à {}: {}", 
                    citoyen.getEmail(), e.getMessage());
            }
        }

        logger.info("Notifications de quiz quotidien envoyées");
    }

    /**
     * Envoie une notification de quiz quotidien à un utilisateur
     */
    public void envoyerNotificationQuizQuotidien(Citoyen citoyen) {
        String langue = getLangueCitoyen(citoyen);
        
        String contenuFr = "🎯 Défi du jour disponible ! Testez vos connaissances sur les procédures administratives.";
        String contenuEn = "🎯 Daily challenge available! Test your knowledge of administrative procedures.";

        Notification notification = new Notification();
        notification.setCitoyen(citoyen);
        notification.setType("QUIZ_QUOTIDIEN");
        notification.setTypeQuiz("QUIZ_QUOTIDIEN");
        
        // Stocker les deux langues
        if ("en".equals(langue)) {
            notification.setContenu(contenuEn);
            notification.setContenuEn(contenuEn);
        } else {
            notification.setContenu(contenuFr);
            notification.setContenuEn(contenuEn); // Stocker aussi la version EN
        }
        
        notificationRepository.save(notification);

        // Envoyer un email optionnel si l'utilisateur l'a activé
        // (à implémenter si nécessaire)
    }

    /**
     * Envoie un rappel de streak aux utilisateurs qui n'ont pas complété le quiz
     */
    public void envoyerRappelsStreak() {
        List<QuizStatistique> stats = quizStatistiqueRepository.findAll();
        
        logger.info("Vérification des streaks pour {} utilisateurs", stats.size());

        for (QuizStatistique stat : stats) {
            // Si l'utilisateur a un streak actif mais n'a pas complété le quiz d'aujourd'hui
            if (stat.getStreakJours() > 0 && 
                (stat.getDerniereParticipation() == null || 
                 !stat.getDerniereParticipation().equals(java.time.LocalDate.now()))) {
                
                try {
                    envoyerRappelStreak(stat.getCitoyen(), stat.getStreakJours());
                } catch (Exception e) {
                    logger.error("Erreur lors de l'envoi du rappel de streak à {}: {}", 
                        stat.getCitoyen().getEmail(), e.getMessage());
                }
            }
        }

        logger.info("Rappels de streak envoyés");
    }

    /**
     * Envoie un rappel de streak à un utilisateur
     */
    public void envoyerRappelStreak(Citoyen citoyen, int streakActuel) {
        String langue = getLangueCitoyen(citoyen);
        
        String contenuFr = String.format(
            "🔥 Votre série est de %d jours ! Ne laissez pas tomber, complétez le quiz d'aujourd'hui !",
            streakActuel
        );
        
        String contenuEn = String.format(
            "🔥 Your streak is %d days! Don't break it, complete today's quiz!",
            streakActuel
        );

        Notification notification = new Notification();
        notification.setCitoyen(citoyen);
        notification.setType("RAPPEL_STREAK");
        notification.setTypeQuiz("RAPPEL_STREAK");
        
        // Stocker les deux langues
        if ("en".equals(langue)) {
            notification.setContenu(contenuEn);
            notification.setContenuEn(contenuEn);
        } else {
            notification.setContenu(contenuFr);
            notification.setContenuEn(contenuEn); // Stocker aussi la version EN
        }
        
        notificationRepository.save(notification);
    }

    /**
     * Envoie une notification de badge débloqué
     */
    public void envoyerNotificationBadge(Citoyen citoyen, String nomBadge) {
        String langue = getLangueCitoyen(citoyen);
        
        String contenuFr = String.format("🏆 Félicitations ! Vous avez débloqué le badge \"%s\" !", nomBadge);
        String contenuEn = String.format("🏆 Congratulations! You've unlocked the \"%s\" badge!", nomBadge);

        Notification notification = new Notification();
        notification.setCitoyen(citoyen);
        notification.setType("BADGE_DEBLOQUE");
        notification.setTypeQuiz("BADGE_DEBLOQUE");
        
        // Stocker les deux langues
        if ("en".equals(langue)) {
            notification.setContenu(contenuEn);
            notification.setContenuEn(contenuEn);
        } else {
            notification.setContenu(contenuFr);
            notification.setContenuEn(contenuEn); // Stocker aussi la version EN
        }
        
        notificationRepository.save(notification);
    }

    /**
     * Envoie une notification de déblocage de niveau
     */
    public void envoyerNotificationDeblocageNiveau(Citoyen citoyen, String niveau) {
        String langue = getLangueCitoyen(citoyen);
        
        String niveauFr = "MOYEN".equals(niveau) ? "Moyen" : "Difficile";
        String niveauEn = "MOYEN".equals(niveau) ? "Medium" : "Difficult";
        
        String contenuFr = String.format("🎉 Félicitations ! Vous avez débloqué le niveau %s ! Vous pouvez maintenant accéder à des quiz plus difficiles.", niveauFr);
        String contenuEn = String.format("🎉 Congratulations! You've unlocked the %s level! You can now access more difficult quizzes.", niveauEn);

        Notification notification = new Notification();
        notification.setCitoyen(citoyen);
        notification.setType("NIVEAU_DEBLOQUE");
        notification.setTypeQuiz("NIVEAU_DEBLOQUE");
        
        // Stocker les deux langues
        if ("en".equals(langue)) {
            notification.setContenu(contenuEn);
            notification.setContenuEn(contenuEn);
        } else {
            notification.setContenu(contenuFr);
            notification.setContenuEn(contenuEn); // Stocker aussi la version EN
        }
        
        notificationRepository.save(notification);
        logger.info("Notification de déblocage du niveau {} envoyée à l'utilisateur {}", niveau, citoyen.getId());
    }

    /**
     * Récupère la langue préférée d'un citoyen
     */
    private String getLangueCitoyen(Citoyen citoyen) {
        if (citoyen.getLanguePreferee() != null) {
            return citoyen.getLanguePreferee();
        }
        return "fr"; // Langue par défaut
    }
}

