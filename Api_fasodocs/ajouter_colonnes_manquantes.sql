-- ============================================
-- AJOUT DES COLONNES MANQUANTES - FasoDocs
-- Pour compléter la traduction à 100%
-- ============================================

USE FasoDocs;

-- ============================================
-- COÛTS - Ajout de description_en si manquante
-- ============================================

-- Vérifier si la colonne existe avant de l'ajouter
SET @col_exists = (
    SELECT COUNT(*) 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'FasoDocs' 
      AND TABLE_NAME = 'couts' 
      AND COLUMN_NAME = 'description_en'
);

SET @sql = IF(@col_exists = 0,
    'ALTER TABLE couts ADD COLUMN description_en VARCHAR(500) AFTER description, ADD COLUMN description_bm VARCHAR(500) AFTER description_en',
    'SELECT "Colonne description_en existe déjà dans couts" as message'
);

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- ============================================
-- LOIS ARTICLES - Ajout de description_en si manquante
-- ============================================

SET @col_exists = (
    SELECT COUNT(*) 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'FasoDocs' 
      AND TABLE_NAME = 'lois_articles' 
      AND COLUMN_NAME = 'description_en'
);

SET @sql = IF(@col_exists = 0,
    'ALTER TABLE lois_articles ADD COLUMN description_en VARCHAR(500) AFTER description, ADD COLUMN description_bm VARCHAR(500) AFTER description_en',
    'SELECT "Colonne description_en existe déjà dans lois_articles" as message'
);

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- ============================================
-- VÉRIFICATION
-- ============================================

SELECT '✅ Colonnes ajoutées avec succès !' as status;

