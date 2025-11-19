package ml.fasodocs.backend.dto.response;

import lombok.Data;
import ml.fasodocs.backend.entity.Citoyen;

import java.time.LocalDateTime;

@Data
public class CitoyenResponse {
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
    private String role;

    public CitoyenResponse(Citoyen citoyen) {
        this.id = citoyen.getId();
        this.nom = citoyen.getNom();
        this.prenom = citoyen.getPrenom();
        this.telephone = citoyen.getTelephone();
        this.email = citoyen.getEmail();
        this.estActif = citoyen.getEstActif();
        this.emailVerifie = citoyen.getEmailVerifie();
        this.telephoneVerifie = citoyen.getTelephoneVerifie();
        this.languePreferee = citoyen.getLanguePreferee();
        this.photoProfil = citoyen.getPhotoProfil();
        this.dateCreation = citoyen.getDateCreation();
        this.dateModification = citoyen.getDateModification();
        this.role = citoyen.getRole().name();
    }
}