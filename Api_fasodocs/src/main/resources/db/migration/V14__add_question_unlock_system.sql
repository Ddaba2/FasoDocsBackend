-- Migration V14: Système de déblocage progressif des questions
-- Date: 2025-01-26
-- Description: Permet de débloquer les questions progressivement (50% des points requis)

-- Ajouter la colonne ordre à quiz_questions pour ordonner les questions
SET @dbname = DATABASE();
SET @tablename = "quiz_questions";
SET @columnname = "ordre";

-- Vérifier si la colonne ordre existe déjà
SET @preparedStatement = (SELECT IF(
  (
    SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
    WHERE
      (table_name = @tablename)
      AND (table_schema = @dbname)
      AND (column_name = @columnname)
  ) > 0,
  "SELECT 1",
  CONCAT("ALTER TABLE ", @tablename, " ADD COLUMN ", @columnname, " INTEGER DEFAULT 0 COMMENT 'Ordre de la question dans le quiz (1, 2, 3, 4, 5)'")
));
PREPARE alterIfNotExists FROM @preparedStatement;
EXECUTE alterIfNotExists;
DEALLOCATE PREPARE alterIfNotExists;

-- Mettre à jour l'ordre des questions existantes basé sur leur ID
UPDATE quiz_questions q1
INNER JOIN (
    SELECT id, 
           ROW_NUMBER() OVER (PARTITION BY quiz_journalier_id ORDER BY id) as ordre
    FROM quiz_questions
) q2 ON q1.id = q2.id
SET q1.ordre = q2.ordre
WHERE q1.ordre = 0 OR q1.ordre IS NULL;

-- Table quiz_questions_debloquees (Questions débloquées par utilisateur)
CREATE TABLE IF NOT EXISTS quiz_questions_debloquees (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    citoyen_id BIGINT NOT NULL,
    quiz_journalier_id BIGINT NOT NULL,
    question_id BIGINT NOT NULL,
    date_deblocage DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (citoyen_id) REFERENCES citoyens(id) ON DELETE CASCADE,
    FOREIGN KEY (quiz_journalier_id) REFERENCES quiz_journaliers(id) ON DELETE CASCADE,
    FOREIGN KEY (question_id) REFERENCES quiz_questions(id) ON DELETE CASCADE,
    UNIQUE KEY unique_question_debloquee (citoyen_id, quiz_journalier_id, question_id),
    INDEX idx_citoyen_quiz (citoyen_id, quiz_journalier_id),
    INDEX idx_question (question_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Débloquer automatiquement la première question de chaque quiz pour tous les utilisateurs
-- (La première question est toujours accessible)
INSERT INTO quiz_questions_debloquees (citoyen_id, quiz_journalier_id, question_id)
SELECT DISTINCT 
    c.id as citoyen_id,
    qj.id as quiz_journalier_id,
    qq.id as question_id
FROM citoyens c
CROSS JOIN quiz_journaliers qj
INNER JOIN quiz_questions qq ON qq.quiz_journalier_id = qj.id
WHERE qq.ordre = 1
AND NOT EXISTS (
    SELECT 1 FROM quiz_questions_debloquees qqd
    WHERE qqd.citoyen_id = c.id
    AND qqd.quiz_journalier_id = qj.id
    AND qqd.question_id = qq.id
)
ON DUPLICATE KEY UPDATE question_id = question_id;

