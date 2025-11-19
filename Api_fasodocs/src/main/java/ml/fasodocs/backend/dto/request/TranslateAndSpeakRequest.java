package ml.fasodocs.backend.dto.request;

import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * Requête pour traduire du français vers le bambara ET générer l'audio
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class TranslateAndSpeakRequest {
    
    @NotBlank(message = "Le texte ne peut pas être vide")
    private String text;
    
    // Description de la voix pour la synthèse vocale
    private String voiceDescription = "Voix claire et naturelle";
    
    // Taille des chunks (optionnel)
    private Float chunkSize = 1.0f;
    
    // ID de la procédure pour le fallback audio (optionnel)
    private Long procedureId;
}

