package ml.fasodocs.backend.dto.response;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * DTO de réponse pour un centre
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class CentreResponse {
    private Long id;
    private String nom;
    private String adresse;
    private String horaires;
    private String coordonneesGPS;
    private String telephone;
    private String email;
}
