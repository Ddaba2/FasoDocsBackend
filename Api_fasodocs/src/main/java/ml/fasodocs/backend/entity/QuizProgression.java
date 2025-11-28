package ml.fasodocs.backend.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;

/**
 * Entité représentant la progression d'un utilisateur dans les niveaux de quiz
 */
@Entity
@Table(name = "quiz_progression",
       uniqueConstraints = @UniqueConstraint(columnNames = {"citoyen_id", "niveau"}))
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString(exclude = {"citoyen"})
@EqualsAndHashCode(exclude = {"citoyen"})
public class QuizProgression {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "citoyen_id", nullable = false)
    private Citoyen citoyen;

    @Column(name = "niveau", length = 20, nullable = false)
    private String niveau; // FACILE, MOYEN, DIFFICILE

    @CreationTimestamp
    @Column(name = "date_deblocage", updatable = false)
    private LocalDateTime dateDeblocage;

    @Column(name = "quiz_completes")
    private Integer quizCompletes = 0;

    @Column(name = "meilleur_score")
    private Integer meilleurScore = 0;
}

