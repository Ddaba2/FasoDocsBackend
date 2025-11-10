package ml.fasodocs.backend.dto.request;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

/**
 * DTO pour l'upload de photo de profil
 */
@Data
public class UploadPhotoRequest {

    @NotBlank(message = "La photo est obligatoire")
    private String photoProfil; // Photo en Base64
}

