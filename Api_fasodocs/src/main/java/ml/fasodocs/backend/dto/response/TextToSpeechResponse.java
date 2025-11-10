package ml.fasodocs.backend.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * Réponse de synthèse vocale (Text-to-Speech)
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class TextToSpeechResponse {
    
    private String text;
    
    // Audio encodé en Base64
    private String audioBase64;
    
    // Format audio (wav, mp3, etc.)
    private String format;
    
    // Durée en millisecondes (optionnel)
    private Integer durationMs;
    
    // Description de la voix utilisée
    private String voiceDescription;
}

