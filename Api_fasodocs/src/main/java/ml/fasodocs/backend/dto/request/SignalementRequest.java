package ml.fasodocs.backend.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.Data;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonIgnore;
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

    @Size(max = 200, message = "La structure ne peut pas dépasser 200 caractères")
    private String structure;

    private Long procedureId; // Optionnel - procédure concernée

    /**
     * Custom setter for type to handle string conversion
     */
    @JsonProperty("type")
    public void setTypeFromString(String typeString) {
        if (typeString != null && !typeString.trim().isEmpty()) {
            this.type = Signalement.TypeSignalement.fromString(typeString);
        }
    }

    /**
     * Setter pour permettre l'utilisation de "message" comme description
     */
    @JsonProperty("message")
    public void setMessageAsDescription(String message) {
        this.description = message;
    }

    /**
     * Ensure that if titre is not set but we have a description, we use the first part of the description as title
     */
    @JsonIgnore
    public void validateAndSetDefaults() {
        if (this.titre == null || this.titre.trim().isEmpty()) {
            if (this.description != null && !this.description.trim().isEmpty()) {
                // Use first 50 characters of description as title, or the whole description if it's shorter
                this.titre = this.description.length() > 50 ? this.description.substring(0, 50) + "..." : this.description;
            } else {
                // Default title if neither titre nor description is provided
                this.titre = "Signalement sans titre";
            }
        }
    }
}