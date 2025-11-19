-- Migration pour simplifier la gestion des rôles
-- Remplace la table citoyen_roles par un champ role dans la table citoyens

-- Étape 1 : Ajouter le champ role à la table citoyens
ALTER TABLE citoyens 
ADD COLUMN role VARCHAR(20) NOT NULL DEFAULT 'USER'
COMMENT 'Rôle du citoyen : USER ou ADMIN';

-- Étape 2 : Mettre à jour les citoyens qui ont le rôle ADMIN
-- On parcourt la table citoyen_roles pour identifier les admins
UPDATE citoyens c
SET c.role = 'ADMIN'
WHERE EXISTS (
    SELECT 1 
    FROM citoyen_roles cr
    INNER JOIN roles r ON cr.role_id = r.id
    WHERE cr.citoyen_id = c.id 
    AND r.nom = 'ROLE_ADMIN'
);

-- Étape 3 : Supprimer la table citoyen_roles (table de jointure)
DROP TABLE IF EXISTS citoyen_roles;

-- Étape 4 : Supprimer la table roles (optionnel, plus nécessaire)
DROP TABLE IF EXISTS roles;

-- Note : Les valeurs possibles pour le champ role sont : 'USER' et 'ADMIN'
-- Par défaut, tous les nouveaux citoyens auront le rôle 'USER'

