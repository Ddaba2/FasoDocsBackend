package ml.fasodocs.backend.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.client.BufferingClientHttpRequestFactory;
import org.springframework.http.client.SimpleClientHttpRequestFactory;
import org.springframework.web.client.RestTemplate;
import org.springframework.boot.web.client.RestTemplateBuilder;
import java.time.Duration;

/**
 * Configuration pour RestTemplate
 */
@Configuration
public class RestTemplateConfig {

    @Value("${rest.template.connect.timeout:120000}")
    private int connectTimeout;
    
    @Value("${rest.template.read.timeout:600000}")
    private int readTimeout;

    @Bean
    public RestTemplate restTemplate(RestTemplateBuilder builder) {
        // Utiliser BufferingClientHttpRequestFactory pour permettre la relecture du body
        // Cela permet de lire le body d'erreur même après que RestTemplate ait fermé le stream
        SimpleClientHttpRequestFactory requestFactory = new SimpleClientHttpRequestFactory();
        requestFactory.setConnectTimeout((int) Duration.ofMillis(connectTimeout).toMillis());
        requestFactory.setReadTimeout((int) Duration.ofMillis(readTimeout).toMillis());
        
        BufferingClientHttpRequestFactory bufferingFactory = new BufferingClientHttpRequestFactory(requestFactory);
        
        RestTemplate restTemplate = builder
                .requestFactory(() -> bufferingFactory)
                .setConnectTimeout(Duration.ofMillis(connectTimeout))
                .setReadTimeout(Duration.ofMillis(readTimeout))
                .build();
        
        // Ajouter l'interceptor pour capturer le body d'erreur AVANT qu'il ne soit consommé
        restTemplate.getInterceptors().add(new ErrorBodyCapturingInterceptor());
        
        // ErrorHandler personnalisé pour capturer le body des réponses d'erreur
        // Avec BufferingClientHttpRequestFactory, le body peut être relu plusieurs fois
        restTemplate.setErrorHandler(new CustomResponseErrorHandler());
        
        return restTemplate;
    }
}