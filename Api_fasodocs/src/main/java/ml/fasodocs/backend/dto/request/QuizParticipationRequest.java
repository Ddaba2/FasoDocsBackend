package ml.fasodocs.backend.dto.request;

import lombok.Data;
import jakarta.validation.constraints.NotNull;
import java.util.List;

@Data
public class QuizParticipationRequest {
    @NotNull(message = "L'ID du quiz est requis")
    private Long quizJournalierId;
    
    @NotNull(message = "Les réponses sont requises")
    private List<ReponseQuestion> reponses;
    
    private Integer tempsSecondes;

    @Data
    public static class ReponseQuestion {
        @NotNull(message = "L'ID de la question est requis")
        private Long questionId;
        
        @NotNull(message = "L'ID de la réponse choisie est requis")
        private Long reponseChoisieId;
    }
}

