package ml.fasodocs.backend.dto.response;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * DTO pour les réponses de synthèse vocale
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class SpeakResponse {
    
    private String text;
    private String language;
    private String audioUrl;
    private boolean success;
    private String errorMessage;
}
