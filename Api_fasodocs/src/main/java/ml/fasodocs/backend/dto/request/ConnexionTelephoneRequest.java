package ml.fasodocs.backend.dto.request;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

/**
 * DTO pour la demande de connexion par téléphone uniquement
 */
@Data
public class ConnexionTelephoneRequest {

    @NotBlank(message = "Le numéro de téléphone est obligatoire")
    private String telephone;
}