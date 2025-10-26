package ml.fasodocs.backend.dto.response;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * DTO pour les réponses de chat avec Djelia AI
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class ChatResponse {
    
    private String response;
    private String language;
    private String audioUrl; // URL de l'audio généré (optionnel)
    private boolean success;
    private String errorMessage;
}
