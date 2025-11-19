package ml.fasodocs.backend.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * DTO pour la réponse d'une demande de service
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class DemandeServiceResponse {
    private Long id;
    private ProcedureSimpleResponse procedure;
    private String statut;
    private BigDecimal tarif;
    private BigDecimal tarifService;
    private BigDecimal coutLegal;
    private String commune;
    private String quartier;
    private String telephoneContact;
    private LocalDate dateSouhaitee;
    private String commentaires;
    private String notesAgent;
    private CitoyenSimpleResponse agent;
    private LocalDateTime dateAcceptation;
    private LocalDateTime dateDebut;
    private LocalDateTime dateFin;
    private LocalDateTime dateCreation;
    private LocalDateTime dateModification;

    /**
     * Classe interne pour représenter une procédure simplifiée
     */
    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class ProcedureSimpleResponse {
        private Long id;
        private String nom;
        private String titre;
    }

    /**
     * Classe interne pour représenter un citoyen simplifié
     */
    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class CitoyenSimpleResponse {
        private Long id;
        private String nom;
        private String prenom;
        private String telephone;
    }
}

