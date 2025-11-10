package ml.fasodocs.backend.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonManagedReference;
import ml.fasodocs.backend.entity.converters.TypeSignalementConverter;
import java.time.LocalDateTime;

/**
 * Entité représentant un signalement fait par un citoyen
 */
@Entity
@Table(name = "signalements")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode(exclude = {"citoyen", "procedure"})
@ToString(exclude = {"citoyen", "procedure"})
public class Signalement {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 200)
    private String titre;

    @Column(columnDefinition = "TEXT")
    private String description;

    @Convert(converter = TypeSignalementConverter.class)
    @Column(nullable = false, length = 50)
    private TypeSignalement type;

    @Column(name = "structure", nullable = true, length = 200)
    private String structure;

    @CreationTimestamp
    @Column(name = "date_creation", updatable = false)
    private LocalDateTime dateCreation;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "citoyen_id", nullable = false)
    @JsonManagedReference
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
        AUTRE;

        @JsonCreator
        public static TypeSignalement fromString(String value) {
            if (value == null || value.trim().isEmpty()) {
                return null;
            }
            
            // Nettoyer la valeur
            String cleanValue = value.trim();
            
            // Handle exact string values first (case sensitive)
            try {
                return TypeSignalement.valueOf(cleanValue);
            } catch (IllegalArgumentException e) {
                // Continue with other matching strategies
            }
            
            // Handle exact string values (case insensitive)
            for (TypeSignalement type : TypeSignalement.values()) {
                if (type.name().equalsIgnoreCase(cleanValue)) {
                    return type;
                }
            }
            
            // Handle French string values
            switch (cleanValue.toLowerCase()) {
                case "absence du service":
                case "absence_du_service":
                    return ABSENCE_DU_SERVICE;
                case "non respect du délai":
                case "non_respect_du_delai":
                    return NON_RESPECT_DU_DELAI;
                case "mauvaise qualité du service":
                case "mauvaise_qualité_du_service":
                    return MAUVAISE_QUALITE_DU_SERVICE;
                case "signalement d'abus":
                case "abus":
                case "autre":
                    return AUTRE;
                default:
                    // Default to AUTRE for unknown values
                    return AUTRE;
            }
        }
        
        @Override
        public String toString() {
            return this.name();
        }
    }


    /**
     * Vérifie si le signalement peut encore être modifié
     * Un signalement ne peut plus être modifié après 15 minutes
     */
    public boolean peutEtreModifie() {
        return dateCreation.isAfter(LocalDateTime.now().minusMinutes(15));
    }
}