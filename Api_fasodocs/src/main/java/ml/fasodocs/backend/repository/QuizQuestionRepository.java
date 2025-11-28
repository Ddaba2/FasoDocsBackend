package ml.fasodocs.backend.repository;

import ml.fasodocs.backend.entity.QuizQuestion;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * Repository pour l'entité QuizQuestion
 */
@Repository
public interface QuizQuestionRepository extends JpaRepository<QuizQuestion, Long> {

    /**
     * Trouve toutes les questions d'un quiz
     */
    List<QuizQuestion> findByQuizJournalierIdOrderById(Long quizJournalierId);

    /**
     * Trouve toutes les questions d'un quiz avec les réponses
     */
    @Query("SELECT DISTINCT q FROM QuizQuestion q " +
           "LEFT JOIN FETCH q.reponses " +
           "WHERE q.quizJournalier.id = :quizJournalierId " +
           "ORDER BY q.id")
    List<QuizQuestion> findByQuizJournalierIdWithReponses(@Param("quizJournalierId") Long quizJournalierId);
    
    /**
     * Trouve toutes les questions d'un ordre donné pour un niveau donné
     */
    @Query("SELECT q FROM QuizQuestion q " +
           "WHERE q.quizJournalier.niveau = :niveau " +
           "AND q.ordre = :ordre " +
           "AND q.quizJournalier.estActif = true " +
           "ORDER BY q.quizJournalier.id")
    List<QuizQuestion> findByNiveauAndOrdre(@Param("niveau") String niveau, 
                                            @Param("ordre") Integer ordre);
}

