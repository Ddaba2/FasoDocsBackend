package ml.fasodocs.backend.dto.request;

import lombok.Data;

/**
 * DTO pour la mise à jour d'un document requis
 */
@Data
public class DocumentRequisUpdateRequest {
    private Long id; // Si fourni, met à jour le document existant
    private String nom;
    private String description;
    private Boolean estObligatoire;
    private String modeleUrl;
}

