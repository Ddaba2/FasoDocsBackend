package ml.fasodocs.backend.dto.response;

import lombok.Data;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@Data
public class QuizParticipationResponse {
    private Long id;
    private Long quizJournalierId;
    private LocalDate dateQuiz;
    private Integer score;
    private Integer nombreBonnesReponses;
    private Integer nombreQuestions;
    private Integer tempsSecondes;
    private Boolean estComplete;
    private LocalDateTime dateParticipation;
    private List<QuizReponseUtilisateurResponse> reponses;
}

