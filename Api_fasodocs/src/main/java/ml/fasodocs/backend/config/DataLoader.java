package ml.fasodocs.backend.config;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.core.io.ClassPathResource;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;

/**
 * Chargeur de données complet pour FasoDocs
 * Charge le fichier fasodocs-data-complete.sql automatiquement au démarrage
 */
@Component
public class DataLoader implements CommandLineRunner {

    private static final Logger logger = LoggerFactory.getLogger(DataLoader.class);

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @Override
    @Transactional
    public void run(String... args) throws Exception {
        // Vérifier si les données sont déjà chargées
        if (isDataLoaded()) {
            logger.info("✅ Données FasoDocs déjà présentes. Chargement ignoré.");
            logDataStats();
            return;
        }

        logger.info("📊 Chargement des données FasoDocs complètes...");
        logger.info("⏳ Ceci peut prendre quelques secondes...");
        
        try {
            loadCompleteData();
            logger.info("🎉 Données FasoDocs chargées avec succès !");
            logDataStats();
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
            
            // Désactiver temporairement les contraintes de clés étrangères
            try {
                jdbcTemplate.execute("SET FOREIGN_KEY_CHECKS = 0");
                logger.debug("🔓 Contraintes de clés étrangères désactivées");
            } catch (Exception e) {
                logger.warn("⚠️ Impossible de désactiver les contraintes FK");
            }
            
            List<String> statements = parseSQL(reader);
            int successCount = 0;
            int errorCount = 0;
            int totalStatements = statements.size();
            
            logger.info("📝 Exécution de {} requêtes SQL...", totalStatements);
            
            for (int i = 0; i < statements.size(); i++) {
                String statement = statements.get(i);
                
                try {
                    jdbcTemplate.execute(statement);
                    successCount++;
                    
                    // Logger le progrès tous les 50 statements
                    if ((i + 1) % 50 == 0) {
                        logger.info("⏳ Progrès: {}/{} requêtes exécutées", i + 1, totalStatements);
                    }
                } catch (Exception e) {
                    errorCount++;
                    // Logger l'erreur avec plus de détails
                    String preview = statement.length() > 150 
                        ? statement.substring(0, 150) + "..." 
                        : statement;
                    logger.warn("⚠️ Erreur SQL #{}: {} - {}", errorCount, e.getMessage(), preview);
                }
            }
            
            // Réactiver les contraintes de clés étrangères
            try {
                jdbcTemplate.execute("SET FOREIGN_KEY_CHECKS = 1");
                logger.debug("🔒 Contraintes de clés étrangères réactivées");
            } catch (Exception e) {
                logger.warn("⚠️ Impossible de réactiver les contraintes FK");
            }
            
            logger.info("📊 Résultat: {} succès, {} erreurs sur {} requêtes", 
                       successCount, errorCount, totalStatements);
        }
    }

    private List<String> parseSQL(BufferedReader reader) throws Exception {
        List<String> statements = new ArrayList<>();
        StringBuilder currentStatement = new StringBuilder();
        String line;
        
        while ((line = reader.readLine()) != null) {
            line = line.trim();
            
            // Ignorer les commentaires et lignes vides
            if (line.isEmpty() || line.startsWith("--")) {
                continue;
            }
            
            // Ignorer les commandes USE
            if (line.toUpperCase().startsWith("USE ")) {
                continue;
            }
            
            currentStatement.append(line).append(" ");
            
            // Si la ligne se termine par ';', c'est la fin d'un statement
            if (line.endsWith(";")) {
                String statement = currentStatement.toString().trim();
                // Enlever le ';' final
                if (statement.endsWith(";")) {
                    statement = statement.substring(0, statement.length() - 1).trim();
                }
                if (!statement.isEmpty()) {
                    statements.add(statement);
                }
                currentStatement = new StringBuilder();
            }
        }
        
        // Ajouter le dernier statement s'il existe
        if (currentStatement.length() > 0) {
            String statement = currentStatement.toString().trim();
            if (!statement.isEmpty()) {
                statements.add(statement);
            }
        }
        
        return statements;
    }

    private void logDataStats() {
        try {
            logger.info("================================================");
            logger.info("📊 Statistiques des données FasoDocs:");
            
            Integer categories = jdbcTemplate.queryForObject("SELECT COUNT(*) FROM categories", Integer.class);
            Integer sousCategories = jdbcTemplate.queryForObject("SELECT COUNT(*) FROM sous_categories", Integer.class);
            Integer procedures = jdbcTemplate.queryForObject("SELECT COUNT(*) FROM procedures", Integer.class);
            Integer centres = jdbcTemplate.queryForObject("SELECT COUNT(*) FROM centres", Integer.class);
            Integer etapes = jdbcTemplate.queryForObject("SELECT COUNT(*) FROM etapes", Integer.class);
            Integer documents = jdbcTemplate.queryForObject("SELECT COUNT(*) FROM documents_requis", Integer.class);
            Integer couts = jdbcTemplate.queryForObject("SELECT COUNT(*) FROM couts", Integer.class);
            Integer lois = jdbcTemplate.queryForObject("SELECT COUNT(*) FROM lois_articles", Integer.class);
            
            logger.info("   - Catégories: {}", categories);
            logger.info("   - Sous-catégories: {}", sousCategories);
            logger.info("   - Procédures: {}", procedures);
            logger.info("   - Centres: {}", centres);
            logger.info("   - Étapes: {}", etapes);
            logger.info("   - Documents requis: {}", documents);
            logger.info("   - Coûts: {}", couts);
            logger.info("   - Lois et articles: {}", lois);
            logger.info("================================================");
        } catch (Exception e) {
            logger.error("❌ Erreur lors de l'affichage des statistiques", e);
        }
    }
}
