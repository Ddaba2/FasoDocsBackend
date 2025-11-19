package ml.fasodocs.backend.dto.request;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

/**
 * DTO pour modifier le statut d'une demande de service
 */
@Data
public class ModifierStatutDemandeRequest {

    @NotBlank(message = "Le statut est obligatoire")
    private String statut;

    private String notes;
}

