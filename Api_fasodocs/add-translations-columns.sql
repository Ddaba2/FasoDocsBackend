-- ============================================
-- MIGRATION: Ajout des colonnes de traduction
-- FasoDocs - Support multilingue
-- Date: 2025-11-13
-- ============================================
-- IMPORTANT: Exécutez ce script sur votre base de données FasoDocs
-- avant de redémarrer l'application
-- ============================================

USE FasoDocs;

-- ============================================
-- 1. CATÉGORIES - Ajout des traductions
-- ============================================

ALTER TABLE categories 
  ADD COLUMN titre_en VARCHAR(100) AFTER titre,
  ADD COLUMN titre_bm VARCHAR(100) AFTER titre_en,
  ADD COLUMN description_en TEXT AFTER description,
  ADD COLUMN description_bm TEXT AFTER description_en;

-- ============================================
-- 2. SOUS-CATÉGORIES - Ajout des traductions
-- ============================================

ALTER TABLE sous_categories
  ADD COLUMN titre_en VARCHAR(100) AFTER titre,
  ADD COLUMN titre_bm VARCHAR(100) AFTER titre_en,
  ADD COLUMN description_en TEXT AFTER description,
  ADD COLUMN description_bm TEXT AFTER description_en;

-- ============================================
-- 3. PROCÉDURES - Ajout des traductions
-- ============================================

ALTER TABLE procedures
  ADD COLUMN nom_en VARCHAR(200) AFTER nom,
  ADD COLUMN nom_bm VARCHAR(200) AFTER nom_en,
  ADD COLUMN titre_en VARCHAR(100) AFTER titre,
  ADD COLUMN titre_bm VARCHAR(100) AFTER titre_en,
  ADD COLUMN description_en TEXT AFTER description,
  ADD COLUMN description_bm TEXT AFTER description_en,
  ADD COLUMN delai_en VARCHAR(500) AFTER delai,
  ADD COLUMN delai_bm VARCHAR(500) AFTER delai_en;

-- ============================================
-- 4. ÉTAPES - Ajout des traductions
-- ============================================

ALTER TABLE etapes
  ADD COLUMN description_en TEXT AFTER description,
  ADD COLUMN description_bm TEXT AFTER description_en;

-- ============================================
-- 5. DOCUMENTS REQUIS - Ajout des traductions
-- ============================================

ALTER TABLE documents_requis
  ADD COLUMN description_en TEXT AFTER description,
  ADD COLUMN description_bm TEXT AFTER description_en;

-- ============================================
-- 6. CENTRES - Ajout des traductions
-- ============================================

ALTER TABLE centres
  ADD COLUMN nom_en VARCHAR(200) AFTER nom,
  ADD COLUMN nom_bm VARCHAR(200) AFTER nom_en,
  ADD COLUMN adresse_en VARCHAR(500) AFTER adresse,
  ADD COLUMN adresse_bm VARCHAR(500) AFTER adresse_en,
  ADD COLUMN horaires_en VARCHAR(200) AFTER horaires,
  ADD COLUMN horaires_bm VARCHAR(200) AFTER horaires_en;

-- ============================================
-- 7. COÛTS - Ajout des traductions
-- ============================================

ALTER TABLE couts
  ADD COLUMN description_en VARCHAR(500) AFTER description,
  ADD COLUMN description_bm VARCHAR(500) AFTER description_en;

-- ============================================
-- 8. LOIS ET ARTICLES - Ajout des traductions
-- ============================================

ALTER TABLE lois_articles
  ADD COLUMN description_en VARCHAR(500) AFTER description,
  ADD COLUMN description_bm VARCHAR(500) AFTER description_en;

-- ============================================
-- VÉRIFICATION
-- ============================================

SELECT 
    'categories' as table_name,
    COUNT(*) as columns_added
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_SCHEMA = 'FasoDocs' 
  AND TABLE_NAME = 'categories' 
  AND COLUMN_NAME LIKE '%_en'
UNION ALL
SELECT 
    'sous_categories' as table_name,
    COUNT(*) as columns_added
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_SCHEMA = 'FasoDocs' 
  AND TABLE_NAME = 'sous_categories' 
  AND COLUMN_NAME LIKE '%_en'
UNION ALL
SELECT 
    'procedures' as table_name,
    COUNT(*) as columns_added
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_SCHEMA = 'FasoDocs' 
  AND TABLE_NAME = 'procedures' 
  AND COLUMN_NAME LIKE '%_en';

-- ============================================
-- NOTES
-- ============================================
-- ✅ Les colonnes _fr restent les colonnes originales
-- ✅ Les colonnes _en et _bm sont ajoutées pour les traductions
-- ✅ Les colonnes peuvent être NULL (on les remplira progressivement)
-- ============================================

SELECT '✅ Migration terminée avec succès !' as status;











