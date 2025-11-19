package ml.fasodocs.backend.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * Réponse pour l'audio d'une procédure
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AudioResponse {
    
    private Long procedureId;
    
    private String procedureNom;
    
    // Audio encodé en Base64
    private String audioBase64;
    
    // Format audio (wav, mp3, ogg)
    private String format;
    
    // Nom du fichier audio
    private String filename;
    
    // Taille du fichier en bytes
    private Long fileSize;
}

