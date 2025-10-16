package ml.fasodocs.backend.dto.response;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * DTO de réponse pour une étape
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class EtapeResponse {
    private Long id;
    private String nom;
    private String description;
    private Integer niveau;
}
