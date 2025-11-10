-- Migration pour ajouter le champ photo_profil à la table citoyens
-- Cette migration ajoute le support des photos de profil stockées en Base64

ALTER TABLE citoyens 
ADD COLUMN photo_profil LONGTEXT NULL 
COMMENT 'Photo de profil du citoyen en format Base64';

