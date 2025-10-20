package ml.fasodocs.backend.repository;

import ml.fasodocs.backend.entity.Procedure;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * Repository pour l'entité Procedure
 */
@Repository
public interface ProcedureRepository extends JpaRepository<Procedure, Long> {

    /**
     * Recherche des procédures par catégorie
     */
    List<Procedure> findByCategorieId(Long categorieId);

    /**
     * Recherche des procédures par nom (contient)
     */
    @Query("SELECT p FROM Procedure p WHERE LOWER(p.nom) LIKE LOWER(CONCAT('%', :nom, '%'))")
    List<Procedure> rechercherParNom(@Param("nom") String nom);

    /**
     * Recherche des procédures par titre (contient)
     */
    @Query("SELECT p FROM Procedure p WHERE LOWER(p.titre) LIKE LOWER(CONCAT('%', :titre, '%'))")
    List<Procedure> rechercherParTitre(@Param("titre") String titre);

    /**
     * Recherche toutes les procédures avec leurs documents requis
     */
    @Query("SELECT DISTINCT p FROM Procedure p LEFT JOIN FETCH p.documentsRequis")
    List<Procedure> findAllAvecDocuments();

    /**
     * Recherche toutes les procédures avec leurs centres de traitement
     */
    @Query("SELECT DISTINCT p FROM Procedure p LEFT JOIN FETCH p.centre")
    List<Procedure> findAllAvecCentres();

    /**
     * Recherche des procédures récemment modifiées
     */
    @Query("SELECT p FROM Procedure p ORDER BY p.dateModification DESC")
    List<Procedure> findRecentesModifications();
    
    /**
     * Recherche des procédures par sous-catégorie
     */
    List<Procedure> findBySousCategorieId(Long sousCategorieId);

    /**
     * Recherche des procédures par centre
     */
    List<Procedure> findByCentreId(Long centreId);

    /**
     * Recherche des procédures par coût
     */
    List<Procedure> findByCoutId(Long coutId);
}
