package ml.fasodocs.backend.repository;

import ml.fasodocs.backend.entity.QuizStatistique;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

/**
 * Repository pour l'entité QuizStatistique
 */
@Repository
public interface QuizStatistiqueRepository extends JpaRepository<QuizStatistique, Long> {

    /**
     * Trouve les statistiques d'un utilisateur
     */
    Optional<QuizStatistique> findByCitoyenId(Long citoyenId);

    /**
     * Trouve le classement hebdomadaire (top N)
     * Utilise Pageable car LIMIT n'est pas supporté directement en JPQL
     */
    @Query("SELECT s FROM QuizStatistique s " +
           "ORDER BY s.totalPoints DESC, s.streakJours DESC")
    List<QuizStatistique> findTopByTotalPoints(org.springframework.data.domain.Pageable pageable);

    /**
     * Trouve le classement mensuel (top N)
     * Utilise Pageable car LIMIT n'est pas supporté directement en JPQL
     */
    @Query("SELECT s FROM QuizStatistique s " +
           "WHERE s.derniereParticipation >= :dateDebut " +
           "ORDER BY s.totalPoints DESC, s.streakJours DESC")
    List<QuizStatistique> findTopByTotalPointsSince(
        @Param("dateDebut") java.time.LocalDate dateDebut,
        org.springframework.data.domain.Pageable pageable
    );
}

