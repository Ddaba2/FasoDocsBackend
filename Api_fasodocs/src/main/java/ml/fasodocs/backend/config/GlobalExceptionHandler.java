package ml.fasodocs.backend.config;

import ml.fasodocs.backend.dto.response.MessageResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import java.util.HashMap;
import java.util.Map;

/**
 * Gestionnaire global des exceptions pour retourner des messages d'erreur clairs
 * 
 * Ce handler intercepte toutes les exceptions non gérées dans les contrôleurs
 * et retourne des réponses JSON standardisées avec les codes HTTP appropriés.
 * 
 * @author FasoDocs Team
 * @version 1.0
 */
@RestControllerAdvice
public class GlobalExceptionHandler {

    private static final Logger logger = LoggerFactory.getLogger(GlobalExceptionHandler.class);

    /**
     * Gère les erreurs de validation des requêtes Bean Validation
     * 
     * Intercepte les erreurs de validation (@Valid, @NotBlank, @Email, etc.)
     * et retourne un message d'erreur structuré avec tous les champs invalides.
     * 
     * @param ex Exception de validation des arguments de méthode
     * @return Réponse HTTP 400 (Bad Request) avec les erreurs de validation
     */
    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<?> handleValidationExceptions(MethodArgumentNotValidException ex) {
        Map<String, String> errors = new HashMap<>();
        
        ex.getBindingResult().getAllErrors().forEach((error) -> {
            String fieldName = ((FieldError) error).getField();
            String errorMessage = error.getDefaultMessage();
            errors.put(fieldName, errorMessage);
        });

        // Créer un message clair
        StringBuilder message = new StringBuilder("Erreur de validation: ");
        errors.forEach((field, msg) -> message.append(field).append(": ").append(msg).append("; "));

        return ResponseEntity
                .status(HttpStatus.BAD_REQUEST)
                .body(MessageResponse.error(message.toString()));
    }

    /**
     * Gère les RuntimeException génériques
     * 
     * Capture les exceptions à l'exécution levées dans les services
     * (ex: utilisateur non trouvé, violation de règles métier, etc.)
     * 
     * @param ex Exception à l'exécution
     * @return Réponse HTTP 400 (Bad Request) avec le message d'erreur
     */
    @ExceptionHandler(RuntimeException.class)
    public ResponseEntity<?> handleRuntimeException(RuntimeException ex) {
        logger.warn("RuntimeException capturée: {}", ex.getMessage());
        return ResponseEntity
                .status(HttpStatus.BAD_REQUEST)
                .body(MessageResponse.error(ex.getMessage()));
    }

    /**
     * Gère les erreurs d'accès refusé (403 Forbidden)
     * 
     * Intercepte les erreurs Spring Security lorsque l'utilisateur
     * n'a pas les permissions nécessaires pour accéder à une ressource.
     * 
     * @param ex Exception d'accès refusé
     * @return Réponse HTTP 403 (Forbidden)
     */
    @ExceptionHandler(AccessDeniedException.class)
    public ResponseEntity<?> handleAccessDenied(AccessDeniedException ex) {
        logger.warn("Accès refusé: {}", ex.getMessage());
        return ResponseEntity
                .status(HttpStatus.FORBIDDEN)
                .body(MessageResponse.error("Accès refusé : vous n'avez pas les permissions nécessaires"));
    }

    /**
     * Gère toutes les autres exceptions non gérées
     * 
     * Handler catch-all pour toutes les exceptions non prévues.
     * Les détails complets sont loggés pour le debugging.
     * 
     * @param ex Exception non gérée
     * @return Réponse HTTP 500 (Internal Server Error) avec message générique
     */
    @ExceptionHandler(Exception.class)
    public ResponseEntity<?> handleGenericException(Exception ex) {
        // Logger l'exception complète pour le debugging
        logger.error("Exception non gérée capturée", ex);
        
        // Retourner un message générique sans exposer les détails internes
        return ResponseEntity
                .status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body(MessageResponse.error("Une erreur inattendue s'est produite. Veuillez réessayer plus tard."));
    }
}




