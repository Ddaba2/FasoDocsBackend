package ml.fasodocs.backend.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;
import java.util.HashSet;
import java.util.Set;

/**
 * Entité représentant une catégorie de procédures administratives
 */
@Entity
@Table(name = "categories")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString(exclude = {"procedures", "sousCategories"})
@EqualsAndHashCode(exclude = {"procedures", "sousCategories"})
public class Categorie {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true, length = 100)
    private String titre;

    @Column(name = "titre_en", length = 100)
    private String titreEn;

    @Column(name = "titre_bm", length = 100)
    private String titreBm;

    @Column(columnDefinition = "TEXT")
    private String description;

    @Column(name = "description_en", columnDefinition = "TEXT")
    private String descriptionEn;

    @Column(name = "description_bm", columnDefinition = "TEXT")
    private String descriptionBm;

    @Enumerated(EnumType.STRING)
    @Column(name = "nom_categorie", nullable = false, length = 100)
    private CategorieEnum nomCategorie;

    @Column(name = "icone_url")
    private String iconeUrl;

    @CreationTimestamp
    @Column(name = "date_creation", updatable = false)
    private LocalDateTime dateCreation;

    @OneToMany(mappedBy = "categorie", cascade = CascadeType.ALL)
    private Set<Procedure> procedures = new HashSet<>();
    
    @OneToMany(mappedBy = "categorie", cascade = CascadeType.ALL)
    private Set<SousCategorie> sousCategories = new HashSet<>();

    /**
     * Méthode pour consulter la catégorie
     */
    public Categorie consulterCategorie() {
        return this;
    }
}
