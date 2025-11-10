package ml.fasodocs.backend.dto.request;

import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * Requête pour convertir du texte bambara en audio
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class TextToSpeechRequest {
    
    @NotBlank(message = "Le texte ne peut pas être vide")
    private String text;
    
    // Description de la voix (ex: "Seydou parle clairement et naturellement")
    private String description = "Voix claire et naturelle";
    
    // Taille des chunks pour le streaming (optionnel)
    private Float chunkSize = 1.0f;
}

