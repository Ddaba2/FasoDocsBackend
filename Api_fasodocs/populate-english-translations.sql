-- ============================================
-- TRADUCTIONS ANGLAISES - FasoDocs
-- Script pour peupler les traductions des catégories, sous-catégories et procédures
-- Date: 2025-11-13
-- ============================================

USE FasoDocs;

-- ============================================
-- 1. CATÉGORIES - Traductions anglaises
-- ============================================

UPDATE categories SET 
    titre_en = 'Identity and citizenship',
    description_en = 'Identity documents, civil status and citizenship'
WHERE titre = 'Identité et citoyenneté';

UPDATE categories SET 
    titre_en = 'Business creation',
    description_en = 'Business creation and registration'
WHERE titre = 'Création d''entreprise';

UPDATE categories SET 
    titre_en = 'Vehicle documents',
    description_en = 'Driver''s license, vehicle registration and car documents'
WHERE titre = 'Documents auto';

UPDATE categories SET 
    titre_en = 'Land services',
    description_en = 'Land, land titles and building permits'
WHERE titre = 'Service fonciers';

UPDATE categories SET 
    titre_en = 'Water and electricity',
    description_en = 'Water and electricity meters'
WHERE titre = 'Eau et électricité';

UPDATE categories SET 
    titre_en = 'Justice',
    description_en = 'Judicial and legal procedures'
WHERE titre = 'Justice';

UPDATE categories SET 
    titre_en = 'Tax and Customs',
    description_en = 'Tax declarations and taxes'
WHERE titre = 'Impôt et Douane';

-- ============================================
-- 2. SOUS-CATÉGORIES - Traductions anglaises (Identité et citoyenneté)
-- ============================================

UPDATE sous_categories SET 
    titre_en = 'Birth certificate',
    description_en = 'Obtain a birth certificate'
WHERE titre = 'Extrait d''acte de naissance';

UPDATE sous_categories SET 
    titre_en = 'Marriage certificate',
    description_en = 'Obtain a marriage certificate'
WHERE titre = 'Extrait d''acte de mariage';

UPDATE sous_categories SET 
    titre_en = 'Divorce request',
    description_en = 'Divorce procedure'
WHERE titre = 'Demande de divorce';

UPDATE sous_categories SET 
    titre_en = 'Death certificate',
    description_en = 'Obtain a death certificate'
WHERE titre = 'Acte de décès';

UPDATE sous_categories SET 
    titre_en = 'Certificate of nationality',
    description_en = 'Obtain a certificate of nationality'
WHERE titre = 'Certificat de nationalité';

UPDATE sous_categories SET 
    titre_en = 'Criminal record certificate',
    description_en = 'Obtain a criminal record certificate'
WHERE titre = 'Certificat de casier judiciaire';

UPDATE sous_categories SET 
    titre_en = 'National identity card',
    description_en = 'Obtain a national identity card'
WHERE titre = 'Carte d''identité nationale';

UPDATE sous_categories SET 
    titre_en = 'Malian passport',
    description_en = 'Obtain a Malian passport'
WHERE titre = 'Passeport malien';

UPDATE sous_categories SET 
    titre_en = 'Nationality (by naturalization, by marriage)',
    description_en = 'Obtain Malian nationality'
WHERE titre = 'Nationalité(par voie de naturalisation, par mariage)';

UPDATE sous_categories SET 
    titre_en = 'Voter card',
    description_en = 'Obtain a voter card'
WHERE titre = 'Carte d''électeur';

UPDATE sous_categories SET 
    titre_en = 'Residence permit',
    description_en = 'Obtain a residence permit'
WHERE titre = 'Fiche de résidence';

UPDATE sous_categories SET 
    titre_en = 'Electoral list registration',
    description_en = 'Register on the electoral list'
WHERE titre = 'Inscription liste électorale';

-- ============================================
-- 3. SOUS-CATÉGORIES - Création d'entreprise
-- ============================================

UPDATE sous_categories SET 
    titre_en = 'Sole proprietorship',
    description_en = 'Create a sole proprietorship'
WHERE titre = 'Entreprise individuel';

UPDATE sous_categories SET 
    titre_en = 'SARL company',
    description_en = 'Create an SARL company'
WHERE titre = 'Entreprise SARL';

UPDATE sous_categories SET 
    titre_en = 'Single-person limited liability company (EURL, SARL unipersonnelle)',
    description_en = 'Create a single-person limited liability company'
WHERE titre = 'Entreprise unipersonnelle à responsabilité limitée (EURL, SARL unipersonnelle)';

UPDATE sous_categories SET 
    titre_en = 'Public limited companies (SA)',
    description_en = 'Create a public limited company'
WHERE titre = 'Sociétés Anonymes (SA)';

-- ============================================
-- 4. SOUS-CATÉGORIES - Documents auto
-- ============================================

UPDATE sous_categories SET 
    titre_en = 'Driver''s license',
    description_en = 'Obtain a driver''s license'
WHERE titre = 'Permis de conduire';

UPDATE sous_categories SET 
    titre_en = 'Vehicle registration',
    description_en = 'Obtain vehicle registration (carte grise)'
WHERE titre = 'Carte grise';

UPDATE sous_categories SET 
    titre_en = 'Vehicle technical inspection',
    description_en = 'Vehicle technical inspection'
WHERE titre = 'Visite technique automobile';

-- ============================================
-- 5. SOUS-CATÉGORIES - Services fonciers
-- ============================================

UPDATE sous_categories SET 
    titre_en = 'Building permit',
    description_en = 'Obtain a building permit'
WHERE titre = 'Permis de construire';

UPDATE sous_categories SET 
    titre_en = 'Land title',
    description_en = 'Obtain a land title'
WHERE titre = 'Titre foncier';

-- ============================================
-- 6. SOUS-CATÉGORIES - Eau et électricité
-- ============================================

UPDATE sous_categories SET 
    titre_en = 'Water meter',
    description_en = 'Install a water meter'
WHERE titre = 'Compteur d''eau';

UPDATE sous_categories SET 
    titre_en = 'Electricity meter',
    description_en = 'Install an electricity meter'
WHERE titre = 'Compteur d''électricité';

-- ============================================
-- 7. PROCÉDURES - Traductions anglaises (exemples)
-- ============================================

UPDATE procedures SET 
    nom_en = 'Marriage certificate',
    titre_en = 'Obtain a marriage certificate',
    description_en = 'Procedure to obtain a marriage certificate from the town hall. The legal period for celebration is 15 clear days after the declaration, unless derogation and if there is no opposition.',
    delai_en = '1 week after marriage'
WHERE nom = 'Extrait d''acte de mariage';

UPDATE procedures SET 
    nom_en = 'Birth certificate',
    titre_en = 'Obtain a birth certificate',
    description_en = 'Procedure to obtain a birth certificate from the town hall.',
    delai_en = 'Immediate'
WHERE nom = 'Extrait d''acte de naissance';

UPDATE procedures SET 
    nom_en = 'National identity card',
    titre_en = 'Obtain a national identity card',
    description_en = 'Procedure to obtain a Malian national identity card.',
    delai_en = '2 to 4 weeks'
WHERE nom = 'Carte d''identité nationale';

UPDATE procedures SET 
    nom_en = 'Malian passport',
    titre_en = 'Obtain a Malian passport',
    description_en = 'Procedure to obtain a Malian passport.',
    delai_en = '3 to 6 weeks'
WHERE nom = 'Passeport malien';

UPDATE procedures SET 
    nom_en = 'Driver''s license',
    titre_en = 'Obtain a driver''s license',
    description_en = 'Procedure to obtain a driver''s license in Mali.',
    delai_en = 'Variable according to training'
WHERE nom = 'Permis de conduire';

UPDATE procedures SET 
    nom_en = 'Vehicle registration',
    titre_en = 'Obtain vehicle registration',
    description_en = 'Procedure to obtain vehicle registration (carte grise) in Mali.',
    delai_en = '1 to 2 weeks'
WHERE nom = 'Carte grise';

-- ============================================
-- 8. CENTRES - Traductions anglaises
-- ============================================

UPDATE centres SET 
    nom_en = 'Town Hall',
    adresse_en = 'Town Hall of your municipality',
    horaires_en = 'Monday-Friday: 8am-4pm, Saturday: 8am-12pm'
WHERE nom = 'Mairie';

UPDATE centres SET 
    nom_en = 'Court',
    adresse_en = 'Court of your jurisdiction',
    horaires_en = 'Monday-Friday: 8am-4pm'
WHERE nom = 'Tribunal';

-- ============================================
-- VÉRIFICATION
-- ============================================

SELECT 
    'Catégories traduites' as type,
    COUNT(*) as total,
    SUM(CASE WHEN titre_en IS NOT NULL THEN 1 ELSE 0 END) as translated
FROM categories

UNION ALL

SELECT 
    'Sous-catégories traduites' as type,
    COUNT(*) as total,
    SUM(CASE WHEN titre_en IS NOT NULL THEN 1 ELSE 0 END) as translated
FROM sous_categories

UNION ALL

SELECT 
    'Procédures traduites' as type,
    COUNT(*) as total,
    SUM(CASE WHEN titre_en IS NOT NULL THEN 1 ELSE 0 END) as translated
FROM procedures;

-- ============================================
-- NOTES
-- ============================================
-- ✅ Traductions basiques pour les catégories principales
-- ✅ Traductions pour les sous-catégories les plus courantes
-- ✅ Traductions pour quelques procédures clés
-- ⚠️  Pour les autres procédures, vous devrez ajouter les traductions manuellement
--     ou utiliser un outil de traduction
-- ============================================

SELECT '✅ Traductions anglaises ajoutées avec succès !' as status;





















