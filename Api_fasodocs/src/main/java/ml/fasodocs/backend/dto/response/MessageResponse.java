package ml.fasodocs.backend.dto.response;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * DTO de réponse standard pour les opérations de l'API
 * 
 * Classe utilitaire pour standardiser les réponses de l'API FasoDocs.
 * Utilisée pour toutes les opérations qui retournent un simple message (succès ou erreur).
 * 
 * Structure :
 * - message : Message descriptif de l'opération (succès ou erreur)
 * - success : Indicateur booléen du succès de l'opération
 * - data : Données optionnelles à retourner (peut être null)
 * 
 * Méthodes statiques pour faciliter la création :
 * - success(String) : Crée une réponse de succès sans données
 * - success(String, Object) : Crée une réponse de succès avec données
 * - error(String) : Crée une réponse d'erreur
 * 
 * @see ml.fasodocs.backend.controller.AuthController
 * @see ml.fasodocs.backend.controller.ProcedureController
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class MessageResponse {
    
    /** Message descriptif de l'opération */
    private String message;
    
    /** Indicateur de succès de l'opération (true) ou d'échec (false) */
    private boolean success;
    
    /** Données optionnelles à retourner avec le message (peut être null) */
    private Object data;

    /**
     * Constructeur avec message et statut
     * 
     * @param message Message descriptif
     * @param success Statut de l'opération
     */
    public MessageResponse(String message, boolean success) {
        this.message = message;
        this.success = success;
        this.data = null;
    }

    /**
     * Crée une réponse de succès sans données
     * 
     * @param message Message de succès
     * @return MessageResponse avec success=true
     */
    public static MessageResponse success(String message) {
        return new MessageResponse(message, true);
    }

    /**
     * Crée une réponse de succès avec données
     * 
     * @param message Message de succès
     * @param data Données à retourner
     * @return MessageResponse avec success=true et data
     */
    public static MessageResponse success(String message, Object data) {
        MessageResponse response = new MessageResponse(message, true);
        response.setData(data);
        return response;
    }

    /**
     * Crée une réponse d'erreur
     * 
     * @param message Message d'erreur
     * @return MessageResponse avec success=false
     */
    public static MessageResponse error(String message) {
        return new MessageResponse(message, false);
    }
}
