package ml.fasodocs.backend.dto.response;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * DTO de réponse contenant le token JWT et les informations du citoyen authentifié
 * 
 * Retourné après une connexion réussie (vérification SMS ou login classique).
 * Contient toutes les informations nécessaires au frontend pour :
 * - Stocker le token JWT pour les requêtes authentifiées
 * - Afficher le profil utilisateur
 * - Personnaliser l'interface selon la langue préférée
 * 
 * @see ml.fasodocs.backend.controller.AuthController
 * @see ml.fasodocs.backend.service.AuthService#verifierCodeSms
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class JwtResponse {
    
    /** Token JWT pour l'authentification des requêtes */
    private String token;
    
    /** Identifiant unique du citoyen */
    private Long id;
    
    /** Nom du citoyen */
    private String nom;
    
    /** Prénom du citoyen */
    private String prenom;
    
    /** Email du citoyen */
    private String email;
    
    /** Numéro de téléphone du citoyen */
    private String telephone;
    
    /** Langue préférée du citoyen (fr ou bm) */
    private String languePreferee;
}
