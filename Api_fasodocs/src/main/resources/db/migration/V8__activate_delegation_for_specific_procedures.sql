-- Migration pour activer la délégation uniquement pour les procédures spécifiées
-- Service de délégation disponible uniquement pour certaines procédures
-- 
-- Catégories concernées :
-- 1. Identité et citoyenneté (certaines procédures)
-- 2. Création d'entreprise (toutes)
-- 3. Documents auto (certaines procédures)
-- 4. Service foncier (certaines procédures)
-- 5. Eau et électricité (certaines procédures)

-- Désactiver la délégation pour toutes les procédures d'abord
UPDATE procedures SET peut_etre_delegatee = FALSE;

-- ============================================
-- 1. IDENTITÉ ET CITOYENNETÉ
-- ============================================
UPDATE procedures 
SET peut_etre_delegatee = TRUE 
WHERE nom LIKE '%Extrait d''acte de naissance%'
   OR nom LIKE '%Extrait d''acte de mariage%'
   OR nom LIKE '%Acte de décès%'
   OR nom LIKE '%Certificat de nationalité%'
   OR nom LIKE '%Certificat de casier judiciaire%'
   OR nom LIKE '%Fiche de résidence%'
   OR nom LIKE '%Extrait%acte%naissance%'
   OR nom LIKE '%Extrait%acte%mariage%'
   OR nom LIKE '%Casier judiciaire%'
   OR nom LIKE '%Résidence%';

-- ============================================
-- 2. CRÉATION D'ENTREPRISE
-- ============================================
UPDATE procedures 
SET peut_etre_delegatee = TRUE 
WHERE nom LIKE '%Entreprise individuelle%'
   OR nom LIKE '%Entreprise SARL%'
   OR nom LIKE '%SARL U%'
   OR nom LIKE '%Société à Responsabilité Limitée Unipersonnelle%'
   OR nom LIKE '%Sociétés Anonymes%'
   OR nom LIKE '%Société Anonyme%'
   OR nom LIKE '%SA%' AND nom LIKE '%Société%'
   OR nom LIKE '%Sociétés en Nom Collectif%'
   OR nom LIKE '%Société en Nom Collectif%'
   OR nom LIKE '%SNC%' AND nom LIKE '%Société%'
   OR nom LIKE '%Sociétés en Commandite Simple%'
   OR nom LIKE '%Société en Commandite Simple%'
   OR nom LIKE '%SCS%' AND nom LIKE '%Société%'
   OR nom LIKE '%Sociétés par Actions Simplifiées%'
   OR nom LIKE '%Société par Actions Simplifiées%'
   OR nom LIKE '%SAS%' AND nom LIKE '%Société%'
   OR nom LIKE '%SASU%'
   OR nom LIKE '%Sociétés par Actions Simplifiées Unipersonnelle%'
   OR nom LIKE '%Société par Actions Simplifiées Unipersonnelle%'
   OR nom LIKE '%Création d''entreprise%'
   OR nom LIKE '%Création%entreprise%';

-- ============================================
-- 3. DOCUMENTS AUTO
-- ============================================
UPDATE procedures 
SET peut_etre_delegatee = TRUE 
WHERE nom LIKE '%Renouvellement%permis de conduire%'
   OR nom LIKE '%Renouvellement%permis%conduire%'
   OR nom LIKE '%Permis de conduire%renouvellement%'
   OR nom LIKE '%Carte grise%obtention%'
   OR nom LIKE '%Obtention%carte grise%'
   OR nom LIKE '%Carte grise%mutation%'
   OR nom LIKE '%Mutation%carte grise%'
   OR nom LIKE '%Carte grise%renouvellement%'
   OR nom LIKE '%Renouvellement%carte grise%'
   OR nom LIKE '%Visite technique%'
   OR nom LIKE '%Vignette%'
   OR nom LIKE '%Changer%voiture%taxi%'
   OR nom LIKE '%Changement de couleur de plaque%'
   OR nom LIKE '%Changement%couleur%plaque%'
   OR (nom LIKE '%Carte grise%' AND nom NOT LIKE '%perte%' AND nom NOT LIKE '%vol%');

-- ============================================
-- 4. SERVICES FONCIERS
-- ============================================
UPDATE procedures 
SET peut_etre_delegatee = TRUE 
WHERE nom LIKE '%Permis de construire%'
   OR nom LIKE '%Permis%construire%'
   OR nom LIKE '%Demande de bail%'
   OR nom LIKE '%Demande%bail%'
   OR nom LIKE '%Logement sociaux%'
   OR nom LIKE '%Logement social%'
   OR nom LIKE '%Titre foncier%'
   OR nom LIKE '%Vérification%titres de propriétés%'
   OR nom LIKE '%Vérification%titres de propriété%'
   OR nom LIKE '%Vérification%titre%propriété%'
   OR nom LIKE '%Lettre d''attribution%titre provisoire%concession rurale%'
   OR nom LIKE '%Lettre%attribution%titre provisoire%concession rurale%'
   OR nom LIKE '%Lettre de transfert%parcelle%usage d''habitation%'
   OR nom LIKE '%Lettre%transfert%parcelle%habitation%'
   OR nom LIKE '%Titre provisoire%titre foncier%'
   OR nom LIKE '%Titre provisoire%foncier%'
   OR nom LIKE '%Concession urbaine%usage d''habitation%'
   OR nom LIKE '%Concession urbaine%habitation%'
   OR nom LIKE '%CUH%'
   OR nom LIKE '%CRH%'
   OR nom LIKE '%Concession rurale%habitation%';

-- ============================================
-- 5. EAU ET ÉLECTRICITÉ
-- ============================================
UPDATE procedures 
SET peut_etre_delegatee = TRUE 
WHERE nom LIKE '%Demande%compteur d''eau%'
   OR nom LIKE '%Demande%compteur%eau%'
   OR nom LIKE '%Demande%compteur d''électricité%'
   OR nom LIKE '%Demande%compteur%électricité%'
   OR nom LIKE '%Récupérer%compteur d''eau%suspendue%'
   OR nom LIKE '%Récupérer%compteur%eau%suspendue%'
   OR nom LIKE '%Récupérer%compteur d''électricité%suspendue%'
   OR nom LIKE '%Récupérer%compteur%électricité%suspendue%'
   OR nom LIKE '%Récupération%compteur%eau%suspendu%'
   OR nom LIKE '%Récupération%compteur%électricité%suspendu%'
   OR nom LIKE '%Demande de transférer%compteur d''eau%'
   OR nom LIKE '%Demande%transférer%compteur%eau%'
   OR nom LIKE '%Transfert%compteur%eau%'
   OR nom LIKE '%Demande de transférer%compteur d''électricité%'
   OR nom LIKE '%Demande%transférer%compteur%électricité%'
   OR nom LIKE '%Transfert%compteur%électricité%'
   OR (nom LIKE '%Compteur d''eau%' AND nom NOT LIKE '%réparation%' AND nom NOT LIKE '%panne%')
   OR (nom LIKE '%Compteur d''électricité%' AND nom NOT LIKE '%réparation%' AND nom NOT LIKE '%panne%');

-- ============================================
-- VÉRIFICATION
-- ============================================
-- Pour vérifier les procédures avec délégation activée :
-- SELECT id, nom, peut_etre_delegatee FROM procedures WHERE peut_etre_delegatee = TRUE ORDER BY nom;
-- 
-- Pour compter :
-- SELECT COUNT(*) as total_procedures_delegables FROM procedures WHERE peut_etre_delegatee = TRUE;

