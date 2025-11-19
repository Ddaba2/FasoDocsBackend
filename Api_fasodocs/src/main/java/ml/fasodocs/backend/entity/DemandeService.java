package ml.fasodocs.backend.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;
import com.fasterxml.jackson.annotation.JsonBackReference;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * Entité représentant une demande de service de procédure administrative
 */
@Entity
@Table(name = "demandes_service")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString(exclude = {"citoyen", "procedure", "agent"})
@EqualsAndHashCode(exclude = {"citoyen", "procedure", "agent"})
public class DemandeService {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "citoyen_id", nullable = false)
    @JsonBackReference
    private Citoyen citoyen;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "procedure_id", nullable = false)
    private Procedure procedure;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private StatutDemande statut = StatutDemande.EN_ATTENTE;

    @Column(nullable = false, precision = 10, scale = 2)
    private BigDecimal tarif; // Tarif convenu (frais de service + coût légal)

    @Column(name = "tarif_service", nullable = false, precision = 10, scale = 2)
    private BigDecimal tarifService; // Frais de service uniquement (selon commune)

    @Column(name = "cout_legal", precision = 10, scale = 2)
    private BigDecimal coutLegal; // Coût légal de la procédure

    @Column(name = "commune", nullable = false, length = 100)
    private String commune; // Commune de résidence

    @Column(name = "quartier", length = 100)
    private String quartier;

    @Column(name = "telephone_contact", length = 20)
    private String telephoneContact;

    @Column(name = "date_souhaitee")
    private LocalDate dateSouhaitee; // Date souhaitée de réalisation

    @Column(columnDefinition = "TEXT")
    private String commentaires; // Instructions spéciales du client

    @Column(name = "notes_agent", columnDefinition = "TEXT")
    private String notesAgent; // Notes internes de l'agent

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "agent_id")
    private Citoyen agent; // Agent assigné (si ADMIN)

    @Column(name = "date_acceptation")
    private LocalDateTime dateAcceptation;

    @Column(name = "date_debut")
    private LocalDateTime dateDebut; // Quand l'agent a commencé

    @Column(name = "date_fin")
    private LocalDateTime dateFin; // Quand la procédure est terminée

    @CreationTimestamp
    @Column(name = "date_creation", updatable = false)
    private LocalDateTime dateCreation;

    @UpdateTimestamp
    @Column(name = "date_modification")
    private LocalDateTime dateModification;

    /**
     * Enum pour les statuts de la demande
     */
    public enum StatutDemande {
        EN_ATTENTE,    // En attente de traitement (statut initial automatique)
        EN_COURS,      // Traitement en cours (changé par l'admin)
        TERMINEE       // Procédure terminée (changé par l'admin)
    }
}

