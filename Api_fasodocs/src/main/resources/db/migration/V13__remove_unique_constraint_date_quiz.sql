-- Migration V13: Suppression de la contrainte unique sur date_quiz
-- Date: 2025-01-26
-- Problème: La contrainte UNIQUE sur date_quiz (créée dans V11) empêche la création de plusieurs quiz le même jour
-- Solution: Supprimer toutes les contraintes uniques sur date_quiz pour permettre plusieurs quiz par jour

-- Étape 1: Trouver et supprimer toutes les contraintes uniques sur date_quiz
-- MySQL crée des contraintes avec des noms générés automatiquement (comme UK_pnhoksvbjyts8sh36ogt2ummc)

-- Supprimer toutes les contraintes uniques qui incluent date_quiz
SET @dbname = DATABASE();
SET @tablename = "quiz_journaliers";

-- Méthode 1: Supprimer par le nom de la colonne dans les statistiques
-- Trouver tous les index uniques sur date_quiz
SET @sql = (
    SELECT CONCAT('ALTER TABLE ', @tablename, ' DROP INDEX ', INDEX_NAME)
    FROM INFORMATION_SCHEMA.STATISTICS
    WHERE TABLE_SCHEMA = @dbname
    AND TABLE_NAME = @tablename
    AND COLUMN_NAME = 'date_quiz'
    AND NON_UNIQUE = 0
    LIMIT 1
);

-- Exécuter si un index unique a été trouvé
SET @preparedStatement = IF(@sql IS NOT NULL, @sql, 'SELECT 1');
PREPARE stmt FROM @preparedStatement;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Méthode 2: Modifier directement la colonne pour enlever UNIQUE
-- Cela supprime la contrainte UNIQUE même si l'index a un nom généré
ALTER TABLE quiz_journaliers 
MODIFY COLUMN date_quiz DATE NOT NULL;

-- Étape 3: Supprimer la contrainte unique sur (date_quiz, niveau) si elle existe
-- Cette contrainte peut avoir été créée dans V12 ou par Hibernate
SET @constraint_name = (
    SELECT CONSTRAINT_NAME 
    FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
    WHERE TABLE_SCHEMA = @dbname 
    AND TABLE_NAME = @tablename 
    AND CONSTRAINT_TYPE = 'UNIQUE'
    AND CONSTRAINT_NAME LIKE '%date_quiz%'
    LIMIT 1
);

-- Si une contrainte unique sur (date_quiz, niveau) existe, la supprimer
SET @sql2 = IF(
    @constraint_name IS NOT NULL,
    CONCAT('ALTER TABLE ', @tablename, ' DROP INDEX ', @constraint_name),
    'SELECT 1'
);
PREPARE stmt2 FROM @sql2;
EXECUTE stmt2;
DEALLOCATE PREPARE stmt2;

-- Supprimer aussi toutes les contraintes uniques qui incluent date_quiz et niveau
-- Chercher dans les index composites
SET @index_composite = (
    SELECT INDEX_NAME 
    FROM INFORMATION_SCHEMA.STATISTICS 
    WHERE TABLE_SCHEMA = @dbname 
    AND TABLE_NAME = @tablename 
    AND COLUMN_NAME IN ('date_quiz', 'niveau')
    AND NON_UNIQUE = 0
    GROUP BY INDEX_NAME
    HAVING COUNT(DISTINCT COLUMN_NAME) = 2
    LIMIT 1
);

-- Supprimer l'index composite unique s'il existe
SET @sql3 = IF(
    @index_composite IS NOT NULL,
    CONCAT('ALTER TABLE ', @tablename, ' DROP INDEX ', @index_composite),
    'SELECT 1'
);
PREPARE stmt3 FROM @sql3;
EXECUTE stmt3;
DEALLOCATE PREPARE stmt3;

-- Vérification: Il ne devrait plus y avoir de contrainte unique sur date_quiz seule ou (date_quiz, niveau)
-- On peut maintenant avoir plusieurs quiz avec la même date et le même niveau

