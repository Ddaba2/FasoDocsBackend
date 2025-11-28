package ml.fasodocs.backend.repository;

import ml.fasodocs.backend.entity.QuizJournalier;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

/**
 * Repository pour l'entité QuizJournalier
 */
@Repository
public interface QuizJournalierRepository extends JpaRepository<QuizJournalier, Long> {

    /**
     * Trouve le quiz du jour (pour compatibilité - retourne le quiz FACILE)
     */
    Optional<QuizJournalier> findByDateQuiz(LocalDate date);

    /**
     * Trouve un quiz par date et niveau
     */
    Optional<QuizJournalier> findByDateQuizAndNiveau(LocalDate date, String niveau);

    /**
     * Trouve tous les quiz d'une date donnée
     */
    List<QuizJournalier> findByDateQuizOrderByNiveauAsc(LocalDate date);

    /**
     * Trouve tous les quiz d'une date et d'un niveau donnés
     */
    List<QuizJournalier> findByDateQuizAndNiveauOrderByIdAsc(LocalDate date, String niveau);

    /**
     * Trouve le quiz du jour avec toutes les relations chargées (pour un niveau spécifique)
     */
    @Query("SELECT DISTINCT q FROM QuizJournalier q " +
           "LEFT JOIN FETCH q.questions qu " +
           "LEFT JOIN FETCH qu.reponses " +
           "WHERE q.dateQuiz = :date AND q.niveau = :niveau AND q.estActif = true")
    Optional<QuizJournalier> findByDateQuizAndNiveauWithQuestions(
            @Param("date") LocalDate date, 
            @Param("niveau") String niveau);

    /**
     * Trouve le quiz du jour avec toutes les relations chargées (pour compatibilité)
     */
    @Query("SELECT DISTINCT q FROM QuizJournalier q " +
           "LEFT JOIN FETCH q.questions qu " +
           "LEFT JOIN FETCH qu.reponses " +
           "WHERE q.dateQuiz = :date AND q.niveau = 'FACILE' AND q.estActif = true")
    Optional<QuizJournalier> findByDateQuizWithQuestions(@Param("date") LocalDate date);

    /**
     * Vérifie si un quiz existe pour une date donnée
     */
    boolean existsByDateQuiz(LocalDate date);

    /**
     * Vérifie si un quiz existe pour une date et un niveau donnés
     */
    boolean existsByDateQuizAndNiveau(LocalDate date, String niveau);

    /**
     * Trouve tous les quiz avec leurs questions, réponses, procédure et catégorie chargées
     */
    @Query("SELECT DISTINCT q FROM QuizJournalier q " +
           "LEFT JOIN FETCH q.procedure " +
           "LEFT JOIN FETCH q.categorie " +
           "LEFT JOIN FETCH q.questions qu " +
           "LEFT JOIN FETCH qu.reponses " +
           "ORDER BY q.dateQuiz DESC")
    List<QuizJournalier> findAllWithQuestions();

    /**
     * Trouve un quiz par ID avec toutes les relations chargées
     */
    @Query("SELECT DISTINCT q FROM QuizJournalier q " +
           "LEFT JOIN FETCH q.procedure " +
           "LEFT JOIN FETCH q.categorie " +
           "LEFT JOIN FETCH q.questions qu " +
           "LEFT JOIN FETCH qu.reponses " +
           "WHERE q.id = :id")
    Optional<QuizJournalier> findByIdWithQuestions(@Param("id") Long id);
    
    /**
     * Trouve tous les quiz d'un niveau avec toutes les relations chargées en une seule requête (optimisé)
     */
    @Query("SELECT DISTINCT q FROM QuizJournalier q " +
           "LEFT JOIN FETCH q.procedure " +
           "LEFT JOIN FETCH q.categorie " +
           "LEFT JOIN FETCH q.questions qu " +
           "LEFT JOIN FETCH qu.reponses " +
           "WHERE q.niveau = :niveau AND q.estActif = true " +
           "ORDER BY q.id")
    List<QuizJournalier> findByNiveauWithQuestions(@Param("niveau") String niveau);
}

