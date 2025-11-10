-- ============================================================================
-- Script d'ajout des centres pour Demande de bail et Logements sociaux
-- ============================================================================

USE fasodocs;

-- ============================================================================
-- 1. CRÉER LE CENTRE POUR LA DEMANDE DE BAIL
-- ============================================================================

-- Centre: Direction Nationale des Domaines et du Cadastre (DNDC)
INSERT INTO centres (nom, adresse, telephone, email, horaires, coordonnees_gps)
SELECT * FROM (SELECT 
    'Direction Nationale des Domaines et du Cadastre (DNDC)' as nom,
    'Ministère de l''Économie et des Finances, Bamako, Mali' as adresse,
    '+223 20 22 XX XX' as telephone,
    'contact@dndc.gouv.ml' as email,
    'Lundi - Vendredi: 08h00 - 16h00' as horaires,
    '12.6392,-8.0029' as coordonnees_gps
) AS tmp
WHERE NOT EXISTS (
    SELECT id FROM centres WHERE nom LIKE '%Direction Nationale des Domaines et du Cadastre%'
) LIMIT 1;

-- Récupérer l'ID du centre DNDC
SET @dndc_id = (SELECT id FROM centres WHERE nom LIKE '%Direction Nationale des Domaines et du Cadastre%' ORDER BY id DESC LIMIT 1);

-- ============================================================================
-- 2. CRÉER LE CENTRE POUR LES LOGEMENTS SOCIAUX
-- ============================================================================

-- Centre: Office Malien de l'Habitat (OMH)
INSERT INTO centres (nom, adresse, telephone, email, horaires, coordonnees_gps)
SELECT * FROM (SELECT 
    'Office Malien de l''Habitat (OMH)' as nom,
    'Direction Générale de l''Office Malien de l''Habitat, Darsalam, Bamako' as adresse,
    '+223 20 23 XX XX' as telephone,
    'contact@omh-mali.org' as email,
    'Lundi - Vendredi: 08h00 - 17h00' as horaires,
    '12.6542,-8.0156' as coordonnees_gps
) AS tmp
WHERE NOT EXISTS (
    SELECT id FROM centres WHERE nom LIKE '%Office Malien de l''Habitat%'
) LIMIT 1;

-- Récupérer l'ID du centre OMH
SET @omh_id = (SELECT id FROM centres WHERE nom LIKE '%Office Malien de l''Habitat%' ORDER BY id DESC LIMIT 1);

-- ============================================================================
-- 3. LIER LES CENTRES AUX PROCÉDURES
-- ============================================================================

-- Lier DNDC à la procédure "Obtenir un bail de location" (ID: 78)
UPDATE procedures 
SET centre_id = @dndc_id
WHERE id = 78;

-- Lier OMH à la procédure "Obtenir un logement social" (ID: 77)
UPDATE procedures 
SET centre_id = @omh_id
WHERE id = 77;

-- ============================================================================
-- 4. VÉRIFICATION
-- ============================================================================

-- Afficher les procédures avec leurs centres
SELECT 
    p.id,
    p.titre AS 'Procédure',
    c.nom AS 'Centre de traitement',
    c.adresse AS 'Adresse',
    c.email AS 'Email'
FROM procedures p
LEFT JOIN centres c ON p.centre_id = c.id
WHERE p.id IN (77, 78)
ORDER BY p.id;

-- Message de confirmation
SELECT '✅ Centres créés et liés avec succès!' AS 'Statut';
