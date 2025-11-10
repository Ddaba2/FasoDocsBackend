package ml.fasodocs.backend.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Service pour vérifier la complétude des procédures par sous-catégorie
 */
@Service
public class VerificationService {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    /**
     * Résumé global des sous-catégories
     */
    public Map<String, Object> getResumeGlobal() {
        String sql = """
            SELECT 
                COUNT(DISTINCT sc.id) AS total,
                COUNT(DISTINCT CASE WHEN procedure_complete.id IS NOT NULL THEN sc.id END) AS avec_procedure_complete,
                COUNT(DISTINCT CASE WHEN procedure_complete.id IS NULL THEN sc.id END) AS sans_procedure_complete
            FROM sous_categories sc
            LEFT JOIN (
                SELECT DISTINCT p.sous_categorie_id, p.id
                FROM procedures p
                WHERE p.sous_categorie_id IS NOT NULL
                  AND p.centre_id IS NOT NULL
                  AND p.cout_id IS NOT NULL
                  AND p.delai IS NOT NULL 
                  AND TRIM(p.delai) != ''
                  AND (SELECT COUNT(*) FROM etapes e WHERE e.procedure_id = p.id) > 0
                  AND (SELECT COUNT(*) FROM documents_requis dr WHERE dr.procedure_id = p.id) > 0
                  AND (SELECT COUNT(*) FROM lois_articles la WHERE la.procedure_id = p.id) > 0
            ) procedure_complete ON sc.id = procedure_complete.sous_categorie_id
            """;
        
        return jdbcTemplate.queryForMap(sql);
    }

    /**
     * Liste des sous-catégories sans procédure complète
     */
    public List<Map<String, Object>> getSousCategoriesIncompletes() {
        String sql = """
            SELECT 
                cat.titre AS categorie,
                sc.titre AS sous_categorie,
                sc.id AS id_sous_categorie,
                COUNT(DISTINCT p.id) AS nb_procedures,
                COUNT(DISTINCT CASE WHEN p.centre_id IS NOT NULL THEN p.id END) AS procedures_avec_centre,
                COUNT(DISTINCT CASE WHEN p.cout_id IS NOT NULL THEN p.id END) AS procedures_avec_cout,
                COUNT(DISTINCT CASE WHEN p.delai IS NOT NULL AND TRIM(p.delai) != '' THEN p.id END) AS procedures_avec_delai,
                COUNT(DISTINCT CASE WHEN (SELECT COUNT(*) FROM etapes e WHERE e.procedure_id = p.id) > 0 THEN p.id END) AS procedures_avec_etapes,
                COUNT(DISTINCT CASE WHEN (SELECT COUNT(*) FROM documents_requis dr WHERE dr.procedure_id = p.id) > 0 THEN p.id END) AS procedures_avec_documents,
                COUNT(DISTINCT CASE WHEN (SELECT COUNT(*) FROM lois_articles la WHERE la.procedure_id = p.id) > 0 THEN p.id END) AS procedures_avec_lois
            FROM sous_categories sc
            INNER JOIN categories cat ON sc.categorie_id = cat.id
            LEFT JOIN procedures p ON sc.id = p.sous_categorie_id
            GROUP BY sc.id, sc.titre, cat.titre
            HAVING COUNT(DISTINCT CASE 
                WHEN p.centre_id IS NOT NULL 
                 AND p.cout_id IS NOT NULL 
                 AND p.delai IS NOT NULL 
                 AND TRIM(p.delai) != ''
                 AND (SELECT COUNT(*) FROM etapes e WHERE e.procedure_id = p.id) > 0
                 AND (SELECT COUNT(*) FROM documents_requis dr WHERE dr.procedure_id = p.id) > 0
                 AND (SELECT COUNT(*) FROM lois_articles la WHERE la.procedure_id = p.id) > 0
                THEN p.id 
            END) = 0
            ORDER BY cat.titre, sc.titre
            """;
        
        return jdbcTemplate.query(sql, (rs, rowNum) -> {
            Map<String, Object> row = new HashMap<>();
            row.put("categorie", rs.getString("categorie"));
            row.put("sous_categorie", rs.getString("sous_categorie"));
            row.put("id_sous_categorie", rs.getLong("id_sous_categorie"));
            row.put("nb_procedures", rs.getLong("nb_procedures"));
            row.put("procedures_avec_centre", rs.getLong("procedures_avec_centre"));
            row.put("procedures_avec_cout", rs.getLong("procedures_avec_cout"));
            row.put("procedures_avec_delai", rs.getLong("procedures_avec_delai"));
            row.put("procedures_avec_etapes", rs.getLong("procedures_avec_etapes"));
            row.put("procedures_avec_documents", rs.getLong("procedures_avec_documents"));
            row.put("procedures_avec_lois", rs.getLong("procedures_avec_lois"));
            return row;
        });
    }

    /**
     * Statistiques par catégorie
     */
    public List<Map<String, Object>> getStatistiquesParCategorie() {
        String sql = """
            SELECT 
                cat.titre AS categorie,
                COUNT(DISTINCT sc.id) AS total_sous_categories,
                COUNT(DISTINCT CASE 
                    WHEN EXISTS (
                        SELECT 1 
                        FROM procedures p
                        WHERE p.sous_categorie_id = sc.id
                          AND p.centre_id IS NOT NULL
                          AND p.cout_id IS NOT NULL
                          AND p.delai IS NOT NULL 
                          AND TRIM(p.delai) != ''
                          AND (SELECT COUNT(*) FROM etapes e WHERE e.procedure_id = p.id) > 0
                          AND (SELECT COUNT(*) FROM documents_requis dr WHERE dr.procedure_id = p.id) > 0
                          AND (SELECT COUNT(*) FROM lois_articles la WHERE la.procedure_id = p.id) > 0
                    ) THEN sc.id 
                END) AS sous_categories_completes,
                COUNT(DISTINCT CASE 
                    WHEN NOT EXISTS (
                        SELECT 1 
                        FROM procedures p
                        WHERE p.sous_categorie_id = sc.id
                          AND p.centre_id IS NOT NULL
                          AND p.cout_id IS NOT NULL
                          AND p.delai IS NOT NULL 
                          AND TRIM(p.delai) != ''
                          AND (SELECT COUNT(*) FROM etapes e WHERE e.procedure_id = p.id) > 0
                          AND (SELECT COUNT(*) FROM documents_requis dr WHERE dr.procedure_id = p.id) > 0
                          AND (SELECT COUNT(*) FROM lois_articles la WHERE la.procedure_id = p.id) > 0
                    ) THEN sc.id 
                END) AS sous_categories_incompletes,
                ROUND(
                    COUNT(DISTINCT CASE 
                        WHEN EXISTS (
                            SELECT 1 
                            FROM procedures p
                            WHERE p.sous_categorie_id = sc.id
                              AND p.centre_id IS NOT NULL
                              AND p.cout_id IS NOT NULL
                              AND p.delai IS NOT NULL 
                              AND TRIM(p.delai) != ''
                              AND (SELECT COUNT(*) FROM etapes e WHERE e.procedure_id = p.id) > 0
                              AND (SELECT COUNT(*) FROM documents_requis dr WHERE dr.procedure_id = p.id) > 0
                              AND (SELECT COUNT(*) FROM lois_articles la WHERE la.procedure_id = p.id) > 0
                        ) THEN sc.id 
                    END) * 100.0 / COUNT(DISTINCT sc.id), 
                    2
                ) AS taux_completude
            FROM categories cat
            INNER JOIN sous_categories sc ON cat.id = sc.categorie_id
            GROUP BY cat.id, cat.titre
            ORDER BY cat.titre
            """;
        
        return jdbcTemplate.query(sql, (rs, rowNum) -> {
            Map<String, Object> row = new HashMap<>();
            row.put("categorie", rs.getString("categorie"));
            row.put("total_sous_categories", rs.getLong("total_sous_categories"));
            row.put("sous_categories_completes", rs.getLong("sous_categories_completes"));
            row.put("sous_categories_incompletes", rs.getLong("sous_categories_incompletes"));
            row.put("taux_completude", rs.getDouble("taux_completude"));
            return row;
        });
    }

    /**
     * Détail des procédures incomplètes
     */
    public List<Map<String, Object>> getProceduresIncompletes() {
        String sql = """
            SELECT 
                cat.titre AS categorie,
                sc.titre AS sous_categorie,
                p.id AS id_procedure,
                p.titre AS titre_procedure,
                CASE WHEN p.centre_id IS NOT NULL THEN 1 ELSE 0 END AS a_centre,
                CASE WHEN p.cout_id IS NOT NULL THEN 1 ELSE 0 END AS a_cout,
                CASE WHEN p.delai IS NOT NULL AND TRIM(p.delai) != '' THEN 1 ELSE 0 END AS a_delai,
                CASE WHEN (SELECT COUNT(*) FROM etapes e WHERE e.procedure_id = p.id) > 0 THEN 1 ELSE 0 END AS a_etapes,
                CASE WHEN (SELECT COUNT(*) FROM documents_requis dr WHERE dr.procedure_id = p.id) > 0 THEN 1 ELSE 0 END AS a_documents,
                CASE WHEN (SELECT COUNT(*) FROM lois_articles la WHERE la.procedure_id = p.id) > 0 THEN 1 ELSE 0 END AS a_lois,
                (SELECT COUNT(*) FROM etapes e WHERE e.procedure_id = p.id) AS nb_etapes,
                (SELECT COUNT(*) FROM documents_requis dr WHERE dr.procedure_id = p.id) AS nb_documents,
                (SELECT COUNT(*) FROM lois_articles la WHERE la.procedure_id = p.id) AS nb_lois
            FROM sous_categories sc
            INNER JOIN categories cat ON sc.categorie_id = cat.id
            LEFT JOIN procedures p ON sc.id = p.sous_categorie_id
            WHERE p.id IS NOT NULL
              AND (
                p.centre_id IS NULL
                OR p.cout_id IS NULL
                OR p.delai IS NULL 
                OR TRIM(p.delai) = ''
                OR (SELECT COUNT(*) FROM etapes e WHERE e.procedure_id = p.id) = 0
                OR (SELECT COUNT(*) FROM documents_requis dr WHERE dr.procedure_id = p.id) = 0
                OR (SELECT COUNT(*) FROM lois_articles la WHERE la.procedure_id = p.id) = 0
              )
            ORDER BY cat.titre, sc.titre, p.titre
            """;
        
        return jdbcTemplate.query(sql, (rs, rowNum) -> {
            Map<String, Object> row = new HashMap<>();
            row.put("categorie", rs.getString("categorie"));
            row.put("sous_categorie", rs.getString("sous_categorie"));
            row.put("id_procedure", rs.getLong("id_procedure"));
            row.put("titre_procedure", rs.getString("titre_procedure"));
            row.put("a_centre", rs.getInt("a_centre") == 1);
            row.put("a_cout", rs.getInt("a_cout") == 1);
            row.put("a_delai", rs.getInt("a_delai") == 1);
            row.put("a_etapes", rs.getInt("a_etapes") == 1);
            row.put("a_documents", rs.getInt("a_documents") == 1);
            row.put("a_lois", rs.getInt("a_lois") == 1);
            row.put("nb_etapes", rs.getLong("nb_etapes"));
            row.put("nb_documents", rs.getLong("nb_documents"));
            row.put("nb_lois", rs.getLong("nb_lois"));
            return row;
        });
    }

    /**
     * Sous-catégories sans procédure
     */
    public List<Map<String, Object>> getSousCategoriesSansProcedure() {
        String sql = """
            SELECT 
                cat.titre AS categorie,
                sc.titre AS sous_categorie,
                sc.id AS id_sous_categorie
            FROM sous_categories sc
            INNER JOIN categories cat ON sc.categorie_id = cat.id
            WHERE NOT EXISTS (
                SELECT 1 
                FROM procedures p 
                WHERE p.sous_categorie_id = sc.id
            )
            ORDER BY cat.titre, sc.titre
            """;
        
        return jdbcTemplate.query(sql, (rs, rowNum) -> {
            Map<String, Object> row = new HashMap<>();
            row.put("categorie", rs.getString("categorie"));
            row.put("sous_categorie", rs.getString("sous_categorie"));
            row.put("id_sous_categorie", rs.getLong("id_sous_categorie"));
            return row;
        });
    }

    /**
     * Rapport complet de vérification
     */
    public Map<String, Object> getRapportComplet() {
        Map<String, Object> rapport = new HashMap<>();
        rapport.put("resume_global", getResumeGlobal());
        rapport.put("statistiques_par_categorie", getStatistiquesParCategorie());
        rapport.put("sous_categories_incompletes", getSousCategoriesIncompletes());
        rapport.put("procedures_incompletes", getProceduresIncompletes());
        rapport.put("sous_categories_sans_procedure", getSousCategoriesSansProcedure());
        return rapport;
    }
}

