-- Migration pour renommer "délégation" en "service"
-- Cette migration renomme la table et les colonnes pour refléter la nouvelle terminologie

-- Renommer la table
ALTER TABLE demandes_delegation RENAME TO demandes_service;

-- Renommer la colonne tarif_delegation en tarif_service
ALTER TABLE demandes_service 
CHANGE COLUMN tarif_delegation tarif_service DECIMAL(10,2) NOT NULL COMMENT 'Frais de service selon commune';

-- Mettre à jour les commentaires de la table
ALTER TABLE demandes_service 
MODIFY COLUMN tarif DECIMAL(10,2) NOT NULL COMMENT 'Tarif total (service + coût légal)';











