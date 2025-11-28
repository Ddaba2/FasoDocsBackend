package ml.fasodocs.backend.dto.response;

import lombok.Data;
import java.time.LocalDate;
import java.util.List;

@Data
public class QuizJournalierResponse {
    private Long id;
    private LocalDate dateQuiz;
    private String niveau; // FACILE, MOYEN, DIFFICILE
    private Long procedureId;
    private String procedureNom;
    private Long categorieId;
    private String categorieTitre;
    private Boolean estActif;
    private List<QuizQuestionResponse> questions;
}

