package ml.fasodocs.backend.dto.response;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDateTime;

/**
 * DTO pour la réponse du profil citoyen
 * Évite les problèmes de sérialisation JSON avec l'entité Citoyen
 */
@Getter
@Setter
@NoArgsConstructor
public class CitoyenProfilResponse {
    private Long id;
    private String nom;
    private String prenom;
    private String telephone;
    private String email;
    private Boolean estActif;
    private Boolean emailVerifie;
    private Boolean telephoneVerifie;
    private String languePreferee;
    private String photoProfil;
    private LocalDateTime dateCreation;
    private LocalDateTime dateModification;

    public CitoyenProfilResponse(Long id, String nom, String prenom, String telephone, String email,
                                Boolean estActif, Boolean emailVerifie, Boolean telephoneVerifie,
                                String languePreferee, String photoProfil, LocalDateTime dateCreation, LocalDateTime dateModification) {
        this.id = id;
        this.nom = nom;
        this.prenom = prenom;
        this.telephone = telephone;
        this.email = email;
        this.estActif = estActif;
        this.emailVerifie = emailVerifie;
        this.telephoneVerifie = telephoneVerifie;
        this.languePreferee = languePreferee;
        this.photoProfil = photoProfil;
        this.dateCreation = dateCreation;
        this.dateModification = dateModification;
    }
}