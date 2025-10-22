package ml.fasodocs.backend.config;

import ml.fasodocs.backend.dto.response.MessageResponse;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import java.util.HashMap;
import java.util.Map;

/**
 * Gestionnaire global des exceptions pour retourner des messages d'erreur clairs
 */
@RestControllerAdvice
public class GlobalExceptionHandler {

    /**
     * Gère les erreurs de validation des requêtes
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
     */
    @ExceptionHandler(RuntimeException.class)
    public ResponseEntity<?> handleRuntimeException(RuntimeException ex) {
        return ResponseEntity
                .status(HttpStatus.BAD_REQUEST)
                .body(MessageResponse.error(ex.getMessage()));
    }

    /**
     * Gère toutes les autres exceptions
     */
    @ExceptionHandler(Exception.class)
    public ResponseEntity<?> handleGenericException(Exception ex) {
        return ResponseEntity
                .status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body(MessageResponse.error("Erreur interne: " + ex.getMessage()));
    }
}




