package ml.fasodocs.backend.repository;

import ml.fasodocs.backend.entity.QuizReponse;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * Repository pour l'entité QuizReponse
 */
@Repository
public interface QuizReponseRepository extends JpaRepository<QuizReponse, Long> {

    /**
     * Trouve toutes les réponses d'une question
     */
    List<QuizReponse> findByQuestionIdOrderByOrdreAsc(Long questionId);
}

