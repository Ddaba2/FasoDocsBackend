package ml.fasodocs.backend.dto.response;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * DTO de réponse pour un article de loi
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class LoiArticleResponse {
    private Long id;
    private String description;
    private String consulterArticle;
    private String lienAudio;
}
