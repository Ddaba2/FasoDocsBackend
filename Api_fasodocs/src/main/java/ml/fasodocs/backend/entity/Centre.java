package ml.fasodocs.backend.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;
import java.util.HashSet;
import java.util.Set;

/**
 * Entité représentant un centre de traitement
 */
@Entity
@Table(name = "centres")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Centre {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 200)
    private String nom;

    @Column(length = 500)
    private String adresse;

    @Column(length = 200)
    private String horaires;

    @Column(name = "coordonnees_gps", length = 100)
    private String coordonneesGPS;

    @Column(length = 200)
    private String telephone;

    @Column(length = 100)
    private String email;

    @CreationTimestamp
    @Column(name = "date_creation", updatable = false)
    private LocalDateTime dateCreation;

    @OneToMany(mappedBy = "centre", cascade = CascadeType.ALL)
    private Set<Procedure> procedures = new HashSet<>();

    /**
     * Méthode pour consulter le centre
     */
    public Centre consulter() {
        return this;
    }
}
