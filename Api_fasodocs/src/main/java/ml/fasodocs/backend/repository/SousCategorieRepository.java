package ml.fasodocs.backend.repository;

import ml.fasodocs.backend.entity.SousCategorie;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

/**
 * Repository pour l'entité SousCategorie
 */
@Repository
public interface SousCategorieRepository extends JpaRepository<SousCategorie, Long> {

    /**
     * Recherche une sous-catégorie par titre
     */
    Optional<SousCategorie> findByTitre(String titre);

    /**
     * Vérifie si une sous-catégorie existe par titre
     */
    boolean existsByTitre(String titre);
    
    /**
     * Recherche toutes les sous-catégories d'une catégorie
     */
    List<SousCategorie> findByCategorieId(Long categorieId);
}

