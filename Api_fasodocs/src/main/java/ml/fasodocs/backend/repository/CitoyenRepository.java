package ml.fasodocs.backend.repository;

import ml.fasodocs.backend.entity.Citoyen;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.Optional;

/**
 * Repository pour l'entité Citoyen
 * 
 * Fournit les opérations de base de données pour la gestion des citoyens.
 * Hérite de JpaRepository pour les opérations CRUD standard.
 * 
 * @see ml.fasodocs.backend.entity.Citoyen
 * @see ml.fasodocs.backend.service.AuthService
 */
@Repository
public interface CitoyenRepository extends JpaRepository<Citoyen, Long> {

    /**
     * Recherche un citoyen par son adresse email
     * 
     * @param email L'adresse email recherchée
     * @return Un Optional contenant le citoyen si trouvé, vide sinon
     */
    Optional<Citoyen> findByEmail(String email);

    /**
     * Recherche un citoyen par son numéro de téléphone
     * 
     * Utilisé pour l'authentification par SMS et la connexion par téléphone.
     * 
     * @param telephone Le numéro de téléphone recherché (ex: +223XXXXXXXX)
     * @return Un Optional contenant le citoyen si trouvé, vide sinon
     */
    Optional<Citoyen> findByTelephone(String telephone);

    /**
     * Vérifie si une adresse email existe déjà dans la base de données
     * 
     * Utilisé lors de l'inscription pour vérifier l'unicité de l'email.
     * 
     * @param email L'adresse email à vérifier
     * @return true si l'email existe, false sinon
     */
    boolean existsByEmail(String email);

    /**
     * Vérifie si un numéro de téléphone existe déjà dans la base de données
     * 
     * Utilisé lors de l'inscription pour vérifier l'unicité du téléphone.
     * 
     * @param telephone Le numéro de téléphone à vérifier
     * @return true si le téléphone existe, false sinon
     */
    boolean existsByTelephone(String telephone);

    /**
     * Recherche un citoyen par son code de vérification email
     * 
     * Utilisé pour la vérification de l'email lors de l'inscription.
     * 
     * @param codeVerification Le code de vérification
     * @return Un Optional contenant le citoyen si trouvé, vide sinon
     */
    Optional<Citoyen> findByCodeVerification(String codeVerification);

    /**
     * Recherche tous les citoyens actifs dans la base de données
     * 
     * @return Liste de tous les citoyens avec estActif = true
     */
    @Query("SELECT c FROM Citoyen c WHERE c.estActif = true")
    java.util.List<Citoyen> findAllActifs();

    /**
     * Recherche un citoyen par email ou téléphone
     * 
     * Utile pour l'authentification flexible où l'utilisateur peut utiliser
     * soit son email soit son téléphone comme identifiant.
     * 
     * @param identifiant L'email ou le téléphone du citoyen
     * @return Un Optional contenant le citoyen si trouvé, vide sinon
     */
    @Query("SELECT c FROM Citoyen c WHERE c.email = :identifiant OR c.telephone = :identifiant")
    Optional<Citoyen> findByEmailOrTelephone(@Param("identifiant") String identifiant);

    /**
     * Recherche tous les citoyens par rôle
     * 
     * @param role Le rôle recherché (USER ou ADMIN)
     * @return Liste des citoyens avec ce rôle
     */
    @Query("SELECT c FROM Citoyen c WHERE c.role = :role")
    java.util.List<Citoyen> findByRole(@Param("role") Citoyen.RoleCitoyen role);
}
