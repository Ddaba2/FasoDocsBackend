package ml.fasodocs.backend.exception;

/**
 * Exception levée lorsque le quota de l'API Djelia est dépassé
 */
public class DjeliaQuotaExceededException extends DjeliaAPIException {
    
    public DjeliaQuotaExceededException(String message) {
        super(message, 429, "DJELIA_QUOTA_EXCEEDED");
    }
    
    public DjeliaQuotaExceededException(String message, Throwable cause) {
        super(message, cause);
    }
}

