package ml.fasodocs.backend.dto.response;

import lombok.Data;
import ml.fasodocs.backend.entity.SousCategorie;
import ml.fasodocs.backend.service.TranslationHelper;

import java.time.LocalDateTime;

/**
 * DTO pour la réponse d'une sous-catégorie
 */
@Data
public class SousCategorieResponse {

    private Long id;
    private String titre;
    private String description;
    private String iconeUrl;
    private LocalDateTime dateCreation;
    private Long categorieId;
    private String categorieTitre;
    private String categorieNomCategorie;
    private int nombreProcedures;

    public SousCategorieResponse(SousCategorie sousCategorie) {
        this.id = sousCategorie.getId();
        this.titre = sousCategorie.getTitre();
        this.description = sousCategorie.getDescription();
        this.iconeUrl = sousCategorie.getIconeUrl();
        this.dateCreation = sousCategorie.getDateCreation();
        this.categorieId = sousCategorie.getCategorie().getId();
        this.categorieTitre = sousCategorie.getCategorie().getTitre();
        this.categorieNomCategorie = sousCategorie.getCategorie().getNomCategorie().name();
        this.nombreProcedures = sousCategorie.getProcedures().size();
    }

    public SousCategorieResponse(SousCategorie sousCategorie, TranslationHelper translationHelper) {
        this.id = sousCategorie.getId();
        this.titre = translationHelper.getTitre(sousCategorie);
        this.description = translationHelper.getDescription(sousCategorie);
        this.iconeUrl = sousCategorie.getIconeUrl();
        this.dateCreation = sousCategorie.getDateCreation();
        this.categorieId = sousCategorie.getCategorie().getId();
        this.categorieTitre = translationHelper.getTitre(sousCategorie.getCategorie());
        this.categorieNomCategorie = sousCategorie.getCategorie().getNomCategorie().name();
        this.nombreProcedures = sousCategorie.getProcedures().size();
    }
}
