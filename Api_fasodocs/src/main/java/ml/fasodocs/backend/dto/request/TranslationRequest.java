package ml.fasodocs.backend.dto.request;

import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * Requête pour traduire du français vers le bambara
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class TranslationRequest {
    
    @NotBlank(message = "Le texte à traduire ne peut pas être vide")
    private String text;
    
    // Langue source (par défaut: français)
    private String sourceLang = "fr";
    
    // Langue cible (par défaut: bambara)
    private String targetLang = "bm";
}

