package ml.fasodocs.backend.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

/**
 * DTO pour la réponse du tarif de service
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class TarifServiceResponse {
    private Long procedureId;
    private String procedureNom;
    private BigDecimal tarifService; // Frais de service selon commune
    private BigDecimal coutLegal; // Coût légal de la procédure (si disponible)
    private BigDecimal tarifTotal; // Total (service + coût légal)
    private String commune;
    private String description; // Description des services inclus
    private String delaiEstime; // Délai estimé de traitement
}

