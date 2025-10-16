-- ============================================
-- DONNÉES COMPLÈTES FASODOCS - MALI
-- ============================================
-- Catégories et Sous-Catégories Réelles
-- Date: Octobre 2025
-- ============================================

-- IMPORTANT: Exécutez ce script APRÈS le premier démarrage de l'application
-- Les tables doivent être créées par Hibernate avant d'insérer les données

-- ============================================
-- 1. CATÉGORIES PRINCIPALES (7)
-- ============================================

INSERT INTO categories (titre, description, icone_url, date_creation) VALUES
('Identité et citoyenneté', 'Documents d''identité, état civil et citoyenneté', '🪪', NOW()),
('Création d''entreprise', 'Création et immatriculation d''entreprises', '🏢', NOW()),
('Documents auto', 'Permis de conduire, carte grise et documents automobiles', '🚗', NOW()),
('Service fonciers', 'Terrains, titres fonciers et permis de construire', '🏗️', NOW()),
('Eau et électricité', 'Compteurs d''eau et d''électricité', '💡', NOW()),
('Justice', 'Procédures judiciaires et juridiques', '⚖️', NOW()),
('Impôt et Douane', 'Déclarations fiscales et taxes', '💰', NOW());

-- ============================================
-- 2. SOUS-CATÉGORIES PAR CATÉGORIE
-- ============================================

-- ============================================
-- 2.1. IDENTITÉ ET CITOYENNETÉ (12 sous-catégories)
-- ============================================

INSERT INTO sous_categories (titre, description, icone_url, categorie_id, date_creation) VALUES
-- Catégorie 1: Identité et citoyenneté
('Extrait d''acte de naissance', 'Obtenir un extrait d''acte de naissance', '👶', 
 (SELECT id FROM categories WHERE titre = 'Identité et citoyenneté' LIMIT 1), NOW()),
 
('Extrait d''acte de mariage', 'Obtenir un extrait d''acte de mariage', '💍', 
 (SELECT id FROM categories WHERE titre = 'Identité et citoyenneté' LIMIT 1), NOW()),
 
('Demande de divorce', 'Procédure de divorce', '💔', 
 (SELECT id FROM categories WHERE titre = 'Identité et citoyenneté' LIMIT 1), NOW()),
 
('Acte de décès', 'Déclaration et obtention d''acte de décès', '⚰️', 
 (SELECT id FROM categories WHERE titre = 'Identité et citoyenneté' LIMIT 1), NOW()),
 
('Certificat de nationalité', 'Obtenir un certificat de nationalité malienne', '🇲🇱', 
 (SELECT id FROM categories WHERE titre = 'Identité et citoyenneté' LIMIT 1), NOW()),
 
('Certificat de casier judiciaire', 'Demande de casier judiciaire', '📋', 
 (SELECT id FROM categories WHERE titre = 'Identité et citoyenneté' LIMIT 1), NOW()),
 
('Carte d''identité nationale', 'Obtenir ou renouveler la carte NINA', '🪪', 
 (SELECT id FROM categories WHERE titre = 'Identité et citoyenneté' LIMIT 1), NOW()),
 
('Passeport malien', 'Demande de passeport biométrique malien', '🛂', 
 (SELECT id FROM categories WHERE titre = 'Identité et citoyenneté' LIMIT 1), NOW()),
 
('Nationalité (par voie de naturalisation, par mariage)', 'Acquisition de la nationalité malienne', '🇲🇱', 
 (SELECT id FROM categories WHERE titre = 'Identité et citoyenneté' LIMIT 1), NOW()),
 
('Carte d''électeur', 'Inscription et obtention de carte d''électeur', '🗳️', 
 (SELECT id FROM categories WHERE titre = 'Identité et citoyenneté' LIMIT 1), NOW()),
 
('Fiche de résidence', 'Obtenir une fiche de résidence', '🏠', 
 (SELECT id FROM categories WHERE titre = 'Identité et citoyenneté' LIMIT 1), NOW()),
 
('Inscription liste électorale', 'S''inscrire sur les listes électorales', '📝', 
 (SELECT id FROM categories WHERE titre = 'Identité et citoyenneté' LIMIT 1), NOW());

-- ============================================
-- 2.2. CRÉATION D'ENTREPRISE (8 sous-catégories)
-- ============================================

INSERT INTO sous_categories (titre, description, icone_url, categorie_id, date_creation) VALUES
-- Catégorie 2: Création d'entreprise
('Entreprise individuelle', 'Création d''une entreprise individuelle', '👤', 
 (SELECT id FROM categories WHERE titre = 'Création d''entreprise' LIMIT 1), NOW()),
 
('Entreprise SARL', 'Création d''une Société à Responsabilité Limitée', '🏢', 
 (SELECT id FROM categories WHERE titre = 'Création d''entreprise' LIMIT 1), NOW()),
 
('Entreprise unipersonnelle à responsabilité limitée (EURL, SARL unipersonnelle)', 'Création d''une EURL', '👤', 
 (SELECT id FROM categories WHERE titre = 'Création d''entreprise' LIMIT 1), NOW()),
 
('Sociétés Anonymes (SA)', 'Création d''une Société Anonyme', '🏛️', 
 (SELECT id FROM categories WHERE titre = 'Création d''entreprise' LIMIT 1), NOW()),
 
('Sociétés en Nom Collectif (SNC)', 'Création d''une SNC', '👥', 
 (SELECT id FROM categories WHERE titre = 'Création d''entreprise' LIMIT 1), NOW()),
 
('Sociétés en Commandite Simple (SCS)', 'Création d''une SCS', '🤝', 
 (SELECT id FROM categories WHERE titre = 'Création d''entreprise' LIMIT 1), NOW()),
 
('Sociétés par Actions Simplifiées (SAS)', 'Création d''une SAS', '📈', 
 (SELECT id FROM categories WHERE titre = 'Création d''entreprise' LIMIT 1), NOW()),
 
('Sociétés par Actions Simplifiées Unipersonnelle (SASU)', 'Création d''une SASU', '👤', 
 (SELECT id FROM categories WHERE titre = 'Création d''entreprise' LIMIT 1), NOW());

-- ============================================
-- 2.3. DOCUMENTS AUTO (5 sous-catégories)
-- ============================================

INSERT INTO sous_categories (titre, description, icone_url, categorie_id, date_creation) VALUES
-- Catégorie 3: Documents auto
('Permis de conduire (renouvellement)', 'Obtenir ou renouveler un permis de conduire', '🚗', 
 (SELECT id FROM categories WHERE titre = 'Documents auto' LIMIT 1), NOW()),
 
('Carte grise (obtention, mutation et renouvellement)', 'Carte grise pour véhicule', '📄', 
 (SELECT id FROM categories WHERE titre = 'Documents auto' LIMIT 1), NOW()),
 
('Visite technique', 'Contrôle technique de véhicule', '🔧', 
 (SELECT id FROM categories WHERE titre = 'Documents auto' LIMIT 1), NOW()),
 
('Vignette', 'Obtenir la vignette automobile', '🏷️', 
 (SELECT id FROM categories WHERE titre = 'Documents auto' LIMIT 1), NOW()),
 
('Changement de couleur de plaque', 'Changer la couleur de plaque d''immatriculation', '🎨', 
 (SELECT id FROM categories WHERE titre = 'Documents auto' LIMIT 1), NOW());

-- ============================================
-- 2.4. SERVICE FONCIERS (9 sous-catégories)
-- ============================================

INSERT INTO sous_categories (titre, description, icone_url, categorie_id, date_creation) VALUES
-- Catégorie 4: Service fonciers
('Permis de construire (à usage industriel, à usage personnelle)', 'Obtenir un permis de construire', '🏗️', 
 (SELECT id FROM categories WHERE titre = 'Service fonciers' LIMIT 1), NOW()),
 
('Demande de bail', 'Établir un contrat de bail', '📝', 
 (SELECT id FROM categories WHERE titre = 'Service fonciers' LIMIT 1), NOW()),
 
('Titre foncier', 'Obtenir un titre foncier', '📜', 
 (SELECT id FROM categories WHERE titre = 'Service fonciers' LIMIT 1), NOW()),
 
('Vérification des titres de propriétés', 'Vérifier l''authenticité d''un titre de propriété', '🔍', 
 (SELECT id FROM categories WHERE titre = 'Service fonciers' LIMIT 1), NOW()),
 
('Lettre d''attribution du titre provisoire de concession rurale', 'Concession rurale provisoire', '🌾', 
 (SELECT id FROM categories WHERE titre = 'Service fonciers' LIMIT 1), NOW()),
 
('Permis d''occupation', 'Obtenir un permis d''occupation de terrain', '🏕️', 
 (SELECT id FROM categories WHERE titre = 'Service fonciers' LIMIT 1), NOW()),
 
('Lettre de transfert de parcelle à usage d''habitation', 'Transférer une parcelle', '🔄', 
 (SELECT id FROM categories WHERE titre = 'Service fonciers' LIMIT 1), NOW()),
 
('Titre provisoire en titre foncier (CUH, CRH et contrat de bail avec promesse de vente)', 'Convertir titre provisoire en titre foncier', '📋', 
 (SELECT id FROM categories WHERE titre = 'Service fonciers' LIMIT 1), NOW()),
 
('Concession urbaine à usage d''habitation (CUH)', 'Obtenir une CUH', '🏘️', 
 (SELECT id FROM categories WHERE titre = 'Service fonciers' LIMIT 1), NOW());

-- ============================================
-- 2.5. EAU ET ÉLECTRICITÉ (6 sous-catégories)
-- ============================================

INSERT INTO sous_categories (titre, description, icone_url, categorie_id, date_creation) VALUES
-- Catégorie 5: Eau et électricité
('Demande d''un compteur d''eau', 'Installer un nouveau compteur d''eau', '💧', 
 (SELECT id FROM categories WHERE titre = 'Eau et électricité' LIMIT 1), NOW()),
 
('Demande d''un compteur d''électricité', 'Installer un nouveau compteur d''électricité', '⚡', 
 (SELECT id FROM categories WHERE titre = 'Eau et électricité' LIMIT 1), NOW()),
 
('Récupérer un compteur d''eau suspendue', 'Rétablir un compteur d''eau suspendu', '💧', 
 (SELECT id FROM categories WHERE titre = 'Eau et électricité' LIMIT 1), NOW()),
 
('Récupérer un compteur d''électricité suspendue', 'Rétablir un compteur d''électricité suspendu', '⚡', 
 (SELECT id FROM categories WHERE titre = 'Eau et électricité' LIMIT 1), NOW()),
 
('Demande de transférer d''un compteur d''eau', 'Transférer un compteur d''eau', '🔄', 
 (SELECT id FROM categories WHERE titre = 'Eau et électricité' LIMIT 1), NOW()),
 
('Demande de transférer d''un compteur d''électricité', 'Transférer un compteur d''électricité', '🔄', 
 (SELECT id FROM categories WHERE titre = 'Eau et électricité' LIMIT 1), NOW());

-- ============================================
-- 2.6. JUSTICE (9 sous-catégories)
-- ============================================

INSERT INTO sous_categories (titre, description, icone_url, categorie_id, date_creation) VALUES
-- Catégorie 6: Justice
('Déclaration de vol', 'Déclarer un vol auprès des autorités', '🚨', 
 (SELECT id FROM categories WHERE titre = 'Justice' LIMIT 1), NOW()),
 
('Déclaration de perte', 'Déclarer une perte de document', '📋', 
 (SELECT id FROM categories WHERE titre = 'Justice' LIMIT 1), NOW()),
 
('Règlement d''un litige', 'Procédure de règlement de litige', '⚖️', 
 (SELECT id FROM categories WHERE titre = 'Justice' LIMIT 1), NOW()),
 
('Demande de visite d''un prisonnier', 'Obtenir une autorisation de visite en prison', '🔒', 
 (SELECT id FROM categories WHERE titre = 'Justice' LIMIT 1), NOW()),
 
('Demande d''appel d''une décision de jugement', 'Faire appel d''un jugement', '📜', 
 (SELECT id FROM categories WHERE titre = 'Justice' LIMIT 1), NOW()),
 
('Demande de libération conditionnelle', 'Demander une libération conditionnelle', '🆓', 
 (SELECT id FROM categories WHERE titre = 'Justice' LIMIT 1), NOW()),
 
('Demande de libération provisoire', 'Demander une libération provisoire', '🔓', 
 (SELECT id FROM categories WHERE titre = 'Justice' LIMIT 1), NOW()),
 
('Autorisation d''achat d''armes et munitions', 'Obtenir un permis de port d''armes', '🔫', 
 (SELECT id FROM categories WHERE titre = 'Justice' LIMIT 1), NOW()),
 
('Autorisation de vente des biens d''un mineur', 'Autorisation judiciaire pour vente', '👶', 
 (SELECT id FROM categories WHERE titre = 'Justice' LIMIT 1), NOW());

-- ============================================
-- 2.7. IMPÔT ET DOUANE (30 sous-catégories)
-- ============================================

INSERT INTO sous_categories (titre, description, icone_url, categorie_id, date_creation) VALUES
-- Catégorie 7: Impôt et Douane
('Déclaration de revenu foncier', 'Déclarer les revenus fonciers', '🏠', 
 (SELECT id FROM categories WHERE titre = 'Impôt et Douane' LIMIT 1), NOW()),
 
('Déclaration de TVA (Taxe sur la Valeur Ajoutée)', 'Déclaration mensuelle ou trimestrielle de TVA', '💰', 
 (SELECT id FROM categories WHERE titre = 'Impôt et Douane' LIMIT 1), NOW()),
 
('Enregistrement d''un contrat', 'Enregistrer un contrat aux impôts', '📝', 
 (SELECT id FROM categories WHERE titre = 'Impôt et Douane' LIMIT 1), NOW()),
 
('Impôt sur les traitements et salaires (I.T.S)', 'Déclaration I.T.S', '💼', 
 (SELECT id FROM categories WHERE titre = 'Impôt et Douane' LIMIT 1), NOW()),
 
('Contribution forfaitaire à la charge des employeurs (CFE)', 'Déclaration CFE', '🏢', 
 (SELECT id FROM categories WHERE titre = 'Impôt et Douane' LIMIT 1), NOW()),
 
('Taxe logement (TL)', 'Déclaration taxe logement', '🏘️', 
 (SELECT id FROM categories WHERE titre = 'Impôt et Douane' LIMIT 1), NOW()),
 
('Contribution Générale de solidarité (CGS)', 'Déclaration CGS', '🤝', 
 (SELECT id FROM categories WHERE titre = 'Impôt et Douane' LIMIT 1), NOW()),
 
('Taxe de Solidarité et de Lutte contre le Tabagisme (TSLT)', 'Déclaration TSLT', '🚭', 
 (SELECT id FROM categories WHERE titre = 'Impôt et Douane' LIMIT 1), NOW()),
 
('Impôt sur les bénéfices industriels et commerciaux (IBIC/IS)', 'Déclaration IBIC', '🏭', 
 (SELECT id FROM categories WHERE titre = 'Impôt et Douane' LIMIT 1), NOW()),
 
('Impôt synthétique', 'Régime de l''impôt synthétique', '📊', 
 (SELECT id FROM categories WHERE titre = 'Impôt et Douane' LIMIT 1), NOW()),
 
('Impôt sur les bénéfices agricoles (IBA)', 'Déclaration IBA', '🌾', 
 (SELECT id FROM categories WHERE titre = 'Impôt et Douane' LIMIT 1), NOW()),
 
('Impôt sur les revenus de valeurs Mobilières (IRVM)', 'Déclaration IRVM', '📈', 
 (SELECT id FROM categories WHERE titre = 'Impôt et Douane' LIMIT 1), NOW()),
 
('Impôt sur les revenus fonciers (IRF)', 'Déclaration IRF', '🏢', 
 (SELECT id FROM categories WHERE titre = 'Impôt et Douane' LIMIT 1), NOW()),
 
('Taxe foncière (T.F)', 'Paiement de la taxe foncière', '🏠', 
 (SELECT id FROM categories WHERE titre = 'Impôt et Douane' LIMIT 1), NOW()),
 
('Patente professionnelle et licence', 'Obtenir une patente professionnelle', '💼', 
 (SELECT id FROM categories WHERE titre = 'Impôt et Douane' LIMIT 1), NOW()),
 
('Patente sur marchés', 'Patente pour activités sur marchés', '🏪', 
 (SELECT id FROM categories WHERE titre = 'Impôt et Douane' LIMIT 1), NOW()),
 
('Taxe touristique (T.T)', 'Déclaration taxe touristique', '✈️', 
 (SELECT id FROM categories WHERE titre = 'Impôt et Douane' LIMIT 1), NOW()),
 
('Taxe sur les véhicules automobiles (Vignettes ordinaires)', 'Paiement de la vignette automobile', '🚗', 
 (SELECT id FROM categories WHERE titre = 'Impôt et Douane' LIMIT 1), NOW()),
 
('Taxe sur les transports routiers (TTR)', 'Déclaration TTR', '🚛', 
 (SELECT id FROM categories WHERE titre = 'Impôt et Douane' LIMIT 1), NOW()),
 
('Les prélèvements', 'Prélèvements fiscaux divers', '💸', 
 (SELECT id FROM categories WHERE titre = 'Impôt et Douane' LIMIT 1), NOW()),
 
('Redevance et recouvrement de régulation sur les marchés publics', 'Redevance marchés publics', '🏛️', 
 (SELECT id FROM categories WHERE titre = 'Impôt et Douane' LIMIT 1), NOW()),
 
('Impôt spécial sur certains produits (ISCP)', 'Déclaration ISCP', '📦', 
 (SELECT id FROM categories WHERE titre = 'Impôt et Douane' LIMIT 1), NOW()),
 
('Taxe sur les activités financières (TAF)', 'Déclaration TAF', '🏦', 
 (SELECT id FROM categories WHERE titre = 'Impôt et Douane' LIMIT 1), NOW()),
 
('Taxe intérieure sur les produits pétroliers (TIPP)', 'Déclaration TIPP', '⛽', 
 (SELECT id FROM categories WHERE titre = 'Impôt et Douane' LIMIT 1), NOW()),
 
('Contribution de solidarité sur les billets d''avion (CSB)', 'Taxe sur billets d''avion', '✈️', 
 (SELECT id FROM categories WHERE titre = 'Impôt et Douane' LIMIT 1), NOW()),
 
('Taxe sur l''accès au réseau des télécommunications ouvert au public (TARTOP)', 'Déclaration TARTOP', '📱', 
 (SELECT id FROM categories WHERE titre = 'Impôt et Douane' LIMIT 1), NOW()),
 
('Taxe sur les contrats d''assurance (TCA)', 'Déclaration TCA', '🛡️', 
 (SELECT id FROM categories WHERE titre = 'Impôt et Douane' LIMIT 1), NOW()),
 
('Taxe sur les exportateurs d''or non régis par le code minier', 'Taxe exportation or', '🥇', 
 (SELECT id FROM categories WHERE titre = 'Impôt et Douane' LIMIT 1), NOW()),
 
('Taxe sur les armes à feu', 'Taxe sur détention d''armes', '🔫', 
 (SELECT id FROM categories WHERE titre = 'Impôt et Douane' LIMIT 1), NOW());

-- ============================================
-- STATISTIQUES
-- ============================================
-- Total inséré :
-- - 7 catégories
-- - 79 sous-catégories
--   • Identité et citoyenneté : 12
--   • Création d'entreprise : 8
--   • Documents auto : 5
--   • Service fonciers : 9
--   • Eau et électricité : 6
--   • Justice : 9
--   • Impôt et Douane : 30
-- ============================================

-- ============================================
-- VÉRIFICATION
-- ============================================
-- SELECT COUNT(*) FROM categories;  -- Devrait afficher: 7
-- SELECT COUNT(*) FROM sous_categories;  -- Devrait afficher: 79
-- 
-- -- Compter les sous-catégories par catégorie
-- SELECT c.titre, COUNT(sc.id) as nombre_sous_categories 
-- FROM categories c 
-- LEFT JOIN sous_categories sc ON c.id = sc.categorie_id 
-- GROUP BY c.id, c.titre
-- ORDER BY c.id;
-- ============================================

