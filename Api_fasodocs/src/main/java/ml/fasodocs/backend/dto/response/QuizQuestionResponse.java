package ml.fasodocs.backend.dto.response;

import lombok.Data;
import java.util.List;

@Data
public class QuizQuestionResponse {
    private Long id;
    private String question;
    private String typeQuestion;
    private Integer points;
    private String niveau;
    private Integer ordre; // Ordre de la question dans le quiz (1, 2, 3, 4, 5)
    private Boolean estDebloquee; // Si la question est débloquée pour l'utilisateur
    private List<QuizReponseResponse> reponses;
}

