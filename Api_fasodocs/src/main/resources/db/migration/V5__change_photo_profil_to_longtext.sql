-- Migration pour changer le type de photo_profil de LONGBLOB à LONGTEXT
-- LONGTEXT est plus approprié pour stocker du texte Base64 que LONGBLOB
-- Cette migration corrige les problèmes de sérialisation/désérialisation

ALTER TABLE citoyens 
MODIFY COLUMN photo_profil LONGTEXT NULL 
COMMENT 'Photo de profil du citoyen en format Base64 (stockée en LONGTEXT pour texte)';

