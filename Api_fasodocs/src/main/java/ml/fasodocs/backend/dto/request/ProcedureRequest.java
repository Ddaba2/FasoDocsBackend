package ml.fasodocs.backend.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.util.Set;

/**
 * DTO pour la création d'une procédure
 */
@Data
public class ProcedureRequest {

    @NotBlank(message = "Le nom est obligatoire")
    private String nom;

    @NotBlank(message = "Le titre est obligatoire")
    private String titre;

    private String urlVersFormulaire;

    @NotBlank(message = "Le délai est obligatoire")
    private String delai;

    private String description;

    private Set<String> etapes;

    // L'administrateur peut fournir soit l'ID soit le nom de la catégorie
    @NotNull(message = "La catégorie est obligatoire")
    private Long categorieId;
    private String categorieNom;

    // L'administrateur peut fournir soit l'ID soit le nom de la sous-catégorie
    private Long sousCategorieId;
    private String sousCategorieNom;
    
    private Long coutId;
    private Long centreId;
}
