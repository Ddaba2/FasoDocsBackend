-- Script pour identifier les procédures manquantes dans FasoDocs

-- 1. Lister toutes les procédures qui devraient exister selon les erreurs
SELECT 'Procédures attendues mais introuvables:' as Diagnostic;

SELECT 'Nationalité malienne par naturalisation' as procedure_nom,
       CASE WHEN EXISTS (SELECT 1 FROM procedures WHERE nom = 'Nationalité malienne par naturalisation') 
            THEN '✅ EXISTE' ELSE '❌ MANQUANTE' END as statut
UNION ALL
SELECT 'Carte grise (obtention)',
       CASE WHEN EXISTS (SELECT 1 FROM procedures WHERE nom = 'Carte grise (obtention)') 
            THEN '✅ EXISTE' ELSE '❌ MANQUANTE' END
UNION ALL
SELECT 'Carte grise (mutation)',
       CASE WHEN EXISTS (SELECT 1 FROM procedures WHERE nom = 'Carte grise (mutation)') 
            THEN '✅ EXISTE' ELSE '❌ MANQUANTE' END
UNION ALL
SELECT 'Carte grise (renouvellement)',
       CASE WHEN EXISTS (SELECT 1 FROM procedures WHERE nom = 'Carte grise (renouvellement)') 
            THEN '✅ EXISTE' ELSE '❌ MANQUANTE' END
UNION ALL
SELECT 'Visite technique',
       CASE WHEN EXISTS (SELECT 1 FROM procedures WHERE nom = 'Visite technique') 
            THEN '✅ EXISTE' ELSE '❌ MANQUANTE' END
UNION ALL
SELECT 'Changement de couleur de plaque',
       CASE WHEN EXISTS (SELECT 1 FROM procedures WHERE nom = 'Changement de couleur de plaque') 
            THEN '✅ EXISTE' ELSE '❌ MANQUANTE' END
UNION ALL
SELECT 'Libération conditionnelle',
       CASE WHEN EXISTS (SELECT 1 FROM procedures WHERE nom = 'Libération conditionnelle') 
            THEN '✅ EXISTE' ELSE '❌ MANQUANTE' END
UNION ALL
SELECT 'Autorisation d''achat d''armes et munitions',
       CASE WHEN EXISTS (SELECT 1 FROM procedures WHERE nom = 'Autorisation d''achat d''armes et munitions') 
            THEN '✅ EXISTE' ELSE '❌ MANQUANTE' END
UNION ALL
SELECT 'Création d''entreprise individuelle',
       CASE WHEN EXISTS (SELECT 1 FROM procedures WHERE nom = 'Création d''entreprise individuelle') 
            THEN '✅ EXISTE' ELSE '❌ MANQUANTE' END
UNION ALL
SELECT 'Création de SARL',
       CASE WHEN EXISTS (SELECT 1 FROM procedures WHERE nom = 'Création de SARL') 
            THEN '✅ EXISTE' ELSE '❌ MANQUANTE' END
UNION ALL
SELECT 'Création de Société Anonyme (SA)',
       CASE WHEN EXISTS (SELECT 1 FROM procedures WHERE nom = 'Création de Société Anonyme (SA)') 
            THEN '✅ EXISTE' ELSE '❌ MANQUANTE' END
UNION ALL
SELECT 'Permis de construire à usage industriel',
       CASE WHEN EXISTS (SELECT 1 FROM procedures WHERE nom = 'Permis de construire à usage industriel') 
            THEN '✅ EXISTE' ELSE '❌ MANQUANTE' END
UNION ALL
SELECT 'Permis de conduire (obtention)',
       CASE WHEN EXISTS (SELECT 1 FROM procedures WHERE nom = 'Permis de conduire (obtention)') 
            THEN '✅ EXISTE' ELSE '❌ MANQUANTE' END;

-- 2. Vérifier les sous-catégories correspondantes
SELECT '' as separator;
SELECT 'Sous-catégories attendues:' as Diagnostic;

SELECT titre, 
       CASE WHEN categorie_id IS NOT NULL THEN '✅ OK' ELSE '❌ categorie_id NULL' END as statut
FROM sous_categories
WHERE titre IN (
    'Carte grise (obtention)',
    'Carte grise (mutation)',
    'Carte grise (renouvellement)',
    'Visite technique',
    'Changement de couleur de plaque'
);

-- 3. Statistiques globales
SELECT '' as separator;
SELECT 'Statistiques des données:' as Diagnostic;

SELECT 'Catégories' as table_name, COUNT(*) as count FROM categories
UNION ALL
SELECT 'Sous-catégories', COUNT(*) FROM sous_categories
UNION ALL
SELECT 'Procédures', COUNT(*) FROM procedures
UNION ALL
SELECT 'Centres', COUNT(*) FROM centres
UNION ALL
SELECT 'Étapes', COUNT(*) FROM etapes
UNION ALL
SELECT 'Documents requis', COUNT(*) FROM documents_requis
UNION ALL
SELECT 'Coûts', COUNT(*) FROM couts
UNION ALL
SELECT 'Lois et articles', COUNT(*) FROM lois_articles;

