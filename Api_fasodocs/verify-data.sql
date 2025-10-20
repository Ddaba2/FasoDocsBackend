-- Script de vérification de l'intégrité des données FasoDocs
-- Exécutez ces requêtes après le redémarrage de l'application

USE FasoDocs;

-- 1. Vérifier le nombre total de catégories
SELECT 'CATÉGORIES' as Table_Name, COUNT(*) as Total_Records FROM categories;

-- 2. Vérifier le nombre total de sous-catégories
SELECT 'SOUS-CATÉGORIES' as Table_Name, COUNT(*) as Total_Records FROM sous_categories;

-- 3. Vérifier le nombre total de procédures
SELECT 'PROCÉDURES' as Table_Name, COUNT(*) as Total_Records FROM procedures;

-- 4. Vérifier le nombre total de documents requis
SELECT 'DOCUMENTS REQUIS' as Table_Name, COUNT(*) as Total_Records FROM documents_requis;

-- 5. Vérifier le nombre total d'étapes
SELECT 'ÉTAPES' as Table_Name, COUNT(*) as Total_Records FROM etapes;

-- 6. Vérifier le nombre total de centres
SELECT 'CENTRES' as Table_Name, COUNT(*) as Total_Records FROM centres;

-- 7. Vérifier le nombre total de coûts
SELECT 'COÛTS' as Table_Name, COUNT(*) as Total_Records FROM couts;

-- 8. Vérifier le nombre total d'articles de loi
SELECT 'ARTICLES DE LOI' as Table_Name, COUNT(*) as Total_Records FROM lois_articles;

-- 9. Vérifier quelques exemples de documents requis avec leurs procédures
SELECT 
    p.nom as Procedure_Nom,
    COUNT(dr.id) as Nombre_Documents_Requis
FROM procedures p
LEFT JOIN documents_requis dr ON p.id = dr.procedure_id
GROUP BY p.id, p.nom
HAVING COUNT(dr.id) > 0
ORDER BY COUNT(dr.id) DESC
LIMIT 10;

-- 10. Vérifier la structure des documents requis
SELECT 
    nom,
    description,
    est_obligatoire,
    procedure_id
FROM documents_requis 
LIMIT 5;
