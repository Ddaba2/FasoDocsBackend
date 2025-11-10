-- ============================================================================
-- Script de vérification de complétude des données dans fasodocs-data-complete.sql
-- ============================================================================
-- Vérifie si toutes les procédures ont :
-- - Un coût lié (cout_id)
-- - Un centre lié (centre_id)
-- - Un délai renseigné (delai non NULL et non vide)
-- - Au moins une étape
-- - Au moins un document requis
-- - Au moins une référence de loi
-- ============================================================================

-- ============================================================================
-- 1. RÉSUMÉ GLOBAL - PROCÉDURES INCOMPLÈTES
-- ============================================================================

SELECT 
    COUNT(*) AS 'Total procédures',
    COUNT(CASE WHEN cout_id IS NOT NULL THEN 1 END) AS 'Procédures avec coût',
    COUNT(CASE WHEN centre_id IS NOT NULL THEN 1 END) AS 'Procédures avec centre',
    COUNT(CASE WHEN delai IS NOT NULL AND TRIM(delai) != '' THEN 1 END) AS 'Procédures avec délai',
    COUNT(CASE WHEN (SELECT COUNT(*) FROM etapes e WHERE e.procedure_id = p.id) > 0 THEN 1 END) AS 'Procédures avec étapes',
    COUNT(CASE WHEN (SELECT COUNT(*) FROM documents_requis dr WHERE dr.procedure_id = p.id) > 0 THEN 1 END) AS 'Procédures avec documents',
    COUNT(CASE WHEN (SELECT COUNT(*) FROM lois_articles la WHERE la.procedure_id = p.id) > 0 THEN 1 END) AS 'Procédures avec lois',
    COUNT(CASE 
        WHEN cout_id IS NOT NULL 
         AND centre_id IS NOT NULL 
         AND delai IS NOT NULL 
         AND TRIM(delai) != ''
         AND (SELECT COUNT(*) FROM etapes e WHERE e.procedure_id = p.id) > 0
         AND (SELECT COUNT(*) FROM documents_requis dr WHERE dr.procedure_id = p.id) > 0
         AND (SELECT COUNT(*) FROM lois_articles la WHERE la.procedure_id = p.id) > 0
        THEN 1 
    END) AS 'Procédures complètes',
    COUNT(CASE 
        WHEN cout_id IS NULL 
         OR centre_id IS NULL 
         OR delai IS NULL 
         OR TRIM(delai) = ''
         OR (SELECT COUNT(*) FROM etapes e WHERE e.procedure_id = p.id) = 0
         OR (SELECT COUNT(*) FROM documents_requis dr WHERE dr.procedure_id = p.id) = 0
         OR (SELECT COUNT(*) FROM lois_articles la WHERE la.procedure_id = p.id) = 0
        THEN 1 
    END) AS 'Procédures incomplètes'
FROM procedures p;

-- ============================================================================
-- 2. DÉTAIL DES PROCÉDURES INCOMPLÈTES
-- ============================================================================

SELECT 
    p.id AS 'ID',
    p.nom AS 'Nom procédure',
    p.titre AS 'Titre',
    cat.titre AS 'Catégorie',
    sc.titre AS 'Sous-catégorie',
    -- Vérification de chaque critère
    CASE WHEN p.centre_id IS NOT NULL THEN '✅' ELSE '❌ MANQUE' END AS 'Centre',
    CASE WHEN p.cout_id IS NOT NULL THEN '✅' ELSE '❌ MANQUE' END AS 'Coût',
    CASE WHEN p.delai IS NOT NULL AND TRIM(p.delai) != '' THEN '✅' ELSE '❌ MANQUE' END AS 'Délai',
    CASE WHEN (SELECT COUNT(*) FROM etapes e WHERE e.procedure_id = p.id) > 0 THEN '✅' ELSE '❌ MANQUE' END AS 'Étapes',
    CASE WHEN (SELECT COUNT(*) FROM documents_requis dr WHERE dr.procedure_id = p.id) > 0 THEN '✅' ELSE '❌ MANQUE' END AS 'Documents',
    CASE WHEN (SELECT COUNT(*) FROM lois_articles la WHERE la.procedure_id = p.id) > 0 THEN '✅' ELSE '❌ MANQUE' END AS 'Lois',
    -- Détails
    (SELECT COUNT(*) FROM etapes e WHERE e.procedure_id = p.id) AS 'Nb étapes',
    (SELECT COUNT(*) FROM documents_requis dr WHERE dr.procedure_id = p.id) AS 'Nb documents',
    (SELECT COUNT(*) FROM lois_articles la WHERE la.procedure_id = p.id) AS 'Nb lois',
    p.delai AS 'Délai actuel',
    c.nom AS 'Centre actuel',
    co.nom AS 'Coût actuel'
FROM procedures p
LEFT JOIN categories cat ON p.categorie_id = cat.id
LEFT JOIN sous_categories sc ON p.sous_categorie_id = sc.id
LEFT JOIN centres c ON p.centre_id = c.id
LEFT JOIN couts co ON p.cout_id = co.id
WHERE 
    p.centre_id IS NULL
    OR p.cout_id IS NULL
    OR p.delai IS NULL 
    OR TRIM(p.delai) = ''
    OR (SELECT COUNT(*) FROM etapes e WHERE e.procedure_id = p.id) = 0
    OR (SELECT COUNT(*) FROM documents_requis dr WHERE dr.procedure_id = p.id) = 0
    OR (SELECT COUNT(*) FROM lois_articles la WHERE la.procedure_id = p.id) = 0
ORDER BY 
    CASE WHEN p.centre_id IS NULL THEN 1 ELSE 2 END,
    CASE WHEN p.cout_id IS NULL THEN 1 ELSE 2 END,
    CASE WHEN (SELECT COUNT(*) FROM etapes e WHERE e.procedure_id = p.id) = 0 THEN 1 ELSE 2 END,
    CASE WHEN (SELECT COUNT(*) FROM documents_requis dr WHERE dr.procedure_id = p.id) = 0 THEN 1 ELSE 2 END,
    CASE WHEN (SELECT COUNT(*) FROM lois_articles la WHERE la.procedure_id = p.id) = 0 THEN 1 ELSE 2 END,
    cat.titre, sc.titre, p.titre;

-- ============================================================================
-- 3. PROCÉDURES PAR TYPE DE MANQUE
-- ============================================================================

-- 3.1. Procédures sans centre
SELECT 
    p.id,
    p.nom,
    p.titre,
    cat.titre AS 'Catégorie',
    sc.titre AS 'Sous-catégorie'
FROM procedures p
LEFT JOIN categories cat ON p.categorie_id = cat.id
LEFT JOIN sous_categories sc ON p.sous_categorie_id = sc.id
WHERE p.centre_id IS NULL
ORDER BY cat.titre, sc.titre, p.titre;

-- 3.2. Procédures sans coût
SELECT 
    p.id,
    p.nom,
    p.titre,
    cat.titre AS 'Catégorie',
    sc.titre AS 'Sous-catégorie'
FROM procedures p
LEFT JOIN categories cat ON p.categorie_id = cat.id
LEFT JOIN sous_categories sc ON p.sous_categorie_id = sc.id
WHERE p.cout_id IS NULL
ORDER BY cat.titre, sc.titre, p.titre;

-- 3.3. Procédures sans délai
SELECT 
    p.id,
    p.nom,
    p.titre,
    p.delai AS 'Délai actuel',
    cat.titre AS 'Catégorie',
    sc.titre AS 'Sous-catégorie'
FROM procedures p
LEFT JOIN categories cat ON p.categorie_id = cat.id
LEFT JOIN sous_categories sc ON p.sous_categorie_id = sc.id
WHERE p.delai IS NULL OR TRIM(p.delai) = ''
ORDER BY cat.titre, sc.titre, p.titre;

-- 3.4. Procédures sans étapes
SELECT 
    p.id,
    p.nom,
    p.titre,
    (SELECT COUNT(*) FROM etapes e WHERE e.procedure_id = p.id) AS 'Nb étapes',
    cat.titre AS 'Catégorie',
    sc.titre AS 'Sous-catégorie'
FROM procedures p
LEFT JOIN categories cat ON p.categorie_id = cat.id
LEFT JOIN sous_categories sc ON p.sous_categorie_id = sc.id
WHERE (SELECT COUNT(*) FROM etapes e WHERE e.procedure_id = p.id) = 0
ORDER BY cat.titre, sc.titre, p.titre;

-- 3.5. Procédures sans documents requis
SELECT 
    p.id,
    p.nom,
    p.titre,
    (SELECT COUNT(*) FROM documents_requis dr WHERE dr.procedure_id = p.id) AS 'Nb documents',
    cat.titre AS 'Catégorie',
    sc.titre AS 'Sous-catégorie'
FROM procedures p
LEFT JOIN categories cat ON p.categorie_id = cat.id
LEFT JOIN sous_categories sc ON p.sous_categorie_id = sc.id
WHERE (SELECT COUNT(*) FROM documents_requis dr WHERE dr.procedure_id = p.id) = 0
ORDER BY cat.titre, sc.titre, p.titre;

-- 3.6. Procédures sans références de loi
SELECT 
    p.id,
    p.nom,
    p.titre,
    (SELECT COUNT(*) FROM lois_articles la WHERE la.procedure_id = p.id) AS 'Nb lois',
    cat.titre AS 'Catégorie',
    sc.titre AS 'Sous-catégorie'
FROM procedures p
LEFT JOIN categories cat ON p.categorie_id = cat.id
LEFT JOIN sous_categories sc ON p.sous_categorie_id = sc.id
WHERE (SELECT COUNT(*) FROM lois_articles la WHERE la.procedure_id = p.id) = 0
ORDER BY cat.titre, sc.titre, p.titre;

-- ============================================================================
-- 4. STATISTIQUES PAR CATÉGORIE
-- ============================================================================

SELECT 
    cat.titre AS 'Catégorie',
    COUNT(p.id) AS 'Total procédures',
    COUNT(CASE WHEN p.centre_id IS NOT NULL THEN 1 END) AS 'Avec centre',
    COUNT(CASE WHEN p.cout_id IS NOT NULL THEN 1 END) AS 'Avec coût',
    COUNT(CASE WHEN p.delai IS NOT NULL AND TRIM(p.delai) != '' THEN 1 END) AS 'Avec délai',
    COUNT(CASE WHEN (SELECT COUNT(*) FROM etapes e WHERE e.procedure_id = p.id) > 0 THEN 1 END) AS 'Avec étapes',
    COUNT(CASE WHEN (SELECT COUNT(*) FROM documents_requis dr WHERE dr.procedure_id = p.id) > 0 THEN 1 END) AS 'Avec documents',
    COUNT(CASE WHEN (SELECT COUNT(*) FROM lois_articles la WHERE la.procedure_id = p.id) > 0 THEN 1 END) AS 'Avec lois',
    COUNT(CASE 
        WHEN p.centre_id IS NOT NULL 
         AND p.cout_id IS NOT NULL 
         AND p.delai IS NOT NULL 
         AND TRIM(p.delai) != ''
         AND (SELECT COUNT(*) FROM etapes e WHERE e.procedure_id = p.id) > 0
         AND (SELECT COUNT(*) FROM documents_requis dr WHERE dr.procedure_id = p.id) > 0
         AND (SELECT COUNT(*) FROM lois_articles la WHERE la.procedure_id = p.id) > 0
        THEN 1 
    END) AS 'Complètes',
    ROUND(
        COUNT(CASE 
            WHEN p.centre_id IS NOT NULL 
             AND p.cout_id IS NOT NULL 
             AND p.delai IS NOT NULL 
             AND TRIM(p.delai) != ''
             AND (SELECT COUNT(*) FROM etapes e WHERE e.procedure_id = p.id) > 0
             AND (SELECT COUNT(*) FROM documents_requis dr WHERE dr.procedure_id = p.id) > 0
             AND (SELECT COUNT(*) FROM lois_articles la WHERE la.procedure_id = p.id) > 0
            THEN 1 
        END) * 100.0 / COUNT(p.id),
        2
    ) AS 'Taux complétude (%)'
FROM categories cat
LEFT JOIN procedures p ON cat.id = p.categorie_id
GROUP BY cat.id, cat.titre
ORDER BY cat.titre;

-- ============================================================================
-- 5. PROCÉDURES AVEC PLUSIEURS PROBLÈMES
-- ============================================================================

SELECT 
    p.id,
    p.nom,
    p.titre,
    cat.titre AS 'Catégorie',
    sc.titre AS 'Sous-catégorie',
    (
        CASE WHEN p.centre_id IS NULL THEN 1 ELSE 0 END +
        CASE WHEN p.cout_id IS NULL THEN 1 ELSE 0 END +
        CASE WHEN p.delai IS NULL OR TRIM(p.delai) = '' THEN 1 ELSE 0 END +
        CASE WHEN (SELECT COUNT(*) FROM etapes e WHERE e.procedure_id = p.id) = 0 THEN 1 ELSE 0 END +
        CASE WHEN (SELECT COUNT(*) FROM documents_requis dr WHERE dr.procedure_id = p.id) = 0 THEN 1 ELSE 0 END +
        CASE WHEN (SELECT COUNT(*) FROM lois_articles la WHERE la.procedure_id = p.id) = 0 THEN 1 ELSE 0 END
    ) AS 'Nb problèmes',
    CASE WHEN p.centre_id IS NULL THEN '❌ Centre ' ELSE '' END ||
    CASE WHEN p.cout_id IS NULL THEN '❌ Coût ' ELSE '' END ||
    CASE WHEN p.delai IS NULL OR TRIM(p.delai) = '' THEN '❌ Délai ' ELSE '' END ||
    CASE WHEN (SELECT COUNT(*) FROM etapes e WHERE e.procedure_id = p.id) = 0 THEN '❌ Étapes ' ELSE '' END ||
    CASE WHEN (SELECT COUNT(*) FROM documents_requis dr WHERE dr.procedure_id = p.id) = 0 THEN '❌ Documents ' ELSE '' END ||
    CASE WHEN (SELECT COUNT(*) FROM lois_articles la WHERE la.procedure_id = p.id) = 0 THEN '❌ Lois' ELSE '' END AS 'Problèmes'
FROM procedures p
LEFT JOIN categories cat ON p.categorie_id = cat.id
LEFT JOIN sous_categories sc ON p.sous_categorie_id = sc.id
WHERE 
    p.centre_id IS NULL
    OR p.cout_id IS NULL
    OR p.delai IS NULL 
    OR TRIM(p.delai) = ''
    OR (SELECT COUNT(*) FROM etapes e WHERE e.procedure_id = p.id) = 0
    OR (SELECT COUNT(*) FROM documents_requis dr WHERE dr.procedure_id = p.id) = 0
    OR (SELECT COUNT(*) FROM lois_articles la WHERE la.procedure_id = p.id) = 0
ORDER BY 
    (
        CASE WHEN p.centre_id IS NULL THEN 1 ELSE 0 END +
        CASE WHEN p.cout_id IS NULL THEN 1 ELSE 0 END +
        CASE WHEN p.delai IS NULL OR TRIM(p.delai) = '' THEN 1 ELSE 0 END +
        CASE WHEN (SELECT COUNT(*) FROM etapes e WHERE e.procedure_id = p.id) = 0 THEN 1 ELSE 0 END +
        CASE WHEN (SELECT COUNT(*) FROM documents_requis dr WHERE dr.procedure_id = p.id) = 0 THEN 1 ELSE 0 END +
        CASE WHEN (SELECT COUNT(*) FROM lois_articles la WHERE la.procedure_id = p.id) = 0 THEN 1 ELSE 0 END
    ) DESC,
    cat.titre, sc.titre, p.titre;

-- ============================================================================
-- 6. EXPORT POUR CORRECTION (Format INSERT/UPDATE)
-- ============================================================================

-- Cette requête génère les noms de procédures qui manquent de données
-- Vous pouvez utiliser ces noms pour identifier où ajouter les données dans le fichier SQL

SELECT 
    CONCAT('-- PROCÉDURE: ', p.nom) AS 'Ligne à ajouter dans SQL',
    CASE 
        WHEN p.centre_id IS NULL THEN CONCAT('-- MANQUE: Centre pour ', p.nom)
        ELSE ''
    END AS 'Action requise'
FROM procedures p
WHERE p.centre_id IS NULL
UNION ALL
SELECT 
    CONCAT('-- PROCÉDURE: ', p.nom) AS 'Ligne à ajouter dans SQL',
    CASE 
        WHEN p.cout_id IS NULL THEN CONCAT('-- MANQUE: Coût pour ', p.nom)
        ELSE ''
    END AS 'Action requise'
FROM procedures p
WHERE p.cout_id IS NULL
UNION ALL
SELECT 
    CONCAT('-- PROCÉDURE: ', p.nom) AS 'Ligne à ajouter dans SQL',
    CASE 
        WHEN (SELECT COUNT(*) FROM etapes e WHERE e.procedure_id = p.id) = 0 THEN CONCAT('-- MANQUE: Étapes pour ', p.nom)
        ELSE ''
    END AS 'Action requise'
FROM procedures p
WHERE (SELECT COUNT(*) FROM etapes e WHERE e.procedure_id = p.id) = 0
UNION ALL
SELECT 
    CONCAT('-- PROCÉDURE: ', p.nom) AS 'Ligne à ajouter dans SQL',
    CASE 
        WHEN (SELECT COUNT(*) FROM documents_requis dr WHERE dr.procedure_id = p.id) = 0 THEN CONCAT('-- MANQUE: Documents requis pour ', p.nom)
        ELSE ''
    END AS 'Action requise'
FROM procedures p
WHERE (SELECT COUNT(*) FROM documents_requis dr WHERE dr.procedure_id = p.id) = 0
UNION ALL
SELECT 
    CONCAT('-- PROCÉDURE: ', p.nom) AS 'Ligne à ajouter dans SQL',
    CASE 
        WHEN (SELECT COUNT(*) FROM lois_articles la WHERE la.procedure_id = p.id) = 0 THEN CONCAT('-- MANQUE: Références de loi pour ', p.nom)
        ELSE ''
    END AS 'Action requise'
FROM procedures p
WHERE (SELECT COUNT(*) FROM lois_articles la WHERE la.procedure_id = p.id) = 0;

