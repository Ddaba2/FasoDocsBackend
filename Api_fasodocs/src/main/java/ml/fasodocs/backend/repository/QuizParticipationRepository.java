package ml.fasodocs.backend.repository;

import ml.fasodocs.backend.entity.QuizParticipation;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

/**
 * Repository pour l'entité QuizParticipation
 */
@Repository
public interface QuizParticipationRepository extends JpaRepository<QuizParticipation, Long> {

    /**
     * Trouve la participation d'un utilisateur à un quiz
     */
    Optional<QuizParticipation> findByCitoyenIdAndQuizJournalierId(Long citoyenId, Long quizJournalierId);

    /**
     * Trouve toutes les participations d'un utilisateur
     */
    List<QuizParticipation> findByCitoyenIdOrderByDateParticipationDesc(Long citoyenId);

    /**
     * Trouve les participations complètes d'un utilisateur
     */
    List<QuizParticipation> findByCitoyenIdAndEstCompleteTrueOrderByDateParticipationDesc(Long citoyenId);

    /**
     * Trouve la participation d'aujourd'hui pour un utilisateur
     */
    @Query("SELECT p FROM QuizParticipation p " +
           "WHERE p.citoyen.id = :citoyenId " +
           "AND DATE(p.dateParticipation) = :date")
    Optional<QuizParticipation> findByCitoyenIdAndDate(
        @Param("citoyenId") Long citoyenId,
        @Param("date") LocalDate date
    );

    /**
     * Compte le nombre de participations complètes d'un utilisateur
     */
    Long countByCitoyenIdAndEstCompleteTrue(Long citoyenId);
}

