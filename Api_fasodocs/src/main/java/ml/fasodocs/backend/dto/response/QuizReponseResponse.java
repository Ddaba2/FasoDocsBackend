package ml.fasodocs.backend.dto.response;

import lombok.Data;

@Data
public class QuizReponseResponse {
    private Long id;
    private String reponse;
    private Boolean estCorrecte;
    private Integer ordre;
}

