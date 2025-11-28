package ml.fasodocs.backend.repository;

import ml.fasodocs.backend.entity.QuizProgression;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

/**
 * Repository pour l'entité QuizProgression
 */
@Repository
public interface QuizProgressionRepository extends JpaRepository<QuizProgression, Long> {

    /**
     * Trouve la progression d'un utilisateur pour un niveau donné
     */
    Optional<QuizProgression> findByCitoyenIdAndNiveau(Long citoyenId, String niveau);

    /**
     * Trouve toutes les progressions d'un utilisateur
     */
    List<QuizProgression> findByCitoyenIdOrderByDateDeblocageAsc(Long citoyenId);

    /**
     * Vérifie si un utilisateur a débloqué un niveau
     */
    boolean existsByCitoyenIdAndNiveau(Long citoyenId, String niveau);
}

