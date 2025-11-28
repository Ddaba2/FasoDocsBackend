package ml.fasodocs.backend.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;

/**
 * Entité représentant la participation d'un utilisateur à un quiz
 */
@Entity
@Table(name = "quiz_participations", 
       uniqueConstraints = @UniqueConstraint(columnNames = {"citoyen_id", "quiz_journalier_id"}))
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString(exclude = {"citoyen", "quizJournalier"})
@EqualsAndHashCode(exclude = {"citoyen", "quizJournalier"})
public class QuizParticipation {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "citoyen_id", nullable = false)
    private Citoyen citoyen;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "quiz_journalier_id", nullable = false)
    private QuizJournalier quizJournalier;

    @Column(name = "score")
    private Integer score = 0;

    @Column(name = "nombre_bonnes_reponses")
    private Integer nombreBonnesReponses = 0;

    @Column(name = "nombre_questions")
    private Integer nombreQuestions = 0;

    @Column(name = "temps_secondes")
    private Integer tempsSecondes;

    @CreationTimestamp
    @Column(name = "date_participation", updatable = false)
    private LocalDateTime dateParticipation;

    @Column(name = "est_complete")
    private Boolean estComplete = false;
}

