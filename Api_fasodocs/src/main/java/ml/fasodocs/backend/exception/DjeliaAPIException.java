package ml.fasodocs.backend.exception;

/**
 * Exception levée lors d'erreurs avec l'API Djelia AI
 */
public class DjeliaAPIException extends RuntimeException {
    
    private final int statusCode;
    private final String errorCode;
    
    public DjeliaAPIException(String message) {
        super(message);
        this.statusCode = 500;
        this.errorCode = "DJELIA_API_ERROR";
    }
    
    public DjeliaAPIException(String message, int statusCode) {
        super(message);
        this.statusCode = statusCode;
        this.errorCode = "DJELIA_API_ERROR";
    }
    
    public DjeliaAPIException(String message, int statusCode, String errorCode) {
        super(message);
        this.statusCode = statusCode;
        this.errorCode = errorCode;
    }
    
    public DjeliaAPIException(String message, Throwable cause) {
        super(message, cause);
        this.statusCode = 500;
        this.errorCode = "DJELIA_API_ERROR";
    }
    
    public int getStatusCode() {
        return statusCode;
    }
    
    public String getErrorCode() {
        return errorCode;
    }
}

