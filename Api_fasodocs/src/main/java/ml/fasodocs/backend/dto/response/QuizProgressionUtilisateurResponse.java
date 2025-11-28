package ml.fasodocs.backend.dto.response;

import lombok.Data;
import java.util.List;

/**
 * DTO pour la progression complète d'un utilisateur dans tous les niveaux
 */
@Data
public class QuizProgressionUtilisateurResponse {
    private Long citoyenId;
    private String citoyenNom;
    private String citoyenPrenom;
    private List<QuizProgressionResponse> progressions;
    private String niveauActuel; // Le niveau actuel de l'utilisateur
    private Integer totalQuizCompletes; // Total de tous les quiz complétés
    private Integer totalPoints; // Total de tous les points
}

