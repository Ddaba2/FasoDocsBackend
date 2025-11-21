package ml.fasodocs.backend.dto.request;

import lombok.Data;

/**
 * DTO pour la mise à jour d'un article de loi
 */
@Data
public class LoiArticleUpdateRequest {
    private Long id; // Si fourni, met à jour l'article existant
    private String description;
    private String consulterArticle;
    private String lienAudio;
}

