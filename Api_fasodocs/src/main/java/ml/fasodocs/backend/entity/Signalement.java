package ml.fasodocs.backend.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;

/**
 * Entité représentant un signalement fait par un citoyen
 */
@Entity
@Table(name = "signalements")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Signalement {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 200)
    private String titre;

    @Column(columnDefinition = "TEXT")
    private String description;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 50)
    private TypeSignalement type;

    @CreationTimestamp
    @Column(name = "date_creation", updatable = false)
    private LocalDateTime dateCreation;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "citoyen_id", nullable = false)
    private Citoyen citoyen;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "procedure_id")
    private Procedure procedure; // Procédure concernée si applicable

    /**
     * Méthode pour consulter le signalement
     */
    public Signalement consulter() {
        return this;
    }

    /**
     * Enumération des types de signalement
     */
    public enum TypeSignalement {
        ABSENCE_DU_SERVICE,
        NON_RESPECT_DU_DELAI,
        MAUVAISE_QUALITE_DU_SERVICE,
        AUTRE
    }


    /**
     * Vérifie si le signalement peut encore être modifié
     * Un signalement ne peut plus être modifié après 15 minutes
     */
    public boolean peutEtreModifie() {
        return dateCreation.isAfter(LocalDateTime.now().minusMinutes(15));
    }
}
