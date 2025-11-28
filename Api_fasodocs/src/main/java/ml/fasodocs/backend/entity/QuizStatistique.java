package ml.fasodocs.backend.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * Entité représentant les statistiques de quiz d'un utilisateur
 */
@Entity
@Table(name = "quiz_statistiques")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString(exclude = {"citoyen"})
@EqualsAndHashCode(exclude = {"citoyen"})
public class QuizStatistique {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "citoyen_id", nullable = false, unique = true)
    private Citoyen citoyen;

    @Column(name = "total_points")
    private Integer totalPoints = 0;

    @Column(name = "total_quiz_completes")
    private Integer totalQuizCompletes = 0;

    @Column(name = "streak_jours")
    private Integer streakJours = 0;

    @Column(name = "meilleur_streak")
    private Integer meilleurStreak = 0;

    @Column(name = "derniere_participation")
    private LocalDate derniereParticipation;

    @Column(name = "badge_expert")
    private Boolean badgeExpert = false;

    @Column(name = "badge_streak_master")
    private Boolean badgeStreakMaster = false;

    @CreationTimestamp
    @Column(name = "date_creation", updatable = false)
    private LocalDateTime dateCreation;

    @UpdateTimestamp
    @Column(name = "date_modification")
    private LocalDateTime dateModification;
}

