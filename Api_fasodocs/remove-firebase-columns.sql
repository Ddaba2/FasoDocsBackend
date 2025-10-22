USE FasoDocs;

-- Supprimer la colonne token_fcm de la table citoyens
ALTER TABLE citoyens DROP COLUMN IF EXISTS token_fcm;

-- Afficher un message de confirmation
SELECT 'Colonnes Firebase supprimées avec succès!' as Message;
