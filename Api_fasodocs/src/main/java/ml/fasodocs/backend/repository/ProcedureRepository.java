package ml.fasodocs.backend.repository;

import ml.fasodocs.backend.entity.Procedure;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * Repository pour l'entité Procedure
 * 
 * Fournit les opérations de base de données pour la gestion des procédures administratives.
 * Hérite de JpaRepository pour les opérations CRUD standard.
 * 
 * @see ml.fasodocs.backend.entity.Procedure
 * @see ml.fasodocs.backend.service.ProcedureService
 */
@Repository
public interface ProcedureRepository extends JpaRepository<Procedure, Long> {

    /**
     * Recherche toutes les procédures d'une catégorie donnée
     * 
     * @param categorieId L'identifiant de la catégorie
     * @return Liste des procédures de cette catégorie
     */
    List<Procedure> findByCategorieId(Long categorieId);

    /**
     * Recherche des procédures par nom (recherche partielle, insensible à la casse)
     * 
     * La recherche est effectuée avec LIKE et ignore la casse.
     * Utilisé pour la recherche de procédures par les citoyens.
     * 
     * @param nom Le terme de recherche pour le nom de la procédure
     * @return Liste des procédures dont le nom contient le terme recherché
     */
    @Query("SELECT p FROM Procedure p WHERE LOWER(p.nom) LIKE LOWER(CONCAT('%', :nom, '%'))")
    List<Procedure> rechercherParNom(@Param("nom") String nom);

    /**
     * Recherche des procédures par titre (recherche partielle, insensible à la casse)
     * 
     * La recherche est effectuée avec LIKE et ignore la casse.
     * Utilisé pour la recherche de procédures par les citoyens.
     * 
     * @param titre Le terme de recherche pour le titre de la procédure
     * @return Liste des procédures dont le titre contient le terme recherché
     */
    @Query("SELECT p FROM Procedure p WHERE LOWER(p.titre) LIKE LOWER(CONCAT('%', :titre, '%'))")
    List<Procedure> rechercherParTitre(@Param("titre") String titre);

    /**
     * Recherche toutes les procédures avec leurs documents requis (eager loading)
     * 
     * Utilise une requête JQPL avec JOIN FETCH pour charger les documents requis
     * en une seule requête et éviter le problème N+1.
     * 
     * @return Liste des procédures avec leurs documents requis chargés
     */
    @Query("SELECT DISTINCT p FROM Procedure p LEFT JOIN FETCH p.documentsRequis")
    List<Procedure> findAllAvecDocuments();

    /**
     * Recherche toutes les procédures avec leurs centres de traitement (eager loading)
     * 
     * Utilise une requête JQPL avec JOIN FETCH pour charger les centres
     * en une seule requête et éviter le problème N+1.
     * 
     * @return Liste des procédures avec leurs centres chargés
     */
    @Query("SELECT DISTINCT p FROM Procedure p LEFT JOIN FETCH p.centre")
    List<Procedure> findAllAvecCentres();

    /**
     * Recherche des procédures récemment modifiées
     * 
     * Trie les procédures par date de modification décroissante.
     * Utile pour afficher les dernières modifications ou mises à jour.
     * 
     * @return Liste des procédures triées par date de modification (du plus récent au plus ancien)
     */
    @Query("SELECT p FROM Procedure p ORDER BY p.dateModification DESC")
    List<Procedure> findRecentesModifications();
    
    /**
     * Recherche toutes les procédures d'une sous-catégorie donnée
     * 
     * @param sousCategorieId L'identifiant de la sous-catégorie
     * @return Liste des procédures de cette sous-catégorie
     */
    List<Procedure> findBySousCategorieId(Long sousCategorieId);

    /**
     * Recherche toutes les procédures d'un centre donné
     * 
     * Utile pour afficher toutes les procédures disponibles dans un centre spécifique.
     * 
     * @param centreId L'identifiant du centre
     * @return Liste des procédures de ce centre
     */
    List<Procedure> findByCentreId(Long centreId);

    /**
     * Recherche toutes les procédures ayant un coût spécifique
     * 
     * @param coutId L'identifiant du coût
     * @return Liste des procédures ayant ce coût
     */
    List<Procedure> findByCoutId(Long coutId);
}
