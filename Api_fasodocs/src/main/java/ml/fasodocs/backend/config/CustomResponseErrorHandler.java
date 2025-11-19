package ml.fasodocs.backend.config;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.client.ClientHttpResponse;
import org.springframework.util.StreamUtils;
import org.springframework.web.client.DefaultResponseErrorHandler;

import java.io.IOException;
import java.nio.charset.StandardCharsets;

/**
 * ErrorHandler personnalisé pour capturer le body des réponses d'erreur HTTP
 * avant que RestTemplate ne ferme le stream
 */
public class CustomResponseErrorHandler extends DefaultResponseErrorHandler {
    
    private static final Logger logger = LoggerFactory.getLogger(CustomResponseErrorHandler.class);
    
    // ThreadLocal pour stocker le body d'erreur et le rendre accessible dans le catch
    private static final ThreadLocal<String> errorBodyStorage = new ThreadLocal<>();
    
    /**
     * Récupère le body d'erreur capturé pour le thread courant
     */
    public static String getCapturedErrorBody() {
        return errorBodyStorage.get();
    }
    
    /**
     * Nettoie le ThreadLocal après utilisation
     */
    public static void clearErrorBody() {
        errorBodyStorage.remove();
    }
    
    /**
     * Définit le body d'erreur (utilisé par l'interceptor)
     */
    public static void setErrorBody(String errorBody) {
        errorBodyStorage.set(errorBody);
    }
    
    @Override
    public void handleError(ClientHttpResponse response) throws IOException {
        // Lire le body AVANT d'appeler super.handleError() qui pourrait fermer le stream
        String errorBody = null;
        try {
            if (response.getBody() != null) {
                errorBody = StreamUtils.copyToString(response.getBody(), StandardCharsets.UTF_8);
                // Stocker dans ThreadLocal pour accès ultérieur
                errorBodyStorage.set(errorBody);
                logger.error("❌ Erreur HTTP {} - Body capturé ({} bytes): {}", 
                    response.getStatusCode(), 
                    errorBody.length(),
                    errorBody);
            }
        } catch (Exception e) {
            logger.error("Impossible de lire le body d'erreur: {}", e.getMessage());
            errorBodyStorage.remove();
        }
        
        // Appeler la méthode parente qui va lancer l'exception
        // Le body est déjà lu, stocké dans ThreadLocal et loggé
        super.handleError(response);
    }
}

