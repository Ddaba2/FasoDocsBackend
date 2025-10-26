package ml.fasodocs.backend.repository;

import ml.fasodocs.backend.entity.SousCategorie;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
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
    
    /**
     * Recherche une sous-catégorie avec ses procédures chargées
     */
    @Query("SELECT DISTINCT sc FROM SousCategorie sc LEFT JOIN FETCH sc.procedures WHERE sc.id = :id")
    Optional<SousCategorie> findByIdWithProcedures(@Param("id") Long id);
    
    /**
     * Recherche toutes les sous-catégories avec leurs procédures chargées
     */
    @Query("SELECT DISTINCT sc FROM SousCategorie sc LEFT JOIN FETCH sc.procedures")
    List<SousCategorie> findAllWithProcedures();
    
    /**
     * Recherche les sous-catégories d'une catégorie avec leurs procédures chargées
     */
    @Query("SELECT DISTINCT sc FROM SousCategorie sc LEFT JOIN FETCH sc.procedures WHERE sc.categorie.id = :categorieId")
    List<SousCategorie> findByCategorieIdWithProcedures(@Param("categorieId") Long categorieId);
}

