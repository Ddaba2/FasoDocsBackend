package ml.fasodocs.backend.dto.response;

import lombok.Data;
import ml.fasodocs.backend.entity.Signalement;

import java.time.LocalDateTime;

/**
 * DTO pour la réponse d'un signalement
 */
@Data
public class SignalementResponse {

    private Long id;
    private String titre;
    private String description;
    private Signalement.TypeSignalement type;
    private LocalDateTime dateCreation;
    private Long citoyenId;
    private String citoyenNom;
    private String citoyenTelephone;
    private Long procedureId;
    private String procedureNom;
    private boolean peutEtreModifie;

    public SignalementResponse(Signalement signalement) {
        this.id = signalement.getId();
        this.titre = signalement.getTitre();
        this.description = signalement.getDescription();
        this.type = signalement.getType();
        this.dateCreation = signalement.getDateCreation();
        this.citoyenId = signalement.getCitoyen().getId();
        this.citoyenNom = signalement.getCitoyen().getNom() + " " + signalement.getCitoyen().getPrenom();
        this.citoyenTelephone = signalement.getCitoyen().getTelephone();
        this.procedureId = signalement.getProcedure() != null ? signalement.getProcedure().getId() : null;
        this.procedureNom = signalement.getProcedure() != null ? signalement.getProcedure().getNom() : null;
        this.peutEtreModifie = signalement.peutEtreModifie();
    }
}
