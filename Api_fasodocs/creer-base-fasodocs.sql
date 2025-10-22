-- Script pour créer la base de données FasoDocs

-- Supprimer si elle existe déjà
DROP DATABASE IF EXISTS FasoDocs;

-- Créer la base de données avec UTF-8
CREATE DATABASE FasoDocs CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Vérifier qu'elle a bien été créée
SHOW DATABASES LIKE 'FasoDocs';

-- Message de confirmation
SELECT 'Base de données FasoDocs créée avec succès!' AS Message;

