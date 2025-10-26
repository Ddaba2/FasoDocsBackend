package ml.fasodocs.backend.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Data;

/**
 * DTO pour les requêtes de traduction
 */
@Data
public class TranslationRequest {

    @NotBlank(message = "Le texte à traduire est obligatoire")
    @Size(min = 1, max = 2000, message = "Le texte doit contenir entre 1 et 2000 caractères")
    private String text;

    @NotBlank(message = "La langue source est obligatoire")
    private String sourceLang = "fr"; // Français par défaut

    @NotBlank(message = "La langue cible est obligatoire")
    private String targetLang = "bm"; // Bambara par défaut
}
