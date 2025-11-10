-- =============================================================
-- Trouver les IDs des procédures liées à des sous-catégories
-- =============================================================
-- Sous-catégories ciblées:
--  - Fiche individuelle
--  - Passeport malien
--  - Entreprise individuelle
--  - Sociétés Anonymes (SA)
--  - Sociétés par Actions Simplifiées (SAS)
--  - Sociétés en Nom Collectif (SNC)
--  - Permis de construire à usage industriel
--  - Permis de construire à usage personnelle
--  - Logement sociaux
--  - Vérification des titres de propriétés
-- =============================================================

-- 1) Résumé par sous-catégorie (compte de procédures liées)
SELECT 
    sc.id AS sous_categorie_id,
    sc.titre AS sous_categorie,
    COUNT(p.id) AS nb_procedures,
    COUNT(CASE WHEN p.centre_id IS NOT NULL THEN 1 END) AS nb_avec_centre,
    COUNT(CASE WHEN p.cout_id IS NOT NULL THEN 1 END) AS nb_avec_cout,
    COUNT(CASE WHEN p.delai IS NOT NULL AND TRIM(p.delai) <> '' THEN 1 END) AS nb_avec_delai,
    COUNT(CASE WHEN (SELECT COUNT(*) FROM etapes e WHERE e.procedure_id = p.id) > 0 THEN 1 END) AS nb_avec_etapes,
    COUNT(CASE WHEN (SELECT COUNT(*) FROM documents_requis dr WHERE dr.procedure_id = p.id) > 0 THEN 1 END) AS nb_avec_documents,
    COUNT(CASE WHEN (SELECT COUNT(*) FROM lois_articles la WHERE la.procedure_id = p.id) > 0 THEN 1 END) AS nb_avec_lois
FROM sous_categories sc
LEFT JOIN procedures p ON p.sous_categorie_id = sc.id
WHERE sc.titre IN (
  'Fiche individuelle',
  'Passeport malien',
  'Entreprise individuelle',
  'Sociétés Anonymes (SA)',
  'Sociétés par Actions Simplifiées (SAS)',
  'Sociétés en Nom Collectif (SNC)',
  'Permis de construire à usage industriel',
  'Permis de construire à usage personnelle',
  'Logement sociaux',
  'Vérification des titres de propriétés'
)
GROUP BY sc.id, sc.titre
ORDER BY sc.titre;

-- 2) Détail des procédures par sous-catégorie (avec IDs)
SELECT 
    sc.id AS sous_categorie_id,
    sc.titre AS sous_categorie,
    p.id AS procedure_id,
    p.nom,
    p.titre,
    p.delai,
    p.centre_id,
    p.cout_id,
    (SELECT COUNT(*) FROM etapes e WHERE e.procedure_id = p.id) AS nb_etapes,
    (SELECT COUNT(*) FROM documents_requis dr WHERE dr.procedure_id = p.id) AS nb_documents,
    (SELECT COUNT(*) FROM lois_articles la WHERE la.procedure_id = p.id) AS nb_lois
FROM sous_categories sc
LEFT JOIN procedures p ON p.sous_categorie_id = sc.id
WHERE sc.titre IN (
  'Fiche individuelle',
  'Passeport malien',
  'Entreprise individuelle',
  'Sociétés Anonymes (SA)',
  'Sociétés par Actions Simplifiées (SAS)',
  'Sociétés en Nom Collectif (SNC)',
  'Permis de construire à usage industriel',
  'Permis de construire à usage personnelle',
  'Logement sociaux',
  'Vérification des titres de propriétés'
)
ORDER BY sc.titre, p.nom;
