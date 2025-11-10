package ml.fasodocs.backend.exception;

/**
 * Exception levée lors d'erreurs avec le cache Djelia
 */
public class DjeliaCacheException extends RuntimeException {
    
    public DjeliaCacheException(String message) {
        super(message);
    }
    
    public DjeliaCacheException(String message, Throwable cause) {
        super(message, cause);
    }
}

