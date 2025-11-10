package ml.fasodocs.backend.config;

import ml.fasodocs.backend.security.AuthEntryPointJwt;
import ml.fasodocs.backend.security.AuthTokenFilter;
import ml.fasodocs.backend.security.UserDetailsServiceImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;

import java.util.Arrays;

/**
 * Configuration de la sécurité Spring Security pour l'application FasoDocs
 * 
 * Cette classe configure :
 * - L'authentification JWT basée sur Spring Security
 * - Les règles d'autorisation pour les endpoints
 * - La configuration CORS pour permettre les requêtes depuis les frontends Angular/React
 * - Le provider d'authentification DAO avec encodage BCrypt
 * 
 * @author FasoDocs Team
 * @version 1.0
 */
@Configuration
@EnableWebSecurity
@EnableMethodSecurity
public class SecurityConfig {

    /** Service pour charger les détails des utilisateurs depuis la base de données */
    @Autowired
    private UserDetailsServiceImpl userDetailsService;

    /** Gestionnaire des erreurs d'authentification non autorisées */
    @Autowired
    private AuthEntryPointJwt unauthorizedHandler;

    /** 
     * Liste des origines autorisées pour CORS
     * Configurée dans application.properties : app.cors.allowed-origins
     * Par défaut : http://localhost:3000,http://localhost:4200
     */
    @Value("${app.cors.allowed-origins}")
    private String[] allowedOrigins;

    /**
     * Configure le filtre JWT pour l'authentification
     * Ce filtre intercepte toutes les requêtes et vérifie le token JWT
     * 
     * @return Le filtre JWT configuré
     */
    @Bean
    public AuthTokenFilter authenticationJwtTokenFilter() {
        return new AuthTokenFilter();
    }

    /**
     * Configure le provider d'authentification DAO
     * Utilise UserDetailsService pour charger les utilisateurs et BCrypt pour encoder les mots de passe
     * 
     * @return Le provider d'authentification configuré
     */
    @Bean
    public DaoAuthenticationProvider authenticationProvider() {
        DaoAuthenticationProvider authProvider = new DaoAuthenticationProvider();

        authProvider.setUserDetailsService(userDetailsService);
        authProvider.setPasswordEncoder(passwordEncoder());

        return authProvider;
    }

    /**
     * Configure le gestionnaire d'authentification
     * Utilisé pour l'authentification des utilisateurs avec username/password
     * 
     * @param authConfig Configuration d'authentification Spring
     * @return Le gestionnaire d'authentification
     * @throws Exception Si la configuration échoue
     */
    @Bean
    public AuthenticationManager authenticationManager(AuthenticationConfiguration authConfig) throws Exception {
        return authConfig.getAuthenticationManager();
    }

    /**
     * Configure l'encodeur de mots de passe BCrypt
     * BCrypt utilise un algorithme de hachage avec sel automatique
     * 
     * @return L'encodeur BCrypt
     */
    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    /**
     * Configure la chaîne de filtres de sécurité
     * Définit :
     * - Les endpoints publics (sans authentification)
     * - Les endpoints protégés (authentification requise)
     * - Les règles CORS
     * - La gestion des erreurs
     * - La stratégie de session stateless (JWT)
     * 
     * Endpoints publics :
     * - /auth/** : Authentification et inscription
     * - /public/** : Contenu public
     * - /procedures/** : Consultation des procédures
     * - /categories/** : Consultation des catégories
     * - /sous-categories/** : Consultation des sous-catégories
     * - /chatbot/** : API du chatbot
     * - /swagger-ui/** : Documentation API
     * 
     * Endpoints protégés :
     * - /signalements/** : Signalements (authentification requise)
     * - Tout autre endpoint : Authentification requise
     * 
     * @param http Configuration HTTP Security
     * @return La chaîne de filtres configurée
     * @throws Exception Si la configuration échoue
     */
    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http.cors().and().csrf().disable()
                .exceptionHandling().authenticationEntryPoint(unauthorizedHandler).and()
                .sessionManagement().sessionCreationPolicy(SessionCreationPolicy.STATELESS).and()
                .authorizeHttpRequests(auth ->
                        auth
                                .requestMatchers("/auth/**").permitAll()
                                .requestMatchers("/api/auth/**").permitAll()
                                .requestMatchers("/public/**").permitAll()
                                .requestMatchers("/procedures/**").permitAll()
                                .requestMatchers("/categories/**").permitAll()
                                .requestMatchers("/sous-categories/**").permitAll()
                                .requestMatchers("/lieux/**").permitAll()
                                .requestMatchers("/traductions/**").permitAll()
                                .requestMatchers("/chatbot/**").permitAll()
                                .requestMatchers("/signalements/**").authenticated()
                                .requestMatchers("/error").permitAll()
                                // Swagger/OpenAPI endpoints
                                .requestMatchers("/swagger-ui/**").permitAll()
                                .requestMatchers("/swagger-ui.html").permitAll()
                                .requestMatchers("/v3/api-docs/**").permitAll()
                                .requestMatchers("/api-docs/**").permitAll()
                                .requestMatchers("/swagger-resources/**").permitAll()
                                .requestMatchers("/webjars/**").permitAll()
                                .anyRequest().authenticated()
                );

        http.authenticationProvider(authenticationProvider());

        http.addFilterBefore(authenticationJwtTokenFilter(), UsernamePasswordAuthenticationFilter.class);

        return http.build();
    }

    /**
     * Configure la source de configuration CORS (Cross-Origin Resource Sharing)
     * 
     * Autorise les requêtes depuis les origines configurées dans application.properties
     * 
     * Configuration :
     * - Origines autorisées : http://localhost:3000 et http://localhost:4200 (configurables)
     * - Méthodes autorisées : GET, POST, PUT, DELETE, OPTIONS
     * - Headers autorisés : Tous (*)
     * - Credentials : Activés (nécessaire pour les cookies et headers d'authentification)
     * - Max Age : 3600 secondes (1 heure) pour le cache des pré-requêtes CORS
     * 
     * Cette configuration est appliquée à tous les endpoints (/**)
     * 
     * @return La source de configuration CORS
     */
    @Bean
    public CorsConfigurationSource corsConfigurationSource() {
        CorsConfiguration configuration = new CorsConfiguration();
        
        // Autoriser les origines via des patterns (ex: localhost:*, 192.168.*:*)
        configuration.setAllowedOriginPatterns(Arrays.asList(allowedOrigins));
        
        // Autoriser les méthodes HTTP standards
        configuration.setAllowedMethods(Arrays.asList("GET", "POST", "PUT", "DELETE", "OPTIONS"));
        
        // Autoriser tous les headers (nécessaire pour JWT)
        configuration.setAllowedHeaders(Arrays.asList("*"));
        
        // Autoriser l'envoi de cookies et credentials (important pour l'authentification)
        configuration.setAllowCredentials(true);
        
        // Durée de mise en cache des pré-requêtes CORS (en secondes)
        configuration.setMaxAge(3600L);

        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", configuration);
        return source;
    }
}