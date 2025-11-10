package ml.fasodocs.backend.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

/**
 * Réponse combinée : traduction + synthèse vocale
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class TranslateAndSpeakResponse {
    
    private String originalText;
    
    private String translatedText;
    
    // Audio encodé en Base64
    private String audioBase64;
    
    // Format audio
    private String format;
    
    // Indique si la traduction provient du cache
    private boolean fromCache;
    
    private String voiceDescription;
    
    private LocalDateTime timestamp;
}

