-- Relink procedures to correct sous-catégories (Option A)

-- 1) FDI NINA -> Fiche individuelle
UPDATE procedures p
SET p.sous_categorie_id = (
  SELECT id FROM sous_categories WHERE titre = 'Fiche individuelle' LIMIT 1
)
WHERE p.sous_categorie_id = (
  SELECT id FROM sous_categories WHERE titre = 'Fiche Descriptive Individuelle (FDI) NINA' LIMIT 1
);

-- 2) Passeport biométrique -> Passeport malien
UPDATE procedures p
SET p.sous_categorie_id = (
  SELECT id FROM sous_categories WHERE titre = 'Passeport malien' LIMIT 1
)
WHERE p.sous_categorie_id = (
  SELECT id FROM sous_categories WHERE titre = 'Passeport biométrique' LIMIT 1
);

-- 3) Création d'entreprise individuelle -> Entreprise individuelle
UPDATE procedures p
SET p.sous_categorie_id = (
  SELECT id FROM sous_categories WHERE titre = 'Entreprise individuelle' LIMIT 1
)
WHERE p.sous_categorie_id = (
  SELECT id FROM sous_categories WHERE titre = 'Création d''entreprise individuelle' LIMIT 1
);

-- 4) SA: Création de Société Anonyme (SA) -> Sociétés Anonymes (SA)
UPDATE procedures p
SET p.sous_categorie_id = (
  SELECT id FROM sous_categories WHERE titre = 'Sociétés Anonymes (SA)' LIMIT 1
)
WHERE p.sous_categorie_id = (
  SELECT id FROM sous_categories WHERE titre = 'Création de Société Anonyme (SA)' LIMIT 1
);

-- 5) SAS: Création de Société par Actions Simplifiée (SAS) -> Sociétés par Actions Simplifiées (SAS)
UPDATE procedures p
SET p.sous_categorie_id = (
  SELECT id FROM sous_categories WHERE titre = 'Sociétés par Actions Simplifiées (SAS)' LIMIT 1
)
WHERE p.sous_categorie_id = (
  SELECT id FROM sous_categories WHERE titre = 'Création de Société par Actions Simplifiée (SAS)' LIMIT 1
);

-- 6) SNC: Société en Nom Collectif (singulier) -> Sociétés en Nom Collectif (SNC)
UPDATE procedures p
SET p.sous_categorie_id = (
  SELECT id FROM sous_categories WHERE titre = 'Sociétés en Nom Collectif (SNC)' LIMIT 1
)
WHERE p.sous_categorie_id = (
  SELECT id FROM sous_categories WHERE titre = 'Société en Nom Collectif (SNC)' LIMIT 1
);
