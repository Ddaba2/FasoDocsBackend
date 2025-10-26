package ml.fasodocs.backend.dto.response;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * DTO pour les réponses de traduction
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class TranslationResponse {
    
    private String originalText;
    private String translatedText;
    private String sourceLang;
    private String targetLang;
    private boolean success;
    private String errorMessage;
}
