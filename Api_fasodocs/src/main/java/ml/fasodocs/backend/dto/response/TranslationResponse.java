package ml.fasodocs.backend.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

/**
 * Réponse de traduction français -> bambara
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class TranslationResponse {
    
    private String originalText;
    
    private String translatedText;
    
    private String sourceLang;
    
    private String targetLang;
    
    // Indique si la traduction provient du cache
    private boolean fromCache;
    
    private LocalDateTime timestamp;
}

