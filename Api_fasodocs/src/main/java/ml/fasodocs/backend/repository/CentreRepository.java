package ml.fasodocs.backend.repository;

import ml.fasodocs.backend.entity.Centre;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * Repository pour l'entité Centre
 */
@Repository
public interface CentreRepository extends JpaRepository<Centre, Long> {

    /**
     * Recherche un centre par nom
     */
    List<Centre> findByNomContainingIgnoreCase(String nom);

    /**
     * Recherche des centres par ville
     */
    List<Centre> findByAdresseContainingIgnoreCase(String ville);
}
