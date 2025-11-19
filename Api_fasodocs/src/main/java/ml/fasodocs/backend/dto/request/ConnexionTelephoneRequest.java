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
    @Pattern(
        regexp = "^(\\+?223)?[5-9]\\d{7}$|^[5-9]\\d{7}$",
        message = "Le numéro de téléphone doit commencer par 5, 6, 7, 8 ou 9 (ex: 70123456, 22370123456, +22370123456)"
    )
    private String telephone;
}