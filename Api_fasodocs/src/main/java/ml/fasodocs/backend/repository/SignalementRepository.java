package ml.fasodocs.backend.repository;

import ml.fasodocs.backend.entity.Signalement;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import org.springframework.data.repository.query.Param;

import java.time.LocalDateTime;
import java.util.List;

/**
 * Repository pour la gestion des signalements
 */
@Repository
public interface SignalementRepository extends JpaRepository<Signalement, Long> {

    /**
     * Récupère tous les signalements d'un citoyen
     */
    List<Signalement> findByCitoyenIdOrderByDateCreationDesc(Long citoyenId);

    /**
     * Récupère les signalements d'une procédure spécifique
     */
    List<Signalement> findByProcedureIdOrderByDateCreationDesc(Long procedureId);

    /**
     * Récupère les signalements par type
     */
    List<Signalement> findByTypeOrderByDateCreationDesc(Signalement.TypeSignalement type);

    /**
     * Compte les signalements d'un citoyen
     */
    long countByCitoyenId(Long citoyenId);

    /**
     * Récupère les signalements récents (dernières 24h)
     */
    @Query("SELECT s FROM Signalement s WHERE s.dateCreation >= :dateLimite ORDER BY s.dateCreation DESC")
    List<Signalement> findSignalementsRecents(@Param("dateLimite") LocalDateTime dateLimite);
}
