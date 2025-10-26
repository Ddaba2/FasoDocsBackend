package ml.fasodocs.backend.dto.request;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Data;

/**
 * DTO pour la demande d'inscription d'un nouveau citoyen
 * 
 * Utilisé pour recevoir les données d'inscription depuis le frontend.
 * Contient les informations nécessaires pour créer un compte utilisateur :
 * - Téléphone : Numéro de téléphone du citoyen (formats acceptés : +223XXXXXXXX, 223XXXXXXXX)
 * - Email : Adresse email valide pour notifications et communications
 * - Mot de passe : Mot de passe sécurisé (minimum 6 caractères)
 * - Confirmation du mot de passe : Répétition du mot de passe pour validation
 * 
 * Validation automatique par Jakarta Bean Validation
 * 
 * @see ml.fasodocs.backend.controller.AuthController#inscrire(InscriptionRequest)
 * @see ml.fasodocs.backend.service.AuthService#inscrireCitoyen(InscriptionRequest)
 */
@Data
public class InscriptionRequest {

    /**
     * Numéro de téléphone du citoyen
     * Format attendu : +223XXXXXXXX ou 223XXXXXXXX
     * Longueur : entre 8 et 20 caractères
     */
    @NotBlank(message = "Le téléphone est obligatoire")
    @Size(min = 8, max = 20, message = "Le téléphone doit contenir entre 8 et 20 caractères")
    private String telephone;

    /**
     * Adresse email du citoyen
     * Utilisée pour les notifications et communications officielles
     */
    @NotBlank(message = "L'email est obligatoire")
    @Email(message = "Email invalide")
    private String email;

    /**
     * Mot de passe du compte
     * Doit être sécurisé (minimum 6 caractères)
     * Sera haché avec BCrypt avant stockage en base de données
     */
    @NotBlank(message = "Le mot de passe est obligatoire")
    @Size(min = 6, max = 40, message = "Le mot de passe doit contenir entre 6 et 40 caractères")
    private String motDePasse;

    /**
     * Confirmation du mot de passe
     * Doit correspondre exactement au champ motDePasse
     * Vérifié côté service avant inscription
     */
    @NotBlank(message = "La confirmation du mot de passe est obligatoire")
    private String confirmerMotDePasse;
}
