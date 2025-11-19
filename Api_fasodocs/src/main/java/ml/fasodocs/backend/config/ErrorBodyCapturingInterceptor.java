package ml.fasodocs.backend.config;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpRequest;
import org.springframework.http.client.ClientHttpRequestExecution;
import org.springframework.http.client.ClientHttpRequestInterceptor;
import org.springframework.http.client.ClientHttpResponse;
import org.springframework.util.StreamUtils;

import java.io.IOException;
import java.nio.charset.StandardCharsets;

/**
 * Interceptor pour capturer le body des réponses d'erreur HTTP
 * avant que RestTemplate ne le consomme
 */
public class ErrorBodyCapturingInterceptor implements ClientHttpRequestInterceptor {
    
    private static final Logger logger = LoggerFactory.getLogger(ErrorBodyCapturingInterceptor.class);
    
    @Override
    public ClientHttpResponse intercept(
            HttpRequest request,
            byte[] body,
            ClientHttpRequestExecution execution) throws IOException {
        
        ClientHttpResponse response = execution.execute(request, body);
        
        // Si c'est une erreur HTTP (4xx ou 5xx), capturer le body
        if (response.getStatusCode().is4xxClientError() || response.getStatusCode().is5xxServerError()) {
            try {
                // Vérifier que le body est disponible
                if (response.getBody() != null) {
                    // Lire le body AVANT de créer le wrapper
                    // Utiliser un try-with-resources pour s'assurer que le stream est bien géré
                    byte[] responseBody;
                    try (java.io.InputStream bodyStream = response.getBody()) {
                        responseBody = StreamUtils.copyToByteArray(bodyStream);
                    }
                    
                    String bodyAsString = new String(responseBody, StandardCharsets.UTF_8);
                    
                    // Stocker dans ThreadLocal pour accès ultérieur
                    CustomResponseErrorHandler.setErrorBody(bodyAsString);
                    
                    logger.error("❌ Erreur HTTP {} capturée par Interceptor - Body ({} bytes): {}", 
                        response.getStatusCode(), 
                        responseBody.length,
                        bodyAsString);
                    
                    // Créer une nouvelle réponse avec le body en mémoire pour permettre la relecture
                    return new BufferedClientHttpResponse(response, responseBody);
                } else {
                    logger.warn("⚠️ Body d'erreur null pour le status {}", response.getStatusCode());
                }
            } catch (java.io.IOException e) {
                // Si on ne peut pas lire le body (stream déjà fermé, etc.)
                logger.error("❌ Erreur lors de la capture du body (IOException): {}", e.getMessage());
                logger.debug("Stack trace:", e);
                // Essayer de lire depuis les headers si disponible
                if (response.getHeaders().containsKey("Content-Length")) {
                    String contentLength = response.getHeaders().getFirst("Content-Length");
                    logger.warn("⚠️ Body non lisible mais Content-Length indique {} bytes", contentLength);
                }
            } catch (Exception e) {
                logger.error("❌ Erreur inattendue lors de la capture du body: {}", e.getMessage(), e);
            }
        }
        
        return response;
    }
    
    /**
     * Wrapper pour ClientHttpResponse qui permet de relire le body
     * Implémente toutes les méthodes nécessaires pour éviter les problèmes de stream
     */
    private static class BufferedClientHttpResponse implements ClientHttpResponse {
        @SuppressWarnings("unused")
        private final ClientHttpResponse originalResponse; // Gardé pour référence, mais on utilise les copies
        private final byte[] body;
        private final org.springframework.http.HttpHeaders headers;
        private final org.springframework.http.HttpStatusCode statusCode;
        private final String statusText;
        
        public BufferedClientHttpResponse(ClientHttpResponse originalResponse, byte[] body) throws IOException {
            this.originalResponse = originalResponse;
            this.body = body;
            // Copier les headers et le status pour éviter de dépendre de l'original après fermeture
            this.headers = new org.springframework.http.HttpHeaders();
            this.headers.putAll(originalResponse.getHeaders());
            this.statusCode = originalResponse.getStatusCode();
            this.statusText = originalResponse.getStatusText();
        }
        
        @Override
        public java.io.InputStream getBody() throws IOException {
            return new java.io.ByteArrayInputStream(body);
        }
        
        @Override
        public org.springframework.http.HttpHeaders getHeaders() {
            return headers;
        }
        
        @Override
        public org.springframework.http.HttpStatusCode getStatusCode() throws IOException {
            return statusCode;
        }
        
        @Override
        public String getStatusText() throws IOException {
            return statusText;
        }
        
        @Override
        public void close() {
            // Ne pas fermer l'original car il peut déjà être fermé
            // Juste nettoyer les ressources locales si nécessaire
        }
    }
}

