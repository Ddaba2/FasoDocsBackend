-- Migration V12: Ajout du système de niveaux de quiz (FACILE, MOYEN, DIFFICILE)
-- Date: 2025-01-26

-- Ajouter la colonne niveau à quiz_journaliers (seulement si elle n'existe pas)
SET @dbname = DATABASE();
SET @tablename = "quiz_journaliers";
SET @columnname = "niveau";
SET @preparedStatement = (SELECT IF(
  (
    SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
    WHERE
      (table_name = @tablename)
      AND (table_schema = @dbname)
      AND (column_name = @columnname)
  ) > 0,
  "SELECT 1",
  CONCAT("ALTER TABLE ", @tablename, " ADD COLUMN ", @columnname, " VARCHAR(20) DEFAULT 'FACILE' COMMENT 'Niveau du quiz: FACILE, MOYEN, DIFFICILE'")
));
PREPARE alterIfNotExists FROM @preparedStatement;
EXECUTE alterIfNotExists;
DEALLOCATE PREPARE alterIfNotExists;

-- Supprimer la contrainte unique sur date_quiz (on peut avoir plusieurs quiz par date et niveau)
ALTER TABLE quiz_journaliers 
DROP INDEX IF EXISTS date_quiz;

-- Supprimer l'ancienne contrainte unique si elle existe
ALTER TABLE quiz_journaliers 
DROP INDEX IF EXISTS unique_quiz_date_niveau;

-- Permettre plusieurs quiz du même niveau le même jour
-- Pas de contrainte unique sur (date_quiz, niveau) - on peut avoir plusieurs quiz FACILE le même jour

-- Ajouter un index sur niveau pour améliorer les performances (seulement s'il n'existe pas)
SET @indexname = "idx_niveau";
SET @preparedStatement2 = (SELECT IF(
  (
    SELECT COUNT(*) FROM INFORMATION_SCHEMA.STATISTICS
    WHERE
      (table_name = @tablename)
      AND (table_schema = @dbname)
      AND (index_name = @indexname)
  ) > 0,
  "SELECT 1",
  CONCAT("ALTER TABLE ", @tablename, " ADD INDEX ", @indexname, " (niveau)")
));
PREPARE alterIfNotExists2 FROM @preparedStatement2;
EXECUTE alterIfNotExists2;
DEALLOCATE PREPARE alterIfNotExists2;

-- Table quiz_progression (Progression des utilisateurs par niveau)
CREATE TABLE IF NOT EXISTS quiz_progression (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    citoyen_id BIGINT NOT NULL,
    niveau VARCHAR(20) NOT NULL COMMENT 'Niveau débloqué: FACILE, MOYEN, DIFFICILE',
    date_deblocage DATETIME DEFAULT CURRENT_TIMESTAMP,
    quiz_completes INTEGER DEFAULT 0 COMMENT 'Nombre de quiz complétés à ce niveau',
    meilleur_score INTEGER DEFAULT 0 COMMENT 'Meilleur score obtenu à ce niveau',
    FOREIGN KEY (citoyen_id) REFERENCES citoyens(id) ON DELETE CASCADE,
    UNIQUE KEY unique_citoyen_niveau (citoyen_id, niveau),
    INDEX idx_citoyen (citoyen_id),
    INDEX idx_niveau (niveau)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Initialiser les progressions pour les utilisateurs existants (débloquer FACILE par défaut)
INSERT INTO quiz_progression (citoyen_id, niveau, quiz_completes, meilleur_score)
SELECT id, 'FACILE', 0, 0
FROM citoyens
WHERE id NOT IN (SELECT citoyen_id FROM quiz_progression WHERE niveau = 'FACILE')
ON DUPLICATE KEY UPDATE citoyen_id = citoyen_id;

