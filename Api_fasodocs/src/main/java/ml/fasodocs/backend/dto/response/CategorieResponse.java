package ml.fasodocs.backend.dto.response;

import lombok.Data;
import ml.fasodocs.backend.entity.Categorie;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

/**
 * DTO pour la réponse d'une catégorie
 */
@Data
public class CategorieResponse {

    private Long id;
    private String titre;
    private String description;
    private String nomCategorie;
    private String iconeUrl;
    private LocalDateTime dateCreation;
    private List<SousCategorieSimpleResponse> sousCategories;
    private int nombreProcedures;

    public CategorieResponse(Categorie categorie) {
        this.id = categorie.getId();
        this.titre = categorie.getTitre();
        this.description = categorie.getDescription();
        this.nomCategorie = categorie.getNomCategorie().name();
        this.iconeUrl = categorie.getIconeUrl();
        this.dateCreation = categorie.getDateCreation();
        this.sousCategories = categorie.getSousCategories().stream()
                .map(SousCategorieSimpleResponse::new)
                .collect(Collectors.toList());
        this.nombreProcedures = categorie.getProcedures().size();
    }

    /**
     * DTO simplifié pour les sous-catégories dans la réponse catégorie
     */
    @Data
    public static class SousCategorieSimpleResponse {
        private Long id;
        private String titre;
        private String description;
        private String iconeUrl;
        private int nombreProcedures;

        public SousCategorieSimpleResponse(ml.fasodocs.backend.entity.SousCategorie sousCategorie) {
            this.id = sousCategorie.getId();
            this.titre = sousCategorie.getTitre();
            this.description = sousCategorie.getDescription();
            this.iconeUrl = sousCategorie.getIconeUrl();
            this.nombreProcedures = sousCategorie.getProcedures().size();
        }
    }
}
