package ml.fasodocs.backend.dto.request;

import lombok.Data;

import java.util.List;

/**
 * DTO pour la mise à jour d'une procédure
 * Tous les champs sont optionnels pour permettre des mises à jour partielles
 */
@Data
public class ProcedureUpdateRequest {

    private String nom;

    private String titre;

    private String urlVersFormulaire;

    private String delai;

    private String description;

    // Étapes : liste de descriptions (strings)
    // Si fourni, remplace toutes les étapes existantes
    private List<String> etapes;

    // L'administrateur peut fournir soit l'ID soit le nom de la catégorie
    private Long categorieId;
    private String categorieNom;

    // L'administrateur peut fournir soit l'ID soit le nom de la sous-catégorie
    private Long sousCategorieId;
    private String sousCategorieNom;
    
    // Gestion du coût : soit par ID existant, soit directement par prix
    private Long coutId;
    private Integer cout; // Prix direct en FCFA
    private String typeMonnaie; // Type de monnaie (ex: "FCFA")
    
    private Long centreId;
    
    // Documents requis : liste de documents
    // Si fourni, remplace tous les documents existants
    private List<DocumentRequisUpdateRequest> documentsRequis;
    
    // Lois et articles : liste d'articles de loi
    // Si fourni, remplace tous les articles existants
    private List<LoiArticleUpdateRequest> loisArticles;
    
    // Centres : liste d'IDs de centres (pour les procédures avec plusieurs centres)
    // Si fourni, remplace tous les centres existants
    private List<Long> centres;
}

