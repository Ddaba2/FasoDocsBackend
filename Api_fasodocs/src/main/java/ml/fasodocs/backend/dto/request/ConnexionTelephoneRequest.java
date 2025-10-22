package ml.fasodocs.backend.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import lombok.Data;

/**
 * DTO pour la demande de connexion par téléphone uniquement
 */
@Data
public class ConnexionTelephoneRequest {

    @NotBlank(message = "Le numéro de téléphone est obligatoire")
    @Pattern(regexp = "^\\+223[0-9]{8}$", message = "Format de téléphone invalide. Utilisez le format +223XXXXXXXX")
    private String telephone;
}
