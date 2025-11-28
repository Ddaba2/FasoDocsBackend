package ml.fasodocs.backend.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;
import com.fasterxml.jackson.annotation.JsonBackReference;

import java.time.LocalDateTime;
import java.util.HashSet;
import java.util.Set;

/**
 * Entité représentant un citoyen utilisateur de l'application FasoDocs
 */
@Entity
@Table(name = "citoyens")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString(exclude = {"historiques", "notifications", "signalements", "parametre"})
@EqualsAndHashCode(exclude = {"historiques", "notifications", "signalements", "parametre"})
public class Citoyen {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(length = 100)
    private String nom;

    @Column(length = 100)
    private String prenom;

    @Column(nullable = false, unique = true, length = 20)
    private String telephone;

    @Column(nullable = false, unique = true, length = 100)
    private String email;

    @Column(nullable = false)
    private String motDePasse;

    @Column(name = "est_actif")
    private Boolean estActif = true;

    @Column(name = "email_verifie")
    private Boolean emailVerifie = false;

    @Column(name = "code_verification")
    private String codeVerification;
    
    @Column(name = "code_sms")
    private String codeSms;
    
    @Column(name = "code_sms_expiration")
    private LocalDateTime codeSmsExpiration;
    
    @Column(name = "telephone_verifie")
    private Boolean telephoneVerifie = false;


    @Column(name = "langue_preferee", length = 2)
    private String languePreferee = "fr"; // fr, en ou bm (bambara)

    @Column(name = "notifications_quiz_actives")
    private Boolean notificationsQuizActives = true; // Activer les notifications de quiz

    @Lob
    @Column(name = "photo_profil", columnDefinition = "LONGTEXT")
    private String photoProfil; // Photo de profil en Base64

    @CreationTimestamp
    @Column(name = "date_creation", updatable = false)
    private LocalDateTime dateCreation;

    @UpdateTimestamp
    @Column(name = "date_modification")
    private LocalDateTime dateModification;

    @OneToMany(mappedBy = "citoyen", cascade = CascadeType.ALL, orphanRemoval = true)
    @JsonBackReference
    private Set<HistoriqueLog> historiques = new HashSet<>();

    @OneToMany(mappedBy = "citoyen", cascade = CascadeType.ALL, orphanRemoval = true)
    @JsonBackReference
    private Set<Notification> notifications = new HashSet<>();

    @OneToMany(mappedBy = "citoyen", cascade = CascadeType.ALL, orphanRemoval = true)
    @JsonBackReference
    private Set<Signalement> signalements = new HashSet<>();

    @OneToOne(mappedBy = "citoyen", cascade = CascadeType.ALL)
    @JsonBackReference
    private Parametre parametre;

    @Enumerated(EnumType.STRING)
    @Column(name = "role", nullable = false, length = 20)
    private RoleCitoyen role = RoleCitoyen.USER;

    /**
     * Enum pour les rôles des citoyens
     */
    public enum RoleCitoyen {
        USER,
        ADMIN
    }

    /**
     * Méthode pour créer un compte
     */
    public void creerCompte() {
        this.estActif = true;
        this.emailVerifie = false;
        this.dateCreation = LocalDateTime.now();
    }

    /**
     * Méthode pour se connecter (validation sera faite dans le service)
     */
    public boolean seConnecter(String motDePasseSaisi) {
        return this.estActif && this.emailVerifie;
    }

    /**
     * Méthode pour consulter le profil
     */
    public Citoyen consulterProfil() {
        return this;
    }

    /**
     * Méthode pour modifier le profil
     */
    public void modifierProfil(String nom, String prenom, String telephone) {
        this.nom = nom;
        this.prenom = prenom;
        this.telephone = telephone;
    }

    /**
     * Méthode pour modifier les paramètres
     */
    public void modifierParametres(String languePreferee) {
        this.languePreferee = languePreferee;
    }
}