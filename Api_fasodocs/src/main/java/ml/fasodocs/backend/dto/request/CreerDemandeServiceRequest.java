package ml.fasodocs.backend.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.time.LocalDate;

/**
 * DTO pour créer une demande de service
 */
@Data
public class CreerDemandeServiceRequest {

    @NotNull(message = "L'ID de la procédure est obligatoire")
    private Long procedureId;

    @NotBlank(message = "La commune est obligatoire")
    private String commune;

    private String quartier;

    private String telephoneContact;

    private LocalDate dateSouhaitee;

    private String commentaires;

    @NotNull(message = "L'acceptation du tarif est obligatoire")
    private Boolean accepteTarif;
}

