package ml.fasodocs.backend.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.HashSet;
import java.util.Set;

/**
 * Entité représentant un quiz quotidien
 */
@Entity
@Table(name = "quiz_journaliers")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString(exclude = {"questions"})
@EqualsAndHashCode(exclude = {"questions"})
public class QuizJournalier {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "date_quiz", nullable = false)
    private LocalDate dateQuiz;

    @Column(name = "niveau", length = 20, nullable = false)
    private String niveau = "FACILE"; // FACILE, MOYEN, DIFFICILE

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "procedure_id")
    private Procedure procedure;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "categorie_id")
    private Categorie categorie;

    @Column(name = "est_actif")
    private Boolean estActif = true;

    @CreationTimestamp
    @Column(name = "date_creation", updatable = false)
    private LocalDateTime dateCreation;

    @OneToMany(mappedBy = "quizJournalier", cascade = CascadeType.ALL, orphanRemoval = true)
    private Set<QuizQuestion> questions = new HashSet<>();
}

