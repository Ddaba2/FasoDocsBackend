package ml.fasodocs.backend.entity;

import jakarta.persistence.*;
import lombok.*;
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
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString(exclude = {"etapes", "documentsRequis", "signalements", "loisArticles", "categorie", "sousCategorie"})
@EqualsAndHashCode(exclude = {"etapes", "documentsRequis", "signalements", "loisArticles", "categorie", "sousCategorie", "cout", "centre"})
public class Procedure {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 200)
    private String nom;

    @Column(name = "nom_en", length = 200)
    private String nomEn;

    @Column(name = "nom_bm", length = 200)
    private String nomBm;

    @Column(nullable = false, length = 100)
    private String titre;

    @Column(name = "titre_en", length = 100)
    private String titreEn;

    @Column(name = "titre_bm", length = 100)
    private String titreBm;

    @Column(name = "url_vers_formulaire", length = 500)
    private String urlVersFormulaire;

    @Column(nullable = false, length = 500)
    private String delai;

    @Column(name = "delai_en", length = 500)
    private String delaiEn;

    @Column(name = "delai_bm", length = 500)
    private String delaiBm;

    @Column(columnDefinition = "TEXT")
    private String description;

    @Column(name = "description_en", columnDefinition = "TEXT")
    private String descriptionEn;

    @Column(name = "description_bm", columnDefinition = "TEXT")
    private String descriptionBm;

    @Column(name = "audio_url", length = 500)
    private String audioUrl; // URL ou chemin vers le fichier audio de fallback

    @Column(name = "peut_etre_delegatee")
    private Boolean peutEtreDelegatee = false; // Si la procédure peut être déléguée (service disponible)

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
