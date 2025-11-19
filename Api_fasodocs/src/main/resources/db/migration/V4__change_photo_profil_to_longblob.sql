-- Migration pour changer le type de photo_profil de LONGTEXT à LONGBLOB
-- Cette migration modifie le type de colonne pour optimiser le stockage des images

ALTER TABLE citoyens 
MODIFY COLUMN photo_profil LONGBLOB NULL 
COMMENT 'Photo de profil du citoyen en format Base64 (stockée en BLOB)';

