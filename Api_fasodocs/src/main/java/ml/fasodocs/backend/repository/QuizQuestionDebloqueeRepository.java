package ml.fasodocs.backend.repository;

import ml.fasodocs.backend.entity.QuizQuestionDebloquee;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface QuizQuestionDebloqueeRepository extends JpaRepository<QuizQuestionDebloquee, Long> {
    
    /**
     * Trouve toutes les questions débloquées pour un utilisateur dans un quiz
     */
    @Query("SELECT qqd.question.id FROM QuizQuestionDebloquee qqd " +
           "WHERE qqd.citoyen.id = :citoyenId AND qqd.quizJournalier.id = :quizJournalierId " +
           "ORDER BY qqd.question.ordre")
    List<Long> findQuestionIdsDebloquees(@Param("citoyenId") Long citoyenId, 
                                         @Param("quizJournalierId") Long quizJournalierId);
    
    /**
     * Vérifie si une question est débloquée pour un utilisateur
     */
    boolean existsByCitoyenIdAndQuizJournalierIdAndQuestionId(Long citoyenId, 
                                                               Long quizJournalierId, 
                                                               Long questionId);
    
    /**
     * Trouve toutes les questions débloquées avec leurs relations chargées
     */
    @Query("SELECT DISTINCT qqd FROM QuizQuestionDebloquee qqd " +
           "LEFT JOIN FETCH qqd.question q " +
           "LEFT JOIN FETCH q.reponses " +
           "WHERE qqd.citoyen.id = :citoyenId AND qqd.quizJournalier.id = :quizJournalierId " +
           "ORDER BY q.ordre")
    List<QuizQuestionDebloquee> findByCitoyenIdAndQuizJournalierIdWithQuestions(
            @Param("citoyenId") Long citoyenId, 
            @Param("quizJournalierId") Long quizJournalierId);
    
    /**
     * Trouve toutes les questions débloquées d'un ordre donné pour un utilisateur et un niveau
     */
    @Query("SELECT qqd.question.id FROM QuizQuestionDebloquee qqd " +
           "WHERE qqd.citoyen.id = :citoyenId " +
           "AND qqd.quizJournalier.niveau = :niveau " +
           "AND qqd.question.ordre = :ordre")
    List<Long> findQuestionIdsDebloqueesByNiveauAndOrdre(@Param("citoyenId") Long citoyenId,
                                                          @Param("niveau") String niveau,
                                                          @Param("ordre") Integer ordre);
    
    /**
     * Trouve toutes les questions débloquées pour un utilisateur et plusieurs quiz en une seule requête (optimisé)
     */
    @Query("SELECT qqd.quizJournalier.id, qqd.question.id FROM QuizQuestionDebloquee qqd " +
           "WHERE qqd.citoyen.id = :citoyenId " +
           "AND qqd.quizJournalier.id IN :quizIds")
    List<Object[]> findQuestionIdsDebloqueesByQuizIds(@Param("citoyenId") Long citoyenId,
                                                        @Param("quizIds") List<Long> quizIds);
}

