package ml.fasodocs.backend.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.HashSet;
import java.util.Set;

/**
 * Entité représentant un coût pour une procédure
 */
@Entity
@Table(name = "couts")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Cout {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 200)
    private String nom; // Nom du coût (ex: "Frais d'établissement", "Taxe", etc.)

    @Column(nullable = false)
    private Integer prix; // Prix en FCFA

    @Column(length = 500)
    private String description;

    @OneToMany(mappedBy = "cout", cascade = CascadeType.ALL)
    private Set<Procedure> procedures = new HashSet<>();

    /**
     * Méthode pour consulter le coût
     */
    public Cout consulter() {
        return this;
    }
}
