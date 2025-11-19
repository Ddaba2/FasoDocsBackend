package ml.fasodocs.backend.repository;

import ml.fasodocs.backend.entity.DemandeService;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * Repository pour l'entité DemandeService
 */
@Repository
public interface DemandeServiceRepository extends JpaRepository<DemandeService, Long> {

    /**
     * Récupère toutes les demandes d'un citoyen, triées par date de création (plus récentes en premier)
     */
    List<DemandeService> findByCitoyenIdOrderByDateCreationDesc(Long citoyenId);

    /**
     * Récupère toutes les demandes d'une procédure
     */
    List<DemandeService> findByProcedureId(Long procedureId);

    /**
     * Récupère toutes les demandes par statut
     */
    List<DemandeService> findByStatut(DemandeService.StatutDemande statut);

    /**
     * Récupère toutes les demandes d'un agent
     */
    List<DemandeService> findByAgentIdOrderByDateCreationDesc(Long agentId);
}

