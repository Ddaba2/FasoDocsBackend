package ml.fasodocs.backend.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;
import java.util.HashSet;
import java.util.Set;

/**
 * Entité représentant une question de quiz
 */
@Entity
@Table(name = "quiz_questions")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString(exclude = {"reponses", "quizJournalier"})
@EqualsAndHashCode(exclude = {"reponses", "quizJournalier"})
public class QuizQuestion {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "quiz_journalier_id", nullable = false)
    private QuizJournalier quizJournalier;

    @Column(name = "question_fr", nullable = false, columnDefinition = "TEXT")
    private String questionFr;

    @Column(name = "question_en", nullable = false, columnDefinition = "TEXT")
    private String questionEn;

    @Column(name = "type_question", length = 50)
    private String typeQuestion; // DELAI, COUT, DOCUMENT, CENTRE, ETAPE, LOI

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "procedure_id")
    private Procedure procedure;

    @Column(name = "reponse_correcte", nullable = false, columnDefinition = "TEXT")
    private String reponseCorrecte;

    @Column(name = "points")
    private Integer points = 10;

    @Column(name = "niveau", length = 20)
    private String niveau = "FACILE"; // FACILE, MOYEN, DIFFICILE

    @Column(name = "ordre")
    private Integer ordre = 0; // Ordre de la question dans le quiz (1, 2, 3, 4, 5)

    @CreationTimestamp
    @Column(name = "date_creation", updatable = false)
    private LocalDateTime dateCreation;

    @OneToMany(mappedBy = "question", cascade = CascadeType.ALL, orphanRemoval = true)
    private Set<QuizReponse> reponses = new HashSet<>();
}

