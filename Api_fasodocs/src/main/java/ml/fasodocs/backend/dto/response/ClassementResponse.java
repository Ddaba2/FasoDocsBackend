package ml.fasodocs.backend.dto.response;

import lombok.Data;
import java.util.List;

@Data
public class ClassementResponse {
    private String periode; // "HEBDOMADAIRE" ou "MENSUEL"
    private List<QuizStatistiqueResponse> classement;
    private Integer positionUtilisateur;
}

