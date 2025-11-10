-- ============================================
-- CORRECTION DES SOUS-CATÉGORIES DANS LA BASE ACTUELLE
-- ============================================
-- Ce script corrige les liens entre procédures et sous-catégories
-- pour qu'elles correspondent à l'interface utilisateur
-- ============================================

-- 1. FDI NINA -> Fiche individuelle
UPDATE procedures p
SET p.sous_categorie_id = (
  SELECT id FROM sous_categories WHERE titre = 'Fiche individuelle' LIMIT 1
)
WHERE p.sous_categorie_id = (
  SELECT id FROM sous_categories WHERE titre = 'Fiche Descriptive Individuelle (FDI) NINA' LIMIT 1
);

-- 2. Passeport biométrique -> Passeport malien
UPDATE procedures p
SET p.sous_categorie_id = (
  SELECT id FROM sous_categories WHERE titre = 'Passeport malien' LIMIT 1
)
WHERE p.sous_categorie_id IN (
  SELECT id FROM sous_categories WHERE titre LIKE '%Passeport biométrique%' OR titre LIKE '%passeport biométrique%'
);

-- 3. Création d'entreprise individuelle -> Entreprise individuelle
UPDATE procedures p
SET p.sous_categorie_id = (
  SELECT id FROM sous_categories WHERE titre = 'Entreprise individuelle' LIMIT 1
)
WHERE p.sous_categorie_id = (
  SELECT id FROM sous_categories WHERE titre = 'Création d''entreprise individuelle' LIMIT 1
);

-- 4. SA: Création de Société Anonyme (SA) -> Sociétés Anonymes (SA)
UPDATE procedures p
SET p.sous_categorie_id = (
  SELECT id FROM sous_categories WHERE titre = 'Sociétés Anonymes (SA)' LIMIT 1
)
WHERE p.sous_categorie_id = (
  SELECT id FROM sous_categories WHERE titre = 'Création de Société Anonyme (SA)' LIMIT 1
);

-- 5. SAS: Création de Société par Actions Simplifiée (SAS) -> Sociétés par Actions Simplifiées (SAS)
UPDATE procedures p
SET p.sous_categorie_id = (
  SELECT id FROM sous_categories WHERE titre = 'Sociétés par Actions Simplifiées (SAS)' LIMIT 1
)
WHERE p.sous_categorie_id = (
  SELECT id FROM sous_categories WHERE titre = 'Création de Société par Actions Simplifiée (SAS)' LIMIT 1
);

-- 6. SNC: Société en Nom Collectif (singulier) -> Sociétés en Nom Collectif (SNC)
UPDATE procedures p
SET p.sous_categorie_id = (
  SELECT id FROM sous_categories WHERE titre = 'Sociétés en Nom Collectif (SNC)' LIMIT 1
)
WHERE p.sous_categorie_id = (
  SELECT id FROM sous_categories WHERE titre = 'Société en Nom Collectif (SNC)' LIMIT 1
);

-- 7. Permis de construire à usage industriel -> sous-catégorie dédiée
UPDATE procedures p
SET p.sous_categorie_id = (
  SELECT id FROM sous_categories WHERE titre = 'Permis de construire à usage industriel' LIMIT 1
)
WHERE p.nom = 'Permis de construire à usage industriel'
  AND p.sous_categorie_id != (
    SELECT id FROM sous_categories WHERE titre = 'Permis de construire à usage industriel' LIMIT 1
  );

-- 8. Permis de construire à usage personnel -> Permis de construire à usage personnelle (libellé UI)
UPDATE procedures p
SET p.sous_categorie_id = (
  SELECT id FROM sous_categories WHERE titre = 'Permis de construire à usage personnelle' LIMIT 1
)
WHERE p.nom = 'Permis de construire à usage personnel'
  AND p.sous_categorie_id != (
    SELECT id FROM sous_categories WHERE titre = 'Permis de construire à usage personnelle' LIMIT 1
  );

-- 9. Logement sociaux: rattacher la procédure d'attribution à la sous-catégorie UI
UPDATE procedures p
SET p.sous_categorie_id = (
  SELECT id FROM sous_categories WHERE titre = 'Logement sociaux' LIMIT 1
)
WHERE p.nom = 'Attribution des logements sociaux'
  AND EXISTS (
    SELECT 1 FROM sous_categories WHERE titre = 'Logement sociaux'
  )
  AND p.sous_categorie_id != (
    SELECT id FROM sous_categories WHERE titre = 'Logement sociaux' LIMIT 1
  );

-- 10. Nationalité par naturalisation -> corriger le lien
UPDATE procedures p
SET p.sous_categorie_id = (
  SELECT id FROM sous_categories WHERE titre = 'Nationalité par voie de naturalisation' LIMIT 1
)
WHERE p.nom LIKE '%Nationalité%naturalisation%'
  AND EXISTS (
    SELECT 1 FROM sous_categories WHERE titre = 'Nationalité par voie de naturalisation'
  );

-- 11. Nationalité par mariage -> corriger le lien
UPDATE procedures p
SET p.sous_categorie_id = (
  SELECT id FROM sous_categories WHERE titre = 'Nationalité par mariage' LIMIT 1
)
WHERE p.nom LIKE '%Nationalité%mariage%'
  AND EXISTS (
    SELECT 1 FROM sous_categories WHERE titre = 'Nationalité par mariage'
  );

-- 12. Permis de conduire -> corriger le lien
UPDATE procedures p
SET p.sous_categorie_id = (
  SELECT id FROM sous_categories WHERE titre = 'Permis de conduire' LIMIT 1
)
WHERE (p.nom LIKE '%Permis de conduire%' OR p.titre LIKE '%Permis de conduire%')
  AND p.nom NOT LIKE '%renouvellement%'
  AND EXISTS (
    SELECT 1 FROM sous_categories WHERE titre = 'Permis de conduire'
  )
  AND (p.sous_categorie_id IS NULL OR p.sous_categorie_id != (
    SELECT id FROM sous_categories WHERE titre = 'Permis de conduire' LIMIT 1
  ));

-- ============================================
-- VÉRIFICATION DES CORRECTIONS
-- ============================================
-- Afficher le nombre de procédures par sous-catégorie corrigée

SELECT 
    sc.titre AS 'Sous-catégorie',
    COUNT(p.id) AS 'Nombre de procédures'
FROM sous_categories sc
LEFT JOIN procedures p ON sc.id = p.sous_categorie_id
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
    'Vérification des titres de propriétés',
    'Nationalité par voie de naturalisation',
    'Nationalité par mariage',
    'Permis de conduire'
)
GROUP BY sc.id, sc.titre
ORDER BY sc.titre;

