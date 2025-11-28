package ml.fasodocs.backend.dto.response;

import lombok.Data;

@Data
public class QuizReponseUtilisateurResponse {
    private Long questionId;
    private Long reponseChoisieId;
    private Boolean estCorrecte;
    private Integer pointsObtenus;
}

