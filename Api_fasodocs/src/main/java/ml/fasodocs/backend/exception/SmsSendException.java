package ml.fasodocs.backend.exception;

/**
 * Exception personnalisée pour les erreurs d'envoi de SMS
 */
public class SmsSendException extends RuntimeException {
    
    private final String errorCode;
    private final int httpStatus;
    
    public SmsSendException(String message, String errorCode, int httpStatus) {
        super(message);
        this.errorCode = errorCode;
        this.httpStatus = httpStatus;
    }
    
    public SmsSendException(String message, String errorCode, int httpStatus, Throwable cause) {
        super(message, cause);
        this.errorCode = errorCode;
        this.httpStatus = httpStatus;
    }
    
    public String getErrorCode() {
        return errorCode;
    }
    
    public int getHttpStatus() {
        return httpStatus;
    }
    
    @Override
    public String toString() {
        return String.format("SmsSendException{errorCode='%s', httpStatus=%d, message='%s'}", 
                errorCode, httpStatus, getMessage());
    }
}

