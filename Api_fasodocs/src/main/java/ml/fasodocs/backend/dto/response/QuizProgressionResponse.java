package ml.fasodocs.backend.dto.response;

import lombok.Data;
import java.time.LocalDateTime;

/**
 * DTO pour la progression d'un utilisateur dans un niveau de quiz
 */
@Data
public class QuizProgressionResponse {
    private String niveau; // FACILE, MOYEN, DIFFICILE
    private Boolean estDebloque;
    private LocalDateTime dateDeblocage;
    private Integer quizCompletes;
    private Integer meilleurScore;
    private Boolean estNiveauActuel; // Si c'est le niveau actuel (dernier complété)
}

