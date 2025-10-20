-- Script pour recréer la base de données FasoDocs avec la nouvelle structure
-- Exécutez ce script dans votre client MySQL avant de relancer l'application

-- Supprimer la base de données existante
DROP DATABASE IF EXISTS FasoDocs;

-- Créer une nouvelle base de données
CREATE DATABASE FasoDocs 
CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

-- Utiliser la nouvelle base de données
USE FasoDocs;

-- Afficher un message de confirmation
SELECT 'Base de données FasoDocs recréée avec succès!' as Message;
