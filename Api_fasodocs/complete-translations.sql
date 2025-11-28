-- ============================================
-- TRADUCTIONS COMPLÈTES - Sous-catégories et Procédures
-- FasoDocs - Traductions Anglaises Additionnelles
-- ============================================

USE FasoDocs;

-- ============================================
-- SOUS-CATÉGORIES - Compléter les traductions
-- ============================================

-- Déjà traduites : Extrait d'acte de naissance, mariage, divorce, décès, nationalité, casier, passeport

-- Manquantes importantes :
UPDATE sous_categories SET 
    titre_en = 'Biometric national identity card',
    description_en = 'Obtain a biometric national identity card'
WHERE titre = 'Carte nationale d''identité biométrique' OR titre LIKE '%Carte%identité%';

UPDATE sous_categories SET 
    titre_en = 'Individual form',
    description_en = 'Obtain an individual form'
WHERE titre = 'Fiche individuelle';

UPDATE sous_categories SET 
    titre_en = 'Nationality by naturalization',
    description_en = 'Obtain Malian nationality by naturalization'
WHERE titre = 'Nationalité par voie de naturalisation' OR titre LIKE '%naturalisation%';

UPDATE sous_categories SET 
    titre_en = 'Nationality (by naturalization, by marriage)',
    description_en = 'Obtain Malian nationality'
WHERE titre LIKE 'Nationalité%' AND titre_en IS NULL;

UPDATE sous_categories SET 
    titre_en = 'Voter card',
    description_en = 'Obtain a voter card'
WHERE titre = 'Carte d''électeur' OR titre LIKE '%électeur%';

UPDATE sous_categories SET 
    titre_en = 'Residence permit',
    description_en = 'Obtain a residence permit'
WHERE titre = 'Fiche de résidence' OR titre LIKE '%résidence%';

UPDATE sous_categories SET 
    titre_en = 'Electoral list registration',
    description_en = 'Register on the electoral list'
WHERE titre = 'Inscription liste électorale' OR titre LIKE '%liste électorale%';

UPDATE sous_categories SET 
    titre_en = 'Sole proprietorship',
    description_en = 'Create a sole proprietorship'
WHERE titre = 'Entreprise individuel' OR titre LIKE '%individuel%';

UPDATE sous_categories SET 
    titre_en = 'SARL company',
    description_en = 'Create an SARL company (Limited Liability Company)'
WHERE titre = 'Entreprise SARL' OR titre LIKE '%SARL%';

UPDATE sous_categories SET 
    titre_en = 'Single-person limited liability company (EURL)',
    description_en = 'Create a single-person limited liability company'
WHERE titre LIKE '%EURL%' OR titre LIKE '%unipersonnelle%';

UPDATE sous_categories SET 
    titre_en = 'Public limited company (SA)',
    description_en = 'Create a public limited company'
WHERE titre LIKE '%Sociétés Anonymes%' OR titre LIKE '%SA)%';

UPDATE sous_categories SET 
    titre_en = 'Driver''s license',
    description_en = 'Obtain a driver''s license'
WHERE titre = 'Permis de conduire' OR titre LIKE '%Permis%conduire%';

UPDATE sous_categories SET 
    titre_en = 'Vehicle registration (carte grise)',
    description_en = 'Obtain vehicle registration'
WHERE titre = 'Carte grise' OR titre LIKE '%Carte grise%';

UPDATE sous_categories SET 
    titre_en = 'Vehicle technical inspection',
    description_en = 'Vehicle technical inspection'
WHERE titre LIKE '%Visite technique%' OR titre LIKE '%contrôle technique%';

UPDATE sous_categories SET 
    titre_en = 'Building permit',
    description_en = 'Obtain a building permit'
WHERE titre = 'Permis de construire' OR titre LIKE '%Permis%construire%';

UPDATE sous_categories SET 
    titre_en = 'Land title',
    description_en = 'Obtain a land title'
WHERE titre = 'Titre foncier' OR titre LIKE '%Titre foncier%';

UPDATE sous_categories SET 
    titre_en = 'Water meter',
    description_en = 'Install a water meter'
WHERE titre LIKE '%Compteur%eau%' OR titre = 'Compteur d''eau';

UPDATE sous_categories SET 
    titre_en = 'Electricity meter',
    description_en = 'Install an electricity meter'
WHERE titre LIKE '%Compteur%électricité%' OR titre = 'Compteur d''électricité';

-- ============================================
-- PROCÉDURES - Compléter les traductions
-- ============================================

-- Déjà traduite : Extrait d'acte de mariage

UPDATE procedures SET 
    nom_en = 'Divorce request',
    titre_en = 'File for divorce',
    description_en = 'Procedure to file for divorce at the courthouse.',
    delai_en = '6 to 12 months'
WHERE nom = 'Demande de divorce' OR nom LIKE '%divorce%';

UPDATE procedures SET 
    nom_en = 'Death certificate request',
    titre_en = 'Obtain a death certificate',
    description_en = 'Procedure to obtain a death certificate from the town hall.',
    delai_en = 'Within 24 hours after death'
WHERE nom = 'Demande d''acte de décès' OR nom LIKE '%acte de décès%';

UPDATE procedures SET 
    nom_en = 'Voter card request',
    titre_en = 'Obtain a voter card',
    description_en = 'Procedure to obtain a voter card.',
    delai_en = '2 to 4 weeks'
WHERE nom = 'Demande de carte d''électeur' OR nom LIKE '%carte%électeur%';

UPDATE procedures SET 
    nom_en = 'Certificate of nationality',
    titre_en = 'Obtain a certificate of nationality',
    description_en = 'Procedure to obtain a certificate of Malian nationality.',
    delai_en = '1 to 3 months'
WHERE nom = 'Certificat de nationalité' OR nom LIKE '%Certificat%nationalité%';

UPDATE procedures SET 
    nom_en = 'Electoral list registration',
    titre_en = 'Register on the electoral list',
    description_en = 'Procedure to register on the electoral list.',
    delai_en = 'During registration period'
WHERE nom = 'Inscription sur la liste électorale' OR nom LIKE '%liste électorale%';

UPDATE procedures SET 
    nom_en = 'Birth certificate request',
    titre_en = 'Obtain a birth certificate',
    description_en = 'Procedure to obtain a birth certificate from the town hall.',
    delai_en = 'Immediate'
WHERE nom = 'Demande d''extrait d''acte de naissance' OR nom LIKE '%acte de naissance%';

UPDATE procedures SET 
    nom_en = 'Criminal record request',
    titre_en = 'Obtain a criminal record certificate',
    description_en = 'Procedure to obtain a criminal record certificate.',
    delai_en = '3 to 7 days'
WHERE nom = 'Demande de casier judiciaire' OR nom LIKE '%casier judiciaire%';

UPDATE procedures SET 
    nom_en = 'Malian nationality by marriage',
    titre_en = 'Obtain Malian nationality by marriage',
    description_en = 'Procedure to obtain Malian nationality through marriage.',
    delai_en = '6 to 12 months'
WHERE nom = 'Nationalité malienne par mariage' OR nom LIKE '%nationalité%mariage%';

UPDATE procedures SET 
    nom_en = 'Malian nationality by naturalization',
    titre_en = 'Obtain Malian nationality by naturalization',
    description_en = 'Procedure to obtain Malian nationality by naturalization.',
    delai_en = '1 to 2 years'
WHERE nom = 'Nationalité malienne par naturalisation' OR nom LIKE '%naturalisation%';

UPDATE procedures SET 
    nom_en = 'National identity card',
    titre_en = 'Obtain a national identity card',
    description_en = 'Procedure to obtain a Malian national identity card.',
    delai_en = '2 to 4 weeks'
WHERE nom LIKE '%Carte%identité%' OR nom LIKE '%identité nationale%';

UPDATE procedures SET 
    nom_en = 'Malian passport',
    titre_en = 'Obtain a Malian passport',
    description_en = 'Procedure to obtain a Malian passport.',
    delai_en = '3 to 6 weeks'
WHERE nom LIKE '%Passeport%';

UPDATE procedures SET 
    nom_en = 'Driver''s license',
    titre_en = 'Obtain a driver''s license',
    description_en = 'Procedure to obtain a driver''s license in Mali.',
    delai_en = 'Variable according to training'
WHERE nom LIKE '%Permis de conduire%';

UPDATE procedures SET 
    nom_en = 'Vehicle registration',
    titre_en = 'Obtain vehicle registration',
    description_en = 'Procedure to obtain vehicle registration (carte grise) in Mali.',
    delai_en = '1 to 2 weeks'
WHERE nom LIKE '%Carte grise%';

UPDATE procedures SET 
    nom_en = 'Business registration',
    titre_en = 'Register a business',
    description_en = 'Procedure to register a business in Mali.',
    delai_en = '1 to 4 weeks'
WHERE nom LIKE '%Création%entreprise%' OR nom LIKE '%immatriculation%';

UPDATE procedures SET 
    nom_en = 'Building permit',
    titre_en = 'Obtain a building permit',
    description_en = 'Procedure to obtain a building permit.',
    delai_en = '2 to 6 months'
WHERE nom LIKE '%Permis de construire%';

UPDATE procedures SET 
    nom_en = 'Land title',
    titre_en = 'Obtain a land title',
    description_en = 'Procedure to obtain a land title.',
    delai_en = '6 to 18 months'
WHERE nom LIKE '%Titre foncier%';

UPDATE procedures SET 
    nom_en = 'Water meter installation',
    titre_en = 'Install a water meter',
    description_en = 'Procedure to install a water meter.',
    delai_en = '1 to 2 weeks'
WHERE nom LIKE '%Compteur%eau%';

UPDATE procedures SET 
    nom_en = 'Electricity meter installation',
    titre_en = 'Install an electricity meter',
    description_en = 'Procedure to install an electricity meter.',
    delai_en = '1 to 2 weeks'
WHERE nom LIKE '%Compteur%électricité%';

-- ============================================
-- VÉRIFICATION
-- ============================================

SELECT '=== SOUS-CATÉGORIES ===' as info;
SELECT 
    COUNT(*) as total,
    SUM(CASE WHEN titre_en IS NOT NULL THEN 1 ELSE 0 END) as traduites,
    CONCAT(ROUND(SUM(CASE WHEN titre_en IS NOT NULL THEN 1 ELSE 0 END) / COUNT(*) * 100, 1), '%') as pourcentage
FROM sous_categories;

SELECT '=== PROCÉDURES ===' as info;
SELECT 
    COUNT(*) as total,
    SUM(CASE WHEN nom_en IS NOT NULL THEN 1 ELSE 0 END) as traduites,
    CONCAT(ROUND(SUM(CASE WHEN nom_en IS NOT NULL THEN 1 ELSE 0 END) / COUNT(*) * 100, 1), '%') as pourcentage
FROM procedures;

SELECT '✅ Traductions additionnelles ajoutées avec succès !' as status;




















