package ml.fasodocs.backend.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.Data;
import ml.fasodocs.backend.entity.Signalement;

/**
 * DTO pour la création d'un signalement
 */
@Data
public class SignalementRequest {

    @NotBlank(message = "Le titre est obligatoire")
    @Size(max = 200, message = "Le titre ne peut pas dépasser 200 caractères")
    private String titre;

    @Size(max = 1000, message = "La description ne peut pas dépasser 1000 caractères")
    private String description;

    @NotNull(message = "Le type de signalement est obligatoire")
    private Signalement.TypeSignalement type;

    private Long procedureId; // Optionnel - procédure concernée
}
