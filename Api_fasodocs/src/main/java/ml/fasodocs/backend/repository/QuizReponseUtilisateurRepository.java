package ml.fasodocs.backend.repository;

import ml.fasodocs.backend.entity.QuizReponseUtilisateur;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * Repository pour l'entité QuizReponseUtilisateur
 */
@Repository
public interface QuizReponseUtilisateurRepository extends JpaRepository<QuizReponseUtilisateur, Long> {

    /**
     * Trouve toutes les réponses d'une participation
     */
    List<QuizReponseUtilisateur> findByParticipationId(Long participationId);
    
    /**
     * Trouve toutes les réponses d'un utilisateur pour des questions d'un ordre donné et d'un niveau donné
     */
    @Query("SELECT r FROM QuizReponseUtilisateur r " +
           "WHERE r.participation.citoyen.id = :citoyenId " +
           "AND r.question.ordre = :ordre " +
           "AND r.question.quizJournalier.niveau = :niveau")
    List<QuizReponseUtilisateur> findByCitoyenIdAndOrdreAndNiveau(@Param("citoyenId") Long citoyenId,
                                                                   @Param("ordre") Integer ordre,
                                                                   @Param("niveau") String niveau);
    
    /**
     * Trouve toutes les réponses d'un utilisateur pour une question spécifique
     */
    @Query("SELECT r FROM QuizReponseUtilisateur r " +
           "WHERE r.participation.citoyen.id = :citoyenId " +
           "AND r.question.id = :questionId " +
           "ORDER BY r.dateReponse DESC")
    List<QuizReponseUtilisateur> findByCitoyenIdAndQuestionId(@Param("citoyenId") Long citoyenId,
                                                                @Param("questionId") Long questionId);
}

