package ml.fasodocs.backend.repository;

import ml.fasodocs.backend.entity.Etape;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * Repository pour l'entité Etape
 */
@Repository
public interface EtapeRepository extends JpaRepository<Etape, Long> {

    /**
     * Recherche des étapes par procédure
     */
    List<Etape> findByProcedureIdOrderByNiveauAsc(Long procedureId);

    /**
     * Recherche des étapes par niveau
     */
    List<Etape> findByNiveau(Integer niveau);
}
