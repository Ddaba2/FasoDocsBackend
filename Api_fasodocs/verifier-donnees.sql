-- Script de vérification des données FasoDocs

-- Vérifier les catégories
SELECT 'CATEGORIES' as Table_Name, COUNT(*) as Nombre_Lignes FROM categories
UNION ALL
SELECT 'SOUS_CATEGORIES', COUNT(*) FROM sous_categories
UNION ALL
SELECT 'PROCEDURES', COUNT(*) FROM procedures
UNION ALL
SELECT 'CENTRES', COUNT(*) FROM centres
UNION ALL
SELECT 'ETAPES', COUNT(*) FROM etapes
UNION ALL
SELECT 'DOCUMENTS_REQUIS', COUNT(*) FROM documents_requis
UNION ALL
SELECT 'COUTS', COUNT(*) FROM couts
UNION ALL
SELECT 'CITOYENS', COUNT(*) FROM citoyens
UNION ALL
SELECT 'ROLES', COUNT(*) FROM roles;

-- Voir les catégories
SELECT * FROM categories;

-- Voir les procédures
SELECT id, nom, titre FROM procedures LIMIT 10;

-- Voir les centres
SELECT id, nom FROM centres LIMIT 10;

