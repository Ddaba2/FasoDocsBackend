package ml.fasodocs.backend.dto.request;

import jakarta.validation.constraints.Pattern;
import lombok.Data;

/**
 * DTO pour la mise à jour du profil
 * Tous les champs sont optionnels pour permettre des mises à jour partielles
 */
@Data
public class MiseAJourProfilRequest {

    // Optionnel : permet de ne mettre à jour que certains champs
    private String nom;

    // Optionnel : permet de ne mettre à jour que certains champs
    private String prenom;

    @Pattern(
        regexp = "^(\\+?223)?[5-9]\\d{7}$|^[5-9]\\d{7}$",
        message = "Le numéro de téléphone doit commencer par 5, 6, 7, 8 ou 9 (ex: 70123456, 22370123456, +22370123456)"
    )
    private String telephone;

    private String languePreferee;
    
    private String photoProfil; // Photo de profil en Base64
    
    // Champ supplémentaire pour compatibilité avec les clients qui envoient nomComplet
    private String nomComplet;
    
    // Setter personnalisé pour extraire nom et prénom depuis nomComplet
    public void setNomComplet(String nomComplet) {
        this.nomComplet = nomComplet;
        if (nomComplet != null && !nomComplet.trim().isEmpty()) {
            String[] parties = nomComplet.trim().split("\s+", 2);
            if (parties.length >= 1) {
                this.prenom = parties[0];
            }
            if (parties.length >= 2) {
                this.nom = parties[1];
            }
        }
    }
}
