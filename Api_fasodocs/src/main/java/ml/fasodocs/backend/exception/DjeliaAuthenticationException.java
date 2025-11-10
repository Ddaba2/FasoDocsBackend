package ml.fasodocs.backend.exception;

/**
 * Exception levée lors d'erreurs d'authentification avec Djelia AI
 */
public class DjeliaAuthenticationException extends DjeliaAPIException {
    
    public DjeliaAuthenticationException(String message) {
        super(message, 401, "DJELIA_AUTH_ERROR");
    }
    
    public DjeliaAuthenticationException(String message, Throwable cause) {
        super(message, cause);
    }
}

