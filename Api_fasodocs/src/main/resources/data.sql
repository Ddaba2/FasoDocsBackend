-- Script d'initialisation des données FasoDocs
-- Ce fichier sera exécuté automatiquement au démarrage de l'application

-- Désactiver les vérifications de clés étrangères temporairement
SET FOREIGN_KEY_CHECKS = 0;

-- Vider les tables existantes (optionnel)
-- TRUNCATE TABLE lois_articles;
-- TRUNCATE TABLE documents_requis;
-- TRUNCATE TABLE etapes;
-- TRUNCATE TABLE procedures;
-- TRUNCATE TABLE couts;
-- TRUNCATE TABLE centres;
-- TRUNCATE TABLE sous_categories;
-- TRUNCATE TABLE categories;

-- Réactiver les vérifications de clés étrangères
SET FOREIGN_KEY_CHECKS = 1;

-- Note: Les données complètes sont dans fasodocs-data-complete.sql
-- Pour charger toutes les données, utilisez l'option 2 ou 3 ci-dessous
