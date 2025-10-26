package ml.fasodocs.backend.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.Data;
import ml.fasodocs.backend.entity.CategorieEnum;

/**
 * DTO pour la création/modification d'une catégorie
 */
@Data
public class CategorieRequest {

    @NotBlank(message = "Le titre est obligatoire")
    @Size(max = 100, message = "Le titre ne peut pas dépasser 100 caractères")
    private String titre;

    @Size(max = 500, message = "La description ne peut pas dépasser 500 caractères")
    private String description;

    @NotNull(message = "Le nom de catégorie est obligatoire")
    private CategorieEnum nomCategorie;

    private String iconeUrl;
}
