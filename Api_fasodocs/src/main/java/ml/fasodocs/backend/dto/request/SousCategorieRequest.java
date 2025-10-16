package ml.fasodocs.backend.dto.request;

import lombok.Data;

/**
 * DTO pour les requêtes de création/modification de sous-catégories
 */
@Data
public class SousCategorieRequest {
    private String titre;
    private String description;
    private String iconeUrl;
    private Long categorieId;
}

