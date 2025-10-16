package ml.fasodocs.backend.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.LocalDateTime;
import java.util.HashSet;
import java.util.Set;

/**
 * Entité représentant une procédure administrative
 */
@Entity
@Table(name = "procedures")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Procedure {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 200)
    private String nom;

    @Column(nullable = false, length = 100)
    private String titre;

    @Column(name = "url_vers_formulaire", length = 500)
    private String urlVersFormulaire;


    @Column(nullable = false, length = 100)
    private String delai;

    @Column(columnDefinition = "TEXT")
    private String description;

    @OneToMany(mappedBy = "procedure", cascade = CascadeType.ALL, orphanRemoval = true)
    private Set<Etape> etapes = new HashSet<>();

    @CreationTimestamp
    @Column(name = "date_creation", updatable = false)
    private LocalDateTime dateCreation;

    @UpdateTimestamp
    @Column(name = "date_modification")
    private LocalDateTime dateModification;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "categorie_id", nullable = false)
    private Categorie categorie;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "sous_categorie_id")
    private SousCategorie sousCategorie;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "cout_id")
    private Cout cout;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "centre_id")
    private Centre centre;

    @OneToMany(mappedBy = "procedure", cascade = CascadeType.ALL, orphanRemoval = true)
    private Set<DocumentRequis> documentsRequis = new HashSet<>();

    @OneToMany(mappedBy = "procedure", cascade = CascadeType.ALL, orphanRemoval = true)
    private Set<Signalement> signalements = new HashSet<>();

    @OneToMany(mappedBy = "procedure", cascade = CascadeType.ALL, orphanRemoval = true)
    private Set<LoiArticle> loisArticles = new HashSet<>();

    /**
     * Méthode pour consulter la procédure
     */
    public Procedure consulter() {
        return this;
    }

    /**
     * Méthode pour obtenir les étapes
     */
    public Set<Etape> afficherEtapes() {
        return this.etapes;
    }

    /**
     * Méthode pour afficher les documents requis
     */
    public Set<DocumentRequis> afficherDocumentsRequis() {
        return this.documentsRequis;
    }
}
