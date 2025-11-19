-- Script SQL pour vérifier l'état de la photo de profil en base de données

USE FasoDocs;

-- 1. Vérifier le type de la colonne photo_profil
DESCRIBE citoyens;

-- 2. Vérifier la valeur de photo_profil pour l'utilisateur ID 6
SELECT 
    id,
    nom,
    prenom,
    telephone,
    CASE 
        WHEN photo_profil IS NULL THEN 'NULL'
        WHEN photo_profil = '' THEN 'VIDE'
        WHEN LENGTH(photo_profil) = 0 THEN 'VIDE (0 bytes)'
        ELSE CONCAT('PRÉSENTE (', LENGTH(photo_profil), ' caractères)')
    END AS statut_photo,
    CASE 
        WHEN photo_profil IS NOT NULL AND LENGTH(photo_profil) > 0 THEN 
            LEFT(photo_profil, 50)
        ELSE NULL
    END AS preview_photo,
    date_creation,
    date_modification
FROM citoyens 
WHERE id = 6;

-- 3. Vérifier tous les utilisateurs avec leur statut photo
SELECT 
    id,
    nom,
    prenom,
    CASE 
        WHEN photo_profil IS NULL THEN 'NULL'
        WHEN photo_profil = '' THEN 'VIDE'
        ELSE CONCAT('PRÉSENTE (', LENGTH(photo_profil), ' car.)')
    END AS statut_photo
FROM citoyens
ORDER BY id;

-- 4. Compter les utilisateurs avec/sans photo
SELECT 
    CASE 
        WHEN photo_profil IS NULL OR photo_profil = '' THEN 'SANS PHOTO'
        ELSE 'AVEC PHOTO'
    END AS categorie,
    COUNT(*) AS nombre
FROM citoyens
GROUP BY categorie;

