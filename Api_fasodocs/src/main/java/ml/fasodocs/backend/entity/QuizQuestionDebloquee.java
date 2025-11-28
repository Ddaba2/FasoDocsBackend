package ml.fasodocs.backend.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;

/**
 * Entité représentant une question débloquée par un utilisateur dans un quiz
 */
@Entity
@Table(name = "quiz_questions_debloquees",
       uniqueConstraints = @UniqueConstraint(columnNames = {"citoyen_id", "quiz_journalier_id", "question_id"}))
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString(exclude = {"citoyen", "quizJournalier", "question"})
@EqualsAndHashCode(exclude = {"citoyen", "quizJournalier", "question"})
public class QuizQuestionDebloquee {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "citoyen_id", nullable = false)
    private Citoyen citoyen;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "quiz_journalier_id", nullable = false)
    private QuizJournalier quizJournalier;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "question_id", nullable = false)
    private QuizQuestion question;

    @CreationTimestamp
    @Column(name = "date_deblocage", updatable = false)
    private LocalDateTime dateDeblocage;
}

