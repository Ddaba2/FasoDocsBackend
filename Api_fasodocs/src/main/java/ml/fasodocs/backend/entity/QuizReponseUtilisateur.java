package ml.fasodocs.backend.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;

/**
 * Entité représentant une réponse donnée par un utilisateur à une question
 */
@Entity
@Table(name = "quiz_reponses_utilisateurs")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString(exclude = {"participation", "question", "reponseChoisie"})
@EqualsAndHashCode(exclude = {"participation", "question", "reponseChoisie"})
public class QuizReponseUtilisateur {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "participation_id", nullable = false)
    private QuizParticipation participation;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "question_id", nullable = false)
    private QuizQuestion question;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "reponse_choisie_id")
    private QuizReponse reponseChoisie;

    @Column(name = "est_correcte")
    private Boolean estCorrecte;

    @Column(name = "points_obtenus")
    private Integer pointsObtenus = 0;

    @CreationTimestamp
    @Column(name = "date_reponse", updatable = false)
    private LocalDateTime dateReponse;
}

