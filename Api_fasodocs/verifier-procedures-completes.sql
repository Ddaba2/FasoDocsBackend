-- ============================================================================
-- Script de vérification des procédures et leurs relations
-- ============================================================================

USE fasodocs;

-- Liste des procédures recherchées
SELECT 
    p.id,
    p.titre AS 'Titre',
    p.nom AS 'Nom complet',
    p.delai AS 'Délai',
    (SELECT COUNT(*) FROM etapes e WHERE e.procedure_id = p.id) AS 'Nb Étapes',
    (SELECT COUNT(*) FROM documents_requis dr WHERE dr.procedure_id = p.id) AS 'Nb Documents',
    CASE WHEN p.cout_id IS NOT NULL THEN 'Oui' ELSE 'Non' END AS 'Coût?',
    CASE WHEN p.centre_id IS NOT NULL THEN 'Oui' ELSE 'Non' END AS 'Centre?',
    c.nom AS 'Centre',
    cat.titre AS 'Catégorie'
FROM procedures p
LEFT JOIN centres c ON p.centre_id = c.id
LEFT JOIN categories cat ON p.categorie_id = cat.id
WHERE 
    p.titre LIKE '%fiche individuelle%'
    OR p.titre LIKE '%Passeport%'
    OR p.titre LIKE '%Nationalité%naturalisation%'
    OR p.titre LIKE '%Nationalité%mariage%'
    OR p.titre LIKE '%électeur%'
    OR p.titre LIKE '%résidence%'
    OR p.titre LIKE '%électorale%'
    OR p.titre LIKE '%mariage%'
    OR p.titre LIKE '%Sociétés Anonymes%'
    OR p.titre LIKE '%Nom Collectif%'
    OR p.titre LIKE '%Commandite%'
    OR p.titre LIKE '%Actions Simplifiées%'
    OR p.titre LIKE '%individuel%'
    OR p.titre LIKE '%SARL%'
    OR p.titre LIKE '%Visite technique%'
    OR p.titre LIKE '%Vignette%'
    OR p.titre LIKE '%taxi%'
    OR p.titre LIKE '%plaque%'
    OR p.titre LIKE '%Permis de conduire%'
    OR p.titre LIKE '%carte grise%'
    OR p.titre LIKE '%perte%'
    OR p.titre LIKE '%litige%'
    OR p.titre LIKE '%TARTOP%'
    OR p.titre LIKE '%armes%'
    OR p.titre LIKE '%libération%'
    OR p.nom LIKE '%fiche individuelle%'
    OR p.nom LIKE '%Passeport%'
    OR p.nom LIKE '%Nationalité%'
    OR p.nom LIKE '%électeur%'
    OR p.nom LIKE '%résidence%'
    OR p.nom LIKE '%électorale%'
    OR p.nom LIKE '%mariage%'
    OR p.nom LIKE '%SA%'
    OR p.nom LIKE '%SNC%'
    OR p.nom LIKE '%SCS%'
    OR p.nom LIKE '%SAS%'
    OR p.nom LIKE '%SARL%'
    OR p.nom LIKE '%Visite%'
    OR p.nom LIKE '%Vignette%'
    OR p.nom LIKE '%taxi%'
    OR p.nom LIKE '%plaque%'
    OR p.nom LIKE '%Permis%'
    OR p.nom LIKE '%grise%'
    OR p.nom LIKE '%perte%'
    OR p.nom LIKE '%litige%'
    OR p.nom LIKE '%TARTOP%'
    OR p.nom LIKE '%armes%'
    OR p.nom LIKE '%libération%'
ORDER BY p.titre;

-- Comptage total
SELECT COUNT(*) AS 'Total procédures trouvées'
FROM procedures p
WHERE 
    p.titre LIKE '%fiche%' OR p.titre LIKE '%Passeport%' OR p.titre LIKE '%Nationalité%' 
    OR p.titre LIKE '%électeur%' OR p.titre LIKE '%résidence%' OR p.titre LIKE '%mariage%'
    OR p.titre LIKE '%Société%' OR p.titre LIKE '%Entreprise%' OR p.titre LIKE '%Visite%'
    OR p.titre LIKE '%Vignette%' OR p.titre LIKE '%taxi%' OR p.titre LIKE '%Permis%'
    OR p.titre LIKE '%grise%' OR p.titre LIKE '%litige%' OR p.titre LIKE '%TARTOP%'
    OR p.titre LIKE '%armes%' OR p.titre LIKE '%libération%';
