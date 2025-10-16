package ml.fasodocs.backend.dto.response;

import lombok.Data;

@Data
public class DocumentRequisResponse {
    private Long id;
    private String description;
    private Boolean estObligatoire;
    private String modeleUrl;
}
