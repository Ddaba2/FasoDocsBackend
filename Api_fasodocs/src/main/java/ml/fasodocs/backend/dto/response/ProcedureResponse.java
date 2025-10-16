package ml.fasodocs.backend.dto.response;

import lombok.Data;
import java.time.LocalDateTime;
import java.util.Set;

@Data
public class ProcedureResponse {
    private Long id;
    private String nom;
    private String titre;
    private String urlVersFormulaire;
    private String delai;
    private String description;
    private LocalDateTime dateCreation;
    private LocalDateTime dateModification;
    
    // Relations
    private CategorieSimpleResponse categorie;
    private CategorieSimpleResponse sousCategorie;
    private CentreResponse centre;
    
    // Coût
    private Integer cout;
    private String coutDescription;
    
    // Collections
    private Set<EtapeResponse> etapes;
    private Set<DocumentRequisResponse> documentsRequis;
}
