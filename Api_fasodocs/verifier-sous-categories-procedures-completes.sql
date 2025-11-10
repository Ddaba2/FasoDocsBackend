-- ============================================================================
-- Script de vérification des sous-catégories et leurs procédures complètes
-- ============================================================================
-- Vérifie si toutes les sous-catégories ont au moins une procédure complète avec:
-- - Un centre lié (centre_id IS NOT NULL)
-- - Un coût lié (cout_id IS NOT NULL)
-- - Au moins une étape (COUNT > 0)
-- - Au moins un document requis (COUNT > 0)
-- - Au moins une référence de loi (COUNT > 0)
-- - Un délai de traitement renseigné (delai IS NOT NULL et != '')
-- ============================================================================

-- ============================================================================
-- 1. RÉSUMÉ GLOBAL
-- ============================================================================

SELECT 
    COUNT(DISTINCT sc.id) AS 'Total sous-catégories',
    COUNT(DISTINCT CASE WHEN procedure_complete.id IS NOT NULL THEN sc.id END) AS 'Sous-catégories avec procédure complète',
    COUNT(DISTINCT CASE WHEN procedure_complete.id IS NULL THEN sc.id END) AS 'Sous-catégories sans procédure complète'
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
) procedure_complete ON sc.id = procedure_complete.sous_categorie_id;

-- ============================================================================
-- 2. DÉTAIL PAR SOUS-CATÉGORIE - SOUS-CATÉGORIES SANS PROCÉDURE COMPLÈTE
-- ============================================================================

SELECT 
    cat.titre AS 'Catégorie',
    sc.titre AS 'Sous-catégorie',
    sc.id AS 'ID Sous-catégorie',
    COUNT(DISTINCT p.id) AS 'Nb procédures',
    COUNT(DISTINCT CASE WHEN p.id IS NOT NULL THEN p.id END) AS 'Nb procédures liées',
    -- Vérifications détaillées
    COUNT(DISTINCT CASE WHEN p.centre_id IS NOT NULL THEN p.id END) AS 'Procédures avec centre',
    COUNT(DISTINCT CASE WHEN p.cout_id IS NOT NULL THEN p.id END) AS 'Procédures avec coût',
    COUNT(DISTINCT CASE WHEN p.delai IS NOT NULL AND TRIM(p.delai) != '' THEN p.id END) AS 'Procédures avec délai',
    COUNT(DISTINCT CASE WHEN (SELECT COUNT(*) FROM etapes e WHERE e.procedure_id = p.id) > 0 THEN p.id END) AS 'Procédures avec étapes',
    COUNT(DISTINCT CASE WHEN (SELECT COUNT(*) FROM documents_requis dr WHERE dr.procedure_id = p.id) > 0 THEN p.id END) AS 'Procédures avec documents',
    COUNT(DISTINCT CASE WHEN (SELECT COUNT(*) FROM lois_articles la WHERE la.procedure_id = p.id) > 0 THEN p.id END) AS 'Procédures avec lois',
    -- Procédures complètes
    COUNT(DISTINCT CASE 
        WHEN p.centre_id IS NOT NULL 
         AND p.cout_id IS NOT NULL 
         AND p.delai IS NOT NULL 
         AND TRIM(p.delai) != ''
         AND (SELECT COUNT(*) FROM etapes e WHERE e.procedure_id = p.id) > 0
         AND (SELECT COUNT(*) FROM documents_requis dr WHERE dr.procedure_id = p.id) > 0
         AND (SELECT COUNT(*) FROM lois_articles la WHERE la.procedure_id = p.id) > 0
        THEN p.id 
    END) AS 'Procédures complètes',
    CASE 
        WHEN COUNT(DISTINCT CASE 
            WHEN p.centre_id IS NOT NULL 
             AND p.cout_id IS NOT NULL 
             AND p.delai IS NOT NULL 
             AND TRIM(p.delai) != ''
             AND (SELECT COUNT(*) FROM etapes e WHERE e.procedure_id = p.id) > 0
             AND (SELECT COUNT(*) FROM documents_requis dr WHERE dr.procedure_id = p.id) > 0
             AND (SELECT COUNT(*) FROM lois_articles la WHERE la.procedure_id = p.id) > 0
            THEN p.id 
        END) > 0 THEN '✅ COMPLÈTE'
        ELSE '❌ INCOMPLÈTE'
    END AS 'Statut'
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
ORDER BY cat.titre, sc.titre;

-- ============================================================================
-- 3. DÉTAIL PAR CATÉGORIE - STATISTIQUES
-- ============================================================================

SELECT 
    cat.titre AS 'Catégorie',
    COUNT(DISTINCT sc.id) AS 'Total sous-catégories',
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
    END) AS 'Sous-catégories complètes',
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
    END) AS 'Sous-catégories incomplètes',
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
    ) AS 'Taux complétude (%)'
FROM categories cat
INNER JOIN sous_categories sc ON cat.id = sc.categorie_id
GROUP BY cat.id, cat.titre
ORDER BY cat.titre;

-- ============================================================================
-- 4. DÉTAIL DES PROCÉDURES INCOMPLÈTES PAR SOUS-CATÉGORIE
-- ============================================================================

SELECT 
    cat.titre AS 'Catégorie',
    sc.titre AS 'Sous-catégorie',
    p.id AS 'ID Procédure',
    p.titre AS 'Titre procédure',
    CASE WHEN p.centre_id IS NOT NULL THEN '✅' ELSE '❌' END AS 'Centre',
    CASE WHEN p.cout_id IS NOT NULL THEN '✅' ELSE '❌' END AS 'Coût',
    CASE WHEN p.delai IS NOT NULL AND TRIM(p.delai) != '' THEN '✅' ELSE '❌' END AS 'Délai',
    CASE WHEN (SELECT COUNT(*) FROM etapes e WHERE e.procedure_id = p.id) > 0 THEN '✅' ELSE '❌' END AS 'Étapes',
    CASE WHEN (SELECT COUNT(*) FROM documents_requis dr WHERE dr.procedure_id = p.id) > 0 THEN '✅' ELSE '❌' END AS 'Documents',
    CASE WHEN (SELECT COUNT(*) FROM lois_articles la WHERE la.procedure_id = p.id) > 0 THEN '✅' ELSE '❌' END AS 'Lois',
    (SELECT COUNT(*) FROM etapes e WHERE e.procedure_id = p.id) AS 'Nb étapes',
    (SELECT COUNT(*) FROM documents_requis dr WHERE dr.procedure_id = p.id) AS 'Nb documents',
    (SELECT COUNT(*) FROM lois_articles la WHERE la.procedure_id = p.id) AS 'Nb lois'
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
ORDER BY cat.titre, sc.titre, p.titre;

-- ============================================================================
-- 5. SOUS-CATÉGORIES SANS AUCUNE PROCÉDURE
-- ============================================================================

SELECT 
    cat.titre AS 'Catégorie',
    sc.titre AS 'Sous-catégorie',
    sc.id AS 'ID Sous-catégorie'
FROM sous_categories sc
INNER JOIN categories cat ON sc.categorie_id = cat.id
WHERE NOT EXISTS (
    SELECT 1 
    FROM procedures p 
    WHERE p.sous_categorie_id = sc.id
)
ORDER BY cat.titre, sc.titre;

-- ============================================================================
-- 6. EXEMPLE DE PROCÉDURE COMPLÈTE (pour référence)
-- ============================================================================

SELECT 
    cat.titre AS 'Catégorie',
    sc.titre AS 'Sous-catégorie',
    p.id AS 'ID Procédure',
    p.titre AS 'Titre procédure',
    c.nom AS 'Centre',
    co.nom AS 'Coût',
    p.delai AS 'Délai',
    (SELECT COUNT(*) FROM etapes e WHERE e.procedure_id = p.id) AS 'Nb étapes',
    (SELECT COUNT(*) FROM documents_requis dr WHERE dr.procedure_id = p.id) AS 'Nb documents',
    (SELECT COUNT(*) FROM lois_articles la WHERE la.procedure_id = p.id) AS 'Nb lois'
FROM procedures p
INNER JOIN sous_categories sc ON p.sous_categorie_id = sc.id
INNER JOIN categories cat ON sc.categorie_id = cat.id
LEFT JOIN centres c ON p.centre_id = c.id
LEFT JOIN couts co ON p.cout_id = co.id
WHERE p.centre_id IS NOT NULL
  AND p.cout_id IS NOT NULL
  AND p.delai IS NOT NULL 
  AND TRIM(p.delai) != ''
  AND (SELECT COUNT(*) FROM etapes e WHERE e.procedure_id = p.id) > 0
  AND (SELECT COUNT(*) FROM documents_requis dr WHERE dr.procedure_id = p.id) > 0
  AND (SELECT COUNT(*) FROM lois_articles la WHERE la.procedure_id = p.id) > 0
LIMIT 5;

