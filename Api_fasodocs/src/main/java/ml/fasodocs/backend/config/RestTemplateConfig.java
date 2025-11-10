package ml.fasodocs.backend.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
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
        return builder
                .setConnectTimeout(Duration.ofMillis(connectTimeout))
                .setReadTimeout(Duration.ofMillis(readTimeout))
                .build();
    }
}