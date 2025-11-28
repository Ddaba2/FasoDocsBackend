package ml.fasodocs.backend.dto.request;

import lombok.Data;
import jakarta.validation.constraints.NotNull;
import java.time.LocalDate;
import java.util.List;

/**
 * DTO pour la mise à jour d'un quiz journalier
 * Tous les champs sont optionnels pour permettre des mises à jour partielles
 */
@Data
public class QuizJournalierUpdateRequest {

    private LocalDate dateQuiz;

    private Long procedureId;

    private Long categorieId;

    private Boolean estActif;

    /**
     * Liste des questions à mettre à jour
     * Si fourni, remplace toutes les questions existantes
     */
    private List<QuestionUpdate> questions;

    @Data
    public static class QuestionUpdate {
        private Long id; // ID de la question existante (pour mise à jour) ou null (pour création)
        
        @NotNull(message = "La question en français est requise")
        private String questionFr;
        
        @NotNull(message = "La question en anglais est requise")
        private String questionEn;
        
        private String typeQuestion; // DELAI, COUT, DOCUMENT, CENTRE, ETAPE, LOI
        
        private Long procedureId;
        
        @NotNull(message = "La réponse correcte est requise")
        private String reponseCorrecte;
        
        private Integer points = 10;
        
        private String niveau = "FACILE"; // FACILE, MOYEN, DIFFICILE
        
        /**
         * Liste des réponses possibles
         * Si fourni, remplace toutes les réponses existantes pour cette question
         */
        private List<ReponseUpdate> reponses;
    }

    @Data
    public static class ReponseUpdate {
        private Long id; // ID de la réponse existante (pour mise à jour) ou null (pour création)
        
        @NotNull(message = "La réponse en français est requise")
        private String reponseFr;
        
        @NotNull(message = "La réponse en anglais est requise")
        private String reponseEn;
        
        @NotNull(message = "Le statut correct/incorrect est requis")
        private Boolean estCorrecte;
        
        private Integer ordre;
    }
}





