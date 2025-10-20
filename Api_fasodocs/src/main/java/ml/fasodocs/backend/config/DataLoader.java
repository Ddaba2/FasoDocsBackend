package ml.fasodocs.backend.config;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.core.io.ClassPathResource;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;

/**
 * Chargeur de données complet pour FasoDocs
 * Charge le fichier fasodocs-data-complete.sql
 */
@Component
public class DataLoader implements CommandLineRunner {

    private static final Logger logger = LoggerFactory.getLogger(DataLoader.class);

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @Override
    public void run(String... args) throws Exception {
        // Vérifier si les données sont déjà chargées
        if (isDataLoaded()) {
            logger.info("✅ Données FasoDocs déjà présentes. Chargement ignoré.");
            return;
        }

        logger.info("📊 Chargement des données FasoDocs complètes...");
        
        try {
            loadCompleteData();
            logger.info("🎉 Données FasoDocs chargées avec succès !");
        } catch (Exception e) {
            logger.error("❌ Erreur lors du chargement des données", e);
        }
    }

    private boolean isDataLoaded() {
        try {
            // Vérifier si des procédures existent déjà
            Integer count = jdbcTemplate.queryForObject(
                "SELECT COUNT(*) FROM procedures", Integer.class);
            return count != null && count > 0;
        } catch (Exception e) {
            return false;
        }
    }

    private void loadCompleteData() throws Exception {
        ClassPathResource resource = new ClassPathResource("fasodocs-data-complete.sql");
        
        try (BufferedReader reader = new BufferedReader(
                new InputStreamReader(resource.getInputStream(), StandardCharsets.UTF_8))) {
            
            StringBuilder sqlScript = new StringBuilder();
            String line;
            
            while ((line = reader.readLine()) != null) {
                // Ignorer les commentaires et lignes vides
                if (!line.trim().startsWith("--") && !line.trim().isEmpty()) {
                    sqlScript.append(line).append("\n");
                }
            }
            
            // Exécuter le script SQL
            String[] statements = sqlScript.toString().split(";");
            
            for (String statement : statements) {
                statement = statement.trim();
                if (!statement.isEmpty()) {
                    try {
                        jdbcTemplate.execute(statement);
                    } catch (Exception e) {
                        logger.warn("⚠️ Erreur lors de l'exécution de: {}", statement.substring(0, Math.min(50, statement.length())));
                        // Continuer avec les autres statements
                    }
                }
            }
        }
    }
}
