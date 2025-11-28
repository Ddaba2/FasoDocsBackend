package ml.fasodocs.backend.entity;

import jakarta.persistence.*;
import lombok.*;

/**
 * Entité représentant une réponse possible à une question de quiz
 */
@Entity
@Table(name = "quiz_reponses")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString(exclude = {"question"})
@EqualsAndHashCode(exclude = {"question"})
public class QuizReponse {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "question_id", nullable = false)
    private QuizQuestion question;

    @Column(name = "reponse_fr", nullable = false, columnDefinition = "TEXT")
    private String reponseFr;

    @Column(name = "reponse_en", nullable = false, columnDefinition = "TEXT")
    private String reponseEn;

    @Column(name = "est_correcte")
    private Boolean estCorrecte = false;

    @Column(name = "ordre")
    private Integer ordre;
}

