-- Migration pour ajouter le champ audio_url aux procédures
-- Ce champ permet de stocker le chemin/URL vers un fichier audio de fallback
-- qui sera utilisé si Djelia AI ne fonctionne pas

ALTER TABLE procedures 
ADD COLUMN audio_url VARCHAR(500) NULL 
COMMENT 'URL ou chemin vers le fichier audio de fallback pour la procédure (utilisé si Djelia AI échoue)';

