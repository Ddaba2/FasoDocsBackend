package ml.fasodocs.backend.dto.request;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

/**
 * DTO pour la vérification du code SMS
 */
@Data
public class VerificationSmsRequest {

    @NotBlank(message = "Le téléphone est obligatoire")
    private String telephone;

    @NotBlank(message = "Le code est obligatoire")
    private String code;

    private String tokenFcm; // Token pour les notifications push
}

