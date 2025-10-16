package ml.fasodocs.backend.dto.response;

import lombok.Data;

@Data
public class CategorieSimpleResponse {
    private Long id;
    private String titre;
    private String description;
    private String iconeUrl;
}
