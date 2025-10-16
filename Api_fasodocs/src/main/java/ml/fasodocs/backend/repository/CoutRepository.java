package ml.fasodocs.backend.repository;

import ml.fasodocs.backend.entity.Cout;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * Repository pour l'entité Cout
 */
@Repository
public interface CoutRepository extends JpaRepository<Cout, Long> {

    /**
     * Recherche des coûts par prix maximum
     */
    List<Cout> findByPrixLessThanEqual(Integer prixMax);

    /**
     * Recherche des coûts par nom
     */
    List<Cout> findByNomContainingIgnoreCase(String nom);

    /**
     * Recherche des coûts par prix entre min et max
     */
    List<Cout> findByPrixBetween(Integer prixMin, Integer prixMax);
}
