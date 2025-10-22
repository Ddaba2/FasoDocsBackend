-- Script pour agrandir les colonnes de la base de données FasoDocs
-- À exécuter dans MySQL Workbench ou via MySQL CLI

USE FasoDocs;

-- 1. Agrandir la colonne description dans etapes (actuellement VARCHAR(200))
ALTER TABLE etapes MODIFY COLUMN description TEXT;

-- 2. Agrandir la colonne telephone dans centres (actuellement VARCHAR(20))
ALTER TABLE centres MODIFY COLUMN telephone VARCHAR(200);

-- 3. Agrandir la colonne delai dans procedures (actuellement VARCHAR(100))
ALTER TABLE procedures MODIFY COLUMN delai VARCHAR(500);

-- 4. Vérifier les modifications
DESCRIBE etapes;
DESCRIBE centres;
DESCRIBE procedures;

-- Afficher un message de succès
SELECT '✅ Colonnes agrandies avec succès !' as Resultat;




