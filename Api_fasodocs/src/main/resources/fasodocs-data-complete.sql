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
 
('Carte nationale d''identité biométrique', 'Obtenir ou renouveler la carte biométrique', '🪪', 
 (SELECT id FROM categories WHERE titre = 'Identité et citoyenneté' LIMIT 1), NOW()),

 ('Fiche individuelle', 'Obtenir une fiche individuelle', '📄', 
 (SELECT id FROM categories WHERE titre = 'Identité et citoyenneté' LIMIT 1), NOW()),
 
('Passeport malien', 'Demande de passeport biométrique malien', '🛂', 
 (SELECT id FROM categories WHERE titre = 'Identité et citoyenneté' LIMIT 1), NOW()),
 
('Nationalité par voie de naturalisation', 'Acquisition de la nationalité malienne', '🇲🇱', 
 (SELECT id FROM categories WHERE titre = 'Identité et citoyenneté' LIMIT 1), NOW()),

 ('Nationalité par mariage', 'Acquisition de la nationalité malienne', '🇲🇱', 
 (SELECT id FROM categories WHERE titre = 'Identité et citoyenneté' LIMIT 1), NOW()),
 
('Carte d''électeur', 'Inscription et obtention de carte d''électeur', '🗳️', 
 (SELECT id FROM categories WHERE titre = 'Identité et citoyenneté' LIMIT 1), NOW()),
 
('Certificat de résidence', 'Obtenir un certificat de résidence', '🏠', 
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
 
('Société à Responsabilité Limitée Unipersonnelle (SARL U)', 'Création d''une EURL', '👤', 
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
('Permis de conduire', 'Obtenir un permis de conduire', '🚗', 
 (SELECT id FROM categories WHERE titre = 'Documents auto' LIMIT 1), NOW()),

 ('Permis de conduire renouvellement', 'Renouveler un permis de conduire', '🚗', 
 (SELECT id FROM categories WHERE titre = 'Documents auto' LIMIT 1), NOW()),
 
('Carte grise (obtention)', 'Carte grise pour véhicule', '📄', 
 (SELECT id FROM categories WHERE titre = 'Documents auto' LIMIT 1), NOW()),

 ('Carte grise (mutation)', 'Carte grise pour véhicule', '📄', 
 (SELECT id FROM categories WHERE titre = 'Documents auto' LIMIT 1), NOW()),

 ('Carte grise (renouvellement)', 'Carte grise pour véhicule', '📄', 
 (SELECT id FROM categories WHERE titre = 'Documents auto' LIMIT 1), NOW()),
 
('Visite technique', 'Contrôle technique de véhicule', '🔧', 
 (SELECT id FROM categories WHERE titre = 'Documents auto' LIMIT 1), NOW()),
 
('Vignette', 'Obtenir la vignette automobile', '🏷️', 
 (SELECT id FROM categories WHERE titre = 'Documents auto' LIMIT 1), NOW()),
 
('Changement de couleur de plaque', 'Changer la couleur de plaque d''immatriculation', '🎨', 
 (SELECT id FROM categories WHERE titre = 'Documents auto' LIMIT 1), NOW()),

 ('changer sa voiture en taxi', 'Changer sa voiture en Taxi', '🎨', 
 (SELECT id FROM categories WHERE titre = 'Documents auto' LIMIT 1), NOW());

-- ============================================
-- 2.4. SERVICE FONCIERS (9 sous-catégories)
-- ============================================

INSERT INTO sous_categories (titre, description, icone_url, categorie_id, date_creation) VALUES
-- Catégorie 4: Service fonciers
('Permis de construire à usage personnelle', 'Obtenir un permis de construire', '🏗️', 
 (SELECT id FROM categories WHERE titre = 'Service fonciers' LIMIT 1), NOW()),

 ('Permis de construire à usage industriel', 'Obtenir un permis de construire', '🏗️', 
 (SELECT id FROM categories WHERE titre = 'Service fonciers' LIMIT 1), NOW()),
 
('Demande de bail', 'Établir un contrat de bail', '📝', 
 (SELECT id FROM categories WHERE titre = 'Service fonciers' LIMIT 1), NOW()),

 ('Logement sociaux', 'Béneficier d''un logement social', '🏠', 
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
-- 3. CENTRES DE TRAITEMENT
-- ============================================

-- ============================================
-- 3.1. CENTRES PRINCIPAUX
-- ============================================

INSERT INTO centres (nom, adresse, horaires, telephone, email, date_creation) VALUES
('Mairie', 'Mairie de votre commune', 'Lundi-Vendredi: 8h-16h, Samedi: 8h-12h', 'Contactez votre mairie', 'mairie@commune.ml', NOW()),
('Tribunal', 'Tribunal de votre juridiction', 'Lundi-Vendredi: 8h-16h', 'Contactez votre tribunal', 'tribunal@justice.ml', NOW());

-- ============================================
-- 4. PROCÉDURES ET DONNÉES ASSOCIÉES
-- ============================================

-- ============================================
-- 3.1. PROCÉDURE: EXTRAT D'ACTE DE MARIAGE
-- ============================================

-- Insertion de la procédure
INSERT INTO procedures (nom, titre, delai, description, categorie_id, sous_categorie_id, date_creation) VALUES
('Extrait d''acte de mariage', 'Obtenir un extrait d''acte de mariage', '1 semaine après le mariage', 
 'Procédure pour obtenir un extrait d''acte de mariage auprès de la mairie. Le délai légal de célébration est de 15 jours francs après la déclaration, sauf dérogation et s''il n''y a pas d''opposition.',
 (SELECT id FROM categories WHERE titre = 'Identité et citoyenneté' LIMIT 1),
 (SELECT id FROM sous_categories WHERE titre = 'Extrait d''acte de mariage' LIMIT 1),
 NOW());

-- ============================================
-- 3.2. ÉTAPES DE LA PROCÉDURE
-- ============================================

INSERT INTO etapes (nom, description, niveau, procedure_id) VALUES
-- Étape 1: Déclaration
('Déclaration', 'Le couple se présente à la mairie. Un maire adjoint chargé de l''état civil enregistre la déclaration.', 1,
 (SELECT id FROM procedures WHERE nom = 'Extrait d''acte de mariage' LIMIT 1)),

-- Étape 2: Délai légal
('Délai légal de célébration', 'Le délai légal pour célébrer le mariage après la déclaration est de quinze (15) jours francs, sauf dérogation et s''il n''y a pas d''opposition.', 2,
 (SELECT id FROM procedures WHERE nom = 'Extrait d''acte de mariage' LIMIT 1)),

-- Étape 3: Enquête
('Enquête', 'Le responsable chargé de l''état civil mène une enquête pour vérifier: que l''homme n''est pas déjà marié ou ne vit pas en régime monogamique avec la première épouse; que la femme n''est pas mariée ou précédemment fiancée; que la femme n''est pas mineure.', 3,
 (SELECT id FROM procedures WHERE nom = 'Extrait d''acte de mariage' LIMIT 1)),

-- Étape 4: Confirmation et célébration
('Confirmation et célébration', 'Après l''enquête, l''officier de l''état civil confirme la célébration du mariage aux époux. Le mariage est célébré par l''officier de l''état civil (maire ou maire adjoint) en présence des époux et des témoins.', 4,
 (SELECT id FROM procedures WHERE nom = 'Extrait d''acte de mariage' LIMIT 1));

-- ============================================
-- 3.3. COÛTS DE LA PROCÉDURE
-- ============================================

-- Insertion des coûts
INSERT INTO couts (nom, prix, description) VALUES
('Extrait d''acte de mariage', 0, 'Gratuit pour l''extrait de l''acte de mariage'),
('Copie d''acte de mariage', 100, '100 FCFA pour la copie de l''acte de mariage'),
('Livret de famille', 1000, '1000 FCFA pour le livret de famille');

-- Association du coût principal à la procédure
UPDATE procedures 
SET cout_id = (SELECT id FROM couts WHERE nom = 'Extrait d''acte de mariage' LIMIT 1)
WHERE nom = 'Extrait d''acte de mariage';

-- Association du centre (mairie) à la procédure
UPDATE procedures 
SET centre_id = (SELECT id FROM centres WHERE nom = 'Mairie' LIMIT 1)
WHERE nom = 'Extrait d''acte de mariage';

-- ============================================
-- 3.4. ARTICLES DE LOI
-- ============================================

INSERT INTO lois_articles (description, consulter_article, procedure_id) VALUES
('Articles 90 à 101 de la loi n°06-024 du 28 juin 2006 régissant l''Etat Civil', 
 'Articles 90 à 101 de la loi n°06-024 du 28 juin 2006 régissant l''Etat Civil. Ces articles définissent les procédures et conditions pour l''établissement des actes de mariage et la délivrance des extraits.',
 (SELECT id FROM procedures WHERE nom = 'Extrait d''acte de mariage' LIMIT 1)),

('Article 14 et 15 de la loi n°95-034 portant Code des Collectivités Territoriales modifié par la loi 98-010 du 15/06/98 et modifié par la loi 98-066 du 30/12/98',
 'Article 14 et 15 de la loi n°95-034 portant Code des Collectivités Territoriales. Ces articles définissent les compétences des collectivités territoriales en matière d''état civil et de délivrance de documents officiels.',
 (SELECT id FROM procedures WHERE nom = 'Extrait d''acte de mariage' LIMIT 1));

-- ============================================
-- 3.5. PROCÉDURE: DEMANDE DE DIVORCE
-- ============================================

-- Insertion de la procédure
INSERT INTO procedures (nom, titre, delai, description, categorie_id, sous_categorie_id, date_creation) VALUES
('Demande de divorce', 'Procédure de demande de divorce', 'Variable selon la complexité de l''affaire', 
 'La dissolution judiciaire du mariage au Mali peut être obtenue par le divorce, qui peut être prononcé par consentement mutuel, par rupture de vie commune, ou pour faute. La matière est régie par les articles 325 et suivants du Code des personnes et de la famille. Le tribunal compétent est celui du dernier domicile commun des époux ou celui du défendeur. Une tentative de conciliation est obligatoire dans tous les cas de divorce, sauf pour le divorce par consentement mutuel. La procédure est introduite sous forme ordinaire et l''affaire est débattue en chambre du conseil, le ministère public entendu. Le jugement est rendu en audience publique, de même que la décision d''appel. L''appel en cassation en matière de divorce est suspensif.',
 (SELECT id FROM categories WHERE titre = 'Identité et citoyenneté' LIMIT 1),
 (SELECT id FROM sous_categories WHERE titre = 'Demande de divorce' LIMIT 1),
 NOW());

-- ============================================
-- 3.6. ÉTAPES DE LA PROCÉDURE DE DIVORCE
-- ============================================

INSERT INTO etapes (nom, description, niveau, procedure_id) VALUES
-- Étape 1: Dépôt de la requête
('Dépôt de la requête', 'L''époux demandeur présente une requête écrite au juge ou à défaut au chef de la circonscription administrative qui la transmet à la juridiction compétente.', 1,
 (SELECT id FROM procedures WHERE nom = 'Demande de divorce' LIMIT 1)),

-- Étape 2: Tentative de conciliation
('Tentative de conciliation', 'Le juge indique le jour, l''heure et le lieu auxquels il sera procédé à la tentative de conciliation. Cette étape est obligatoire sauf pour le divorce par consentement mutuel.', 2,
 (SELECT id FROM procedures WHERE nom = 'Demande de divorce' LIMIT 1)),

-- Étape 3: Instruction de l'affaire
('Instruction de l''affaire', 'L''affaire est débattue en chambre du conseil, le ministère public entendu. Les parties présentent leurs arguments et preuves.', 3,
 (SELECT id FROM procedures WHERE nom = 'Demande de divorce' LIMIT 1)),

-- Étape 4: Jugement
('Jugement', 'Le jugement est rendu en audience publique par le tribunal compétent.', 4,
 (SELECT id FROM procedures WHERE nom = 'Demande de divorce' LIMIT 1)),

-- Étape 5: Appel possible
('Appel possible', 'La décision d''appel est également rendue en audience publique. L''appel en cassation en matière de divorce est suspensif.', 5,
 (SELECT id FROM procedures WHERE nom = 'Demande de divorce' LIMIT 1));

-- ============================================
-- 3.7. DOCUMENTS REQUIS POUR LE DIVORCE
-- ============================================

INSERT INTO documents_requis (nom, description, est_obligatoire, procedure_id) VALUES
('Copie de l''acte de mariage certifiée', 'Copie certifiée de l''acte de mariage', true, 
 (SELECT id FROM procedures WHERE nom = 'Demande de divorce' LIMIT 1)),

('Extraits d''actes de naissance des enfants', 'Actes de naissance des enfants mineurs s''il y a lieu', true,
 (SELECT id FROM procedures WHERE nom = 'Demande de divorce' LIMIT 1)),

('Contrat de mariage', 'Contrat de mariage s''il existe', true, 
 (SELECT id FROM procedures WHERE nom = 'Demande de divorce' LIMIT 1)),

('Inventaire des biens', 'Inventaire de tous les biens meubles et immeubles', true, 
 (SELECT id FROM procedures WHERE nom = 'Demande de divorce' LIMIT 1)),

('Convention écrite', 'Convention écrite régissant la garde, l''éducation et l''entretien des enfants, et le partage des biens communs le cas échéant (pour divorce par consentement mutuel)', true, 
 (SELECT id FROM procedures WHERE nom = 'Demande de divorce' LIMIT 1)),

('Demande écrite', 'Requête écrite adressée au tribunal civil du domicile commun ou de l''un des époux', true, 
 (SELECT id FROM procedures WHERE nom = 'Demande de divorce' LIMIT 1));

-- ============================================
-- 3.8. COÛTS DE LA PROCÉDURE DE DIVORCE
-- ============================================

-- Insertion des coûts
INSERT INTO couts (nom, prix, description) VALUES
('Consignation au greffe', 20000, 'Une consignation de 20 000 FCFA payée au greffe du tribunal pour l''intitulé de la pièce délivrée : un jugement de divorce'),
('Frais de procédure', 0, 'Frais variables selon le type de divorce et la complexité de l''affaire');

-- Association du coût principal à la procédure
UPDATE procedures 
SET cout_id = (SELECT id FROM couts WHERE nom = 'Consignation au greffe' LIMIT 1)
WHERE nom = 'Demande de divorce';

-- Association du centre (tribunal) à la procédure
UPDATE procedures 
SET centre_id = (SELECT id FROM centres WHERE nom = 'Tribunal' LIMIT 1)
WHERE nom = 'Demande de divorce';

-- ============================================
-- 3.9. ARTICLES DE LOI POUR LE DIVORCE
-- ============================================

INSERT INTO lois_articles (description, consulter_article, procedure_id) VALUES
('Articles 325 et suivants du Code des personnes et de la famille', 
 'Articles 325 et suivants du Code des personnes et de la famille. Ces articles régissent la dissolution judiciaire du mariage par le divorce, définissant les conditions, procédures et effets du divorce au Mali.',
 (SELECT id FROM procedures WHERE nom = 'Demande de divorce' LIMIT 1));

-- ============================================
-- 3.10. PROCÉDURE: DEMANDE D'ACTE DE DÉCÈS
-- ============================================

-- Insertion de la procédure
INSERT INTO procedures (nom, titre, delai, description, categorie_id, sous_categorie_id, date_creation) VALUES
('Demande d''acte de décès', 'Obtenir un acte de décès', '24 heures', 
 'Procédure pour obtenir un acte de décès auprès de la mairie. Le déclarant se rend au bureau d''accueil du centre de santé de référence de sa commune de résidence. Le bureau d''accueil du centre de santé de référence établit le volet n°2 de la déclaration de décès. En principe, le centre de santé de référence transmet le volet n°2 à la mairie de résidence du déclarant par voie administrative, mais en pratique, le centre de santé de référence remet ledit document au déclarant. Le déclarant se rend au secrétariat général de la mairie avec le volet n°2 de la déclaration de décès. Le secrétaire procède à l''enregistrement du document, établit l''acte de décès qui est soumis à la signature du maire et remis à l''usager.',
 (SELECT id FROM categories WHERE titre = 'Identité et citoyenneté' LIMIT 1),
 (SELECT id FROM sous_categories WHERE titre = 'Acte de décès' LIMIT 1),
 NOW());

-- ============================================
-- 3.11. ÉTAPES DE LA PROCÉDURE D'ACTE DE DÉCÈS
-- ============================================

INSERT INTO etapes (nom, description, niveau, procedure_id) VALUES
-- Étape 1: Déclaration au centre de santé
('Déclaration au centre de santé', 'Le déclarant se rend au bureau d''accueil du centre de santé de référence de sa commune de résidence.', 1,
 (SELECT id FROM procedures WHERE nom = 'Demande d''acte de décès' LIMIT 1)),

-- Étape 2: Établissement du volet n°2
('Établissement du volet n°2', 'Le bureau d''accueil du centre de santé de référence établit le volet n°2 de la déclaration de décès.', 2,
 (SELECT id FROM procedures WHERE nom = 'Demande d''acte de décès' LIMIT 1)),

-- Étape 3: Transmission du document
('Transmission du document', 'En principe, le centre de santé de référence transmet le volet n°2 à la mairie de résidence du déclarant par voie administrative, mais en pratique, le centre de santé de référence remet ledit document au déclarant.', 3,
 (SELECT id FROM procedures WHERE nom = 'Demande d''acte de décès' LIMIT 1)),

-- Étape 4: Dépôt à la mairie
('Dépôt à la mairie', 'Le déclarant se rend au secrétariat général de la mairie avec le volet n°2 de la déclaration de décès.', 4,
 (SELECT id FROM procedures WHERE nom = 'Demande d''acte de décès' LIMIT 1)),

-- Étape 5: Établissement et signature
('Établissement et signature', 'Le secrétaire procède à l''enregistrement du document, établit l''acte de décès qui est soumis à la signature du maire et remis à l''usager.', 5,
 (SELECT id FROM procedures WHERE nom = 'Demande d''acte de décès' LIMIT 1));

-- ============================================
-- 3.12. DOCUMENTS REQUIS POUR L'ACTE DE DÉCÈS
-- ============================================

INSERT INTO documents_requis (nom, description, est_obligatoire, procedure_id) VALUES
('Numéro d''enregistrement', 'Numéro d''enregistrement remis par le bureau du permis d''inhumer', true, 
 (SELECT id FROM procedures WHERE nom = 'Demande d''acte de décès' LIMIT 1)),

('Déclaration de décès (volet n°2)', 'Déclaration de décès (volet n°2) établie par le centre de santé de référence', true, 
 (SELECT id FROM procedures WHERE nom = 'Demande d''acte de décès' LIMIT 1));

-- ============================================
-- 3.13. COÛTS DE LA PROCÉDURE D'ACTE DE DÉCÈS
-- ============================================

-- Insertion des coûts
INSERT INTO couts (nom, prix, description) VALUES
('Acte de décès', 0, 'Gratuit pour l''acte de décès'),
('Copie d''acte de décès', 100, '100 FCFA pour la copie de l''acte de décès');

-- Association du coût principal à la procédure
UPDATE procedures 
SET cout_id = (SELECT id FROM couts WHERE nom = 'Acte de décès' LIMIT 1)
WHERE nom = 'Demande d''acte de décès';

-- Association du centre (mairie) à la procédure
UPDATE procedures 
SET centre_id = (SELECT id FROM centres WHERE nom = 'Mairie' LIMIT 1)
WHERE nom = 'Demande d''acte de décès';

-- ============================================
-- 3.14. ARTICLES DE LOI POUR L'ACTE DE DÉCÈS
-- ============================================

INSERT INTO lois_articles (description, consulter_article, procedure_id) VALUES
('Article 65 de la loi 06-24 du 28 juin 2006 portant droit de timbre', 
 'Article 65 de la loi 06-24 du 28 juin 2006 portant droit de timbre. Cet article définit les conditions et procédures pour l''établissement des actes de décès.',
 (SELECT id FROM procedures WHERE nom = 'Demande d''acte de décès' LIMIT 1)),

('Articles 102 à 106 de la loi n°06-024 du 28 juin 2006 régissant l''Etat Civil',
 'Articles 102 à 106 de la loi n°06-024 du 28 juin 2006 régissant l''Etat Civil. Ces articles définissent les procédures et conditions pour l''établissement des actes de décès et la délivrance des extraits.',
 (SELECT id FROM procedures WHERE nom = 'Demande d''acte de décès' LIMIT 1));

-- ============================================
-- 3.15. PROCÉDURE: DEMANDE DE CARTE D'ÉLECTEUR
-- ============================================

-- Insertion de la procédure
INSERT INTO procedures (nom, titre, delai, description, categorie_id, sous_categorie_id, date_creation) VALUES
('Demande de carte d''électeur', 'Obtenir une carte d''électeur NINA', 'Variable (remise au plus tard la veille du scrutin)', 
 'L''émission de la carte d''électeur est régie par les articles 59 et 61 de la loi électorale. Une carte NINA, qui sert de carte d''électeur, doit être délivrée à chaque électeur au plus tard la veille du scrutin. La carte NINA est personnelle et incessible. Les cartes NINA sont délivrées dans des délais et selon des procédures déterminés par le Ministère chargé de l''Administration Territoriale. Historiquement, les cartes d''électeur étaient délivrées par les commissions administratives communales, les ambassades et les consulats. Pour les élections législatives et présidentielles de 2013, les cartes ont été délivrées par les services de la Délégation Générale aux Élections et par des équipes dédiées, sur décision du ministre chargé de l''Administration Territoriale. Tout électeur souhaitant obtenir une carte d''électeur NINA doit s''adresser à la Délégation générale aux élections.',
 (SELECT id FROM categories WHERE titre = 'Identité et citoyenneté' LIMIT 1),
 (SELECT id FROM sous_categories WHERE titre = 'Carte d''électeur' LIMIT 1),
 NOW());

-- ============================================
-- 3.16. ÉTAPES DE LA PROCÉDURE CARTE D'ÉLECTEUR
-- ============================================

INSERT INTO etapes (nom, description, niveau, procedure_id) VALUES
-- Étape 1: Contact de la DGE
('Contact de la Délégation Générale aux Élections', 'L''électeur s''adresse à la Délégation générale aux élections pour faire sa demande de carte NINA.', 1,
 (SELECT id FROM procedures WHERE nom = 'Demande de carte d''électeur' LIMIT 1)),

-- Étape 2: Dépôt de la demande
('Dépôt de la demande', 'L''électeur dépose sa demande auprès des services de la Délégation Générale aux Élections.', 2,
 (SELECT id FROM procedures WHERE nom = 'Demande de carte d''électeur' LIMIT 1)),

-- Étape 3: Traitement de la demande
('Traitement de la demande', 'Les services de la Délégation Générale aux Élections traitent la demande selon les procédures déterminées par le Ministère chargé de l''Administration Territoriale.', 3,
 (SELECT id FROM procedures WHERE nom = 'Demande de carte d''électeur' LIMIT 1)),

-- Étape 4: Remise de la carte
('Remise de la carte NINA', 'La carte NINA est remise à l''électeur au plus tard la veille du scrutin.', 4,
 (SELECT id FROM procedures WHERE nom = 'Demande de carte d''électeur' LIMIT 1));

-- ============================================
-- 3.17. COÛTS DE LA PROCÉDURE CARTE D'ÉLECTEUR
-- ============================================

-- Insertion des coûts
INSERT INTO couts (nom, prix, description) VALUES
('Carte d''électeur NINA', 0, 'Gratuit pour la carte d''électeur NINA');

-- Association du coût principal à la procédure
UPDATE procedures 
SET cout_id = (SELECT id FROM couts WHERE nom = 'Carte d''électeur NINA' LIMIT 1)
WHERE nom = 'Demande de carte d''électeur';

-- ============================================
-- 3.18. ARTICLES DE LOI POUR LA CARTE D'ÉLECTEUR
-- ============================================

INSERT INTO lois_articles (description, consulter_article, procedure_id) VALUES
('Articles 59 et 61 de la loi électorale', 
 'Articles 59 et 61 de la loi électorale. Ces articles régissent l''émission de la carte d''électeur et définissent les conditions et procédures pour l''obtention de la carte NINA qui sert de carte d''électeur.',
 (SELECT id FROM procedures WHERE nom = 'Demande de carte d''électeur' LIMIT 1));

-- ============================================
-- 3.19. CENTRE POUR LA CARTE D'ÉLECTEUR
-- ============================================

-- Ajout du centre DGE
INSERT INTO centres (nom, adresse, horaires, telephone, email, date_creation) VALUES
('Délégation Générale aux Elections', 'Ex. Base Aérienne Hamdallaye ACI 2000 - BP E 5386 Bamako Mali', 'Lundi-Vendredi: 8h-16h', '+223 20 23 99 80', 'contact@dge2013.ml', NOW());

-- Association du centre à la procédure
UPDATE procedures 
SET centre_id = (SELECT id FROM centres WHERE nom = 'Délégation Générale aux Elections' LIMIT 1)
WHERE nom = 'Demande de carte d''électeur';

-- ============================================
-- 3.20. PROCÉDURE: CERTIFICAT DE NATIONALITÉ
-- ============================================

-- Insertion de la procédure
INSERT INTO procedures (nom, titre, delai, description, categorie_id, sous_categorie_id, date_creation) VALUES
('Certificat de nationalité', 'Obtenir un certificat de nationalité malienne', '24 heures', 
 'Procédure pour obtenir un certificat de nationalité malienne auprès du tribunal civil. L''usager se rend au bureau du casier judiciaire et du certificat de nationalité d''un tribunal civil. Un agent enregistre les informations sur un formulaire et transmet au greffier en chef. Le greffier en chef vérifie, enregistre et soumet le certificat à la signature du Président du Tribunal ou d''un Juge de Paix à Compétence étendue. Le certificat est ensuite retourné au bureau du certificat de nationalité.',
 (SELECT id FROM categories WHERE titre = 'Identité et citoyenneté' LIMIT 1),
 (SELECT id FROM sous_categories WHERE titre = 'Certificat de nationalité' LIMIT 1),
 NOW());

-- ============================================
-- 3.21. ÉTAPES DE LA PROCÉDURE CERTIFICAT DE NATIONALITÉ
-- ============================================

INSERT INTO etapes (nom, description, niveau, procedure_id) VALUES
-- Étape 1: Dépôt de la demande
('Dépôt de la demande', 'L''usager se rend au bureau du casier judiciaire et du certificat de nationalité d''un tribunal civil.', 1,
 (SELECT id FROM procedures WHERE nom = 'Certificat de nationalité' LIMIT 1)),

-- Étape 2: Enregistrement des informations
('Enregistrement des informations', 'Un agent enregistre les informations sur un formulaire et transmet au greffier en chef.', 2,
 (SELECT id FROM procedures WHERE nom = 'Certificat de nationalité' LIMIT 1)),

-- Étape 3: Vérification et signature
('Vérification et signature', 'Le greffier en chef vérifie, enregistre et soumet le certificat à la signature du Président du Tribunal ou d''un Juge de Paix à Compétence étendue.', 3,
 (SELECT id FROM procedures WHERE nom = 'Certificat de nationalité' LIMIT 1)),

-- Étape 4: Remise du certificat
('Remise du certificat', 'Le certificat est retourné au bureau du certificat de nationalité et remis à l''usager.', 4,
 (SELECT id FROM procedures WHERE nom = 'Certificat de nationalité' LIMIT 1));

-- ============================================
-- 3.22. DOCUMENTS REQUIS POUR LE CERTIFICAT DE NATIONALITÉ
-- ============================================

INSERT INTO documents_requis (nom, description, est_obligatoire, procedure_id) VALUES
('Copie de l''extrait de l''acte de naissance', 'Copie de l''extrait de l''acte de naissance', true, 
 (SELECT id FROM procedures WHERE nom = 'Certificat de nationalité' LIMIT 1));

-- ============================================
-- 3.23. COÛTS DE LA PROCÉDURE CERTIFICAT DE NATIONALITÉ
-- ============================================

-- Insertion des coûts
INSERT INTO couts (nom, prix, description) VALUES
('Certificat de nationalité', 750, '750 FCFA pour le certificat de nationalité');

-- Association du coût principal à la procédure
UPDATE procedures 
SET cout_id = (SELECT id FROM couts WHERE nom = 'Certificat de nationalité' LIMIT 1)
WHERE nom = 'Certificat de nationalité';

-- Association du centre (tribunal) à la procédure
UPDATE procedures 
SET centre_id = (SELECT id FROM centres WHERE nom = 'Tribunal' LIMIT 1)
WHERE nom = 'Certificat de nationalité';

-- ============================================
-- 3.24. ARTICLES DE LOI POUR LE CERTIFICAT DE NATIONALITÉ
-- ============================================

INSERT INTO lois_articles (description, consulter_article, procedure_id) VALUES
('Loi n°62-18/AN-RM du 03/02/62 et Articles 53 et 54 portant certificat de nationalité', 
 'Loi n°62-18/AN-RM du 03/02/62 et Articles 53 et 54 portant certificat de nationalité. Ces articles définissent les conditions et procédures pour l''établissement et la délivrance du certificat de nationalité malienne.',
 (SELECT id FROM procedures WHERE nom = 'Certificat de nationalité' LIMIT 1));

-- ============================================
-- 3.25. PROCÉDURE: INSCRIPTION SUR LA LISTE ÉLECTORALE
-- ============================================

-- Insertion de la procédure
INSERT INTO procedures (nom, titre, delai, description, categorie_id, sous_categorie_id, date_creation) VALUES
('Inscription sur la liste électorale', 'S''inscrire sur les listes électorales', 'Automatique selon les conditions légales', 
 'Selon la loi n° 017 du 21 mai 2013 modifiant la loi n° 06-044 du 4 septembre 2006 et la loi n° 2011-085 du 30 décembre 2011 (loi électorale), tout citoyen malien âgé d''au moins 18 ans, jouissant de ses droits civils et politiques et non frappé d''interdiction légale ou de condamnation judiciaire, est électeur. Les listes électorales sont permanentes et établies à partir des données biométriques d''état civil comprenant la photo et l''empreinte digitale. Chaque électeur se voit attribuer un numéro d''identification nationale (NINA). L''article 33 de la loi dispose que tout électeur résidant dans la commune, l''Ambassade ou le Consulat et dont les données biométriques (photo et empreinte digitale) sont dans la base de données, doit être automatiquement inscrit sur la liste électorale. Dans les mêmes conditions, les personnes qui atteindront l''âge de 18 ans dans l''année suivant la révision sont également inscrites. En cas de changement de résidence, un électeur peut s''inscrire sur la liste électorale sans être tenu de produire un certificat de radiation de la liste électorale de son ancienne résidence. Toute demande d''inscription, de rectification ou toute autre réclamation doit être adressée à la Commission Administrative qui se réunit sur convocation du représentant de l''État dans le District de Bamako ou dans le Cercle.',
 (SELECT id FROM categories WHERE titre = 'Identité et citoyenneté' LIMIT 1),
 (SELECT id FROM sous_categories WHERE titre = 'Inscription liste électorale' LIMIT 1),
 NOW());

-- ============================================
-- 3.26. ÉTAPES DE LA PROCÉDURE INSCRIPTION ÉLECTORALE
-- ============================================

INSERT INTO etapes (nom, description, niveau, procedure_id) VALUES
-- Étape 1: Vérification des conditions
('Vérification des conditions', 'Vérifier que le citoyen est âgé d''au moins 18 ans, jouit de ses droits civils et politiques et n''est pas frappé d''interdiction légale ou de condamnation judiciaire.', 1,
 (SELECT id FROM procedures WHERE nom = 'Inscription sur la liste électorale' LIMIT 1)),

-- Étape 2: Inscription automatique
('Inscription automatique', 'L''électeur résidant dans la commune, l''Ambassade ou le Consulat et dont les données biométriques (photo et empreinte digitale) sont dans la base de données est automatiquement inscrit sur la liste électorale.', 2,
 (SELECT id FROM procedures WHERE nom = 'Inscription sur la liste électorale' LIMIT 1)),

-- Étape 3: Attribution du NINA
('Attribution du NINA', 'Chaque électeur se voit attribuer un numéro d''identification nationale (NINA) à partir des données biométriques d''état civil.', 3,
 (SELECT id FROM procedures WHERE nom = 'Inscription sur la liste électorale' LIMIT 1)),

-- Étape 4: Inscription des futurs électeurs
('Inscription des futurs électeurs', 'Les personnes qui atteindront l''âge de 18 ans dans l''année suivant la révision sont également inscrites sur la liste électorale.', 4,
 (SELECT id FROM procedures WHERE nom = 'Inscription sur la liste électorale' LIMIT 1)),

-- Étape 5: Changement de résidence
('Changement de résidence', 'En cas de changement de résidence, l''électeur peut s''inscrire sur la liste électorale sans être tenu de produire un certificat de radiation de la liste électorale de son ancienne résidence.', 5,
 (SELECT id FROM procedures WHERE nom = 'Inscription sur la liste électorale' LIMIT 1)),

-- Étape 6: Demande de rectification
('Demande de rectification', 'Toute demande d''inscription, de rectification ou toute autre réclamation doit être adressée à la Commission Administrative qui se réunit sur convocation du représentant de l''État.', 6,
 (SELECT id FROM procedures WHERE nom = 'Inscription sur la liste électorale' LIMIT 1));

-- ============================================
-- 3.27. SERVICE EN LIGNE POUR L'INSCRIPTION ÉLECTORALE
-- ============================================

-- Ajout d'un centre pour le service en ligne
INSERT INTO centres (nom, adresse, horaires, telephone, email, date_creation) VALUES
('Service SMS - Liste électorale', 'Service SMS pour trouver son bureau de vote', '24h/24', 'Orange: 36777 ou 77060606, Malitel: 36666', 'sms@dge2013.ml', NOW());

-- ============================================
-- 3.28. COÛTS DE LA PROCÉDURE INSCRIPTION ÉLECTORALE
-- ============================================

-- Insertion des coûts
INSERT INTO couts (nom, prix, description) VALUES
('Inscription sur la liste électorale', 0, 'Gratuit pour l''inscription sur la liste électorale'),
('Service SMS - Bureau de vote', 0, 'Gratuit pour trouver son bureau de vote par SMS');

-- Association du coût principal à la procédure
UPDATE procedures 
SET cout_id = (SELECT id FROM couts WHERE nom = 'Inscription sur la liste électorale' LIMIT 1)
WHERE nom = 'Inscription sur la liste électorale';

-- Association du centre (DGE) à la procédure
UPDATE procedures 
SET centre_id = (SELECT id FROM centres WHERE nom = 'Délégation Générale aux Elections' LIMIT 1)
WHERE nom = 'Inscription sur la liste électorale';

-- ============================================
-- 3.29. ARTICLES DE LOI POUR L'INSCRIPTION ÉLECTORALE
-- ============================================

INSERT INTO lois_articles (description, consulter_article, procedure_id) VALUES
('Loi n° 017 du 21 mai 2013 modifiant la loi n° 06-044 du 4 septembre 2006 et la loi n° 2011-085 du 30 décembre 2011 (loi électorale)', 
 'Loi n° 017 du 21 mai 2013 modifiant la loi n° 06-044 du 4 septembre 2006 et la loi n° 2011-085 du 30 décembre 2011 (loi électorale). Cette loi définit les conditions d''éligibilité et les procédures d''inscription sur les listes électorales.',
 (SELECT id FROM procedures WHERE nom = 'Inscription sur la liste électorale' LIMIT 1)),

('Article 33 de la loi électorale',
 'Article 33 de la loi électorale. Cet article dispose que tout électeur résidant dans la commune, l''Ambassade ou le Consulat et dont les données biométriques sont dans la base de données, doit être automatiquement inscrit sur la liste électorale.',
 (SELECT id FROM procedures WHERE nom = 'Inscription sur la liste électorale' LIMIT 1));

-- ============================================
-- 3.30. PROCÉDURE: DEMANDE D'EXTRAT D'ACTE DE NAISSANCE
-- ============================================

-- Insertion de la procédure
INSERT INTO procedures (nom, titre, delai, description, categorie_id, sous_categorie_id, date_creation) VALUES
('Demande d''extrait d''acte de naissance', 'Obtenir un extrait d''acte de naissance', '24 heures', 
 'L''hôpital, la clinique, ou la maternité enregistre la naissance dans un registre d''état Civil et transmet un volet (II) dit de déclaration de naissance à la mairie ou au Centre d''état civil dont il ou elle dépend. L''hôpital, la clinique ou la maternité remet à l''usager le numéro du volet de la déclaration de naissance qui à son tour le présente à la section état civil où le volet de la déclaration de naissance a été transmis. L''agent de la section d''état civil procède à l''enregistrement des informations contenues dans le volet. Cette opération est appelée transcription. L''usager vérifie l''exactitude des informations enregistrées. L''extrait d''acte de naissance, dit volet III, est soumis à la signature du maire avant d''être remis à l''usager qui pourra en faire des copies. Les parents ont un délai maximum de 1 mois (30 jours francs) pour déclarer la naissance de leur enfant. Passé ce délai, il faudra recourir à un jugement supplétif. L''extrait d''acte de naissance est une formule manuscrite. C''est sa copie qui est saisie à la machine.',
 (SELECT id FROM categories WHERE titre = 'Identité et citoyenneté' LIMIT 1),
 (SELECT id FROM sous_categories WHERE titre = 'Extrait d''acte de naissance' LIMIT 1),
 NOW());

-- ============================================
-- 3.31. ÉTAPES DE LA PROCÉDURE EXTRAT D'ACTE DE NAISSANCE
-- ============================================

INSERT INTO etapes (nom, description, niveau, procedure_id) VALUES
-- Étape 1: Enregistrement à l'hôpital
('Enregistrement à l''hôpital', 'L''hôpital, la clinique, ou la maternité enregistre la naissance dans un registre d''état Civil et transmet un volet (II) dit de déclaration de naissance à la mairie ou au Centre d''état civil dont il ou elle dépend.', 1,
 (SELECT id FROM procedures WHERE nom = 'Demande d''extrait d''acte de naissance' LIMIT 1)),

-- Étape 2: Remise du numéro de volet
('Remise du numéro de volet', 'L''hôpital, la clinique ou la maternité remet à l''usager le numéro du volet de la déclaration de naissance qui à son tour le présente à la section état civil où le volet de la déclaration de naissance a été transmis.', 2,
 (SELECT id FROM procedures WHERE nom = 'Demande d''extrait d''acte de naissance' LIMIT 1)),

-- Étape 3: Transcription
('Transcription', 'L''agent de la section d''état civil procède à l''enregistrement des informations contenues dans le volet. Cette opération est appelée transcription.', 3,
 (SELECT id FROM procedures WHERE nom = 'Demande d''extrait d''acte de naissance' LIMIT 1)),

-- Étape 4: Vérification des informations
('Vérification des informations', 'L''usager vérifie l''exactitude des informations enregistrées.', 4,
 (SELECT id FROM procedures WHERE nom = 'Demande d''extrait d''acte de naissance' LIMIT 1)),

-- Étape 5: Signature et remise
('Signature et remise', 'L''extrait d''acte de naissance, dit volet III, est soumis à la signature du maire avant d''être remis à l''usager qui pourra en faire des copies.', 5,
 (SELECT id FROM procedures WHERE nom = 'Demande d''extrait d''acte de naissance' LIMIT 1));

-- ============================================
-- 3.32. DOCUMENTS REQUIS POUR L'EXTRAT D'ACTE DE NAISSANCE
-- ============================================

INSERT INTO documents_requis (nom, description, est_obligatoire, procedure_id) VALUES
('Volet de déclaration de naissance', 'Volet de déclaration de naissance de l''hôpital, la clinique ou la maternité pour obtenir l''extrait d''acte de naissance', true, 
 (SELECT id FROM procedures WHERE nom = 'Demande d''extrait d''acte de naissance' LIMIT 1)),

('Extrait d''acte de naissance (volet III)', 'L''extrait d''acte de naissance dit volet III pour obtenir une ou des copies de l''extrait d''acte de naissance', true, 
 (SELECT id FROM procedures WHERE nom = 'Demande d''extrait d''acte de naissance' LIMIT 1));

-- ============================================
-- 3.33. COÛTS DE LA PROCÉDURE EXTRAT D'ACTE DE NAISSANCE
-- ============================================

-- Insertion des coûts
INSERT INTO couts (nom, prix, description) VALUES
('Extrait d''acte de naissance (volet III)', 0, 'Gratuit pour l''extrait d''acte de naissance (volet III)'),
('Copie d''extrait d''acte de naissance', 100, '100 FCFA pour la copie sur l''ensemble du territoire. La copie peut se faire dans n''importe quel centre d''état civil');

-- Association du coût principal à la procédure
UPDATE procedures 
SET cout_id = (SELECT id FROM couts WHERE nom = 'Extrait d''acte de naissance (volet III)' LIMIT 1)
WHERE nom = 'Demande d''extrait d''acte de naissance';

-- Association du centre (mairie) à la procédure
UPDATE procedures 
SET centre_id = (SELECT id FROM centres WHERE nom = 'Mairie' LIMIT 1)
WHERE nom = 'Demande d''extrait d''acte de naissance';

-- ============================================
-- 3.34. ARTICLES DE LOI POUR L'EXTRAT D'ACTE DE NAISSANCE
-- ============================================

INSERT INTO lois_articles (description, consulter_article, procedure_id) VALUES
('Articles 74 à 79 de la loi n°06-024 du 28 juin 2006 régissant l''Etat Civil', 
 'Articles 74 à 79 de la loi n°06-024 du 28 juin 2006 régissant l''Etat Civil. Ces articles définissent les procédures et conditions pour l''établissement des actes de naissance et la délivrance des extraits.',
 (SELECT id FROM procedures WHERE nom = 'Demande d''extrait d''acte de naissance' LIMIT 1)),

('Articles 63, 64, 65 de la loi n°06-024 du 28 juin 2006',
 'Articles 63, 64, 65 de la loi n°06-024 du 28 juin 2006. Ces articles définissent les conditions et procédures pour l''obtention des copies d''actes de naissance.',
 (SELECT id FROM procedures WHERE nom = 'Demande d''extrait d''acte de naissance' LIMIT 1));

-- ============================================
-- 3.35. PROCÉDURE: DEMANDE DE CASIER JUDICIAIRE
-- ============================================

-- Insertion de la procédure
INSERT INTO procedures (nom, titre, delai, description, categorie_id, sous_categorie_id, date_creation) VALUES
('Demande de casier judiciaire', 'Obtenir un certificat de casier judiciaire', '24 heures', 
 'L''usager se présente au tribunal civil de son lieu de naissance, au bureau du casier judiciaire et du certificat de nationalité. Il doit préciser son domicile, sa profession et sa situation de famille. L''agent du bureau procède à l''enregistrement des informations sur une fiche qu''il transmet au greffier en chef. Le greffier en chef atteste, après recherche dans les fichiers dont il dispose, que le requérant n''a pas encore été l''objet d''une condamnation pénale, procède à son enregistrement et soumet la fiche à la signature du Procureur ou du Juge de Paix à Compétence Étendue. Au vu de l''attestation du greffier en chef, le Procureur ou le Juge de Paix à compétence étendue procède à la signature du casier judiciaire qui retourne au bureau du casier judiciaire où il est remis à l''usager. Dans le District de Bamako, le casier judiciaire n''est délivré que par le Tribunal de Paix à Compétence Étendue de la Commune III. Pour les Maliens nés à l''étranger, il est délivré par le Procureur de la Cour d''Appel.',
 (SELECT id FROM categories WHERE titre = 'Identité et citoyenneté' LIMIT 1),
 (SELECT id FROM sous_categories WHERE titre = 'Certificat de casier judiciaire' LIMIT 1),
 NOW());

-- ============================================
-- 3.36. ÉTAPES DE LA PROCÉDURE CASIER JUDICIAIRE
-- ============================================

INSERT INTO etapes (nom, description, niveau, procedure_id) VALUES
-- Étape 1: Présentation au tribunal
('Présentation au tribunal', 'L''usager se présente au tribunal civil de son lieu de naissance, au bureau du casier judiciaire et du certificat de nationalité. Il doit préciser son domicile, sa profession et sa situation de famille.', 1,
 (SELECT id FROM procedures WHERE nom = 'Demande de casier judiciaire' LIMIT 1)),

-- Étape 2: Enregistrement des informations
('Enregistrement des informations', 'L''agent du bureau procède à l''enregistrement des informations sur une fiche qu''il transmet au greffier en chef.', 2,
 (SELECT id FROM procedures WHERE nom = 'Demande de casier judiciaire' LIMIT 1)),

-- Étape 3: Attestation et recherche
('Attestation et recherche', 'Le greffier en chef atteste, après recherche dans les fichiers dont il dispose, que le requérant n''a pas encore été l''objet d''une condamnation pénale, procède à son enregistrement et soumet la fiche à la signature du Procureur ou du Juge de Paix à Compétence Étendue.', 3,
 (SELECT id FROM procedures WHERE nom = 'Demande de casier judiciaire' LIMIT 1)),

-- Étape 4: Signature et remise
('Signature et remise', 'Au vu de l''attestation du greffier en chef, le Procureur ou le Juge de Paix à compétence étendue procède à la signature du casier judiciaire qui retourne au bureau du casier judiciaire où il est remis à l''usager.', 4,
 (SELECT id FROM procedures WHERE nom = 'Demande de casier judiciaire' LIMIT 1));

-- ============================================
-- 3.37. DOCUMENTS REQUIS POUR LE CASIER JUDICIAIRE
-- ============================================

INSERT INTO documents_requis (nom, description, est_obligatoire, procedure_id) VALUES
('Copie de l''extrait d''acte de naissance', 'Copie de l''extrait d''acte de naissance', true, 
 (SELECT id FROM procedures WHERE nom = 'Demande de casier judiciaire' LIMIT 1));

-- ============================================
-- 3.38. COÛTS DE LA PROCÉDURE CASIER JUDICIAIRE
-- ============================================

-- Insertion des coûts
INSERT INTO couts (nom, prix, description) VALUES
('Certificat de casier judiciaire', 750, '750 FCFA pour le certificat de casier judiciaire');

-- Association du coût principal à la procédure
UPDATE procedures 
SET cout_id = (SELECT id FROM couts WHERE nom = 'Certificat de casier judiciaire' LIMIT 1)
WHERE nom = 'Demande de casier judiciaire';

-- Association du centre (tribunal) à la procédure
UPDATE procedures 
SET centre_id = (SELECT id FROM centres WHERE nom = 'Tribunal' LIMIT 1)
WHERE nom = 'Demande de casier judiciaire';

-- ============================================
-- 3.39. ARTICLES DE LOI POUR LE CASIER JUDICIAIRE
-- ============================================

INSERT INTO lois_articles (description, consulter_article, procedure_id) VALUES
('Décret n°95-255/P-RM du 30/06/95 article 66 fixant le prix des bulletins du casier judiciaire', 
 'Décret n°95-255/P-RM du 30/06/95 article 66 fixant le prix des bulletins du casier judiciaire. Ce décret définit le coût et les conditions d''établissement du certificat de casier judiciaire.',
 (SELECT id FROM procedures WHERE nom = 'Demande de casier judiciaire' LIMIT 1));

-- ============================================
-- 3.40. PROCÉDURE: NATIONALITÉ MALIENNE PAR MARIAGE
-- ============================================

-- Insertion de la procédure
INSERT INTO procedures (nom, titre, delai, description, categorie_id, sous_categorie_id, date_creation) VALUES
('Nationalité malienne par mariage', 'Acquérir la nationalité malienne par mariage', '1 an après l''enregistrement et sa notification au Ministère de la Justice', 
 'La demande de l''acquisition de la nationalité malienne par voie de mariage est ouverte à toute personne de nationalité étrangère ou apatride ayant contracté le mariage avec un Malien ou une Malienne sauf à elle de décliner la qualité de Malien avant le mariage. La demande doit être faite après la célébration du mariage au Mali. Toutefois, le gouvernement pendant un délai d''un an peut s''opposer par décret à l''acquisition de la nationalité malienne par le mariage. Ce délai court du jour de la transcription de l''acte de mariage sur le registre de l''Etat civil lorsque celui-ci a été célébré à l''étranger.',
 (SELECT id FROM categories WHERE titre = 'Identité et citoyenneté' LIMIT 1),
 (SELECT id FROM sous_categories WHERE titre = 'Nationalité (par voie de naturalisation, par mariage)' LIMIT 1),
 NOW());

-- ============================================
-- 3.41. ÉTAPES DE LA PROCÉDURE NATIONALITÉ PAR MARIAGE
-- ============================================

INSERT INTO etapes (nom, description, niveau, procedure_id) VALUES
-- Étape 1: Célébration du mariage
('Célébration du mariage', 'Le mariage doit être célébré au Mali ou transcrit sur le registre de l''état civil si célébré à l''étranger.', 1,
 (SELECT id FROM procedures WHERE nom = 'Nationalité malienne par mariage' LIMIT 1)),

-- Étape 2: Dépôt de la demande
('Dépôt de la demande', 'Dépôt d''une demande timbrée adressée au Ministère de la Justice avec tous les documents requis.', 2,
 (SELECT id FROM procedures WHERE nom = 'Nationalité malienne par mariage' LIMIT 1)),

-- Étape 3: Enregistrement et notification
('Enregistrement et notification', 'Enregistrement de la demande et notification au Ministère de la Justice.', 3,
 (SELECT id FROM procedures WHERE nom = 'Nationalité malienne par mariage' LIMIT 1)),

-- Étape 4: Délai d''opposition gouvernementale
('Délai d''opposition gouvernementale', 'Le gouvernement peut s''opposer par décret à l''acquisition de la nationalité malienne par le mariage pendant un délai d''un an.', 4,
 (SELECT id FROM procedures WHERE nom = 'Nationalité malienne par mariage' LIMIT 1)),

-- Étape 5: Acquisition de la nationalité
('Acquisition de la nationalité', 'Après le délai d''un an et en l''absence d''opposition gouvernementale, acquisition de la nationalité malienne.', 5,
 (SELECT id FROM procedures WHERE nom = 'Nationalité malienne par mariage' LIMIT 1));

-- ============================================
-- 3.42. DOCUMENTS REQUIS POUR LA NATIONALITÉ PAR MARIAGE
-- ============================================

INSERT INTO documents_requis (nom, description, est_obligatoire, procedure_id) VALUES
('Demande timbrée', 'Une demande timbrée adressée au Ministère de la Justice', true, 
 (SELECT id FROM procedures WHERE nom = 'Nationalité malienne par mariage' LIMIT 1)),

('Copie littérale de l''acte de mariage', 'Une copie littérale de l''acte de mariage', true, 
 (SELECT id FROM procedures WHERE nom = 'Nationalité malienne par mariage' LIMIT 1)),

('Certificat de nationalité du conjoint', 'Un certificat de nationalité du conjoint', true, 
 (SELECT id FROM procedures WHERE nom = 'Nationalité malienne par mariage' LIMIT 1)),

('Copie littérale de l''acte de naissance du conjoint', 'Une copie littérale de l''acte de naissance du conjoint', true, 
 (SELECT id FROM procedures WHERE nom = 'Nationalité malienne par mariage' LIMIT 1)),

('Attestation de non répudiation', 'Une attestation de non répudiation de la nationalité malienne', true, 
 (SELECT id FROM procedures WHERE nom = 'Nationalité malienne par mariage' LIMIT 1));

-- ============================================
-- 3.43. COÛTS DE LA PROCÉDURE NATIONALITÉ PAR MARIAGE
-- ============================================

-- Insertion des coûts
INSERT INTO couts (nom, prix, description) VALUES
('Frais de chancellerie - Nationalité par mariage', 0, 'Le décret peut fixer des frais de chancellerie perçus au profit du Trésor Public');

-- Association du coût principal à la procédure
UPDATE procedures 
SET cout_id = (SELECT id FROM couts WHERE nom = 'Frais de chancellerie - Nationalité par mariage' LIMIT 1)
WHERE nom = 'Nationalité malienne par mariage';

-- ============================================
-- 3.44. ARTICLES DE LOI POUR LA NATIONALITÉ PAR MARIAGE
-- ============================================

INSERT INTO lois_articles (description, consulter_article, procedure_id) VALUES
('Article 233 du Code des Personnes et de la Famille', 
 'Article 233 du Code des Personnes et de la Famille. Cet article définit les conditions et procédures pour l''acquisition de la nationalité malienne par mariage.',
 (SELECT id FROM procedures WHERE nom = 'Nationalité malienne par mariage' LIMIT 1));

-- ============================================
-- 3.45. PROCÉDURE: NATIONALITÉ MALIENNE PAR NATURALISATION
-- ============================================

-- Insertion de la procédure
INSERT INTO procedures (nom, titre, delai, description, categorie_id, sous_categorie_id, date_creation) VALUES
('Nationalité malienne par naturalisation', 'Acquérir la nationalité malienne par naturalisation', '1 an après la délivrance de l''attestation de dépôt auprès du Ministère de la justice', 
 'L''acquisition de la nationalité malienne par voie de naturalisation s''obtient par une décision de l''autorité publique notamment par un décret non motivé à la demande de l''intéressé. L''acquisition de la nationalité peut se faire par décret pour tout étranger ayant résidé au Mali depuis 10 ans au moins au moment de la présentation de sa demande. Toutefois ce délai est réduit à 5 ans pour le demandeur ayant rendu des services exceptionnels au Mali et aussi pour l''enfant né au Mali de parents étrangers. La résidence habituelle est l''établissement à demeure sur le territoire national qui est assimilé au séjour à l''étranger dans une fonction conférée par le gouvernement malien ou la présence à l''étranger dans une formation de l''armée malienne. Le décret de naturalisation peut toujours être rapporté lorsqu''il apparaît que la personne naturalisée ne remplit pas les conditions requises ou alors fait des déclarations mensongères ou présente des pièces fausses.',
 (SELECT id FROM categories WHERE titre = 'Identité et citoyenneté' LIMIT 1),
 (SELECT id FROM sous_categories WHERE titre = 'Nationalité (par voie de naturalisation, par mariage)' LIMIT 1),
 NOW());

-- ============================================
-- 3.46. ÉTAPES DE LA PROCÉDURE NATIONALITÉ PAR NATURALISATION
-- ============================================

INSERT INTO etapes (nom, description, niveau, procedure_id) VALUES
-- Étape 1: Vérification des conditions de résidence
('Vérification des conditions de résidence', 'Vérifier que l''étranger a résidé au Mali depuis 10 ans au moins (5 ans pour services exceptionnels ou enfant né au Mali de parents étrangers).', 1,
 (SELECT id FROM procedures WHERE nom = 'Nationalité malienne par naturalisation' LIMIT 1)),

-- Étape 2: Dépôt de la demande
('Dépôt de la demande', 'Dépôt d''une demande adressée au Ministère de la justice avec tous les documents requis.', 2,
 (SELECT id FROM procedures WHERE nom = 'Nationalité malienne par naturalisation' LIMIT 1)),

-- Étape 3: Acte solennel de soumission
('Acte solennel de soumission', 'Souscrire un acte solennel de soumission à la République par déclaration sous peine de nullité au Ministère de la justice.', 3,
 (SELECT id FROM procedures WHERE nom = 'Nationalité malienne par naturalisation' LIMIT 1)),

-- Étape 4: Enregistrement et attestation
('Enregistrement et attestation', 'Enregistrement de la demande et délivrance de l''attestation de dépôt auprès du Ministère de la justice.', 4,
 (SELECT id FROM procedures WHERE nom = 'Nationalité malienne par naturalisation' LIMIT 1)),

-- Étape 5: Délai d''opposition gouvernementale
('Délai d''opposition gouvernementale', 'Le gouvernement peut s''opposer par décret insusceptible de recours dans un délai d''un an après la validation judiciaire ou l''acceptation par le Ministère de la justice.', 5,
 (SELECT id FROM procedures WHERE nom = 'Nationalité malienne par naturalisation' LIMIT 1)),

-- Étape 6: Décret de naturalisation
('Décret de naturalisation', 'Un an après la délivrance de l''attestation de dépôt, décret de naturalisation si aucune opposition gouvernementale.', 6,
 (SELECT id FROM procedures WHERE nom = 'Nationalité malienne par naturalisation' LIMIT 1));

-- ============================================
-- 3.47. DOCUMENTS REQUIS POUR LA NATIONALITÉ PAR NATURALISATION
-- ============================================

INSERT INTO documents_requis (nom, description, est_obligatoire, procedure_id) VALUES
('Demande au Ministère de la justice', 'Une demande adressée au Ministère de la justice', true, 
 (SELECT id FROM procedures WHERE nom = 'Nationalité malienne par naturalisation' LIMIT 1)),

('Copie de l''acte de naissance', 'Copie de l''acte de naissance', true, 
 (SELECT id FROM procedures WHERE nom = 'Nationalité malienne par naturalisation' LIMIT 1)),

('Casier judiciaire bulletin n° 3', 'Casier judiciaire bulletin n° 3', true, 
 (SELECT id FROM procedures WHERE nom = 'Nationalité malienne par naturalisation' LIMIT 1)),

('Certificat de résidence', 'Certificat de résidence', true, 
 (SELECT id FROM procedures WHERE nom = 'Nationalité malienne par naturalisation' LIMIT 1)),

('Certificat de visite et de contre visite', 'Certificat de visite et de contre visite', true, 
 (SELECT id FROM procedures WHERE nom = 'Nationalité malienne par naturalisation' LIMIT 1)),

('Certificat de bonne vie et mœurs', 'Certificat de bonne vie et mœurs', true, 
 (SELECT id FROM procedures WHERE nom = 'Nationalité malienne par naturalisation' LIMIT 1)),

('Attestation d''imposition ou de non imposition', 'Attestation d''imposition ou de non imposition', true, 
 (SELECT id FROM procedures WHERE nom = 'Nationalité malienne par naturalisation' LIMIT 1)),

('Acte de mariage et certificat de nationalité du conjoint', 'Le cas échéant, l''acte de mariage et le certificat de nationalité du conjoint', 
 (SELECT id FROM procedures WHERE nom = 'Nationalité malienne par naturalisation' LIMIT 1));

-- ============================================
-- 3.48. COÛTS DE LA PROCÉDURE NATIONALITÉ PAR NATURALISATION
-- ============================================

-- Insertion des coûts
INSERT INTO couts (nom, prix, description) VALUES
('Droit de chancellerie - Nationalité par naturalisation', 0, 'Un droit de chancellerie, dont le taux est fixé par décret au profit du Trésor public');

-- Association du coût principal à la procédure
UPDATE procedures 
SET cout_id = (SELECT id FROM couts WHERE nom = 'Droit de chancellerie - Nationalité par naturalisation' LIMIT 1)
WHERE nom = 'Nationalité malienne par naturalisation';

-- ============================================
-- 3.49. ARTICLES DE LOI POUR LA NATIONALITÉ PAR NATURALISATION
-- ============================================

INSERT INTO lois_articles (description, consulter_article, procedure_id) VALUES
('Articles 237 et suivants du Code des Personnes et de la Famille', 
 'Articles 237 et suivants du Code des Personnes et de la Famille. Ces articles définissent les conditions et procédures pour l''acquisition de la nationalité malienne par naturalisation.',
 (SELECT id FROM procedures WHERE nom = 'Nationalité malienne par naturalisation' LIMIT 1));

-- ============================================
-- 3.50. CENTRE POUR LES PROCÉDURES DE NATIONALITÉ
-- ============================================

-- Ajout du centre Ministère de la Justice
INSERT INTO centres (nom, adresse, horaires, telephone, email, date_creation) VALUES
('Ministère de la Justice, Garde des Sceaux', 'Cité Administrative', 'Lundi-Vendredi: 8h-16h', '+223 20 23 68 98', 'justice@gouv.ml', NOW());

-- Association des centres aux procédures
UPDATE procedures 
SET centre_id = (SELECT id FROM centres WHERE nom = 'Ministère de la Justice, Garde des Sceaux' LIMIT 1)
WHERE nom IN ('Nationalité malienne par mariage', 'Nationalité malienne par naturalisation');

-- ============================================
-- 3.51. PROCÉDURE: CARTE GRISE (OBTENTION)
-- ============================================

-- Insertion de la procédure
INSERT INTO procedures (nom, titre, delai, description, categorie_id, sous_categorie_id, date_creation) VALUES
('Carte grise (obtention)', 'Obtenir une carte grise pour véhicule', '1 mois', 
 'Un véhicule importé relève de la douane et est généralement accompagné d''un carnet de transit routier inter-état, de la carte grise du véhicule usager ou de la facture d''achat du véhicule neuf. Le processus commence à la Direction Régionale des Transports, au niveau de la subdivision des transports au niveau du Cercle. Un expert est désigné pour inspecter le véhicule afin de déterminer son état et ses caractéristiques techniques, et d''établir un procès verbal de constatation. Ce PVC est transmis par bordereau à la Direction Nationale du Commerce et de la Concurrence pour établir l''attestation d''importation et calculer les droits et taxes de timbre. Le dossier est ensuite envoyé à la Direction Régionale des Impôts pour le paiement des droits et timbres, et pour l''enregistrement. La Direction Régionale des Impôts transmet le dossier à la Direction Régionale des Douanes où un concessionnaire agréé évalue les droits de douane. Le concessionnaire agréé établit la déclaration en douane accompagnée du procès verbal de constatation, de l''attestation d''importation, de la carte grise du véhicule usager ou de la facture d''achat du véhicule neuf.',
 (SELECT id FROM categories WHERE titre = 'Documents auto' LIMIT 1),
 (SELECT id FROM sous_categories WHERE titre = 'Carte grise (obtention)' LIMIT 1),
 NOW());

-- ============================================
-- 3.52. ÉTAPES DE LA PROCÉDURE CARTE GRISE (OBTENTION)
-- ============================================

INSERT INTO etapes (nom, description, niveau, procedure_id) VALUES
-- Étape 1: Expertise du véhicule
('Expertise du véhicule', 'Un expert est désigné pour inspecter le véhicule afin de déterminer son état et ses caractéristiques techniques, et d''établir un procès verbal de constatation (PVC).', 1,
 (SELECT id FROM procedures WHERE nom = 'Carte grise (obtention)' LIMIT 1)),

-- Étape 2: Attestation d'importation
('Attestation d''importation', 'Le PVC est transmis par bordereau à la Direction Nationale du Commerce et de la Concurrence pour établir l''attestation d''importation et calculer les droits et taxes de timbre.', 2,
 (SELECT id FROM procedures WHERE nom = 'Carte grise (obtention)' LIMIT 1)),

-- Étape 3: Paiement et enregistrement
('Paiement et enregistrement', 'Le dossier est envoyé à la Direction Régionale des Impôts pour le paiement des droits et timbres, et pour l''enregistrement.', 3,
 (SELECT id FROM procedures WHERE nom = 'Carte grise (obtention)' LIMIT 1)),

-- Étape 4: Évaluation des droits de douane
('Évaluation des droits de douane', 'La Direction Régionale des Impôts transmet le dossier à la Direction Régionale des Douanes où un concessionnaire agréé évalue les droits de douane.', 4,
 (SELECT id FROM procedures WHERE nom = 'Carte grise (obtention)' LIMIT 1)),

-- Étape 5: Déclaration en douane
('Déclaration en douane', 'Le concessionnaire agréé établit la déclaration en douane accompagnée du procès verbal de constatation, de l''attestation d''importation, de la carte grise du véhicule usager ou de la facture d''achat du véhicule neuf.', 5,
 (SELECT id FROM procedures WHERE nom = 'Carte grise (obtention)' LIMIT 1)),

-- Étape 6: Certificat de mise à la consommation
('Certificat de mise à la consommation', 'Établissement du certificat de mise à la consommation (CME) signé par le vérificateur et le Chef de Bureau du Guichet unique, transmis à la Direction Régionale des Transports.', 6,
 (SELECT id FROM procedures WHERE nom = 'Carte grise (obtention)' LIMIT 1)),

-- Étape 7: Carte grise définitive
('Carte grise définitive', 'La carte grise définitive est établie par la Division Production des documents de transport, signée par le Directeur National ou son adjoint, et transmise à la Direction Régionale d''origine.', 7,
 (SELECT id FROM procedures WHERE nom = 'Carte grise (obtention)' LIMIT 1));

-- ============================================
-- 3.53. DOCUMENTS REQUIS POUR CARTE GRISE (OBTENTION)
-- ============================================

INSERT INTO documents_requis (nom, description, est_obligatoire, procedure_id) VALUES
('Carnet TRIE', 'Carnet TRIE', true, 
 (SELECT id FROM procedures WHERE nom = 'Carte grise (obtention)' LIMIT 1)),

('Carte grise du véhicule usager ou Facture d''achat du véhicule neuf', 'Carte grise du véhicule usager ou Facture d''achat du véhicule neuf', true, 
 (SELECT id FROM procedures WHERE nom = 'Carte grise (obtention)' LIMIT 1)),

('Carte d''identité en cours de validité', 'Carte d''identité en cours de validité', true, 
 (SELECT id FROM procedures WHERE nom = 'Carte grise (obtention)' LIMIT 1)),

('Référence du bordereau d''envoi de la Douane', 'Référence du bordereau d''envoi de la Douane', true, 
 (SELECT id FROM procedures WHERE nom = 'Carte grise (obtention)' LIMIT 1)),

('Procuration s''il y a un mandataire', 'Une procuration s''il y a un mandataire', 
 (SELECT id FROM procedures WHERE nom = 'Carte grise (obtention)' LIMIT 1));

-- ============================================
-- 3.54. COÛTS DE LA PROCÉDURE CARTE GRISE (OBTENTION)
-- ============================================

-- Insertion des coûts
INSERT INTO couts (nom, prix, description) VALUES
('Prestation Concessionnaire en douane', 15000, '15,000 FCFA - Prestation Concessionnaire en douane'),
('Frais d''Immatriculation', 10000, '10,000 FCFA - Frais d''Immatriculation'),
('Procès Verbal de Constatation pour Immatriculation', 2500, '2,500 FCFA - Procès Verbal de Constatation pour Immatriculation'),
('Visite Technique', 5000, '5,000 FCFA - Visite Technique'),
('Plaque d''Immatriculation', 12000, '6,000 FCFA x 2 - Plaque d''Immatriculation'),
('Taxe de la sécurité routière', 10000, '10,000 FCFA - Taxe de la sécurité routière'),
('Droit de douane', 0, '10% ou 20% de la valeur - Droit de douane'),
('Redevance statistique', 0, '1% de la valeur - Redevance statistique'),
('Prélèvement Communautaire de Solidarité', 0, '1% - Prélèvement Communautaire de Solidarité'),
('Prélèvement Communautaire', 0, '1% - Prélèvement Communautaire'),
('TVA', 0, '18% - TVA'),
('Redevance Informatique', 5000, '5,000 FCFA - Redevance Informatique'),
('Travail Supplémentaire', 10000, '10,000 FCFA - Travail Supplémentaire');

-- Association du coût principal à la procédure
UPDATE procedures 
SET cout_id = (SELECT id FROM couts WHERE nom = 'Prestation Concessionnaire en douane' LIMIT 1)
WHERE nom = 'Carte grise (obtention)';

-- ============================================
-- 3.55. ARTICLES DE LOI POUR CARTE GRISE (OBTENTION)
-- ============================================

INSERT INTO lois_articles (description, consulter_article, procedure_id) VALUES
('Interministérielle N°2-0321/MICT du 22/02/2002', 
 'Interministérielle N°2-0321/MICT du 22/02/2002 réglementant l''importation des véhicules en République du Mali.',
 (SELECT id FROM procedures WHERE nom = 'Carte grise (obtention)' LIMIT 1)),

('Arrêté n° 2492/MFC/CAB du 07/08/78',
 'Arrêté n° 2492/MFC/CAB du 07/08/78 fixant les modalités d''évaluation en Douane pour les automobiles d''occasion importées.',
 (SELECT id FROM procedures WHERE nom = 'Carte grise (obtention)' LIMIT 1)),

('Arrêté n°04-2584/MEF SG du 17/12/04',
 'Arrêté n°04-2584/MEF SG du 17/12/04 instituant un Guichet unique pour le dédouanement des véhicules à Bamako.',
 (SELECT id FROM procedures WHERE nom = 'Carte grise (obtention)' LIMIT 1)),

('Arrêté n°07-0839/MEF-SG du 10/04/07',
 'Arrêté n°07-0839/MEF-SG du 10/04/07 réglementant les travaux effectués par l''Administration des Douanes en dehors des heures et lieux légaux où s''exerce régulièrement l''action du service.',
 (SELECT id FROM procedures WHERE nom = 'Carte grise (obtention)' LIMIT 1));

-- ============================================
-- 3.56. PROCÉDURE: CARTE GRISE (MUTATION)
-- ============================================

-- Insertion de la procédure
INSERT INTO procedures (nom, titre, delai, description, categorie_id, sous_categorie_id, date_creation) VALUES
('Carte grise (mutation)', 'Transférer la propriété d''une carte grise', '1 mois, prorogeable une fois pour une période de 15 jours', 
 'L''usager se présente à la section carte grise avec son véhicule. L''agent de la section procède à la vérification du dossier et le vise pour le payement à la caisse. Après payement, le dossier revient à la Section où il est enregistré et numéroté. L''agent de la section remplit le formulaire du document provisoire qu''il transmet au Chef de Division ou au Directeur Régional pour signature. Le document provisoire de mutation de la carte grise revient à la section pour être remis à l''usager. Le dossier va à la Salle Informatique pour saisie, puis est validé par l''agent chargé de la validation et retourne à la Salle Informatique pour le tirage de la carte grise. Le dossier revient à la section qui l''envoie au secrétariat pour l''établissement du bordereau d''envoi à la Direction Nationale. Le dossier est envoyé à la Direction Nationale après avoir été visé par le Chef de Division et signé par le Directeur Régional. A la Direction Nationale, on procède à l''enregistrement du dossier et à la vérification de sa conformité avec le dossier mère. S''il est conforme, le Directeur ou son Adjoint signe le document, qui est renvoyé à la Direction Régionale des Transports. Le dossier reste aux archives de la Direction Nationale. Si le dossier n''est pas conforme, il est rejeté.',
 (SELECT id FROM categories WHERE titre = 'Documents auto' LIMIT 1),
 (SELECT id FROM sous_categories WHERE titre = 'Carte grise (mutation)' LIMIT 1),
 NOW());

-- ============================================
-- 3.57. ÉTAPES DE LA PROCÉDURE CARTE GRISE (MUTATION)
-- ============================================

INSERT INTO etapes (nom, description, niveau, procedure_id) VALUES
-- Étape 1: Présentation à la section
('Présentation à la section', 'L''usager se présente à la section carte grise avec son véhicule.', 1,
 (SELECT id FROM procedures WHERE nom = 'Carte grise (mutation)' LIMIT 1)),

-- Étape 2: Vérification et visa
('Vérification et visa', 'L''agent de la section procède à la vérification du dossier et le vise pour le payement à la caisse.', 2,
 (SELECT id FROM procedures WHERE nom = 'Carte grise (mutation)' LIMIT 1)),

-- Étape 3: Enregistrement et numérotation
('Enregistrement et numérotation', 'Après payement, le dossier revient à la Section où il est enregistré et numéroté.', 3,
 (SELECT id FROM procedures WHERE nom = 'Carte grise (mutation)' LIMIT 1)),

-- Étape 4: Document provisoire
('Document provisoire', 'L''agent de la section remplit le formulaire du document provisoire qu''il transmet au Chef de Division ou au Directeur Régional pour signature.', 4,
 (SELECT id FROM procedures WHERE nom = 'Carte grise (mutation)' LIMIT 1)),

-- Étape 5: Remise du document provisoire
('Remise du document provisoire', 'Le document provisoire de mutation de la carte grise revient à la section pour être remis à l''usager.', 5,
 (SELECT id FROM procedures WHERE nom = 'Carte grise (mutation)' LIMIT 1)),

-- Étape 6: Saisie informatique
('Saisie informatique', 'Le dossier va à la Salle Informatique pour saisie, puis est validé par l''agent chargé de la validation et retourne à la Salle Informatique pour le tirage de la carte grise.', 6,
 (SELECT id FROM procedures WHERE nom = 'Carte grise (mutation)' LIMIT 1)),

-- Étape 7: Bordereau d'envoi
('Bordereau d''envoi', 'Le dossier revient à la section qui l''envoie au secrétariat pour l''établissement du bordereau d''envoi à la Direction Nationale.', 7,
 (SELECT id FROM procedures WHERE nom = 'Carte grise (mutation)' LIMIT 1)),

-- Étape 8: Envoi à la Direction Nationale
('Envoi à la Direction Nationale', 'Le dossier est envoyé à la Direction Nationale après avoir été visé par le Chef de Division et signé par le Directeur Régional.', 8,
 (SELECT id FROM procedures WHERE nom = 'Carte grise (mutation)' LIMIT 1)),

-- Étape 9: Vérification de conformité
('Vérification de conformité', 'A la Direction Nationale, on procède à l''enregistrement du dossier et à la vérification de sa conformité avec le dossier mère.', 9,
 (SELECT id FROM procedures WHERE nom = 'Carte grise (mutation)' LIMIT 1)),

-- Étape 10: Signature et retour
('Signature et retour', 'S''il est conforme, le Directeur ou son Adjoint signe le document, qui est renvoyé à la Direction Régionale des Transports.', 10,
 (SELECT id FROM procedures WHERE nom = 'Carte grise (mutation)' LIMIT 1)),

-- Étape 11: Archivage
('Archivage', 'Le dossier reste aux archives de la Direction Nationale.', 11,
 (SELECT id FROM procedures WHERE nom = 'Carte grise (mutation)' LIMIT 1)),

-- Étape 12: Récupération du document
('Récupération du document', 'L''usager ou son mandataire récupère le document à la section carte grise de la Direction Régionale des Transports en rendant le récépissé du document provisoire.', 12,
 (SELECT id FROM procedures WHERE nom = 'Carte grise (mutation)' LIMIT 1));

-- ============================================
-- 3.58. DOCUMENTS REQUIS POUR CARTE GRISE (MUTATION)
-- ============================================

INSERT INTO documents_requis (nom, description, est_obligatoire, procedure_id) VALUES
('La carte grise', 'La carte grise', true, 
 (SELECT id FROM procedures WHERE nom = 'Carte grise (mutation)' LIMIT 1)),

('L''attestation de vente légalisée par le maire ou le notaire', 'L''attestation de vente légalisée par le maire ou le notaire', true, 
 (SELECT id FROM procedures WHERE nom = 'Carte grise (mutation)' LIMIT 1)),

('La copie légalisée de la carte d''identité du vendeur en cours de validité', 'La copie légalisée de la carte d''identité du vendeur en cours de validité', true, 
 (SELECT id FROM procedures WHERE nom = 'Carte grise (mutation)' LIMIT 1)),

('La copie du certificat de visite technique en cours de validité', 'La copie du certificat de visite technique en cours de validité', true, 
 (SELECT id FROM procedures WHERE nom = 'Carte grise (mutation)' LIMIT 1)),

('La déclaration de mise en circulation', 'La déclaration de mise en circulation', 
 (SELECT id FROM procedures WHERE nom = 'Carte grise (mutation)' LIMIT 1));

-- ============================================
-- 3.59. COÛTS DE LA PROCÉDURE CARTE GRISE (MUTATION)
-- ============================================

-- Insertion des coûts
INSERT INTO couts (nom, prix, description) VALUES
('Redevance Propres DNT - Cartes grises', 10000, '10,000 FCFA - Redevance Propres DNT : Cartes grises'),
('Redevance Propres DNT - PVC', 2500, '2,500 FCFA - Redevance Propres DNT : PVC'),
('Timbres fiscaux', 0, '1,500 FCFA / CV - Timbres fiscaux'),
('Redevance sécurité routière', 11000, '10,000 FCFA + 500 FCFA/plaque - Redevance sécurité routière'),
('Frais plaque minéralogique', 12000, '6,000 FCFA/plaque - Frais plaque minéralogique');

-- Association du coût principal à la procédure
UPDATE procedures 
SET cout_id = (SELECT id FROM couts WHERE nom = 'Redevance Propres DNT - Cartes grises' LIMIT 1)
WHERE nom = 'Carte grise (mutation)';

-- ============================================
-- 3.60. PROCÉDURE: CARTE GRISE (RENOUVELLEMENT)
-- ============================================

-- Insertion de la procédure
INSERT INTO procedures (nom, titre, delai, description, categorie_id, sous_categorie_id, date_creation) VALUES
('Carte grise (renouvellement)', 'Renouveler une carte grise', '1 mois, prorogeable une fois pour une période de 15 jours', 
 'L''usager se présente à la section carte grise. L''agent de la section procède à la vérification du dossier et le vise pour le payement à la caisse. Après payement, le dossier revient à la Section où il est enregistré et numéroté. L''agent de la section remplit le formulaire du document provisoire qu''il transmet au Chef de Division ou au Directeur Régional pour signature. Le document provisoire de renouvellement de la carte grise revient à la section pour être remis à l''usager. Le dossier va à la Salle Informatique pour saisie, puis est validé par l''agent chargé de la validation et retourne à la Salle Informatique pour le tirage de la carte grise. Le dossier revient à la section qui l''envoie au secrétariat pour l''établissement du bordereau d''envoi à la Direction Nationale. Le dossier est envoyé à la Direction Nationale après avoir été visé par le Chef de Division et signé par le Directeur Régional. A la Direction Nationale, on procède à l''enregistrement du dossier et à la vérification de sa conformité avec le dossier mère. S''il est conforme, le Directeur ou son Adjoint signe le document, qui est renvoyé à la Direction Régionale des Transports. Le dossier reste aux archives de la Direction Nationale. Si le dossier n''est pas conforme, il est rejeté.',
 (SELECT id FROM categories WHERE titre = 'Documents auto' LIMIT 1),
 (SELECT id FROM sous_categories WHERE titre = 'Carte grise (renouvellement)' LIMIT 1),
 NOW());

-- ============================================
-- 3.61. ÉTAPES DE LA PROCÉDURE CARTE GRISE (RENOUVELLEMENT)
-- ============================================

INSERT INTO etapes (nom, description, niveau, procedure_id) VALUES
-- Étape 1: Présentation à la section
('Présentation à la section', 'L''usager se présente à la section carte grise.', 1,
 (SELECT id FROM procedures WHERE nom = 'Carte grise (renouvellement)' LIMIT 1)),

-- Étape 2: Vérification et visa
('Vérification et visa', 'L''agent de la section procède à la vérification du dossier et le vise pour le payement à la caisse.', 2,
 (SELECT id FROM procedures WHERE nom = 'Carte grise (renouvellement)' LIMIT 1)),

-- Étape 3: Enregistrement et numérotation
('Enregistrement et numérotation', 'Après payement, le dossier revient à la Section où il est enregistré et numéroté.', 3,
 (SELECT id FROM procedures WHERE nom = 'Carte grise (renouvellement)' LIMIT 1)),

-- Étape 4: Document provisoire
('Document provisoire', 'L''agent de la section remplit le formulaire du document provisoire qu''il transmet au Chef de Division ou au Directeur Régional pour signature.', 4,
 (SELECT id FROM procedures WHERE nom = 'Carte grise (renouvellement)' LIMIT 1)),

-- Étape 5: Remise du document provisoire
('Remise du document provisoire', 'Le document provisoire de renouvellement de la carte grise revient à la section pour être remis à l''usager.', 5,
 (SELECT id FROM procedures WHERE nom = 'Carte grise (renouvellement)' LIMIT 1)),

-- Étape 6: Saisie informatique
('Saisie informatique', 'Le dossier va à la Salle Informatique pour saisie, puis est validé par l''agent chargé de la validation et retourne à la Salle Informatique pour le tirage de la carte grise.', 6,
 (SELECT id FROM procedures WHERE nom = 'Carte grise (renouvellement)' LIMIT 1)),

-- Étape 7: Bordereau d'envoi
('Bordereau d''envoi', 'Le dossier revient à la section qui l''envoie au secrétariat pour l''établissement du bordereau d''envoi à la Direction Nationale.', 7,
 (SELECT id FROM procedures WHERE nom = 'Carte grise (renouvellement)' LIMIT 1)),

-- Étape 8: Envoi à la Direction Nationale
('Envoi à la Direction Nationale', 'Le dossier est envoyé à la Direction Nationale après avoir été visé par le Chef de Division et signé par le Directeur Régional.', 8,
 (SELECT id FROM procedures WHERE nom = 'Carte grise (renouvellement)' LIMIT 1)),

-- Étape 9: Vérification de conformité
('Vérification de conformité', 'A la Direction Nationale, on procède à l''enregistrement du dossier et à la vérification de sa conformité avec le dossier mère.', 9,
 (SELECT id FROM procedures WHERE nom = 'Carte grise (renouvellement)' LIMIT 1)),

-- Étape 10: Signature et retour
('Signature et retour', 'S''il est conforme, le Directeur ou son Adjoint signe le document, qui est renvoyé à la Direction Régionale des Transports.', 10,
 (SELECT id FROM procedures WHERE nom = 'Carte grise (renouvellement)' LIMIT 1)),

-- Étape 11: Récupération du document
('Récupération du document', 'L''usager ou son mandataire récupère le document à la section carte grise de la Direction Régionale des Transports en rendant le récépissé du document provisoire.', 11,
 (SELECT id FROM procedures WHERE nom = 'Carte grise (renouvellement)' LIMIT 1));

-- ============================================
-- 3.62. DOCUMENTS REQUIS POUR CARTE GRISE (RENOUVELLEMENT)
-- ============================================

INSERT INTO documents_requis (nom, description, est_obligatoire, procedure_id) VALUES
('La carte grise', 'La carte grise si elle est périmée, froissée ou illisible', true, 
 (SELECT id FROM procedures WHERE nom = 'Carte grise (renouvellement)' LIMIT 1)),

('Le PV de constatation', 'Le PV de constatation', true, 
 (SELECT id FROM procedures WHERE nom = 'Carte grise (renouvellement)' LIMIT 1)),

('La déclaration de mise en circulation', 'La déclaration de mise en circulation, établie par la DRTTF ou sa subdivision', true, 
 (SELECT id FROM procedures WHERE nom = 'Carte grise (renouvellement)' LIMIT 1)),

('Le certificat de visite technique en cours de validité', 'Le certificat de visite technique en cours de validité', 
 (SELECT id FROM procedures WHERE nom = 'Carte grise (renouvellement)' LIMIT 1));

-- ============================================
-- 3.63. COÛTS DE LA PROCÉDURE CARTE GRISE (RENOUVELLEMENT)
-- ============================================

-- Insertion des coûts
INSERT INTO couts (nom, prix, description) VALUES
('Redevance DNT', 8000, '8,000 FCFA - Redevance DNT'),
('Redevance PVC', 2500, '2,500 FCFA - Redevance PVC'),
('Timbres fiscaux', 4000, '4,000 FCFA - Timbres fiscaux'),
('Redevance sécurité routière', 5000, '5,000 FCFA - Redevance sécurité routière');

-- Association du coût principal à la procédure
UPDATE procedures 
SET cout_id = (SELECT id FROM couts WHERE nom = 'Redevance DNT' LIMIT 1)
WHERE nom = 'Carte grise (renouvellement)';

-- ============================================
-- 3.64. CENTRE POUR LES PROCÉDURES CARTE GRISE
-- ============================================

-- Ajout du centre Direction Régionale des Transports
INSERT INTO centres (nom, adresse, horaires, telephone, email, date_creation) VALUES
('Direction Régionale des Transports', 'Section Permis de Conduire', 'Lundi-Vendredi: 8h-16h', '+223 20 22 41 12', 'transports@darsalam.ml', NOW());

-- Association des centres aux procédures
UPDATE procedures 
SET centre_id = (SELECT id FROM centres WHERE nom = 'Direction Régionale des Transports' LIMIT 1)
WHERE nom IN ('Carte grise (obtention)', 'Carte grise (mutation)', 'Carte grise (renouvellement)');

-- ============================================
-- 3.65. PROCÉDURE: VISITE TECHNIQUE
-- ============================================

-- Insertion de la procédure
INSERT INTO procedures (nom, titre, delai, description, categorie_id, sous_categorie_id, date_creation) VALUES
('Visite technique', 'Effectuer une visite technique de véhicule', 'Variable selon le type de véhicule', 
 'L''usager se présente à Mali Technic System situé à Sogoniko ou à ses représentations régionales, précisément à la Section Enregistrement. Une fois les frais payés, le contrôleur inspecte le véhicule sur les aspects suivants : les freins, l''identification, l''éclairage, les pneus, la direction, la géométrie, la signalisation, les nuisances et les accessoires (essuie glace, extincteurs, roues secours, triangles, boîte à pharmacie). S''il n''y a pas de défaut, la validité de tous les éléments contrôlés est confirmée. Une vignette est alors apposée sur le pare-brise. L''agent d''exploitation donne le premier volet (volet n°1) du certificat à l''usager et le deuxième volet (volet n°2) à la direction régionale des transports pour classement. S''il y a un défaut, l''usager est soumis à une revisite. Il a quinze jours pour réparer le véhicule et revenir s''il s''agit d''un véhicule léger (1750 FCFA). Pour les transports publics et poids lourds, il a trente jours (2100 FCFA et 2800 FCFA respectivement). La visite technique est obligatoire pour tous les véhicules. La première visite technique intervient 3 ans après la première mise en circulation. La périodicité de la visite est de : une fois par an pour les véhicules personnels, deux fois par an pour les véhicules de transports et poids lourds.',
 (SELECT id FROM categories WHERE titre = 'Documents auto' LIMIT 1),
 (SELECT id FROM sous_categories WHERE titre = 'Visite technique' LIMIT 1),
 NOW());

-- ============================================
-- 3.66. ÉTAPES DE LA PROCÉDURE VISITE TECHNIQUE
-- ============================================

INSERT INTO etapes (nom, description, niveau, procedure_id) VALUES
-- Étape 1: Présentation à Mali Technic System
('Présentation à Mali Technic System', 'L''usager se présente à Mali Technic System situé à Sogoniko ou à ses représentations régionales, précisément à la Section Enregistrement.', 1,
 (SELECT id FROM procedures WHERE nom = 'Visite technique' LIMIT 1)),

-- Étape 2: Paiement des frais
('Paiement des frais', 'L''usager s''acquitte des frais de visite technique selon le type de véhicule.', 2,
 (SELECT id FROM procedures WHERE nom = 'Visite technique' LIMIT 1)),

-- Étape 3: Inspection du véhicule
('Inspection du véhicule', 'Le contrôleur inspecte le véhicule sur les aspects suivants : les freins, l''identification, l''éclairage, les pneus, la direction, la géométrie, la signalisation, les nuisances et les accessoires.', 3,
 (SELECT id FROM procedures WHERE nom = 'Visite technique' LIMIT 1)),

-- Étape 4: Résultat de l'inspection
('Résultat de l''inspection', 'Si aucun défaut n''est détecté, la validité de tous les éléments contrôlés est confirmée et une vignette est apposée sur le pare-brise.', 4,
 (SELECT id FROM procedures WHERE nom = 'Visite technique' LIMIT 1)),

-- Étape 5: Délivrance du certificat
('Délivrance du certificat', 'L''agent d''exploitation donne le premier volet (volet n°1) du certificat à l''usager et le deuxième volet (volet n°2) à la direction régionale des transports pour classement.', 5,
 (SELECT id FROM procedures WHERE nom = 'Visite technique' LIMIT 1)),

-- Étape 6: Revisite si défaut
('Revisite si défaut', 'S''il y a un défaut, l''usager est soumis à une revisite. Il a quinze jours pour réparer le véhicule et revenir s''il s''agit d''un véhicule léger, trente jours pour les transports publics et poids lourds.', 6,
 (SELECT id FROM procedures WHERE nom = 'Visite technique' LIMIT 1));

-- ============================================
-- 3.67. DOCUMENTS REQUIS POUR VISITE TECHNIQUE
-- ============================================

INSERT INTO documents_requis (nom, description, est_obligatoire, procedure_id) VALUES
('La carte grise du véhicule', 'La carte grise du véhicule', true, 
 (SELECT id FROM procedures WHERE nom = 'Visite technique' LIMIT 1)),

('Le procès verbal de constatation', 'Le procès verbal de constatation', true, 
 (SELECT id FROM procedures WHERE nom = 'Visite technique' LIMIT 1)),

('L''autorisation de circuler', 'L''autorisation de circuler généralement valable pour 24 heures', 
 (SELECT id FROM procedures WHERE nom = 'Visite technique' LIMIT 1));

-- ============================================
-- 3.68. COÛTS DE LA PROCÉDURE VISITE TECHNIQUE
-- ============================================

-- Insertion des coûts
INSERT INTO couts (nom, prix, description) VALUES
('Visite technique - Véhicules légers', 5000, '5,000 FCFA - Véhicules légers'),
('Visite technique - Transport public', 6000, '6,000 FCFA - Transport public'),
('Visite technique - Poids lourds', 8000, '8,000 FCFA - Poids lourds'),
('Frais ANASER', 2500, '2,500 FCFA - Frais ANASER'),
('Revisite - Véhicules légers', 1750, '1,750 FCFA - Revisite véhicules légers'),
('Revisite - Transport public', 2100, '2,100 FCFA - Revisite transport public'),
('Revisite - Poids lourds', 2800, '2,800 FCFA - Revisite poids lourds'),
('Pénalité 5-15 jours', 0, '25% du tarif de base - Pénalité 5 à 15 jours'),
('Pénalité 15-31 jours', 0, '50% du tarif de base - Pénalité 15 à 31 jours'),
('Pénalité 40+ jours', 0, '75% du tarif de base - Pénalité à partir de 40 jours');

-- Association du coût principal à la procédure
UPDATE procedures 
SET cout_id = (SELECT id FROM couts WHERE nom = 'Visite technique - Véhicules légers' LIMIT 1)
WHERE nom = 'Visite technique';

-- ============================================
-- 3.69. PROCÉDURE: VIGNETTE
-- ============================================

-- Insertion de la procédure
INSERT INTO procedures (nom, titre, delai, description, categorie_id, sous_categorie_id, date_creation) VALUES
('Vignette', 'Acquérir une vignette automobile', '1er janvier au 31 mars (période normale)', 
 'L''usager se présente aux guichets des impôts généralement du 1er janvier au 31 mars de l''année en cours, muni de la carte grise pour les véhicules ayant une ancienne immatriculation (à partir de la date de délivrance de la carte grise pour les véhicules qui sont à leur première immatriculation). Il s''acquitte des frais et reçoit la vignette qu''il doit apposer sur la pare brise, ainsi qu''un reçu. Lorsque la vignette est payée à partir du 1er octobre, l''usager doit s''acquitter du demi-tarif. Passés les délais de payement, l''usager est soumis à une pénalité de 100%.',
 (SELECT id FROM categories WHERE titre = 'Documents auto' LIMIT 1),
 (SELECT id FROM sous_categories WHERE titre = 'Vignette' LIMIT 1),
 NOW());

-- ============================================
-- 3.70. ÉTAPES DE LA PROCÉDURE VIGNETTE
-- ============================================

INSERT INTO etapes (nom, description, niveau, procedure_id) VALUES
-- Étape 1: Présentation aux guichets des impôts
('Présentation aux guichets des impôts', 'L''usager se présente aux guichets des impôts généralement du 1er janvier au 31 mars de l''année en cours, muni de la carte grise.', 1,
 (SELECT id FROM procedures WHERE nom = 'Vignette' LIMIT 1)),

-- Étape 2: Vérification de l'immatriculation
('Vérification de l''immatriculation', 'Vérification de l''ancienne immatriculation ou de la date de délivrance de la carte grise pour les véhicules à leur première immatriculation.', 2,
 (SELECT id FROM procedures WHERE nom = 'Vignette' LIMIT 1)),

-- Étape 3: Calcul des frais
('Calcul des frais', 'Calcul des frais selon la puissance fiscale du véhicule (CV).', 3,
 (SELECT id FROM procedures WHERE nom = 'Vignette' LIMIT 1)),

-- Étape 4: Paiement des frais
('Paiement des frais', 'L''usager s''acquitte des frais selon le tarif applicable (tarif normal, demi-tarif à partir du 1er octobre, ou pénalité de 100% après les délais).', 4,
 (SELECT id FROM procedures WHERE nom = 'Vignette' LIMIT 1)),

-- Étape 5: Délivrance de la vignette
('Délivrance de la vignette', 'L''usager reçoit la vignette qu''il doit apposer sur la pare brise, ainsi qu''un reçu.', 5,
 (SELECT id FROM procedures WHERE nom = 'Vignette' LIMIT 1));

-- ============================================
-- 3.71. DOCUMENTS REQUIS POUR VIGNETTE
-- ============================================

INSERT INTO documents_requis (nom, description, est_obligatoire, procedure_id) VALUES
('La carte grise', 'La carte grise du véhicule', true, 
 (SELECT id FROM procedures WHERE nom = 'Vignette' LIMIT 1));

-- ============================================
-- 3.72. COÛTS DE LA PROCÉDURE VIGNETTE
-- ============================================

-- Insertion des coûts
INSERT INTO couts (nom, prix, description) VALUES
('Vignette - Véhicules de 2 à 6 CV', 7000, '7,000 FCFA - Véhicules de 2 à 6 CV'),
('Vignette - Véhicules de 7 à 8 CV', 13000, '13,000 FCFA - Véhicules de 7 à 8 CV'),
('Vignette - Véhicules de 10 à 14 CV', 32000, '32,000 FCFA - Véhicules de 10 à 14 CV'),
('Vignette - Véhicules de 15 à 19 CV', 50000, '50,000 FCFA - Véhicules de 15 à 19 CV'),
('Vignette - Véhicules de 20 CV et plus', 75000, '75,000 FCFA - Véhicules de 20 CV et plus'),
('Demi-tarif à partir du 1er octobre', 0, 'Demi-tarif - Paiement à partir du 1er octobre'),
('Pénalité de retard', 0, '100% de pénalité - Passés les délais de paiement');

-- Association du coût principal à la procédure
UPDATE procedures 
SET cout_id = (SELECT id FROM couts WHERE nom = 'Vignette - Véhicules de 2 à 6 CV' LIMIT 1)
WHERE nom = 'Vignette';

-- ============================================
-- 3.73. CENTRES POUR LES PROCÉDURES AUTO
-- ============================================

-- Ajout du centre Mali Technic System
INSERT INTO centres (nom, adresse, horaires, telephone, email, date_creation) VALUES
('Mali Technic System', 'Sogoniko', 'Lundi-Vendredi: 8h-16h', '+223 20 22 41 12', 'mts@sogoniko.ml', NOW());

-- Ajout du centre Service des Impôts
INSERT INTO centres (nom, adresse, horaires, telephone, email, date_creation) VALUES
('Service des Impôts', 'Service des Impôts de la commune', 'Lundi-Vendredi: 8h-16h', '+223 20 22 64 63', 'impots@commune.ml', NOW());

-- Association des centres aux procédures
UPDATE procedures 
SET centre_id = (SELECT id FROM centres WHERE nom = 'Mali Technic System' LIMIT 1)
WHERE nom = 'Visite technique';

UPDATE procedures 
SET centre_id = (SELECT id FROM centres WHERE nom = 'Service des Impôts' LIMIT 1)
WHERE nom = 'Vignette';

-- ============================================
-- 3.74. PROCÉDURE: CHANGEMENT DE COULEUR DE PLAQUE
-- ============================================

-- Insertion de la procédure
INSERT INTO procedures (nom, titre, delai, description, categorie_id, sous_categorie_id, date_creation) VALUES
('Changement de couleur de plaque', 'Changer la couleur des plaques minéralogiques', '1 mois, prorogeable une fois pour une période de 15 jours', 
 'Le dossier est saisi pour un changement de couleur de plaque. Le véhicule doit être présent. L''usager se présente à la section carte grise. L''agent de la section procède à la vérification du dossier et le vise pour le payement à la caisse. Après payement, le dossier revient à la Section où il est enregistré et numéroté. L''agent de la section remplit le formulaire du document provisoire qu''il transmet au Chef de Division ou au Directeur Régional pour signature. Le document provisoire de changement de couleur de plaque revient à la section pour être remis à l''usager. Le dossier va à la Salle Informatique pour saisie, puis est validé par l''agent chargé de la validation et retourne à la Salle Informatique pour le tirage de la carte grise. Le dossier revient à la section qui l''envoie au secrétariat pour l''établissement du bordereau d''envoi à la Direction Nationale. Le dossier est envoyé à la Direction Nationale après avoir été visé par le Chef de Division et signé par le Directeur Régional. A la Direction Nationale, on procède à l''enregistrement du dossier et à la vérification de sa conformité avec le dossier mère. S''il est conforme, le Directeur ou son Adjoint signe le document, qui est renvoyé à la Direction Régionale des Transports. Le dossier reste aux archives de la Direction Nationale. Si le dossier n''est pas conforme, il est rejeté. L''usager ou son mandataire récupère le document à la section carte grise de la Direction Régionale des Transports et procède au retrait des plaques en rendant le document provisoire. Il doit déposer les anciennes plaques.',
 (SELECT id FROM categories WHERE titre = 'Documents auto' LIMIT 1),
 (SELECT id FROM sous_categories WHERE titre = 'Changement de couleur de plaque' LIMIT 1),
 NOW());

-- ============================================
-- 3.75. ÉTAPES DE LA PROCÉDURE CHANGEMENT DE COULEUR DE PLAQUE
-- ============================================

INSERT INTO etapes (nom, description, niveau, procedure_id) VALUES
-- Étape 1: Présentation à la section carte grise
('Présentation à la section carte grise', 'L''usager se présente à la section carte grise avec le véhicule présent pour un changement de couleur de plaque.', 1,
 (SELECT id FROM procedures WHERE nom = 'Changement de couleur de plaque' LIMIT 1)),

-- Étape 2: Vérification et visa
('Vérification et visa', 'L''agent de la section procède à la vérification du dossier et le vise pour le payement à la caisse.', 2,
 (SELECT id FROM procedures WHERE nom = 'Changement de couleur de plaque' LIMIT 1)),

-- Étape 3: Enregistrement et numérotation
('Enregistrement et numérotation', 'Après payement, le dossier revient à la Section où il est enregistré et numéroté.', 3,
 (SELECT id FROM procedures WHERE nom = 'Changement de couleur de plaque' LIMIT 1)),

-- Étape 4: Document provisoire
('Document provisoire', 'L''agent de la section remplit le formulaire du document provisoire qu''il transmet au Chef de Division ou au Directeur Régional pour signature.', 4,
 (SELECT id FROM procedures WHERE nom = 'Changement de couleur de plaque' LIMIT 1)),

-- Étape 5: Remise du document provisoire
('Remise du document provisoire', 'Le document provisoire de changement de couleur de plaque revient à la section pour être remis à l''usager.', 5,
 (SELECT id FROM procedures WHERE nom = 'Changement de couleur de plaque' LIMIT 1)),

-- Étape 6: Saisie informatique
('Saisie informatique', 'Le dossier va à la Salle Informatique pour saisie, puis est validé par l''agent chargé de la validation et retourne à la Salle Informatique pour le tirage de la carte grise.', 6,
 (SELECT id FROM procedures WHERE nom = 'Changement de couleur de plaque' LIMIT 1)),

-- Étape 7: Bordereau d'envoi
('Bordereau d''envoi', 'Le dossier revient à la section qui l''envoie au secrétariat pour l''établissement du bordereau d''envoi à la Direction Nationale.', 7,
 (SELECT id FROM procedures WHERE nom = 'Changement de couleur de plaque' LIMIT 1)),

-- Étape 8: Envoi à la Direction Nationale
('Envoi à la Direction Nationale', 'Le dossier est envoyé à la Direction Nationale après avoir été visé par le Chef de Division et signé par le Directeur Régional.', 8,
 (SELECT id FROM procedures WHERE nom = 'Changement de couleur de plaque' LIMIT 1)),

-- Étape 9: Vérification de conformité
('Vérification de conformité', 'A la Direction Nationale, on procède à l''enregistrement du dossier et à la vérification de sa conformité avec le dossier mère.', 9,
 (SELECT id FROM procedures WHERE nom = 'Changement de couleur de plaque' LIMIT 1)),

-- Étape 10: Signature et retour
('Signature et retour', 'S''il est conforme, le Directeur ou son Adjoint signe le document, qui est renvoyé à la Direction Régionale des Transports.', 10,
 (SELECT id FROM procedures WHERE nom = 'Changement de couleur de plaque' LIMIT 1)),

-- Étape 11: Archivage
('Archivage', 'Le dossier reste aux archives de la Direction Nationale.', 11,
 (SELECT id FROM procedures WHERE nom = 'Changement de couleur de plaque' LIMIT 1)),

-- Étape 12: Récupération et retrait des plaques
('Récupération et retrait des plaques', 'L''usager ou son mandataire récupère le document à la section carte grise de la Direction Régionale des Transports et procède au retrait des plaques en rendant le document provisoire. Il doit déposer les anciennes plaques.', 12,
 (SELECT id FROM procedures WHERE nom = 'Changement de couleur de plaque' LIMIT 1));

-- ============================================
-- 3.76. DOCUMENTS REQUIS POUR CHANGEMENT DE COULEUR DE PLAQUE
-- ============================================

INSERT INTO documents_requis (nom, description, est_obligatoire, procedure_id) VALUES
('La carte grise', 'La carte grise du véhicule', true, 
 (SELECT id FROM procedures WHERE nom = 'Changement de couleur de plaque' LIMIT 1)),

('La visite technique en cours de validité', 'La visite technique en cours de validité', true, 
 (SELECT id FROM procedures WHERE nom = 'Changement de couleur de plaque' LIMIT 1)),

('La déclaration de mise en circulation', 'La déclaration de mise en circulation délivrée par la DRTTF ou la subdivision', 
 (SELECT id FROM procedures WHERE nom = 'Changement de couleur de plaque' LIMIT 1));

-- ============================================
-- 3.77. COÛTS DE LA PROCÉDURE CHANGEMENT DE COULEUR DE PLAQUE
-- ============================================

-- Insertion des coûts
INSERT INTO couts (nom, prix, description) VALUES
('Frais Plaques Minéralogiques', 12000, '6,000 FCFA / plaque - Frais Plaques Minéralogiques (2 plaques)');

-- Association du coût principal à la procédure
UPDATE procedures 
SET cout_id = (SELECT id FROM couts WHERE nom = 'Frais Plaques Minéralogiques' LIMIT 1)
WHERE nom = 'Changement de couleur de plaque';

-- ============================================
-- 3.78. ASSOCIATION DU CENTRE POUR CHANGEMENT DE COULEUR DE PLAQUE
-- ============================================

-- Association du centre existant à la procédure
UPDATE procedures 
SET centre_id = (SELECT id FROM centres WHERE nom = 'Direction Régionale des Transports' LIMIT 1)
WHERE nom = 'Changement de couleur de plaque';

-- ============================================
-- 3.79. PROCÉDURE: LIBÉRATION CONDITIONNELLE
-- ============================================

-- Insertion de la procédure
INSERT INTO procedures (nom, titre, delai, description, categorie_id, sous_categorie_id, date_creation) VALUES
('Libération conditionnelle', 'Demander une libération conditionnelle', 'En fonction de la durée des travaux de la commission pénitentiaire', 
 'La libération conditionnelle est une suspension de l''exécution d''une peine privative de liberté accompagnée d''une mesure d''aide et de contrôle, l''octroi ou le maintien de laquelle est subordonné à l''observation de certaines conditions. La matière est régie par le Code de procédure pénale. Conditions de fond : Tout condamné peut être admis au bénéfice de la libération conditionnelle, si les conditions suivantes sont remplies : avoir été condamné à titre définitif à une ou plusieurs peines privatives de liberté, avoir donné des preuves suffisantes de bonne conduite, donner des gages sérieux de réadaptation sociale. Conditions de forme : La libération conditionnelle est réservée aux condamnés ayant accompli trois mois de leur peine, si cette peine est inférieure à 6 mois et la moitié de cette peine en cas contraire. Pour les condamnés en état de récidive, le temps d''épreuve est porté à 6 mois si la peine est inférieure à 3 mois et aux deux tiers de la peine dans le cas contraire. Pour les condamnés aux travaux forcés à perpétuité le temps d''épreuve est de 15 années. En matière de drogue, la liberté conditionnelle ne peut être accordée à aucun condamné avant l''exécution des 4/5ème des quantum de la peine prononcée.',
 (SELECT id FROM categories WHERE titre = 'Documents justice' LIMIT 1),
 (SELECT id FROM sous_categories WHERE titre = 'Libération conditionnelle' LIMIT 1),
 NOW());

-- ============================================
-- 3.80. ÉTAPES DE LA PROCÉDURE LIBÉRATION CONDITIONNELLE
-- ============================================

INSERT INTO etapes (nom, description, niveau, procedure_id) VALUES
-- Étape 1: Vérification des conditions de fond
('Vérification des conditions de fond', 'Vérification que le condamné a été condamné à titre définitif à une ou plusieurs peines privatives de liberté, a donné des preuves suffisantes de bonne conduite et donne des gages sérieux de réadaptation sociale.', 1,
 (SELECT id FROM procedures WHERE nom = 'Libération conditionnelle' LIMIT 1)),

-- Étape 2: Vérification des conditions de forme
('Vérification des conditions de forme', 'Vérification du temps d''épreuve accompli selon le type de peine et la situation du condamné (récidive, travaux forcés à perpétuité, matière de drogue).', 2,
 (SELECT id FROM procedures WHERE nom = 'Libération conditionnelle' LIMIT 1)),

-- Étape 3: Dépôt de la demande
('Dépôt de la demande', 'Le détenu condamné ou son avocat adresse une demande au Ministre de la justice dès que les conditions de fond et de forme sont remplies.', 3,
 (SELECT id FROM procedures WHERE nom = 'Libération conditionnelle' LIMIT 1)),

-- Étape 4: Préparation du dossier par l'administration pénitentiaire
('Préparation du dossier par l''administration pénitentiaire', 'L''administration pénitentiaire et le Juge d''application des peines préparent un extrait du registre d''écrou et un avis du chef de circonscription.', 4,
 (SELECT id FROM procedures WHERE nom = 'Libération conditionnelle' LIMIT 1)),

-- Étape 5: Examen par la commission pénitentiaire
('Examen par la commission pénitentiaire', 'La commission pénitentiaire consultative de l''aménagement des peines examine le dossier et émet un avis.', 5,
 (SELECT id FROM procedures WHERE nom = 'Libération conditionnelle' LIMIT 1)),

-- Étape 6: Décision du Ministre
('Décision du Ministre', 'Le Ministre de la justice prend la décision d''accorder ou de refuser la libération conditionnelle après avis de la commission.', 6,
 (SELECT id FROM procedures WHERE nom = 'Libération conditionnelle' LIMIT 1)),

-- Étape 7: Notification et mise en œuvre
('Notification et mise en œuvre', 'Si accordée, la libération conditionnelle est notifiée et mise en œuvre avec les mesures de contrôle et obligations particulières.', 7,
 (SELECT id FROM procedures WHERE nom = 'Libération conditionnelle' LIMIT 1));

-- ============================================
-- 3.81. DOCUMENTS REQUIS POUR LIBÉRATION CONDITIONNELLE
-- ============================================

INSERT INTO documents_requis (nom, description, est_obligatoire, procedure_id) VALUES
('Demande adressée au Ministre de la justice', 'Une demande adressée au Ministre de la justice. Cette demande peut être faite en son nom par l''avocat.', true, 
 (SELECT id FROM procedures WHERE nom = 'Libération conditionnelle' LIMIT 1)),

('Extrait du registre d''écrou', 'Un extrait du registre d''écrou de l''établissement dont relève le détenu.', true, 
 (SELECT id FROM procedures WHERE nom = 'Libération conditionnelle' LIMIT 1)),

('Avis du chef de circonscription', 'Un avis du chef de la circonscription où le détenu entend fixer sa résidence.', 
 (SELECT id FROM procedures WHERE nom = 'Libération conditionnelle' LIMIT 1));

-- ============================================
-- 3.82. COÛTS DE LA PROCÉDURE LIBÉRATION CONDITIONNELLE
-- ============================================

-- Insertion des coûts
INSERT INTO couts (nom, prix, description) VALUES
('Libération conditionnelle', 0, 'Gratuit - Nature de la pièce délivrée: un arrêté de liberté conditionnelle après avis de la commission pénitentiaire consultative de l''aménagement des peines');

-- Association du coût principal à la procédure
UPDATE procedures 
SET cout_id = (SELECT id FROM couts WHERE nom = 'Libération conditionnelle' LIMIT 1)
WHERE nom = 'Libération conditionnelle';

-- ============================================
-- 3.83. PROCÉDURE: DÉCLARATION DE PERTE
-- ============================================

-- Insertion de la procédure
INSERT INTO procedures (nom, titre, delai, description, categorie_id, sous_categorie_id, date_creation) VALUES
('Déclaration de perte', 'Déclarer la perte de documents', 'Immédiat', 
 'Toute personne ayant perdu ses papiers est admis à en faire la déclarations immédiatement afin d''éviter la fraude et/ou l''usage de ceux-ci par un tiers. Comment est faite la déclaration ? Par déclaration écrite ou verbale. Qui reçoit la déclaration ? L''autorité compétente notamment le préfet, le commissariat de police, la gendarmerie à la section Voie publique ou le chef de poste de garde le jour de la déclaration dans le registre de la main courante. NB : La déclaration de certains documents tels que le titre foncier ne débouche pas sur la livraison à l''usager d''un certificat de perte.',
 (SELECT id FROM categories WHERE titre = 'Documents justice' LIMIT 1),
 (SELECT id FROM sous_categories WHERE titre = 'Déclaration de perte' LIMIT 1),
 NOW());

-- ============================================
-- 3.84. ÉTAPES DE LA PROCÉDURE DÉCLARATION DE PERTE
-- ============================================

INSERT INTO etapes (nom, description, niveau, procedure_id) VALUES
-- Étape 1: Identification du déclarant
('Identification du déclarant', 'Présentation de la carte d''identité ou toute pièce permettant d''identifier le déclarant.', 1,
 (SELECT id FROM procedures WHERE nom = 'Déclaration de perte' LIMIT 1)),

-- Étape 2: Déclaration de la perte
('Déclaration de la perte', 'Le déclarant fait une déclaration écrite ou verbale de la perte de ses documents.', 2,
 (SELECT id FROM procedures WHERE nom = 'Déclaration de perte' LIMIT 1)),

-- Étape 3: Enregistrement dans le registre
('Enregistrement dans le registre', 'L''autorité compétente enregistre la déclaration dans le registre de la main courante le jour même.', 3,
 (SELECT id FROM procedures WHERE nom = 'Déclaration de perte' LIMIT 1)),

-- Étape 4: Délivrance de l'attestation
('Délivrance de l''attestation', 'L''autorité compétente délivre immédiatement une attestation de perte de papiers (sauf pour certains documents comme le titre foncier).', 4,
 (SELECT id FROM procedures WHERE nom = 'Déclaration de perte' LIMIT 1));

-- ============================================
-- 3.85. DOCUMENTS REQUIS POUR DÉCLARATION DE PERTE
-- ============================================

INSERT INTO documents_requis (nom, description, est_obligatoire, procedure_id) VALUES
('Carte d''identité ou pièce d''identification', 'La carte d''identité ou toute pièce permettant d''identifier le déclarant', true, 
 (SELECT id FROM procedures WHERE nom = 'Déclaration de perte' LIMIT 1));

-- ============================================
-- 3.86. COÛTS DE LA PROCÉDURE DÉCLARATION DE PERTE
-- ============================================

-- Insertion des coûts
INSERT INTO couts (nom, prix, description) VALUES
('Déclaration de perte', 0, 'Gratuit - Nature de la pièce délivrée: une attestation de perte de papiers');

-- Association du coût principal à la procédure
UPDATE procedures 
SET cout_id = (SELECT id FROM couts WHERE nom = 'Déclaration de perte' LIMIT 1)
WHERE nom = 'Déclaration de perte';

-- ============================================
-- 3.87. CENTRES POUR LES PROCÉDURES JUSTICE
-- ============================================

-- Ajout du centre Ministère de la Justice (déjà existant, on l'utilise)
-- Le centre "Ministère de la Justice, Garde des Sceaux" existe déjà

-- Ajout des centres pour déclaration de perte
INSERT INTO centres (nom, adresse, horaires, telephone, email, date_creation) VALUES
('Préfecture', 'Préfecture de la région', 'Lundi-Vendredi: 8h-16h', 'Contactez votre préfecture', 'prefecture@region.ml', NOW());

INSERT INTO centres (nom, adresse, horaires, telephone, email, date_creation) VALUES
('Commissariat de Police', 'Commissariat de police de la commune', '24h/24', 'Contactez votre commissariat', 'police@commune.ml', NOW());

INSERT INTO centres (nom, adresse, horaires, telephone, email, date_creation) VALUES
('Gendarmerie', 'Gendarmerie - Section Voie publique', 'Lundi-Vendredi: 8h-16h', 'Contactez votre gendarmerie', 'gendarmerie@region.ml', NOW());

-- Association des centres aux procédures
UPDATE procedures 
SET centre_id = (SELECT id FROM centres WHERE nom = 'Ministère de la Justice, Garde des Sceaux' LIMIT 1)
WHERE nom = 'Libération conditionnelle';

-- Pour la déclaration de perte, on peut associer plusieurs centres
-- On choisit le commissariat comme centre principal
UPDATE procedures 
SET centre_id = (SELECT id FROM centres WHERE nom = 'Commissariat de Police' LIMIT 1)
WHERE nom = 'Déclaration de perte';

-- ============================================
-- 3.88. PROCÉDURE: DEMANDE DE LIBÉRATION PROVISOIRE
-- ============================================

-- Insertion de la procédure
INSERT INTO procedures (nom, titre, delai, description, categorie_id, sous_categorie_id, date_creation) VALUES
('Demande de libération provisoire', 'Demander une mise en liberté provisoire', '8 jours après la demande adressée au juge', 
 'La mise en liberté provisoire peut être demandée en tout état de cause par tout individu de nationalité malienne ou étrangère lorsqu''il se trouve être prévenu, inculpé ou accusé. La liberté provisoire peut être ordonnée soit par le juge d''instruction, soit sur réquisition du ministère public, soit d''office. A la condition que l''inculpé prenne l''engagement de se représenter à tous les actes de la procédure aussitôt qu''il lui sera demandé et de tenir le magistrat instructeur informé de tous ses déplacements. L''inculpé ou son avocat peuvent demander la liberté provisoire à toute période de la procédure. Toutefois, lorsque la mise en liberté n''est pas de droit, elle peut être subordonnée à l''obligation de payer un cautionnement ou de constituer des sûretés. Ceux-ci garantissent la représentation de l''inculpé, l''exécution du jugement, les frais avancés par la partie civile, les frais avancés par la partie publique et les amendes notamment.',
 (SELECT id FROM categories WHERE titre = 'Documents justice' LIMIT 1),
 (SELECT id FROM sous_categories WHERE titre = 'Demande de libération provisoire' LIMIT 1),
 NOW());

-- ============================================
-- 3.89. ÉTAPES DE LA PROCÉDURE DEMANDE DE LIBÉRATION PROVISOIRE
-- ============================================

INSERT INTO etapes (nom, description, niveau, procedure_id) VALUES
-- Étape 1: Vérification des conditions
('Vérification des conditions', 'Vérification que l''inculpé accepte de se représenter à tous les actes de la procédure et de tenir le magistrat instructeur informé de tous ses déplacements.', 1,
 (SELECT id FROM procedures WHERE nom = 'Demande de libération provisoire' LIMIT 1)),

-- Étape 2: Dépôt de la demande
('Dépôt de la demande', 'L''inculpé ou son avocat adresse une demande au magistrat chargé du dossier à toute période de la procédure.', 2,
 (SELECT id FROM procedures WHERE nom = 'Demande de libération provisoire' LIMIT 1)),

-- Étape 3: Examen par le juge d'instruction
('Examen par le juge d''instruction', 'Le juge d''instruction examine la demande de mise en liberté provisoire.', 3,
 (SELECT id FROM procedures WHERE nom = 'Demande de libération provisoire' LIMIT 1)),

-- Étape 4: Réquisitions du Procureur
('Réquisitions du Procureur', 'Le Procureur de la République émet ses réquisitions sur la demande.', 4,
 (SELECT id FROM procedures WHERE nom = 'Demande de libération provisoire' LIMIT 1)),

-- Étape 5: Décision du juge
('Décision du juge', 'Le juge d''instruction rend une ordonnance spécialement motivée dans les 8 jours après la demande.', 5,
 (SELECT id FROM procedures WHERE nom = 'Demande de libération provisoire' LIMIT 1)),

-- Étape 6: Constitution des garanties si nécessaire
('Constitution des garanties si nécessaire', 'Si la mise en liberté n''est pas de droit, constitution d''un cautionnement ou de sûretés pour garantir la représentation et l''exécution du jugement.', 6,
 (SELECT id FROM procedures WHERE nom = 'Demande de libération provisoire' LIMIT 1)),

-- Étape 7: Mise en liberté
('Mise en liberté', 'Mise en liberté provisoire de l''inculpé avec les conditions et obligations fixées par l''ordonnance.', 7,
 (SELECT id FROM procedures WHERE nom = 'Demande de libération provisoire' LIMIT 1));

-- ============================================
-- 3.90. DOCUMENTS REQUIS POUR DEMANDE DE LIBÉRATION PROVISOIRE
-- ============================================

INSERT INTO documents_requis (nom, description, est_obligatoire, procedure_id) VALUES
('Demande de l''inculpé ou de son conseil', 'Une demande de l''inculpé ou de son conseil adressée au magistrat chargé du dossier', true, 
 (SELECT id FROM procedures WHERE nom = 'Demande de libération provisoire' LIMIT 1));

-- ============================================
-- 3.91. COÛTS DE LA PROCÉDURE DEMANDE DE LIBÉRATION PROVISOIRE
-- ============================================

-- Insertion des coûts
INSERT INTO couts (nom, prix, description) VALUES
('Demande de libération provisoire', 0, 'Gratuit - Toutefois, lorsque la mise en liberté n''est pas de droit, elle peut être subordonnée à l''obligation de payer un cautionnement ou de constituer des sûretés'),
('Cautionnement', 0, 'Variable selon la décision - Garantit la représentation de l''inculpé, l''exécution du jugement, les frais avancés par les parties et les amendes');

-- Association du coût principal à la procédure
UPDATE procedures 
SET cout_id = (SELECT id FROM couts WHERE nom = 'Demande de libération provisoire' LIMIT 1)
WHERE nom = 'Demande de libération provisoire';

-- ============================================
-- 3.92. ARTICLES DE LOI POUR DEMANDE DE LIBÉRATION PROVISOIRE
-- ============================================

INSERT INTO lois_articles (description, consulter_article, procedure_id) VALUES
('Article 148 et suivants du Code de procédure pénale', 
 'Article 148 et suivants du Code de procédure pénale régissant la mise en liberté provisoire.',
 (SELECT id FROM procedures WHERE nom = 'Demande de libération provisoire' LIMIT 1));

-- ============================================
-- 3.93. PROCÉDURE: AUTORISATION D'ACHAT D'ARMES ET MUNITIONS
-- ============================================

-- Insertion de la procédure
INSERT INTO procedures (nom, titre, delai, description, categorie_id, sous_categorie_id, date_creation) VALUES
('Autorisation d''achat d''armes et munitions', 'Obtenir une autorisation d''achat d''armes et munitions', 'Plusieurs semaines', 
 'L''autorisation d''achat d''armes et de munitions permet à son détenteur d''acheter ou d''importer une arme ou des munitions pour la chasse ou pour sa propre sécurité. Le port de chaque arme nécessite une autorisation distincte. Toute personne intéressée âgée de 21 ans au moins peut demander l''autorisation. En cas de perte ou de vol, il faut formuler une nouvelle demande ou demander un duplicata en fournissant les mêmes documents que pour la demande initiale.',
 (SELECT id FROM categories WHERE titre = 'Documents justice' LIMIT 1),
 (SELECT id FROM sous_categories WHERE titre = 'Autorisation d''achat d''armes et munitions' LIMIT 1),
 NOW());

-- ============================================
-- 3.94. ÉTAPES DE LA PROCÉDURE AUTORISATION D'ACHAT D'ARMES ET MUNITIONS
-- ============================================

INSERT INTO etapes (nom, description, niveau, procedure_id) VALUES
-- Étape 1: Vérification des conditions d'âge
('Vérification des conditions d''âge', 'Vérification que le demandeur est âgé de 21 ans au moins.', 1,
 (SELECT id FROM procedures WHERE nom = 'Autorisation d''achat d''armes et munitions' LIMIT 1)),

-- Étape 2: Préparation du dossier
('Préparation du dossier', 'Préparation de tous les documents requis : demande manuscrite, copie de carte d''identité, extrait de casier judiciaire, photos d''identité et timbre fiscal.', 2,
 (SELECT id FROM procedures WHERE nom = 'Autorisation d''achat d''armes et munitions' LIMIT 1)),

-- Étape 3: Dépôt de la demande
('Dépôt de la demande', 'Dépôt de la demande manuscrite adressée au Directeur de la Police Nationale avec tous les documents requis.', 3,
 (SELECT id FROM procedures WHERE nom = 'Autorisation d''achat d''armes et munitions' LIMIT 1)),

-- Étape 4: Examen du dossier
('Examen du dossier', 'Examen du dossier par la Direction Générale de la Police Nationale.', 4,
 (SELECT id FROM procedures WHERE nom = 'Autorisation d''achat d''armes et munitions' LIMIT 1)),

-- Étape 5: Vérifications de sécurité
('Vérifications de sécurité', 'Vérifications de sécurité et de l''extrait de casier judiciaire du demandeur.', 5,
 (SELECT id FROM procedures WHERE nom = 'Autorisation d''achat d''armes et munitions' LIMIT 1)),

-- Étape 6: Décision et délivrance
('Décision et délivrance', 'Décision d''octroi ou de refus de l''autorisation et délivrance du permis ou autorisation de port d''armes.', 6,
 (SELECT id FROM procedures WHERE nom = 'Autorisation d''achat d''armes et munitions' LIMIT 1));

-- ============================================
-- 3.95. DOCUMENTS REQUIS POUR AUTORISATION D'ACHAT D'ARMES ET MUNITIONS
-- ============================================

INSERT INTO documents_requis (nom, description, est_obligatoire, procedure_id) VALUES
('Demande manuscrite', 'Une demande manuscrite adressée au Directeur de la Police Nationale', true, 
 (SELECT id FROM procedures WHERE nom = 'Autorisation d''achat d''armes et munitions' LIMIT 1)),

('Copie certifiée conforme de la carte d''identité nationale', 'Une copie certifiée conforme de la carte d''identité nationale', true, 
 (SELECT id FROM procedures WHERE nom = 'Autorisation d''achat d''armes et munitions' LIMIT 1)),

('Extrait de casier judiciaire', 'Un extrait de casier judiciaire', true, 
 (SELECT id FROM procedures WHERE nom = 'Autorisation d''achat d''armes et munitions' LIMIT 1)),

('Quatre photos d''identité', 'Quatre photos d''identité', true, 
 (SELECT id FROM procedures WHERE nom = 'Autorisation d''achat d''armes et munitions' LIMIT 1)),

('Timbre fiscal de 750 FCFA', 'Un timbre fiscal de 750 FCFA', 
 (SELECT id FROM procedures WHERE nom = 'Autorisation d''achat d''armes et munitions' LIMIT 1));

-- ============================================
-- 3.96. COÛTS DE LA PROCÉDURE AUTORISATION D'ACHAT D'ARMES ET MUNITIONS
-- ============================================

-- Insertion des coûts
INSERT INTO couts (nom, prix, description) VALUES
('Autorisation d''achat d''armes et munitions', 0, 'Gratuit - Nature de la pièce délivrée: permis ou autorisation de port d''armes'),
('Timbre fiscal', 750, '750 FCFA - Timbre fiscal obligatoire');

-- Association du coût principal à la procédure
UPDATE procedures 
SET cout_id = (SELECT id FROM couts WHERE nom = 'Autorisation d''achat d''armes et munitions' LIMIT 1)
WHERE nom = 'Autorisation d''achat d''armes et munitions';

-- ============================================
-- 3.97. CENTRES POUR LES PROCÉDURES SÉCURITÉ
-- ============================================

-- Ajout du centre Ministère de la Sécurité et de la Protection civile
INSERT INTO centres (nom, adresse, horaires, telephone, email, date_creation) VALUES
('Ministère de la Sécurité et de la Protection civile', 'ACI 2000', 'Lundi-Vendredi: 8h-16h', '+223 20 22 39 77', 'securite@mali.ml', NOW());

-- Ajout du centre Direction Générale de la Police Nationale
INSERT INTO centres (nom, adresse, horaires, telephone, email, date_creation) VALUES
('Direction Générale de la Police Nationale', 'ACI 2000', 'Lundi-Vendredi: 8h-16h', '+223 20 22 44 05', 'police.nationale@mali.ml', NOW());

-- Association des centres aux procédures
UPDATE procedures 
SET centre_id = (SELECT id FROM centres WHERE nom = 'Ministère de la Justice, Garde des Sceaux' LIMIT 1)
WHERE nom = 'Demande de libération provisoire';

UPDATE procedures 
SET centre_id = (SELECT id FROM centres WHERE nom = 'Direction Générale de la Police Nationale' LIMIT 1)
WHERE nom = 'Autorisation d''achat d''armes et munitions';

-- ============================================
-- 3.98. PROCÉDURE: DEMANDE DE VISITE D'UN PRISONNIER
-- ============================================

-- Insertion de la procédure
INSERT INTO procedures (nom, titre, delai, description, categorie_id, sous_categorie_id, date_creation) VALUES
('Demande de visite d''un prisonnier', 'Obtenir un permis de communiquer pour visiter un prisonnier', 'Variable selon l''entretien avec le juge', 
 'Le permis de communiquer est un acte par lequel le procureur ou le Juge d''Instruction autorise un citoyen à rendre visite à un prévenu ou à un inculpé à la Maison d''Arrêt. Dans la pratique, c''est aussi une technique utilisée pour observer ceux qui lui rendent visite. En principe, l''usager adresse une demande verbale au Juge (par son secrétaire) qui peut demander un entretien plus approfondi au terme duquel il délivre ou non le permis. Le permis de communiquer est gratuit et est valable pour une seule visite. Toutefois, il peut être valable pour une période, pour les parents proches du prévenu.',
 (SELECT id FROM categories WHERE titre = 'Documents justice' LIMIT 1),
 (SELECT id FROM sous_categories WHERE titre = 'Demande de visite d''un prisonnier' LIMIT 1),
 NOW());

-- ============================================
-- 3.99. ÉTAPES DE LA PROCÉDURE DEMANDE DE VISITE D'UN PRISONNIER
-- ============================================

INSERT INTO etapes (nom, description, niveau, procedure_id) VALUES
-- Étape 1: Demande verbale au juge
('Demande verbale au juge', 'L''usager adresse une demande verbale au Juge d''Instruction ou au Procureur par l''intermédiaire de son secrétaire.', 1,
 (SELECT id FROM procedures WHERE nom = 'Demande de visite d''un prisonnier' LIMIT 1)),

-- Étape 2: Entretien approfondi si nécessaire
('Entretien approfondi si nécessaire', 'Le Juge peut demander un entretien plus approfondi avec le demandeur pour évaluer la demande.', 2,
 (SELECT id FROM procedures WHERE nom = 'Demande de visite d''un prisonnier' LIMIT 1)),

-- Étape 3: Décision du juge
('Décision du juge', 'Le Juge d''Instruction ou le Procureur délivre ou refuse le permis de communiquer après évaluation.', 3,
 (SELECT id FROM procedures WHERE nom = 'Demande de visite d''un prisonnier' LIMIT 1)),

-- Étape 4: Délivrance du permis
('Délivrance du permis', 'Si accordé, le permis de communiquer est délivré pour une visite unique ou pour une période (parents proches).', 4,
 (SELECT id FROM procedures WHERE nom = 'Demande de visite d''un prisonnier' LIMIT 1)),

-- Étape 5: Visite à la Maison d'Arrêt
('Visite à la Maison d''Arrêt', 'Le détenteur du permis se rend à la Maison d''Arrêt pour rendre visite au prévenu ou inculpé.', 5,
 (SELECT id FROM procedures WHERE nom = 'Demande de visite d''un prisonnier' LIMIT 1));

-- ============================================
-- 3.100. DOCUMENTS REQUIS POUR DEMANDE DE VISITE D'UN PRISONNIER
-- ============================================

INSERT INTO documents_requis (nom, description, est_obligatoire, procedure_id) VALUES
('Demande verbale', 'Une demande verbale adressée au Juge d''Instruction ou au Procureur par l''intermédiaire de son secrétaire', true, 
 (SELECT id FROM procedures WHERE nom = 'Demande de visite d''un prisonnier' LIMIT 1));

-- ============================================
-- 3.101. COÛTS DE LA PROCÉDURE DEMANDE DE VISITE D'UN PRISONNIER
-- ============================================

-- Insertion des coûts
INSERT INTO couts (nom, prix, description) VALUES
('Permis de communiquer', 0, 'Gratuit - Valable pour une seule visite ou pour une période (parents proches du prévenu)');

-- Association du coût principal à la procédure
UPDATE procedures 
SET cout_id = (SELECT id FROM couts WHERE nom = 'Permis de communiquer' LIMIT 1)
WHERE nom = 'Demande de visite d''un prisonnier';

-- ============================================
-- 3.102. ARTICLES DE LOI POUR DEMANDE DE VISITE D'UN PRISONNIER
-- ============================================

INSERT INTO lois_articles (description, consulter_article, procedure_id) VALUES
('Loi n°01-080 du 20 août 2001 portant Code de Procédure Pénale', 
 'Loi n°01-080 du 20 août 2001 portant Code de Procédure Pénale régissant le permis de communiquer.',
 (SELECT id FROM procedures WHERE nom = 'Demande de visite d''un prisonnier' LIMIT 1));

-- ============================================
-- 3.103. ASSOCIATION DU CENTRE POUR DEMANDE DE VISITE D'UN PRISONNIER
-- ============================================

-- Association du centre existant à la procédure
UPDATE procedures 
SET centre_id = (SELECT id FROM centres WHERE nom = 'Ministère de la Justice, Garde des Sceaux' LIMIT 1)
WHERE nom = 'Demande de visite d''un prisonnier';

-- ============================================
-- 3.104. PROCÉDURE: CRÉATION D'ENTREPRISE INDIVIDUELLE
-- ============================================

-- Insertion de la procédure
INSERT INTO procedures (nom, titre, delai, description, categorie_id, sous_categorie_id, date_creation) VALUES
('Création d''entreprise individuelle', 'Créer une entreprise individuelle au Mali', '72 heures ouvrables', 
 'Pour créer une entreprise individuelle au Mali, il faut se rendre au Guichet unique de l''Agence de Promotion des Investissements (API Mali) avec un dossier comprenant une copie de la pièce d''identité, l''extrait de l''acte de naissance, l''extrait du casier judiciaire, le certificat de nationalité et le certificat de résidence, le cas échéant. Le processus peut être finalisé en environ 72 heures. Les frais de création varient selon le type d''activité (par exemple, FCFA 8000 pour un commerce général ou FCFA 12000 pour un commerce import-export ou nécessitant un agrément). Après le traitement du dossier, vous pourrez retirer vos documents administratifs au guichet unique, notamment le Registre du Commerce et du Crédit Mobilier (RCCM) et la carte d''identification fiscale (NIF).',
 (SELECT id FROM categories WHERE titre = 'Documents commerce' LIMIT 1),
 (SELECT id FROM sous_categories WHERE titre = 'Création d''entreprise individuelle' LIMIT 1),
 NOW());

-- ============================================
-- 3.105. ÉTAPES DE LA PROCÉDURE CRÉATION D'ENTREPRISE INDIVIDUELLE
-- ============================================

INSERT INTO etapes (nom, description, niveau, procedure_id) VALUES
-- Étape 1: Constitution du dossier
('Constitution du dossier', 'Rassemblement des pièces justificatives nécessaires : copie de la pièce d''identité, acte de naissance, casier judiciaire, certificat de nationalité, certificat de résidence et acte de mariage si applicable.', 1,
 (SELECT id FROM procedures WHERE nom = 'Création d''entreprise individuelle' LIMIT 1)),

-- Étape 2: Dépôt du dossier
('Dépôt du dossier', 'Rendez-vous au Guichet unique de l''API Mali pour déposer tous les documents requis.', 2,
 (SELECT id FROM procedures WHERE nom = 'Création d''entreprise individuelle' LIMIT 1)),

-- Étape 3: Paiement des frais
('Paiement des frais', 'Règlement des frais de création qui varient selon le type d''activité (8,000 FCFA pour commerce général, 12,000 FCFA pour import-export ou activités nécessitant agrément).', 3,
 (SELECT id FROM procedures WHERE nom = 'Création d''entreprise individuelle' LIMIT 1)),

-- Étape 4: Traitement du dossier
('Traitement du dossier', 'Traitement du dossier par l''API Mali et les services compétents pour l''enregistrement de l''entreprise.', 4,
 (SELECT id FROM procedures WHERE nom = 'Création d''entreprise individuelle' LIMIT 1)),

-- Étape 5: Retrait des documents
('Retrait des documents', 'Retrait des documents administratifs au guichet unique après traitement (environ 72 heures ouvrables) : RCCM et carte d''identification fiscale (NIF).', 5,
 (SELECT id FROM procedures WHERE nom = 'Création d''entreprise individuelle' LIMIT 1));

-- ============================================
-- 3.106. DOCUMENTS REQUIS POUR CRÉATION D'ENTREPRISE INDIVIDUELLE
-- ============================================

INSERT INTO documents_requis (nom, description, est_obligatoire, procedure_id) VALUES
('Copie de la pièce d''identité', 'Copie de la pièce d''identité (passeport ou carte NINA)', true, 
 (SELECT id FROM procedures WHERE nom = 'Création d''entreprise individuelle' LIMIT 1)),

('Copie de l''acte de naissance', 'Copie de l''acte de naissance', true, 
 (SELECT id FROM procedures WHERE nom = 'Création d''entreprise individuelle' LIMIT 1)),

('Extrait de casier judiciaire', 'Extrait de casier judiciaire', true, 
 (SELECT id FROM procedures WHERE nom = 'Création d''entreprise individuelle' LIMIT 1)),

('Certificat de nationalité', 'Certificat de nationalité (délivré par le greffe du tribunal de première instance)', true, 
 (SELECT id FROM procedures WHERE nom = 'Création d''entreprise individuelle' LIMIT 1)),

('Certificat de résidence', 'Certificat de résidence (délivré par le commissariat de police)', true, 
 (SELECT id FROM procedures WHERE nom = 'Création d''entreprise individuelle' LIMIT 1)),

('Copie de l''acte de mariage', 'Copie de l''acte de mariage (si applicable)', 
 (SELECT id FROM procedures WHERE nom = 'Création d''entreprise individuelle' LIMIT 1));

-- ============================================
-- 3.107. COÛTS DE LA PROCÉDURE CRÉATION D'ENTREPRISE INDIVIDUELLE
-- ============================================

-- Insertion des coûts
INSERT INTO couts (nom, prix, description) VALUES
('Frais de création - Commerce général', 8000, '8,000 FCFA - Frais de création pour commerce général'),
('Frais de création - Import-export', 12000, '12,000 FCFA - Frais de création pour commerce import-export ou activités nécessitant agrément');

-- Association du coût principal à la procédure
UPDATE procedures 
SET cout_id = (SELECT id FROM couts WHERE nom = 'Frais de création - Commerce général' LIMIT 1)
WHERE nom = 'Création d''entreprise individuelle';

-- ============================================
-- 3.108. CENTRE POUR CRÉATION D'ENTREPRISE INDIVIDUELLE
-- ============================================

-- Ajout du centre API Mali
INSERT INTO centres (nom, adresse, horaires, telephone, email, date_creation) VALUES
('API Mali - Guichet unique', 'Agence de Promotion des Investissements', 'Lundi-Vendredi: 8h-16h', '+223 20 22 39 77', 'api@mali.ml', NOW());

-- Association du centre à la procédure
UPDATE procedures 
SET centre_id = (SELECT id FROM centres WHERE nom = 'API Mali - Guichet unique' LIMIT 1)
WHERE nom = 'Création d''entreprise individuelle';

-- ============================================
-- 3.109. PROCÉDURE: CRÉATION DE SARL
-- ============================================

-- Insertion de la procédure
INSERT INTO procedures (nom, titre, delai, description, categorie_id, sous_categorie_id, date_creation) VALUES
('Création de SARL', 'Créer une Société à Responsabilité Limitée (SARL) au Mali', '72 heures après dépôt du dossier complet', 
 'Pour créer une SARL au Mali, vous devez rédiger les statuts, déposer le capital social, constituer un dossier d''immatriculation au Guichet Unique de l''API Mali, faire la publication dans un journal d''annonces légales, puis obtenir les certificats et les immatriculations auprès de l''API. Le processus comprend la rédaction des statuts, la désignation des gérants, le dépôt du capital social minimum, la constitution du dossier d''immatriculation, la publication d''un avis de création dans un journal d''annonces légales, le dépôt du dossier complet et l''enregistrement fiscal. Les frais s''élèvent à 6,000 FCFA pour les SARL.',
 (SELECT id FROM categories WHERE titre = 'Documents commerce' LIMIT 1),
 (SELECT id FROM sous_categories WHERE titre = 'Création de SARL' LIMIT 1),
 NOW());

-- ============================================
-- 3.110. ÉTAPES DE LA PROCÉDURE CRÉATION DE SARL
-- ============================================

INSERT INTO etapes (nom, description, niveau, procedure_id) VALUES
-- Étape 1: Rédaction des statuts et dépôt du capital
('Rédaction des statuts et dépôt du capital', 'Rédaction des statuts de la société par écrit, désignation des gérants (associés ou non), dépôt du capital social minimum requis et obtention de l''attestation de dépôt.', 1,
 (SELECT id FROM procedures WHERE nom = 'Création de SARL' LIMIT 1)),

-- Étape 2: Constitution du dossier d'immatriculation
('Constitution du dossier d''immatriculation', 'Rassemblement de tous les documents nécessaires : formulaire d''immatriculation, statuts signés, justificatif de siège social, attestation de dépôt des fonds, déclaration de non-condamnation des gérants et copie de pièce d''identité des gérants.', 2,
 (SELECT id FROM procedures WHERE nom = 'Création de SARL' LIMIT 1)),

-- Étape 3: Publication d'un avis de création
('Publication d''un avis de création', 'Publication d''un avis de création dans un journal d''annonces légales (JAL) pour informer le public de la création de la société.', 3,
 (SELECT id FROM procedures WHERE nom = 'Création de SARL' LIMIT 1)),

-- Étape 4: Dépôt du dossier et paiement des frais
('Dépôt du dossier et paiement des frais', 'Dépôt du dossier complet au Guichet Unique de l''API Mali et règlement des frais de 6,000 FCFA pour les SARL.', 4,
 (SELECT id FROM procedures WHERE nom = 'Création de SARL' LIMIT 1)),

-- Étape 5: Traitement et obtention des certificats
('Traitement et obtention des certificats', 'Traitement du dossier par l''API Mali et obtention des documents : certificat RCCM, certificat NIMA, carte d''identification fiscale et retrait du journal ayant publié l''annonce.', 5,
 (SELECT id FROM procedures WHERE nom = 'Création de SARL' LIMIT 1)),

-- Étape 6: Enregistrement fiscal
('Enregistrement fiscal', 'Obtention du numéro d''identification fiscale (NIF) auprès du service des impôts et accomplissement des autres formalités fiscales nécessaires.', 6,
 (SELECT id FROM procedures WHERE nom = 'Création de SARL' LIMIT 1));

-- ============================================
-- 3.111. DOCUMENTS REQUIS POUR CRÉATION DE SARL
-- ============================================

INSERT INTO documents_requis (nom, description, est_obligatoire, procedure_id) VALUES
('Formulaire d''immatriculation', 'Le formulaire d''immatriculation (disponible au guichet unique)', true, 
 (SELECT id FROM procedures WHERE nom = 'Création de SARL' LIMIT 1)),

('Statuts signés', 'Les statuts de la société signés par les associés', true, 
 (SELECT id FROM procedures WHERE nom = 'Création de SARL' LIMIT 1)),

('Justificatif de siège social', 'Un justificatif de siège social (bail, facture d''électricité, etc.)', true, 
 (SELECT id FROM procedures WHERE nom = 'Création de SARL' LIMIT 1)),

('Attestation de dépôt des fonds', 'L''attestation de dépôt des fonds du capital social', true, 
 (SELECT id FROM procedures WHERE nom = 'Création de SARL' LIMIT 1)),

('Déclaration de non-condamnation des gérants', 'Une déclaration de non-condamnation des gérants', true, 
 (SELECT id FROM procedures WHERE nom = 'Création de SARL' LIMIT 1)),

('Copie de la pièce d''identité des gérants', 'Une copie de la pièce d''identité du ou des gérants', 
 (SELECT id FROM procedures WHERE nom = 'Création de SARL' LIMIT 1));

-- ============================================
-- 3.112. COÛTS DE LA PROCÉDURE CRÉATION DE SARL
-- ============================================

-- Insertion des coûts
INSERT INTO couts (nom, prix, description) VALUES
('Frais de création SARL', 6000, '6,000 FCFA - Frais de création pour Société à Responsabilité Limitée (SARL)');

-- Association du coût principal à la procédure
UPDATE procedures 
SET cout_id = (SELECT id FROM couts WHERE nom = 'Frais de création SARL' LIMIT 1)
WHERE nom = 'Création de SARL';

-- ============================================
-- 3.113. ASSOCIATION DU CENTRE POUR CRÉATION DE SARL
-- ============================================

-- Association du centre existant à la procédure
UPDATE procedures 
SET centre_id = (SELECT id FROM centres WHERE nom = 'API Mali - Guichet unique' LIMIT 1)
WHERE nom = 'Création de SARL';

-- ============================================
-- 3.114. PROCÉDURE: CRÉATION DE SOCIÉTÉ ANONYME (SA)
-- ============================================

-- Insertion de la procédure
INSERT INTO procedures (nom, titre, delai, description, categorie_id, sous_categorie_id, date_creation) VALUES
('Création de Société Anonyme (SA)', 'Créer une Société Anonyme (SA) au Mali', '72 heures après dépôt du dossier complet', 
 'Pour créer une Société Anonyme (SA) au Mali, vous devez passer par le Guichet Unique de l''Agence pour la Promotion des Investissements (API-Mali), en déposant les statuts notariés et le dossier de constitution. Le capital social minimum requis est de 10 millions de FCFA, divisé en actions d''une valeur nominale de 10,000 FCFA minimum. Il faut libérer au moins la moitié du capital numéraire à la création. Le processus comprend la rédaction des statuts par un notaire, la définition du capital social et des apports, la désignation des dirigeants, la publication d''un avis de création dans un journal d''annonces légales, le dépôt du dossier de constitution et l''obtention des documents officiels.',
 (SELECT id FROM categories WHERE titre = 'Documents commerce' LIMIT 1),
 (SELECT id FROM sous_categories WHERE titre = 'Création de Société Anonyme (SA)' LIMIT 1),
 NOW());

-- ============================================
-- 3.115. ÉTAPES DE LA PROCÉDURE CRÉATION DE SOCIÉTÉ ANONYME (SA)
-- ============================================

INSERT INTO etapes (nom, description, niveau, procedure_id) VALUES
-- Étape 1: Rédaction des statuts
('Rédaction des statuts', 'Rédaction des statuts de la société par un notaire (préférable pour une SA) ou acte sous seing privé. Les statuts doivent être signés par tous les actionnaires et peuvent être notariés ou non.', 1,
 (SELECT id FROM procedures WHERE nom = 'Création de Société Anonyme (SA)' LIMIT 1)),

-- Étape 2: Définition du capital social et des apports
('Définition du capital social et des apports', 'Définition du capital social minimum de 10 millions de FCFA, divisé en actions d''une valeur nominale de 10,000 FCFA minimum. Libération d''au moins la moitié du capital numéraire à la création.', 2,
 (SELECT id FROM procedures WHERE nom = 'Création de Société Anonyme (SA)' LIMIT 1)),

-- Étape 3: Désignation des dirigeants
('Désignation des dirigeants', 'Choix et désignation des dirigeants de la SA avec définition claire de leur rôle et organisation pour faciliter la rédaction des statuts.', 3,
 (SELECT id FROM procedures WHERE nom = 'Création de Société Anonyme (SA)' LIMIT 1)),

-- Étape 4: Publication d'un avis de création
('Publication d''un avis de création', 'Publication d''un avis de création de la SA dans un journal d''annonces légales et conservation de l''attestation de publication pour le dossier de création.', 4,
 (SELECT id FROM procedures WHERE nom = 'Création de Société Anonyme (SA)' LIMIT 1)),

-- Étape 5: Constitution et dépôt du dossier
('Constitution et dépôt du dossier', 'Constitution d''un dossier complet comprenant les statuts notariés et tous les documents requis, puis dépôt au Guichet Unique de l''API-Mali.', 5,
 (SELECT id FROM procedures WHERE nom = 'Création de Société Anonyme (SA)' LIMIT 1)),

-- Étape 6: Validation et obtention des documents
('Validation et obtention des documents', 'Validation du dossier par l''API-Mali et obtention des documents officiels : Certificat RCCM, Certificat NIMA, Carte d''Identification Fiscale et journal contenant l''annonce de création.', 6,
 (SELECT id FROM procedures WHERE nom = 'Création de Société Anonyme (SA)' LIMIT 1));

-- ============================================
-- 3.116. DOCUMENTS REQUIS POUR CRÉATION DE SOCIÉTÉ ANONYME (SA)
-- ============================================

INSERT INTO documents_requis (nom, description, est_obligatoire, procedure_id) VALUES
('Statuts notariés', 'Les statuts de la société rédigés par un notaire et signés par tous les actionnaires', true, 
 (SELECT id FROM procedures WHERE nom = 'Création de Société Anonyme (SA)' LIMIT 1)),

('Dossier de constitution', 'Le dossier complet de constitution de la société avec tous les documents requis', true, 
 (SELECT id FROM procedures WHERE nom = 'Création de Société Anonyme (SA)' LIMIT 1)),

('Attestation de libération du capital', 'Attestation de libération d''au moins la moitié du capital numéraire (5 millions FCFA minimum)', true, 
 (SELECT id FROM procedures WHERE nom = 'Création de Société Anonyme (SA)' LIMIT 1)),

('Attestation de publication JAL', 'Attestation de publication de l''avis de création dans un journal d''annonces légales', true, 
 (SELECT id FROM procedures WHERE nom = 'Création de Société Anonyme (SA)' LIMIT 1)),

('Déclaration des dirigeants', 'Déclaration de non-condamnation et pièces d''identité des dirigeants de la SA', 
 (SELECT id FROM procedures WHERE nom = 'Création de Société Anonyme (SA)' LIMIT 1));

-- ============================================
-- 3.117. COÛTS DE LA PROCÉDURE CRÉATION DE SOCIÉTÉ ANONYME (SA)
-- ============================================

-- Insertion des coûts
INSERT INTO couts (nom, prix, description) VALUES
('Frais de création SA', 0, 'Frais variables selon l''API-Mali - Frais de création pour Société Anonyme (SA)'),
('Capital social minimum', 10000000, '10,000,000 FCFA - Capital social minimum requis pour une SA'),
('Libération partielle', 5000000, '5,000,000 FCFA - Libération d''au moins la moitié du capital numéraire à la création'),
('Valeur nominale action', 10000, '10,000 FCFA - Valeur nominale minimum par action');

-- Association du coût principal à la procédure
UPDATE procedures 
SET cout_id = (SELECT id FROM couts WHERE nom = 'Frais de création SA' LIMIT 1)
WHERE nom = 'Création de Société Anonyme (SA)';

-- ============================================
-- 3.118. ASSOCIATION DU CENTRE POUR CRÉATION DE SOCIÉTÉ ANONYME (SA)
-- ============================================

-- Association du centre existant à la procédure
UPDATE procedures 
SET centre_id = (SELECT id FROM centres WHERE nom = 'API Mali - Guichet unique' LIMIT 1)
WHERE nom = 'Création de Société Anonyme (SA)';

-- ============================================
-- 3.119. PROCÉDURE: CRÉATION DE SOCIÉTÉ PAR ACTIONS SIMPLIFIÉE (SAS)
-- ============================================

-- Insertion de la procédure
INSERT INTO procedures (nom, titre, delai, description, categorie_id, sous_categorie_id, date_creation) VALUES
('Création de Société par Actions Simplifiée (SAS)', 'Créer une Société par Actions Simplifiée (SAS) au Mali', '72 heures après dépôt du dossier complet', 
 'Pour créer une Société par Actions Simplifiée (SAS) au Mali, il faut suivre la procédure encadrée par l''Agence pour la Promotion des Investissements au Mali (API-Mali) via son Guichet Unique. Le Mali, en tant que membre de l''OHADA, applique l''Acte Uniforme relatif au droit des sociétés commerciales et du Groupement d''Intérêt Économique, ce qui permet la création d''une SAS ou d''une SASU (SAS à associé unique). La SAS offre une grande liberté contractuelle, notamment pour la répartition du pouvoir entre les associés. Un avantage majeur de la SAS est qu''elle ne requiert pas de capital minimum, ce qui facilite sa création. Le processus comprend la rédaction des statuts, le dépôt du capital social, l''obtention des pièces justificatives, le dépôt du dossier au Guichet Unique, l''enregistrement et immatriculation, et la publication de l''avis de constitution.',
 (SELECT id FROM categories WHERE titre = 'Documents commerce' LIMIT 1),
 (SELECT id FROM sous_categories WHERE titre = 'Création de Société par Actions Simplifiée (SAS)' LIMIT 1),
 NOW());

-- ============================================
-- 3.120. ÉTAPES DE LA PROCÉDURE CRÉATION DE SOCIÉTÉ PAR ACTIONS SIMPLIFIÉE (SAS)
-- ============================================

INSERT INTO etapes (nom, description, niveau, procedure_id) VALUES
-- Étape 1: Rédaction des statuts et nomination des dirigeants
('Rédaction des statuts et nomination des dirigeants', 'Rédaction précise des statuts incluant la dénomination sociale, l''objet social, l''adresse du siège, le montant du capital, la durée de la société et les modalités de gestion. La SAS offre une grande liberté contractuelle pour la répartition du pouvoir entre les associés.', 1,
 (SELECT id FROM procedures WHERE nom = 'Création de Société par Actions Simplifiée (SAS)' LIMIT 1)),

-- Étape 2: Dépôt du capital social
('Dépôt du capital social', 'Dépôt du capital social dans une banque au Mali. Un avantage de la SAS est qu''elle ne requiert pas de capital minimum, ce qui facilite sa création.', 2,
 (SELECT id FROM procedures WHERE nom = 'Création de Société par Actions Simplifiée (SAS)' LIMIT 1)),

-- Étape 3: Obtention des pièces justificatives
('Obtention des pièces justificatives', 'Obtention de tous les documents nécessaires : casier judiciaire des dirigeants, copies des pièces d''identité des fondateurs, attestations de filiation et déclarations sur l''honneur de non-condamnation.', 3,
 (SELECT id FROM procedures WHERE nom = 'Création de Société par Actions Simplifiée (SAS)' LIMIT 1)),

-- Étape 4: Dépôt du dossier au Guichet Unique
('Dépôt du dossier au Guichet Unique', 'Dépôt du dossier complet au Guichet Unique de l''API-Mali pour un traitement centralisé de toutes les formalités de création d''entreprise.', 4,
 (SELECT id FROM procedures WHERE nom = 'Création de Société par Actions Simplifiée (SAS)' LIMIT 1)),

-- Étape 5: Enregistrement et immatriculation
('Enregistrement et immatriculation', 'Enregistrement des statuts au service des impôts et immatriculation de la société au Registre du Commerce et du Crédit Mobilier (RCCM) avec délivrance du certificat RCCM.', 5,
 (SELECT id FROM procedures WHERE nom = 'Création de Société par Actions Simplifiée (SAS)' LIMIT 1)),

-- Étape 6: Publication de l'avis de constitution
('Publication de l''avis de constitution', 'Publication d''une annonce légale de la création de la société dans le Journal officiel du Mali et retrait de la carte d''identification fiscale et de l''annonce publiée.', 6,
 (SELECT id FROM procedures WHERE nom = 'Création de Société par Actions Simplifiée (SAS)' LIMIT 1));

-- ============================================
-- 3.121. DOCUMENTS REQUIS POUR CRÉATION DE SOCIÉTÉ PAR ACTIONS SIMPLIFIÉE (SAS)
-- ============================================

INSERT INTO documents_requis (nom, description, est_obligatoire, procedure_id) VALUES
('Photocopie légalisée de la pièce d''identité', 'Une photocopie légalisée de la pièce d''identité (carte d''identité ou passeport) des fondateurs et dirigeants', true, 
 (SELECT id FROM procedures WHERE nom = 'Création de Société par Actions Simplifiée (SAS)' LIMIT 1)),

('Extrait d''acte de naissance ou certificat de nationalité', 'Deux copies légalisées de l''extrait d''acte de naissance ou du certificat de nationalité', true, 
 (SELECT id FROM procedures WHERE nom = 'Création de Société par Actions Simplifiée (SAS)' LIMIT 1)),

('Extrait de casier judiciaire', 'Un extrait de casier judiciaire datant de moins de 3 mois, ou une déclaration sur l''honneur de non-condamnation si le casier n''est pas disponible', true, 
 (SELECT id FROM procedures WHERE nom = 'Création de Société par Actions Simplifiée (SAS)' LIMIT 1)),

('Permis de séjour ou visa', 'Un permis de séjour ou un visa valide pour les associés ou dirigeants étrangers', true, 
 (SELECT id FROM procedures WHERE nom = 'Création de Société par Actions Simplifiée (SAS)' LIMIT 1)),

('Attestation de résidence', 'Une attestation de résidence ou tout autre justificatif de domicile', true, 
 (SELECT id FROM procedures WHERE nom = 'Création de Société par Actions Simplifiée (SAS)' LIMIT 1)),

('Statuts de la société', 'Les statuts de la société, qui doivent être rédigés en respectant l''Acte Uniforme OHADA', true, 
 (SELECT id FROM procedures WHERE nom = 'Création de Société par Actions Simplifiée (SAS)' LIMIT 1)),

('Procès-verbal d''assemblée générale', 'Un procès-verbal d''assemblée générale de constitution si la société a plusieurs associés', true, 
 (SELECT id FROM procedures WHERE nom = 'Création de Société par Actions Simplifiée (SAS)' LIMIT 1)),

('Attestation de dépôt des fonds', 'Une attestation de dépôt des fonds si un capital social est versé en numéraire', true, 
 (SELECT id FROM procedures WHERE nom = 'Création de Société par Actions Simplifiée (SAS)' LIMIT 1)),

('Déclaration de souscription et versement', 'Une déclaration de souscription et de versement du capital', true, 
 (SELECT id FROM procedures WHERE nom = 'Création de Société par Actions Simplifiée (SAS)' LIMIT 1)),

('Justificatif de domiciliation', 'Un justificatif de la domiciliation de la société (contrat de bail, facture récente, ou attestation)', true, 
 (SELECT id FROM procedures WHERE nom = 'Création de Société par Actions Simplifiée (SAS)' LIMIT 1));

-- ============================================
-- 3.122. COÛTS DE LA PROCÉDURE CRÉATION DE SOCIÉTÉ PAR ACTIONS SIMPLIFIÉE (SAS)
-- ============================================

-- Insertion des coûts
INSERT INTO couts (nom, prix, description) VALUES
('Frais de création SAS', 0, 'Frais variables selon l''API-Mali - Frais de création pour Société par Actions Simplifiée (SAS)'),
('Capital social', 0, 'Aucun capital minimum requis - Avantage majeur de la SAS'),
('Assistance professionnelle', 0, 'Recommandée - Assistance d''un avocat ou notaire pour la rédaction des statuts');

-- Association du coût principal à la procédure
UPDATE procedures 
SET cout_id = (SELECT id FROM couts WHERE nom = 'Frais de création SAS' LIMIT 1)
WHERE nom = 'Création de Société par Actions Simplifiée (SAS)';

-- ============================================
-- 3.123. ASSOCIATION DU CENTRE POUR CRÉATION DE SOCIÉTÉ PAR ACTIONS SIMPLIFIÉE (SAS)
-- ============================================

-- Association du centre existant à la procédure
UPDATE procedures 
SET centre_id = (SELECT id FROM centres WHERE nom = 'API Mali - Guichet unique' LIMIT 1)
WHERE nom = 'Création de Société par Actions Simplifiée (SAS)';

-- ============================================
-- 3.124. PROCÉDURE: CRÉATION DE SOCIÉTÉ EN COMMANDITE SIMPLE (SCS)
-- ============================================

-- Insertion de la procédure
INSERT INTO procedures (nom, titre, delai, description, categorie_id, sous_categorie_id, date_creation) VALUES
('Création de Société en Commandite Simple (SCS)', 'Créer une Société en Commandite Simple (SCS)', 'Variable selon la complexité du dossier', 
 'Forme sociale : Société en Commandite Simple (SCS). Particularité : Distinction entre associés commandités (gérants) et commanditaires (investisseurs). Capital : Aucun capital minimum exigé. Durée : Maximum 99 ans. Enregistrement : Centre de Gestion Intégrée (CGI) ou RCCM. Associés commandités : Gèrent la société, qualité de commerçant requise. Associés commanditaires : Investisseurs, responsabilité limitée. Notaire obligatoire : Contrairement à d''autres formes. Publication obligatoire : Journal Officiel du Mali.',
 (SELECT id FROM categories WHERE titre = 'Création d''entreprise' LIMIT 1),
 (SELECT id FROM sous_categories WHERE titre = 'Sociétés en Commandite Simple (SCS)' LIMIT 1),
 NOW());

-- ============================================
-- 3.125. ÉTAPES DE LA PROCÉDURE CRÉATION DE SOCIÉTÉ EN COMMANDITE SIMPLE (SCS)
-- ============================================

INSERT INTO etapes (nom, description, niveau, procedure_id) VALUES
-- Étape 1: Rédaction des statuts
('Rédaction des statuts', 'Rédaction des statuts avec informations obligatoires détaillées : forme sociale (SCS), dénomination sociale (avec noms des commandités), siège social, objet social, capital social et évaluation des apports, liste des associés et répartition des parts, désignation des gérants, durée de la société, date de clôture de l''exercice.', 1,
 (SELECT id FROM procedures WHERE nom = 'Création de Société en Commandite Simple (SCS)' LIMIT 1)),

-- Étape 2: Publication de l'avis de constitution
('Publication de l''avis de constitution', 'Publication de l''avis de constitution dans un support d''annonces légales du département avec les informations essentielles de la société.', 2,
 (SELECT id FROM procedures WHERE nom = 'Création de Société en Commandite Simple (SCS)' LIMIT 1)),

-- Étape 3: Enregistrement de la société
('Enregistrement de la société', 'Dépôt du dossier complet au Centre de Gestion Intégrée (CGI) ou RCCM avec tous les documents requis pour l''immatriculation.', 3,
 (SELECT id FROM procedures WHERE nom = 'Création de Société en Commandite Simple (SCS)' LIMIT 1));

-- ============================================
-- 3.126. DOCUMENTS REQUIS POUR CRÉATION DE SOCIÉTÉ EN COMMANDITE SIMPLE (SCS)
-- ============================================

INSERT INTO documents_requis (nom, description, est_obligatoire, procedure_id) VALUES
-- A. Statuts de la société
('Statuts de la société', 'Statuts complets avec forme sociale (SCS), dénomination sociale (avec noms des commandités), siège social, objet social, capital social et évaluation des apports, liste des associés et répartition des parts, désignation des gérants, durée de la société, date de clôture de l''exercice', 
 (SELECT id FROM procedures WHERE nom = 'Création de Société en Commandite Simple (SCS)' LIMIT 1)),

-- B. Documents d'enregistrement
('Statuts signés', 'Statuts signés par tous les associés', 
 (SELECT id FROM procedures WHERE nom = 'Création de Société en Commandite Simple (SCS)' LIMIT 1)),

('Avis de constitution publié', 'Avis de constitution publié dans le support d''annonces légales', 
 (SELECT id FROM procedures WHERE nom = 'Création de Société en Commandite Simple (SCS)' LIMIT 1)),

('Copies des pièces d''identité des associés', 'Copies des pièces d''identité de tous les associés (commandités et commanditaires)', 
 (SELECT id FROM procedures WHERE nom = 'Création de Société en Commandite Simple (SCS)' LIMIT 1)),

('Justificatifs de qualité de commerçant', 'Justificatifs de qualité de commerçant pour les associés commandités', 
 (SELECT id FROM procedures WHERE nom = 'Création de Société en Commandite Simple (SCS)' LIMIT 1)),

-- C. Publication légale
('Avis de constitution dans support d''annonces légales', 'Avis de constitution publié dans un support d''annonces légales du département', 
 (SELECT id FROM procedures WHERE nom = 'Création de Société en Commandite Simple (SCS)' LIMIT 1)),

('Publication au Journal Officiel du Mali', 'Publication de l''annonce de constitution au Journal Officiel du Mali', 
 (SELECT id FROM procedures WHERE nom = 'Création de Société en Commandite Simple (SCS)' LIMIT 1));

-- ============================================
-- 3.127. COÛTS DE LA PROCÉDURE CRÉATION DE SOCIÉTÉ EN COMMANDITE SIMPLE (SCS)
-- ============================================

-- Insertion des coûts
INSERT INTO couts (nom, prix, description) VALUES
('Frais de notaire - SCS', 250000, 'Estimation totale : ~250,000 FCFA - Couvre : Rédaction statuts, enregistrement, timbres, publication - Obligatoire : Intervention notaire requise pour SCS'),
('Timbres légaux - SCS', 9750, 'Timbres légaux : ~9,750 FCFA - Couvre : Enregistrement statuts et immatriculation RCCM'),
('Journal Officiel - SCS', 38000, 'Journal Officiel : Variable selon longueur annonce - Souscription annuelle : ~38,000 FCFA'),
('Coût total estimé - SCS', 250000, 'Coût total estimé avec notaire : ~250,000 FCFA - Détail : Notaire + timbres + publication');

-- Association du coût principal à la procédure
UPDATE procedures 
SET cout_id = (SELECT id FROM couts WHERE nom = 'Coût total estimé - SCS' LIMIT 1)
WHERE nom = 'Création de Société en Commandite Simple (SCS)';

-- ============================================
-- 3.128. CENTRES POUR CRÉATION DE SOCIÉTÉ EN COMMANDITE SIMPLE (SCS)
-- ============================================

-- Ajout des centres spécifiques pour SCS
INSERT INTO centres (nom, adresse, horaires, telephone, email, date_creation) VALUES
('Centre de Gestion Intégrée (CGI)', 'Bamako', 'Lundi-Vendredi: 8h-16h', 'Contactez le CGI', 'cgi@mali.ml', NOW()),
('Registre du Commerce et du Crédit Mobilier (RCCM)', 'Bamako', 'Lundi-Vendredi: 8h-16h', 'Contactez le RCCM', 'rccm@mali.ml', NOW()),
('Guichet Unique API-Mali', 'Bamako', 'Lundi-Vendredi: 8h-16h', 'Contactez API-Mali', 'api@mali.ml', NOW());

-- Association du centre principal à la procédure
UPDATE procedures 
SET centre_id = (SELECT id FROM centres WHERE nom = 'Centre de Gestion Intégrée (CGI)' LIMIT 1)
WHERE nom = 'Création de Société en Commandite Simple (SCS)';

-- ============================================
-- 3.129. PROCÉDURE: TRANSFERT DE PARCELLE À USAGE D'HABITATION
-- ============================================

-- Insertion de la procédure
INSERT INTO procedures (nom, titre, delai, description, categorie_id, sous_categorie_id, date_creation) VALUES
('Transfert de parcelle à usage d''habitation', 'Transférer une parcelle à usage d''habitation', 'Variable selon la complexité du dossier', 
 'Pour transférer une parcelle à usage d''habitation au Mali, il faut rédiger un acte de vente notarié et enregistrer la mutation au Bureau des Domaines. Le processus implique des documents comme le titre foncier ou l''Arrêté de Concession Définitive (ACD) du propriétaire actuel, ainsi qu''une demande écrite du nouvel acquéreur, des preuves de propriété, et le paiement des frais correspondants à la mutation. Le transfert de propriété doit obligatoirement passer par un notaire et l''acte de vente doit être enregistré auprès des services compétents des impôts et domaines du Mali.',
 (SELECT id FROM categories WHERE titre = 'Service fonciers' LIMIT 1),
 (SELECT id FROM sous_categories WHERE titre = 'Lettre de transfert de parcelle à usage d''habitation' LIMIT 1),
 NOW());

-- ============================================
-- 3.130. ÉTAPES DE LA PROCÉDURE TRANSFERT DE PARCELLE À USAGE D'HABITATION
-- ============================================

INSERT INTO etapes (nom, description, niveau, procedure_id) VALUES
-- Étape 1: Rédiger l'acte de vente
('Rédiger l''acte de vente', 'Contactez un notaire : Le transfert de propriété doit obligatoirement passer par un notaire. Fournissez les documents : Le notaire aura besoin de l''acte de propriété original (titre foncier ou ACD), des pièces d''identité des deux parties, et d''un extrait de cadastre si disponible. Rédigez l''acte de vente : Il s''agira d''un acte authentique qui formalise la cession de la parcelle.', 1,
 (SELECT id FROM procedures WHERE nom = 'Transfert de parcelle à usage d''habitation' LIMIT 1)),

-- Étape 2: Enregistrer la mutation
('Enregistrer la mutation', 'Enregistrement fiscal : L''acte de vente doit être enregistré auprès des services compétents des impôts et domaines du Mali. Le coût de cette démarche est à la charge de l''acquéreur. Demande de transfert : Le nouvel acquéreur doit faire une demande écrite de transfert auprès du notaire choisi.', 2,
 (SELECT id FROM procedures WHERE nom = 'Transfert de parcelle à usage d''habitation' LIMIT 1));

-- ============================================
-- 3.131. DOCUMENTS REQUIS POUR TRANSFERT DE PARCELLE À USAGE D'HABITATION
-- ============================================

INSERT INTO documents_requis (nom, description, est_obligatoire, procedure_id) VALUES
('Original de la preuve de propriété', 'Le titre foncier ou l''Arrêté de Concession Définitive (ACD) de la parcelle', 
 (SELECT id FROM procedures WHERE nom = 'Transfert de parcelle à usage d''habitation' LIMIT 1)),

('Pièces d''identité des deux parties', 'Copies des pièces d''identité des deux parties (vendeur et acquéreur)', 
 (SELECT id FROM procedures WHERE nom = 'Transfert de parcelle à usage d''habitation' LIMIT 1)),

('Demande écrite de transfert', 'Une demande formelle de transfert rédigée par l''acquéreur', 
 (SELECT id FROM procedures WHERE nom = 'Transfert de parcelle à usage d''habitation' LIMIT 1)),

('Extrait du cadastre', 'Si disponible, pour identifier précisément la parcelle', 
 (SELECT id FROM procedures WHERE nom = 'Transfert de parcelle à usage d''habitation' LIMIT 1)),

('Preuve de paiement', 'Une preuve du paiement des impôts et des frais de mutation', 
 (SELECT id FROM procedures WHERE nom = 'Transfert de parcelle à usage d''habitation' LIMIT 1));

-- ============================================
-- 3.132. COÛTS DE LA PROCÉDURE TRANSFERT DE PARCELLE À USAGE D'HABITATION
-- ============================================

-- Insertion des coûts
INSERT INTO couts (nom, prix, description) VALUES
('Frais de notaire - Transfert parcelle', 0, 'Frais variables selon le notaire - Rédaction de l''acte de vente notarié obligatoire'),
('Enregistrement fiscal - Transfert parcelle', 0, 'Frais d''enregistrement auprès des services des impôts et domaines - À la charge de l''acquéreur'),
('Frais de mutation - Transfert parcelle', 0, 'Frais de mutation correspondants au transfert de propriété'),
('Coût total estimé - Transfert parcelle', 0, 'Coût total variable selon la valeur de la parcelle et les frais de notaire');

-- Association du coût principal à la procédure
UPDATE procedures 
SET cout_id = (SELECT id FROM couts WHERE nom = 'Coût total estimé - Transfert parcelle' LIMIT 1)
WHERE nom = 'Transfert de parcelle à usage d''habitation';

-- ============================================
-- 3.133. CENTRES POUR TRANSFERT DE PARCELLE À USAGE D'HABITATION
-- ============================================

-- Ajout des centres spécifiques pour transfert de parcelle
INSERT INTO centres (nom, adresse, horaires, telephone, email, date_creation) VALUES
('Bureau des Domaines', 'Bamako', 'Lundi-Vendredi: 8h-16h', 'Contactez le Bureau des Domaines', 'domaines@mali.ml', NOW()),
('Services des Impôts et Domaines', 'Bamako', 'Lundi-Vendredi: 8h-16h', 'Contactez les Services des Impôts', 'impots@mali.ml', NOW()),
('Notaires du Mali', 'Bamako', 'Lundi-Vendredi: 8h-16h', 'Contactez l''Ordre des Notaires', 'notaires@mali.ml', NOW());

-- Association du centre principal à la procédure
UPDATE procedures 
SET centre_id = (SELECT id FROM centres WHERE nom = 'Bureau des Domaines' LIMIT 1)
WHERE nom = 'Transfert de parcelle à usage d''habitation';

-- ============================================
-- 3.134. ARTICLES DE LOI POUR TRANSFERT DE PARCELLE À USAGE D'HABITATION
-- ============================================

INSERT INTO lois_articles (description, consulter_article, procedure_id) VALUES
-- Ordonnance n°2020-014/P-RM du 24 décembre 2020
('Ordonnance n°2020-014/P-RM du 24 décembre 2020', 
 'Ordonnance n°2020-014/P-RM du 24 décembre 2020. Cette ordonnance est venue modifier et compléter l''Ordonnance n°00-027/P-RM du 22 mars 2000 portant Code Domanial et Foncier. Elle constitue la version la plus récente qui régit la matière du transfert de parcelles au Mali.',
 (SELECT id FROM procedures WHERE nom = 'Transfert de parcelle à usage d''habitation' LIMIT 1)),

-- Articles 73 et 74 - Transmissibilité et cessibilité des droits fonciers
('Articles 73 et 74 du Code Domanial et Foncier', 
 'Articles 73 et 74 du Code Domanial et Foncier. Ces articles régissent la question de la transmissibilité et la cessibilité des droits fonciers. Ils distinguent les droits coutumiers impliquant une emprise évidente et permanente sur le sol, qui peuvent être concédés ou transformés en droits de propriété, des autres droits coutumiers qui ne peuvent être transférés qu''entre personnes ou collectivités ayant les mêmes droits.',
 (SELECT id FROM procedures WHERE nom = 'Transfert de parcelle à usage d''habitation' LIMIT 1)),

-- Article 101 - Publicité des droits réels immobiliers
('Article 101 du Code Domanial et Foncier', 
 'Article 101 du Code Domanial et Foncier. Cet article précise que les droits réels immobiliers (comme la propriété) ne sont opposables aux tiers qu''après avoir été rendus publics, notamment par l''enregistrement des actes chez le conservateur foncier.',
 (SELECT id FROM procedures WHERE nom = 'Transfert de parcelle à usage d''habitation' LIMIT 1)),

-- Article 32 - Domaine privé immobilier de l'État
('Article 32 du Code Domanial et Foncier', 
 'Article 32 du Code Domanial et Foncier. L''État dispose de son domaine privé immobilier comme tout propriétaire.',
 (SELECT id FROM procedures WHERE nom = 'Transfert de parcelle à usage d''habitation' LIMIT 1)),

-- Décret n°2019-0113/P-RM du 22 février 2019
('Décret n°2019-0113/P-RM du 22 février 2019', 
 'Décret n°2019-0113/P-RM du 22 février 2019. Ce décret fixe les prix de cession et les redevances des terrains urbains et ruraux du domaine privé immobilier de l''État. Il est une référence pour les transactions impliquant des parcelles du domaine privé de l''État.',
 (SELECT id FROM procedures WHERE nom = 'Transfert de parcelle à usage d''habitation' LIMIT 1)),

-- Loi n°2017-01 du 11 avril 2017 - Foncier agricole
('Loi n°2017-01 du 11 avril 2017', 
 'Loi n°2017-01 du 11 avril 2017. Cette loi porte sur le foncier agricole, mais ses articles 10 et 12 abordent également la transmissibilité et la cessibilité des droits fonciers.',
 (SELECT id FROM procedures WHERE nom = 'Transfert de parcelle à usage d''habitation' LIMIT 1));

-- ============================================
-- 3.135. PROCÉDURE: PERMIS DE CONSTRUIRE À USAGE INDUSTRIEL
-- ============================================

-- Insertion de la procédure
INSERT INTO procedures (nom, titre, delai, description, categorie_id, sous_categorie_id, date_creation) VALUES
('Permis de construire à usage industriel', 'Obtenir un permis de construire à usage industriel', '15 jours après réception du dossier complet', 
 'Pour obtenir un permis de construire à usage industriel au Mali, il faut déposer un dossier complet auprès des services compétents, comprenant des pièces justificatives de propriété ou d''usage du terrain, une copie de pièce d''identité et un dossier technique en plusieurs exemplaires. Ce dossier technique doit inclure plusieurs plans (situation, masse, coupes, façades) et un devis descriptif détaillé, conformément à la réglementation. Le dossier est instruit par les services de l''urbanisme et de la construction. L''autorité compétente pour délivrer le permis est généralement le maire ou l''autorité administrative compétente. Pour les constructions de grande envergure, un « Accord Préalable » est souvent requis avant le permis de construire. Le permis de construire est valable pour une durée d''un an à compter de sa date de signature.',
 (SELECT id FROM categories WHERE titre = 'Service fonciers' LIMIT 1),
 (SELECT id FROM sous_categories WHERE titre = 'Permis de construire (à usage industriel, à usage personnelle)' LIMIT 1),
 NOW());

-- ============================================
-- 3.136. ÉTAPES DE LA PROCÉDURE PERMIS DE CONSTRUIRE À USAGE INDUSTRIEL
-- ============================================

INSERT INTO etapes (nom, description, niveau, procedure_id) VALUES
-- Étape 1: Préparation du dossier technique
('Préparation du dossier technique', 'Préparer le dossier technique en au moins cinq exemplaires comprenant : Plan de situation de la parcelle (échelle minimale 1/2000ème), Plan de masse (échelle 1/500ème au moins), Vues en plan, façades et coupes (échelles 1/50ème ou 1/100ème selon la taille de la construction), Plan des ouvrages sanitaires (échelle 1/50ème), Devis descriptif détaillé.', 1,
 (SELECT id FROM procedures WHERE nom = 'Permis de construire à usage industriel' LIMIT 1)),

-- Étape 2: Accord Préalable (si nécessaire)
('Accord Préalable (si nécessaire)', 'Pour les constructions de grande envergure, un « Accord Préalable » est souvent requis avant le permis de construire. Cet accord est accordé par l''autorité administrative compétente et est nécessaire pour les projets d''intérêt général, les constructions de plus de 500m² de surface de plancher ou celles recevant du public.', 2,
 (SELECT id FROM procedures WHERE nom = 'Permis de construire à usage industriel' LIMIT 1)),

-- Étape 3: Dépôt du dossier complet
('Dépôt du dossier complet', 'Déposer le dossier complet auprès des services de l''urbanisme et de la construction avec toutes les pièces justificatives : titre de propriété ou document justifiant le droit d''usage du terrain, copie de la pièce d''identité en cours de validité, dossier technique en au moins cinq exemplaires.', 3,
 (SELECT id FROM procedures WHERE nom = 'Permis de construire à usage industriel' LIMIT 1)),

-- Étape 4: Instruction du dossier
('Instruction du dossier', 'Le dossier est instruit par les services de l''urbanisme et de la construction. L''instruction de la demande doit généralement aboutir à une décision dans un délai de 15 jours après réception du dossier complet.', 4,
 (SELECT id FROM procedures WHERE nom = 'Permis de construire à usage industriel' LIMIT 1)),

-- Étape 5: Délivrance du permis
('Délivrance du permis', 'L''autorité compétente pour délivrer le permis est généralement le maire ou l''autorité administrative compétente. Le permis de construire est valable pour une durée d''un an à compter de sa date de signature.', 5,
 (SELECT id FROM procedures WHERE nom = 'Permis de construire à usage industriel' LIMIT 1));

-- ============================================
-- 3.137. DOCUMENTS REQUIS POUR PERMIS DE CONSTRUIRE À USAGE INDUSTRIEL
-- ============================================

INSERT INTO documents_requis (nom, description, est_obligatoire, procedure_id) VALUES
-- Documents communs pour tout type de permis de construire
('Demande adressée au maire de la commune', 'Une demande adressée au maire de la commune', 
 (SELECT id FROM procedures WHERE nom = 'Permis de construire à usage industriel' LIMIT 1)),

('Plan de situation du terrain', 'Le plan de situation du terrain, permettant de le localiser précisément (échelle minimale 1/2000ème)', 
 (SELECT id FROM procedures WHERE nom = 'Permis de construire à usage industriel' LIMIT 1)),

('Titre de propriété du terrain', 'Le titre de propriété du terrain (titre foncier, permis d''occuper, etc.)', 
 (SELECT id FROM procedures WHERE nom = 'Permis de construire à usage industriel' LIMIT 1)),

('Lévé topographique du terrain', 'Un levé topographique du terrain', 
 (SELECT id FROM procedures WHERE nom = 'Permis de construire à usage industriel' LIMIT 1)),

('Plans d''architecte et d''ingénieur', 'Les plans d''architecte et d''ingénieur (plans de masse, façades, coupes, etc.)', 
 (SELECT id FROM procedures WHERE nom = 'Permis de construire à usage industriel' LIMIT 1)),

('Devis estimatif des travaux', 'Le devis estimatif des travaux', 
 (SELECT id FROM procedures WHERE nom = 'Permis de construire à usage industriel' LIMIT 1)),

('Étude de l''impact environnemental et social', 'Une étude de l''impact environnemental et social (obligatoire pour les projets industriels)', 
 (SELECT id FROM procedures WHERE nom = 'Permis de construire à usage industriel' LIMIT 1)),

('Copies des pièces d''identité du demandeur', 'Les copies des pièces d''identité du demandeur', 
 (SELECT id FROM procedures WHERE nom = 'Permis de construire à usage industriel' LIMIT 1)),

('Pièces justificatives du paiement des droits et taxes', 'Les pièces justificatives du paiement des droits et taxes associés', 
 (SELECT id FROM procedures WHERE nom = 'Permis de construire à usage industriel' LIMIT 1)),

('Quitus fiscal en cours de validité', 'Le quitus fiscal en cours de validité', 
 (SELECT id FROM procedures WHERE nom = 'Permis de construire à usage industriel' LIMIT 1)),

-- Documents spécifiques à usage industriel
('Plan de masse industriel', 'Le plan de masse, indiquant la disposition des bâtiments industriels, des accès et des aires de stationnement (échelle 1/500ème au moins)', 
 (SELECT id FROM procedures WHERE nom = 'Permis de construire à usage industriel' LIMIT 1)),

('Plans détaillés des installations techniques', 'Les plans détaillés des installations techniques, comme les systèmes de ventilation, de plomberie et d''électricité', 
 (SELECT id FROM procedures WHERE nom = 'Permis de construire à usage industriel' LIMIT 1)),

('Plan des façades et des toitures industriels', 'Le plan des façades et des toitures, qui doivent respecter les normes de sécurité et de protection de l''environnement', 
 (SELECT id FROM procedures WHERE nom = 'Permis de construire à usage industriel' LIMIT 1)),

('Description détaillée du terrain et de l''activité', 'Une description détaillée du terrain et de la nature de l''activité, incluant les risques potentiels (pollution, bruits, etc.)', 
 (SELECT id FROM procedures WHERE nom = 'Permis de construire à usage industriel' LIMIT 1)),

('Autorisation d''exploitation', 'L''autorisation d''exploitation, délivrée par les autorités compétentes', 
 (SELECT id FROM procedures WHERE nom = 'Permis de construire à usage industriel' LIMIT 1));

-- ============================================
-- 3.138. COÛTS DE LA PROCÉDURE PERMIS DE CONSTRUIRE À USAGE INDUSTRIEL
-- ============================================

-- Insertion des coûts
INSERT INTO couts (nom, prix, description) VALUES
('Frais d''acquisition du terrain - Permis industriel', 0, 'Si l''acquisition d''un terrain est nécessaire, le coût varie. Pour les zones économiques spéciales (ZES), il s''agit généralement d''un loyer annuel plutôt que d''un prix d''achat, avec des frais qui dépendent de la localisation'),
('Frais d''étude et de préparation - Permis industriel', 0, 'Inclut les coûts liés aux études d''impact environnemental (EIE), obligatoires pour les projets industriels. Ces études sont généralement menées par des consultants externes et peuvent coûter des dizaines de milliers de dollars'),
('Frais administratifs - Permis industriel', 0, 'Ces frais concernent le traitement du dossier de demande de permis auprès des services de la mairie et de l''urbanisme'),
('Frais de raccordement aux services publics - Permis industriel', 0, 'Le raccordement à l''eau, à l''électricité et aux services de télécommunication engendre des coûts supplémentaires'),
('Coût total estimé - Permis industriel', 0, 'Coût total variable selon le projet et sa localisation - Inclut acquisition terrain, études, frais administratifs et raccordements');

-- Association du coût principal à la procédure
UPDATE procedures 
SET cout_id = (SELECT id FROM couts WHERE nom = 'Coût total estimé - Permis industriel' LIMIT 1)
WHERE nom = 'Permis de construire à usage industriel';

-- ============================================
-- 3.139. CENTRES POUR PERMIS DE CONSTRUIRE À USAGE INDUSTRIEL
-- ============================================

-- Ajout des centres spécifiques pour permis de construire industriel
INSERT INTO centres (nom, adresse, horaires, telephone, email, date_creation) VALUES
('Services de l''Urbanisme et de la Construction', 'Bamako', 'Lundi-Vendredi: 8h-16h', 'Contactez les Services d''Urbanisme', 'urbanisme@mali.ml', NOW()),
('Autorité Administrative Compétente', 'Bamako', 'Lundi-Vendredi: 8h-16h', 'Contactez l''Autorité Administrative', 'admin@mali.ml', NOW()),
('Mairie - Service Urbanisme', 'Bamako', 'Lundi-Vendredi: 8h-16h', 'Contactez la Mairie', 'mairie.urbanisme@bamako.ml', NOW());

-- Association du centre principal à la procédure
UPDATE procedures 
SET centre_id = (SELECT id FROM centres WHERE nom = 'Services de l''Urbanisme et de la Construction' LIMIT 1)
WHERE nom = 'Permis de construire à usage industriel';

-- ============================================
-- 3.140. ARTICLES DE LOI POUR PERMIS DE CONSTRUIRE À USAGE INDUSTRIEL
-- ============================================

INSERT INTO lois_articles (description, consulter_article, procedure_id) VALUES
-- Loi n° 90-033 du 9 août 1990
('Loi n° 90-033 du 9 août 1990', 
 'Loi n° 90-033 du 9 août 1990 fixant le Code de l''urbanisme et de la construction. Ce texte encadre les procédures de délivrance des permis de construire au Mali.',
 (SELECT id FROM procedures WHERE nom = 'Permis de construire à usage industriel' LIMIT 1)),

-- Loi n°02-016 du 03 juin 2002
('Loi n°02-016 du 03 juin 2002', 
 'Loi n°02-016 du 03 juin 2002. Ce texte fixe les règles générales de l''urbanisme au Mali.',
 (SELECT id FROM procedures WHERE nom = 'Permis de construire à usage industriel' LIMIT 1)),

-- Ordonnance n° 2020-014/PT-RM du 24 décembre 2020
('Ordonnance n° 2020-014/PT-RM du 24 décembre 2020', 
 'Ordonnance n° 2020-014/PT-RM, modifiée, du 24 décembre 2020 portant loi domaniale et foncière, qui encadre l''attribution des titres de propriété.',
 (SELECT id FROM procedures WHERE nom = 'Permis de construire à usage industriel' LIMIT 1)),

-- Décret n°2019-0113 du 22 février 2019
('Décret n°2019-0113 du 22 février 2019', 
 'Décret n°2019-0113 du 22 février 2019. Ce décret est primordial car il fixe les prix de cession et les redevances pour les terrains du domaine privé de l''État à usage commercial, industriel et autres.',
 (SELECT id FROM procedures WHERE nom = 'Permis de construire à usage industriel' LIMIT 1)),

-- Loi n°91-47/AN-RM - Protection de l'environnement
('Loi n°91-47/AN-RM', 
 'Loi n°91-47/AN-RM. Les projets industriels sont soumis à une étude d''impact environnemental (EIE) obligatoire, en vertu des lois maliennes sur la protection de l''environnement.',
 (SELECT id FROM procedures WHERE nom = 'Permis de construire à usage industriel' LIMIT 1)),

-- Réformes récentes - Système informatisé
('Réformes récentes - Système informatisé', 
 'Réformes récentes visant à faciliter les procédures de construction, notamment la mise en place d''un système de gestion informatisé du permis de construire à Bamako.',
 (SELECT id FROM procedures WHERE nom = 'Permis de construire à usage industriel' LIMIT 1));

-- ============================================
-- 3.141. PROCÉDURE: PERMIS DE CONSTRUIRE À USAGE PERSONNEL
-- ============================================

-- Insertion de la procédure
INSERT INTO procedures (nom, titre, delai, description, categorie_id, sous_categorie_id, date_creation) VALUES
('Permis de construire à usage personnel', 'Obtenir un permis de construire à usage personnel', '2 mois après réception du dossier complet', 
 'Pour obtenir un permis de construire à usage personnel au Mali, il est nécessaire de suivre une procédure impliquant plusieurs étapes, la soumission de documents spécifiques, et le respect d''une législation encadrant l''urbanisme et l''habitat. Le demandeur dépose le dossier complet au service de l''urbanisme de la commune concernée ou à la Direction nationale de l''Urbanisme et de l''Habitat (DNAT) pour le district de Bamako. L''administration vérifie si le projet est conforme aux règles d''urbanisme en vigueur. Le délai d''instruction pour une maison individuelle est d''environ deux mois, à compter de la réception d''un dossier complet. Le permis est délivré par arrêté si le dossier est conforme. Une fois le permis obtenu, son affichage sur le chantier est obligatoire pour informer le public et faire courir le délai de recours des tiers.',
 (SELECT id FROM categories WHERE titre = 'Service fonciers' LIMIT 1),
 (SELECT id FROM sous_categories WHERE titre = 'Permis de construire (à usage industriel, à usage personnelle)' LIMIT 1),
 NOW());

-- ============================================
-- 3.142. ÉTAPES DE LA PROCÉDURE PERMIS DE CONSTRUIRE À USAGE PERSONNEL
-- ============================================

INSERT INTO etapes (nom, description, niveau, procedure_id) VALUES
-- Étape 1: Dépôt du dossier
('Dépôt du dossier', 'Le demandeur dépose le dossier complet au service de l''urbanisme de la commune concernée ou à la Direction nationale de l''Urbanisme et de l''Habitat (DNAT) pour le district de Bamako. En région, le dépôt se fait au niveau de la direction régionale de l''urbanisme et de l''habitat, ainsi qu''à la mairie locale.', 1,
 (SELECT id FROM procedures WHERE nom = 'Permis de construire à usage personnel' LIMIT 1)),

-- Étape 2: Instruction du dossier
('Instruction du dossier', 'L''administration vérifie si le projet est conforme aux règles d''urbanisme en vigueur. Le délai d''instruction pour une maison individuelle est d''environ deux mois, à compter de la réception d''un dossier complet.', 2,
 (SELECT id FROM procedures WHERE nom = 'Permis de construire à usage personnel' LIMIT 1)),

-- Étape 3: Délivrance ou rejet
('Délivrance ou rejet', 'Le permis est délivré par arrêté si le dossier est conforme. Dans le cas contraire, un rejet est notifié. Une commission de recours existe pour traiter les litiges.', 3,
 (SELECT id FROM procedures WHERE nom = 'Permis de construire à usage personnel' LIMIT 1)),

-- Étape 4: Affichage sur le terrain
('Affichage sur le terrain', 'Une fois le permis obtenu, son affichage sur le chantier est obligatoire pour informer le public et faire courir le délai de recours des tiers.', 4,
 (SELECT id FROM procedures WHERE nom = 'Permis de construire à usage personnel' LIMIT 1));

-- ============================================
-- 3.143. DOCUMENTS REQUIS POUR PERMIS DE CONSTRUIRE À USAGE PERSONNEL
-- ============================================

INSERT INTO documents_requis (nom, description, est_obligatoire, procedure_id) VALUES
-- Documents communs pour tout type de permis de construire
('Demande adressée au maire de la commune', 'Une demande adressée au maire de la commune', 
 (SELECT id FROM procedures WHERE nom = 'Permis de construire à usage personnel' LIMIT 1)),

('Plan de situation du terrain', 'Le plan de situation du terrain, permettant de le localiser précisément', 
 (SELECT id FROM procedures WHERE nom = 'Permis de construire à usage personnel' LIMIT 1)),

('Titre de propriété du terrain', 'Le titre de propriété du terrain (titre foncier, permis d''occuper, etc.)', 
 (SELECT id FROM procedures WHERE nom = 'Permis de construire à usage personnel' LIMIT 1)),

('Lévé topographique du terrain', 'Un levé topographique du terrain', 
 (SELECT id FROM procedures WHERE nom = 'Permis de construire à usage personnel' LIMIT 1)),

('Plans d''architecte et d''ingénieur', 'Les plans d''architecte et d''ingénieur (plans de masse, façades, coupes, etc.)', 
 (SELECT id FROM procedures WHERE nom = 'Permis de construire à usage personnel' LIMIT 1)),

('Devis estimatif des travaux', 'Le devis estimatif des travaux', 
 (SELECT id FROM procedures WHERE nom = 'Permis de construire à usage personnel' LIMIT 1)),

('Étude de l''impact environnemental et social', 'Une étude de l''impact environnemental et social (selon la nature et l''ampleur du projet)', 
 (SELECT id FROM procedures WHERE nom = 'Permis de construire à usage personnel' LIMIT 1)),

('Copies des pièces d''identité du demandeur', 'Les copies des pièces d''identité du demandeur', 
 (SELECT id FROM procedures WHERE nom = 'Permis de construire à usage personnel' LIMIT 1)),

('Pièces justificatives du paiement des droits et taxes', 'Les pièces justificatives du paiement des droits et taxes associés', 
 (SELECT id FROM procedures WHERE nom = 'Permis de construire à usage personnel' LIMIT 1)),

('Quitus fiscal en cours de validité', 'Le quitus fiscal en cours de validité', 
 (SELECT id FROM procedures WHERE nom = 'Permis de construire à usage personnel' LIMIT 1)),

-- Documents spécifiques à usage personnel
('Plan de masse personnel', 'Le plan de masse, montrant la disposition des bâtiments sur le terrain', 
 (SELECT id FROM procedures WHERE nom = 'Permis de construire à usage personnel' LIMIT 1)),

('Plans des façades et des toitures', 'Les plans des façades et des toitures', 
 (SELECT id FROM procedures WHERE nom = 'Permis de construire à usage personnel' LIMIT 1)),

('Plans en coupe', 'Les plans en coupe, qui donnent une vue en coupe de la construction', 
 (SELECT id FROM procedures WHERE nom = 'Permis de construire à usage personnel' LIMIT 1));

-- ============================================
-- 3.144. COÛTS DE LA PROCÉDURE PERMIS DE CONSTRUIRE À USAGE PERSONNEL
-- ============================================

-- Insertion des coûts
INSERT INTO couts (nom, prix, description) VALUES
('Frais de demande de permis - Usage personnel', 0, 'Frais de demande de permis de construire à usage personnel - Variables selon les réglementations locales et la surface du projet'),
('Frais d''architecte - Usage personnel', 0, 'Frais annexes liés aux services d''un architecte pour la signature des plans'),
('Frais d''études techniques - Usage personnel', 0, 'Frais d''études techniques (étude de sol, étude d''impact environnemental si nécessaire)'),
('Coût total estimé - Usage personnel', 0, 'Coût total variable selon la surface du projet et les frais annexes - Il est conseillé de contacter les services concernés pour obtenir le tarif précis');

-- Association du coût principal à la procédure
UPDATE procedures 
SET cout_id = (SELECT id FROM couts WHERE nom = 'Coût total estimé - Usage personnel' LIMIT 1)
WHERE nom = 'Permis de construire à usage personnel';

-- ============================================
-- 3.145. CENTRES POUR PERMIS DE CONSTRUIRE À USAGE PERSONNEL
-- ============================================

-- Ajout des centres spécifiques pour permis de construire personnel
INSERT INTO centres (nom, adresse, horaires, telephone, email, date_creation) VALUES
('Direction Nationale de l''Urbanisme et de l''Habitat (DNAT)', 'Bamako', 'Lundi-Vendredi: 8h-16h', 'Contactez la DNAT', 'dnat@mali.ml', NOW()),
('Service de l''Urbanisme - Mairie', 'Bamako', 'Lundi-Vendredi: 8h-16h', 'Contactez la Mairie', 'mairie.urbanisme@bamako.ml', NOW()),
('Direction Régionale de l''Urbanisme et de l''Habitat', 'Régions', 'Lundi-Vendredi: 8h-16h', 'Contactez la Direction Régionale', 'urbanisme.region@mali.ml', NOW());

-- Association du centre principal à la procédure
UPDATE procedures 
SET centre_id = (SELECT id FROM centres WHERE nom = 'Direction Nationale de l''Urbanisme et de l''Habitat (DNAT)' LIMIT 1)
WHERE nom = 'Permis de construire à usage personnel';

-- ============================================
-- 3.146. ARTICLES DE LOI POUR PERMIS DE CONSTRUIRE À USAGE PERSONNEL
-- ============================================

INSERT INTO lois_articles (description, consulter_article, procedure_id) VALUES
-- Loi n° 90-033 du 9 août 1990
('Loi n° 90-033 du 9 août 1990', 
 'Loi n° 90-033 du 9 août 1990 fixant le Code de l''urbanisme et de la construction. Ce texte encadre les procédures de délivrance des permis de construire au Mali.',
 (SELECT id FROM procedures WHERE nom = 'Permis de construire à usage personnel' LIMIT 1)),

-- Loi n°02-016 du 03 juin 2002
('Loi n°02-016 du 03 juin 2002', 
 'Loi n°02-016 du 03 juin 2002. Cette loi fixe les règles générales de l''urbanisme au Mali.',
 (SELECT id FROM procedures WHERE nom = 'Permis de construire à usage personnel' LIMIT 1)),

-- Ordonnance n° 2020-014/PT-RM du 24 décembre 2020
('Ordonnance n° 2020-014/PT-RM du 24 décembre 2020', 
 'Ordonnance n° 2020-014/PT-RM, modifiée, du 24 décembre 2020 portant loi domaniale et foncière, qui encadre l''attribution des titres de propriété.',
 (SELECT id FROM procedures WHERE nom = 'Permis de construire à usage personnel' LIMIT 1)),

-- Décret n°115 du 09 mars 2005
('Décret n°115 du 09 mars 2005', 
 'Décret n°115 du 09 mars 2005. Ce décret fixe les modalités de réalisation des différents types d''opérations d''urbanisme.',
 (SELECT id FROM procedures WHERE nom = 'Permis de construire à usage personnel' LIMIT 1)),

-- Réformes récentes - Système informatisé
('Réformes récentes - Système informatisé', 
 'Réformes récentes visant à faciliter les procédures de construction, notamment la mise en place d''un système de gestion informatisé du permis de construire à Bamako.',
 (SELECT id FROM procedures WHERE nom = 'Permis de construire à usage personnel' LIMIT 1));

-- ============================================
-- 3.147. PROCÉDURE: TITRE FONCIER
-- ============================================

-- Insertion de la procédure
INSERT INTO procedures (nom, titre, delai, description, categorie_id, sous_categorie_id, date_creation) VALUES
('Titre foncier', 'Obtenir un titre foncier', '6 mois maximum', 
 'Un titre foncier au Mali est le document officiel qui prouve la propriété d''un terrain et offre une protection juridique complète. Pour l''obtenir, il faut généralement passer par une transformation de documents provisoires, comme un permis d''occuper, en remplissant un dossier auprès des autorités compétentes, comme la Direction nationale des domaines. Le titre foncier est définitif et inattaquable, unique et officiel, et offre une sécurité juridique complète. Il permet de sécuriser le bien et d''éviter les litiges. Chaque parcelle sur le territoire national est identifiée par un numéro d''identification national unique cadastral (NINACAD), attribué par le service du cadastre. Le délai de traitement au Mali est de 6 mois maximum. Ce délai est le temps maximal pour obtenir un titre foncier, une fois le dossier déposé et complet. Il est important de noter que ce délai peut varier en fonction des situations spécifiques, des éventuels litiges ou du rythme de traitement de l''administration.',
 (SELECT id FROM categories WHERE titre = 'Service fonciers' LIMIT 1),
 (SELECT id FROM sous_categories WHERE titre = 'Titre foncier' LIMIT 1),
 NOW());

-- ============================================
-- 3.148. ÉTAPES DE LA PROCÉDURE TITRE FONCIER
-- ============================================

INSERT INTO etapes (nom, description, niveau, procedure_id) VALUES
-- Étape 1: Rassemblement des documents
('Rassemblement des documents', 'Rassemblez les documents nécessaires : votre titre provisoire, une copie de votre pièce d''identité, des photos d''identité et un document de votre terrain enregistré en mairie. Assurez-vous que tous les documents sont complets et exacts avant de les déposer pour éviter tout retard.', 1,
 (SELECT id FROM procedures WHERE nom = 'Titre foncier' LIMIT 1)),

-- Étape 2: Rédaction de la demande
('Rédaction de la demande', 'Rédigez une demande officielle de transformation en titre foncier aux autorités compétentes. La demande doit être adressée aux services compétents avec toutes les pièces justificatives.', 2,
 (SELECT id FROM procedures WHERE nom = 'Titre foncier' LIMIT 1)),

-- Étape 3: Soumission du dossier
('Soumission du dossier', 'Soumettez le dossier complet auprès de la Direction Générale des Domaines et du Cadastre (DGDC) ou des directions régionales des Domaines et du Cadastre selon la situation géographique de la parcelle.', 3,
 (SELECT id FROM procedures WHERE nom = 'Titre foncier' LIMIT 1)),

-- Étape 4: Instruction et enquête
('Instruction et enquête', 'Le dossier est instruit par les services compétents. Une enquête de 30 jours (réduite de 60 jours par les réformes récentes) est menée pour vérifier l''authenticité des documents et la situation du terrain.', 4,
 (SELECT id FROM procedures WHERE nom = 'Titre foncier' LIMIT 1)),

-- Étape 5: Délivrance du titre foncier
('Délivrance du titre foncier', 'Après instruction favorable, le titre foncier définitif est délivré. Le délai de traitement au Mali est de 6 mois maximum. Ce délai est le temps maximal pour obtenir un titre foncier, une fois le dossier déposé et complet. Il est important de noter que ce délai peut varier en fonction des situations spécifiques, des éventuels litiges ou du rythme de traitement de l''administration.', 5,
 (SELECT id FROM procedures WHERE nom = 'Titre foncier' LIMIT 1));

-- ============================================
-- 3.149. DOCUMENTS REQUIS POUR TITRE FONCIER
-- ============================================

INSERT INTO documents_requis (nom, description, est_obligatoire, procedure_id) VALUES
('Titre provisoire', 'Votre titre provisoire (permis d''occuper, CUH, CRH, etc.)', 
 (SELECT id FROM procedures WHERE nom = 'Titre foncier' LIMIT 1)),

('Copie de la pièce d''identité', 'Une copie de votre pièce d''identité en cours de validité', 
 (SELECT id FROM procedures WHERE nom = 'Titre foncier' LIMIT 1)),

('Photos d''identité', 'Des photos d''identité récentes', 
 (SELECT id FROM procedures WHERE nom = 'Titre foncier' LIMIT 1)),

('Document de terrain enregistré en mairie', 'Un document de votre terrain enregistré en mairie', 
 (SELECT id FROM procedures WHERE nom = 'Titre foncier' LIMIT 1)),

('Procès-verbal d''attribution et délibération du conseil communal', 'Le procès-verbal d''attribution et la délibération du conseil communal, qui attestent de la cession du terrain par l''État', 
 (SELECT id FROM procedures WHERE nom = 'Titre foncier' LIMIT 1)),

('Lévé topographique ou plan de situation', 'Un levé topographique ou un plan de situation, réalisé par un géomètre assermenté', 
 (SELECT id FROM procedures WHERE nom = 'Titre foncier' LIMIT 1)),

('Numéro d''identification cadastrale (NINACAD)', 'Un numéro d''identification cadastrale (NINACAD), qui est désormais un prérequis pour chaque parcelle', 
 (SELECT id FROM procedures WHERE nom = 'Titre foncier' LIMIT 1)),

('Demande d''immatriculation', 'Une demande d''immatriculation adressée aux services compétents', 
 (SELECT id FROM procedures WHERE nom = 'Titre foncier' LIMIT 1)),

('Dossier administratif complet', 'Le dossier administratif complet comprenant les copies des pièces d''identité du demandeur', 
 (SELECT id FROM procedures WHERE nom = 'Titre foncier' LIMIT 1)),

('Pièces justifiant le paiement des droits et taxes', 'Les pièces justifiant le paiement des droits et taxes associés (enregistrement, mutation, timbres)', 
 (SELECT id FROM procedures WHERE nom = 'Titre foncier' LIMIT 1)),

('Quitus fiscal en cours de validité', 'Le quitus fiscal en cours de validité', 
 (SELECT id FROM procedures WHERE nom = 'Titre foncier' LIMIT 1));

-- ============================================
-- 3.150. COÛTS DE LA PROCÉDURE TITRE FONCIER
-- ============================================

-- Insertion des coûts
INSERT INTO couts (nom, prix, description) VALUES
('Droit d''enregistrement - Titre foncier', 0, 'Droit d''enregistrement de 15% du prix de la parcelle'),
('Droit de mutation - Titre foncier', 0, 'Droit de mutation de 0,9% du prix de la parcelle'),
('Frais de dossier - Titre foncier', 0, 'Frais de dossier déterminés par des taxes, incluant le droit d''enregistrement et le droit de mutation'),
('Réduction pour transformation - Titre foncier', 0, 'Des réductions peuvent s''appliquer si vous transformez un titre provisoire en titre foncier'),
('Coût du mètre carré réduit - Titre foncier', 0, 'Le prix de cession du mètre carré a été réduit pour faciliter l''accès à la terre'),
('Coût total estimé - Titre foncier', 0, 'Coût total variable selon la valeur de la parcelle - Inclut droits d''enregistrement (15%) et de mutation (0,9%)');

-- Association du coût principal à la procédure
UPDATE procedures 
SET cout_id = (SELECT id FROM couts WHERE nom = 'Coût total estimé - Titre foncier' LIMIT 1)
WHERE nom = 'Titre foncier';

-- ============================================
-- 3.151. CENTRES POUR TITRE FONCIER
-- ============================================

-- Ajout des centres spécifiques pour titre foncier
INSERT INTO centres (nom, adresse, horaires, telephone, email, date_creation) VALUES
('Direction Générale des Domaines et du Cadastre (DGDC)', 'Bamako', 'Lundi-Vendredi: 8h-16h', 'Contactez la DGDC', 'dgdc@mali.ml', NOW()),
('Directions Régionales des Domaines et du Cadastre', 'Régions', 'Lundi-Vendredi: 8h-16h', 'Contactez la Direction Régionale', 'domaines.region@mali.ml', NOW()),
('Ministère de l''Urbanisme, de l''Habitat, des Domaines, de l''Aménagement du territoire et de la Population (MUHDATP)', 'Bamako', 'Lundi-Vendredi: 8h-16h', 'Contactez le MUHDATP', 'muhdatp@mali.ml', NOW());

-- Association du centre principal à la procédure
UPDATE procedures 
SET centre_id = (SELECT id FROM centres WHERE nom = 'Direction Générale des Domaines et du Cadastre (DGDC)' LIMIT 1)
WHERE nom = 'Titre foncier';

-- ============================================
-- 3.152. ARTICLES DE LOI POUR TITRE FONCIER
-- ============================================

INSERT INTO lois_articles (description, consulter_article, procedure_id) VALUES
-- Ordonnance n°2020-014/PT-RM du 24 décembre 2020
('Ordonnance n°2020-014/PT-RM du 24 décembre 2020', 
 'Ordonnance n°2020-014/PT-RM, modifiée, du 24 décembre 2020 portant loi domaniale et foncière. C''est le texte de référence qui régit l''accès à la propriété foncière, l''immatriculation des terrains et la délivrance des titres.',
 (SELECT id FROM procedures WHERE nom = 'Titre foncier' LIMIT 1)),

-- Ordonnance n°2024-001/PTRM du 15 janvier 2024
('Ordonnance n°2024-001/PTRM du 15 janvier 2024', 
 'Ordonnance n°2024-001/PTRM du 15 janvier 2024. Ce texte a institué la Direction Générale des Domaines et du Cadastre, qui a remplacé l''ancienne Direction Nationale des Domaines et du Cadastre.',
 (SELECT id FROM procedures WHERE nom = 'Titre foncier' LIMIT 1)),

-- Code domanial et foncier (CDF)
('Code domanial et foncier (CDF)', 
 'Code domanial et foncier (CDF). Ce code définit les principes et procédures concernant la gestion du domaine public et privé de l''État et des collectivités.',
 (SELECT id FROM procedures WHERE nom = 'Titre foncier' LIMIT 1)),

-- Réformes récentes 2024
('Réformes récentes (à partir de 2024)', 
 'Réformes récentes (à partir de 2024). Les autorités de la transition ont introduit plusieurs modifications, notamment la réduction des délais d''enquête (passant de 60 à 30 jours), la réduction du prix du mètre carré pour la cession, et la suppression des titres provisoires de type CUH et CRH.',
 (SELECT id FROM procedures WHERE nom = 'Titre foncier' LIMIT 1));

-- ============================================
-- 3.153. PROCÉDURE: VÉRIFICATION DES TITRES DE PROPRIÉTÉS
-- ============================================

-- Insertion de la procédure
INSERT INTO procedures (nom, titre, delai, description, categorie_id, sous_categorie_id, date_creation) VALUES
('Vérification des titres de propriétés', 'Vérifier l''authenticité d''un titre de propriété', 'Variable selon la complexité du dossier', 
 'Pour vérifier un titre de propriété au Mali, vous devez vous rendre à la Direction Nationale des Domaines et du Cadastre (DNDC) pour une demande de réquisition parcellaire auprès du service domanial compétent. Vous pouvez également consulter les services du cadastre de la commune, qui peut être en mesure de fournir le plan cadastral et le numéro d''identification national unique cadastral (NINACAD). Ces démarches permettent de s''assurer que le vendeur est bien propriétaire et qu''il n''y a pas de litige. La vérification d''un titre de propriété est une étape essentielle pour sécuriser une transaction immobilière. Seul le titre foncier est considéré comme un acte de propriété garanti par l''État. Les titres provisoires doivent être convertis en titres fonciers définitifs pour renforcer la sécurité juridique.',
 (SELECT id FROM categories WHERE titre = 'Service fonciers' LIMIT 1),
 (SELECT id FROM sous_categories WHERE titre = 'Vérification des titres de propriétés' LIMIT 1),
 NOW());

-- ============================================
-- 3.154. ÉTAPES DE LA PROCÉDURE VÉRIFICATION DES TITRES DE PROPRIÉTÉS
-- ============================================

INSERT INTO etapes (nom, description, niveau, procedure_id) VALUES
-- Étape 1: Collecte des documents
('Collecte des documents', 'Demandez au propriétaire de vous fournir une copie du titre foncier et des documents d''identification de la parcelle. Rassemblez tous les documents nécessaires pour la réquisition parcellaire.', 1,
 (SELECT id FROM procedures WHERE nom = 'Vérification des titres de propriétés' LIMIT 1)),

-- Étape 2: Contact avec la DNDC
('Contact avec la DNDC', 'Contactez la Direction Nationale des Domaines et du Cadastre (DNDC) : C''est l''organisme central pour la gestion des propriétés foncières au Mali. Demandez une réquisition parcellaire en remplissant le formulaire de réquisition parcellaire, qui contient des informations sur la parcelle (superficie, localisation).', 2,
 (SELECT id FROM procedures WHERE nom = 'Vérification des titres de propriétés' LIMIT 1)),

-- Étape 3: Consultation des services fonciers
('Consultation des services fonciers', 'Service des Domaines et du Cadastre : Déposez une réquisition de parcelle auprès de ce service en fournissant les documents requis. Système NINACAD : Le service du cadastre utilise le numéro NINACAD pour identifier et tracer les parcelles, vous permettant ainsi de vérifier les informations cadastrales.', 3,
 (SELECT id FROM procedures WHERE nom = 'Vérification des titres de propriétés' LIMIT 1)),

-- Étape 4: Vérification des archives
('Vérification des archives', 'Le service domanial vérifiera les archives pour confirmer la propriété du demandeur. Faites vérifier les archives : Le service domanial vérifiera les archives pour confirmer la propriété du demandeur.', 4,
 (SELECT id FROM procedures WHERE nom = 'Vérification des titres de propriétés' LIMIT 1)),

-- Étape 5: Inspection physique
('Inspection physique', 'Visitez le terrain pour vérifier que les informations du titre correspondent à la réalité sur le terrain. Cette étape permet de s''assurer de la cohérence entre les documents et la situation réelle.', 5,
 (SELECT id FROM procedures WHERE nom = 'Vérification des titres de propriétés' LIMIT 1)),

-- Étape 6: Engagement d'un notaire
('Engagement d''un notaire', 'Faites appel à un notaire public pour effectuer une vérification approfondie. Le notaire : S''assure de l''authenticité des documents, Vérifie l''historique du bien pour s''assurer de l''absence de litiges antérieurs, S''assure que le bien est libre de toute hypothèque ou autre charge.', 6,
 (SELECT id FROM procedures WHERE nom = 'Vérification des titres de propriétés' LIMIT 1)),

-- Étape 7: Obtention du résultat
('Obtention du résultat', 'Le service domanial retournera la réquisition avec une attestation de propriété si le dossier est en ordre. Obtenez le résultat : Le service domanial retournera la réquisition avec une attestation de propriété si le dossier est en ordre.', 7,
 (SELECT id FROM procedures WHERE nom = 'Vérification des titres de propriétés' LIMIT 1));

-- ============================================
-- 3.155. DOCUMENTS REQUIS POUR VÉRIFICATION DES TITRES DE PROPRIÉTÉS
-- ============================================

INSERT INTO documents_requis (nom, description, est_obligatoire, procedure_id) VALUES
('Réquisition de parcelle', 'Une réquisition de parcelle, qui comprend les informations suivantes sur le bien à vérifier', 
 (SELECT id FROM procedures WHERE nom = 'Vérification des titres de propriétés' LIMIT 1)),

('Nom et prénom du propriétaire', 'Nom et prénom du propriétaire', 
 (SELECT id FROM procedures WHERE nom = 'Vérification des titres de propriétés' LIMIT 1)),

('Adresse du propriétaire', 'Adresse du propriétaire', 
 (SELECT id FROM procedures WHERE nom = 'Vérification des titres de propriétés' LIMIT 1)),

('Numéro de la parcelle', 'Numéro de la parcelle', 
 (SELECT id FROM procedures WHERE nom = 'Vérification des titres de propriétés' LIMIT 1)),

('Numéro du titre foncier', 'Numéro du titre foncier, le cas échéant', 
 (SELECT id FROM procedures WHERE nom = 'Vérification des titres de propriétés' LIMIT 1)),

('Numéro d''enregistrement aux folios', 'Numéro d''enregistrement aux folios du service des domaines et du cadastre', 
 (SELECT id FROM procedures WHERE nom = 'Vérification des titres de propriétés' LIMIT 1)),

('Superficie de la parcelle', 'Superficie de la parcelle', 
 (SELECT id FROM procedures WHERE nom = 'Vérification des titres de propriétés' LIMIT 1)),

('Lieu de situation de la parcelle', 'Lieu de situation de la parcelle', 
 (SELECT id FROM procedures WHERE nom = 'Vérification des titres de propriétés' LIMIT 1)),

('Copie du titre foncier', 'Une copie du titre foncier fournie par le propriétaire', 
 (SELECT id FROM procedures WHERE nom = 'Vérification des titres de propriétés' LIMIT 1)),

('Documents d''identification de la parcelle', 'Les documents d''identification de la parcelle', 
 (SELECT id FROM procedures WHERE nom = 'Vérification des titres de propriétés' LIMIT 1));

-- ============================================
-- 3.156. COÛTS DE LA PROCÉDURE VÉRIFICATION DES TITRES DE PROPRIÉTÉS
-- ============================================

-- Insertion des coûts
INSERT INTO couts (nom, prix, description) VALUES
('Droit d''enregistrement - Vérification', 0, 'Droit d''enregistrement : 15% du prix de la parcelle (à titre indicatif)'),
('Droit de mutation - Vérification', 0, 'Droit de mutation : 0,9% du prix de la parcelle (à titre indicatif)'),
('Droit de timbre - Vérification', 12000, 'Droit de timbre : 12 000 FCFA'),
('Frais de notaire - Vérification', 0, 'Frais de notaire pour vérification approfondie et authentification des documents'),
('Coût total estimé - Vérification', 0, 'Coût total variable selon la valeur de la parcelle - Inclut droits d''enregistrement, mutation, timbre et frais de notaire');

-- Association du coût principal à la procédure
UPDATE procedures 
SET cout_id = (SELECT id FROM couts WHERE nom = 'Coût total estimé - Vérification' LIMIT 1)
WHERE nom = 'Vérification des titres de propriétés';

-- ============================================
-- 3.157. CENTRES POUR VÉRIFICATION DES TITRES DE PROPRIÉTÉS
-- ============================================

-- Ajout des centres spécifiques pour vérification des titres
INSERT INTO centres (nom, adresse, horaires, telephone, email, date_creation) VALUES
('Direction Nationale des Domaines et du Cadastre (DNDC)', 'Bamako', 'Lundi-Vendredi: 8h-16h', 'Contactez la DNDC', 'dndc@mali.ml', NOW()),
('Service des Domaines et du Cadastre', 'Bamako', 'Lundi-Vendredi: 8h-16h', 'Contactez le Service des Domaines', 'domaines@mali.ml', NOW()),
('Services du cadastre de la commune', 'Communes', 'Lundi-Vendredi: 8h-16h', 'Contactez le cadastre communal', 'cadastre.commune@mali.ml', NOW()),
('Notaires publics', 'Bamako', 'Lundi-Vendredi: 8h-16h', 'Contactez l''Ordre des Notaires', 'notaires@mali.ml', NOW());

-- Association du centre principal à la procédure
UPDATE procedures 
SET centre_id = (SELECT id FROM centres WHERE nom = 'Direction Nationale des Domaines et du Cadastre (DNDC)' LIMIT 1)
WHERE nom = 'Vérification des titres de propriétés';

-- ============================================
-- 3.158. ARTICLES DE LOI POUR VÉRIFICATION DES TITRES DE PROPRIÉTÉS
-- ============================================

INSERT INTO lois_articles (description, consulter_article, procedure_id) VALUES
-- Code domanial et foncier
('Code domanial et foncier', 
 'Code domanial et foncier. Ce code définit le cadre juridique de la propriété foncière au Mali. Il a été mis à jour par l''ordonnance n°2020-014/PT-RM du 24 décembre 2020.',
 (SELECT id FROM procedures WHERE nom = 'Vérification des titres de propriétés' LIMIT 1)),

-- Ordonnance n°2020-014/PT-RM du 24 décembre 2020
('Ordonnance n°2020-014/PT-RM du 24 décembre 2020', 
 'Ordonnance n°2020-014/PT-RM du 24 décembre 2020. Cette ordonnance a mis à jour le Code domanial et foncier et régit la propriété foncière au Mali.',
 (SELECT id FROM procedures WHERE nom = 'Vérification des titres de propriétés' LIMIT 1)),

-- Décret portant création du NINACAD
('Décret portant création du NINACAD', 
 'Décret portant création du NINACAD. Ce décret établit le Numéro d''Identification National Cadastral (NINACAD) pour toutes les parcelles de terrain. Il améliore la traçabilité des transactions et l''identification des propriétés.',
 (SELECT id FROM procedures WHERE nom = 'Vérification des titres de propriétés' LIMIT 1));

-- ============================================
-- 3.159. PROCÉDURE: TRANSACTION IMMOBILIÈRE COMPLÈTE
-- ============================================

-- Insertion de la procédure
INSERT INTO procedures (nom, titre, delai, description, categorie_id, sous_categorie_id, date_creation) VALUES
('Transaction immobilière complète', 'Sécuriser une transaction immobilière complète', 'Plusieurs mois (selon les étapes)', 
 'Pour une transaction immobilière complète au Mali, plusieurs délais s''ajoutent selon les étapes : Compromis de vente : Le délai entre la signature du compromis et l''acte de vente notarié est généralement de 3 à 4 mois. Cette période permet de lever les conditions suspensives, telles que l''obtention d''un crédit ou la vérification du titre de propriété. Vérification notariale : La vérification par le notaire peut prendre de 1 à 5 semaines, selon sa disponibilité et la complexité du dossier, qui inclut la réunion de tous les documents nécessaires. Droit de préemption : Les collectivités locales ont souvent un droit de préemption, qui peut ajouter un délai de 60 jours à la procédure. En résumé, le délai total pour la sécurisation d''une transaction immobilière complète, de la vérification à l''obtention du titre, peut donc être de plusieurs mois.',
 (SELECT id FROM categories WHERE titre = 'Service fonciers' LIMIT 1),
 (SELECT id FROM sous_categories WHERE titre = 'Vérification des titres de propriétés' LIMIT 1),
 NOW());

-- ============================================
-- 3.160. ÉTAPES DE LA PROCÉDURE TRANSACTION IMMOBILIÈRE COMPLÈTE
-- ============================================

INSERT INTO etapes (nom, description, niveau, procedure_id) VALUES
-- Étape 1: Signature du compromis de vente
('Signature du compromis de vente', 'Signature du compromis de vente entre l''acheteur et le vendeur. Le délai entre la signature du compromis et l''acte de vente notarié est généralement de 3 à 4 mois. Cette période permet de lever les conditions suspensives, telles que l''obtention d''un crédit ou la vérification du titre de propriété.', 1,
 (SELECT id FROM procedures WHERE nom = 'Transaction immobilière complète' LIMIT 1)),

-- Étape 2: Vérification notariale
('Vérification notariale', 'La vérification par le notaire peut prendre de 1 à 5 semaines, selon sa disponibilité et la complexité du dossier, qui inclut la réunion de tous les documents nécessaires. Le notaire s''assure de l''authenticité des documents et vérifie l''historique du bien.', 2,
 (SELECT id FROM procedures WHERE nom = 'Transaction immobilière complète' LIMIT 1)),

-- Étape 3: Droit de préemption (si applicable)
('Droit de préemption (si applicable)', 'Les collectivités locales ont souvent un droit de préemption, qui peut ajouter un délai de 60 jours à la procédure. Cette étape n''est pas systématique mais peut s''appliquer selon la localisation et la nature du bien.', 3,
 (SELECT id FROM procedures WHERE nom = 'Transaction immobilière complète' LIMIT 1)),

-- Étape 4: Acte de vente notarié
('Acte de vente notarié', 'Préparation et signature de l''acte de vente notarié. Le notaire prépare l''acte de vente et procède à la signature en présence des parties.', 4,
 (SELECT id FROM procedures WHERE nom = 'Transaction immobilière complète' LIMIT 1)),

-- Étape 5: Paiement des taxes et enregistrement
('Paiement des taxes et enregistrement', 'Paiement des frais légaux, y compris les droits d''enregistrement et de mutation, auprès des services compétents. Le notaire enregistre l''acte de vente aux services des impôts et domaines.', 5,
 (SELECT id FROM procedures WHERE nom = 'Transaction immobilière complète' LIMIT 1)),

-- Étape 6: Obtention du titre foncier
('Obtention du titre foncier', 'Le délai total pour la sécurisation d''une transaction immobilière complète, de la vérification à l''obtention du titre, peut donc être de plusieurs mois. Le titre foncier définitif est délivré après l''enregistrement de l''acte de vente.', 6,
 (SELECT id FROM procedures WHERE nom = 'Transaction immobilière complète' LIMIT 1));

-- ============================================
-- 3.161. DOCUMENTS REQUIS POUR TRANSACTION IMMOBILIÈRE COMPLÈTE
-- ============================================

INSERT INTO documents_requis (nom, description, est_obligatoire, procedure_id) VALUES
('Compromis de vente', 'Le compromis de vente signé entre l''acheteur et le vendeur', 
 (SELECT id FROM procedures WHERE nom = 'Transaction immobilière complète' LIMIT 1)),

('Titre de propriété du vendeur', 'Le titre de propriété du vendeur (titre foncier, permis d''occuper, etc.)', 
 (SELECT id FROM procedures WHERE nom = 'Transaction immobilière complète' LIMIT 1)),

('Pièces d''identité des parties', 'Les pièces d''identité de l''acheteur et du vendeur', 
 (SELECT id FROM procedures WHERE nom = 'Transaction immobilière complète' LIMIT 1)),

('Justificatifs de revenus (si crédit)', 'Les justificatifs de revenus de l''acheteur si un crédit est nécessaire', 
 (SELECT id FROM procedures WHERE nom = 'Transaction immobilière complète' LIMIT 1)),

('Attestation de non préemption', 'L''attestation de non préemption des collectivités locales (si applicable)', 
 (SELECT id FROM procedures WHERE nom = 'Transaction immobilière complète' LIMIT 1)),

('Acte de vente notarié', 'L''acte de vente notarié préparé par le notaire', 
 (SELECT id FROM procedures WHERE nom = 'Transaction immobilière complète' LIMIT 1)),

('Quitus fiscal', 'Le quitus fiscal en cours de validité', 
 (SELECT id FROM procedures WHERE nom = 'Transaction immobilière complète' LIMIT 1));

-- ============================================
-- 3.162. COÛTS DE LA PROCÉDURE TRANSACTION IMMOBILIÈRE COMPLÈTE
-- ============================================

-- Insertion des coûts
INSERT INTO couts (nom, prix, description) VALUES
('Frais de notaire - Transaction complète', 0, 'Frais de notaire pour la préparation de l''acte de vente et l''enregistrement'),
('Droit d''enregistrement - Transaction complète', 0, 'Droit d''enregistrement : 15% du prix de la parcelle'),
('Droit de mutation - Transaction complète', 0, 'Droit de mutation : 0,9% du prix de la parcelle'),
('Droit de timbre - Transaction complète', 12000, 'Droit de timbre : 12 000 FCFA'),
('Frais de préemption - Transaction complète', 0, 'Frais éventuels liés au droit de préemption des collectivités locales'),
('Coût total estimé - Transaction complète', 0, 'Coût total variable selon la valeur de la parcelle - Inclut tous les frais de notaire, droits et taxes');

-- Association du coût principal à la procédure
UPDATE procedures 
SET cout_id = (SELECT id FROM couts WHERE nom = 'Coût total estimé - Transaction complète' LIMIT 1)
WHERE nom = 'Transaction immobilière complète';

-- ============================================
-- 3.163. CENTRES POUR TRANSACTION IMMOBILIÈRE COMPLÈTE
-- ============================================

-- Association du centre principal à la procédure
UPDATE procedures 
SET centre_id = (SELECT id FROM centres WHERE nom = 'Direction Nationale des Domaines et du Cadastre (DNDC)' LIMIT 1)
WHERE nom = 'Transaction immobilière complète';

-- ============================================
-- 3.164. ARTICLES DE LOI POUR TRANSACTION IMMOBILIÈRE COMPLÈTE
-- ============================================

INSERT INTO lois_articles (description, consulter_article, procedure_id) VALUES
-- Code domanial et foncier
('Code domanial et foncier - Transaction immobilière', 
 'Code domanial et foncier. Ce code définit le cadre juridique de la propriété foncière et des transactions immobilières au Mali.',
 (SELECT id FROM procedures WHERE nom = 'Transaction immobilière complète' LIMIT 1)),

-- Ordonnance n°2020-014/PT-RM du 24 décembre 2020
('Ordonnance n°2020-014/PT-RM du 24 décembre 2020 - Transaction immobilière', 
 'Ordonnance n°2020-014/PT-RM du 24 décembre 2020. Cette ordonnance régit les transactions immobilières et la propriété foncière au Mali.',
 (SELECT id FROM procedures WHERE nom = 'Transaction immobilière complète' LIMIT 1)),

-- Droit de préemption
('Droit de préemption des collectivités locales', 
 'Droit de préemption des collectivités locales. Les collectivités locales ont souvent un droit de préemption, qui peut ajouter un délai de 60 jours à la procédure de transaction immobilière.',
 (SELECT id FROM procedures WHERE nom = 'Transaction immobilière complète' LIMIT 1));

-- ============================================
-- 3.165. PROCÉDURE: LETTRE D'ATTRIBUTION DU TITRE PROVISOIRE DE CONCESSION RURALE
-- ============================================

-- Insertion de la procédure
INSERT INTO procedures (nom, titre, delai, description, categorie_id, sous_categorie_id, date_creation) VALUES
('Lettre d''attribution du titre provisoire de concession rurale', 'Obtenir une lettre d''attribution provisoire de concession rurale', 'Plusieurs mois (délai variable selon la complexité)', 
 'Une lettre d''attribution provisoire de concession rurale au Mali est un acte qui accorde le droit d''utiliser un terrain à titre provisoire, en attendant un transfert de propriété définitif après la mise en valeur du terrain. Le processus implique une demande formelle, la vérification des conditions par les autorités, le respect des clauses du cahier des charges et l''obtention éventuelle d''un titre foncier (ou un Arrêté de Concession Définitive - ACD) si les obligations sont remplies. Le délai de traitement n''est pas fixe et dépend de plusieurs facteurs : nature et complexité du dossier, vérification des droits fonciers coutumiers, coordination administrative, interventions sur le terrain, litiges éventuels et charge de travail de l''administration. Le demandeur doit prévoir un processus qui peut être long et complexe et dont la durée exacte est difficile à estimer à l''avance.',
 (SELECT id FROM categories WHERE titre = 'Service fonciers' LIMIT 1),
 (SELECT id FROM sous_categories WHERE titre = 'Lettre d''attribution du titre provisoire de concession rurale' LIMIT 1),
 NOW());

-- ============================================
-- 3.166. ÉTAPES DE LA PROCÉDURE LETTRE D'ATTRIBUTION DU TITRE PROVISOIRE DE CONCESSION RURALE
-- ============================================

INSERT INTO etapes (nom, description, niveau, procedure_id) VALUES
-- Étape 1: Dépôt de la demande
('Dépôt de la demande', 'Le demandeur doit soumettre une demande écrite aux autorités compétentes, en précisant son intention de mettre en valeur le terrain. Soumettez le dossier complet auprès de la préfecture ou de la direction des domaines et du cadastre compétente.', 1,
 (SELECT id FROM procedures WHERE nom = 'Lettre d''attribution du titre provisoire de concession rurale' LIMIT 1)),

-- Étape 2: Vérification et homologation
('Vérification et homologation', 'Les services compétents vérifient la conformité de la demande, les conditions locales et la disponibilité de la parcelle. Une commission se rendra sur le terrain pour procéder à un bornage et à une enquête afin de vérifier les droits coutumiers et d''éventuels conflits.', 2,
 (SELECT id FROM procedures WHERE nom = 'Lettre d''attribution du titre provisoire de concession rurale' LIMIT 1)),

-- Étape 3: Enquête et bornage
('Enquête et bornage', 'Cette étape peut prendre plusieurs semaines, voire plusieurs mois, en fonction de la disponibilité des équipes techniques et des potentielles contestations. Le bornage et l''établissement des plans par le géomètre, ainsi que les visites sur site pour l''enquête, sont des étapes qui peuvent prendre du temps.', 3,
 (SELECT id FROM procedures WHERE nom = 'Lettre d''attribution du titre provisoire de concession rurale' LIMIT 1)),

-- Étape 4: Établissement du cahier des charges
('Établissement du cahier des charges', 'Un cahier des charges est annexé à la lettre d''attribution, détaillant les obligations et les délais de mise en valeur. Le dossier est soumis à l''autorité administrative compétente (selon la taille du terrain) pour validation et signature.', 4,
 (SELECT id FROM procedures WHERE nom = 'Lettre d''attribution du titre provisoire de concession rurale' LIMIT 1)),

-- Étape 5: Approbation et délivrance
('Approbation et délivrance', 'Le dossier est soumis à l''autorité administrative compétente (selon la taille du terrain) pour validation et signature. Après approbation, la lettre d''attribution provisoire est délivrée au demandeur. L''autorité accorde la concession provisoire, soumise aux conditions du cahier des charges.', 5,
 (SELECT id FROM procedures WHERE nom = 'Lettre d''attribution du titre provisoire de concession rurale' LIMIT 1)),

-- Étape 6: Mise en valeur
('Mise en valeur', 'Le concessionnaire doit remplir ses obligations dans le délai imparti. Le bénéficiaire dispose d''un délai (souvent trois ans) pour mettre en valeur le terrain comme stipulé dans le cahier des charges.', 6,
 (SELECT id FROM procedures WHERE nom = 'Lettre d''attribution du titre provisoire de concession rurale' LIMIT 1)),

-- Étape 7: Transfert de propriété (si applicable)
('Transfert de propriété (si applicable)', 'Si la mise en valeur est effective et constatée, le concessionnaire peut demander l''immatriculation du terrain pour obtenir un titre foncier ou un ACD, qui constitue le titre de propriété définitif. Une fois la mise en valeur effectuée, le bénéficiaire peut entamer la procédure de confirmation du titre provisoire en titre foncier définitif.', 7,
 (SELECT id FROM procedures WHERE nom = 'Lettre d''attribution du titre provisoire de concession rurale' LIMIT 1));

-- ============================================
-- 3.167. DOCUMENTS REQUIS POUR LETTRE D'ATTRIBUTION DU TITRE PROVISOIRE DE CONCESSION RURALE
-- ============================================

INSERT INTO documents_requis (nom, description, est_obligatoire, procedure_id) VALUES
('Demande manuscrite timbrée', 'Une demande manuscrite timbrée adressée à l''autorité compétente (Préfet ou Gouverneur selon la superficie)', 
 (SELECT id FROM procedures WHERE nom = 'Lettre d''attribution du titre provisoire de concession rurale' LIMIT 1)),

('Pièces d''état civil du demandeur', 'Des pièces d''état civil du demandeur (extrait d''acte de naissance, carte d''identité ou passeport)', 
 (SELECT id FROM procedures WHERE nom = 'Lettre d''attribution du titre provisoire de concession rurale' LIMIT 1)),

('Quitus fiscal', 'Un quitus fiscal prouvant que le demandeur est à jour de ses obligations fiscales', 
 (SELECT id FROM procedures WHERE nom = 'Lettre d''attribution du titre provisoire de concession rurale' LIMIT 1)),

('Fiche d''identification', 'Une fiche d''identification fournie par l''administration, dûment remplie', 
 (SELECT id FROM procedures WHERE nom = 'Lettre d''attribution du titre provisoire de concession rurale' LIMIT 1)),

('Plan de situation et plan de bornage', 'Un plan de situation et un plan de bornage du terrain, établis par un géomètre agréé', 
 (SELECT id FROM procedures WHERE nom = 'Lettre d''attribution du titre provisoire de concession rurale' LIMIT 1)),

('Procès-verbal de constat du terrain', 'Un procès-verbal de constat du terrain, dressé par le service des Domaines et du Cadastre', 
 (SELECT id FROM procedures WHERE nom = 'Lettre d''attribution du titre provisoire de concession rurale' LIMIT 1)),

('Procès-verbal d''enquête de commodo et incommodo', 'Un procès-verbal d''enquête de commodo et incommodo attestant que l''attribution ne porte pas préjudice aux droits des tiers', 
 (SELECT id FROM procedures WHERE nom = 'Lettre d''attribution du titre provisoire de concession rurale' LIMIT 1)),

('Copie de l''acte de naissance', 'Une copie de l''acte de naissance pour les nationaux', 
 (SELECT id FROM procedures WHERE nom = 'Lettre d''attribution du titre provisoire de concession rurale' LIMIT 1)),

('Autorisation spéciale pour étrangers', 'Une autorisation spéciale pour les ressortissants étrangers', 
 (SELECT id FROM procedures WHERE nom = 'Lettre d''attribution du titre provisoire de concession rurale' LIMIT 1)),

('Engagement de mise en valeur', 'Un engagement du demandeur à mettre en valeur le terrain et à respecter les clauses du cahier des charges', 
 (SELECT id FROM procedures WHERE nom = 'Lettre d''attribution du titre provisoire de concession rurale' LIMIT 1));

-- ============================================
-- 3.168. COÛTS DE LA PROCÉDURE LETTRE D'ATTRIBUTION DU TITRE PROVISOIRE DE CONCESSION RURALE
-- ============================================

-- Insertion des coûts
INSERT INTO couts (nom, prix, description) VALUES
('Taxes et redevances - Concession rurale', 0, 'Le prix de cession varie selon la localisation et l''usage du terrain'),
('Frais d''arpentage - Concession rurale', 0, 'Le coût des opérations de bornage et d''établissement des plans, facturé par le service compétent'),
('Droits d''enregistrement - Concession rurale', 0, 'Frais liés à l''enregistrement de la concession auprès des services fiscaux'),
('Frais de dossier - Concession rurale', 0, 'Montant à acquitter au moment du dépôt de la demande'),
('Timbre fiscal - Concession rurale', 0, 'Pour la demande et les documents'),
('Coût total estimé - Concession rurale', 0, 'Coût total variable selon la localisation, l''usage du terrain et les frais d''arpentage');

-- Association du coût principal à la procédure
UPDATE procedures 
SET cout_id = (SELECT id FROM couts WHERE nom = 'Coût total estimé - Concession rurale' LIMIT 1)
WHERE nom = 'Lettre d''attribution du titre provisoire de concession rurale';

-- ============================================
-- 3.169. CENTRES POUR LETTRE D'ATTRIBUTION DU TITRE PROVISOIRE DE CONCESSION RURALE
-- ============================================

-- Ajout des centres spécifiques pour concession rurale
INSERT INTO centres (nom, adresse, horaires, telephone, email, date_creation) VALUES
('Direction Générale des Domaines et du Cadastre (DGDC)', 'Bamako', 'Lundi-Vendredi: 8h-16h', 'Contactez la DGDC', 'dgdc@mali.ml', NOW()),
('Directions Régionales des Domaines et du Cadastre', 'Régions', 'Lundi-Vendredi: 8h-16h', 'Contactez la Direction Régionale', 'domaines.region@mali.ml', NOW()),
('Préfectures et Sous-préfectures', 'Régions', 'Lundi-Vendredi: 8h-16h', 'Contactez la Préfecture', 'prefecture@mali.ml', NOW()),
('Ministère de l''Urbanisme, de l''Habitat, des Domaines, de l''Aménagement du Territoire et de la Population', 'Bamako', 'Lundi-Vendredi: 8h-16h', 'Contactez le MUHDATP', 'muhdatp@mali.ml', NOW());

-- Association du centre principal à la procédure
UPDATE procedures 
SET centre_id = (SELECT id FROM centres WHERE nom = 'Direction Générale des Domaines et du Cadastre (DGDC)' LIMIT 1)
WHERE nom = 'Lettre d''attribution du titre provisoire de concession rurale';

-- ============================================
-- 3.170. ARTICLES DE LOI POUR LETTRE D'ATTRIBUTION DU TITRE PROVISOIRE DE CONCESSION RURALE
-- ============================================

INSERT INTO lois_articles (description, consulter_article, procedure_id) VALUES
-- Ordonnance n°00-027/P-RM du 22 mars 2000
('Ordonnance n°00-027/P-RM du 22 mars 2000', 
 'Ordonnance n°00-027/P-RM du 22 mars 2000. Portant Code domanial et foncier, modifiée et ratifiée par la Loi n°02-008 du 12 février 2002.',
 (SELECT id FROM procedures WHERE nom = 'Lettre d''attribution du titre provisoire de concession rurale' LIMIT 1)),

-- Décret n°01-040/P-RM du 02 février 2001
('Décret n°01-040/P-RM du 02 février 2001', 
 'Décret n°01-040/P-RM du 02 février 2001. Déterminant les formes et conditions d''attribution des terrains du domaine privé immobilier de l''État.',
 (SELECT id FROM procedures WHERE nom = 'Lettre d''attribution du titre provisoire de concession rurale' LIMIT 1)),

-- Décret n°02-112/P-RM du 06 mars 2002
('Décret n°02-112/P-RM du 06 mars 2002', 
 'Décret n°02-112/P-RM du 06 mars 2002. Déterminant les formes et conditions d''attribution des terrains du domaine privé immobilier des collectivités territoriales.',
 (SELECT id FROM procedures WHERE nom = 'Lettre d''attribution du titre provisoire de concession rurale' LIMIT 1)),

-- Loi n°2017-01 du 11 avril 2017
('Loi n°2017-01 du 11 avril 2017', 
 'Loi n°2017-01 du 11 avril 2017. Portant sur le foncier agricole.',
 (SELECT id FROM procedures WHERE nom = 'Lettre d''attribution du titre provisoire de concession rurale' LIMIT 1)),

-- Décret n°2019-0113/P-RM du 22 février 2019
('Décret n°2019-0113/P-RM du 22 février 2019', 
 'Décret n°2019-0113/P-RM du 22 février 2019. Fixant les prix de cession et redevances des terrains domaniaux.',
 (SELECT id FROM procedures WHERE nom = 'Lettre d''attribution du titre provisoire de concession rurale' LIMIT 1));

-- ============================================
-- 3.171. PROCÉDURE: CONCESSION URBAINE À USAGE D'HABITATION (CUH)
-- ============================================

-- Insertion de la procédure
INSERT INTO procedures (nom, titre, delai, description, categorie_id, sous_categorie_id, date_creation) VALUES
('Concession urbaine à usage d''habitation (CUH)', 'Obtenir une Concession Urbaine à usage d''Habitation (CUH)', 'Durée variable selon la célérité des services administratifs', 
 'La procédure d''obtention d''une Concession Urbaine à usage d''Habitation (CUH) au Mali comprend deux grandes phases : l''obtention d''un titre provisoire (la CUH) et sa transformation en titre foncier définitif. Phase 1 : Demande de concession aux services domaniaux, enquête de commodo et incommodo, procès-verbal de bornage et d''évaluation, arrêté de concession provisoire. Phase 2 : Mise en valeur dans un délai imparti, demande de titre foncier, publication et immatriculation. Les délais de traitement sont variables et dépendent de la célérité des services administratifs. Le délai maximal pour l''obtention d''un titre foncier après la mise en valeur est de 6 mois.',
 (SELECT id FROM categories WHERE titre = 'Service fonciers' LIMIT 1),
 (SELECT id FROM sous_categories WHERE titre = 'Concession urbaine à usage d''habitation (CUH)' LIMIT 1),
 NOW());

-- ============================================
-- 3.172. ÉTAPES DE LA PROCÉDURE CONCESSION URBAINE À USAGE D'HABITATION (CUH)
-- ============================================

INSERT INTO etapes (nom, description, niveau, procedure_id) VALUES
-- Phase 1: Obtention de la CUH
-- Étape 1: Demande de concession
('Demande de concession', 'Adressez une demande de concession aux services domaniaux (Ministère des Domaines de l''État). La demande doit être écrite et indiquer les coordonnées du demandeur et la localisation du terrain souhaité.', 1,
 (SELECT id FROM procedures WHERE nom = 'Concession urbaine à usage d''habitation (CUH)' LIMIT 1)),

-- Étape 2: Enquête de commodo et incommodo
('Enquête de commodo et incommodo', 'Les services des domaines procèdent à une enquête afin de s''assurer que l''attribution du terrain ne cause pas de gêne pour le voisinage et qu''elle est conforme aux règles d''urbanisme.', 2,
 (SELECT id FROM procedures WHERE nom = 'Concession urbaine à usage d''habitation (CUH)' LIMIT 1)),

-- Étape 3: Procès-verbal de bornage et d'évaluation
('Procès-verbal de bornage et d''évaluation', 'Un procès-verbal est établi pour délimiter le terrain et en évaluer la valeur.', 3,
 (SELECT id FROM procedures WHERE nom = 'Concession urbaine à usage d''habitation (CUH)' LIMIT 1)),

-- Étape 4: Arrêté de concession provisoire
('Arrêté de concession provisoire', 'Sur la base de l''enquête et du procès-verbal, le ministre des Domaines délivre l''arrêté de concession provisoire, qui fait office de CUH.', 4,
 (SELECT id FROM procedures WHERE nom = 'Concession urbaine à usage d''habitation (CUH)' LIMIT 1)),

-- Phase 2: Transformation de la CUH en titre foncier
-- Étape 5: Mise en valeur
('Mise en valeur', 'Dans un délai imparti, généralement fixé dans l''arrêté de concession, le bénéficiaire doit construire sa maison conformément aux plans approuvés.', 5,
 (SELECT id FROM procedures WHERE nom = 'Concession urbaine à usage d''habitation (CUH)' LIMIT 1)),

-- Étape 6: Demande de titre foncier
('Demande de titre foncier', 'Une fois la mise en valeur effectuée, le concessionnaire dépose une demande de transformation de sa CUH en titre foncier auprès de la Direction Nationale des Domaines et du Cadastre (DNDC).', 6,
 (SELECT id FROM procedures WHERE nom = 'Concession urbaine à usage d''habitation (CUH)' LIMIT 1)),

-- Étape 7: Publication et immatriculation
('Publication et immatriculation', 'La DNDC procède à l''immatriculation du terrain et à la publication du titre foncier, qui devient alors définitif. Le délai maximal pour l''obtention d''un titre foncier après la mise en valeur est de 6 mois.', 7,
 (SELECT id FROM procedures WHERE nom = 'Concession urbaine à usage d''habitation (CUH)' LIMIT 1));

-- ============================================
-- 3.173. DOCUMENTS REQUIS POUR CONCESSION URBAINE À USAGE D'HABITATION (CUH)
-- ============================================

INSERT INTO documents_requis (nom, description, est_obligatoire, procedure_id) VALUES
('Demande de concession écrite et timbrée', 'Une demande de concession écrite et timbrée, adressée au ministre des Domaines', 
 (SELECT id FROM procedures WHERE nom = 'Concession urbaine à usage d''habitation (CUH)' LIMIT 1)),

('Copie certifiée de la carte d''identité ou du passeport', 'Une copie certifiée de la carte d''identité ou du passeport du demandeur', 
 (SELECT id FROM procedures WHERE nom = 'Concession urbaine à usage d''habitation (CUH)' LIMIT 1)),

('Extrait d''acte de naissance ou jugement supplétif', 'Un extrait d''acte de naissance ou jugement supplétif', 
 (SELECT id FROM procedures WHERE nom = 'Concession urbaine à usage d''habitation (CUH)' LIMIT 1)),

('Certificat de résidence', 'Un certificat de résidence', 
 (SELECT id FROM procedures WHERE nom = 'Concession urbaine à usage d''habitation (CUH)' LIMIT 1)),

('Plan de situation du terrain', 'Un plan de situation du terrain', 
 (SELECT id FROM procedures WHERE nom = 'Concession urbaine à usage d''habitation (CUH)' LIMIT 1)),

('Dossier d''enquête dûment rempli', 'Un dossier d''enquête dûment rempli par les services compétents', 
 (SELECT id FROM procedures WHERE nom = 'Concession urbaine à usage d''habitation (CUH)' LIMIT 1)),

('Dossier technique avec plans de construction', 'Un dossier technique comprenant les plans de construction visés par le service de l''urbanisme', 
 (SELECT id FROM procedures WHERE nom = 'Concession urbaine à usage d''habitation (CUH)' LIMIT 1)),

('Procès-verbal de bornage et d''évaluation', 'Le procès-verbal de bornage et d''évaluation du terrain', 
 (SELECT id FROM procedures WHERE nom = 'Concession urbaine à usage d''habitation (CUH)' LIMIT 1)),

('Arrêté de concession provisoire', 'L''arrêté de concession provisoire délivré par le ministre des Domaines', 
 (SELECT id FROM procedures WHERE nom = 'Concession urbaine à usage d''habitation (CUH)' LIMIT 1));

-- ============================================
-- 3.174. COÛTS DE LA PROCÉDURE CONCESSION URBAINE À USAGE D'HABITATION (CUH)
-- ============================================

-- Insertion des coûts
INSERT INTO couts (nom, prix, description) VALUES
('Droits d''enregistrement - CUH', 0, 'Droit d''enregistrement de 15% du prix de cession du terrain'),
('Droits de mutation - CUH', 0, 'Droit de mutation de 0,9% du prix de cession du terrain'),
('Droits de timbres - CUH', 0, 'Droits de timbres pour les documents nécessaires'),
('Frais d''immatriculation et d''arpentage - CUH', 0, 'Frais d''immatriculation et d''arpentage pour l''établissement du titre foncier définitif'),
('Coût de la construction - CUH', 0, 'Le bénéficiaire doit financer la construction de sa maison'),
('Coût total estimé - CUH', 0, 'Coût total variable selon le prix de cession du terrain et le coût de construction');

-- Association du coût principal à la procédure
UPDATE procedures 
SET cout_id = (SELECT id FROM couts WHERE nom = 'Coût total estimé - CUH' LIMIT 1)
WHERE nom = 'Concession urbaine à usage d''habitation (CUH)';

-- ============================================
-- 3.175. CENTRES POUR CONCESSION URBAINE À USAGE D'HABITATION (CUH)
-- ============================================

-- Ajout des centres spécifiques pour CUH
INSERT INTO centres (nom, adresse, horaires, telephone, email, date_creation) VALUES
('Direction Nationale des Domaines et du Cadastre (DNDC)', 'Bamako', 'Lundi-Vendredi: 8h-16h', 'Contactez la DNDC', 'dndc@mali.ml', NOW()),
('Directions régionales des Domaines et du Cadastre', 'Régions', 'Lundi-Vendredi: 8h-16h', 'Contactez la Direction Régionale', 'domaines.region@mali.ml', NOW()),
('Services domaniaux au sein des mairies', 'Communes', 'Lundi-Vendredi: 8h-16h', 'Contactez la Mairie', 'mairie.domaine@mali.ml', NOW()),
('Ministère des Domaines de l''État', 'Bamako', 'Lundi-Vendredi: 8h-16h', 'Contactez le Ministère des Domaines', 'domaines.etat@mali.ml', NOW());

-- Association du centre principal à la procédure
UPDATE procedures 
SET centre_id = (SELECT id FROM centres WHERE nom = 'Direction Nationale des Domaines et du Cadastre (DNDC)' LIMIT 1)
WHERE nom = 'Concession urbaine à usage d''habitation (CUH)';

-- ============================================
-- 3.176. ARTICLES DE LOI POUR CONCESSION URBAINE À USAGE D'HABITATION (CUH)
-- ============================================

INSERT INTO lois_articles (description, consulter_article, procedure_id) VALUES
-- Ordonnance N° 00-027/P-RM du 22 mars 2000
('Ordonnance N° 00-027/P-RM du 22 mars 2000', 
 'Ordonnance N° 00-027/P-RM du 22 mars 2000 modifiée portant Code Domanial et Foncier. Ce texte est la base juridique qui régit toutes les questions relatives à la propriété foncière, y compris les concessions urbaines à usage d''habitation.',
 (SELECT id FROM procedures WHERE nom = 'Concession urbaine à usage d''habitation (CUH)' LIMIT 1));

-- ============================================
-- 3.177. PROCÉDURE: TITRE PROVISOIRE EN TITRE FONCIER (CUH, CRH ET CONTRAT DE BAIL AVEC PROMESSE DE VENTE)
-- ============================================

-- Insertion de la procédure
INSERT INTO procedures (nom, titre, delai, description, categorie_id, sous_categorie_id, date_creation) VALUES
('Titre provisoire en titre foncier (CUH, CRH et contrat de bail avec promesse de vente)', 'Convertir un titre provisoire en titre foncier définitif', '6 mois environ (délai indicatif)', 
 'Pour obtenir un titre foncier définitif au Mali, il est nécessaire de transformer les titres provisoires comme le Certificat d''Utilisation à des fins d''Habitation (CUH), le Certificat de reconnaissance des droits d''occupation (CRH) ou le contrat de bail avec promesse de vente. Le titre foncier garantit la propriété de manière définitive et irrévocable, contrairement aux titres provisoires. La transformation d''un titre provisoire en titre foncier au Mali suit une procédure bien établie, encadrée par la Direction Nationale des Domaines et du Cadastre (DNDC). Le délai pour l''obtention d''un titre foncier est de six mois environ, mais il peut varier en fonction de la complexité du dossier. Le titre foncier offre une sécurité juridique absolue, une protection contre les litiges et facilite les transactions.',
 (SELECT id FROM categories WHERE titre = 'Service fonciers' LIMIT 1),
 (SELECT id FROM sous_categories WHERE titre = 'Titre provisoire en titre foncier (CUH, CRH et contrat de bail avec promesse de vente)' LIMIT 1),
 NOW());

-- ============================================
-- 3.178. ÉTAPES DE LA PROCÉDURE TITRE PROVISOIRE EN TITRE FONCIER
-- ============================================

INSERT INTO etapes (nom, description, niveau, procedure_id) VALUES
-- Étape 1: Préparation du dossier
('Préparation du dossier', 'Rassemblez tous les documents nécessaires avant de commencer la procédure. Rédigez une demande formelle adressée aux autorités compétentes, comme la Direction Nationale des Domaines et du Cadastre du Mali (DNDC).', 1,
 (SELECT id FROM procedures WHERE nom = 'Titre provisoire en titre foncier (CUH, CRH et contrat de bail avec promesse de vente)' LIMIT 1)),

-- Étape 2: Dépôt de la demande
('Dépôt de la demande', 'Soumettez le dossier complet à la Direction Régionale des Domaines et du Cadastre (DRDC) de votre localité. La demande doit être accompagnée des pièces requises, y compris une copie certifiée du titre provisoire (CUH, CRH ou bail), ainsi que tout autre document pertinent.', 2,
 (SELECT id FROM procedures WHERE nom = 'Titre provisoire en titre foncier (CUH, CRH et contrat de bail avec promesse de vente)' LIMIT 1)),

-- Étape 3: Validation et enquête
('Validation et enquête', 'La DRDC procède à une vérification et envoie un agent sur le terrain pour constater la mise en valeur de la parcelle, s''assurer que le propriétaire a bien bâti et occupé les lieux. Les autorités effectuent des vérifications pour s''assurer que le terrain n''est pas grevé de charges et est conforme aux règles d''urbanisme.', 3,
 (SELECT id FROM procedures WHERE nom = 'Titre provisoire en titre foncier (CUH, CRH et contrat de bail avec promesse de vente)' LIMIT 1)),

-- Étape 4: Enregistrement et réquisition
('Enregistrement et réquisition', 'Après validation, la DNDC procède à l''immatriculation et à l''enregistrement du droit de propriété, ce qui mène à la création du titre foncier. Une fois les vérifications terminées, le dossier est instruit pour l''immatriculation du terrain et la délivrance du titre foncier.', 4,
 (SELECT id FROM procedures WHERE nom = 'Titre provisoire en titre foncier (CUH, CRH et contrat de bail avec promesse de vente)' LIMIT 1)),

-- Étape 5: Signature et délivrance
('Signature et délivrance', 'Le titre foncier est finalement signé et délivré au bénéficiaire, officialisant sa propriété définitive. Après l''enregistrement, un titre foncier est délivré, garantissant un droit de propriété définitif et inattaquable.', 5,
 (SELECT id FROM procedures WHERE nom = 'Titre provisoire en titre foncier (CUH, CRH et contrat de bail avec promesse de vente)' LIMIT 1));

-- ============================================
-- 3.179. DOCUMENTS REQUIS POUR TITRE PROVISOIRE EN TITRE FONCIER
-- ============================================

INSERT INTO documents_requis (nom, description, est_obligatoire, procedure_id) VALUES
('Demande de transformation', 'Une demande écrite adressée aux autorités compétentes (DNDC/DRDC)', 
 (SELECT id FROM procedures WHERE nom = 'Titre provisoire en titre foncier (CUH, CRH et contrat de bail avec promesse de vente)' LIMIT 1)),

('Titre provisoire original et copie certifiée', 'L''original et une copie certifiée conforme du CUH, du CRH ou du contrat de bail avec promesse de vente', 
 (SELECT id FROM procedures WHERE nom = 'Titre provisoire en titre foncier (CUH, CRH et contrat de bail avec promesse de vente)' LIMIT 1)),

('Certificat de validation', 'Une réquisition de renseignement validée', 
 (SELECT id FROM procedures WHERE nom = 'Titre provisoire en titre foncier (CUH, CRH et contrat de bail avec promesse de vente)' LIMIT 1)),

('Attestation de mise en valeur', 'Un document attestant que la parcelle a été mise en valeur conformément aux règles d''urbanisme', 
 (SELECT id FROM procedures WHERE nom = 'Titre provisoire en titre foncier (CUH, CRH et contrat de bail avec promesse de vente)' LIMIT 1)),

('Pièces d''identité', 'Copie légalisée de la carte d''identité ou du passeport du demandeur', 
 (SELECT id FROM procedures WHERE nom = 'Titre provisoire en titre foncier (CUH, CRH et contrat de bail avec promesse de vente)' LIMIT 1)),

('Plans cadastraux', 'Plans de délimitation de la parcelle, disponibles auprès des services du Cadastre', 
 (SELECT id FROM procedures WHERE nom = 'Titre provisoire en titre foncier (CUH, CRH et contrat de bail avec promesse de vente)' LIMIT 1));

-- ============================================
-- 3.180. COÛTS DE LA PROCÉDURE TITRE PROVISOIRE EN TITRE FONCIER
-- ============================================

-- Insertion des coûts
INSERT INTO couts (nom, prix, description) VALUES
('Droit d''enregistrement - Transformation', 0, 'Droit d''enregistrement : 15% du prix de la parcelle'),
('Droit de mutation - Transformation', 0, 'Droit de mutation : 0,9% du prix de la parcelle'),
('Droit de timbre - Transformation', 12000, 'Droit de timbre : 12 000 FCFA (2 feuilles de 1 500 FCFA)'),
('Frais supplémentaires - Transformation', 0, 'Des frais supplémentaires peuvent s''appliquer pour les plans cadastraux, les enquêtes et autres formalités administratives'),
('Coût total estimé - Transformation', 0, 'Coût total variable selon le prix de la parcelle - Inclut droits d''enregistrement, mutation, timbre et frais supplémentaires');

-- Association du coût principal à la procédure
UPDATE procedures 
SET cout_id = (SELECT id FROM couts WHERE nom = 'Coût total estimé - Transformation' LIMIT 1)
WHERE nom = 'Titre provisoire en titre foncier (CUH, CRH et contrat de bail avec promesse de vente)';

-- ============================================
-- 3.181. CENTRES POUR TITRE PROVISOIRE EN TITRE FONCIER
-- ============================================

-- Ajout des centres spécifiques pour transformation de titre
INSERT INTO centres (nom, adresse, horaires, telephone, email, date_creation) VALUES
('Direction Nationale des Domaines et du Cadastre (DNDC)', 'Bamako', 'Lundi-Vendredi: 8h-16h', 'Contactez la DNDC', 'dndc@mali.ml', NOW()),
('Directions Régionales des Domaines et du Cadastre (DRDC)', 'Régions', 'Lundi-Vendredi: 8h-16h', 'Contactez la DRDC', 'drdc@mali.ml', NOW()),
('Domaine Cadastre de Kati', 'Kati', 'Lundi-Vendredi: 8h-16h', 'Contactez le Domaine Cadastre de Kati', 'cadastre.kati@mali.ml', NOW());

-- Association du centre principal à la procédure
UPDATE procedures 
SET centre_id = (SELECT id FROM centres WHERE nom = 'Direction Nationale des Domaines et du Cadastre (DNDC)' LIMIT 1)
WHERE nom = 'Titre provisoire en titre foncier (CUH, CRH et contrat de bail avec promesse de vente)';

-- ============================================
-- 3.182. ARTICLES DE LOI POUR TITRE PROVISOIRE EN TITRE FONCIER
-- ============================================

INSERT INTO lois_articles (description, consulter_article, procedure_id) VALUES
-- Code Domanial et Foncier - Ordonnance n°00-027/P-RM du 22 mars 2000
('Code Domanial et Foncier - Ordonnance n°00-027/P-RM du 22 mars 2000', 
 'Code Domanial et Foncier. L''Ordonnance n°00-027/P-RM du 22 mars 2000, qui régit les procédures et les droits fonciers au Mali.',
 (SELECT id FROM procedures WHERE nom = 'Titre provisoire en titre foncier (CUH, CRH et contrat de bail avec promesse de vente)' LIMIT 1)),

-- Loi n°02-016 du 03 juin 2002
('Loi n°02-016 du 03 juin 2002', 
 'Loi n°02-016 du 03 juin 2002. Fixe les règles générales de l''urbanisme et est pertinente pour les CUH.',
 (SELECT id FROM procedures WHERE nom = 'Titre provisoire en titre foncier (CUH, CRH et contrat de bail avec promesse de vente)' LIMIT 1)),

-- Décret n°01-040/P-RM du 02 février 2002
('Décret n°01-040/P-RM du 02 février 2002', 
 'Décret n°01-040/P-RM du 02 février 2002. Détermine les conditions d''attribution des terrains du domaine privé de l''État.',
 (SELECT id FROM procedures WHERE nom = 'Titre provisoire en titre foncier (CUH, CRH et contrat de bail avec promesse de vente)' LIMIT 1));

-- ============================================
-- 3.183. PROCÉDURE: APPEL D'UNE DÉCISION DE JUSTICE
-- ============================================

-- Insertion de la procédure
INSERT INTO procedures (nom, titre, delai, description, categorie_id, sous_categorie_id, date_creation) VALUES
('Appel d''une décision de justice', 'Faire appel d''un jugement', 'Délai d''appel : 10 jours après le prononcé du jugement (ou après la signification dans certains cas)', 
 'Pour faire appel d''une décision de justice au Mali, il est nécessaire de suivre une procédure rigoureuse. L''appel permet de faire réexaminer le jugement par une juridiction supérieure, généralement la cour d''appel. Conditions de l''appel : Avoir qualité d''appelant (personne insatisfaite de la décision), respecter les délais (généralement 10 jours après le prononcé du jugement), tenir compte des formalités selon les règles de procédure en vigueur au Mali. Le délai de traitement par la cour d''appel peut varier considérablement, car il dépend de la charge de travail du tribunal et de la complexité de l''affaire. Il est fortement recommandé de consulter un avocat malien spécialisé pour vous guider dans la rédaction des documents, la préparation des arguments et le suivi des délais.',
 (SELECT id FROM categories WHERE titre = 'Justice' LIMIT 1),
 (SELECT id FROM sous_categories WHERE titre = 'Demande d''appel d''une décision de jugement' LIMIT 1),
 NOW());

-- ============================================
-- 3.184. ÉTAPES DE LA PROCÉDURE APPEL D'UNE DÉCISION DE JUSTICE
-- ============================================

INSERT INTO etapes (nom, description, niveau, procedure_id) VALUES
-- Étape 1: Notification de la décision
('Notification de la décision', 'Attendez la notification officielle du jugement de première instance. Assurez-vous d''avoir qualité d''appelant (être une personne insatisfaite de la décision) et de respecter les délais légaux.', 1,
 (SELECT id FROM procedures WHERE nom = 'Appel d''une décision de justice' LIMIT 1)),

-- Étape 2: Déclaration d'appel
('Déclaration d''appel', 'Formez l''appel au greffe de la juridiction qui a rendu le jugement initial (par exemple, le tribunal de première instance) dans le délai imparti. Rédigez un acte de déclaration d''appel avec l''aide d''un avocat ou du greffier, incluant vos coordonnées, celles de la partie adverse, la date du jugement contesté, ainsi que le motif de l''appel.', 2,
 (SELECT id FROM procedures WHERE nom = 'Appel d''une décision de justice' LIMIT 1)),

-- Étape 3: Dépôt des documents et conclusions
('Dépôt des documents et conclusions', 'Une fois la déclaration déposée, rédigez des conclusions détaillées expliquant les raisons pour lesquelles vous demandez la réformation ou l''annulation du jugement. Ces conclusions doivent être soumises au greffe de la cour d''appel dans les délais légaux. Basez-vous sur les faits de l''affaire, les arguments juridiques solides et la jurisprudence pertinente.', 3,
 (SELECT id FROM procedures WHERE nom = 'Appel d''une décision de justice' LIMIT 1)),

-- Étape 4: Échange de conclusions et de pièces
('Échange de conclusions et de pièces', 'Les parties échangent des conclusions et des pièces en vue de l''audience. La procédure d''appel inclut un échange de pièces et de conclusions avec la partie adverse pour instruire l''affaire. Payez les frais de justice généralement exigés pour le traitement de l''appel.', 4,
 (SELECT id FROM procedures WHERE nom = 'Appel d''une décision de justice' LIMIT 1)),

-- Étape 5: Audience d'appel
('Audience d''appel', 'Après l''échange des pièces et des arguments, une audience de plaidoirie est fixée devant la cour d''appel. Présentez vos arguments lors de cette audience de plaidoirie.', 5,
 (SELECT id FROM procedures WHERE nom = 'Appel d''une décision de justice' LIMIT 1)),

-- Étape 6: Décision
('Décision', 'À l''issue de l''audience, la cour d''appel rendra sa décision, qui peut confirmer, infirmer ou annuler le jugement de première instance. La cour d''appel rend sa décision, qui peut confirmer, infirmer ou annuler le jugement de première instance.', 6,
 (SELECT id FROM procedures WHERE nom = 'Appel d''une décision de justice' LIMIT 1));

-- ============================================
-- 3.185. DOCUMENTS REQUIS POUR APPEL D'UNE DÉCISION DE JUSTICE
-- ============================================

INSERT INTO documents_requis (nom, description, est_obligatoire, procedure_id) VALUES
('Copie du jugement', 'Une copie scellée et signifiée de la décision de première instance dont vous faites appel', 
 (SELECT id FROM procedures WHERE nom = 'Appel d''une décision de justice' LIMIT 1)),

('Déclaration d''appel', 'L''acte de déclaration d''appel déposé au greffe, rédigé avec l''aide d''un avocat ou du greffier', 
 (SELECT id FROM procedures WHERE nom = 'Appel d''une décision de justice' LIMIT 1)),

('Conclusions écrites', 'Les conclusions écrites exposant vos arguments juridiques et vos motifs d''appel', 
 (SELECT id FROM procedures WHERE nom = 'Appel d''une décision de justice' LIMIT 1)),

('Pièces justificatives', 'Toutes les pièces et preuves pertinentes à l''affaire', 
 (SELECT id FROM procedures WHERE nom = 'Appel d''une décision de justice' LIMIT 1)),

('Mandat d''avocat', 'Un mandat si vous êtes représenté par un avocat', 
 (SELECT id FROM procedures WHERE nom = 'Appel d''une décision de justice' LIMIT 1)),

('Preuve de paiement des frais', 'Preuve du paiement des frais de justice exigés pour le traitement de l''appel', 
 (SELECT id FROM procedures WHERE nom = 'Appel d''une décision de justice' LIMIT 1));

-- ============================================
-- 3.186. COÛTS DE LA PROCÉDURE APPEL D'UNE DÉCISION DE JUSTICE
-- ============================================

-- Insertion des coûts
INSERT INTO couts (nom, prix, description) VALUES
('Frais de justice - Appel', 0, 'Des frais de justice sont généralement exigés pour le traitement de l''appel'),
('Honoraires d''avocat - Appel', 0, 'Les coûts varient en fonction de la complexité du dossier et des honoraires d''avocat'),
('Frais de procédure - Appel', 0, 'Frais de procédure à discuter directement avec le greffe'),
('Timbre fiscal - Appel', 0, 'Timbre fiscal requis pour la procédure d''appel'),
('Coût total estimé - Appel', 0, 'Coût total variable selon la complexité du dossier, des honoraires d''avocat et des frais de justice');

-- Association du coût principal à la procédure
UPDATE procedures 
SET cout_id = (SELECT id FROM couts WHERE nom = 'Coût total estimé - Appel' LIMIT 1)
WHERE nom = 'Appel d''une décision de justice';

-- ============================================
-- 3.187. CENTRES POUR APPEL D'UNE DÉCISION DE JUSTICE
-- ============================================

-- Ajout des centres spécifiques pour appel
INSERT INTO centres (nom, adresse, horaires, telephone, email, date_creation) VALUES
('Cour d''appel de Bamako', 'Bamako', 'Lundi-Vendredi: 8h-16h', 'Contactez la Cour d''appel', 'cour.appel@mali.ml', NOW()),
('Greffe du tribunal de première instance', 'Tribunaux de première instance', 'Lundi-Vendredi: 8h-16h', 'Contactez le greffe du tribunal', 'greffe.tpi@mali.ml', NOW()),
('Ministère de la Justice et des Droits de l''Homme', 'Bamako', 'Lundi-Vendredi: 8h-16h', 'Contactez le Ministère de la Justice', 'justice@mali.ml', NOW());

-- Association du centre principal à la procédure
UPDATE procedures 
SET centre_id = (SELECT id FROM centres WHERE nom = 'Cour d''appel de Bamako' LIMIT 1)
WHERE nom = 'Appel d''une décision de justice';

-- ============================================
-- 3.188. ARTICLES DE LOI POUR APPEL D'UNE DÉCISION DE JUSTICE
-- ============================================

INSERT INTO lois_articles (description, consulter_article, procedure_id) VALUES
-- Code de procédure civile, commerciale et sociale
('Code de procédure civile, commerciale et sociale', 
 'Code de procédure civile, commerciale et sociale. La procédure d''appel au Mali est principalement régie par le Code de procédure civile, commerciale et sociale. Les articles concernant l''appel peuvent varier en fonction du type d''affaire.',
 (SELECT id FROM procedures WHERE nom = 'Appel d''une décision de justice' LIMIT 1)),

-- Code de procédure pénale
('Code de procédure pénale', 
 'Code de procédure pénale. La procédure d''appel au Mali est également régie par le Code de procédure pénale pour les affaires pénales. Les articles concernant l''appel peuvent varier en fonction du type d''affaire.',
 (SELECT id FROM procedures WHERE nom = 'Appel d''une décision de justice' LIMIT 1));

-- ============================================
-- 3.189. PROCÉDURE: AUTORISATION DE VENTE DES BIENS D'UN MINEUR
-- ============================================

-- Insertion de la procédure
INSERT INTO procedures (nom, titre, delai, description, categorie_id, sous_categorie_id, date_creation) VALUES
('Autorisation de vente des biens d''un mineur', 'Obtenir une autorisation judiciaire pour vendre les biens d''un mineur', 'Délais variables selon la charge de travail du tribunal et la complexité du dossier', 
 'Pour vendre les biens d''un mineur, une autorisation est nécessaire en raison de son incapacité juridique à effectuer des actes de disposition importants. La procédure à suivre dépend du régime de protection du mineur (administration légale ou tutelle) et du type de bien concerné. Sous l''autorité parentale, la vente d''un bien immobilier ou d''un autre bien de valeur est strictement encadrée par la loi et nécessite l''approbation du juge des tutelles. Si le mineur est placé sous tutelle, la procédure de vente est similaire, mais c''est le conseil de famille qui autorise la vente, sous le contrôle du juge. L''argent provenant de la vente est placé sur un compte bloqué au nom du mineur. Il ne peut être utilisé que dans son intérêt, et chaque utilisation doit être justifiée. Si la vente est réalisée sans l''autorisation nécessaire, l''acte est nul, et le mineur pourra l''annuler à sa majorité.',
 (SELECT id FROM categories WHERE titre = 'Justice' LIMIT 1),
 (SELECT id FROM sous_categories WHERE titre = 'Autorisation de vente des biens d''un mineur' LIMIT 1),
 NOW());

-- ============================================
-- 3.190. ÉTAPES DE LA PROCÉDURE AUTORISATION DE VENTE DES BIENS D'UN MINEUR
-- ============================================

INSERT INTO etapes (nom, description, niveau, procedure_id) VALUES
-- Étape 1: Réunion du Conseil de Famille
('Réunion du Conseil de Famille', 'Les parents et les membres de la famille concernés doivent se réunir pour discuter de la nécessité et des modalités de la vente. Le Conseil de Famille doit consigner sa décision dans un procès-verbal. Ce document, qui constitue la pièce maîtresse du dossier, doit motiver la vente et en fixer les clauses, notamment le prix.', 1,
 (SELECT id FROM procedures WHERE nom = 'Autorisation de vente des biens d''un mineur' LIMIT 1)),

-- Étape 2: Requête au juge
('Requête au juge', 'Le représentant légal du mineur (un des parents ou le tuteur) doit déposer une requête auprès du juge des tutelles, ou du président du tribunal de première instance, pour solliciter l''homologation du procès-verbal du Conseil de Famille. La requête doit être motivée et expliquer pourquoi la vente est dans l''intérêt de l''enfant.', 2,
 (SELECT id FROM procedures WHERE nom = 'Autorisation de vente des biens d''un mineur' LIMIT 1)),

-- Étape 3: Instruction du dossier par le juge
('Instruction du dossier par le juge', 'Le juge examine le dossier pour s''assurer que la vente est bien dans l''intérêt supérieur du mineur. Il peut demander des informations supplémentaires ou ordonner une enquête si nécessaire. Le juge vérifie les raisons de la vente (par exemple, pour payer des études, des soins médicaux ou un réinvestissement) et le projet de réemploi des fonds.', 3,
 (SELECT id FROM procedures WHERE nom = 'Autorisation de vente des biens d''un mineur' LIMIT 1)),

-- Étape 4: Ordonnance du juge
('Ordonnance du juge', 'Si le juge est convaincu de l''intérêt de la vente, il rend une ordonnance qui l''autorise. Le juge rendra une ordonnance autorisant la vente après avoir examiné le dossier et s''être assuré que la transaction est dans l''intérêt supérieur du mineur.', 4,
 (SELECT id FROM procedures WHERE nom = 'Autorisation de vente des biens d''un mineur' LIMIT 1)),

-- Étape 5: Signature de l'acte notarié
('Signature de l''acte notarié', 'L''acte de vente peut être signé chez un notaire seulement après l''obtention de l''ordonnance du juge. Le notaire est un acteur clé de cette transaction pour s''assurer du respect des procédures légales.', 5,
 (SELECT id FROM procedures WHERE nom = 'Autorisation de vente des biens d''un mineur' LIMIT 1)),

-- Étape 6: Réinvestissement des fonds
('Réinvestissement des fonds', 'Le produit de la vente doit être géré dans l''intérêt exclusif du mineur, souvent par le placement sur un compte bloqué. L''utilisation des fonds pour d''autres fins que le bien-être du mineur nécessite également une autorisation spéciale du juge. Le responsable légal (parent ou tuteur) a l''obligation de rendre des comptes sur la gestion des biens du mineur.', 6,
 (SELECT id FROM procedures WHERE nom = 'Autorisation de vente des biens d''un mineur' LIMIT 1));

-- ============================================
-- 3.191. DOCUMENTS REQUIS POUR AUTORISATION DE VENTE DES BIENS D'UN MINEUR
-- ============================================

INSERT INTO documents_requis (nom, description, est_obligatoire, procedure_id) VALUES
('Procès-verbal du Conseil de Famille', 'Le procès-verbal du Conseil de Famille, signé par les membres présents, qui constitue la pièce maîtresse du dossier', 
 (SELECT id FROM procedures WHERE nom = 'Autorisation de vente des biens d''un mineur' LIMIT 1)),

('Pièces d''identité du représentant légal', 'Une copie des pièces d''identité du représentant légal et des membres du Conseil de Famille', 
 (SELECT id FROM procedures WHERE nom = 'Autorisation de vente des biens d''un mineur' LIMIT 1)),

('Acte de naissance du mineur', 'L''acte de naissance du mineur', 
 (SELECT id FROM procedures WHERE nom = 'Autorisation de vente des biens d''un mineur' LIMIT 1)),

('Documents de propriété du bien', 'Les documents attestant la propriété du bien (par exemple, le titre foncier)', 
 (SELECT id FROM procedures WHERE nom = 'Autorisation de vente des biens d''un mineur' LIMIT 1)),

('Estimation de la valeur du bien', 'Une estimation de la valeur du bien, si possible', 
 (SELECT id FROM procedures WHERE nom = 'Autorisation de vente des biens d''un mineur' LIMIT 1)),

('Plan de réemploi des fonds', 'Un plan de réemploi des fonds, expliquant comment l''argent sera investi au profit du mineur', 
 (SELECT id FROM procedures WHERE nom = 'Autorisation de vente des biens d''un mineur' LIMIT 1)),

('Requête motivée au juge', 'Une requête motivée adressée au juge des tutelles expliquant pourquoi la vente est dans l''intérêt de l''enfant', 
 (SELECT id FROM procedures WHERE nom = 'Autorisation de vente des biens d''un mineur' LIMIT 1));

-- ============================================
-- 3.192. COÛTS DE LA PROCÉDURE AUTORISATION DE VENTE DES BIENS D'UN MINEUR
-- ============================================

-- Insertion des coûts
INSERT INTO couts (nom, prix, description) VALUES
('Frais de justice - Vente mineur', 0, 'Les coûts se composent principalement des frais de justice pour l''instruction du dossier'),
('Honoraires du notaire - Vente mineur', 0, 'Honoraires du notaire pour la rédaction de l''acte de vente'),
('Frais de procédure - Vente mineur', 0, 'Frais de procédure variables selon le tribunal compétent'),
('Frais de conservation foncière - Vente mineur', 0, 'Frais de conservation foncière pour les biens immobiliers'),
('Coût total estimé - Vente mineur', 0, 'Coût total variable selon la valeur du bien - Il n''existe pas de tarif unique, et les montants varient en fonction de la valeur du bien');

-- Association du coût principal à la procédure
UPDATE procedures 
SET cout_id = (SELECT id FROM couts WHERE nom = 'Coût total estimé - Vente mineur' LIMIT 1)
WHERE nom = 'Autorisation de vente des biens d''un mineur';

-- ============================================
-- 3.193. CENTRES POUR AUTORISATION DE VENTE DES BIENS D'UN MINEUR
-- ============================================

-- Ajout des centres spécifiques pour vente des biens de mineur
INSERT INTO centres (nom, adresse, horaires, telephone, email, date_creation) VALUES
('Tribunal de première instance', 'Tribunaux de première instance', 'Lundi-Vendredi: 8h-16h', 'Contactez le tribunal compétent', 'tpi@mali.ml', NOW()),
('Greffe du tribunal de première instance', 'Greffe du tribunal de première instance du lieu de résidence du mineur', 'Lundi-Vendredi: 8h-16h', 'Contactez le greffe du tribunal', 'greffe.tpi@mali.ml', NOW()),
('Notaire', 'Notaires agréés', 'Lundi-Vendredi: 8h-16h', 'Contactez un notaire agréé', 'notaire@mali.ml', NOW()),
('Conservation Foncière', 'Conservation Foncière', 'Lundi-Vendredi: 8h-16h', 'Contactez la Conservation Foncière', 'conservation.fonciere@mali.ml', NOW());

-- Association du centre principal à la procédure
UPDATE procedures 
SET centre_id = (SELECT id FROM centres WHERE nom = 'Tribunal de première instance' LIMIT 1)
WHERE nom = 'Autorisation de vente des biens d''un mineur';

-- ============================================
-- 3.194. ARTICLES DE LOI POUR AUTORISATION DE VENTE DES BIENS D'UN MINEUR
-- ============================================

INSERT INTO lois_articles (description, consulter_article, procedure_id) VALUES
-- Code des Personnes et de la Famille du Mali
('Code des Personnes et de la Famille du Mali', 
 'Code des Personnes et de la Famille du Mali. La procédure est encadrée par le Code des Personnes et de la Famille du Mali. Les articles relatifs à la tutelle, à l''administration légale et aux actes de disposition des biens des mineurs y sont clairement définis.',
 (SELECT id FROM procedures WHERE nom = 'Autorisation de vente des biens d''un mineur' LIMIT 1));

-- ============================================
-- 3.195. PROCÉDURE: RACCORDEMENT ET INSTALLATION D'UN COMPTEUR D'EAU
-- ============================================

-- Insertion de la procédure
INSERT INTO procedures (nom, titre, delai, description, categorie_id, sous_categorie_id, date_creation) VALUES
('Raccordement et installation d''un compteur d''eau', 'Installer un nouveau compteur d''eau', 'Plusieurs semaines (délai variable selon la complexité des travaux et les autorisations administratives)', 
 'Pour une demande de raccordement et l''installation d''un compteur d''eau au Mali, vous devez contacter la Société Malienne de Gestion de l''Eau Potable (SOMAGEP-SA). Le processus est mené par l''agence commerciale de la SOMAGEP-SA et nécessite de fournir plusieurs documents. Il n''existe pas de coût fixe et légal unique pour le raccordement. Le montant est déterminé après l''étude de faisabilité et l''établissement d''un devis par la SOMAGEP-SA, qui chiffre le matériel et les travaux nécessaires. Les frais sont basés sur le bordereau de prix en vigueur de la société. Le délai de traitement peut varier en fonction de la complexité des travaux et des autorisations administratives. Il est conseillé de prévoir plusieurs semaines pour l''ensemble du processus, depuis le dépôt de la demande jusqu''à la mise en service du compteur.',
 (SELECT id FROM categories WHERE titre = 'Eau et électricité' LIMIT 1),
 (SELECT id FROM sous_categories WHERE titre = 'Demande d''un compteur d''eau' LIMIT 1),
 NOW());

-- ============================================
-- 3.196. ÉTAPES DE LA PROCÉDURE RACCORDEMENT ET INSTALLATION D'UN COMPTEUR D'EAU
-- ============================================

INSERT INTO etapes (nom, description, niveau, procedure_id) VALUES
-- Étape 1: Préparation du dossier
('Préparation du dossier', 'Rassemblez tous les documents nécessaires pour votre demande de branchement. Préparez une demande manuscrite rédigée par le propriétaire de l''habitation ou du terrain, une copie légalisée de votre pièce d''identité, une attestation de propriété, et si vous êtes locataire, une autorisation signée et légalisée du propriétaire.', 1,
 (SELECT id FROM procedures WHERE nom = 'Raccordement et installation d''un compteur d''eau' LIMIT 1)),

-- Étape 2: Dépôt du dossier
('Dépôt du dossier', 'Déposez votre dossier de demande complet auprès de l''agence commerciale de la SOMAGEP-SA la plus proche de votre domicile ou du terrain concerné. Présentez-vous à l''agence commerciale de la SOMAGEP-SA avec tous les documents nécessaires pour la demande de branchement et de compteur.', 2,
 (SELECT id FROM procedures WHERE nom = 'Raccordement et installation d''un compteur d''eau' LIMIT 1)),

-- Étape 3: Étude de faisabilité
('Étude de faisabilité', 'Une fois votre demande déposée, une étude technique est menée sur place par les services de la SOMAGEP-SA pour évaluer la faisabilité du branchement. Un agent de la SOMAGEP-SA se déplacera sur les lieux pour une étude technique et évaluer les spécificités du site.', 3,
 (SELECT id FROM procedures WHERE nom = 'Raccordement et installation d''un compteur d''eau' LIMIT 1)),

-- Étape 4: Établissement du devis
('Établissement du devis', 'Un devis chiffrant le coût des travaux de raccordement est établi en fonction des spécificités du site. Les frais de raccordement ne sont pas fixes et sont déterminés par un devis établi après la visite d''un agent de la SOMAGEP-SA. Le montant est basé sur le bordereau de prix en vigueur de la société.', 4,
 (SELECT id FROM procedures WHERE nom = 'Raccordement et installation d''un compteur d''eau' LIMIT 1)),

-- Étape 5: Paiement des frais
('Paiement des frais', 'Après acceptation du devis, vous devez régler les frais de branchement auprès de l''agence. Les frais sont basés sur le bordereau de prix en vigueur de la société et incluent le matériel et les travaux nécessaires.', 5,
 (SELECT id FROM procedures WHERE nom = 'Raccordement et installation d''un compteur d''eau' LIMIT 1)),

-- Étape 6: Réalisation des travaux
('Réalisation des travaux', 'Les équipes de la SOMAGEP-SA procèdent à l''installation du branchement et du compteur. La pose du branchement et du compteur est réalisée par la société. Préparez un espace dédié pour accueillir le compteur, généralement près de la limite de votre propriété. Le raccordement et la pose du compteur auront lieu une fois les autorisations délivrées.', 6,
 (SELECT id FROM procedures WHERE nom = 'Raccordement et installation d''un compteur d''eau' LIMIT 1));

-- ============================================
-- 3.197. DOCUMENTS REQUIS POUR RACCORDEMENT ET INSTALLATION D'UN COMPTEUR D'EAU
-- ============================================

INSERT INTO documents_requis (nom, description, est_obligatoire, procedure_id) VALUES
('Demande manuscrite', 'Une demande manuscrite rédigée par le propriétaire de l''habitation ou du terrain, adressée au Directeur de l''agence concernée', 
 (SELECT id FROM procedures WHERE nom = 'Raccordement et installation d''un compteur d''eau' LIMIT 1)),

('Copie légalisée de la pièce d''identité', 'Une copie légalisée de la pièce d''identité du demandeur (carte d''identité, passeport ou permis de conduire)', 
 (SELECT id FROM procedures WHERE nom = 'Raccordement et installation d''un compteur d''eau' LIMIT 1)),

('Attestation de propriété', 'Une attestation de propriété du domaine à alimenter, document prouvant que vous êtes bien le propriétaire du lieu à alimenter', 
 (SELECT id FROM procedures WHERE nom = 'Raccordement et installation d''un compteur d''eau' LIMIT 1)),

('Autorisation du propriétaire', 'Si vous êtes locataire, une autorisation signée et légalisée du propriétaire est nécessaire', 
 (SELECT id FROM procedures WHERE nom = 'Raccordement et installation d''un compteur d''eau' LIMIT 1)),

('Plan de situation et cadastral', 'Des documents techniques indiquant l''emplacement de la parcelle, le cas échéant, les références cadastrales de la parcelle', 
 (SELECT id FROM procedures WHERE nom = 'Raccordement et installation d''un compteur d''eau' LIMIT 1));

-- ============================================
-- 3.198. COÛTS DE LA PROCÉDURE RACCORDEMENT ET INSTALLATION D'UN COMPTEUR D'EAU
-- ============================================

-- Insertion des coûts
INSERT INTO couts (nom, prix, description) VALUES
('Frais de raccordement - Eau', 0, 'Frais de raccordement déterminés par devis après étude de faisabilité'),
('Matériel et travaux - Eau', 0, 'Coût du matériel et des travaux nécessaires selon le bordereau de prix en vigueur'),
('Frais d''étude technique - Eau', 0, 'Frais d''étude technique et de faisabilité par la SOMAGEP-SA'),
('Frais d''installation - Eau', 0, 'Frais d''installation du branchement et du compteur'),
('Coût total estimé - Eau', 0, 'Coût total variable selon devis - Il n''existe pas de coût fixe et légal unique, le montant est déterminé après l''étude de faisabilité');

-- Association du coût principal à la procédure
UPDATE procedures 
SET cout_id = (SELECT id FROM couts WHERE nom = 'Coût total estimé - Eau' LIMIT 1)
WHERE nom = 'Raccordement et installation d''un compteur d''eau';

-- ============================================
-- 3.199. CENTRES POUR RACCORDEMENT ET INSTALLATION D'UN COMPTEUR D'EAU
-- ============================================

-- Ajout des centres spécifiques pour raccordement eau
INSERT INTO centres (nom, adresse, horaires, telephone, email, date_creation) VALUES
('SOMAGEP-SA - Siège', 'Djicoroni Troukabougou, Bamako', 'Lundi-Vendredi: 8h-16h', '80 00 20 20', 'contact@somagep-sa.ml', NOW()),
('Agence commerciale SOMAGEP-SA', 'Agences commerciales SOMAGEP-SA', 'Lundi-Vendredi: 8h-16h', '80 00 20 20', 'agence@somagep-sa.ml', NOW()),
('SOMAGEP-SA - Service client', 'Service client SOMAGEP-SA', 'Lundi-Vendredi: 8h-16h', '80 00 20 20', 'service.client@somagep-sa.ml', NOW());

-- Association du centre principal à la procédure
UPDATE procedures 
SET centre_id = (SELECT id FROM centres WHERE nom = 'SOMAGEP-SA - Siège' LIMIT 1)
WHERE nom = 'Raccordement et installation d''un compteur d''eau';

-- ============================================
-- 3.200. ARTICLES DE LOI POUR RACCORDEMENT ET INSTALLATION D'UN COMPTEUR D'EAU
-- ============================================

INSERT INTO lois_articles (description, consulter_article, procedure_id) VALUES
-- Loi N°02-006/ du 31 janvier 2002 portant Code de l'Eau
('Loi N°02-006/ du 31 janvier 2002 portant Code de l''Eau', 
 'Loi N°02-006/ du 31 janvier 2002 portant Code de l''Eau. Cette loi établit le cadre juridique de la gestion des ressources en eau au Mali.',
 (SELECT id FROM procedures WHERE nom = 'Raccordement et installation d''un compteur d''eau' LIMIT 1)),

-- Ordonnance n°00-020/P-RM du 15 mars 2000
('Ordonnance n°00-020/P-RM du 15 mars 2000', 
 'Ordonnance n°00-020/P-RM du 15 mars 2000. Elle fixe le cadre juridique du service public de l''alimentation en eau potable.',
 (SELECT id FROM procedures WHERE nom = 'Raccordement et installation d''un compteur d''eau' LIMIT 1)),

-- Décret N° 2014-0572/P-RM du 22 juillet 2014
('Décret N° 2014-0572/P-RM du 22 juillet 2014', 
 'Décret N° 2014-0572/P-RM du 22 juillet 2014. Ce décret a transféré aux collectivités les compétences relatives à la gestion des services d''eau, bien que cela ne soit pas encore pleinement effectif dans les zones de concession de la SOMAGEP-SA.',
 (SELECT id FROM procedures WHERE nom = 'Raccordement et installation d''un compteur d''eau' LIMIT 1)),

-- Journal Officiel du Mali - Directive 2011
('Journal Officiel du Mali - Directive 2011', 
 'Journal Officiel du Mali. Les références législatives et réglementaires peuvent être retrouvées dans le Journal Officiel. Par exemple, une directive du Journal Officiel de 2011 oblige les autorités à assurer un service universel d''approvisionnement en eau potable.',
 (SELECT id FROM procedures WHERE nom = 'Raccordement et installation d''un compteur d''eau' LIMIT 1));

-- ============================================
-- 3.201. PROCÉDURE: DEMANDE D'UN COMPTEUR D'ÉLECTRICITÉ
-- ============================================

-- Insertion de la procédure
INSERT INTO procedures (nom, titre, delai, description, categorie_id, sous_categorie_id, date_creation) VALUES
('Demande d''un compteur d''électricité', 'Installer un nouveau compteur d''électricité', 'Délais variables selon la complexité du branchement et la charge de travail d''EDM-SA', 
 'Pour demander un nouveau branchement et un compteur ISAGO auprès d''Énergie du Mali (EDM-SA), la procédure se fait directement sur le site web de l''entreprise. La demande peut être initiée en ligne sur le site d''EDM-SA ou en agence. Le coût d''un nouveau branchement n''est pas fixe et dépend de l''étude technique qui est réalisée. Il est influencé par plusieurs facteurs : la distance entre la parcelle et le poteau électrique le plus proche, la charge de la ligne électrique existante, et le coût des équipements (compteur, câbles, etc.). Un devis sera établi par EDM-SA après l''étude technique. Les délais varient en fonction de la complexité du branchement, mais le processus se déroule généralement en plusieurs étapes. Il n''y a pas de délai fixe garanti, mais le suivi peut se faire via l''espace client en ligne ou en contactant le centre d''appel d''EDM-SA.',
 (SELECT id FROM categories WHERE titre = 'Eau et électricité' LIMIT 1),
 (SELECT id FROM sous_categories WHERE titre = 'Demande d''un compteur d''électricité' LIMIT 1),
 NOW());

-- ============================================
-- 3.202. ÉTAPES DE LA PROCÉDURE DEMANDE D'UN COMPTEUR D'ÉLECTRICITÉ
-- ============================================

INSERT INTO etapes (nom, description, niveau, procedure_id) VALUES
-- Étape 1: Formuler la demande
('Formuler la demande', 'La demande peut être initiée en ligne sur le site d''EDM-SA (edmsa.ml/client/nouveau-branchement) ou en agence. Rendez-vous sur le site d''EDM-SA et accédez à la page dédiée aux nouvelles demandes de branchement. Le site vous demandera de créer un compte si vous n''en avez pas déjà un.', 1,
 (SELECT id FROM procedures WHERE nom = 'Demande d''un compteur d''électricité' LIMIT 1)),

-- Étape 2: Préparer le dossier
('Préparer le dossier', 'Rassemblez les documents requis pour compléter votre dossier. Une fiche de demande d''abonnement est disponible en ligne. Remplissez le formulaire de demande en fournissant des informations précises sur le lieu d''installation souhaité.', 2,
 (SELECT id FROM procedures WHERE nom = 'Demande d''un compteur d''électricité' LIMIT 1)),

-- Étape 3: Instruction de la demande
('Instruction de la demande', 'Une équipe technique se déplace pour réaliser l''étude de faisabilité du branchement. Une fois la demande soumise, vous pouvez suivre son traitement via votre espace client sur le site d''EDM-SA. L''étude technique évalue la distance entre la parcelle et le poteau électrique le plus proche, la charge de la ligne électrique existante, et les besoins en équipements.', 3,
 (SELECT id FROM procedures WHERE nom = 'Demande d''un compteur d''électricité' LIMIT 1)),

-- Étape 4: Paiement des frais
('Paiement des frais', 'Après la validation de l''étude, vous devrez vous acquitter des frais de branchement et de l''abonnement. Un devis sera établi par EDM-SA après l''étude technique. Le délai dépend de la rapidité du demandeur pour valider le devis et effectuer le paiement.', 4,
 (SELECT id FROM procedures WHERE nom = 'Demande d''un compteur d''électricité' LIMIT 1)),

-- Étape 5: Installation du compteur
('Installation du compteur', 'Une fois le paiement effectué, l''équipe technique procède à l''installation du compteur ISAGO. Une fois le paiement confirmé, l''installation est planifiée et réalisée par les équipes d''EDM-SA.', 5,
 (SELECT id FROM procedures WHERE nom = 'Demande d''un compteur d''électricité' LIMIT 1));

-- ============================================
-- 3.203. DOCUMENTS REQUIS POUR DEMANDE D'UN COMPTEUR D'ÉLECTRICITÉ
-- ============================================

INSERT INTO documents_requis (nom, description, est_obligatoire, procedure_id) VALUES
('Pièce d''identité en cours de validité', 'Une pièce d''identité en cours de validité : carte d''identité, passeport ou carte de séjour', 
 (SELECT id FROM procedures WHERE nom = 'Demande d''un compteur d''électricité' LIMIT 1)),

('Justificatif de domicile - Propriétaire', 'Pour les propriétaires : un titre de propriété comme l''attestation de détention de parcelle ou un permis d''occuper', 
 (SELECT id FROM procedures WHERE nom = 'Demande d''un compteur d''électricité' LIMIT 1)),

('Justificatif de domicile - Locataire', 'Pour les locataires : un contrat de location dûment signé par le propriétaire et le locataire', 
 (SELECT id FROM procedures WHERE nom = 'Demande d''un compteur d''électricité' LIMIT 1)),

('Fiche de demande d''abonnement', 'Une fiche de demande d''abonnement disponible sur le site d''EDM-SA', 
 (SELECT id FROM procedures WHERE nom = 'Demande d''un compteur d''électricité' LIMIT 1)),

('Plan de situation du logement', 'Un plan de situation du logement pour faciliter le repérage de l''adresse par les techniciens d''EDM-SA', 
 (SELECT id FROM procedures WHERE nom = 'Demande d''un compteur d''électricité' LIMIT 1)),

('Permis de construire', 'Un permis de construire (dans certains cas)', 
 (SELECT id FROM procedures WHERE nom = 'Demande d''un compteur d''électricité' LIMIT 1));

-- ============================================
-- 3.204. COÛTS DE LA PROCÉDURE DEMANDE D'UN COMPTEUR D'ÉLECTRICITÉ
-- ============================================

-- Insertion des coûts
INSERT INTO couts (nom, prix, description) VALUES
('Frais de branchement - Électricité', 0, 'Frais de branchement déterminés par l''étude technique'),
('Frais d''abonnement - Électricité', 0, 'Frais d''abonnement au service électrique'),
('Coût des équipements - Électricité', 0, 'Coût des équipements (compteur ISAGO, câbles, etc.)'),
('Frais d''étude technique - Électricité', 0, 'Frais d''étude technique et de faisabilité par EDM-SA'),
('Frais d''installation - Électricité', 0, 'Frais d''installation du branchement et du compteur'),
('Coût total estimé - Électricité', 0, 'Coût total variable selon devis - Le coût dépend de la distance au poteau, de la charge de la ligne et des équipements nécessaires');

-- Association du coût principal à la procédure
UPDATE procedures 
SET cout_id = (SELECT id FROM couts WHERE nom = 'Coût total estimé - Électricité' LIMIT 1)
WHERE nom = 'Demande d''un compteur d''électricité';

-- ============================================
-- 3.205. CENTRES POUR DEMANDE D'UN COMPTEUR D'ÉLECTRICITÉ
-- ============================================

-- Ajout des centres spécifiques pour raccordement électricité
INSERT INTO centres (nom, adresse, horaires, telephone, email, date_creation) VALUES
('EDM-SA - Siège social', 'Square Patrice Lumumba, Bamako', 'Lundi-Vendredi: 8h-16h', '36077', 'contact@edmsa.ml', NOW()),
('Agences commerciales EDM-SA', 'Agences commerciales EDM-SA à Bamako', 'Lundi-Vendredi: 8h-16h', '36077', 'agence@edmsa.ml', NOW()),
('EDM-SA - Centre d''appel', 'Centre d''appel EDM-SA', 'Lundi-Vendredi: 8h-16h', '36077', 'service.client@edmsa.ml', NOW()),
('EDM-SA - Plateforme en ligne', 'edmsa.ml/client/nouveau-branchement', '24h/24', '36077', 'online@edmsa.ml', NOW());

-- Association du centre principal à la procédure
UPDATE procedures 
SET centre_id = (SELECT id FROM centres WHERE nom = 'EDM-SA - Siège social' LIMIT 1)
WHERE nom = 'Demande d''un compteur d''électricité';

-- ============================================
-- 3.206. ARTICLES DE LOI POUR DEMANDE D'UN COMPTEUR D'ÉLECTRICITÉ
-- ============================================

INSERT INTO lois_articles (description, consulter_article, procedure_id) VALUES
-- Ordonnance N°00-019/P-RM du 15 mars 2000
('Ordonnance N°00-019/P-RM du 15 mars 2000', 
 'Ordonnance N°00-019/P-RM du 15 mars 2000. Ce texte et ses décrets d''application régissent les activités électriques au Mali et définissent le cadre réglementaire dans lequel EDM-SA opère.',
 (SELECT id FROM procedures WHERE nom = 'Demande d''un compteur d''électricité' LIMIT 1)),

-- Décret N°00-184/P-RM du 14 avril 2000
('Décret N°00-184/P-RM du 14 avril 2000', 
 'Décret N°00-184/P-RM du 14 avril 2000. Fixe les modalités d''application de l''ordonnance mentionnée ci-dessus, notamment en ce qui concerne la délivrance des autorisations.',
 (SELECT id FROM procedures WHERE nom = 'Demande d''un compteur d''électricité' LIMIT 1));

-- ============================================
-- 3.207. PROCÉDURE: DEMANDE DE TRANSFÉRER D'UN COMPTEUR D'ÉLECTRICITÉ
-- ============================================

-- Insertion de la procédure
INSERT INTO procedures (nom, titre, delai, description, categorie_id, sous_categorie_id, date_creation) VALUES
('Demande de transférer d''un compteur d''électricité', 'Transférer un compteur d''électricité', 'Délais variables selon le type de demande et la complexité des travaux', 
 'Pour effectuer une demande de transfert de compteur ISAGO, vous devez vous adresser à la compagnie Énergie du Mali (EDM-SA), car ISAGO est le système de recharge prépayée utilisé au Mali. Le processus varie selon le motif du transfert (déménagement, changement d''abonnement, déplacement du compteur, etc.). Pour les locataires qui déménagent : résiliation du contrat et solde du compte. Pour les nouveaux arrivants : changement d''abonnement pour mettre le compteur à leur nom. Pour un déplacement du compteur : déplacement physique au sein du même logement. Les frais de traitement et de déplacement varient en fonction du type de demande. Le traitement de la demande de changement d''abonné peut prendre plusieurs jours ouvrables. Le délai de déplacement physique dépend de la complexité des travaux et du planning des équipes techniques d''EDM-SA.',
 (SELECT id FROM categories WHERE titre = 'Eau et électricité' LIMIT 1),
 (SELECT id FROM sous_categories WHERE titre = 'Demande de transférer d''un compteur d''électricité' LIMIT 1),
 NOW());

-- ============================================
-- 3.208. ÉTAPES DE LA PROCÉDURE DEMANDE DE TRANSFÉRER D'UN COMPTEUR D'ÉLECTRICITÉ
-- ============================================

INSERT INTO etapes (nom, description, niveau, procedure_id) VALUES
-- Étape 1: Préparation selon le type de transfert
('Préparation selon le type de transfert', 'Identifiez le type de transfert nécessaire : déménagement (changement d''abonné), nouveau arrivant (reprise de compteur existant), ou déplacement physique du compteur. Pour un déménagement, l''abonné sortant doit se présenter à l''agence EDM-SA pour résilier son contrat et solder son compte. Il peut fournir le relevé final du compteur au moment de son départ.', 1,
 (SELECT id FROM procedures WHERE nom = 'Demande de transférer d''un compteur d''électricité' LIMIT 1)),

-- Étape 2: Demande de transfert
('Demande de transfert', 'Pour un changement d''abonné : le nouvel occupant se rend à l''agence EDM-SA la plus proche pour demander un changement d''abonnement et mettre le compteur existant à son nom. Pour un déplacement physique : le client doit contacter l''agence EDM-SA pour solliciter un déplacement physique de son compteur. Rendez-vous à votre agence EDM-SA pour obtenir les formulaires nécessaires.', 2,
 (SELECT id FROM procedures WHERE nom = 'Demande de transférer d''un compteur d''électricité' LIMIT 1)),

-- Étape 3: Instruction du dossier
('Instruction du dossier', 'Le service clientèle de l''agence traitera la demande et vérifiera les informations et documents fournis. Pour un déplacement physique, un technicien d''EDM-SA sera chargé de réaliser l''évaluation des travaux et d''établir un devis. Remplissez la demande de résiliation ou la fiche de demande d''abonnement selon votre situation.', 3,
 (SELECT id FROM procedures WHERE nom = 'Demande de transférer d''un compteur d''électricité' LIMIT 1)),

-- Étape 4: Devis et accord (pour déplacement physique)
('Devis et accord (pour déplacement physique)', 'Pour un déplacement physique du compteur, un technicien de l''EDM-SA se déplacera pour évaluer les travaux et établir un devis. Le client doit donner son accord et payer les frais correspondants. L''agence relèvera l''index final de votre compteur pour permettre le calcul de votre solde et la résiliation effective du contrat.', 4,
 (SELECT id FROM procedures WHERE nom = 'Demande de transférer d''un compteur d''électricité' LIMIT 1)),

-- Étape 5: Finalisation
('Finalisation', 'Après validation, le compteur ISAGO sera réinitialisé et un nouveau compte abonné sera associé au nouvel occupant. Pour un déplacement physique, une fois le devis approuvé et payé, les équipes techniques effectuent le déplacement. Le compteur sera mis à jour et un nouveau compte sera créé si nécessaire.', 5,
 (SELECT id FROM procedures WHERE nom = 'Demande de transférer d''un compteur d''électricité' LIMIT 1));

-- ============================================
-- 3.209. DOCUMENTS REQUIS POUR DEMANDE DE TRANSFÉRER D'UN COMPTEUR D'ÉLECTRICITÉ
-- ============================================

INSERT INTO documents_requis (nom, description, est_obligatoire, procedure_id) VALUES
('Pièce d''identité valide', 'Pièce d''identité valide (carte d''identité nationale, passeport, etc.)', 
 (SELECT id FROM procedures WHERE nom = 'Demande de transférer d''un compteur d''électricité' LIMIT 1)),

('Preuve de la nouvelle occupation du logement', 'Preuve de la nouvelle occupation du logement (contrat de location, titre de propriété)', 
 (SELECT id FROM procedures WHERE nom = 'Demande de transférer d''un compteur d''électricité' LIMIT 1)),

('Formulaire de demande de changement d''abonné', 'Formulaire de demande de changement d''abonné fourni par l''agence EDM-SA', 
 (SELECT id FROM procedures WHERE nom = 'Demande de transférer d''un compteur d''électricité' LIMIT 1)),

('Relevé du compteur et numéro de l''ancien abonné', 'Relevé du compteur et le numéro de l''ancien abonné pour la clôture du compte', 
 (SELECT id FROM procedures WHERE nom = 'Demande de transférer d''un compteur d''électricité' LIMIT 1)),

('Demande de résiliation', 'Demande de résiliation pour l''abonné sortant', 
 (SELECT id FROM procedures WHERE nom = 'Demande de transférer d''un compteur d''électricité' LIMIT 1)),

('Fiche de demande d''abonnement', 'Fiche de demande d''abonnement en précisant que vous souhaitez reprendre un compteur ISAGO existant', 
 (SELECT id FROM procedures WHERE nom = 'Demande de transférer d''un compteur d''électricité' LIMIT 1));

-- ============================================
-- 3.210. COÛTS DE LA PROCÉDURE DEMANDE DE TRANSFÉRER D'UN COMPTEUR D'ÉLECTRICITÉ
-- ============================================

-- Insertion des coûts
INSERT INTO couts (nom, prix, description) VALUES
('Frais de dossier - Transfert électricité', 0, 'Des frais de dossier peuvent être appliqués pour le transfert du contrat'),
('Frais de changement d''abonné - Transfert électricité', 0, 'Frais de traitement pour le changement d''abonné'),
('Frais de déplacement physique - Transfert électricité', 0, 'Frais de déplacement physique du compteur selon devis'),
('Frais de résiliation - Transfert électricité', 0, 'Frais de résiliation du contrat pour l''abonné sortant'),
('Frais de réinitialisation - Transfert électricité', 0, 'Frais de réinitialisation du compteur ISAGO'),
('Coût total estimé - Transfert électricité', 0, 'Coût total variable selon le type de transfert - Un devis est nécessaire pour obtenir une estimation exacte');

-- Association du coût principal à la procédure
UPDATE procedures 
SET cout_id = (SELECT id FROM couts WHERE nom = 'Coût total estimé - Transfert électricité' LIMIT 1)
WHERE nom = 'Demande de transférer d''un compteur d''électricité';

-- ============================================
-- 3.211. CENTRES POUR DEMANDE DE TRANSFÉRER D'UN COMPTEUR D'ÉLECTRICITÉ
-- ============================================

-- Ajout des centres spécifiques pour transfert électricité
INSERT INTO centres (nom, adresse, horaires, telephone, email, date_creation) VALUES
('EDM-SA - Agences Bamako Rive Gauche', 'Agences EDM-SA Rive Gauche, Bamako', 'Lundi-Vendredi: 8h-16h', '36077', 'agence.rg@edmsa.ml', NOW()),
('EDM-SA - Agences Bamako Rive Droite', 'Agences EDM-SA Rive Droite, Bamako', 'Lundi-Vendredi: 8h-16h', '36077', 'agence.rd@edmsa.ml', NOW()),
('EDM-SA - Agences régionales', 'Agences EDM-SA dans les régions', 'Lundi-Vendredi: 8h-16h', '36077', 'agence.region@edmsa.ml', NOW()),
('EDM-SA - Service client transfert', 'Service client EDM-SA pour transferts', 'Lundi-Vendredi: 8h-16h', '36077', 'transfert@edmsa.ml', NOW());

-- Association du centre principal à la procédure
UPDATE procedures 
SET centre_id = (SELECT id FROM centres WHERE nom = 'EDM-SA - Agences Bamako Rive Gauche' LIMIT 1)
WHERE nom = 'Demande de transférer d''un compteur d''électricité';

-- ============================================
-- 3.212. ARTICLES DE LOI POUR DEMANDE DE TRANSFÉRER D'UN COMPTEUR D'ÉLECTRICITÉ
-- ============================================

INSERT INTO lois_articles (description, consulter_article, procedure_id) VALUES
-- Loi n°04-055 du 25 octobre 2004
('Loi n°04-055 du 25 octobre 2004', 
 'Loi n°04-055 du 25 octobre 2004 portant organisation du secteur de l''électricité. La gestion et la régulation de la fourniture d''électricité au Mali sont encadrées par des textes législatifs. Cette loi est un texte de référence pour le secteur électrique.',
 (SELECT id FROM procedures WHERE nom = 'Demande de transférer d''un compteur d''électricité' LIMIT 1)),

-- Conditions Générales de Vente d'EDM-SA
('Conditions Générales de Vente d''EDM-SA', 
 'Conditions Générales de Vente d''EDM-SA. Le contrat d''abonnement est régi par les conditions générales de vente d''EDM-SA, qui définissent les droits et obligations du client et du fournisseur.',
 (SELECT id FROM procedures WHERE nom = 'Demande de transférer d''un compteur d''électricité' LIMIT 1)),

-- Fiche d'autorisation de branchement
('Fiche d''autorisation de branchement (DCC IS 012.01b-04)', 
 'Fiche d''autorisation de branchement (DCC IS 012.01b-04). Des documents spécifiques comme la Fiche d''autorisation de branchement sont également des références administratives pour les procédures de transfert.',
 (SELECT id FROM procedures WHERE nom = 'Demande de transférer d''un compteur d''électricité' LIMIT 1));

-- ============================================
-- 3.213. PROCÉDURE: DEMANDE DE TRANSFÉRER D'UN COMPTEUR D'EAU
-- ============================================

-- Insertion de la procédure
INSERT INTO procedures (nom, titre, delai, description, categorie_id, sous_categorie_id, date_creation) VALUES
('Demande de transférer d''un compteur d''eau', 'Transférer un compteur d''eau', 'Plusieurs jours à quelques semaines (délai variable selon la charge de travail et les contraintes techniques)', 
 'Pour transférer un compteur d''eau au Mali, il n''est pas possible de simplement changer le nom sur un contrat existant. Le nouvel occupant doit plutôt souscrire un nouveau contrat à son nom auprès de la Société Malienne de Gestion de l''Eau Potable (SOMAGEP-SA), tandis que l''ancien occupant doit résilier le sien. L''ancien occupant est responsable de la résiliation de son contrat d''eau et doit contacter la SOMAGEP-SA pour l''informer de son départ. Il devra fournir un relevé final du compteur d''eau pour que le service puisse établir la facture de clôture. Le nouvel occupant doit suivre la procédure de branchement de la SOMAGEP-SA. Les frais sont variables et incluent le coût du branchement, les frais de dossier, et une caution (qui est remboursable à la fin du contrat). Le délai pour la souscription d''un nouvel abonnement peut varier selon la charge de travail et les contraintes techniques.',
 (SELECT id FROM categories WHERE titre = 'Eau et électricité' LIMIT 1),
 (SELECT id FROM sous_categories WHERE titre = 'Demande de transférer d''un compteur d''eau' LIMIT 1),
 NOW());

-- ============================================
-- 3.214. ÉTAPES DE LA PROCÉDURE DEMANDE DE TRANSFÉRER D'UN COMPTEUR D'EAU
-- ============================================

INSERT INTO etapes (nom, description, niveau, procedure_id) VALUES
-- Étape 1: Résiliation par l'ancien occupant
('Résiliation par l''ancien occupant', 'L''ancien occupant doit relever l''index du compteur d''eau le jour du départ. Il doit se rendre dans l''une des agences de la SOMAGEP pour notifier la résiliation du contrat. Il devra fournir un relevé final du compteur d''eau pour que le service puisse établir la facture de clôture. Il doit payer la facture de clôture, calculée sur la base du relevé final. Une fois la facture réglée, le contrat est clôturé.', 1,
 (SELECT id FROM procedures WHERE nom = 'Demande de transférer d''un compteur d''eau' LIMIT 1)),

-- Étape 2: Préparation du dossier par le nouvel occupant
('Préparation du dossier par le nouvel occupant', 'Le nouvel occupant doit préparer les pièces nécessaires pour un nouvel abonnement. Il doit fournir le numéro de contrat ou, si possible, le numéro de l''ancien compteur, une photocopie légalisée de sa pièce d''identité, une attestation de propriété du lieu de résidence (ou autorisation légalisée du propriétaire si locataire), et le relevé du compteur d''eau au moment de l''emménagement.', 2,
 (SELECT id FROM procedures WHERE nom = 'Demande de transférer d''un compteur d''eau' LIMIT 1)),

-- Étape 3: Dépôt du dossier d'abonnement
('Dépôt du dossier d''abonnement', 'Le nouvel occupant doit déposer le dossier d''abonnement complet auprès de l''agence SOMAGEP la plus proche. Il doit fournir une copie légalisée de sa pièce d''identité en cours de validité, une attestation de propriété du domaine à desservir (ou autorisation légalisée du propriétaire si locataire), le relevé de l''index du compteur au moment de l''emménagement, et un plan de situation pour localiser l''adresse.', 3,
 (SELECT id FROM procedures WHERE nom = 'Demande de transférer d''un compteur d''eau' LIMIT 1)),

-- Étape 4: Paiement des frais
('Paiement des frais', 'Le nouvel occupant doit payer les frais de raccordement et la caution demandée par la SOMAGEP. Les frais sont variables et incluent le coût du branchement, les frais de dossier, et une caution (qui est remboursable à la fin du contrat). Le montant exact dépend de l''ampleur des travaux nécessaires.', 4,
 (SELECT id FROM procedures WHERE nom = 'Demande de transférer d''un compteur d''eau' LIMIT 1)),

-- Étape 5: Installation et mise en service
('Installation et mise en service', 'L''équipe technique de la SOMAGEP procède à l''installation ou à la réactivation du compteur et à la mise en service du contrat. Après le dépôt du dossier et le paiement des frais, l''équipe technique de la SOMAGEP interviendra pour la mise en service. Les délais dépendent de la charge de travail et des contraintes techniques.', 5,
 (SELECT id FROM procedures WHERE nom = 'Demande de transférer d''un compteur d''eau' LIMIT 1));

-- ============================================
-- 3.215. DOCUMENTS REQUIS POUR DEMANDE DE TRANSFÉRER D'UN COMPTEUR D'EAU
-- ============================================

INSERT INTO documents_requis (nom, description, est_obligatoire, procedure_id) VALUES
('Numéro de contrat et de compteur', 'Le numéro de contrat et de compteur de l''ancien abonnement', 
 (SELECT id FROM procedures WHERE nom = 'Demande de transférer d''un compteur d''eau' LIMIT 1)),

('Relevé de l''index du compteur', 'Le relevé de l''index du compteur au moment du départ (pour résiliation) et au moment de l''emménagement (pour nouvel abonnement)', 
 (SELECT id FROM procedures WHERE nom = 'Demande de transférer d''un compteur d''eau' LIMIT 1)),

('Pièce d''identité du titulaire', 'Une pièce d''identité du titulaire du contrat (pour résiliation) et une copie légalisée de la pièce d''identité en cours de validité (pour nouvel abonnement)', 
 (SELECT id FROM procedures WHERE nom = 'Demande de transférer d''un compteur d''eau' LIMIT 1)),

('Attestation de propriété', 'Une attestation de propriété du domaine à desservir. Si vous êtes locataire, il faut fournir une autorisation légalisée du propriétaire', 
 (SELECT id FROM procedures WHERE nom = 'Demande de transférer d''un compteur d''eau' LIMIT 1)),

('Plan de situation', 'Un plan de situation pour localiser l''adresse', 
 (SELECT id FROM procedures WHERE nom = 'Demande de transférer d''un compteur d''eau' LIMIT 1)),

('Demande de résiliation', 'Demande de résiliation du contrat pour l''ancien occupant', 
 (SELECT id FROM procedures WHERE nom = 'Demande de transférer d''un compteur d''eau' LIMIT 1)),

('Dossier d''abonnement', 'Dossier d''abonnement complet pour le nouvel occupant', 
 (SELECT id FROM procedures WHERE nom = 'Demande de transférer d''un compteur d''eau' LIMIT 1));

-- ============================================
-- 3.216. COÛTS DE LA PROCÉDURE DEMANDE DE TRANSFÉRER D'UN COMPTEUR D'EAU
-- ============================================

-- Insertion des coûts
INSERT INTO couts (nom, prix, description) VALUES
('Frais de branchement - Transfert eau', 0, 'Coût du branchement selon l''ampleur des travaux nécessaires'),
('Frais de dossier - Transfert eau', 0, 'Frais de dossier pour le nouvel abonnement'),
('Caution - Transfert eau', 0, 'Caution demandée par la SOMAGEP (remboursable à la fin du contrat)'),
('Frais de résiliation - Transfert eau', 0, 'Frais de résiliation du contrat pour l''ancien occupant'),
('Facture de clôture - Transfert eau', 0, 'Facture de clôture calculée sur la base du relevé final'),
('Coût total estimé - Transfert eau', 0, 'Coût total variable selon l''ampleur des travaux - Il est conseillé de se renseigner directement auprès d''une agence SOMAGEP pour obtenir un devis précis');

-- Association du coût principal à la procédure
UPDATE procedures 
SET cout_id = (SELECT id FROM couts WHERE nom = 'Coût total estimé - Transfert eau' LIMIT 1)
WHERE nom = 'Demande de transférer d''un compteur d''eau';

-- ============================================
-- 3.217. CENTRES POUR DEMANDE DE TRANSFÉRER D'UN COMPTEUR D'EAU
-- ============================================

-- Ajout des centres spécifiques pour transfert eau
INSERT INTO centres (nom, adresse, horaires, telephone, email, date_creation) VALUES
('SOMAGEP-SA - Siège', 'Rue 41, Djicoroni Troukabougou, BP E708, Bamako', 'Lundi-Vendredi: 8h-16h', '80 00 20 20', 'contact@somagep.ml', NOW()),
('SOMAGEP-SA - Agence Kalaban Coura', 'H2J5+G3R Kalaban Coura, Bamako', 'Lundi-Vendredi: 8h-16h', '80 00 20 20', 'kalaban@somagep.ml', NOW()),
('SOMAGEP-SA - Agences commerciales', 'Agences commerciales SOMAGEP-SA', 'Lundi-Vendredi: 8h-16h', '80 00 20 20', 'agence@somagep.ml', NOW()),
('SOMAGEP-SA - Service client transfert', 'Service client SOMAGEP-SA pour transferts', 'Lundi-Vendredi: 8h-16h', '80 00 20 20', 'transfert@somagep.ml', NOW());

-- Association du centre principal à la procédure
UPDATE procedures 
SET centre_id = (SELECT id FROM centres WHERE nom = 'SOMAGEP-SA - Siège' LIMIT 1)
WHERE nom = 'Demande de transférer d''un compteur d''eau';

-- ============================================
-- 3.218. ARTICLES DE LOI POUR DEMANDE DE TRANSFÉRER D'UN COMPTEUR D'EAU
-- ============================================

INSERT INTO lois_articles (description, consulter_article, procedure_id) VALUES
-- Ordonnance n°2010-040/P-RM du 5 août 2010
('Ordonnance n°2010-040/P-RM du 5 août 2010', 
 'Ordonnance n°2010-040/P-RM du 5 août 2010. Cette ordonnance a créé la SOMAGEP-SA et lui a confié l''exploitation du service public de l''eau potable au Mali.',
 (SELECT id FROM procedures WHERE nom = 'Demande de transférer d''un compteur d''eau' LIMIT 1)),

-- Acte Uniforme OHADA
('Acte Uniforme de l''Organisation pour l''Harmonisation en Afrique du Droit des Affaires (OHADA)', 
 'Acte Uniforme de l''Organisation pour l''Harmonisation en Afrique du Droit des Affaires (OHADA). La SOMAGEP-SA est une société anonyme d''État régie par les lois et règlements du Mali, notamment l''Acte Uniforme OHADA.',
 (SELECT id FROM procedures WHERE nom = 'Demande de transférer d''un compteur d''eau' LIMIT 1));

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

-- ============================================
-- 3.213. PROCÉDURE: CRÉATION DE SOCIÉTÉ PAR ACTIONS SIMPLIFIÉE UNIPERSONNELLE (SASU)
-- ============================================

-- Insertion de la procédure
INSERT INTO procedures (nom, titre, delai, description, categorie_id, sous_categorie_id, date_creation) VALUES
('Création de Société par Actions Simplifiée Unipersonnelle (SASU)', 'Créer une Société par Actions Simplifiée Unipersonnelle (SASU) au Mali', '72 heures après dépôt du dossier complet', 
 'Au Mali, les Sociétés par Actions Simplifiées Unipersonnelles (SASU) sont régies par le droit de l''Organisation pour l''Harmonisation en Afrique du Droit des Affaires (OHADA). La création d''une entreprise se centralise auprès du Guichet Unique de l''Agence pour la Promotion des Investissements au Mali (API-Mali). La SASU offre une grande liberté contractuelle et ne requiert pas de capital minimum, ce qui facilite sa création. L''associé unique a une responsabilité limitée au montant de ses apports. Le processus comprend la rédaction des statuts, le dépôt du capital social, l''obtention des pièces justificatives, le dépôt du dossier au Guichet Unique, l''enregistrement et immatriculation, et la publication de l''avis de constitution.',
 (SELECT id FROM categories WHERE titre = 'Création d''entreprise' LIMIT 1),
 (SELECT id FROM sous_categories WHERE titre = 'Sociétés par Actions Simplifiées Unipersonnelle (SASU)' LIMIT 1),
 NOW());

-- ============================================
-- 3.214. ÉTAPES DE LA PROCÉDURE CRÉATION DE SOCIÉTÉ PAR ACTIONS SIMPLIFIÉE UNIPERSONNELLE (SASU)
-- ============================================

INSERT INTO etapes (nom, description, niveau, procedure_id) VALUES
-- Étape 1: Rédaction des statuts
('Rédaction des statuts', 'L''associé unique rédige ou fait rédiger les statuts, incluant la dénomination sociale, l''objet, le siège, le capital social et les modalités de fonctionnement. Un notaire peut être nécessaire pour certaines formalités. Les statuts doivent respecter l''Acte uniforme révisé relatif au droit des sociétés commerciales et du groupement d''intérêt économique (AUSCGIE) de l''OHADA.', 1,
 (SELECT id FROM procedures WHERE nom = 'Création de Société par Actions Simplifiée Unipersonnelle (SASU)' LIMIT 1)),

-- Étape 2: Dépôt du capital social
('Dépôt du capital social', 'L''associé unique doit déposer le capital social de l''entreprise sur un compte bancaire bloqué au nom de la société en formation. Aucun capital minimum n''est requis pour une SASU, ce qui constitue un avantage majeur.', 2,
 (SELECT id FROM procedures WHERE nom = 'Création de Société par Actions Simplifiée Unipersonnelle (SASU)' LIMIT 1)),

-- Étape 3: Préparation du dossier complet
('Préparation du dossier complet', 'Rassemblement de tous les documents requis : statuts signés, déclaration de souscription et de versement du capital social, casier judiciaire, extrait d''acte de naissance, certificat de nationalité, certificat de résidence, pièce d''identité, preuve de dépôt du capital social, et titre d''occupation des lieux.', 3,
 (SELECT id FROM procedures WHERE nom = 'Création de Société par Actions Simplifiée Unipersonnelle (SASU)' LIMIT 1)),

-- Étape 4: Dépôt du dossier au Guichet Unique
('Dépôt du dossier au Guichet Unique', 'Le dossier complet est déposé auprès du Guichet Unique de l''Agence pour la Promotion des Investissements au Mali (API-Mali), situé à Bamako. C''est le point de contact unique pour toutes les formalités.', 4,
 (SELECT id FROM procedures WHERE nom = 'Création de Société par Actions Simplifiée Unipersonnelle (SASU)' LIMIT 1)),

-- Étape 5: Enregistrement et immatriculation
('Enregistrement et immatriculation', 'L''API-Mali gère l''enregistrement des statuts au service des Impôts et l''immatriculation au Registre du Commerce et du Crédit Mobilier (RCCM) auprès du tribunal de commerce. Cette étape est effectuée dans le délai de 72 heures.', 5,
 (SELECT id FROM procedures WHERE nom = 'Création de Société par Actions Simplifiée Unipersonnelle (SASU)' LIMIT 1)),

-- Étape 6: Publication
('Publication', 'Une annonce de création est publiée dans le Journal officiel pour informer le public de la constitution de la société.', 6,
 (SELECT id FROM procedures WHERE nom = 'Création de Société par Actions Simplifiée Unipersonnelle (SASU)' LIMIT 1)),

-- Étape 7: Retrait des documents
('Retrait des documents', 'Une fois les démarches accomplies, l''entrepreneur retire les certificats RCCM, NIMA (Numéro d''Identification des Marchés), la carte fiscale et un exemplaire du Journal officiel.', 7,
 (SELECT id FROM procedures WHERE nom = 'Création de Société par Actions Simplifiée Unipersonnelle (SASU)' LIMIT 1));

-- ============================================
-- 3.215. DOCUMENTS REQUIS POUR CRÉATION DE SOCIÉTÉ PAR ACTIONS SIMPLIFIÉE UNIPERSONNELLE (SASU)
-- ============================================

INSERT INTO documents_requis (nom, description, obligatoire, procedure_id) VALUES
('Statuts signés', 'Statuts de la société signés par l''associé unique, incluant la dénomination sociale, l''objet, le siège, le capital social et les modalités de fonctionnement.', true,
 (SELECT id FROM procedures WHERE nom = 'Création de Société par Actions Simplifiée Unipersonnelle (SASU)' LIMIT 1)),

('Déclaration de souscription et de versement du capital social', 'Document attestant la souscription et le versement du capital social sur un compte bancaire bloqué.', true,
 (SELECT id FROM procedures WHERE nom = 'Création de Société par Actions Simplifiée Unipersonnelle (SASU)' LIMIT 1)),

('Casier judiciaire du président et de l''administrateur', 'Casier judiciaire du président et de l''administrateur, si différent de l''associé unique.', true,
 (SELECT id FROM procedures WHERE nom = 'Création de Société par Actions Simplifiée Unipersonnelle (SASU)' LIMIT 1)),

('Extrait d''acte de naissance du président ou de l''associé unique', 'Extrait d''acte de naissance du président ou de l''associé unique.', true,
 (SELECT id FROM procedures WHERE nom = 'Création de Société par Actions Simplifiée Unipersonnelle (SASU)' LIMIT 1)),

('Certificat de nationalité du président ou de l''associé unique', 'Certificat de nationalité du président ou de l''associé unique.', true,
 (SELECT id FROM procedures WHERE nom = 'Création de Société par Actions Simplifiée Unipersonnelle (SASU)' LIMIT 1)),

('Certificat de résidence du président ou de l''associé unique', 'Certificat de résidence du président ou de l''associé unique.', true,
 (SELECT id FROM procedures WHERE nom = 'Création de Société par Actions Simplifiée Unipersonnelle (SASU)' LIMIT 1)),

('Pièce d''identité du président', 'Pièce d''identité (carte d''identité ou passeport) du président.', true,
 (SELECT id FROM procedures WHERE nom = 'Création de Société par Actions Simplifiée Unipersonnelle (SASU)' LIMIT 1)),

('Preuve de dépôt du capital social', 'Document bancaire attestant le dépôt du capital social sur un compte bloqué au nom de la société en formation.', true,
 (SELECT id FROM procedures WHERE nom = 'Création de Société par Actions Simplifiée Unipersonnelle (SASU)' LIMIT 1)),

('Titre d''occupation des lieux', 'Titre d''occupation des lieux (bail commercial ou contrat de domiciliation) pour le siège social de la société.', true,
 (SELECT id FROM procedures WHERE nom = 'Création de Société par Actions Simplifiée Unipersonnelle (SASU)' LIMIT 1));

-- ============================================
-- 3.216. COÛTS DE LA PROCÉDURE CRÉATION DE SOCIÉTÉ PAR ACTIONS SIMPLIFIÉE UNIPERSONNELLE (SASU)
-- ============================================

INSERT INTO couts (nom, prix, description) VALUES
('Frais d''immatriculation au RCCM', 0, 'Frais d''immatriculation au Registre du Commerce et du Crédit Mobilier (RCCM) - Montant variable selon l''API-Mali'),
('Frais de publication au Journal officiel', 0, 'Coût de la publication de l''annonce de création dans le Journal officiel'),
('Frais d''enregistrement des statuts', 0, 'Frais d''enregistrement des statuts auprès des impôts'),
('Frais de notaire', 0, 'Coûts associés au notaire si nécessaire pour certaines formalités'),
('Autres frais administratifs', 0, 'Coûts associés aux divers documents administratifs et formalités');

-- Association des coûts à la procédure
UPDATE procedures 
SET cout_id = (SELECT id FROM couts WHERE nom = 'Frais d''immatriculation au RCCM' LIMIT 1)
WHERE nom = 'Création de Société par Actions Simplifiée Unipersonnelle (SASU)';

-- ============================================
-- 3.217. ASSOCIATION DU CENTRE POUR CRÉATION DE SOCIÉTÉ PAR ACTIONS SIMPLIFIÉE UNIPERSONNELLE (SASU)
-- ============================================

-- Insertion du centre Guichet Unique API-Mali s'il n'existe pas déjà
INSERT INTO centres (nom, adresse, horaires, telephone, email, date_creation) 
SELECT 'Guichet Unique API-Mali', 'Bamako, Mali', 'Lundi-Vendredi: 8h-16h', 'Contactez l''API-Mali', 'contact@api-mali.ml', NOW()
WHERE NOT EXISTS (SELECT 1 FROM centres WHERE nom = 'Guichet Unique API-Mali');

-- Association du centre à la procédure
UPDATE procedures 
SET centre_id = (SELECT id FROM centres WHERE nom = 'Guichet Unique API-Mali' LIMIT 1)
WHERE nom = 'Création de Société par Actions Simplifiée Unipersonnelle (SASU)';

-- ============================================
-- 3.218. ARTICLES DE LOI POUR CRÉATION DE SOCIÉTÉ PAR ACTIONS SIMPLIFIÉE UNIPERSONNELLE (SASU)
-- ============================================

INSERT INTO lois_articles (description, consulter_article, procedure_id) VALUES
-- Acte uniforme révisé relatif au droit des sociétés commerciales et du groupement d'intérêt économique (AUSCGIE)
('Acte uniforme révisé relatif au droit des sociétés commerciales et du groupement d''intérêt économique (AUSCGIE)', 
 'Adopté le 30 janvier 2014 à Ouagadougou, cet acte est le texte de référence qui consacre et encadre la création des Sociétés par Actions Simplifiées (SAS) dans l''espace OHADA. L''article 5 précise que la société commerciale peut être créée par une seule personne par un acte écrit, ouvrant la voie à la SASU. Les associés ont une grande liberté pour organiser le fonctionnement de la société dans les statuts. La responsabilité de l''associé unique est limitée au montant de ses apports.',
 (SELECT id FROM procedures WHERE nom = 'Création de Société par Actions Simplifiée Unipersonnelle (SASU)' LIMIT 1)),

-- Livre 4-2 de l'Acte uniforme
('Livre 4-2 de l''Acte uniforme OHADA', 
 'Ce livre est spécifiquement relatif à la Société par actions simplifiée. En droit OHADA, la SAS peut être constituée par une seule personne, ce qui rend le régime de la SAS à associé unique applicable pour la SASU.',
 (SELECT id FROM procedures WHERE nom = 'Création de Société par Actions Simplifiée Unipersonnelle (SASU)' LIMIT 1)),

-- Législation fiscale malienne
('Législation fiscale malienne', 
 'Les lois fiscales maliennes déterminent le régime d''imposition de la SASU et les obligations fiscales de l''entreprise.',
 (SELECT id FROM procedures WHERE nom = 'Création de Société par Actions Simplifiée Unipersonnelle (SASU)' LIMIT 1)),

-- Réglementation du Guichet Unique API-Mali
('Réglementation du Guichet Unique de l''API-Mali', 
 'La création d''entreprise au Mali passe par le Guichet Unique de l''Agence pour la Promotion des Investissements, qui assure la coordination des démarches administratives conformément à la législation en vigueur. Le délai de traitement est de 72 heures à compter du dépôt d''un dossier complet.',
 (SELECT id FROM procedures WHERE nom = 'Création de Société par Actions Simplifiée Unipersonnelle (SASU)' LIMIT 1));

-- ============================================
-- 3.219. PROCÉDURE: CRÉATION DE SOCIÉTÉ À RESPONSABILITÉ LIMITÉE UNIPERSONNELLE (SARL U)
-- ============================================

-- Insertion de la procédure
INSERT INTO procedures (nom, titre, delai, description, categorie_id, sous_categorie_id, date_creation) VALUES
('Création de Société à Responsabilité Limitée Unipersonnelle (SARL U)', 'Créer une Société à Responsabilité Limitée Unipersonnelle (SARL U) au Mali', '72 heures après dépôt du dossier complet', 
 'Au Mali, la forme juridique de l''entreprise unipersonnelle à responsabilité limitée est connue sous le nom de Société à Responsabilité Limitée Unipersonnelle (SARL U), conformément au droit de l''Organisation pour l''harmonisation en Afrique du droit des affaires (OHADA). La SARL U est constituée par une seule personne (physique ou morale) avec une responsabilité limitée au montant de ses apports. Le capital social minimum requis est d''un million de francs CFA (1 000 000 FCFA), divisé en parts sociales égales d''une valeur nominale minimale de 5 000 FCFA. La gestion est confiée à un gérant qui peut être l''associé unique ou un tiers. Le processus de création est centralisé par le Guichet Unique de l''API-Mali.',
 (SELECT id FROM categories WHERE titre = 'Création d''entreprise' LIMIT 1),
 (SELECT id FROM sous_categories WHERE titre = 'Société à Responsabilité Limitée Unipersonnelle (SARL U)' LIMIT 1),
 NOW());

-- ============================================
-- 3.220. ÉTAPES DE LA PROCÉDURE CRÉATION DE SOCIÉTÉ À RESPONSABILITÉ LIMITÉE UNIPERSONNELLE (SARL U)
-- ============================================

INSERT INTO etapes (nom, description, niveau, procedure_id) VALUES
-- Étape 1: Rédaction des statuts
('Rédaction des statuts', 'Préparation de l''acte constitutif de la société, qui doit être signé par l''associé unique. Les statuts doivent inclure la dénomination sociale, l''objet social, le siège social, le capital social (minimum 1 000 000 FCFA), la durée de la société, et les modalités de fonctionnement conformément au droit OHADA.', 1,
 (SELECT id FROM procedures WHERE nom = 'Création de Société à Responsabilité Limitée Unipersonnelle (SARL U)' LIMIT 1)),

-- Étape 2: Dépôt du capital social
('Dépôt du capital social', 'Le capital social minimum requis est d''un million de FCFA (1 000 000 FCFA), divisé en parts sociales égales d''une valeur nominale minimale de 5 000 FCFA. Il doit être déposé sur un compte bancaire de l''entreprise, et une attestation de dépôt de fonds doit être fournie.', 2,
 (SELECT id FROM procedures WHERE nom = 'Création de Société à Responsabilité Limitée Unipersonnelle (SARL U)' LIMIT 1)),

-- Étape 3: Préparation du dossier complet
('Préparation du dossier complet', 'Rassemblement de tous les documents requis : projet de statuts signés, attestation de dépôt de fonds, copie de pièce d''identité de l''associé unique et du gérant, extrait de casier judiciaire, justificatif de domiciliation, et formulaires spécifiques de demande d''immatriculation.', 3,
 (SELECT id FROM procedures WHERE nom = 'Création de Société à Responsabilité Limitée Unipersonnelle (SARL U)' LIMIT 1)),

-- Étape 4: Dépôt du dossier au Guichet Unique
('Dépôt du dossier au Guichet Unique de l''API-Mali', 'Soumission de tous les documents requis pour l''enregistrement auprès du Guichet Unique de l''Agence de Promotion des Investissements (API-Mali), situé à Bamako. Ce guichet centralise toutes les formalités pour simplifier le processus.', 4,
 (SELECT id FROM procedures WHERE nom = 'Création de Société à Responsabilité Limitée Unipersonnelle (SARL U)' LIMIT 1)),

-- Étape 5: Enregistrement des statuts
('Enregistrement des statuts', 'Les documents sont enregistrés par les services fiscaux conformément aux dispositions légales en vigueur au Mali.', 5,
 (SELECT id FROM procedures WHERE nom = 'Création de Société à Responsabilité Limitée Unipersonnelle (SARL U)' LIMIT 1)),

-- Étape 6: Immatriculation au RCCM
('Immatriculation au Registre du Commerce et du Crédit Mobilier (RCCM)', 'Le greffe du tribunal de commerce procède à l''immatriculation de la société au Registre du Commerce et du Crédit Mobilier (RCCM).', 6,
 (SELECT id FROM procedures WHERE nom = 'Création de Société à Responsabilité Limitée Unipersonnelle (SARL U)' LIMIT 1)),

-- Étape 7: Publication d'une annonce légale
('Publication d''une annonce légale', 'Un avis de constitution est publié au Journal officiel pour informer le public de la création de la société.', 7,
 (SELECT id FROM procedures WHERE nom = 'Création de Société à Responsabilité Limitée Unipersonnelle (SARL U)' LIMIT 1)),

-- Étape 8: Retrait des documents
('Retrait des documents', 'Une fois toutes les démarches accomplies, l''entrepreneur retire les documents officiels : certificat RCCM, NIMA (Numéro d''Identification des Marchés), carte fiscale et exemplaire du Journal officiel.', 8,
 (SELECT id FROM procedures WHERE nom = 'Création de Société à Responsabilité Limitée Unipersonnelle (SARL U)' LIMIT 1));

-- ============================================
-- 3.221. DOCUMENTS REQUIS POUR CRÉATION DE SOCIÉTÉ À RESPONSABILITÉ LIMITÉE UNIPERSONNELLE (SARL U)
-- ============================================

INSERT INTO documents_requis (nom, description, obligatoire, procedure_id) VALUES
('Projet de statuts', 'L''acte constitutif de la société, signé par l''associé unique, incluant la dénomination sociale, l''objet social, le siège social, le capital social et les modalités de fonctionnement.', true,
 (SELECT id FROM procedures WHERE nom = 'Création de Société à Responsabilité Limitée Unipersonnelle (SARL U)' LIMIT 1)),

('Attestation de dépôt de fonds', 'Preuve du dépôt du capital social (minimum 1 000 000 FCFA) sur un compte bancaire de l''entreprise, délivrée par la banque.', true,
 (SELECT id FROM procedures WHERE nom = 'Création de Société à Responsabilité Limitée Unipersonnelle (SARL U)' LIMIT 1)),

('Copie de pièce d''identité de l''associé unique', 'Copie de la carte d''identité ou du passeport de l''associé unique.', true,
 (SELECT id FROM procedures WHERE nom = 'Création de Société à Responsabilité Limitée Unipersonnelle (SARL U)' LIMIT 1)),

('Copie de pièce d''identité du gérant', 'Copie de la carte d''identité ou du passeport du gérant, si différent de l''associé unique.', true,
 (SELECT id FROM procedures WHERE nom = 'Création de Société à Responsabilité Limitée Unipersonnelle (SARL U)' LIMIT 1)),

('Extrait de casier judiciaire', 'Extrait de casier judiciaire du gérant, souvent requis pour les villes de Bamako et Kati.', true,
 (SELECT id FROM procedures WHERE nom = 'Création de Société à Responsabilité Limitée Unipersonnelle (SARL U)' LIMIT 1)),

('Justificatif de domiciliation', 'Preuve de l''adresse du siège social de l''entreprise (bail commercial, contrat de domiciliation, ou titre de propriété).', true,
 (SELECT id FROM procedures WHERE nom = 'Création de Société à Responsabilité Limitée Unipersonnelle (SARL U)' LIMIT 1)),

('Formulaires de demande d''immatriculation', 'Les formulaires spécifiques de demande d''immatriculation à remplir auprès de l''API-Mali.', true,
 (SELECT id FROM procedures WHERE nom = 'Création de Société à Responsabilité Limitée Unipersonnelle (SARL U)' LIMIT 1)),

('Copie d''acte de mariage', 'Dans le cas échéant, copie d''acte de mariage disponible à la mairie, si applicable.', false,
 (SELECT id FROM procedures WHERE nom = 'Création de Société à Responsabilité Limitée Unipersonnelle (SARL U)' LIMIT 1));

-- ============================================
-- 3.222. COÛTS DE LA PROCÉDURE CRÉATION DE SOCIÉTÉ À RESPONSABILITÉ LIMITÉE UNIPERSONNELLE (SARL U)
-- ============================================

INSERT INTO couts (nom, prix, description) VALUES
('Capital social minimum', 1000000, 'Capital social minimum requis : 1 000 000 FCFA, divisé en parts sociales égales d''une valeur nominale minimale de 5 000 FCFA'),
('Frais d''enregistrement des statuts', 0, 'Frais liés à l''enregistrement des statuts auprès des services fiscaux - Montant variable selon les textes en vigueur'),
('Frais d''immatriculation au RCCM', 0, 'Frais d''immatriculation au Registre du Commerce et du Crédit Mobilier (RCCM) - Montant variable selon l''API-Mali'),
('Frais de publication au Journal officiel', 0, 'Coût de la publication de l''avis de constitution dans le Journal officiel'),
('Honoraires professionnels', 0, 'Honoraires des professionnels (notaire ou juriste) pour la rédaction des statuts et l''accompagnement'),
('Autres frais administratifs', 0, 'Coûts associés aux divers documents administratifs et formalités');

-- Association des coûts à la procédure
UPDATE procedures 
SET cout_id = (SELECT id FROM couts WHERE nom = 'Capital social minimum' LIMIT 1)
WHERE nom = 'Création de Société à Responsabilité Limitée Unipersonnelle (SARL U)';

-- ============================================
-- 3.223. ASSOCIATION DU CENTRE POUR CRÉATION DE SOCIÉTÉ À RESPONSABILITÉ LIMITÉE UNIPERSONNELLE (SARL U)
-- ============================================

-- Association du centre à la procédure (le centre Guichet Unique API-Mali existe déjà)
UPDATE procedures 
SET centre_id = (SELECT id FROM centres WHERE nom = 'Guichet Unique API-Mali' LIMIT 1)
WHERE nom = 'Création de Société à Responsabilité Limitée Unipersonnelle (SARL U)';

-- ============================================
-- 3.224. ARTICLES DE LOI POUR CRÉATION DE SOCIÉTÉ À RESPONSABILITÉ LIMITÉE UNIPERSONNELLE (SARL U)
-- ============================================

INSERT INTO lois_articles (description, consulter_article, procedure_id) VALUES
-- Acte uniforme relatif au droit des sociétés commerciales et au Groupement d'Intérêt Économique (AUSCGIE)
('Acte uniforme relatif au droit des sociétés commerciales et au Groupement d''Intérêt Économique (AUSCGIE)', 
 'Ce texte de loi encadre la création, le fonctionnement et la dissolution des SARL U dans l''espace OHADA, dont le Mali fait partie. L''AUSCGIE définit les règles applicables aux sociétés commerciales dans l''espace OHADA.',
 (SELECT id FROM procedures WHERE nom = 'Création de Société à Responsabilité Limitée Unipersonnelle (SARL U)' LIMIT 1)),

-- Articles 558 à 561 de l'Acte Uniforme
('Articles 558 à 561 de l''Acte Uniforme OHADA', 
 'Ces articles contiennent les dispositions spécifiques concernant le fonctionnement de la SARL U, notamment les règles de constitution, de gestion et de fonctionnement de cette forme juridique.',
 (SELECT id FROM procedures WHERE nom = 'Création de Société à Responsabilité Limitée Unipersonnelle (SARL U)' LIMIT 1)),

-- Législation fiscale malienne
('Législation fiscale malienne', 
 'Les lois fiscales maliennes déterminent le régime d''imposition de la SARL U et les obligations fiscales de l''entreprise, notamment en matière de TVA, d''impôt sur les sociétés et de taxes diverses.',
 (SELECT id FROM procedures WHERE nom = 'Création de Société à Responsabilité Limitée Unipersonnelle (SARL U)' LIMIT 1)),

-- Réglementation du Guichet Unique API-Mali
('Réglementation du Guichet Unique de l''API-Mali', 
 'La création d''entreprise au Mali passe par le Guichet Unique de l''Agence de Promotion des Investissements, qui assure la coordination des démarches administratives conformément à la législation en vigueur. Le délai de traitement est de 72 heures à compter de la réception d''un dossier complet et validé.',
 (SELECT id FROM procedures WHERE nom = 'Création de Société à Responsabilité Limitée Unipersonnelle (SARL U)' LIMIT 1));

-- ============================================
-- 3.225. PROCÉDURE: IMPÔT SYNTHÉTIQUE
-- ============================================

-- Insertion de la procédure
INSERT INTO procedures (nom, titre, delai, description, categorie_id, sous_categorie_id, date_creation) VALUES
('Impôt synthétique', 'Souscrire au régime de l''impôt synthétique', 'Variable selon le type d''activité', 
 'L''impôt synthétique est un régime fiscal simplifié au Mali destiné aux petites et moyennes entreprises. Ce régime permet aux contribuables de bénéficier d''une imposition forfaitaire basée sur des critères objectifs (chiffre d''affaires, nombre d''employés, secteur d''activité) plutôt que sur la comptabilité réelle. L''impôt synthétique s''applique aux entreprises dont le chiffre d''affaires annuel ne dépasse pas certains seuils définis par la Direction Générale des Impôts (DGI). Ce régime simplifie les obligations comptables et fiscales des petites entreprises tout en garantissant une contribution équitable à l''impôt.',
 (SELECT id FROM categories WHERE titre = 'Impôt et Douane' LIMIT 1),
 (SELECT id FROM sous_categories WHERE titre = 'Impôt synthétique' LIMIT 1),
 NOW());

-- ============================================
-- 3.226. ÉTAPES DE LA PROCÉDURE IMPÔT SYNTHÉTIQUE
-- ============================================

INSERT INTO etapes (nom, description, niveau, procedure_id) VALUES
-- Étape 1: Vérification de l'éligibilité
('Vérification de l''éligibilité', 'Vérifier que l''entreprise respecte les critères d''éligibilité au régime de l''impôt synthétique : chiffre d''affaires annuel dans les limites fixées par la DGI, secteur d''activité éligible, et respect des conditions spécifiques définies par la réglementation fiscale malienne.', 1,
 (SELECT id FROM procedures WHERE nom = 'Impôt synthétique' LIMIT 1)),

-- Étape 2: Constitution du dossier de demande
('Constitution du dossier de demande', 'Préparation du dossier de demande d''adhésion au régime de l''impôt synthétique incluant : formulaire de demande, justificatifs d''activité, déclaration de chiffre d''affaires, et tous les documents requis par la Direction Générale des Impôts.', 2,
 (SELECT id FROM procedures WHERE nom = 'Impôt synthétique' LIMIT 1)),

-- Étape 3: Dépôt de la demande
('Dépôt de la demande', 'Soumission du dossier de demande auprès du service des impôts compétent (Direction Régionale des Impôts ou bureau local selon la localisation de l''entreprise).', 3,
 (SELECT id FROM procedures WHERE nom = 'Impôt synthétique' LIMIT 1)),

-- Étape 4: Instruction de la demande
('Instruction de la demande', 'Examen du dossier par les services fiscaux pour vérifier l''éligibilité, l''exactitude des informations fournies et la conformité aux critères du régime de l''impôt synthétique.', 4,
 (SELECT id FROM procedures WHERE nom = 'Impôt synthétique' LIMIT 1)),

-- Étape 5: Notification de la décision
('Notification de la décision', 'Communication de la décision d''acceptation ou de refus d''adhésion au régime de l''impôt synthétique par les services fiscaux.', 5,
 (SELECT id FROM procedures WHERE nom = 'Impôt synthétique' LIMIT 1)),

-- Étape 6: Calcul et notification de l'impôt
('Calcul et notification de l''impôt', 'En cas d''acceptation, calcul de l''impôt synthétique basé sur les critères objectifs (chiffre d''affaires, secteur d''activité, nombre d''employés) et notification du montant à payer.', 6,
 (SELECT id FROM procedures WHERE nom = 'Impôt synthétique' LIMIT 1)),

-- Étape 7: Paiement de l'impôt
('Paiement de l''impôt', 'Règlement de l''impôt synthétique selon les modalités et échéances fixées par la Direction Générale des Impôts (paiement annuel ou trimestriel selon le cas).', 7,
 (SELECT id FROM procedures WHERE nom = 'Impôt synthétique' LIMIT 1)),

-- Étape 8: Suivi et renouvellement
('Suivi et renouvellement', 'Respect des obligations déclaratives simplifiées et renouvellement périodique de l''adhésion au régime selon les modalités définies par la DGI.', 8,
 (SELECT id FROM procedures WHERE nom = 'Impôt synthétique' LIMIT 1));

-- ============================================
-- 3.227. DOCUMENTS REQUIS POUR IMPÔT SYNTHÉTIQUE
-- ============================================

INSERT INTO documents_requis (nom, description, obligatoire, procedure_id) VALUES
('Formulaire de demande d''adhésion', 'Formulaire officiel de demande d''adhésion au régime de l''impôt synthétique, disponible auprès des services fiscaux.', true,
 (SELECT id FROM procedures WHERE nom = 'Impôt synthétique' LIMIT 1)),

('Déclaration de chiffre d''affaires', 'Déclaration du chiffre d''affaires annuel de l''entreprise avec justificatifs (factures, reçus, etc.).', true,
 (SELECT id FROM procedures WHERE nom = 'Impôt synthétique' LIMIT 1)),

('Justificatifs d''activité', 'Documents attestant de l''activité de l''entreprise : certificat d''immatriculation, autorisation d''exercice, ou tout document officiel.', true,
 (SELECT id FROM procedures WHERE nom = 'Impôt synthétique' LIMIT 1)),

('Copie de la carte d''identité du responsable', 'Copie de la carte d''identité ou du passeport du responsable de l''entreprise.', true,
 (SELECT id FROM procedures WHERE nom = 'Impôt synthétique' LIMIT 1)),

('Justificatif de domiciliation', 'Preuve de l''adresse du siège social ou du lieu d''exercice de l''activité.', true,
 (SELECT id FROM procedures WHERE nom = 'Impôt synthétique' LIMIT 1)),

('Déclaration du nombre d''employés', 'Déclaration du nombre d''employés de l''entreprise, si applicable.', false,
 (SELECT id FROM procedures WHERE nom = 'Impôt synthétique' LIMIT 1)),

('Bilan simplifié', 'Bilan comptable simplifié de l''entreprise, si disponible.', false,
 (SELECT id FROM procedures WHERE nom = 'Impôt synthétique' LIMIT 1));

-- ============================================
-- 3.228. COÛTS DE LA PROCÉDURE IMPÔT SYNTHÉTIQUE
-- ============================================

INSERT INTO couts (nom, prix, description) VALUES
('Frais de dossier', 0, 'Frais de traitement du dossier de demande d''adhésion au régime de l''impôt synthétique - Montant variable selon la DGI'),
('Impôt synthétique', 0, 'Montant de l''impôt synthétique calculé selon les critères objectifs (chiffre d''affaires, secteur d''activité, nombre d''employés) - Variable selon l''entreprise'),
('Frais de notification', 0, 'Frais de notification de la décision et de l''avis d''imposition - Montant fixé par la DGI'),
('Pénalités de retard', 0, 'Pénalités applicables en cas de retard dans le paiement de l''impôt synthétique - 10% du montant dû'),
('Frais de renouvellement', 0, 'Frais de renouvellement périodique de l''adhésion au régime - Montant variable');

-- Association des coûts à la procédure
UPDATE procedures 
SET cout_id = (SELECT id FROM couts WHERE nom = 'Impôt synthétique' LIMIT 1)
WHERE nom = 'Impôt synthétique';

-- ============================================
-- 3.229. ASSOCIATION DU CENTRE POUR IMPÔT SYNTHÉTIQUE
-- ============================================

-- Insertion du centre DGI s'il n'existe pas déjà
INSERT INTO centres (nom, adresse, horaires, telephone, email, date_creation) 
SELECT 'Direction Générale des Impôts (DGI)', 'Bamako, Mali', 'Lundi-Vendredi: 8h-16h', 'Contactez la DGI', 'contact@dgi.gouv.ml', NOW()
WHERE NOT EXISTS (SELECT 1 FROM centres WHERE nom = 'Direction Générale des Impôts (DGI)');

-- Association du centre à la procédure
UPDATE procedures 
SET centre_id = (SELECT id FROM centres WHERE nom = 'Direction Générale des Impôts (DGI)' LIMIT 1)
WHERE nom = 'Impôt synthétique';

-- ============================================
-- 3.230. ARTICLES DE LOI POUR IMPÔT SYNTHÉTIQUE
-- ============================================

INSERT INTO lois_articles (description, consulter_article, procedure_id) VALUES
-- Code Général des Impôts du Mali
('Code Général des Impôts du Mali', 
 'Le Code Général des Impôts du Mali définit les règles applicables à l''impôt synthétique, notamment les conditions d''éligibilité, les modalités de calcul et les obligations des contribuables. L''impôt synthétique est un régime fiscal simplifié destiné aux petites et moyennes entreprises.',
 (SELECT id FROM procedures WHERE nom = 'Impôt synthétique' LIMIT 1)),

-- Instruction DGI sur l'impôt synthétique
('Instruction DGI sur l''impôt synthétique', 
 'L''instruction de la Direction Générale des Impôts (DGI) du Mali précise les modalités d''application de l''impôt synthétique, les seuils de chiffre d''affaires, les secteurs d''activité éligibles et les procédures de demande d''adhésion. Cette instruction est régulièrement mise à jour pour refléter les évolutions réglementaires. Référence : ESE-NOUVELLES-IMPOT-SYNTHETIQUE-OK.pdf disponible sur le site de la DGI.',
 (SELECT id FROM procedures WHERE nom = 'Impôt synthétique' LIMIT 1)),

-- Loi de finances
('Loi de finances annuelle', 
 'La loi de finances annuelle du Mali peut contenir des dispositions spécifiques concernant l''impôt synthétique, notamment les taux d''imposition, les seuils d''éligibilité et les modalités de calcul. Il est important de consulter la loi de finances en vigueur pour connaître les dispositions applicables.',
 (SELECT id FROM procedures WHERE nom = 'Impôt synthétique' LIMIT 1)),

-- Décret d'application
('Décret d''application de l''impôt synthétique', 
 'Le décret d''application précise les modalités pratiques d''application de l''impôt synthétique, notamment les procédures de demande, les documents à fournir, les délais de traitement et les obligations déclaratives des entreprises bénéficiaires du régime.',
 (SELECT id FROM procedures WHERE nom = 'Impôt synthétique' LIMIT 1));

-- ============================================
-- 3.231. PROCÉDURE: IMPÔT SUR LES TRAITEMENTS ET SALAIRES (I.T.S)
-- ============================================

-- Insertion de la procédure
INSERT INTO procedures (nom, titre, delai, description, categorie_id, sous_categorie_id, date_creation) VALUES
('Impôt sur les traitements et salaires (I.T.S)', 'Déclarer et payer l''impôt sur les traitements et salaires', 'Mensuel - avant le 15 du mois suivant', 
 'L''impôt sur les traitements et salaires (I.T.S) est applicable à toutes les sommes payées aux salariés par les employeurs publics et privés, directement ou par l''entremise d''un tiers, en contrepartie ou à l''occasion du travail. Il s''applique aux traitements, indemnités, émoluments, commissions, participations, primes, gratifications, gages, pourboires et autres rétributions. L''impôt est calculé selon un barème progressif et peut faire l''objet de réductions pour charges de famille. La déclaration et le paiement sont mensuels.',
 (SELECT id FROM categories WHERE titre = 'Impôt et Douane' LIMIT 1),
 (SELECT id FROM sous_categories WHERE titre = 'Impôt sur les traitements et salaires (I.T.S)' LIMIT 1),
 NOW());

-- ============================================
-- 3.232. ÉTAPES DE LA PROCÉDURE I.T.S
-- ============================================

INSERT INTO etapes (nom, description, niveau, procedure_id) VALUES
-- Étape 1: Vérification de l'assujettissement
('Vérification de l''assujettissement', 'Vérifier que les revenus sont soumis à l''I.T.S selon l''article 1 du Code Général des Impôts : traitements, salaires, indemnités, émoluments, commissions, participations, primes, gratifications, gages, pourboires et autres rétributions versés aux salariés.', 1,
 (SELECT id FROM procedures WHERE nom = 'Impôt sur les traitements et salaires (I.T.S)' LIMIT 1)),

-- Étape 2: Calcul de la base imposable
('Calcul de la base imposable', 'Déterminer le montant net du revenu imposable en déduisant du montant brut : les retenues pour pensions/retraites (limite 4%), les allocations et indemnités spéciales destinées à couvrir les frais inhérents à la fonction, conformément aux articles 5-8 du Code.', 2,
 (SELECT id FROM procedures WHERE nom = 'Impôt sur les traitements et salaires (I.T.S)' LIMIT 1)),

-- Étape 3: Application du barème progressif
('Application du barème progressif', 'Appliquer le barème progressif de l''I.T.S selon l''article 10 du Code Général des Impôts pour calculer l''impôt brut sur le revenu imposable.', 3,
 (SELECT id FROM procedures WHERE nom = 'Impôt sur les traitements et salaires (I.T.S)' LIMIT 1)),

-- Étape 4: Calcul des réductions pour charges de famille
('Calcul des réductions pour charges de famille', 'Appliquer les réductions pour charges de famille selon l''article 11 du Code Général des Impôts pour obtenir l''impôt net à payer.', 4,
 (SELECT id FROM procedures WHERE nom = 'Impôt sur les traitements et salaires (I.T.S)' LIMIT 1)),

-- Étape 5: Déclaration mensuelle
('Déclaration mensuelle', 'Établir et déposer la déclaration I.T.S mensuelle auprès du service des impôts compétent avant le 15 du mois suivant celui des paiements.', 5,
 (SELECT id FROM procedures WHERE nom = 'Impôt sur les traitements et salaires (I.T.S)' LIMIT 1)),

-- Étape 6: Paiement de l'impôt
('Paiement de l''impôt', 'Effectuer le paiement de l''I.T.S calculé selon les modalités et échéances fixées par la Direction Générale des Impôts.', 6,
 (SELECT id FROM procedures WHERE nom = 'Impôt sur les traitements et salaires (I.T.S)' LIMIT 1));

-- ============================================
-- 3.233. DOCUMENTS REQUIS POUR I.T.S
-- ============================================

INSERT INTO documents_requis (nom, description, obligatoire, procedure_id) VALUES
('Bulletins de salaire', 'Bulletins de salaire de tous les employés pour le mois concerné avec détail des rémunérations brutes et nettes.', true,
 (SELECT id FROM procedures WHERE nom = 'Impôt sur les traitements et salaires (I.T.S)' LIMIT 1)),

('Déclaration I.T.S', 'Formulaire de déclaration mensuelle de l''impôt sur les traitements et salaires, disponible auprès des services fiscaux.', true,
 (SELECT id FROM procedures WHERE nom = 'Impôt sur les traitements et salaires (I.T.S)' LIMIT 1)),

('Justificatifs des déductions', 'Documents justifiant les déductions effectuées : retenues pour pensions/retraites, allocations spéciales, etc.', true,
 (SELECT id FROM procedures WHERE nom = 'Impôt sur les traitements et salaires (I.T.S)' LIMIT 1)),

('Relevé des avantages en nature', 'Déclaration des avantages en nature accordés aux salariés avec leur évaluation selon l''article 6 du Code.', false,
 (SELECT id FROM procedures WHERE nom = 'Impôt sur les traitements et salaires (I.T.S)' LIMIT 1)),

('Attestation de charges de famille', 'Justificatifs des charges de famille pour l''application des réductions d''impôt selon l''article 11.', false,
 (SELECT id FROM procedures WHERE nom = 'Impôt sur les traitements et salaires (I.T.S)' LIMIT 1));

-- ============================================
-- 3.234. COÛTS DE LA PROCÉDURE I.T.S
-- ============================================

INSERT INTO couts (nom, prix, description) VALUES
('Barème progressif I.T.S', 0, 'Taux progressif selon le barème de l''article 10 du Code Général des Impôts - Variable selon le montant des revenus'),
('Réductions pour charges de famille', 0, 'Réductions d''impôt accordées pour charges de famille selon l''article 11 du Code'),
('Frais de déclaration', 0, 'Frais de traitement de la déclaration I.T.S - Montant fixé par la DGI'),
('Pénalités de retard', 0, 'Pénalités applicables en cas de retard dans la déclaration ou le paiement - 10% du montant dû'),
('Intérêts de retard', 0, 'Intérêts de retard calculés sur le montant de l''impôt non payé dans les délais');

-- Association des coûts à la procédure
UPDATE procedures 
SET cout_id = (SELECT id FROM couts WHERE nom = 'Barème progressif I.T.S' LIMIT 1)
WHERE nom = 'Impôt sur les traitements et salaires (I.T.S)';

-- ============================================
-- 3.235. ASSOCIATION DU CENTRE POUR I.T.S
-- ============================================

-- Association du centre à la procédure
UPDATE procedures 
SET centre_id = (SELECT id FROM centres WHERE nom = 'Direction Générale des Impôts (DGI)' LIMIT 1)
WHERE nom = 'Impôt sur les traitements et salaires (I.T.S)';

-- ============================================
-- 3.236. ARTICLES DE LOI POUR I.T.S
-- ============================================

INSERT INTO lois_articles (description, consulter_article, procedure_id) VALUES
-- Article 1 du Code Général des Impôts
('Article 1 - Champ d''application de l''I.T.S', 
 'L''article 1 du Code Général des Impôts institue l''impôt sur les traitements et salaires applicable à toutes les sommes payées aux salariés par les employeurs publics et privés, en contrepartie ou à l''occasion du travail.',
 (SELECT id FROM procedures WHERE nom = 'Impôt sur les traitements et salaires (I.T.S)' LIMIT 1)),

-- Articles 5-8 du Code Général des Impôts
('Articles 5-8 - Détermination de la base d''imposition', 
 'Les articles 5 à 8 du Code Général des Impôts définissent la détermination de la base d''imposition, incluant les déductions autorisées pour les retenues de pensions (limite 4%) et les allocations spéciales.',
 (SELECT id FROM procedures WHERE nom = 'Impôt sur les traitements et salaires (I.T.S)' LIMIT 1)),

-- Article 10 du Code Général des Impôts
('Article 10 - Barème progressif de l''I.T.S', 
 'L''article 10 du Code Général des Impôts fixe les taux applicables au revenu imposable selon un barème progressif pour le calcul de l''impôt sur les traitements et salaires.',
 (SELECT id FROM procedures WHERE nom = 'Impôt sur les traitements et salaires (I.T.S)' LIMIT 1)),

-- Article 11 du Code Général des Impôts
('Article 11 - Réductions pour charges de famille', 
 'L''article 11 du Code Général des Impôts prévoit l''application de réductions pour charges de famille à l''impôt brut calculé selon le barème progressif.',
 (SELECT id FROM procedures WHERE nom = 'Impôt sur les traitements et salaires (I.T.S)' LIMIT 1));

-- ============================================
-- 3.237. PROCÉDURE: DÉCLARATION DE TVA
-- ============================================

-- Insertion de la procédure
INSERT INTO procedures (nom, titre, delai, description, categorie_id, sous_categorie_id, date_creation) VALUES
('Déclaration de TVA (Taxe sur la Valeur Ajoutée)', 'Déclarer et payer la Taxe sur la Valeur Ajoutée', 'Mensuel - avant le 15 du mois suivant', 
 'La Taxe sur la Valeur Ajoutée (TVA) est un impôt indirect qui s''applique aux opérations de vente de biens et de prestations de services effectuées au Mali par les assujettis. La TVA est collectée par les entreprises assujetties et reversée à l''État. Les entreprises peuvent déduire la TVA qu''elles ont payée sur leurs achats de la TVA qu''elles collectent sur leurs ventes. La déclaration et le paiement sont mensuels pour la plupart des entreprises.',
 (SELECT id FROM categories WHERE titre = 'Impôt et Douane' LIMIT 1),
 (SELECT id FROM sous_categories WHERE titre = 'Déclaration de TVA (Taxe sur la Valeur Ajoutée)' LIMIT 1),
 NOW());

-- ============================================
-- 3.238. ÉTAPES DE LA PROCÉDURE TVA
-- ============================================

INSERT INTO etapes (nom, description, niveau, procedure_id) VALUES
-- Étape 1: Vérification de l'assujettissement
('Vérification de l''assujettissement', 'Vérifier que l''entreprise est assujettie à la TVA selon les critères définis par le Code Général des Impôts : chiffre d''affaires annuel, nature de l''activité, et respect des seuils d''assujettissement.', 1,
 (SELECT id FROM procedures WHERE nom = 'Déclaration de TVA (Taxe sur la Valeur Ajoutée)' LIMIT 1)),

-- Étape 2: Calcul de la TVA collectée
('Calcul de la TVA collectée', 'Calculer la TVA collectée sur les ventes et prestations de services effectuées au cours du mois, en appliquant le taux de TVA approprié (18% pour le taux normal).', 2,
 (SELECT id FROM procedures WHERE nom = 'Déclaration de TVA (Taxe sur la Valeur Ajoutée)' LIMIT 1)),

-- Étape 3: Calcul de la TVA déductible
('Calcul de la TVA déductible', 'Calculer la TVA déductible sur les achats et prestations reçues au cours du mois, en respectant les conditions de déductibilité prévues par le Code Général des Impôts.', 3,
 (SELECT id FROM procedures WHERE nom = 'Déclaration de TVA (Taxe sur la Valeur Ajoutée)' LIMIT 1)),

-- Étape 4: Détermination de la TVA à payer
('Détermination de la TVA à payer', 'Calculer la différence entre la TVA collectée et la TVA déductible pour déterminer le montant de TVA à payer ou le crédit de TVA à reporter.', 4,
 (SELECT id FROM procedures WHERE nom = 'Déclaration de TVA (Taxe sur la Valeur Ajoutée)' LIMIT 1)),

-- Étape 5: Déclaration mensuelle
('Déclaration mensuelle', 'Établir et déposer la déclaration de TVA mensuelle auprès du service des impôts compétent avant le 15 du mois suivant.', 5,
 (SELECT id FROM procedures WHERE nom = 'Déclaration de TVA (Taxe sur la Valeur Ajoutée)' LIMIT 1)),

-- Étape 6: Paiement de la TVA
('Paiement de la TVA', 'Effectuer le paiement de la TVA due selon les modalités et échéances fixées par la Direction Générale des Impôts.', 6,
 (SELECT id FROM procedures WHERE nom = 'Déclaration de TVA (Taxe sur la Valeur Ajoutée)' LIMIT 1));

-- ============================================
-- 3.239. DOCUMENTS REQUIS POUR TVA
-- ============================================

INSERT INTO documents_requis (nom, description, obligatoire, procedure_id) VALUES
('Déclaration de TVA', 'Formulaire de déclaration mensuelle de la Taxe sur la Valeur Ajoutée, disponible auprès des services fiscaux.', true,
 (SELECT id FROM procedures WHERE nom = 'Déclaration de TVA (Taxe sur la Valeur Ajoutée)' LIMIT 1)),

('Factures de ventes', 'Factures émises au cours du mois avec détail de la TVA collectée sur les ventes et prestations de services.', true,
 (SELECT id FROM procedures WHERE nom = 'Déclaration de TVA (Taxe sur la Valeur Ajoutée)' LIMIT 1)),

('Factures d''achats', 'Factures reçues au cours du mois avec détail de la TVA déductible sur les achats et prestations reçues.', true,
 (SELECT id FROM procedures WHERE nom = 'Déclaration de TVA (Taxe sur la Valeur Ajoutée)' LIMIT 1)),

('Livre de recettes', 'Livre de recettes tenu conformément aux obligations comptables pour justifier les ventes déclarées.', true,
 (SELECT id FROM procedures WHERE nom = 'Déclaration de TVA (Taxe sur la Valeur Ajoutée)' LIMIT 1)),

('Livre des achats', 'Livre des achats tenu conformément aux obligations comptables pour justifier les achats déclarés.', true,
 (SELECT id FROM procedures WHERE nom = 'Déclaration de TVA (Taxe sur la Valeur Ajoutée)' LIMIT 1)),

('Justificatifs des déductions', 'Documents justifiant les déductions de TVA effectuées selon les conditions prévues par le Code.', false,
 (SELECT id FROM procedures WHERE nom = 'Déclaration de TVA (Taxe sur la Valeur Ajoutée)' LIMIT 1));

-- ============================================
-- 3.240. COÛTS DE LA PROCÉDURE TVA
-- ============================================

INSERT INTO couts (nom, prix, description) VALUES
('Taux normal de TVA', 18, 'Taux normal de la Taxe sur la Valeur Ajoutée : 18% sur les ventes et prestations de services'),
('Taux réduit de TVA', 0, 'Taux réduit de TVA applicable à certains produits et services selon le Code Général des Impôts'),
('Frais de déclaration', 0, 'Frais de traitement de la déclaration de TVA - Montant fixé par la DGI'),
('Pénalités de retard', 0, 'Pénalités applicables en cas de retard dans la déclaration ou le paiement - 10% du montant dû'),
('Intérêts de retard', 0, 'Intérêts de retard calculés sur le montant de la TVA non payée dans les délais');

-- Association des coûts à la procédure
UPDATE procedures 
SET cout_id = (SELECT id FROM couts WHERE nom = 'Taux normal de TVA' LIMIT 1)
WHERE nom = 'Déclaration de TVA (Taxe sur la Valeur Ajoutée)';

-- ============================================
-- 3.241. ASSOCIATION DU CENTRE POUR TVA
-- ============================================

-- Association du centre à la procédure
UPDATE procedures 
SET centre_id = (SELECT id FROM centres WHERE nom = 'Direction Générale des Impôts (DGI)' LIMIT 1)
WHERE nom = 'Déclaration de TVA (Taxe sur la Valeur Ajoutée)';

-- ============================================
-- 3.242. ARTICLES DE LOI POUR TVA
-- ============================================

INSERT INTO lois_articles (description, consulter_article, procedure_id) VALUES
-- Titre 2 du Code Général des Impôts - TVA
('Titre 2 - Taxe sur la valeur ajoutée', 
 'Le Titre 2 du Code Général des Impôts définit les règles applicables à la Taxe sur la Valeur Ajoutée, notamment les opérations imposables, les notions d''assujettis, les exonérations, la territorialité, l''assiette, et les modalités de déduction.',
 (SELECT id FROM procedures WHERE nom = 'Déclaration de TVA (Taxe sur la Valeur Ajoutée)' LIMIT 1)),

-- Opérations imposables et assujettis
('Opérations imposables et notions d''assujettis', 
 'Les dispositions du Code Général des Impôts définissent les opérations imposables à la TVA (ventes de biens, prestations de services) et les critères d''assujettissement des entreprises.',
 (SELECT id FROM procedures WHERE nom = 'Déclaration de TVA (Taxe sur la Valeur Ajoutée)' LIMIT 1)),

-- Taux de la TVA
('Taux de la Taxe sur la Valeur Ajoutée', 
 'Le Code Général des Impôts fixe les taux de TVA applicables : taux normal et taux réduits selon la nature des produits et services.',
 (SELECT id FROM procedures WHERE nom = 'Déclaration de TVA (Taxe sur la Valeur Ajoutée)' LIMIT 1)),

-- Modalités de déduction
('Modalités d''exercice du droit à déduction', 
 'Le Code Général des Impôts précise les conditions et modalités d''exercice du droit à déduction de la TVA payée sur les achats et prestations reçues.',
 (SELECT id FROM procedures WHERE nom = 'Déclaration de TVA (Taxe sur la Valeur Ajoutée)' LIMIT 1));

-- ============================================
-- 3.243. PROCÉDURE: IMPÔT SUR LES BÉNÉFICES INDUSTRIELS ET COMMERCIAUX (IBIC/IS)
-- ============================================

-- Insertion de la procédure
INSERT INTO procedures (nom, titre, delai, description, categorie_id, sous_categorie_id, date_creation) VALUES
('Impôt sur les bénéfices industriels et commerciaux (IBIC/IS)', 'Déclarer et payer l''impôt sur les bénéfices', 'Annuel - avant le 31 mars de l''année suivante', 
 'L''impôt sur les bénéfices industriels et commerciaux (IBIC/IS) est un impôt direct qui s''applique aux bénéfices réalisés par les entreprises industrielles et commerciales au Mali. Il concerne les personnes physiques et morales exerçant une activité industrielle, commerciale ou artisanale. L''impôt est calculé sur le bénéfice net réalisé au cours de l''exercice comptable, après déduction des charges déductibles. Le taux d''imposition varie selon le montant du bénéfice et le statut de l''entreprise (personne physique ou morale).',
 (SELECT id FROM categories WHERE titre = 'Impôt et Douane' LIMIT 1),
 (SELECT id FROM sous_categories WHERE titre = 'Impôt sur les bénéfices industriels et commerciaux (IBIC/IS)' LIMIT 1),
 NOW());

-- ============================================
-- 3.244. ÉTAPES DE LA PROCÉDURE IBIC/IS
-- ============================================

INSERT INTO etapes (nom, description, niveau, procedure_id) VALUES
-- Étape 1: Vérification de l'assujettissement
('Vérification de l''assujettissement', 'Vérifier que l''entreprise est assujettie à l''IBIC/IS selon les critères définis par le Code Général des Impôts : exercice d''une activité industrielle, commerciale ou artisanale, et respect des seuils d''assujettissement.', 1,
 (SELECT id FROM procedures WHERE nom = 'Impôt sur les bénéfices industriels et commerciaux (IBIC/IS)' LIMIT 1)),

-- Étape 2: Établissement des comptes annuels
('Établissement des comptes annuels', 'Établir les comptes annuels (bilan, compte de résultat, annexe) conformément aux normes comptables en vigueur au Mali pour déterminer le bénéfice imposable.', 2,
 (SELECT id FROM procedures WHERE nom = 'Impôt sur les bénéfices industriels et commerciaux (IBIC/IS)' LIMIT 1)),

-- Étape 3: Calcul du bénéfice imposable
('Calcul du bénéfice imposable', 'Calculer le bénéfice imposable en appliquant les règles de déductibilité des charges selon le Code Général des Impôts et en réintégrant les charges non déductibles.', 3,
 (SELECT id FROM procedures WHERE nom = 'Impôt sur les bénéfices industriels et commerciaux (IBIC/IS)' LIMIT 1)),

-- Étape 4: Application du taux d'imposition
('Application du taux d''imposition', 'Appliquer le taux d''imposition approprié selon le montant du bénéfice et le statut de l''entreprise (personne physique ou morale) conformément au barème de l''IBIC/IS.', 4,
 (SELECT id FROM procedures WHERE nom = 'Impôt sur les bénéfices industriels et commerciaux (IBIC/IS)' LIMIT 1)),

-- Étape 5: Déclaration annuelle
('Déclaration annuelle', 'Établir et déposer la déclaration annuelle d''IBIC/IS auprès du service des impôts compétent avant le 31 mars de l''année suivant l''exercice.', 5,
 (SELECT id FROM procedures WHERE nom = 'Impôt sur les bénéfices industriels et commerciaux (IBIC/IS)' LIMIT 1)),

-- Étape 6: Paiement de l'impôt
('Paiement de l''impôt', 'Effectuer le paiement de l''IBIC/IS calculé selon les modalités et échéances fixées par la Direction Générale des Impôts.', 6,
 (SELECT id FROM procedures WHERE nom = 'Impôt sur les bénéfices industriels et commerciaux (IBIC/IS)' LIMIT 1));

-- ============================================
-- 3.245. DOCUMENTS REQUIS POUR IBIC/IS
-- ============================================

INSERT INTO documents_requis (nom, description, obligatoire, procedure_id) VALUES
('Déclaration IBIC/IS', 'Formulaire de déclaration annuelle de l''impôt sur les bénéfices industriels et commerciaux, disponible auprès des services fiscaux.', true,
 (SELECT id FROM procedures WHERE nom = 'Impôt sur les bénéfices industriels et commerciaux (IBIC/IS)' LIMIT 1)),

('Bilan comptable', 'Bilan comptable de l''exercice concerné établi conformément aux normes comptables en vigueur au Mali.', true,
 (SELECT id FROM procedures WHERE nom = 'Impôt sur les bénéfices industriels et commerciaux (IBIC/IS)' LIMIT 1)),

('Compte de résultat', 'Compte de résultat de l''exercice concerné avec détail des produits et charges.', true,
 (SELECT id FROM procedures WHERE nom = 'Impôt sur les bénéfices industriels et commerciaux (IBIC/IS)' LIMIT 1)),

('Annexe comptable', 'Annexe aux comptes annuels contenant les informations complémentaires et les justificatifs des écritures comptables.', true,
 (SELECT id FROM procedures WHERE nom = 'Impôt sur les bénéfices industriels et commerciaux (IBIC/IS)' LIMIT 1)),

('Grand livre général', 'Grand livre général de l''exercice concerné pour justifier les écritures comptables.', false,
 (SELECT id FROM procedures WHERE nom = 'Impôt sur les bénéfices industriels et commerciaux (IBIC/IS)' LIMIT 1)),

('Justificatifs des charges', 'Justificatifs des charges déductibles et non déductibles selon le Code Général des Impôts.', false,
 (SELECT id FROM procedures WHERE nom = 'Impôt sur les bénéfices industriels et commerciaux (IBIC/IS)' LIMIT 1));

-- ============================================
-- 3.246. COÛTS DE LA PROCÉDURE IBIC/IS
-- ============================================

INSERT INTO couts (nom, prix, description) VALUES
('Taux IBIC/IS - Personnes physiques', 0, 'Taux d''imposition de l''IBIC/IS pour les personnes physiques selon le barème progressif - Variable selon le bénéfice'),
('Taux IBIC/IS - Personnes morales', 0, 'Taux d''imposition de l''IBIC/IS pour les personnes morales selon le barème progressif - Variable selon le bénéfice'),
('Frais de déclaration', 0, 'Frais de traitement de la déclaration IBIC/IS - Montant fixé par la DGI'),
('Pénalités de retard', 0, 'Pénalités applicables en cas de retard dans la déclaration ou le paiement - 10% du montant dû'),
('Intérêts de retard', 0, 'Intérêts de retard calculés sur le montant de l''impôt non payé dans les délais');

-- Association des coûts à la procédure
UPDATE procedures 
SET cout_id = (SELECT id FROM couts WHERE nom = 'Taux IBIC/IS - Personnes physiques' LIMIT 1)
WHERE nom = 'Impôt sur les bénéfices industriels et commerciaux (IBIC/IS)';

-- ============================================
-- 3.247. ASSOCIATION DU CENTRE POUR IBIC/IS
-- ============================================

-- Association du centre à la procédure
UPDATE procedures 
SET centre_id = (SELECT id FROM centres WHERE nom = 'Direction Générale des Impôts (DGI)' LIMIT 1)
WHERE nom = 'Impôt sur les bénéfices industriels et commerciaux (IBIC/IS)';

-- ============================================
-- 3.248. ARTICLES DE LOI POUR IBIC/IS
-- ============================================

INSERT INTO lois_articles (description, consulter_article, procedure_id) VALUES
-- Chapitre sur l'IBIC/IS du Code Général des Impôts
('Chapitre IBIC/IS - Impôt sur les bénéfices industriels et commerciaux', 
 'Le chapitre relatif à l''IBIC/IS du Code Général des Impôts définit les règles applicables à l''impôt sur les bénéfices industriels et commerciaux, notamment le champ d''application, l''assiette, les taux d''imposition et les modalités de déclaration.',
 (SELECT id FROM procedures WHERE nom = 'Impôt sur les bénéfices industriels et commerciaux (IBIC/IS)' LIMIT 1)),

-- Règles de déductibilité des charges
('Règles de déductibilité des charges', 
 'Le Code Général des Impôts précise les règles de déductibilité des charges pour le calcul du bénéfice imposable, incluant les charges déductibles et non déductibles.',
 (SELECT id FROM procedures WHERE nom = 'Impôt sur les bénéfices industriels et commerciaux (IBIC/IS)' LIMIT 1)),

-- Barème de l'IBIC/IS
('Barème de l''IBIC/IS', 
 'Le Code Général des Impôts fixe les taux d''imposition de l''IBIC/IS selon un barème progressif, différencié entre les personnes physiques et les personnes morales.',
 (SELECT id FROM procedures WHERE nom = 'Impôt sur les bénéfices industriels et commerciaux (IBIC/IS)' LIMIT 1)),

-- Obligations déclaratives
('Obligations déclaratives IBIC/IS', 
 'Le Code Général des Impôts définit les obligations déclaratives des entreprises assujetties à l''IBIC/IS, notamment les délais de déclaration et les documents à fournir.',
 (SELECT id FROM procedures WHERE nom = 'Impôt sur les bénéfices industriels et commerciaux (IBIC/IS)' LIMIT 1));

-- ============================================
-- 3.249. PROCÉDURE: CONTRIBUTION FORFAITAIRE À LA CHARGE DES EMPLOYEURS (CFE)
-- ============================================

-- Insertion de la procédure
INSERT INTO procedures (nom, titre, delai, description, categorie_id, sous_categorie_id, date_creation) VALUES
('Contribution forfaitaire à la charge des employeurs (CFE)', 'Déclarer et payer la CFE', 'Mensuel - avant le 15 du mois suivant', 
 'La Contribution Forfaitaire à la charge des Employeurs (CFE) est un impôt direct qui s''applique aux employeurs publics et privés employant des salariés au Mali. Elle est calculée sur la masse salariale brute versée aux salariés au cours du mois. La CFE est destinée à financer les prestations sociales et les équipements collectifs. Le taux de la CFE est fixé par la réglementation en vigueur et peut varier selon le secteur d''activité et la taille de l''entreprise.',
 (SELECT id FROM categories WHERE titre = 'Impôt et Douane' LIMIT 1),
 (SELECT id FROM sous_categories WHERE titre = 'Contribution forfaitaire à la charge des employeurs (CFE)' LIMIT 1),
 NOW());

-- ============================================
-- 3.250. ÉTAPES DE LA PROCÉDURE CFE
-- ============================================

INSERT INTO etapes (nom, description, niveau, procedure_id) VALUES
-- Étape 1: Vérification de l'assujettissement
('Vérification de l''assujettissement', 'Vérifier que l''entreprise est assujettie à la CFE selon les critères définis par le Code Général des Impôts : emploi de salariés et respect des seuils d''assujettissement.', 1,
 (SELECT id FROM procedures WHERE nom = 'Contribution forfaitaire à la charge des employeurs (CFE)' LIMIT 1)),

-- Étape 2: Calcul de la masse salariale
('Calcul de la masse salariale', 'Calculer la masse salariale brute versée aux salariés au cours du mois, incluant tous les éléments de rémunération soumis à la CFE.', 2,
 (SELECT id FROM procedures WHERE nom = 'Contribution forfaitaire à la charge des employeurs (CFE)' LIMIT 1)),

-- Étape 3: Application du taux de CFE
('Application du taux de CFE', 'Appliquer le taux de CFE approprié selon le secteur d''activité et la taille de l''entreprise pour calculer le montant de la contribution due.', 3,
 (SELECT id FROM procedures WHERE nom = 'Contribution forfaitaire à la charge des employeurs (CFE)' LIMIT 1)),

-- Étape 4: Déclaration mensuelle
('Déclaration mensuelle', 'Établir et déposer la déclaration mensuelle de CFE auprès du service des impôts compétent avant le 15 du mois suivant.', 4,
 (SELECT id FROM procedures WHERE nom = 'Contribution forfaitaire à la charge des employeurs (CFE)' LIMIT 1)),

-- Étape 5: Paiement de la CFE
('Paiement de la CFE', 'Effectuer le paiement de la CFE calculée selon les modalités et échéances fixées par la Direction Générale des Impôts.', 5,
 (SELECT id FROM procedures WHERE nom = 'Contribution forfaitaire à la charge des employeurs (CFE)' LIMIT 1));

-- ============================================
-- 3.251. DOCUMENTS REQUIS POUR CFE
-- ============================================

INSERT INTO documents_requis (nom, description, obligatoire, procedure_id) VALUES
('Déclaration CFE', 'Formulaire de déclaration mensuelle de la Contribution Forfaitaire à la charge des Employeurs, disponible auprès des services fiscaux.', true,
 (SELECT id FROM procedures WHERE nom = 'Contribution forfaitaire à la charge des employeurs (CFE)' LIMIT 1)),

('Bulletins de salaire', 'Bulletins de salaire de tous les employés pour le mois concerné avec détail de la masse salariale brute.', true,
 (SELECT id FROM procedures WHERE nom = 'Contribution forfaitaire à la charge des employeurs (CFE)' LIMIT 1)),

('Relevé de paie', 'Relevé de paie mensuel récapitulatif de la masse salariale brute versée aux salariés.', true,
 (SELECT id FROM procedures WHERE nom = 'Contribution forfaitaire à la charge des employeurs (CFE)' LIMIT 1)),

('Justificatifs des rémunérations', 'Documents justifiant les rémunérations versées aux salariés et soumises à la CFE.', false,
 (SELECT id FROM procedures WHERE nom = 'Contribution forfaitaire à la charge des employeurs (CFE)' LIMIT 1));

-- ============================================
-- 3.252. COÛTS DE LA PROCÉDURE CFE
-- ============================================

INSERT INTO couts (nom, prix, description) VALUES
('Taux de CFE', 0, 'Taux de la Contribution Forfaitaire à la charge des Employeurs - Variable selon le secteur d''activité et la taille de l''entreprise'),
('Frais de déclaration', 0, 'Frais de traitement de la déclaration CFE - Montant fixé par la DGI'),
('Pénalités de retard', 0, 'Pénalités applicables en cas de retard dans la déclaration ou le paiement - 10% du montant dû'),
('Intérêts de retard', 0, 'Intérêts de retard calculés sur le montant de la CFE non payée dans les délais');

-- Association des coûts à la procédure
UPDATE procedures 
SET cout_id = (SELECT id FROM couts WHERE nom = 'Taux de CFE' LIMIT 1)
WHERE nom = 'Contribution forfaitaire à la charge des employeurs (CFE)';

-- ============================================
-- 3.253. ASSOCIATION DU CENTRE POUR CFE
-- ============================================

-- Association du centre à la procédure
UPDATE procedures 
SET centre_id = (SELECT id FROM centres WHERE nom = 'Direction Générale des Impôts (DGI)' LIMIT 1)
WHERE nom = 'Contribution forfaitaire à la charge des employeurs (CFE)';

-- ============================================
-- 3.254. ARTICLES DE LOI POUR CFE
-- ============================================

INSERT INTO lois_articles (description, consulter_article, procedure_id) VALUES
-- Chapitre CFE du Code Général des Impôts
('Chapitre CFE - Contribution forfaitaire à la charge des employeurs', 
 'Le chapitre relatif à la CFE du Code Général des Impôts définit les règles applicables à la Contribution Forfaitaire à la charge des Employeurs, notamment le champ d''application, l''assiette, les taux et les modalités de déclaration.',
 (SELECT id FROM procedures WHERE nom = 'Contribution forfaitaire à la charge des employeurs (CFE)' LIMIT 1)),

-- Assiette de la CFE
('Assiette de la CFE', 
 'Le Code Général des Impôts précise que la CFE est calculée sur la masse salariale brute versée aux salariés, incluant tous les éléments de rémunération.',
 (SELECT id FROM procedures WHERE nom = 'Contribution forfaitaire à la charge des employeurs (CFE)' LIMIT 1)),

-- Taux de la CFE
('Taux de la CFE', 
 'Le Code Général des Impôts fixe les taux de la CFE selon le secteur d''activité et la taille de l''entreprise, avec des taux différenciés.',
 (SELECT id FROM procedures WHERE nom = 'Contribution forfaitaire à la charge des employeurs (CFE)' LIMIT 1)),

-- Obligations déclaratives CFE
('Obligations déclaratives CFE', 
 'Le Code Général des Impôts définit les obligations déclaratives des employeurs assujettis à la CFE, notamment les délais de déclaration mensuelle.',
 (SELECT id FROM procedures WHERE nom = 'Contribution forfaitaire à la charge des employeurs (CFE)' LIMIT 1));

-- ============================================
-- 3.255. PROCÉDURE: CONTRIBUTION GÉNÉRALE DE SOLIDARITÉ (CGS)
-- ============================================

-- Insertion de la procédure
INSERT INTO procedures (nom, titre, delai, description, categorie_id, sous_categorie_id, date_creation) VALUES
('Contribution Générale de solidarité (CGS)', 'Déclarer et payer la Contribution Générale de solidarité', 'Mensuel - avant le 15 du mois suivant', 
 'La Contribution Générale de Solidarité (CGS) est instituée par la Loi N° 2018-010 du 12 Février 2018 pour une période de trois ans au profit du Fonds pour le Développement durable. Elle est assise sur le chiffre d''affaires hors taxe réalisé par les entreprises relevant de l''impôt sur les bénéfices industriels et commerciaux, de l''impôt sur les sociétés et de l''impôt synthétique. Le taux de la CGS est fixé à 0,5%. Le fait générateur et l''exigibilité se réalisent dans les mêmes conditions qu''en matière de TVA. La déclaration et l''acquittement suivent les mêmes délais et procédures que la TVA.',
 (SELECT id FROM categories WHERE titre = 'Impôt et Douane' LIMIT 1),
 (SELECT id FROM sous_categories WHERE titre = 'Contribution Générale de solidarité (CGS)' LIMIT 1),
 NOW());

-- ============================================
-- 3.256. ÉTAPES DE LA PROCÉDURE CGS
-- ============================================

INSERT INTO etapes (nom, description, niveau, procedure_id) VALUES
-- Étape 1: Vérification de l'assujettissement
('Vérification de l''assujettissement', 'Vérifier que l''entreprise est assujettie à la CGS selon l''article 3 de la Loi 2018-010 : entreprises relevant de l''IBIC, de l''impôt sur les sociétés et de l''impôt synthétique.', 1,
 (SELECT id FROM procedures WHERE nom = 'Contribution Générale de solidarité (CGS)' LIMIT 1)),

-- Étape 2: Calcul du chiffre d'affaires hors taxe
('Calcul du chiffre d''affaires hors taxe', 'Calculer le chiffre d''affaires hors taxe réalisé au cours du mois selon l''article 2 de la Loi 2018-010, base d''imposition de la CGS.', 2,
 (SELECT id FROM procedures WHERE nom = 'Contribution Générale de solidarité (CGS)' LIMIT 1)),

-- Étape 3: Application du taux de 0,5%
('Application du taux de 0,5%', 'Appliquer le taux de 0,5% fixé par l''article 4 de la Loi 2018-010 sur le chiffre d''affaires hors taxe pour calculer le montant de la CGS due.', 3,
 (SELECT id FROM procedures WHERE nom = 'Contribution Générale de solidarité (CGS)' LIMIT 1)),

-- Étape 4: Déclaration mensuelle
('Déclaration mensuelle', 'Établir et déposer la déclaration mensuelle de CGS selon l''article 7 de la Loi 2018-010, dans les mêmes délais et suivant les mêmes procédures que la TVA.', 4,
 (SELECT id FROM procedures WHERE nom = 'Contribution Générale de solidarité (CGS)' LIMIT 1)),

-- Étape 5: Paiement de la CGS
('Paiement de la CGS', 'Effectuer le paiement de la CGS calculée selon les modalités et échéances fixées par la Direction Générale des Impôts, dans les mêmes conditions que la TVA.', 5,
 (SELECT id FROM procedures WHERE nom = 'Contribution Générale de solidarité (CGS)' LIMIT 1));

-- ============================================
-- 3.257. DOCUMENTS REQUIS POUR CGS
-- ============================================

INSERT INTO documents_requis (nom, description, obligatoire, procedure_id) VALUES
('Déclaration CGS', 'Formulaire de déclaration mensuelle de la Contribution Générale de Solidarité, disponible auprès des services fiscaux selon l''article 7 de la Loi 2018-010.', true,
 (SELECT id FROM procedures WHERE nom = 'Contribution Générale de solidarité (CGS)' LIMIT 1)),

('Relevé de chiffre d''affaires', 'Relevé détaillé du chiffre d''affaires hors taxe réalisé au cours du mois, base d''imposition de la CGS.', true,
 (SELECT id FROM procedures WHERE nom = 'Contribution Générale de solidarité (CGS)' LIMIT 1)),

('Factures de ventes', 'Factures de ventes émises au cours du mois pour justifier le chiffre d''affaires déclaré.', true,
 (SELECT id FROM procedures WHERE nom = 'Contribution Générale de solidarité (CGS)' LIMIT 1)),

('Livre de recettes', 'Livre de recettes tenu conformément aux obligations comptables pour justifier le chiffre d''affaires déclaré.', false,
 (SELECT id FROM procedures WHERE nom = 'Contribution Générale de solidarité (CGS)' LIMIT 1));

-- ============================================
-- 3.258. COÛTS DE LA PROCÉDURE CGS
-- ============================================

INSERT INTO couts (nom, prix, description) VALUES
('Taux CGS', 0.5, 'Taux de la Contribution Générale de Solidarité : 0,5% du chiffre d''affaires hors taxe selon l''article 4 de la Loi 2018-010'),
('Frais de déclaration', 0, 'Frais de traitement de la déclaration CGS - Montant fixé par la DGI'),
('Pénalité de retard (5%)', 0, 'Pénalité de 5% des droits dus en cas de déclaration tardive sans mise en demeure selon l''article 8 de la Loi 2018-010'),
('Pénalité après mise en demeure (25%)', 0, 'Pénalité de 25% des droits dus en cas de déclaration après mise en demeure selon l''article 8 de la Loi 2018-010'),
('Pénalité minimum', 25000, 'Pénalité minimum de 25 000 Francs selon l''article 8 de la Loi 2018-010'),
('Pénalité taxation d''office (50%)', 0, 'Pénalité de 50% en cas de taxation d''office après 10 jours de mise en demeure selon l''article 8 de la Loi 2018-010');

-- Association des coûts à la procédure
UPDATE procedures 
SET cout_id = (SELECT id FROM couts WHERE nom = 'Taux CGS' LIMIT 1)
WHERE nom = 'Contribution Générale de solidarité (CGS)';

-- ============================================
-- 3.259. ASSOCIATION DU CENTRE POUR CGS
-- ============================================

-- Association du centre à la procédure
UPDATE procedures 
SET centre_id = (SELECT id FROM centres WHERE nom = 'Direction Générale des Impôts (DGI)' LIMIT 1)
WHERE nom = 'Contribution Générale de solidarité (CGS)';

-- ============================================
-- 3.260. ARTICLES DE LOI POUR CGS
-- ============================================

INSERT INTO lois_articles (description, consulter_article, procedure_id) VALUES
-- Loi N° 2018-010 du 12 Février 2018
('Loi N° 2018-010 du 12 Février 2018 - Titre I CGS', 
 'La Loi N° 2018-010 du 12 Février 2018 institue la Contribution Générale de Solidarité pour une période de trois ans au profit du Fonds pour le Développement durable. Elle est assise sur le chiffre d''affaires hors taxe des entreprises relevant de l''IBIC, de l''impôt sur les sociétés et de l''impôt synthétique.',
 (SELECT id FROM procedures WHERE nom = 'Contribution Générale de solidarité (CGS)' LIMIT 1)),

-- Article 4 - Taux de la CGS
('Article 4 - Taux de la CGS', 
 'L''article 4 de la Loi 2018-010 fixe le taux de la Contribution Générale de Solidarité à 0,5% du chiffre d''affaires hors taxe.',
 (SELECT id FROM procedures WHERE nom = 'Contribution Générale de solidarité (CGS)' LIMIT 1)),

-- Article 7 - Déclaration et acquittement
('Article 7 - Déclaration et acquittement', 
 'L''article 7 de la Loi 2018-010 précise que la CGS est déclarée et acquittée dans les mêmes délais et suivant les mêmes procédures que la TVA, avec utilisation des imprimés appropriés mis à disposition par la DGI.',
 (SELECT id FROM procedures WHERE nom = 'Contribution Générale de solidarité (CGS)' LIMIT 1)),

-- Article 8 - Pénalités
('Article 8 - Pénalités et sanctions', 
 'L''article 8 de la Loi 2018-010 définit les pénalités applicables : 5% pour déclaration tardive, 25% après mise en demeure, 50% pour taxation d''office, avec un minimum de 25 000 Francs.',
 (SELECT id FROM procedures WHERE nom = 'Contribution Générale de solidarité (CGS)' LIMIT 1));

-- ============================================
-- 3.261. PROCÉDURE: TAXE DE SOLIDARITÉ ET DE LUTTE CONTRE LE TABAGISME (TSLT)
-- ============================================

-- Insertion de la procédure
INSERT INTO procedures (nom, titre, delai, description, categorie_id, sous_categorie_id, date_creation) VALUES
('Taxe de Solidarité et de Lutte contre le Tabagisme (TSLT)', 'Déclarer et payer la TSLT', 'Variable selon le type d''opération', 
 'La Taxe de Solidarité et de Lutte contre le Tabagisme (TSLT) est instituée par la Loi N° 2018-010 du 12 Février 2018 pour une période de trois ans au profit du Fonds pour le Développement durable. Elle est due par les fabricants et les importateurs de tabacs à l''importation ou lors de la livraison à la consommation. Le taux de la TSLT est fixé à 5%. Le fait générateur est constitué par la mise à la consommation pour les produits importés et par la première livraison à la consommation pour les produits fabriqués localement.',
 (SELECT id FROM categories WHERE titre = 'Impôt et Douane' LIMIT 1),
 (SELECT id FROM sous_categories WHERE titre = 'Taxe de Solidarité et de Lutte contre le Tabagisme (TSLT)' LIMIT 1),
 NOW());

-- ============================================
-- 3.262. ÉTAPES DE LA PROCÉDURE TSLT
-- ============================================

INSERT INTO etapes (nom, description, niveau, procedure_id) VALUES
-- Étape 1: Vérification de l'assujettissement
('Vérification de l''assujettissement', 'Vérifier que l''entreprise est assujettie à la TSLT selon l''article 11 de la Loi 2018-010 : fabricants et importateurs de tabacs.', 1,
 (SELECT id FROM procedures WHERE nom = 'Taxe de Solidarité et de Lutte contre le Tabagisme (TSLT)' LIMIT 1)),

-- Étape 2: Détermination du fait générateur
('Détermination du fait générateur', 'Déterminer le fait générateur selon l''article 12 de la Loi 2018-010 : mise à la consommation pour les produits importés, première livraison à la consommation pour les produits fabriqués localement.', 2,
 (SELECT id FROM procedures WHERE nom = 'Taxe de Solidarité et de Lutte contre le Tabagisme (TSLT)' LIMIT 1)),

-- Étape 3: Calcul de la base d'imposition
('Calcul de la base d''imposition', 'Calculer la base d''imposition selon l''article 13 de la Loi 2018-010 : valeur en douane majorée des droits et taxes (importation) ou prix de vente sortie-usine (fabrication locale), hors TVA.', 3,
 (SELECT id FROM procedures WHERE nom = 'Taxe de Solidarité et de Lutte contre le Tabagisme (TSLT)' LIMIT 1)),

-- Étape 4: Application du taux de 5%
('Application du taux de 5%', 'Appliquer le taux de 5% fixé par l''article 14 de la Loi 2018-010 sur la base d''imposition pour calculer le montant de la TSLT due.', 4,
 (SELECT id FROM procedures WHERE nom = 'Taxe de Solidarité et de Lutte contre le Tabagisme (TSLT)' LIMIT 1)),

-- Étape 5: Déclaration et paiement
('Déclaration et paiement', 'Établir et déposer la déclaration de TSLT et effectuer le paiement selon les modalités fixées par la Direction Générale des Impôts.', 5,
 (SELECT id FROM procedures WHERE nom = 'Taxe de Solidarité et de Lutte contre le Tabagisme (TSLT)' LIMIT 1));

-- ============================================
-- 3.263. DOCUMENTS REQUIS POUR TSLT
-- ============================================

INSERT INTO documents_requis (nom, description, obligatoire, procedure_id) VALUES
('Déclaration TSLT', 'Formulaire de déclaration de la Taxe de Solidarité et de Lutte contre le Tabagisme, disponible auprès des services fiscaux.', true,
 (SELECT id FROM procedures WHERE nom = 'Taxe de Solidarité et de Lutte contre le Tabagisme (TSLT)' LIMIT 1)),

('Documents d''importation', 'Documents douaniers pour les produits importés : déclaration en douane, facture commerciale, certificat d''origine.', true,
 (SELECT id FROM procedures WHERE nom = 'Taxe de Solidarité et de Lutte contre le Tabagisme (TSLT)' LIMIT 1)),

('Documents de fabrication', 'Documents de fabrication pour les produits fabriqués localement : factures de vente, bons de livraison, registres de production.', true,
 (SELECT id FROM procedures WHERE nom = 'Taxe de Solidarité et de Lutte contre le Tabagisme (TSLT)' LIMIT 1)),

('Justificatifs de prix', 'Justificatifs des prix de vente ou de revient selon le cas, pour le calcul de la base d''imposition.', true,
 (SELECT id FROM procedures WHERE nom = 'Taxe de Solidarité et de Lutte contre le Tabagisme (TSLT)' LIMIT 1)),

('Autorisation d''exercice', 'Autorisation d''exercice d''activité de fabrication ou d''importation de tabacs.', false,
 (SELECT id FROM procedures WHERE nom = 'Taxe de Solidarité et de Lutte contre le Tabagisme (TSLT)' LIMIT 1));

-- ============================================
-- 3.264. COÛTS DE LA PROCÉDURE TSLT
-- ============================================

INSERT INTO couts (nom, prix, description) VALUES
('Taux TSLT', 5, 'Taux de la Taxe de Solidarité et de Lutte contre le Tabagisme : 5% selon l''article 14 de la Loi 2018-010'),
('Frais de déclaration', 0, 'Frais de traitement de la déclaration TSLT - Montant fixé par la DGI'),
('Pénalités de retard', 0, 'Pénalités applicables en cas de retard dans la déclaration ou le paiement selon les dispositions générales'),
('Intérêts de retard', 0, 'Intérêts de retard calculés sur le montant de la TSLT non payée dans les délais');

-- Association des coûts à la procédure
UPDATE procedures 
SET cout_id = (SELECT id FROM couts WHERE nom = 'Taux TSLT' LIMIT 1)
WHERE nom = 'Taxe de Solidarité et de Lutte contre le Tabagisme (TSLT)';

-- ============================================
-- 3.265. ASSOCIATION DU CENTRE POUR TSLT
-- ============================================

-- Association du centre à la procédure
UPDATE procedures 
SET centre_id = (SELECT id FROM centres WHERE nom = 'Direction Générale des Impôts (DGI)' LIMIT 1)
WHERE nom = 'Taxe de Solidarité et de Lutte contre le Tabagisme (TSLT)';

-- ============================================
-- 3.266. ARTICLES DE LOI POUR TSLT
-- ============================================

INSERT INTO lois_articles (description, consulter_article, procedure_id) VALUES
-- Loi N° 2018-010 du 12 Février 2018 - Titre II
('Loi N° 2018-010 du 12 Février 2018 - Titre II TSLT', 
 'La Loi N° 2018-010 du 12 Février 2018 institue la Taxe de Solidarité et de Lutte contre le Tabagisme pour une période de trois ans au profit du Fonds pour le Développement durable. Elle est due par les fabricants et importateurs de tabacs.',
 (SELECT id FROM procedures WHERE nom = 'Taxe de Solidarité et de Lutte contre le Tabagisme (TSLT)' LIMIT 1)),

-- Article 12 - Fait générateur
('Article 12 - Fait générateur de la TSLT', 
 'L''article 12 de la Loi 2018-010 définit le fait générateur : mise à la consommation pour les produits importés, première livraison à la consommation pour les produits fabriqués localement.',
 (SELECT id FROM procedures WHERE nom = 'Taxe de Solidarité et de Lutte contre le Tabagisme (TSLT)' LIMIT 1)),

-- Article 13 - Base d'imposition
('Article 13 - Base d''imposition de la TSLT', 
 'L''article 13 de la Loi 2018-010 définit la base d''imposition : valeur en douane majorée des droits et taxes (importation) ou prix de vente sortie-usine (fabrication), hors TVA.',
 (SELECT id FROM procedures WHERE nom = 'Taxe de Solidarité et de Lutte contre le Tabagisme (TSLT)' LIMIT 1)),

-- Article 14 - Taux de la TSLT
('Article 14 - Taux de la TSLT', 
 'L''article 14 de la Loi 2018-010 fixe le taux de la Taxe de Solidarité et de Lutte contre le Tabagisme à 5% de la base d''imposition.',
 (SELECT id FROM procedures WHERE nom = 'Taxe de Solidarité et de Lutte contre le Tabagisme (TSLT)' LIMIT 1));

-- ============================================
-- 3.267. PROCÉDURE: PATENTE PROFESSIONNELLE ET LICENCE
-- ============================================

-- Insertion de la procédure
INSERT INTO procedures (nom, titre, delai, description, categorie_id, sous_categorie_id, date_creation) VALUES
('Patente professionnelle et licence', 'Obtenir la patente professionnelle et licence', 'Variable selon le type d''activité', 
 'La patente professionnelle est un impôt direct qui s''applique aux personnes physiques et morales exerçant une activité professionnelle au Mali. Elle constitue une taxe annuelle due par les commerçants, industriels, artisans et prestataires de services. La patente est calculée selon un barème progressif basé sur le chiffre d''affaires ou les bénéfices de l''entreprise. Elle comprend également une licence qui autorise l''exercice de l''activité. Le paiement de la patente est obligatoire pour toute personne exerçant une activité professionnelle soumise à cet impôt.',
 (SELECT id FROM categories WHERE titre = 'Impôt et Douane' LIMIT 1),
 (SELECT id FROM sous_categories WHERE titre = 'Patente professionnelle et licence' LIMIT 1),
 NOW());

-- ============================================
-- 3.268. ÉTAPES DE LA PROCÉDURE PATENTE
-- ============================================

INSERT INTO etapes (nom, description, niveau, procedure_id) VALUES
-- Étape 1: Vérification de l'assujettissement
('Vérification de l''assujettissement', 'Vérifier que l''activité exercée est soumise à la patente professionnelle selon le Code Général des Impôts : commerce, industrie, artisanat, prestations de services.', 1,
 (SELECT id FROM procedures WHERE nom = 'Patente professionnelle et licence' LIMIT 1)),

-- Étape 2: Détermination de la catégorie
('Détermination de la catégorie', 'Déterminer la catégorie de patente applicable selon l''activité exercée et le chiffre d''affaires réalisé, conformément au barème de patente.', 2,
 (SELECT id FROM procedures WHERE nom = 'Patente professionnelle et licence' LIMIT 1)),

-- Étape 3: Calcul du montant de la patente
('Calcul du montant de la patente', 'Calculer le montant de la patente selon le barème progressif applicable, en fonction du chiffre d''affaires ou des bénéfices déclarés.', 3,
 (SELECT id FROM procedures WHERE nom = 'Patente professionnelle et licence' LIMIT 1)),

-- Étape 4: Déclaration et paiement
('Déclaration et paiement', 'Établir et déposer la déclaration de patente et effectuer le paiement selon les modalités et échéances fixées par la Direction Générale des Impôts.', 4,
 (SELECT id FROM procedures WHERE nom = 'Patente professionnelle et licence' LIMIT 1)),

-- Étape 5: Obtention de la licence
('Obtention de la licence', 'Obtenir la licence d''exercice de l''activité professionnelle après paiement de la patente, permettant l''exercice légal de l''activité.', 5,
 (SELECT id FROM procedures WHERE nom = 'Patente professionnelle et licence' LIMIT 1));

-- ============================================
-- 3.269. DOCUMENTS REQUIS POUR PATENTE
-- ============================================

INSERT INTO documents_requis (nom, description, obligatoire, procedure_id) VALUES
('Déclaration de patente', 'Formulaire de déclaration de patente professionnelle, disponible auprès des services fiscaux.', true,
 (SELECT id FROM procedures WHERE nom = 'Patente professionnelle et licence' LIMIT 1)),

('Justificatif d''activité', 'Justificatif de l''activité exercée : certificat d''immatriculation, autorisation d''exercice, ou tout document attestant de l''activité.', true,
 (SELECT id FROM procedures WHERE nom = 'Patente professionnelle et licence' LIMIT 1)),

('Relevé de chiffre d''affaires', 'Relevé du chiffre d''affaires réalisé ou des bénéfices déclarés pour le calcul de la patente.', true,
 (SELECT id FROM procedures WHERE nom = 'Patente professionnelle et licence' LIMIT 1)),

('Pièce d''identité', 'Pièce d''identité du contribuable (carte d''identité, passeport) ou du représentant légal.', true,
 (SELECT id FROM procedures WHERE nom = 'Patente professionnelle et licence' LIMIT 1)),

('Justificatif de domiciliation', 'Justificatif de l''adresse du siège de l''activité ou du domicile du contribuable.', false,
 (SELECT id FROM procedures WHERE nom = 'Patente professionnelle et licence' LIMIT 1));

-- ============================================
-- 3.270. COÛTS DE LA PROCÉDURE PATENTE
-- ============================================

INSERT INTO couts (nom, prix, description) VALUES
('Barème progressif de patente', 0, 'Montant de la patente calculé selon le barème progressif en fonction du chiffre d''affaires ou des bénéfices - Variable selon l''activité'),
('Frais de déclaration', 0, 'Frais de traitement de la déclaration de patente - Montant fixé par la DGI'),
('Frais de licence', 0, 'Frais d''établissement de la licence d''exercice - Montant fixé par la DGI'),
('Pénalités de retard', 0, 'Pénalités applicables en cas de retard dans la déclaration ou le paiement de la patente'),
('Intérêts de retard', 0, 'Intérêts de retard calculés sur le montant de la patente non payée dans les délais');

-- Association des coûts à la procédure
UPDATE procedures 
SET cout_id = (SELECT id FROM couts WHERE nom = 'Barème progressif de patente' LIMIT 1)
WHERE nom = 'Patente professionnelle et licence';

-- ============================================
-- 3.271. ASSOCIATION DU CENTRE POUR PATENTE
-- ============================================

-- Association du centre à la procédure
UPDATE procedures 
SET centre_id = (SELECT id FROM centres WHERE nom = 'Direction Générale des Impôts (DGI)' LIMIT 1)
WHERE nom = 'Patente professionnelle et licence';

-- ============================================
-- 3.272. ARTICLES DE LOI POUR PATENTE
-- ============================================

INSERT INTO lois_articles (description, consulter_article, procedure_id) VALUES
-- Chapitre II - Contribution des patentes et licences
('Chapitre II - Contribution des patentes et licences', 
 'Le Chapitre II du Code Général des Impôts définit les règles applicables à la patente professionnelle, notamment le champ d''application, l''assiette, les taux et les modalités de déclaration.',
 (SELECT id FROM procedures WHERE nom = 'Patente professionnelle et licence' LIMIT 1)),

-- Barème de patente
('Barème de patente', 
 'Le Code Général des Impôts fixe un barème progressif pour le calcul de la patente professionnelle selon le chiffre d''affaires ou les bénéfices réalisés par l''entreprise.',
 (SELECT id FROM procedures WHERE nom = 'Patente professionnelle et licence' LIMIT 1)),

-- Obligations déclaratives patente
('Obligations déclaratives patente', 
 'Le Code Général des Impôts définit les obligations déclaratives des contribuables assujettis à la patente, notamment les délais de déclaration et les documents à fournir.',
 (SELECT id FROM procedures WHERE nom = 'Patente professionnelle et licence' LIMIT 1)),

-- Licence d'exercice
('Licence d''exercice', 
 'La licence d''exercice est délivrée après paiement de la patente et autorise l''exercice de l''activité professionnelle conformément à la réglementation en vigueur.',
 (SELECT id FROM procedures WHERE nom = 'Patente professionnelle et licence' LIMIT 1));

-- ============================================
-- 3.273. PROCÉDURE: TAXE SUR LES VÉHICULES AUTOMOBILES (VIGNETTES ORDINAIRES)
-- ============================================

-- Insertion de la procédure
INSERT INTO procedures (nom, titre, delai, description, categorie_id, sous_categorie_id, date_creation) VALUES
('Taxe sur les véhicules automobiles (Vignettes ordinaires)', 'Obtenir la vignette automobile', 'Annuel - avant le 31 décembre', 
 'La taxe sur les véhicules automobiles, communément appelée vignette, est un impôt direct annuel dû par les propriétaires de véhicules automobiles au Mali. Elle s''applique à tous les véhicules automobiles immatriculés au Mali, qu''ils soient utilisés à des fins personnelles ou professionnelles. Le montant de la vignette varie selon la puissance fiscale du véhicule, son type (particulier, commercial, transport en commun) et son âge. Le paiement de la vignette est obligatoire et conditionne la validité de l''immatriculation du véhicule.',
 (SELECT id FROM categories WHERE titre = 'Impôt et Douane' LIMIT 1),
 (SELECT id FROM sous_categories WHERE titre = 'Taxe sur les véhicules automobiles (Vignettes ordinaires)' LIMIT 1),
 NOW());

-- ============================================
-- 3.274. ÉTAPES DE LA PROCÉDURE VIGNETTE
-- ============================================

INSERT INTO etapes (nom, description, niveau, procedure_id) VALUES
-- Étape 1: Vérification de l'assujettissement
('Vérification de l''assujettissement', 'Vérifier que le véhicule est soumis à la vignette selon le Code Général des Impôts : véhicules automobiles immatriculés au Mali.', 1,
 (SELECT id FROM procedures WHERE nom = 'Taxe sur les véhicules automobiles (Vignettes ordinaires)' LIMIT 1)),

-- Étape 2: Détermination de la catégorie
('Détermination de la catégorie', 'Déterminer la catégorie de vignette applicable selon le type de véhicule, sa puissance fiscale et son usage (particulier, commercial, transport).', 2,
 (SELECT id FROM procedures WHERE nom = 'Taxe sur les véhicules automobiles (Vignettes ordinaires)' LIMIT 1)),

-- Étape 3: Calcul du montant de la vignette
('Calcul du montant de la vignette', 'Calculer le montant de la vignette selon le barème applicable, en fonction de la puissance fiscale et de la catégorie du véhicule.', 3,
 (SELECT id FROM procedures WHERE nom = 'Taxe sur les véhicules automobiles (Vignettes ordinaires)' LIMIT 1)),

-- Étape 4: Paiement de la vignette
('Paiement de la vignette', 'Effectuer le paiement de la vignette selon les modalités et échéances fixées par la Direction Générale des Impôts.', 4,
 (SELECT id FROM procedures WHERE nom = 'Taxe sur les véhicules automobiles (Vignettes ordinaires)' LIMIT 1)),

-- Étape 5: Obtention de la vignette
('Obtention de la vignette', 'Obtenir la vignette automobile après paiement, à apposer sur le véhicule conformément à la réglementation.', 5,
 (SELECT id FROM procedures WHERE nom = 'Taxe sur les véhicules automobiles (Vignettes ordinaires)' LIMIT 1));

-- ============================================
-- 3.275. DOCUMENTS REQUIS POUR VIGNETTE
-- ============================================

INSERT INTO documents_requis (nom, description, obligatoire, procedure_id) VALUES
('Carte grise', 'Carte grise du véhicule (certificat d''immatriculation) en cours de validité.', true,
 (SELECT id FROM procedures WHERE nom = 'Taxe sur les véhicules automobiles (Vignettes ordinaires)' LIMIT 1)),

('Pièce d''identité', 'Pièce d''identité du propriétaire du véhicule (carte d''identité, passeport).', true,
 (SELECT id FROM procedures WHERE nom = 'Taxe sur les véhicules automobiles (Vignettes ordinaires)' LIMIT 1)),

('Justificatif de propriété', 'Justificatif de propriété du véhicule ou procuration si le demandeur n''est pas le propriétaire.', true,
 (SELECT id FROM procedures WHERE nom = 'Taxe sur les véhicules automobiles (Vignettes ordinaires)' LIMIT 1)),

('Vignette de l''année précédente', 'Vignette de l''année précédente, si disponible, pour vérification.', false,
 (SELECT id FROM procedures WHERE nom = 'Taxe sur les véhicules automobiles (Vignettes ordinaires)' LIMIT 1));

-- ============================================
-- 3.276. COÛTS DE LA PROCÉDURE VIGNETTE
-- ============================================

INSERT INTO couts (nom, prix, description) VALUES
('Barème vignette véhicules particuliers', 0, 'Montant de la vignette pour véhicules particuliers selon la puissance fiscale - Variable selon le véhicule'),
('Barème vignette véhicules commerciaux', 0, 'Montant de la vignette pour véhicules commerciaux selon la puissance fiscale - Variable selon le véhicule'),
('Barème vignette transport en commun', 0, 'Montant de la vignette pour véhicules de transport en commun selon la puissance fiscale - Variable selon le véhicule'),
('Frais de délivrance', 0, 'Frais de délivrance de la vignette - Montant fixé par la DGI'),
('Pénalités de retard', 0, 'Pénalités applicables en cas de retard dans le paiement de la vignette');

-- Association des coûts à la procédure
UPDATE procedures 
SET cout_id = (SELECT id FROM couts WHERE nom = 'Barème vignette véhicules particuliers' LIMIT 1)
WHERE nom = 'Taxe sur les véhicules automobiles (Vignettes ordinaires)';

-- ============================================
-- 3.277. ASSOCIATION DU CENTRE POUR VIGNETTE
-- ============================================

-- Association du centre à la procédure
UPDATE procedures 
SET centre_id = (SELECT id FROM centres WHERE nom = 'Direction Générale des Impôts (DGI)' LIMIT 1)
WHERE nom = 'Taxe sur les véhicules automobiles (Vignettes ordinaires)';

-- ============================================
-- 3.278. ARTICLES DE LOI POUR VIGNETTE
-- ============================================

INSERT INTO lois_articles (description, consulter_article, procedure_id) VALUES
-- Section III - Taxe sur les véhicules automobiles
('Section III - Taxe sur les véhicules automobiles', 
 'La Section III du Code Général des Impôts définit les règles applicables à la taxe sur les véhicules automobiles (vignette), notamment le champ d''application, l''assiette et les modalités de paiement.',
 (SELECT id FROM procedures WHERE nom = 'Taxe sur les véhicules automobiles (Vignettes ordinaires)' LIMIT 1)),

-- Barème de vignette
('Barème de vignette', 
 'Le Code Général des Impôts fixe un barème différencié pour le calcul de la vignette selon le type de véhicule, sa puissance fiscale et son usage.',
 (SELECT id FROM procedures WHERE nom = 'Taxe sur les véhicules automobiles (Vignettes ordinaires)' LIMIT 1)),

-- Obligations de paiement
('Obligations de paiement', 
 'Le Code Général des Impôts définit les obligations de paiement de la vignette, notamment les délais et les modalités de paiement.',
 (SELECT id FROM procedures WHERE nom = 'Taxe sur les véhicules automobiles (Vignettes ordinaires)' LIMIT 1)),

-- Sanctions et pénalités
('Sanctions et pénalités', 
 'Le Code Général des Impôts prévoit des sanctions et pénalités en cas de non-paiement ou de retard dans le paiement de la vignette.',
 (SELECT id FROM procedures WHERE nom = 'Taxe sur les véhicules automobiles (Vignettes ordinaires)' LIMIT 1));

-- ============================================
-- 3.279. PROCÉDURE: TAXE FONCIÈRE (T.F)
-- ============================================

-- Insertion de la procédure
INSERT INTO procedures (nom, titre, delai, description, categorie_id, sous_categorie_id, date_creation) VALUES
('Taxe foncière (T.F)', 'Payer la taxe foncière', 'Annuel - avant le 31 décembre', 
 'La taxe foncière est un impôt direct annuel qui s''applique aux propriétaires de biens immobiliers au Mali. Elle concerne tous les terrains, constructions et installations fixes situés sur le territoire malien. La taxe foncière est calculée sur la valeur locative cadastrale des biens immobiliers. Elle est due par le propriétaire du bien au 1er janvier de l''année d''imposition. Le paiement de la taxe foncière est obligatoire et conditionne la jouissance paisible du bien immobilier.',
 (SELECT id FROM categories WHERE titre = 'Impôt et Douane' LIMIT 1),
 (SELECT id FROM sous_categories WHERE titre = 'Taxe foncière (T.F)' LIMIT 1),
 NOW());

-- ============================================
-- 3.280. ÉTAPES DE LA PROCÉDURE TAXE FONCIÈRE
-- ============================================

INSERT INTO etapes (nom, description, niveau, procedure_id) VALUES
-- Étape 1: Vérification de l'assujettissement
('Vérification de l''assujettissement', 'Vérifier que le bien immobilier est soumis à la taxe foncière selon le Code Général des Impôts : terrains, constructions et installations fixes.', 1,
 (SELECT id FROM procedures WHERE nom = 'Taxe foncière (T.F)' LIMIT 1)),

-- Étape 2: Détermination de la valeur locative
('Détermination de la valeur locative', 'Déterminer la valeur locative cadastrale du bien immobilier, base de calcul de la taxe foncière selon les règles cadastrales.', 2,
 (SELECT id FROM procedures WHERE nom = 'Taxe foncière (T.F)' LIMIT 1)),

-- Étape 3: Calcul de la taxe foncière
('Calcul de la taxe foncière', 'Calculer le montant de la taxe foncière selon le taux applicable sur la valeur locative cadastrale du bien.', 3,
 (SELECT id FROM procedures WHERE nom = 'Taxe foncière (T.F)' LIMIT 1)),

-- Étape 4: Paiement de la taxe
('Paiement de la taxe', 'Effectuer le paiement de la taxe foncière selon les modalités et échéances fixées par la Direction Générale des Impôts.', 4,
 (SELECT id FROM procedures WHERE nom = 'Taxe foncière (T.F)' LIMIT 1)),

-- Étape 5: Obtention du quitus
('Obtention du quitus', 'Obtenir le quitus de paiement de la taxe foncière, attestant du règlement de l''impôt pour l''année concernée.', 5,
 (SELECT id FROM procedures WHERE nom = 'Taxe foncière (T.F)' LIMIT 1));

-- ============================================
-- 3.281. DOCUMENTS REQUIS POUR TAXE FONCIÈRE
-- ============================================

INSERT INTO documents_requis (nom, description, obligatoire, procedure_id) VALUES
('Titre de propriété', 'Titre de propriété du bien immobilier (acte de vente, acte de donation, jugement, etc.).', true,
 (SELECT id FROM procedures WHERE nom = 'Taxe foncière (T.F)' LIMIT 1)),

('Pièce d''identité', 'Pièce d''identité du propriétaire du bien (carte d''identité, passeport).', true,
 (SELECT id FROM procedures WHERE nom = 'Taxe foncière (T.F)' LIMIT 1)),

('Avis d''imposition', 'Avis d''imposition de la taxe foncière pour l''année concernée, délivré par les services fiscaux.', true,
 (SELECT id FROM procedures WHERE nom = 'Taxe foncière (T.F)' LIMIT 1)),

('Plan cadastral', 'Plan cadastral du bien immobilier, si disponible, pour vérification de la superficie.', false,
 (SELECT id FROM procedures WHERE nom = 'Taxe foncière (T.F)' LIMIT 1));

-- ============================================
-- 3.282. COÛTS DE LA PROCÉDURE TAXE FONCIÈRE
-- ============================================

INSERT INTO couts (nom, prix, description) VALUES
('Taux de taxe foncière', 0, 'Taux de la taxe foncière appliqué sur la valeur locative cadastrale - Variable selon la localisation et le type de bien'),
('Frais de délivrance', 0, 'Frais de délivrance de l''avis d''imposition et du quitus - Montant fixé par la DGI'),
('Pénalités de retard', 0, 'Pénalités applicables en cas de retard dans le paiement de la taxe foncière'),
('Intérêts de retard', 0, 'Intérêts de retard calculés sur le montant de la taxe non payée dans les délais');

-- Association des coûts à la procédure
UPDATE procedures 
SET cout_id = (SELECT id FROM couts WHERE nom = 'Taux de taxe foncière' LIMIT 1)
WHERE nom = 'Taxe foncière (T.F)';

-- ============================================
-- 3.283. ASSOCIATION DU CENTRE POUR TAXE FONCIÈRE
-- ============================================

-- Association du centre à la procédure
UPDATE procedures 
SET centre_id = (SELECT id FROM centres WHERE nom = 'Direction Générale des Impôts (DGI)' LIMIT 1)
WHERE nom = 'Taxe foncière (T.F)';

-- ============================================
-- 3.284. ARTICLES DE LOI POUR TAXE FONCIÈRE
-- ============================================

INSERT INTO lois_articles (description, consulter_article, procedure_id) VALUES
-- Titre 5 - Droits de la conservation foncière
('Titre 5 - Droits de la conservation foncière', 
 'Le Titre 5 du Code Général des Impôts définit les règles applicables à la taxe foncière, notamment le champ d''application, l''assiette et les modalités de paiement.',
 (SELECT id FROM procedures WHERE nom = 'Taxe foncière (T.F)' LIMIT 1)),

-- Valeur locative cadastrale
('Valeur locative cadastrale', 
 'Le Code Général des Impôts définit les règles de détermination de la valeur locative cadastrale, base de calcul de la taxe foncière.',
 (SELECT id FROM procedures WHERE nom = 'Taxe foncière (T.F)' LIMIT 1)),

-- Obligations de paiement
('Obligations de paiement', 
 'Le Code Général des Impôts définit les obligations de paiement de la taxe foncière, notamment les délais et les modalités de paiement.',
 (SELECT id FROM procedures WHERE nom = 'Taxe foncière (T.F)' LIMIT 1)),

-- Sanctions et pénalités
('Sanctions et pénalités', 
 'Le Code Général des Impôts prévoit des sanctions et pénalités en cas de non-paiement ou de retard dans le paiement de la taxe foncière.',
 (SELECT id FROM procedures WHERE nom = 'Taxe foncière (T.F)' LIMIT 1));

-- ============================================
-- 3.285. PROCÉDURE: ENREGISTREMENT D'UN CONTRAT
-- ============================================

-- Insertion de la procédure
INSERT INTO procedures (nom, titre, delai, description, categorie_id, sous_categorie_id, date_creation) VALUES
('Enregistrement d''un contrat', 'Enregistrer un contrat', 'Variable selon le type de contrat', 
 'L''enregistrement d''un contrat est une formalité obligatoire pour certains actes et contrats au Mali. Il s''agit d''un droit de timbre qui confère date certaine et force exécutoire aux actes. L''enregistrement est obligatoire pour les actes de vente, de donation, de partage, de bail, de société, et autres contrats selon les dispositions du Code Général des Impôts. Le droit d''enregistrement est calculé selon un barème progressif ou proportionnel selon le type d''acte et sa valeur.',
 (SELECT id FROM categories WHERE titre = 'Impôt et Douane' LIMIT 1),
 (SELECT id FROM sous_categories WHERE titre = 'Enregistrement d''un contrat' LIMIT 1),
 NOW());

-- ============================================
-- 3.286. ÉTAPES DE LA PROCÉDURE ENREGISTREMENT
-- ============================================

INSERT INTO etapes (nom, description, niveau, procedure_id) VALUES
-- Étape 1: Vérification de l'obligation d'enregistrement
('Vérification de l''obligation d''enregistrement', 'Vérifier que le contrat est soumis à l''enregistrement selon le Code Général des Impôts : actes de vente, donation, partage, bail, société, etc.', 1,
 (SELECT id FROM procedures WHERE nom = 'Enregistrement d''un contrat' LIMIT 1)),

-- Étape 2: Détermination du droit d'enregistrement
('Détermination du droit d''enregistrement', 'Déterminer le montant du droit d''enregistrement selon le barème applicable au type de contrat et à sa valeur.', 2,
 (SELECT id FROM procedures WHERE nom = 'Enregistrement d''un contrat' LIMIT 1)),

-- Étape 3: Préparation du dossier
('Préparation du dossier', 'Préparer le dossier d''enregistrement avec tous les documents requis et le contrat à enregistrer.', 3,
 (SELECT id FROM procedures WHERE nom = 'Enregistrement d''un contrat' LIMIT 1)),

-- Étape 4: Dépôt et paiement
('Dépôt et paiement', 'Déposer le dossier auprès des services d''enregistrement et effectuer le paiement du droit d''enregistrement.', 4,
 (SELECT id FROM procedures WHERE nom = 'Enregistrement d''un contrat' LIMIT 1)),

-- Étape 5: Obtention de l'acte enregistré
('Obtention de l''acte enregistré', 'Obtenir l''acte enregistré avec mention de l''enregistrement, conférant date certaine et force exécutoire.', 5,
 (SELECT id FROM procedures WHERE nom = 'Enregistrement d''un contrat' LIMIT 1));

-- ============================================
-- 3.287. DOCUMENTS REQUIS POUR ENREGISTREMENT
-- ============================================

INSERT INTO documents_requis (nom, description, obligatoire, procedure_id) VALUES
('Contrat à enregistrer', 'Contrat ou acte à enregistrer, signé par toutes les parties concernées.', true,
 (SELECT id FROM procedures WHERE nom = 'Enregistrement d''un contrat' LIMIT 1)),

('Pièces d''identité', 'Pièces d''identité de toutes les parties au contrat (carte d''identité, passeport).', true,
 (SELECT id FROM procedures WHERE nom = 'Enregistrement d''un contrat' LIMIT 1)),

('Justificatifs de valeur', 'Justificatifs de la valeur du contrat (facture, estimation, acte de vente, etc.) pour le calcul du droit d''enregistrement.', true,
 (SELECT id FROM procedures WHERE nom = 'Enregistrement d''un contrat' LIMIT 1)),

('Justificatifs de propriété', 'Justificatifs de propriété des biens concernés par le contrat, si applicable.', false,
 (SELECT id FROM procedures WHERE nom = 'Enregistrement d''un contrat' LIMIT 1));

-- ============================================
-- 3.288. COÛTS DE LA PROCÉDURE ENREGISTREMENT
-- ============================================

INSERT INTO couts (nom, prix, description) VALUES
('Droit d''enregistrement', 0, 'Droit d''enregistrement calculé selon le barème applicable au type de contrat et à sa valeur - Variable selon l''acte'),
('Frais de délivrance', 0, 'Frais de délivrance de l''acte enregistré - Montant fixé par la DGI'),
('Pénalités de retard', 0, 'Pénalités applicables en cas de retard dans l''enregistrement du contrat'),
('Intérêts de retard', 0, 'Intérêts de retard calculés sur le montant du droit d''enregistrement non payé dans les délais');

-- Association des coûts à la procédure
UPDATE procedures 
SET cout_id = (SELECT id FROM couts WHERE nom = 'Droit d''enregistrement' LIMIT 1)
WHERE nom = 'Enregistrement d''un contrat';

-- ============================================
-- 3.289. ASSOCIATION DU CENTRE POUR ENREGISTREMENT
-- ============================================

-- Association du centre à la procédure
UPDATE procedures 
SET centre_id = (SELECT id FROM centres WHERE nom = 'Direction Générale des Impôts (DGI)' LIMIT 1)
WHERE nom = 'Enregistrement d''un contrat';

-- ============================================
-- 3.290. ARTICLES DE LOI POUR ENREGISTREMENT
-- ============================================

INSERT INTO lois_articles (description, consulter_article, procedure_id) VALUES
-- Titre 3 - Droits d'enregistrement
('Titre 3 - Droits d''enregistrement', 
 'Le Titre 3 du Code Général des Impôts définit les règles applicables aux droits d''enregistrement, notamment le champ d''application, l''assiette et les modalités de paiement.',
 (SELECT id FROM procedures WHERE nom = 'Enregistrement d''un contrat' LIMIT 1)),

-- Barème des droits d'enregistrement
('Barème des droits d''enregistrement', 
 'Le Code Général des Impôts fixe un barème différencié pour le calcul des droits d''enregistrement selon le type d''acte et sa valeur.',
 (SELECT id FROM procedures WHERE nom = 'Enregistrement d''un contrat' LIMIT 1)),

-- Obligations d'enregistrement
('Obligations d''enregistrement', 
 'Le Code Général des Impôts définit les obligations d''enregistrement des actes et contrats, notamment les délais et les modalités.',
 (SELECT id FROM procedures WHERE nom = 'Enregistrement d''un contrat' LIMIT 1)),

-- Effets de l'enregistrement
('Effets de l''enregistrement', 
 'L''enregistrement confère date certaine et force exécutoire aux actes, leur permettant de produire leurs effets juridiques.',
 (SELECT id FROM procedures WHERE nom = 'Enregistrement d''un contrat' LIMIT 1));

-- ============================================
-- 3.291. PROCÉDURE: IMPÔT SUR LES BÉNÉFICES AGRICOLES (IBA)
-- ============================================

-- Insertion de la procédure
INSERT INTO procedures (nom, titre, delai, description, categorie_id, sous_categorie_id, date_creation) VALUES
('Impôt sur les bénéfices agricoles (IBA)', 'Déclarer et payer l''impôt sur les bénéfices agricoles', 'Annuel - avant le 31 mars de l''année suivante', 
 'L''impôt sur les bénéfices agricoles (IBA) est un impôt direct qui s''applique aux bénéfices réalisés par les personnes physiques et morales exerçant une activité agricole au Mali. Il concerne les activités de production végétale, d''élevage, de pêche, de sylviculture et d''autres activités agricoles connexes. L''impôt est calculé sur le bénéfice net réalisé au cours de l''exercice comptable, après déduction des charges déductibles. Le taux d''imposition varie selon le montant du bénéfice et le statut de l''exploitant.',
 (SELECT id FROM categories WHERE titre = 'Impôt et Douane' LIMIT 1),
 (SELECT id FROM sous_categories WHERE titre = 'Impôt sur les bénéfices agricoles (IBA)' LIMIT 1),
 NOW());

-- ============================================
-- 3.292. ÉTAPES DE LA PROCÉDURE IBA
-- ============================================

INSERT INTO etapes (nom, description, niveau, procedure_id) VALUES
-- Étape 1: Vérification de l'assujettissement
('Vérification de l''assujettissement', 'Vérifier que l''activité exercée est soumise à l''IBA selon le Code Général des Impôts : production végétale, élevage, pêche, sylviculture, etc.', 1,
 (SELECT id FROM procedures WHERE nom = 'Impôt sur les bénéfices agricoles (IBA)' LIMIT 1)),

-- Étape 2: Établissement des comptes agricoles
('Établissement des comptes agricoles', 'Établir les comptes de l''exploitation agricole : recettes, charges, amortissements, et déterminer le bénéfice net réalisé.', 2,
 (SELECT id FROM procedures WHERE nom = 'Impôt sur les bénéfices agricoles (IBA)' LIMIT 1)),

-- Étape 3: Calcul du bénéfice imposable
('Calcul du bénéfice imposable', 'Calculer le bénéfice imposable après déduction des charges déductibles et application des règles spécifiques à l''agriculture.', 3,
 (SELECT id FROM procedures WHERE nom = 'Impôt sur les bénéfices agricoles (IBA)' LIMIT 1)),

-- Étape 4: Application du taux d'imposition
('Application du taux d''imposition', 'Appliquer le taux d''imposition applicable selon le montant du bénéfice et le statut de l''exploitant (personne physique ou morale).', 4,
 (SELECT id FROM procedures WHERE nom = 'Impôt sur les bénéfices agricoles (IBA)' LIMIT 1)),

-- Étape 5: Déclaration et paiement
('Déclaration et paiement', 'Établir et déposer la déclaration annuelle d''IBA et effectuer le paiement selon les modalités et échéances fixées par la Direction Générale des Impôts.', 5,
 (SELECT id FROM procedures WHERE nom = 'Impôt sur les bénéfices agricoles (IBA)' LIMIT 1));

-- ============================================
-- 3.293. DOCUMENTS REQUIS POUR IBA
-- ============================================

INSERT INTO documents_requis (nom, description, obligatoire, procedure_id) VALUES
('Déclaration IBA', 'Formulaire de déclaration annuelle de l''impôt sur les bénéfices agricoles, disponible auprès des services fiscaux.', true,
 (SELECT id FROM procedures WHERE nom = 'Impôt sur les bénéfices agricoles (IBA)' LIMIT 1)),

('Comptes de l''exploitation', 'Comptes de l''exploitation agricole : recettes, charges, amortissements, et calcul du bénéfice net.', true,
 (SELECT id FROM procedures WHERE nom = 'Impôt sur les bénéfices agricoles (IBA)' LIMIT 1)),

('Justificatifs des recettes', 'Justificatifs des recettes agricoles : factures de vente, contrats de vente, relevés de livraison, etc.', true,
 (SELECT id FROM procedures WHERE nom = 'Impôt sur les bénéfices agricoles (IBA)' LIMIT 1)),

('Justificatifs des charges', 'Justificatifs des charges déductibles : factures d''achat, frais de transport, frais de stockage, etc.', true,
 (SELECT id FROM procedures WHERE nom = 'Impôt sur les bénéfices agricoles (IBA)' LIMIT 1)),

('Pièce d''identité', 'Pièce d''identité de l''exploitant agricole (carte d''identité, passeport) ou du représentant légal.', true,
 (SELECT id FROM procedures WHERE nom = 'Impôt sur les bénéfices agricoles (IBA)' LIMIT 1)),

('Titre d''exploitation', 'Titre d''exploitation des terres agricoles (bail, acte de propriété, autorisation d''exploitation).', false,
 (SELECT id FROM procedures WHERE nom = 'Impôt sur les bénéfices agricoles (IBA)' LIMIT 1));

-- ============================================
-- 3.294. COÛTS DE LA PROCÉDURE IBA
-- ============================================

INSERT INTO couts (nom, prix, description) VALUES
('Taux IBA - Personnes physiques', 0, 'Taux d''imposition de l''IBA pour les personnes physiques selon le barème progressif - Variable selon le bénéfice'),
('Taux IBA - Personnes morales', 0, 'Taux d''imposition de l''IBA pour les personnes morales selon le barème progressif - Variable selon le bénéfice'),
('Frais de déclaration', 0, 'Frais de traitement de la déclaration IBA - Montant fixé par la DGI'),
('Pénalités de retard', 0, 'Pénalités applicables en cas de retard dans la déclaration ou le paiement de l''IBA'),
('Intérêts de retard', 0, 'Intérêts de retard calculés sur le montant de l''impôt non payé dans les délais');

-- Association des coûts à la procédure
UPDATE procedures 
SET cout_id = (SELECT id FROM couts WHERE nom = 'Taux IBA - Personnes physiques' LIMIT 1)
WHERE nom = 'Impôt sur les bénéfices agricoles (IBA)';

-- ============================================
-- 3.295. ASSOCIATION DU CENTRE POUR IBA
-- ============================================

-- Association du centre à la procédure
UPDATE procedures 
SET centre_id = (SELECT id FROM centres WHERE nom = 'Direction Générale des Impôts (DGI)' LIMIT 1)
WHERE nom = 'Impôt sur les bénéfices agricoles (IBA)';

-- ============================================
-- 3.296. ARTICLES DE LOI POUR IBA
-- ============================================

INSERT INTO lois_articles (description, consulter_article, procedure_id) VALUES
-- Chapitre IBA - Impôt sur les bénéfices agricoles
('Chapitre IBA - Impôt sur les bénéfices agricoles', 
 'Le chapitre relatif à l''IBA du Code Général des Impôts définit les règles applicables à l''impôt sur les bénéfices agricoles, notamment le champ d''application, l''assiette, les taux d''imposition et les modalités de déclaration.',
 (SELECT id FROM procedures WHERE nom = 'Impôt sur les bénéfices agricoles (IBA)' LIMIT 1)),

-- Assiette de l'IBA
('Assiette de l''IBA', 
 'Le Code Général des Impôts définit l''assiette de l''IBA : bénéfice net réalisé au cours de l''exercice comptable, après déduction des charges déductibles.',
 (SELECT id FROM procedures WHERE nom = 'Impôt sur les bénéfices agricoles (IBA)' LIMIT 1)),

-- Taux d'imposition IBA
('Taux d''imposition IBA', 
 'Le Code Général des Impôts fixe les taux d''imposition de l''IBA selon le montant du bénéfice et le statut de l''exploitant (personne physique ou morale).',
 (SELECT id FROM procedures WHERE nom = 'Impôt sur les bénéfices agricoles (IBA)' LIMIT 1)),

-- Obligations déclaratives IBA
('Obligations déclaratives IBA', 
 'Le Code Général des Impôts définit les obligations déclaratives des exploitants agricoles assujettis à l''IBA, notamment les délais de déclaration et les documents à fournir.',
 (SELECT id FROM procedures WHERE nom = 'Impôt sur les bénéfices agricoles (IBA)' LIMIT 1));

-- ============================================
-- 3.297. PROCÉDURE: TAXE SUR LES TRANSPORTS ROUTIERS (TTR)
-- ============================================

-- Insertion de la procédure
INSERT INTO procedures (nom, titre, delai, description, categorie_id, sous_categorie_id, date_creation) VALUES
('Taxe sur les transports routiers (TTR)', 'Payer la taxe sur les transports routiers', 'Variable selon le type de transport', 
 'La taxe sur les transports routiers (TTR) est un impôt direct qui s''applique aux entreprises et personnes exerçant une activité de transport routier au Mali. Elle concerne les transports de marchandises, de passagers, et les services de transport connexes. La TTR est calculée selon un barème différencié selon le type de transport, la distance parcourue, et la nature des biens ou passagers transportés. Le paiement de la TTR est obligatoire pour toute activité de transport routier soumise à cet impôt.',
 (SELECT id FROM categories WHERE titre = 'Impôt et Douane' LIMIT 1),
 (SELECT id FROM sous_categories WHERE titre = 'Taxe sur les transports routiers (TTR)' LIMIT 1),
 NOW());

-- ============================================
-- 3.298. ÉTAPES DE LA PROCÉDURE TTR
-- ============================================

INSERT INTO etapes (nom, description, niveau, procedure_id) VALUES
-- Étape 1: Vérification de l'assujettissement
('Vérification de l''assujettissement', 'Vérifier que l''activité de transport routier est soumise à la TTR selon le Code Général des Impôts : transport de marchandises, de passagers, services connexes.', 1,
 (SELECT id FROM procedures WHERE nom = 'Taxe sur les transports routiers (TTR)' LIMIT 1)),

-- Étape 2: Détermination de la catégorie
('Détermination de la catégorie', 'Déterminer la catégorie de TTR applicable selon le type de transport, la distance parcourue, et la nature des biens ou passagers transportés.', 2,
 (SELECT id FROM procedures WHERE nom = 'Taxe sur les transports routiers (TTR)' LIMIT 1)),

-- Étape 3: Calcul de la TTR
('Calcul de la TTR', 'Calculer le montant de la TTR selon le barème applicable, en fonction de la catégorie de transport et des paramètres de calcul.', 3,
 (SELECT id FROM procedures WHERE nom = 'Taxe sur les transports routiers (TTR)' LIMIT 1)),

-- Étape 4: Déclaration et paiement
('Déclaration et paiement', 'Établir et déposer la déclaration de TTR et effectuer le paiement selon les modalités et échéances fixées par la Direction Générale des Impôts.', 4,
 (SELECT id FROM procedures WHERE nom = 'Taxe sur les transports routiers (TTR)' LIMIT 1)),

-- Étape 5: Obtention du quitus
('Obtention du quitus', 'Obtenir le quitus de paiement de la TTR, attestant du règlement de l''impôt pour la période concernée.', 5,
 (SELECT id FROM procedures WHERE nom = 'Taxe sur les transports routiers (TTR)' LIMIT 1));

-- ============================================
-- 3.299. DOCUMENTS REQUIS POUR TTR
-- ============================================

INSERT INTO documents_requis (nom, description, obligatoire, procedure_id) VALUES
('Déclaration TTR', 'Formulaire de déclaration de la taxe sur les transports routiers, disponible auprès des services fiscaux.', true,
 (SELECT id FROM procedures WHERE nom = 'Taxe sur les transports routiers (TTR)' LIMIT 1)),

('Justificatif d''activité', 'Justificatif de l''activité de transport routier : autorisation d''exercice, licence de transport, etc.', true,
 (SELECT id FROM procedures WHERE nom = 'Taxe sur les transports routiers (TTR)' LIMIT 1)),

('Relevé des transports', 'Relevé détaillé des transports effectués : distances, nature des biens/passagers, dates, etc.', true,
 (SELECT id FROM procedures WHERE nom = 'Taxe sur les transports routiers (TTR)' LIMIT 1)),

('Pièce d''identité', 'Pièce d''identité du transporteur (carte d''identité, passeport) ou du représentant légal.', true,
 (SELECT id FROM procedures WHERE nom = 'Taxe sur les transports routiers (TTR)' LIMIT 1)),

('Justificatifs de véhicules', 'Justificatifs des véhicules utilisés : cartes grises, autorisations de circulation, etc.', false,
 (SELECT id FROM procedures WHERE nom = 'Taxe sur les transports routiers (TTR)' LIMIT 1));

-- ============================================
-- 3.300. COÛTS DE LA PROCÉDURE TTR
-- ============================================

INSERT INTO couts (nom, prix, description) VALUES
('Barème TTR transport marchandises', 0, 'Montant de la TTR pour le transport de marchandises selon la distance et la nature des biens - Variable selon le transport'),
('Barème TTR transport passagers', 0, 'Montant de la TTR pour le transport de passagers selon la distance et le type de service - Variable selon le transport'),
('Frais de déclaration', 0, 'Frais de traitement de la déclaration TTR - Montant fixé par la DGI'),
('Pénalités de retard', 0, 'Pénalités applicables en cas de retard dans la déclaration ou le paiement de la TTR'),
('Intérêts de retard', 0, 'Intérêts de retard calculés sur le montant de la TTR non payée dans les délais');

-- Association des coûts à la procédure
UPDATE procedures 
SET cout_id = (SELECT id FROM couts WHERE nom = 'Barème TTR transport marchandises' LIMIT 1)
WHERE nom = 'Taxe sur les transports routiers (TTR)';

-- ============================================
-- 3.301. ASSOCIATION DU CENTRE POUR TTR
-- ============================================

-- Association du centre à la procédure
UPDATE procedures 
SET centre_id = (SELECT id FROM centres WHERE nom = 'Direction Générale des Impôts (DGI)' LIMIT 1)
WHERE nom = 'Taxe sur les transports routiers (TTR)';

-- ============================================
-- 3.302. ARTICLES DE LOI POUR TTR
-- ============================================

INSERT INTO lois_articles (description, consulter_article, procedure_id) VALUES
-- Section V - Taxe sur les transports routiers
('Section V - Taxe sur les transports routiers', 
 'La Section V du Code Général des Impôts définit les règles applicables à la taxe sur les transports routiers, notamment le champ d''application, l''assiette et les modalités de paiement.',
 (SELECT id FROM procedures WHERE nom = 'Taxe sur les transports routiers (TTR)' LIMIT 1)),

-- Barème de la TTR
('Barème de la TTR', 
 'Le Code Général des Impôts fixe un barème différencié pour le calcul de la TTR selon le type de transport, la distance parcourue, et la nature des biens ou passagers transportés.',
 (SELECT id FROM procedures WHERE nom = 'Taxe sur les transports routiers (TTR)' LIMIT 1)),

-- Obligations de paiement TTR
('Obligations de paiement TTR', 
 'Le Code Général des Impôts définit les obligations de paiement de la TTR, notamment les délais et les modalités de paiement.',
 (SELECT id FROM procedures WHERE nom = 'Taxe sur les transports routiers (TTR)' LIMIT 1)),

-- Sanctions et pénalités TTR
('Sanctions et pénalités TTR', 
 'Le Code Général des Impôts prévoit des sanctions et pénalités en cas de non-paiement ou de retard dans le paiement de la TTR.',
 (SELECT id FROM procedures WHERE nom = 'Taxe sur les transports routiers (TTR)' LIMIT 1));

-- ============================================
-- 3.303. PROCÉDURE: IMPÔT SPÉCIAL SUR CERTAINS PRODUITS (ISCP)
-- ============================================

-- Insertion de la procédure
INSERT INTO procedures (nom, titre, delai, description, categorie_id, sous_categorie_id, date_creation) VALUES
('Impôt spécial sur certains produits (ISCP)', 'Déclarer et payer l''ISCP', 'Variable selon le type de produit', 
 'L''impôt spécial sur certains produits (ISCP) est un impôt indirect qui s''applique à la production, à l''importation et à la vente de certains produits spécifiques au Mali. Il concerne notamment les produits de luxe, les boissons alcoolisées, les produits du tabac, et autres produits soumis à une taxation spéciale. L''ISCP est calculé selon un barème différencié selon le type de produit, sa valeur, et son origine (production locale ou importation). Le paiement de l''ISCP est obligatoire pour tous les produits soumis à cet impôt.',
 (SELECT id FROM categories WHERE titre = 'Impôt et Douane' LIMIT 1),
 (SELECT id FROM sous_categories WHERE titre = 'Impôt spécial sur certains produits (ISCP)' LIMIT 1),
 NOW());

-- ============================================
-- 3.304. ÉTAPES DE LA PROCÉDURE ISCP
-- ============================================

INSERT INTO etapes (nom, description, niveau, procedure_id) VALUES
-- Étape 1: Vérification de l'assujettissement
('Vérification de l''assujettissement', 'Vérifier que le produit est soumis à l''ISCP selon le Code Général des Impôts : produits de luxe, boissons alcoolisées, tabac, etc.', 1,
 (SELECT id FROM procedures WHERE nom = 'Impôt spécial sur certains produits (ISCP)' LIMIT 1)),

-- Étape 2: Détermination de la catégorie
('Détermination de la catégorie', 'Déterminer la catégorie d''ISCP applicable selon le type de produit, sa valeur, et son origine (production locale ou importation).', 2,
 (SELECT id FROM procedures WHERE nom = 'Impôt spécial sur certains produits (ISCP)' LIMIT 1)),

-- Étape 3: Calcul de l'ISCP
('Calcul de l''ISCP', 'Calculer le montant de l''ISCP selon le barème applicable, en fonction de la catégorie du produit et des paramètres de calcul.', 3,
 (SELECT id FROM procedures WHERE nom = 'Impôt spécial sur certains produits (ISCP)' LIMIT 1)),

-- Étape 4: Déclaration et paiement
('Déclaration et paiement', 'Établir et déposer la déclaration d''ISCP et effectuer le paiement selon les modalités et échéances fixées par la Direction Générale des Impôts.', 4,
 (SELECT id FROM procedures WHERE nom = 'Impôt spécial sur certains produits (ISCP)' LIMIT 1)),

-- Étape 5: Obtention du quitus
('Obtention du quitus', 'Obtenir le quitus de paiement de l''ISCP, attestant du règlement de l''impôt pour la période concernée.', 5,
 (SELECT id FROM procedures WHERE nom = 'Impôt spécial sur certains produits (ISCP)' LIMIT 1));

-- ============================================
-- 3.305. DOCUMENTS REQUIS POUR ISCP
-- ============================================

INSERT INTO documents_requis (nom, description, obligatoire, procedure_id) VALUES
('Déclaration ISCP', 'Formulaire de déclaration de l''impôt spécial sur certains produits, disponible auprès des services fiscaux.', true,
 (SELECT id FROM procedures WHERE nom = 'Impôt spécial sur certains produits (ISCP)' LIMIT 1)),

('Justificatif d''activité', 'Justificatif de l''activité de production, d''importation ou de vente des produits soumis à l''ISCP.', true,
 (SELECT id FROM procedures WHERE nom = 'Impôt spécial sur certains produits (ISCP)' LIMIT 1)),

('Relevé des produits', 'Relevé détaillé des produits soumis à l''ISCP : quantités, valeurs, dates de production/importation/vente, etc.', true,
 (SELECT id FROM procedures WHERE nom = 'Impôt spécial sur certains produits (ISCP)' LIMIT 1)),

('Pièce d''identité', 'Pièce d''identité du contribuable (carte d''identité, passeport) ou du représentant légal.', true,
 (SELECT id FROM procedures WHERE nom = 'Impôt spécial sur certains produits (ISCP)' LIMIT 1)),

('Justificatifs de valeur', 'Justificatifs de la valeur des produits : factures, contrats de vente, estimations, etc.', false,
 (SELECT id FROM procedures WHERE nom = 'Impôt spécial sur certains produits (ISCP)' LIMIT 1));

-- ============================================
-- 3.306. COÛTS DE LA PROCÉDURE ISCP
-- ============================================

INSERT INTO couts (nom, prix, description) VALUES
('Barème ISCP produits de luxe', 0, 'Montant de l''ISCP pour les produits de luxe selon la valeur et l''origine - Variable selon le produit'),
('Barème ISCP boissons alcoolisées', 0, 'Montant de l''ISCP pour les boissons alcoolisées selon le type et la teneur en alcool - Variable selon le produit'),
('Barème ISCP produits du tabac', 0, 'Montant de l''ISCP pour les produits du tabac selon le type et la quantité - Variable selon le produit'),
('Frais de déclaration', 0, 'Frais de traitement de la déclaration ISCP - Montant fixé par la DGI'),
('Pénalités de retard', 0, 'Pénalités applicables en cas de retard dans la déclaration ou le paiement de l''ISCP'),
('Intérêts de retard', 0, 'Intérêts de retard calculés sur le montant de l''ISCP non payé dans les délais');

-- Association des coûts à la procédure
UPDATE procedures 
SET cout_id = (SELECT id FROM couts WHERE nom = 'Barème ISCP produits de luxe' LIMIT 1)
WHERE nom = 'Impôt spécial sur certains produits (ISCP)';

-- ============================================
-- 3.307. ASSOCIATION DU CENTRE POUR ISCP
-- ============================================

-- Association du centre à la procédure
UPDATE procedures 
SET centre_id = (SELECT id FROM centres WHERE nom = 'Direction Générale des Impôts (DGI)' LIMIT 1)
WHERE nom = 'Impôt spécial sur certains produits (ISCP)';

-- ============================================
-- 3.308. ARTICLES DE LOI POUR ISCP
-- ============================================

INSERT INTO lois_articles (description, consulter_article, procedure_id) VALUES
-- Chapitre II - Impôt spécial sur certains produits
('Chapitre II - Impôt spécial sur certains produits', 
 'Le Chapitre II du Code Général des Impôts définit les règles applicables à l''impôt spécial sur certains produits, notamment le champ d''application, l''assiette et les modalités de paiement.',
 (SELECT id FROM procedures WHERE nom = 'Impôt spécial sur certains produits (ISCP)' LIMIT 1)),

-- Barème de l'ISCP
('Barème de l''ISCP', 
 'Le Code Général des Impôts fixe un barème différencié pour le calcul de l''ISCP selon le type de produit, sa valeur, et son origine (production locale ou importation).',
 (SELECT id FROM procedures WHERE nom = 'Impôt spécial sur certains produits (ISCP)' LIMIT 1)),

-- Obligations de paiement ISCP
('Obligations de paiement ISCP', 
 'Le Code Général des Impôts définit les obligations de paiement de l''ISCP, notamment les délais et les modalités de paiement.',
 (SELECT id FROM procedures WHERE nom = 'Impôt spécial sur certains produits (ISCP)' LIMIT 1)),

-- Sanctions et pénalités ISCP
('Sanctions et pénalités ISCP', 
 'Le Code Général des Impôts prévoit des sanctions et pénalités en cas de non-paiement ou de retard dans le paiement de l''ISCP.',
 (SELECT id FROM procedures WHERE nom = 'Impôt spécial sur certains produits (ISCP)' LIMIT 1));

-- ============================================
-- 3.309. PROCÉDURE: TAXE SUR LES ACTIVITÉS FINANCIÈRES (TAF)
-- ============================================

-- Insertion de la procédure
INSERT INTO procedures (nom, titre, delai, description, categorie_id, sous_categorie_id, date_creation) VALUES
('Taxe sur les activités financières (TAF)', 'Déclarer et payer la TAF', 'Variable selon le type d''activité', 
 'La taxe sur les activités financières (TAF) est un impôt indirect qui s''applique aux opérations et services financiers au Mali. Elle concerne les établissements de crédit, les institutions financières, les compagnies d''assurance, et autres acteurs du secteur financier. La TAF est calculée selon un barème différencié selon le type d''opération financière, sa valeur, et la nature du service rendu. Le paiement de la TAF est obligatoire pour toutes les opérations financières soumises à cet impôt.',
 (SELECT id FROM categories WHERE titre = 'Impôt et Douane' LIMIT 1),
 (SELECT id FROM sous_categories WHERE titre = 'Taxe sur les activités financières (TAF)' LIMIT 1),
 NOW());

-- ============================================
-- 3.310. ÉTAPES DE LA PROCÉDURE TAF
-- ============================================

INSERT INTO etapes (nom, description, niveau, procedure_id) VALUES
-- Étape 1: Vérification de l'assujettissement
('Vérification de l''assujettissement', 'Vérifier que l''activité financière est soumise à la TAF selon le Code Général des Impôts : opérations bancaires, assurances, services financiers, etc.', 1,
 (SELECT id FROM procedures WHERE nom = 'Taxe sur les activités financières (TAF)' LIMIT 1)),

-- Étape 2: Détermination de la catégorie
('Détermination de la catégorie', 'Déterminer la catégorie de TAF applicable selon le type d''opération financière, sa valeur, et la nature du service rendu.', 2,
 (SELECT id FROM procedures WHERE nom = 'Taxe sur les activités financières (TAF)' LIMIT 1)),

-- Étape 3: Calcul de la TAF
('Calcul de la TAF', 'Calculer le montant de la TAF selon le barème applicable, en fonction de la catégorie d''opération et des paramètres de calcul.', 3,
 (SELECT id FROM procedures WHERE nom = 'Taxe sur les activités financières (TAF)' LIMIT 1)),

-- Étape 4: Déclaration et paiement
('Déclaration et paiement', 'Établir et déposer la déclaration de TAF et effectuer le paiement selon les modalités et échéances fixées par la Direction Générale des Impôts.', 4,
 (SELECT id FROM procedures WHERE nom = 'Taxe sur les activités financières (TAF)' LIMIT 1)),

-- Étape 5: Obtention du quitus
('Obtention du quitus', 'Obtenir le quitus de paiement de la TAF, attestant du règlement de l''impôt pour la période concernée.', 5,
 (SELECT id FROM procedures WHERE nom = 'Taxe sur les activités financières (TAF)' LIMIT 1));

-- ============================================
-- 3.311. DOCUMENTS REQUIS POUR TAF
-- ============================================

INSERT INTO documents_requis (nom, description, obligatoire, procedure_id) VALUES
('Déclaration TAF', 'Formulaire de déclaration de la taxe sur les activités financières, disponible auprès des services fiscaux.', true,
 (SELECT id FROM procedures WHERE nom = 'Taxe sur les activités financières (TAF)' LIMIT 1)),

('Justificatif d''activité', 'Justificatif de l''activité financière : autorisation d''exercice, licence bancaire, agrément, etc.', true,
 (SELECT id FROM procedures WHERE nom = 'Taxe sur les activités financières (TAF)' LIMIT 1)),

('Relevé des opérations', 'Relevé détaillé des opérations financières soumises à la TAF : montants, dates, nature des opérations, etc.', true,
 (SELECT id FROM procedures WHERE nom = 'Taxe sur les activités financières (TAF)' LIMIT 1)),

('Pièce d''identité', 'Pièce d''identité du contribuable (carte d''identité, passeport) ou du représentant légal.', true,
 (SELECT id FROM procedures WHERE nom = 'Taxe sur les activités financières (TAF)' LIMIT 1)),

('Justificatifs de valeur', 'Justificatifs de la valeur des opérations financières : contrats, factures, relevés, etc.', false,
 (SELECT id FROM procedures WHERE nom = 'Taxe sur les activités financières (TAF)' LIMIT 1));

-- ============================================
-- 3.312. COÛTS DE LA PROCÉDURE TAF
-- ============================================

INSERT INTO couts (nom, prix, description) VALUES
('Barème TAF opérations bancaires', 0, 'Montant de la TAF pour les opérations bancaires selon le type et la valeur - Variable selon l''opération'),
('Barème TAF assurances', 0, 'Montant de la TAF pour les opérations d''assurance selon le type et la valeur - Variable selon l''opération'),
('Barème TAF services financiers', 0, 'Montant de la TAF pour les services financiers selon le type et la valeur - Variable selon le service'),
('Frais de déclaration', 0, 'Frais de traitement de la déclaration TAF - Montant fixé par la DGI'),
('Pénalités de retard', 0, 'Pénalités applicables en cas de retard dans la déclaration ou le paiement de la TAF'),
('Intérêts de retard', 0, 'Intérêts de retard calculés sur le montant de la TAF non payée dans les délais');

-- Association des coûts à la procédure
UPDATE procedures 
SET cout_id = (SELECT id FROM couts WHERE nom = 'Barème TAF opérations bancaires' LIMIT 1)
WHERE nom = 'Taxe sur les activités financières (TAF)';

-- ============================================
-- 3.313. ASSOCIATION DU CENTRE POUR TAF
-- ============================================

-- Association du centre à la procédure
UPDATE procedures 
SET centre_id = (SELECT id FROM centres WHERE nom = 'Direction Générale des Impôts (DGI)' LIMIT 1)
WHERE nom = 'Taxe sur les activités financières (TAF)';

-- ============================================
-- 3.314. ARTICLES DE LOI POUR TAF
-- ============================================

INSERT INTO lois_articles (description, consulter_article, procedure_id) VALUES
-- Chapitre III - Taxe sur les activités financières
('Chapitre III - Taxe sur les activités financières', 
 'Le Chapitre III du Code Général des Impôts définit les règles applicables à la taxe sur les activités financières, notamment le champ d''application, l''assiette et les modalités de paiement.',
 (SELECT id FROM procedures WHERE nom = 'Taxe sur les activités financières (TAF)' LIMIT 1)),

-- Barème de la TAF
('Barème de la TAF', 
 'Le Code Général des Impôts fixe un barème différencié pour le calcul de la TAF selon le type d''opération financière, sa valeur, et la nature du service rendu.',
 (SELECT id FROM procedures WHERE nom = 'Taxe sur les activités financières (TAF)' LIMIT 1)),

-- Obligations de paiement TAF
('Obligations de paiement TAF', 
 'Le Code Général des Impôts définit les obligations de paiement de la TAF, notamment les délais et les modalités de paiement.',
 (SELECT id FROM procedures WHERE nom = 'Taxe sur les activités financières (TAF)' LIMIT 1)),

-- Sanctions et pénalités TAF
('Sanctions et pénalités TAF', 
 'Le Code Général des Impôts prévoit des sanctions et pénalités en cas de non-paiement ou de retard dans le paiement de la TAF.',
 (SELECT id FROM procedures WHERE nom = 'Taxe sur les activités financières (TAF)' LIMIT 1));

-- ============================================
-- 3.315. PROCÉDURE: DÉCLARATION DE REVENU FONCIER
-- ============================================

-- Insertion de la procédure
INSERT INTO procedures (nom, titre, delai, description, categorie_id, sous_categorie_id, date_creation) VALUES
('Déclaration de revenu foncier', 'Déclarer les revenus fonciers', 'Annuel - avant le 31 mars de l''année suivante', 
 'La déclaration de revenu foncier est une obligation fiscale qui s''applique aux propriétaires de biens immobiliers qui perçoivent des revenus de location au Mali. Elle concerne tous les revenus tirés de la location de terrains, constructions, installations et autres biens immobiliers. Les revenus fonciers sont soumis à l''impôt sur le revenu selon un barème progressif. Le propriétaire doit déclarer ses revenus locatifs bruts, déduire les charges déductibles, et calculer le revenu net imposable. Cette déclaration est obligatoire pour toute personne percevant des revenus fonciers.',
 (SELECT id FROM categories WHERE titre = 'Impôt et Douane' LIMIT 1),
 (SELECT id FROM sous_categories WHERE titre = 'Déclaration de revenu foncier' LIMIT 1),
 NOW());

-- ============================================
-- 3.316. ÉTAPES DE LA PROCÉDURE REVENU FONCIER
-- ============================================

INSERT INTO etapes (nom, description, niveau, procedure_id) VALUES
-- Étape 1: Vérification de l'assujettissement
('Vérification de l''assujettissement', 'Vérifier que les revenus perçus sont soumis à la déclaration de revenu foncier selon le Code Général des Impôts : revenus de location de biens immobiliers.', 1,
 (SELECT id FROM procedures WHERE nom = 'Déclaration de revenu foncier' LIMIT 1)),

-- Étape 2: Calcul des revenus bruts
('Calcul des revenus bruts', 'Calculer les revenus locatifs bruts perçus au cours de l''année : loyers, charges locatives, indemnités, etc.', 2,
 (SELECT id FROM procedures WHERE nom = 'Déclaration de revenu foncier' LIMIT 1)),

-- Étape 3: Déduction des charges
('Déduction des charges', 'Déduire les charges déductibles : travaux, réparations, assurances, taxes, intérêts d''emprunt, amortissements, etc.', 3,
 (SELECT id FROM procedures WHERE nom = 'Déclaration de revenu foncier' LIMIT 1)),

-- Étape 4: Calcul du revenu net imposable
('Calcul du revenu net imposable', 'Calculer le revenu net imposable après déduction des charges déductibles selon les règles fiscales applicables.', 4,
 (SELECT id FROM procedures WHERE nom = 'Déclaration de revenu foncier' LIMIT 1)),

-- Étape 5: Déclaration et paiement
('Déclaration et paiement', 'Établir et déposer la déclaration de revenu foncier et effectuer le paiement de l''impôt selon les modalités et échéances fixées par la Direction Générale des Impôts.', 5,
 (SELECT id FROM procedures WHERE nom = 'Déclaration de revenu foncier' LIMIT 1));

-- ============================================
-- 3.317. DOCUMENTS REQUIS POUR REVENU FONCIER
-- ============================================

INSERT INTO documents_requis (nom, description, obligatoire, procedure_id) VALUES
('Déclaration de revenu foncier', 'Formulaire de déclaration de revenu foncier, disponible auprès des services fiscaux.', true,
 (SELECT id FROM procedures WHERE nom = 'Déclaration de revenu foncier' LIMIT 1)),

('Contrats de location', 'Contrats de location des biens immobiliers avec indication des loyers et charges.', true,
 (SELECT id FROM procedures WHERE nom = 'Déclaration de revenu foncier' LIMIT 1)),

('Justificatifs des revenus', 'Justificatifs des revenus perçus : quittances de loyer, relevés bancaires, reçus, etc.', true,
 (SELECT id FROM procedures WHERE nom = 'Déclaration de revenu foncier' LIMIT 1)),

('Justificatifs des charges', 'Justificatifs des charges déductibles : factures de travaux, assurances, taxes, intérêts d''emprunt, etc.', true,
 (SELECT id FROM procedures WHERE nom = 'Déclaration de revenu foncier' LIMIT 1)),

('Pièce d''identité', 'Pièce d''identité du propriétaire (carte d''identité, passeport).', true,
 (SELECT id FROM procedures WHERE nom = 'Déclaration de revenu foncier' LIMIT 1)),

('Titre de propriété', 'Titre de propriété des biens immobiliers loués.', false,
 (SELECT id FROM procedures WHERE nom = 'Déclaration de revenu foncier' LIMIT 1));

-- ============================================
-- 3.318. COÛTS DE LA PROCÉDURE REVENU FONCIER
-- ============================================

INSERT INTO couts (nom, prix, description) VALUES
('Barème progressif revenu foncier', 0, 'Taux d''imposition progressif sur le revenu net imposable selon le barème de l''impôt sur le revenu - Variable selon le montant'),
('Frais de déclaration', 0, 'Frais de traitement de la déclaration de revenu foncier - Montant fixé par la DGI'),
('Pénalités de retard', 0, 'Pénalités applicables en cas de retard dans la déclaration ou le paiement de l''impôt sur le revenu foncier'),
('Intérêts de retard', 0, 'Intérêts de retard calculés sur le montant de l''impôt non payé dans les délais');

-- Association des coûts à la procédure
UPDATE procedures 
SET cout_id = (SELECT id FROM couts WHERE nom = 'Barème progressif revenu foncier' LIMIT 1)
WHERE nom = 'Déclaration de revenu foncier';

-- ============================================
-- 3.319. ASSOCIATION DU CENTRE POUR REVENU FONCIER
-- ============================================

-- Association du centre à la procédure
UPDATE procedures 
SET centre_id = (SELECT id FROM centres WHERE nom = 'Direction Générale des Impôts (DGI)' LIMIT 1)
WHERE nom = 'Déclaration de revenu foncier';

-- ============================================
-- 3.320. ARTICLES DE LOI POUR REVENU FONCIER
-- ============================================

INSERT INTO lois_articles (description, consulter_article, procedure_id) VALUES
-- Impôt sur le revenu foncier
('Impôt sur le revenu foncier', 
 'Le Code Général des Impôts définit les règles applicables à l''impôt sur le revenu foncier, notamment le champ d''application, l''assiette, les déductions et les modalités de déclaration.',
 (SELECT id FROM procedures WHERE nom = 'Déclaration de revenu foncier' LIMIT 1)),

-- Charges déductibles
('Charges déductibles', 
 'Le Code Général des Impôts définit les charges déductibles des revenus fonciers : travaux, réparations, assurances, taxes, intérêts d''emprunt, amortissements.',
 (SELECT id FROM procedures WHERE nom = 'Déclaration de revenu foncier' LIMIT 1)),

-- Barème progressif
('Barème progressif', 
 'Le Code Général des Impôts fixe un barème progressif pour l''imposition des revenus fonciers selon le montant du revenu net imposable.',
 (SELECT id FROM procedures WHERE nom = 'Déclaration de revenu foncier' LIMIT 1)),

-- Obligations déclaratives
('Obligations déclaratives', 
 'Le Code Général des Impôts définit les obligations déclaratives des propriétaires de biens immobiliers, notamment les délais de déclaration et les documents à fournir.',
 (SELECT id FROM procedures WHERE nom = 'Déclaration de revenu foncier' LIMIT 1));

-- ============================================
-- 3.321. PROCÉDURE: TAXE LOGEMENT (TL)
-- ============================================

-- Insertion de la procédure
INSERT INTO procedures (nom, titre, delai, description, categorie_id, sous_categorie_id, date_creation) VALUES
('Taxe logement (TL)', 'Payer la taxe logement', 'Variable selon le type de logement', 
 'La taxe logement (TL) est un impôt direct qui s''applique aux propriétaires et occupants de logements au Mali. Elle concerne tous les logements, qu''ils soient occupés par leurs propriétaires ou loués à des tiers. La taxe logement est calculée selon un barème différencié selon le type de logement, sa superficie, sa localisation, et sa valeur locative. Elle est destinée à financer les équipements collectifs et les services urbains. Le paiement de la taxe logement est obligatoire pour tous les logements soumis à cet impôt.',
 (SELECT id FROM categories WHERE titre = 'Impôt et Douane' LIMIT 1),
 (SELECT id FROM sous_categories WHERE titre = 'Taxe logement (TL)' LIMIT 1),
 NOW());

-- ============================================
-- 3.322. ÉTAPES DE LA PROCÉDURE TAXE LOGEMENT
-- ============================================

INSERT INTO etapes (nom, description, niveau, procedure_id) VALUES
-- Étape 1: Vérification de l'assujettissement
('Vérification de l''assujettissement', 'Vérifier que le logement est soumis à la taxe logement selon le Code Général des Impôts : logements occupés ou loués.', 1,
 (SELECT id FROM procedures WHERE nom = 'Taxe logement (TL)' LIMIT 1)),

-- Étape 2: Détermination de la catégorie
('Détermination de la catégorie', 'Déterminer la catégorie de taxe logement applicable selon le type de logement, sa superficie, sa localisation, et sa valeur locative.', 2,
 (SELECT id FROM procedures WHERE nom = 'Taxe logement (TL)' LIMIT 1)),

-- Étape 3: Calcul de la taxe logement
('Calcul de la taxe logement', 'Calculer le montant de la taxe logement selon le barème applicable, en fonction de la catégorie du logement et des paramètres de calcul.', 3,
 (SELECT id FROM procedures WHERE nom = 'Taxe logement (TL)' LIMIT 1)),

-- Étape 4: Paiement de la taxe
('Paiement de la taxe', 'Effectuer le paiement de la taxe logement selon les modalités et échéances fixées par la Direction Générale des Impôts.', 4,
 (SELECT id FROM procedures WHERE nom = 'Taxe logement (TL)' LIMIT 1)),

-- Étape 5: Obtention du quitus
('Obtention du quitus', 'Obtenir le quitus de paiement de la taxe logement, attestant du règlement de l''impôt pour l''année concernée.', 5,
 (SELECT id FROM procedures WHERE nom = 'Taxe logement (TL)' LIMIT 1));

-- ============================================
-- 3.323. DOCUMENTS REQUIS POUR TAXE LOGEMENT
-- ============================================

INSERT INTO documents_requis (nom, description, obligatoire, procedure_id) VALUES
('Avis d''imposition TL', 'Avis d''imposition de la taxe logement pour l''année concernée, délivré par les services fiscaux.', true,
 (SELECT id FROM procedures WHERE nom = 'Taxe logement (TL)' LIMIT 1)),

('Titre de propriété', 'Titre de propriété du logement ou contrat de location si le demandeur est locataire.', true,
 (SELECT id FROM procedures WHERE nom = 'Taxe logement (TL)' LIMIT 1)),

('Pièce d''identité', 'Pièce d''identité du propriétaire ou de l''occupant (carte d''identité, passeport).', true,
 (SELECT id FROM procedures WHERE nom = 'Taxe logement (TL)' LIMIT 1)),

('Justificatif de domiciliation', 'Justificatif de l''adresse du logement : facture d''électricité, d''eau, ou tout document attestant de l''occupation.', true,
 (SELECT id FROM procedures WHERE nom = 'Taxe logement (TL)' LIMIT 1)),

('Plan du logement', 'Plan du logement ou description des lieux pour vérification de la superficie, si disponible.', false,
 (SELECT id FROM procedures WHERE nom = 'Taxe logement (TL)' LIMIT 1));

-- ============================================
-- 3.324. COÛTS DE LA PROCÉDURE TAXE LOGEMENT
-- ============================================

INSERT INTO couts (nom, prix, description) VALUES
('Barème TL logements individuels', 0, 'Montant de la taxe logement pour les logements individuels selon la superficie et la localisation - Variable selon le logement'),
('Barème TL logements collectifs', 0, 'Montant de la taxe logement pour les logements collectifs selon la superficie et la localisation - Variable selon le logement'),
('Frais de délivrance', 0, 'Frais de délivrance de l''avis d''imposition et du quitus - Montant fixé par la DGI'),
('Pénalités de retard', 0, 'Pénalités applicables en cas de retard dans le paiement de la taxe logement'),
('Intérêts de retard', 0, 'Intérêts de retard calculés sur le montant de la taxe non payée dans les délais');

-- Association des coûts à la procédure
UPDATE procedures 
SET cout_id = (SELECT id FROM couts WHERE nom = 'Barème TL logements individuels' LIMIT 1)
WHERE nom = 'Taxe logement (TL)';

-- ============================================
-- 3.325. ASSOCIATION DU CENTRE POUR TAXE LOGEMENT
-- ============================================

-- Association du centre à la procédure
UPDATE procedures 
SET centre_id = (SELECT id FROM centres WHERE nom = 'Direction Générale des Impôts (DGI)' LIMIT 1)
WHERE nom = 'Taxe logement (TL)';

-- ============================================
-- 3.326. ARTICLES DE LOI POUR TAXE LOGEMENT
-- ============================================

INSERT INTO lois_articles (description, consulter_article, procedure_id) VALUES
-- Taxe logement
('Taxe logement', 
 'Le Code Général des Impôts définit les règles applicables à la taxe logement, notamment le champ d''application, l''assiette et les modalités de paiement.',
 (SELECT id FROM procedures WHERE nom = 'Taxe logement (TL)' LIMIT 1)),

-- Barème de la taxe logement
('Barème de la taxe logement', 
 'Le Code Général des Impôts fixe un barème différencié pour le calcul de la taxe logement selon le type de logement, sa superficie, sa localisation, et sa valeur locative.',
 (SELECT id FROM procedures WHERE nom = 'Taxe logement (TL)' LIMIT 1)),

-- Obligations de paiement
('Obligations de paiement', 
 'Le Code Général des Impôts définit les obligations de paiement de la taxe logement, notamment les délais et les modalités de paiement.',
 (SELECT id FROM procedures WHERE nom = 'Taxe logement (TL)' LIMIT 1)),

-- Sanctions et pénalités
('Sanctions et pénalités', 
 'Le Code Général des Impôts prévoit des sanctions et pénalités en cas de non-paiement ou de retard dans le paiement de la taxe logement.',
 (SELECT id FROM procedures WHERE nom = 'Taxe logement (TL)' LIMIT 1));

-- ============================================
-- 3.327. PROCÉDURE: IMPÔT SUR LES REVENUS DE VALEURS MOBILIÈRES (IRVM)
-- ============================================

-- Insertion de la procédure
INSERT INTO procedures (nom, titre, delai, description, categorie_id, sous_categorie_id, date_creation) VALUES
('Impôt sur les revenus de valeurs Mobilières (IRVM)', 'Déclarer et payer l''IRVM', 'Annuel - avant le 31 mars de l''année suivante', 
 'L''impôt sur les revenus de valeurs mobilières (IRVM) est un impôt direct qui s''applique aux revenus tirés de la détention et de la cession de valeurs mobilières au Mali. Il concerne les dividendes, intérêts, plus-values de cession d''actions, obligations, parts sociales, et autres titres financiers. L''IRVM est calculé selon un barème différencié selon le type de revenu et le statut du contribuable. Les revenus de valeurs mobilières sont soumis à l''impôt sur le revenu selon les règles applicables. Cette déclaration est obligatoire pour toute personne percevant des revenus de valeurs mobilières.',
 (SELECT id FROM categories WHERE titre = 'Impôt et Douane' LIMIT 1),
 (SELECT id FROM sous_categories WHERE titre = 'Impôt sur les revenus de valeurs Mobilières (IRVM)' LIMIT 1),
 NOW());

-- ============================================
-- 3.328. ÉTAPES DE LA PROCÉDURE IRVM
-- ============================================

INSERT INTO etapes (nom, description, niveau, procedure_id) VALUES
-- Étape 1: Vérification de l'assujettissement
('Vérification de l''assujettissement', 'Vérifier que les revenus perçus sont soumis à l''IRVM selon le Code Général des Impôts : dividendes, intérêts, plus-values de cession de valeurs mobilières.', 1,
 (SELECT id FROM procedures WHERE nom = 'Impôt sur les revenus de valeurs Mobilières (IRVM)' LIMIT 1)),

-- Étape 2: Calcul des revenus bruts
('Calcul des revenus bruts', 'Calculer les revenus bruts de valeurs mobilières perçus au cours de l''année : dividendes, intérêts, plus-values de cession, etc.', 2,
 (SELECT id FROM procedures WHERE nom = 'Impôt sur les revenus de valeurs Mobilières (IRVM)' LIMIT 1)),

-- Étape 3: Déduction des charges
('Déduction des charges', 'Déduire les charges déductibles : frais de gestion, commissions, droits de garde, et autres frais liés à la détention des valeurs mobilières.', 3,
 (SELECT id FROM procedures WHERE nom = 'Impôt sur les revenus de valeurs Mobilières (IRVM)' LIMIT 1)),

-- Étape 4: Calcul du revenu net imposable
('Calcul du revenu net imposable', 'Calculer le revenu net imposable après déduction des charges déductibles selon les règles fiscales applicables.', 4,
 (SELECT id FROM procedures WHERE nom = 'Impôt sur les revenus de valeurs Mobilières (IRVM)' LIMIT 1)),

-- Étape 5: Déclaration et paiement
('Déclaration et paiement', 'Établir et déposer la déclaration d''IRVM et effectuer le paiement de l''impôt selon les modalités et échéances fixées par la Direction Générale des Impôts.', 5,
 (SELECT id FROM procedures WHERE nom = 'Impôt sur les revenus de valeurs Mobilières (IRVM)' LIMIT 1));

-- ============================================
-- 3.329. DOCUMENTS REQUIS POUR IRVM
-- ============================================

INSERT INTO documents_requis (nom, description, obligatoire, procedure_id) VALUES
('Déclaration IRVM', 'Formulaire de déclaration de l''impôt sur les revenus de valeurs mobilières, disponible auprès des services fiscaux.', true,
 (SELECT id FROM procedures WHERE nom = 'Impôt sur les revenus de valeurs Mobilières (IRVM)' LIMIT 1)),

('Relevés de compte', 'Relevés de compte des établissements financiers avec indication des revenus de valeurs mobilières perçus.', true,
 (SELECT id FROM procedures WHERE nom = 'Impôt sur les revenus de valeurs Mobilières (IRVM)' LIMIT 1)),

('Justificatifs des revenus', 'Justificatifs des revenus perçus : avis de dividendes, certificats d''intérêts, bordereaux de cession, etc.', true,
 (SELECT id FROM procedures WHERE nom = 'Impôt sur les revenus de valeurs Mobilières (IRVM)' LIMIT 1)),

('Justificatifs des charges', 'Justificatifs des charges déductibles : factures de frais de gestion, commissions, droits de garde, etc.', true,
 (SELECT id FROM procedures WHERE nom = 'Impôt sur les revenus de valeurs Mobilières (IRVM)' LIMIT 1)),

('Pièce d''identité', 'Pièce d''identité du contribuable (carte d''identité, passeport).', true,
 (SELECT id FROM procedures WHERE nom = 'Impôt sur les revenus de valeurs Mobilières (IRVM)' LIMIT 1)),

('Portefeuille de titres', 'Portefeuille de titres détenus avec indication des valeurs et des dates d''acquisition, si disponible.', false,
 (SELECT id FROM procedures WHERE nom = 'Impôt sur les revenus de valeurs Mobilières (IRVM)' LIMIT 1));

-- ============================================
-- 3.330. COÛTS DE LA PROCÉDURE IRVM
-- ============================================

INSERT INTO couts (nom, prix, description) VALUES
('Barème progressif IRVM', 0, 'Taux d''imposition progressif sur le revenu net imposable selon le barème de l''impôt sur le revenu - Variable selon le montant'),
('Frais de déclaration', 0, 'Frais de traitement de la déclaration IRVM - Montant fixé par la DGI'),
('Pénalités de retard', 0, 'Pénalités applicables en cas de retard dans la déclaration ou le paiement de l''impôt sur les revenus de valeurs mobilières'),
('Intérêts de retard', 0, 'Intérêts de retard calculés sur le montant de l''impôt non payé dans les délais');

-- Association des coûts à la procédure
UPDATE procedures 
SET cout_id = (SELECT id FROM couts WHERE nom = 'Barème progressif IRVM' LIMIT 1)
WHERE nom = 'Impôt sur les revenus de valeurs Mobilières (IRVM)';

-- ============================================
-- 3.331. ASSOCIATION DU CENTRE POUR IRVM
-- ============================================

-- Association du centre à la procédure
UPDATE procedures 
SET centre_id = (SELECT id FROM centres WHERE nom = 'Direction Générale des Impôts (DGI)' LIMIT 1)
WHERE nom = 'Impôt sur les revenus de valeurs Mobilières (IRVM)';

-- ============================================
-- 3.332. ARTICLES DE LOI POUR IRVM
-- ============================================

INSERT INTO lois_articles (description, consulter_article, procedure_id) VALUES
-- Impôt sur les revenus de valeurs mobilières
('Impôt sur les revenus de valeurs mobilières', 
 'Le Code Général des Impôts définit les règles applicables à l''impôt sur les revenus de valeurs mobilières, notamment le champ d''application, l''assiette, les déductions et les modalités de déclaration.',
 (SELECT id FROM procedures WHERE nom = 'Impôt sur les revenus de valeurs Mobilières (IRVM)' LIMIT 1)),

-- Charges déductibles IRVM
('Charges déductibles IRVM', 
 'Le Code Général des Impôts définit les charges déductibles des revenus de valeurs mobilières : frais de gestion, commissions, droits de garde, et autres frais liés à la détention des titres.',
 (SELECT id FROM procedures WHERE nom = 'Impôt sur les revenus de valeurs Mobilières (IRVM)' LIMIT 1)),

-- Barème progressif IRVM
('Barème progressif IRVM', 
 'Le Code Général des Impôts fixe un barème progressif pour l''imposition des revenus de valeurs mobilières selon le montant du revenu net imposable.',
 (SELECT id FROM procedures WHERE nom = 'Impôt sur les revenus de valeurs Mobilières (IRVM)' LIMIT 1)),

-- Obligations déclaratives IRVM
('Obligations déclaratives IRVM', 
 'Le Code Général des Impôts définit les obligations déclaratives des détenteurs de valeurs mobilières, notamment les délais de déclaration et les documents à fournir.',
 (SELECT id FROM procedures WHERE nom = 'Impôt sur les revenus de valeurs Mobilières (IRVM)' LIMIT 1));

-- ============================================
-- 3.333. PROCÉDURE: IMPÔT SUR LES REVENUS FONCIERS (IRF)
-- ============================================

-- Insertion de la procédure
INSERT INTO procedures (nom, titre, delai, description, categorie_id, sous_categorie_id, date_creation) VALUES
('Impôt sur les revenus fonciers (IRF)', 'Déclarer et payer l''IRF', 'Annuel - avant le 31 mars de l''année suivante', 
 'L''impôt sur les revenus fonciers (IRF) est un impôt direct qui s''applique aux revenus tirés de la propriété et de l''exploitation de biens immobiliers au Mali. Il concerne les revenus de location, de sous-location, de cession de droits d''usage, et autres revenus fonciers. L''IRF est calculé selon un barème progressif sur le revenu net imposable après déduction des charges déductibles. Les revenus fonciers sont soumis à l''impôt sur le revenu selon les règles applicables. Cette déclaration est obligatoire pour toute personne percevant des revenus fonciers.',
 (SELECT id FROM categories WHERE titre = 'Impôt et Douane' LIMIT 1),
 (SELECT id FROM sous_categories WHERE titre = 'Impôt sur les revenus fonciers (IRF)' LIMIT 1),
 NOW());

-- ============================================
-- 3.334. ÉTAPES DE LA PROCÉDURE IRF
-- ============================================

INSERT INTO etapes (nom, description, niveau, procedure_id) VALUES
-- Étape 1: Vérification de l'assujettissement
('Vérification de l''assujettissement', 'Vérifier que les revenus perçus sont soumis à l''IRF selon le Code Général des Impôts : revenus de location, sous-location, cession de droits d''usage, etc.', 1,
 (SELECT id FROM procedures WHERE nom = 'Impôt sur les revenus fonciers (IRF)' LIMIT 1)),

-- Étape 2: Calcul des revenus bruts
('Calcul des revenus bruts', 'Calculer les revenus fonciers bruts perçus au cours de l''année : loyers, charges locatives, indemnités, droits d''usage, etc.', 2,
 (SELECT id FROM procedures WHERE nom = 'Impôt sur les revenus fonciers (IRF)' LIMIT 1)),

-- Étape 3: Déduction des charges
('Déduction des charges', 'Déduire les charges déductibles : travaux, réparations, assurances, taxes, intérêts d''emprunt, amortissements, frais de gestion, etc.', 3,
 (SELECT id FROM procedures WHERE nom = 'Impôt sur les revenus fonciers (IRF)' LIMIT 1)),

-- Étape 4: Calcul du revenu net imposable
('Calcul du revenu net imposable', 'Calculer le revenu net imposable après déduction des charges déductibles selon les règles fiscales applicables.', 4,
 (SELECT id FROM procedures WHERE nom = 'Impôt sur les revenus fonciers (IRF)' LIMIT 1)),

-- Étape 5: Déclaration et paiement
('Déclaration et paiement', 'Établir et déposer la déclaration d''IRF et effectuer le paiement de l''impôt selon les modalités et échéances fixées par la Direction Générale des Impôts.', 5,
 (SELECT id FROM procedures WHERE nom = 'Impôt sur les revenus fonciers (IRF)' LIMIT 1));

-- ============================================
-- 3.335. DOCUMENTS REQUIS POUR IRF
-- ============================================

INSERT INTO documents_requis (nom, description, obligatoire, procedure_id) VALUES
('Déclaration IRF', 'Formulaire de déclaration de l''impôt sur les revenus fonciers, disponible auprès des services fiscaux.', true,
 (SELECT id FROM procedures WHERE nom = 'Impôt sur les revenus fonciers (IRF)' LIMIT 1)),

('Contrats de location', 'Contrats de location, sous-location, ou cession de droits d''usage des biens immobiliers avec indication des revenus.', true,
 (SELECT id FROM procedures WHERE nom = 'Impôt sur les revenus fonciers (IRF)' LIMIT 1)),

('Justificatifs des revenus', 'Justificatifs des revenus perçus : quittances de loyer, relevés bancaires, reçus, contrats de cession, etc.', true,
 (SELECT id FROM procedures WHERE nom = 'Impôt sur les revenus fonciers (IRF)' LIMIT 1)),

('Justificatifs des charges', 'Justificatifs des charges déductibles : factures de travaux, assurances, taxes, intérêts d''emprunt, frais de gestion, etc.', true,
 (SELECT id FROM procedures WHERE nom = 'Impôt sur les revenus fonciers (IRF)' LIMIT 1)),

('Pièce d''identité', 'Pièce d''identité du contribuable (carte d''identité, passeport).', true,
 (SELECT id FROM procedures WHERE nom = 'Impôt sur les revenus fonciers (IRF)' LIMIT 1)),

('Titre de propriété', 'Titre de propriété des biens immobiliers générant des revenus.', false,
 (SELECT id FROM procedures WHERE nom = 'Impôt sur les revenus fonciers (IRF)' LIMIT 1));

-- ============================================
-- 3.336. COÛTS DE LA PROCÉDURE IRF
-- ============================================

INSERT INTO couts (nom, prix, description) VALUES
('Barème progressif IRF', 0, 'Taux d''imposition progressif sur le revenu net imposable selon le barème de l''impôt sur le revenu - Variable selon le montant'),
('Frais de déclaration', 0, 'Frais de traitement de la déclaration IRF - Montant fixé par la DGI'),
('Pénalités de retard', 0, 'Pénalités applicables en cas de retard dans la déclaration ou le paiement de l''impôt sur les revenus fonciers'),
('Intérêts de retard', 0, 'Intérêts de retard calculés sur le montant de l''impôt non payé dans les délais');

-- Association des coûts à la procédure
UPDATE procedures 
SET cout_id = (SELECT id FROM couts WHERE nom = 'Barème progressif IRF' LIMIT 1)
WHERE nom = 'Impôt sur les revenus fonciers (IRF)';

-- ============================================
-- 3.337. ASSOCIATION DU CENTRE POUR IRF
-- ============================================

-- Association du centre à la procédure
UPDATE procedures 
SET centre_id = (SELECT id FROM centres WHERE nom = 'Direction Générale des Impôts (DGI)' LIMIT 1)
WHERE nom = 'Impôt sur les revenus fonciers (IRF)';

-- ============================================
-- 3.338. ARTICLES DE LOI POUR IRF
-- ============================================

INSERT INTO lois_articles (description, consulter_article, procedure_id) VALUES
-- Impôt sur les revenus fonciers
('Impôt sur les revenus fonciers', 
 'Le Code Général des Impôts définit les règles applicables à l''impôt sur les revenus fonciers, notamment le champ d''application, l''assiette, les déductions et les modalités de déclaration.',
 (SELECT id FROM procedures WHERE nom = 'Impôt sur les revenus fonciers (IRF)' LIMIT 1)),

-- Charges déductibles IRF
('Charges déductibles IRF', 
 'Le Code Général des Impôts définit les charges déductibles des revenus fonciers : travaux, réparations, assurances, taxes, intérêts d''emprunt, amortissements, frais de gestion.',
 (SELECT id FROM procedures WHERE nom = 'Impôt sur les revenus fonciers (IRF)' LIMIT 1)),

-- Barème progressif IRF
('Barème progressif IRF', 
 'Le Code Général des Impôts fixe un barème progressif pour l''imposition des revenus fonciers selon le montant du revenu net imposable.',
 (SELECT id FROM procedures WHERE nom = 'Impôt sur les revenus fonciers (IRF)' LIMIT 1)),

-- Obligations déclaratives IRF
('Obligations déclaratives IRF', 
 'Le Code Général des Impôts définit les obligations déclaratives des propriétaires de biens immobiliers, notamment les délais de déclaration et les documents à fournir.',
 (SELECT id FROM procedures WHERE nom = 'Impôt sur les revenus fonciers (IRF)' LIMIT 1));

-- ============================================
-- 3.339. PROCÉDURE: PATENTE SUR MARCHÉS
-- ============================================

-- Insertion de la procédure
INSERT INTO procedures (nom, titre, delai, description, categorie_id, sous_categorie_id, date_creation) VALUES
('Patente sur marchés', 'Payer la patente sur marchés', 'Annuel - au plus tard le 30 janvier de l''année N+1', 
 'La patente sur marchés est un impôt direct qui s''applique à toute personne, résident ou non résident, qui bénéficie des contrats de marchés publics au Mali. Elle concerne la livraison de biens et de services aux organismes publics ou parapublics. La patente sur marchés est calculée sur les montants encaissés sur les marchés dont l''entreprise est attributaire. Cette taxe est destinée à financer les équipements collectifs et les services publics. Le paiement de la patente sur marchés est obligatoire pour tous les bénéficiaires de contrats de marchés publics.',
 (SELECT id FROM categories WHERE titre = 'Impôt et Douane' LIMIT 1),
 (SELECT id FROM sous_categories WHERE titre = 'Patente sur marchés' LIMIT 1),
 NOW());

-- ============================================
-- 3.340. ÉTAPES DE LA PROCÉDURE PATENTE SUR MARCHÉS
-- ============================================

INSERT INTO etapes (nom, description, niveau, procedure_id) VALUES
-- Étape 1: Vérification de l'assujettissement
('Vérification de l''assujettissement', 'Vérifier que l''entreprise est assujettie à la patente sur marchés selon la DGI : bénéficiaire de contrats de marchés publics pour la livraison de biens et services aux organismes publics ou parapublics.', 1,
 (SELECT id FROM procedures WHERE nom = 'Patente sur marchés' LIMIT 1)),

-- Étape 2: Calcul des montants encaissés
('Calcul des montants encaissés', 'Calculer les montants encaissés sur les marchés publics dont l''entreprise est attributaire au cours de l''année concernée.', 2,
 (SELECT id FROM procedures WHERE nom = 'Patente sur marchés' LIMIT 1)),

-- Étape 3: Détermination de la catégorie
('Détermination de la catégorie', 'Déterminer la catégorie de patente sur marchés applicable selon le montant des marchés encaissés et le type d''activité.', 3,
 (SELECT id FROM procedures WHERE nom = 'Patente sur marchés' LIMIT 1)),

-- Étape 4: Calcul de la patente
('Calcul de la patente', 'Calculer le montant de la patente sur marchés selon le barème applicable, en fonction des montants encaissés et de la catégorie.', 4,
 (SELECT id FROM procedures WHERE nom = 'Patente sur marchés' LIMIT 1)),

-- Étape 5: Déclaration et paiement
('Déclaration et paiement', 'Établir et déposer la déclaration de patente sur marchés et effectuer le paiement au plus tard le 30 janvier de l''année N+1 selon les modalités fixées par la Direction Générale des Impôts.', 5,
 (SELECT id FROM procedures WHERE nom = 'Patente sur marchés' LIMIT 1));

-- ============================================
-- 3.341. DOCUMENTS REQUIS POUR PATENTE SUR MARCHÉS
-- ============================================

INSERT INTO documents_requis (nom, description, obligatoire, procedure_id) VALUES
('Déclaration patente marchés', 'Formulaire de déclaration de patente sur marchés, disponible auprès des services fiscaux.', true,
 (SELECT id FROM procedures WHERE nom = 'Patente sur marchés' LIMIT 1)),

('Contrats de marchés publics', 'Contrats de marchés publics dont l''entreprise est attributaire avec indication des montants et dates d''exécution.', true,
 (SELECT id FROM procedures WHERE nom = 'Patente sur marchés' LIMIT 1)),

('Justificatifs des encaissements', 'Justificatifs des montants encaissés sur les marchés publics : factures, bons de livraison, attestations de réception, etc.', true,
 (SELECT id FROM procedures WHERE nom = 'Patente sur marchés' LIMIT 1)),

('Pièce d''identité', 'Pièce d''identité du représentant légal de l''entreprise (carte d''identité, passeport).', true,
 (SELECT id FROM procedures WHERE nom = 'Patente sur marchés' LIMIT 1)),

('Justificatif d''activité', 'Justificatif de l''activité de l''entreprise : certificat d''immatriculation, autorisation d''exercice, etc.', false,
 (SELECT id FROM procedures WHERE nom = 'Patente sur marchés' LIMIT 1));

-- ============================================
-- 3.342. COÛTS DE LA PROCÉDURE PATENTE SUR MARCHÉS
-- ============================================

INSERT INTO couts (nom, prix, description) VALUES
('Barème patente marchés', 0, 'Montant de la patente sur marchés calculé selon le barème applicable sur les montants encaissés - Variable selon les montants'),
('Frais de déclaration', 0, 'Frais de traitement de la déclaration de patente sur marchés - Montant fixé par la DGI'),
('Pénalités de retard', 0, 'Pénalités applicables en cas de retard dans la déclaration ou le paiement de la patente sur marchés'),
('Intérêts de retard', 0, 'Intérêts de retard calculés sur le montant de la patente non payée dans les délais');

-- Association des coûts à la procédure
UPDATE procedures 
SET cout_id = (SELECT id FROM couts WHERE nom = 'Barème patente marchés' LIMIT 1)
WHERE nom = 'Patente sur marchés';

-- ============================================
-- 3.343. ASSOCIATION DU CENTRE POUR PATENTE SUR MARCHÉS
-- ============================================

-- Association du centre à la procédure
UPDATE procedures 
SET centre_id = (SELECT id FROM centres WHERE nom = 'Direction Générale des Impôts (DGI)' LIMIT 1)
WHERE nom = 'Patente sur marchés';

-- ============================================
-- 3.344. ARTICLES DE LOI POUR PATENTE SUR MARCHÉS
-- ============================================

INSERT INTO lois_articles (description, consulter_article, procedure_id) VALUES
-- Patente sur marchés publics
('Patente sur marchés publics', 
 'La patente sur marchés publics s''applique à toute personne, résident ou non résident, qui bénéficie des contrats de marchés publics pour la livraison de biens et de services aux organismes publics ou parapublics.',
 (SELECT id FROM procedures WHERE nom = 'Patente sur marchés' LIMIT 1)),

-- Délai de déclaration
('Délai de déclaration', 
 'La déclaration et le paiement de la patente sur marchés doivent être effectués au plus tard le 30 janvier de l''année N+1 pour les montants encaissés sur les marchés de l''année précédente.',
 (SELECT id FROM procedures WHERE nom = 'Patente sur marchés' LIMIT 1)),

-- Base d'imposition
('Base d''imposition', 
 'La patente sur marchés est calculée sur les montants encaissés sur les marchés publics dont l''entreprise est attributaire au cours de l''année concernée.',
 (SELECT id FROM procedures WHERE nom = 'Patente sur marchés' LIMIT 1)),

-- Obligations déclaratives
('Obligations déclaratives', 
 'Les bénéficiaires de contrats de marchés publics sont tenus de déclarer et payer la patente sur marchés selon les modalités fixées par la Direction Générale des Impôts.',
 (SELECT id FROM procedures WHERE nom = 'Patente sur marchés' LIMIT 1));

-- ============================================
-- 3.345. PROCÉDURE: TAXE TOURISTIQUE (T.T)
-- ============================================

-- Insertion de la procédure
INSERT INTO procedures (nom, titre, delai, description, categorie_id, sous_categorie_id, date_creation) VALUES
('Taxe touristique (T.T)', 'Déclarer et payer la taxe touristique', 'Mensuel - dans la 1ère quinzaine du mois suivant', 
 'La taxe touristique (T.T) est un impôt indirect qui s''applique aux activités touristiques au Mali. Elle concerne les établissements hôteliers, les agences de voyage, les guides touristiques, les restaurants touristiques, et autres prestataires de services touristiques. La taxe touristique est calculée selon un barème différencié selon le type d''activité touristique et le chiffre d''affaires réalisé. Elle est destinée à financer le développement du secteur touristique et les équipements touristiques. Le paiement de la taxe touristique est obligatoire pour tous les prestataires de services touristiques.',
 (SELECT id FROM categories WHERE titre = 'Impôt et Douane' LIMIT 1),
 (SELECT id FROM sous_categories WHERE titre = 'Taxe touristique (T.T)' LIMIT 1),
 NOW());

-- ============================================
-- 3.346. ÉTAPES DE LA PROCÉDURE TAXE TOURISTIQUE
-- ============================================

INSERT INTO etapes (nom, description, niveau, procedure_id) VALUES
-- Étape 1: Vérification de l'assujettissement
('Vérification de l''assujettissement', 'Vérifier que l''activité exercée est soumise à la taxe touristique selon la DGI : établissements hôteliers, agences de voyage, guides touristiques, restaurants touristiques, etc.', 1,
 (SELECT id FROM procedures WHERE nom = 'Taxe touristique (T.T)' LIMIT 1)),

-- Étape 2: Calcul du chiffre d'affaires
('Calcul du chiffre d''affaires', 'Calculer le chiffre d''affaires réalisé au cours du mois dans le cadre des activités touristiques.', 2,
 (SELECT id FROM procedures WHERE nom = 'Taxe touristique (T.T)' LIMIT 1)),

-- Étape 3: Détermination de la catégorie
('Détermination de la catégorie', 'Déterminer la catégorie de taxe touristique applicable selon le type d''activité et le chiffre d''affaires réalisé.', 3,
 (SELECT id FROM procedures WHERE nom = 'Taxe touristique (T.T)' LIMIT 1)),

-- Étape 4: Calcul de la taxe
('Calcul de la taxe', 'Calculer le montant de la taxe touristique selon le barème applicable, en fonction de la catégorie et du chiffre d''affaires.', 4,
 (SELECT id FROM procedures WHERE nom = 'Taxe touristique (T.T)' LIMIT 1)),

-- Étape 5: Déclaration et paiement
('Déclaration et paiement', 'Établir et déposer la déclaration de taxe touristique et effectuer le paiement dans la 1ère quinzaine du mois suivant selon les modalités fixées par la Direction Générale des Impôts.', 5,
 (SELECT id FROM procedures WHERE nom = 'Taxe touristique (T.T)' LIMIT 1));

-- ============================================
-- 3.347. DOCUMENTS REQUIS POUR TAXE TOURISTIQUE
-- ============================================

INSERT INTO documents_requis (nom, description, obligatoire, procedure_id) VALUES
('Déclaration taxe touristique', 'Formulaire de déclaration de taxe touristique, disponible auprès des services fiscaux.', true,
 (SELECT id FROM procedures WHERE nom = 'Taxe touristique (T.T)' LIMIT 1)),

('Justificatif d''activité touristique', 'Justificatif de l''activité touristique : licence d''exploitation, autorisation d''exercice, agrément, etc.', true,
 (SELECT id FROM procedures WHERE nom = 'Taxe touristique (T.T)' LIMIT 1)),

('Relevé de chiffre d''affaires', 'Relevé du chiffre d''affaires réalisé au cours du mois dans le cadre des activités touristiques.', true,
 (SELECT id FROM procedures WHERE nom = 'Taxe touristique (T.T)' LIMIT 1)),

('Pièce d''identité', 'Pièce d''identité du représentant légal (carte d''identité, passeport).', true,
 (SELECT id FROM procedures WHERE nom = 'Taxe touristique (T.T)' LIMIT 1)),

('Factures de ventes', 'Factures de ventes émises au cours du mois pour justifier le chiffre d''affaires déclaré.', false,
 (SELECT id FROM procedures WHERE nom = 'Taxe touristique (T.T)' LIMIT 1));

-- ============================================
-- 3.348. COÛTS DE LA PROCÉDURE TAXE TOURISTIQUE
-- ============================================

INSERT INTO couts (nom, prix, description) VALUES
('Barème taxe touristique', 0, 'Montant de la taxe touristique calculé selon le barème applicable sur le chiffre d''affaires - Variable selon l''activité'),
('Frais de déclaration', 0, 'Frais de traitement de la déclaration de taxe touristique - Montant fixé par la DGI'),
('Pénalités de retard', 0, 'Pénalités applicables en cas de retard dans la déclaration ou le paiement de la taxe touristique'),
('Intérêts de retard', 0, 'Intérêts de retard calculés sur le montant de la taxe non payée dans les délais');

-- Association des coûts à la procédure
UPDATE procedures 
SET cout_id = (SELECT id FROM couts WHERE nom = 'Barème taxe touristique' LIMIT 1)
WHERE nom = 'Taxe touristique (T.T)';

-- ============================================
-- 3.349. ASSOCIATION DU CENTRE POUR TAXE TOURISTIQUE
-- ============================================

-- Association du centre à la procédure
UPDATE procedures 
SET centre_id = (SELECT id FROM centres WHERE nom = 'Direction Générale des Impôts (DGI)' LIMIT 1)
WHERE nom = 'Taxe touristique (T.T)';

-- ============================================
-- 3.350. ARTICLES DE LOI POUR TAXE TOURISTIQUE
-- ============================================

INSERT INTO lois_articles (description, consulter_article, procedure_id) VALUES
-- Taxe touristique
('Taxe touristique', 
 'La taxe touristique s''applique aux activités touristiques au Mali : établissements hôteliers, agences de voyage, guides touristiques, restaurants touristiques, et autres prestataires de services touristiques.',
 (SELECT id FROM procedures WHERE nom = 'Taxe touristique (T.T)' LIMIT 1)),

-- Délai de déclaration
('Délai de déclaration', 
 'La déclaration et le paiement de la taxe touristique doivent être effectués dans la 1ère quinzaine du mois suivant celui pendant lequel les opérations sont réalisées.',
 (SELECT id FROM procedures WHERE nom = 'Taxe touristique (T.T)' LIMIT 1)),

-- Base d'imposition
('Base d''imposition', 
 'La taxe touristique est calculée sur le chiffre d''affaires réalisé dans le cadre des activités touristiques selon un barème différencié selon le type d''activité.',
 (SELECT id FROM procedures WHERE nom = 'Taxe touristique (T.T)' LIMIT 1)),

-- Obligations déclaratives
('Obligations déclaratives', 
 'Les prestataires de services touristiques sont tenus de déclarer et payer la taxe touristique selon les modalités fixées par la Direction Générale des Impôts.',
 (SELECT id FROM procedures WHERE nom = 'Taxe touristique (T.T)' LIMIT 1));

-- ============================================
-- 3.351. PROCÉDURE: TAXE INTÉRIEURE SUR LES PRODUITS PÉTROLIERS (TIPP)
-- ============================================

-- Insertion de la procédure
INSERT INTO procedures (nom, titre, delai, description, categorie_id, sous_categorie_id, date_creation) VALUES
('Taxe intérieure sur les produits pétroliers (TIPP)', 'Déclarer et payer la TIPP', 'Mensuel - dans la 1ère quinzaine du mois suivant', 
 'La Taxe intérieure sur les produits pétroliers (TIPP) est un impôt indirect qui s''applique aux produits pétroliers au Mali. Elle concerne l''importation, la production, la distribution et la vente de produits pétroliers tels que l''essence, le gasoil, le kérosène, le fuel domestique, etc. La TIPP est calculée selon un barème différencié selon le type de produit pétrolier et les quantités. Elle est destinée à financer les infrastructures routières et les équipements collectifs. Le paiement de la TIPP est obligatoire pour tous les importateurs, producteurs et distributeurs de produits pétroliers.',
 (SELECT id FROM categories WHERE titre = 'Impôt et Douane' LIMIT 1),
 (SELECT id FROM sous_categories WHERE titre = 'Taxe intérieure sur les produits pétroliers (TIPP)' LIMIT 1),
 NOW());

-- ============================================
-- 3.352. ÉTAPES DE LA PROCÉDURE TIPP
-- ============================================

INSERT INTO etapes (nom, description, niveau, procedure_id) VALUES
-- Étape 1: Vérification de l'assujettissement
('Vérification de l''assujettissement', 'Vérifier que l''activité exercée est soumise à la TIPP selon la DGI : importation, production, distribution ou vente de produits pétroliers.', 1,
 (SELECT id FROM procedures WHERE nom = 'Taxe intérieure sur les produits pétroliers (TIPP)' LIMIT 1)),

-- Étape 2: Calcul des quantités
('Calcul des quantités', 'Calculer les quantités de produits pétroliers importés, produits, distribués ou vendus au cours du mois.', 2,
 (SELECT id FROM procedures WHERE nom = 'Taxe intérieure sur les produits pétroliers (TIPP)' LIMIT 1)),

-- Étape 3: Détermination du taux
('Détermination du taux', 'Déterminer le taux de TIPP applicable selon le type de produit pétrolier : essence, gasoil, kérosène, fuel domestique, etc.', 3,
 (SELECT id FROM procedures WHERE nom = 'Taxe intérieure sur les produits pétroliers (TIPP)' LIMIT 1)),

-- Étape 4: Calcul de la taxe
('Calcul de la taxe', 'Calculer le montant de la TIPP selon le barème applicable, en fonction des quantités et du taux applicable.', 4,
 (SELECT id FROM procedures WHERE nom = 'Taxe intérieure sur les produits pétroliers (TIPP)' LIMIT 1)),

-- Étape 5: Déclaration et paiement
('Déclaration et paiement', 'Établir et déposer la déclaration de TIPP et effectuer le paiement dans la 1ère quinzaine du mois suivant selon les modalités fixées par la Direction Générale des Impôts.', 5,
 (SELECT id FROM procedures WHERE nom = 'Taxe intérieure sur les produits pétroliers (TIPP)' LIMIT 1));

-- ============================================
-- 3.353. DOCUMENTS REQUIS POUR TIPP
-- ============================================

INSERT INTO documents_requis (nom, description, obligatoire, procedure_id) VALUES
('Déclaration TIPP', 'Formulaire de déclaration de Taxe intérieure sur les produits pétroliers, disponible auprès des services fiscaux.', true,
 (SELECT id FROM procedures WHERE nom = 'Taxe intérieure sur les produits pétroliers (TIPP)' LIMIT 1)),

('Justificatif d''activité pétrolière', 'Justificatif de l''activité pétrolière : licence d''importation, autorisation de production, agrément de distribution, etc.', true,
 (SELECT id FROM procedures WHERE nom = 'Taxe intérieure sur les produits pétroliers (TIPP)' LIMIT 1)),

('Relevé des quantités', 'Relevé des quantités de produits pétroliers importés, produits, distribués ou vendus au cours du mois.', true,
 (SELECT id FROM procedures WHERE nom = 'Taxe intérieure sur les produits pétroliers (TIPP)' LIMIT 1)),

('Pièce d''identité', 'Pièce d''identité du représentant légal (carte d''identité, passeport).', true,
 (SELECT id FROM procedures WHERE nom = 'Taxe intérieure sur les produits pétroliers (TIPP)' LIMIT 1)),

('Factures de vente', 'Factures de vente des produits pétroliers émises au cours du mois pour justifier les quantités déclarées.', false,
 (SELECT id FROM procedures WHERE nom = 'Taxe intérieure sur les produits pétroliers (TIPP)' LIMIT 1));

-- ============================================
-- 3.354. COÛTS DE LA PROCÉDURE TIPP
-- ============================================

INSERT INTO couts (nom, prix, description) VALUES
('Barème TIPP', 0, 'Montant de la TIPP calculé selon le barème applicable sur les quantités de produits pétroliers - Variable selon le type de produit'),
('Frais de déclaration', 0, 'Frais de traitement de la déclaration de TIPP - Montant fixé par la DGI'),
('Pénalités de retard', 0, 'Pénalités applicables en cas de retard dans la déclaration ou le paiement de la TIPP'),
('Intérêts de retard', 0, 'Intérêts de retard calculés sur le montant de la taxe non payée dans les délais');

-- Association des coûts à la procédure
UPDATE procedures 
SET cout_id = (SELECT id FROM couts WHERE nom = 'Barème TIPP' LIMIT 1)
WHERE nom = 'Taxe intérieure sur les produits pétroliers (TIPP)';

-- ============================================
-- 3.355. ASSOCIATION DU CENTRE POUR TIPP
-- ============================================

-- Association du centre à la procédure
UPDATE procedures 
SET centre_id = (SELECT id FROM centres WHERE nom = 'Direction Générale des Impôts (DGI)' LIMIT 1)
WHERE nom = 'Taxe intérieure sur les produits pétroliers (TIPP)';

-- ============================================
-- 3.356. ARTICLES DE LOI POUR TIPP
-- ============================================

INSERT INTO lois_articles (description, consulter_article, procedure_id) VALUES
-- Taxe intérieure sur les produits pétroliers
('Taxe intérieure sur les produits pétroliers', 
 'La TIPP s''applique aux produits pétroliers au Mali : essence, gasoil, kérosène, fuel domestique, etc. Elle concerne l''importation, la production, la distribution et la vente de ces produits.',
 (SELECT id FROM procedures WHERE nom = 'Taxe intérieure sur les produits pétroliers (TIPP)' LIMIT 1)),

-- Délai de déclaration
('Délai de déclaration', 
 'La déclaration et le paiement de la TIPP doivent être effectués dans la 1ère quinzaine du mois suivant celui pendant lequel les opérations sont réalisées.',
 (SELECT id FROM procedures WHERE nom = 'Taxe intérieure sur les produits pétroliers (TIPP)' LIMIT 1)),

-- Base d'imposition
('Base d''imposition', 
 'La TIPP est calculée sur les quantités de produits pétroliers importés, produits, distribués ou vendus selon un barème différencié selon le type de produit.',
 (SELECT id FROM procedures WHERE nom = 'Taxe intérieure sur les produits pétroliers (TIPP)' LIMIT 1)),

-- Obligations déclaratives
('Obligations déclaratives', 
 'Les importateurs, producteurs et distributeurs de produits pétroliers sont tenus de déclarer et payer la TIPP selon les modalités fixées par la Direction Générale des Impôts.',
 (SELECT id FROM procedures WHERE nom = 'Taxe intérieure sur les produits pétroliers (TIPP)' LIMIT 1));

-- ============================================
-- 3.357. PROCÉDURE: CONTRIBUTION DE SOLIDARITÉ SUR LES BILLETS D'AVION (CSB)
-- ============================================

-- Insertion de la procédure
INSERT INTO procedures (nom, titre, delai, description, categorie_id, sous_categorie_id, date_creation) VALUES
('Contribution de solidarité sur les billets d''avion (CSB)', 'Déclarer et payer la CSB', 'Mensuel - dans la 1ère quinzaine du mois suivant', 
 'La Contribution de solidarité sur les billets d''avion (CSB) est un impôt indirect qui s''applique aux billets d''avion émis au Mali. Elle concerne les compagnies aériennes, les agences de voyage, les plateformes de réservation et tous les émetteurs de billets d''avion. La CSB est calculée selon un barème fixe ou proportionnel sur le montant des billets d''avion émis. Elle est destinée à financer des actions de solidarité et de développement. Le paiement de la CSB est obligatoire pour tous les émetteurs de billets d''avion.',
 (SELECT id FROM categories WHERE titre = 'Impôt et Douane' LIMIT 1),
 (SELECT id FROM sous_categories WHERE titre = 'Contribution de solidarité sur les billets d''avion (CSB)' LIMIT 1),
 NOW());

-- ============================================
-- 3.358. ÉTAPES DE LA PROCÉDURE CSB
-- ============================================

INSERT INTO etapes (nom, description, niveau, procedure_id) VALUES
-- Étape 1: Vérification de l'assujettissement
('Vérification de l''assujettissement', 'Vérifier que l''activité exercée est soumise à la CSB selon la DGI : émission de billets d''avion par des compagnies aériennes, agences de voyage, plateformes de réservation, etc.', 1,
 (SELECT id FROM procedures WHERE nom = 'Contribution de solidarité sur les billets d''avion (CSB)' LIMIT 1)),

-- Étape 2: Calcul des billets émis
('Calcul des billets émis', 'Calculer le nombre et le montant des billets d''avion émis au cours du mois.', 2,
 (SELECT id FROM procedures WHERE nom = 'Contribution de solidarité sur les billets d''avion (CSB)' LIMIT 1)),

-- Étape 3: Détermination du taux
('Détermination du taux', 'Déterminer le taux de CSB applicable selon le type de billet et la destination.', 3,
 (SELECT id FROM procedures WHERE nom = 'Contribution de solidarité sur les billets d''avion (CSB)' LIMIT 1)),

-- Étape 4: Calcul de la contribution
('Calcul de la contribution', 'Calculer le montant de la CSB selon le barème applicable, en fonction du nombre de billets et du taux applicable.', 4,
 (SELECT id FROM procedures WHERE nom = 'Contribution de solidarité sur les billets d''avion (CSB)' LIMIT 1)),

-- Étape 5: Déclaration et paiement
('Déclaration et paiement', 'Établir et déposer la déclaration de CSB et effectuer le paiement dans la 1ère quinzaine du mois suivant selon les modalités fixées par la Direction Générale des Impôts.', 5,
 (SELECT id FROM procedures WHERE nom = 'Contribution de solidarité sur les billets d''avion (CSB)' LIMIT 1));

-- ============================================
-- 3.359. DOCUMENTS REQUIS POUR CSB
-- ============================================

INSERT INTO documents_requis (nom, description, obligatoire, procedure_id) VALUES
('Déclaration CSB', 'Formulaire de déclaration de Contribution de solidarité sur les billets d''avion, disponible auprès des services fiscaux.', true,
 (SELECT id FROM procedures WHERE nom = 'Contribution de solidarité sur les billets d''avion (CSB)' LIMIT 1)),

('Justificatif d''activité aérienne', 'Justificatif de l''activité aérienne : licence d''exploitation, autorisation d''émission de billets, agrément, etc.', true,
 (SELECT id FROM procedures WHERE nom = 'Contribution de solidarité sur les billets d''avion (CSB)' LIMIT 1)),

('Relevé des billets émis', 'Relevé du nombre et du montant des billets d''avion émis au cours du mois.', true,
 (SELECT id FROM procedures WHERE nom = 'Contribution de solidarité sur les billets d''avion (CSB)' LIMIT 1)),

('Pièce d''identité', 'Pièce d''identité du représentant légal (carte d''identité, passeport).', true,
 (SELECT id FROM procedures WHERE nom = 'Contribution de solidarité sur les billets d''avion (CSB)' LIMIT 1)),

('Factures de billets', 'Factures de billets d''avion émises au cours du mois pour justifier les montants déclarés.', false,
 (SELECT id FROM procedures WHERE nom = 'Contribution de solidarité sur les billets d''avion (CSB)' LIMIT 1));

-- ============================================
-- 3.360. COÛTS DE LA PROCÉDURE CSB
-- ============================================

INSERT INTO couts (nom, prix, description) VALUES
('Barème CSB', 0, 'Montant de la CSB calculé selon le barème applicable sur les billets d''avion émis - Variable selon le type de billet'),
('Frais de déclaration', 0, 'Frais de traitement de la déclaration de CSB - Montant fixé par la DGI'),
('Pénalités de retard', 0, 'Pénalités applicables en cas de retard dans la déclaration ou le paiement de la CSB'),
('Intérêts de retard', 0, 'Intérêts de retard calculés sur le montant de la contribution non payée dans les délais');

-- Association des coûts à la procédure
UPDATE procedures 
SET cout_id = (SELECT id FROM couts WHERE nom = 'Barème CSB' LIMIT 1)
WHERE nom = 'Contribution de solidarité sur les billets d''avion (CSB)';

-- ============================================
-- 3.361. ASSOCIATION DU CENTRE POUR CSB
-- ============================================

-- Association du centre à la procédure
UPDATE procedures 
SET centre_id = (SELECT id FROM centres WHERE nom = 'Direction Générale des Impôts (DGI)' LIMIT 1)
WHERE nom = 'Contribution de solidarité sur les billets d''avion (CSB)';

-- ============================================
-- 3.362. ARTICLES DE LOI POUR CSB
-- ============================================

INSERT INTO lois_articles (description, consulter_article, procedure_id) VALUES
-- Contribution de solidarité sur les billets d'avion
('Contribution de solidarité sur les billets d''avion', 
 'La CSB s''applique aux billets d''avion émis au Mali par les compagnies aériennes, agences de voyage, plateformes de réservation et tous les émetteurs de billets d''avion.',
 (SELECT id FROM procedures WHERE nom = 'Contribution de solidarité sur les billets d''avion (CSB)' LIMIT 1)),

-- Délai de déclaration
('Délai de déclaration', 
 'La déclaration et le paiement de la CSB doivent être effectués dans la 1ère quinzaine du mois suivant celui pendant lequel les opérations sont réalisées.',
 (SELECT id FROM procedures WHERE nom = 'Contribution de solidarité sur les billets d''avion (CSB)' LIMIT 1)),

-- Base d'imposition
('Base d''imposition', 
 'La CSB est calculée sur le nombre et le montant des billets d''avion émis selon un barème fixe ou proportionnel selon le type de billet et la destination.',
 (SELECT id FROM procedures WHERE nom = 'Contribution de solidarité sur les billets d''avion (CSB)' LIMIT 1)),

-- Obligations déclaratives
('Obligations déclaratives', 
 'Les émetteurs de billets d''avion sont tenus de déclarer et payer la CSB selon les modalités fixées par la Direction Générale des Impôts.',
 (SELECT id FROM procedures WHERE nom = 'Contribution de solidarité sur les billets d''avion (CSB)' LIMIT 1));

-- ============================================
-- 3.363. PROCÉDURE: TAXE SUR L'ACCÈS AU RÉSEAU DES TÉLÉCOMMUNICATIONS (TARTOP)
-- ============================================

-- Insertion de la procédure
INSERT INTO procedures (nom, titre, delai, description, categorie_id, sous_categorie_id, date_creation) VALUES
('Taxe sur l''accès au réseau des télécommunications (TARTOP)', 'Déclarer et payer la TARTOP', 'Mensuel - dans la 1ère quinzaine du mois suivant', 
 'La Taxe sur l''accès au réseau des télécommunications ouvert au public (TARTOP) est un impôt indirect qui s''applique aux opérateurs de télécommunications au Mali. Elle concerne l''accès aux réseaux de télécommunications ouverts au public, incluant les services de téléphonie mobile, fixe, internet, et autres services de télécommunications. La TARTOP est calculée selon un barème différencié selon le type de service et le volume de trafic. Elle est destinée à financer le développement des infrastructures de télécommunications et la régulation du secteur. Le paiement de la TARTOP est obligatoire pour tous les opérateurs de télécommunications.',
 (SELECT id FROM categories WHERE titre = 'Impôt et Douane' LIMIT 1),
 (SELECT id FROM sous_categories WHERE titre = 'Taxe sur l''accès au réseau des télécommunications (TARTOP)' LIMIT 1),
 NOW());

-- ============================================
-- 3.364. ÉTAPES DE LA PROCÉDURE TARTOP
-- ============================================

INSERT INTO etapes (nom, description, niveau, procedure_id) VALUES
-- Étape 1: Vérification de l'assujettissement
('Vérification de l''assujettissement', 'Vérifier que l''activité exercée est soumise à la TARTOP selon la DGI : opérateur de télécommunications offrant des services d''accès au réseau ouvert au public.', 1,
 (SELECT id FROM procedures WHERE nom = 'Taxe sur l''accès au réseau des télécommunications (TARTOP)' LIMIT 1)),

-- Étape 2: Calcul du volume de trafic
('Calcul du volume de trafic', 'Calculer le volume de trafic et les revenus générés par l''accès au réseau de télécommunications au cours du mois.', 2,
 (SELECT id FROM procedures WHERE nom = 'Taxe sur l''accès au réseau des télécommunications (TARTOP)' LIMIT 1)),

-- Étape 3: Détermination du taux
('Détermination du taux', 'Déterminer le taux de TARTOP applicable selon le type de service : téléphonie mobile, fixe, internet, etc.', 3,
 (SELECT id FROM procedures WHERE nom = 'Taxe sur l''accès au réseau des télécommunications (TARTOP)' LIMIT 1)),

-- Étape 4: Calcul de la taxe
('Calcul de la taxe', 'Calculer le montant de la TARTOP selon le barème applicable, en fonction du volume de trafic et du taux applicable.', 4,
 (SELECT id FROM procedures WHERE nom = 'Taxe sur l''accès au réseau des télécommunications (TARTOP)' LIMIT 1)),

-- Étape 5: Déclaration et paiement
('Déclaration et paiement', 'Établir et déposer la déclaration de TARTOP et effectuer le paiement dans la 1ère quinzaine du mois suivant selon les modalités fixées par la Direction Générale des Impôts.', 5,
 (SELECT id FROM procedures WHERE nom = 'Taxe sur l''accès au réseau des télécommunications (TARTOP)' LIMIT 1));

-- ============================================
-- 3.365. DOCUMENTS REQUIS POUR TARTOP
-- ============================================

INSERT INTO documents_requis (nom, description, obligatoire, procedure_id) VALUES
('Déclaration TARTOP', 'Formulaire de déclaration de Taxe sur l''accès au réseau des télécommunications, disponible auprès des services fiscaux.', true,
 (SELECT id FROM procedures WHERE nom = 'Taxe sur l''accès au réseau des télécommunications (TARTOP)' LIMIT 1)),

('Licence de télécommunications', 'Licence d''exploitation de services de télécommunications délivrée par l''Autorité de Régulation des Télécommunications.', true,
 (SELECT id FROM procedures WHERE nom = 'Taxe sur l''accès au réseau des télécommunications (TARTOP)' LIMIT 1)),

('Relevé de trafic', 'Relevé du volume de trafic et des revenus générés par l''accès au réseau de télécommunications au cours du mois.', true,
 (SELECT id FROM procedures WHERE nom = 'Taxe sur l''accès au réseau des télécommunications (TARTOP)' LIMIT 1)),

('Pièce d''identité', 'Pièce d''identité du représentant légal (carte d''identité, passeport).', true,
 (SELECT id FROM procedures WHERE nom = 'Taxe sur l''accès au réseau des télécommunications (TARTOP)' LIMIT 1)),

('Rapport d''activité', 'Rapport d''activité mensuel détaillant les services offerts et les volumes de trafic.', false,
 (SELECT id FROM procedures WHERE nom = 'Taxe sur l''accès au réseau des télécommunications (TARTOP)' LIMIT 1));

-- ============================================
-- 3.366. COÛTS DE LA PROCÉDURE TARTOP
-- ============================================

INSERT INTO couts (nom, prix, description) VALUES
('Barème TARTOP', 0, 'Montant de la TARTOP calculé selon le barème applicable sur le volume de trafic - Variable selon le type de service'),
('Frais de déclaration', 0, 'Frais de traitement de la déclaration de TARTOP - Montant fixé par la DGI'),
('Pénalités de retard', 0, 'Pénalités applicables en cas de retard dans la déclaration ou le paiement de la TARTOP'),
('Intérêts de retard', 0, 'Intérêts de retard calculés sur le montant de la taxe non payée dans les délais');

-- Association des coûts à la procédure
UPDATE procedures 
SET cout_id = (SELECT id FROM couts WHERE nom = 'Barème TARTOP' LIMIT 1)
WHERE nom = 'Taxe sur l''accès au réseau des télécommunications (TARTOP)';

-- ============================================
-- 3.367. ASSOCIATION DU CENTRE POUR TARTOP
-- ============================================

-- Association du centre à la procédure
UPDATE procedures 
SET centre_id = (SELECT id FROM centres WHERE nom = 'Direction Générale des Impôts (DGI)' LIMIT 1)
WHERE nom = 'Taxe sur l''accès au réseau des télécommunications (TARTOP)';

-- ============================================
-- 3.368. ARTICLES DE LOI POUR TARTOP
-- ============================================

INSERT INTO lois_articles (description, consulter_article, procedure_id) VALUES
-- Taxe sur l'accès au réseau des télécommunications
('Taxe sur l''accès au réseau des télécommunications', 
 'La TARTOP s''applique aux opérateurs de télécommunications au Mali offrant des services d''accès au réseau ouvert au public : téléphonie mobile, fixe, internet, et autres services de télécommunications.',
 (SELECT id FROM procedures WHERE nom = 'Taxe sur l''accès au réseau des télécommunications (TARTOP)' LIMIT 1)),

-- Délai de déclaration
('Délai de déclaration', 
 'La déclaration et le paiement de la TARTOP doivent être effectués dans la 1ère quinzaine du mois suivant celui pendant lequel les opérations sont réalisées.',
 (SELECT id FROM procedures WHERE nom = 'Taxe sur l''accès au réseau des télécommunications (TARTOP)' LIMIT 1)),

-- Base d'imposition
('Base d''imposition', 
 'La TARTOP est calculée sur le volume de trafic et les revenus générés par l''accès au réseau de télécommunications selon un barème différencié selon le type de service.',
 (SELECT id FROM procedures WHERE nom = 'Taxe sur l''accès au réseau des télécommunications (TARTOP)' LIMIT 1)),

-- Obligations déclaratives
('Obligations déclaratives', 
 'Les opérateurs de télécommunications sont tenus de déclarer et payer la TARTOP selon les modalités fixées par la Direction Générale des Impôts.',
 (SELECT id FROM procedures WHERE nom = 'Taxe sur l''accès au réseau des télécommunications (TARTOP)' LIMIT 1));

-- ============================================
-- 3.369. PROCÉDURE: TAXE SUR LES CONTRATS D'ASSURANCE (TCA)
-- ============================================

-- Insertion de la procédure
INSERT INTO procedures (nom, titre, delai, description, categorie_id, sous_categorie_id, date_creation) VALUES
('Taxe sur les contrats d''assurance (TCA)', 'Déclarer et payer la TCA', 'Mensuel - dans la 1ère quinzaine du mois suivant', 
 'La Taxe sur les contrats d''assurance (TCA) est un impôt indirect qui s''applique aux contrats d''assurance au Mali. Elle concerne tous les types d''assurances : assurance automobile, assurance habitation, assurance vie, assurance santé, assurance entreprise, etc. La TCA est calculée selon un barème différencié selon le type d''assurance et le montant des primes. Elle est destinée à financer la régulation du secteur de l''assurance et les équipements collectifs. Le paiement de la TCA est obligatoire pour tous les assureurs et courtiers d''assurance.',
 (SELECT id FROM categories WHERE titre = 'Impôt et Douane' LIMIT 1),
 (SELECT id FROM sous_categories WHERE titre = 'Taxe sur les contrats d''assurance (TCA)' LIMIT 1),
 NOW());

-- ============================================
-- 3.370. ÉTAPES DE LA PROCÉDURE TCA
-- ============================================

INSERT INTO etapes (nom, description, niveau, procedure_id) VALUES
-- Étape 1: Vérification de l'assujettissement
('Vérification de l''assujettissement', 'Vérifier que l''activité exercée est soumise à la TCA selon la DGI : assureur, courtier d''assurance, ou intermédiaire en assurance.', 1,
 (SELECT id FROM procedures WHERE nom = 'Taxe sur les contrats d''assurance (TCA)' LIMIT 1)),

-- Étape 2: Calcul des primes
('Calcul des primes', 'Calculer le montant des primes d''assurance collectées au cours du mois pour tous les types de contrats.', 2,
 (SELECT id FROM procedures WHERE nom = 'Taxe sur les contrats d''assurance (TCA)' LIMIT 1)),

-- Étape 3: Détermination du taux
('Détermination du taux', 'Déterminer le taux de TCA applicable selon le type d''assurance : automobile, habitation, vie, santé, entreprise, etc.', 3,
 (SELECT id FROM procedures WHERE nom = 'Taxe sur les contrats d''assurance (TCA)' LIMIT 1)),

-- Étape 4: Calcul de la taxe
('Calcul de la taxe', 'Calculer le montant de la TCA selon le barème applicable, en fonction des primes collectées et du taux applicable.', 4,
 (SELECT id FROM procedures WHERE nom = 'Taxe sur les contrats d''assurance (TCA)' LIMIT 1)),

-- Étape 5: Déclaration et paiement
('Déclaration et paiement', 'Établir et déposer la déclaration de TCA et effectuer le paiement dans la 1ère quinzaine du mois suivant selon les modalités fixées par la Direction Générale des Impôts.', 5,
 (SELECT id FROM procedures WHERE nom = 'Taxe sur les contrats d''assurance (TCA)' LIMIT 1));

-- ============================================
-- 3.371. DOCUMENTS REQUIS POUR TCA
-- ============================================

INSERT INTO documents_requis (nom, description, obligatoire, procedure_id) VALUES
('Déclaration TCA', 'Formulaire de déclaration de Taxe sur les contrats d''assurance, disponible auprès des services fiscaux.', true,
 (SELECT id FROM procedures WHERE nom = 'Taxe sur les contrats d''assurance (TCA)' LIMIT 1)),

('Autorisation d''exercice', 'Autorisation d''exercice d''activité d''assurance délivrée par l''Autorité de Contrôle des Assurances.', true,
 (SELECT id FROM procedures WHERE nom = 'Taxe sur les contrats d''assurance (TCA)' LIMIT 1)),

('Relevé des primes', 'Relevé du montant des primes d''assurance collectées au cours du mois par type de contrat.', true,
 (SELECT id FROM procedures WHERE nom = 'Taxe sur les contrats d''assurance (TCA)' LIMIT 1)),

('Pièce d''identité', 'Pièce d''identité du représentant légal (carte d''identité, passeport).', true,
 (SELECT id FROM procedures WHERE nom = 'Taxe sur les contrats d''assurance (TCA)' LIMIT 1)),

('Contrats d''assurance', 'Copies des contrats d''assurance conclus au cours du mois pour justifier les primes déclarées.', false,
 (SELECT id FROM procedures WHERE nom = 'Taxe sur les contrats d''assurance (TCA)' LIMIT 1));

-- ============================================
-- 3.372. COÛTS DE LA PROCÉDURE TCA
-- ============================================

INSERT INTO couts (nom, prix, description) VALUES
('Barème TCA', 0, 'Montant de la TCA calculé selon le barème applicable sur les primes d''assurance - Variable selon le type d''assurance'),
('Frais de déclaration', 0, 'Frais de traitement de la déclaration de TCA - Montant fixé par la DGI'),
('Pénalités de retard', 0, 'Pénalités applicables en cas de retard dans la déclaration ou le paiement de la TCA'),
('Intérêts de retard', 0, 'Intérêts de retard calculés sur le montant de la taxe non payée dans les délais');

-- Association des coûts à la procédure
UPDATE procedures 
SET cout_id = (SELECT id FROM couts WHERE nom = 'Barème TCA' LIMIT 1)
WHERE nom = 'Taxe sur les contrats d''assurance (TCA)';

-- ============================================
-- 3.373. ASSOCIATION DU CENTRE POUR TCA
-- ============================================

-- Association du centre à la procédure
UPDATE procedures 
SET centre_id = (SELECT id FROM centres WHERE nom = 'Direction Générale des Impôts (DGI)' LIMIT 1)
WHERE nom = 'Taxe sur les contrats d''assurance (TCA)';

-- ============================================
-- 3.374. ARTICLES DE LOI POUR TCA
-- ============================================

INSERT INTO lois_articles (description, consulter_article, procedure_id) VALUES
-- Taxe sur les contrats d'assurance
('Taxe sur les contrats d''assurance', 
 'La TCA s''applique aux contrats d''assurance au Mali : assurance automobile, habitation, vie, santé, entreprise, et tous autres types d''assurances.',
 (SELECT id FROM procedures WHERE nom = 'Taxe sur les contrats d''assurance (TCA)' LIMIT 1)),

-- Délai de déclaration
('Délai de déclaration', 
 'La déclaration et le paiement de la TCA doivent être effectués dans la 1ère quinzaine du mois suivant celui pendant lequel les opérations sont réalisées.',
 (SELECT id FROM procedures WHERE nom = 'Taxe sur les contrats d''assurance (TCA)' LIMIT 1)),

-- Base d'imposition
('Base d''imposition', 
 'La TCA est calculée sur les primes d''assurance collectées selon un barème différencié selon le type d''assurance et le montant des primes.',
 (SELECT id FROM procedures WHERE nom = 'Taxe sur les contrats d''assurance (TCA)' LIMIT 1)),

-- Obligations déclaratives
('Obligations déclaratives', 
 'Les assureurs et courtiers d''assurance sont tenus de déclarer et payer la TCA selon les modalités fixées par la Direction Générale des Impôts.',
 (SELECT id FROM procedures WHERE nom = 'Taxe sur les contrats d''assurance (TCA)' LIMIT 1));

-- ============================================
-- 3.375. PROCÉDURE: TAXE SUR LES EXPORTATEURS D'OR NON RÉGIS PAR LE CODE MINIER
-- ============================================

-- Insertion de la procédure
INSERT INTO procedures (nom, titre, delai, description, categorie_id, sous_categorie_id, date_creation) VALUES
('Taxe sur les exportateurs d''or non régis par le code minier', 'Déclarer et payer la taxe sur l''or', 'Mensuel - dans la 1ère quinzaine du mois suivant', 
 'La Taxe sur les exportateurs d''or non régis par le code minier est un impôt indirect qui s''applique aux exportateurs d''or au Mali qui ne sont pas soumis au régime du code minier. Elle concerne les exportateurs d''or artisanal, les négociants d''or, et autres acteurs de la filière aurifère non couverts par le code minier. La taxe est calculée selon un barème différencié selon le type d''exportation et la quantité d''or exportée. Elle est destinée à financer le développement du secteur minier artisanal et la régulation de la filière aurifère. Le paiement de cette taxe est obligatoire pour tous les exportateurs d''or non régis par le code minier.',
 (SELECT id FROM categories WHERE titre = 'Impôt et Douane' LIMIT 1),
 (SELECT id FROM sous_categories WHERE titre = 'Taxe sur les exportateurs d''or non régis par le code minier' LIMIT 1),
 NOW());

-- ============================================
-- 3.376. ÉTAPES DE LA PROCÉDURE TAXE SUR L'OR
-- ============================================

INSERT INTO etapes (nom, description, niveau, procedure_id) VALUES
-- Étape 1: Vérification de l'assujettissement
('Vérification de l''assujettissement', 'Vérifier que l''activité exercée est soumise à la taxe sur l''or selon la DGI : exportateur d''or non régi par le code minier (or artisanal, négociants, etc.).', 1,
 (SELECT id FROM procedures WHERE nom = 'Taxe sur les exportateurs d''or non régis par le code minier' LIMIT 1)),

-- Étape 2: Calcul des quantités exportées
('Calcul des quantités exportées', 'Calculer les quantités d''or exportées au cours du mois et leur valeur marchande.', 2,
 (SELECT id FROM procedures WHERE nom = 'Taxe sur les exportateurs d''or non régis par le code minier' LIMIT 1)),

-- Étape 3: Détermination du taux
('Détermination du taux', 'Déterminer le taux de taxe applicable selon le type d''exportation et la quantité d''or exportée.', 3,
 (SELECT id FROM procedures WHERE nom = 'Taxe sur les exportateurs d''or non régis par le code minier' LIMIT 1)),

-- Étape 4: Calcul de la taxe
('Calcul de la taxe', 'Calculer le montant de la taxe selon le barème applicable, en fonction des quantités exportées et du taux applicable.', 4,
 (SELECT id FROM procedures WHERE nom = 'Taxe sur les exportateurs d''or non régis par le code minier' LIMIT 1)),

-- Étape 5: Déclaration et paiement
('Déclaration et paiement', 'Établir et déposer la déclaration de taxe sur l''or et effectuer le paiement dans la 1ère quinzaine du mois suivant selon les modalités fixées par la Direction Générale des Impôts.', 5,
 (SELECT id FROM procedures WHERE nom = 'Taxe sur les exportateurs d''or non régis par le code minier' LIMIT 1));

-- ============================================
-- 3.377. DOCUMENTS REQUIS POUR TAXE SUR L'OR
-- ============================================

INSERT INTO documents_requis (nom, description, obligatoire, procedure_id) VALUES
('Déclaration taxe or', 'Formulaire de déclaration de taxe sur les exportateurs d''or non régis par le code minier, disponible auprès des services fiscaux.', true,
 (SELECT id FROM procedures WHERE nom = 'Taxe sur les exportateurs d''or non régis par le code minier' LIMIT 1)),

('Autorisation d''exportation', 'Autorisation d''exportation d''or délivrée par les autorités compétentes.', true,
 (SELECT id FROM procedures WHERE nom = 'Taxe sur les exportateurs d''or non régis par le code minier' LIMIT 1)),

('Certificat d''origine', 'Certificat d''origine de l''or exporté attestant de sa provenance malienne.', true,
 (SELECT id FROM procedures WHERE nom = 'Taxe sur les exportateurs d''or non régis par le code minier' LIMIT 1)),

('Pièce d''identité', 'Pièce d''identité du représentant légal (carte d''identité, passeport).', true,
 (SELECT id FROM procedures WHERE nom = 'Taxe sur les exportateurs d''or non régis par le code minier' LIMIT 1)),

('Factures d''exportation', 'Factures d''exportation d''or émises au cours du mois pour justifier les quantités déclarées.', false,
 (SELECT id FROM procedures WHERE nom = 'Taxe sur les exportateurs d''or non régis par le code minier' LIMIT 1));

-- ============================================
-- 3.378. COÛTS DE LA PROCÉDURE TAXE SUR L'OR
-- ============================================

INSERT INTO couts (nom, prix, description) VALUES
('Barème taxe or', 0, 'Montant de la taxe sur l''or calculé selon le barème applicable sur les quantités exportées - Variable selon le type d''exportation'),
('Frais de déclaration', 0, 'Frais de traitement de la déclaration de taxe sur l''or - Montant fixé par la DGI'),
('Pénalités de retard', 0, 'Pénalités applicables en cas de retard dans la déclaration ou le paiement de la taxe sur l''or'),
('Intérêts de retard', 0, 'Intérêts de retard calculés sur le montant de la taxe non payée dans les délais');

-- Association des coûts à la procédure
UPDATE procedures 
SET cout_id = (SELECT id FROM couts WHERE nom = 'Barème taxe or' LIMIT 1)
WHERE nom = 'Taxe sur les exportateurs d''or non régis par le code minier';

-- ============================================
-- 3.379. ASSOCIATION DU CENTRE POUR TAXE SUR L'OR
-- ============================================

-- Association du centre à la procédure
UPDATE procedures 
SET centre_id = (SELECT id FROM centres WHERE nom = 'Direction Générale des Impôts (DGI)' LIMIT 1)
WHERE nom = 'Taxe sur les exportateurs d''or non régis par le code minier';

-- ============================================
-- 3.380. ARTICLES DE LOI POUR TAXE SUR L'OR
-- ============================================

INSERT INTO lois_articles (description, consulter_article, procedure_id) VALUES
-- Taxe sur les exportateurs d'or
('Taxe sur les exportateurs d''or', 
 'La taxe sur les exportateurs d''or non régis par le code minier s''applique aux exportateurs d''or artisanal, négociants d''or, et autres acteurs de la filière aurifère non couverts par le code minier.',
 (SELECT id FROM procedures WHERE nom = 'Taxe sur les exportateurs d''or non régis par le code minier' LIMIT 1)),

-- Délai de déclaration
('Délai de déclaration', 
 'La déclaration et le paiement de la taxe sur l''or doivent être effectués dans la 1ère quinzaine du mois suivant celui pendant lequel les opérations sont réalisées.',
 (SELECT id FROM procedures WHERE nom = 'Taxe sur les exportateurs d''or non régis par le code minier' LIMIT 1)),

-- Base d'imposition
('Base d''imposition', 
 'La taxe sur l''or est calculée sur les quantités d''or exportées et leur valeur marchande selon un barème différencié selon le type d''exportation.',
 (SELECT id FROM procedures WHERE nom = 'Taxe sur les exportateurs d''or non régis par le code minier' LIMIT 1)),

-- Obligations déclaratives
('Obligations déclaratives', 
 'Les exportateurs d''or non régis par le code minier sont tenus de déclarer et payer cette taxe selon les modalités fixées par la Direction Générale des Impôts.',
 (SELECT id FROM procedures WHERE nom = 'Taxe sur les exportateurs d''or non régis par le code minier' LIMIT 1));

-- ============================================
-- 3.381. PROCÉDURE: LES PRÉLÈVEMENTS
-- ============================================

-- Insertion de la procédure
INSERT INTO procedures (nom, titre, delai, description, categorie_id, sous_categorie_id, date_creation) VALUES
('Les prélèvements', 'Effectuer les prélèvements obligatoires', 'Variable selon le type de prélèvement', 
 'Les prélèvements sont des retenues à la source effectuées par les employeurs, les clients, ou les organismes payeurs sur les revenus, salaires, honoraires, et autres sommes versées. Ils concernent notamment les prélèvements sur les salaires (retenue à la source), les prélèvements sur les honoraires, les prélèvements sur les revenus fonciers, les prélèvements sur les bénéfices commerciaux, etc. Les prélèvements sont calculés selon des barèmes spécifiques et sont reversés à l''administration fiscale. Ils constituent un mécanisme de recouvrement anticipé de l''impôt. Le respect des obligations de prélèvement est obligatoire pour tous les organismes payeurs.',
 (SELECT id FROM categories WHERE titre = 'Impôt et Douane' LIMIT 1),
 (SELECT id FROM sous_categories WHERE titre = 'Les prélèvements' LIMIT 1),
 NOW());

-- ============================================
-- 3.382. ÉTAPES DE LA PROCÉDURE PRÉLÈVEMENTS
-- ============================================

INSERT INTO etapes (nom, description, niveau, procedure_id) VALUES
-- Étape 1: Vérification de l'assujettissement
('Vérification de l''assujettissement', 'Vérifier que l''organisme est tenu d''effectuer des prélèvements selon la DGI : employeur, client, organisme payeur de revenus, honoraires, etc.', 1,
 (SELECT id FROM procedures WHERE nom = 'Les prélèvements' LIMIT 1)),

-- Étape 2: Calcul des montants à prélever
('Calcul des montants à prélever', 'Calculer les montants à prélever selon les barèmes applicables : salaires, honoraires, revenus fonciers, bénéfices commerciaux, etc.', 2,
 (SELECT id FROM procedures WHERE nom = 'Les prélèvements' LIMIT 1)),

-- Étape 3: Détermination du taux
('Détermination du taux', 'Déterminer le taux de prélèvement applicable selon le type de revenu et le montant versé.', 3,
 (SELECT id FROM procedures WHERE nom = 'Les prélèvements' LIMIT 1)),

-- Étape 4: Calcul du prélèvement
('Calcul du prélèvement', 'Calculer le montant du prélèvement selon le barème applicable, en fonction des montants versés et du taux applicable.', 4,
 (SELECT id FROM procedures WHERE nom = 'Les prélèvements' LIMIT 1)),

-- Étape 5: Déclaration et reversement
('Déclaration et reversement', 'Établir et déposer la déclaration de prélèvements et effectuer le reversement à l''administration fiscale selon les modalités et échéances fixées.', 5,
 (SELECT id FROM procedures WHERE nom = 'Les prélèvements' LIMIT 1));

-- ============================================
-- 3.383. DOCUMENTS REQUIS POUR PRÉLÈVEMENTS
-- ============================================

INSERT INTO documents_requis (nom, description, obligatoire, procedure_id) VALUES
('Déclaration prélèvements', 'Formulaire de déclaration de prélèvements, disponible auprès des services fiscaux.', true,
 (SELECT id FROM procedures WHERE nom = 'Les prélèvements' LIMIT 1)),

('Justificatif d''activité', 'Justificatif de l''activité de l''organisme payeur : certificat d''immatriculation, autorisation d''exercice, etc.', true,
 (SELECT id FROM procedures WHERE nom = 'Les prélèvements' LIMIT 1)),

('Relevé des versements', 'Relevé des montants versés au cours de la période avec indication des prélèvements effectués.', true,
 (SELECT id FROM procedures WHERE nom = 'Les prélèvements' LIMIT 1)),

('Pièce d''identité', 'Pièce d''identité du représentant légal (carte d''identité, passeport).', true,
 (SELECT id FROM procedures WHERE nom = 'Les prélèvements' LIMIT 1)),

('Bulletins de paie', 'Bulletins de paie ou factures pour justifier les montants versés et les prélèvements effectués.', false,
 (SELECT id FROM procedures WHERE nom = 'Les prélèvements' LIMIT 1));

-- ============================================
-- 3.384. COÛTS DE LA PROCÉDURE PRÉLÈVEMENTS
-- ============================================

INSERT INTO couts (nom, prix, description) VALUES
('Barème prélèvements', 0, 'Montant des prélèvements calculé selon les barèmes applicables - Variable selon le type de revenu'),
('Frais de déclaration', 0, 'Frais de traitement de la déclaration de prélèvements - Montant fixé par la DGI'),
('Pénalités de retard', 0, 'Pénalités applicables en cas de retard dans la déclaration ou le reversement des prélèvements'),
('Intérêts de retard', 0, 'Intérêts de retard calculés sur le montant des prélèvements non reversés dans les délais');

-- Association des coûts à la procédure
UPDATE procedures 
SET cout_id = (SELECT id FROM couts WHERE nom = 'Barème prélèvements' LIMIT 1)
WHERE nom = 'Les prélèvements';

-- ============================================
-- 3.385. ASSOCIATION DU CENTRE POUR PRÉLÈVEMENTS
-- ============================================

-- Association du centre à la procédure
UPDATE procedures 
SET centre_id = (SELECT id FROM centres WHERE nom = 'Direction Générale des Impôts (DGI)' LIMIT 1)
WHERE nom = 'Les prélèvements';

-- ============================================
-- 3.386. ARTICLES DE LOI POUR PRÉLÈVEMENTS
-- ============================================

INSERT INTO lois_articles (description, consulter_article, procedure_id) VALUES
-- Prélèvements obligatoires
('Prélèvements obligatoires', 
 'Les prélèvements sont des retenues à la source effectuées par les employeurs, clients, ou organismes payeurs sur les revenus, salaires, honoraires, et autres sommes versées.',
 (SELECT id FROM procedures WHERE nom = 'Les prélèvements' LIMIT 1)),

-- Délai de reversement
('Délai de reversement', 
 'Les prélèvements doivent être reversés à l''administration fiscale selon les modalités et échéances fixées par la Direction Générale des Impôts.',
 (SELECT id FROM procedures WHERE nom = 'Les prélèvements' LIMIT 1)),

-- Base d'imposition
('Base d''imposition', 
 'Les prélèvements sont calculés sur les montants versés selon des barèmes spécifiques : salaires, honoraires, revenus fonciers, bénéfices commerciaux, etc.',
 (SELECT id FROM procedures WHERE nom = 'Les prélèvements' LIMIT 1)),

-- Obligations déclaratives
('Obligations déclaratives', 
 'Les organismes payeurs sont tenus de déclarer et reverser les prélèvements selon les modalités fixées par la Direction Générale des Impôts.',
 (SELECT id FROM procedures WHERE nom = 'Les prélèvements' LIMIT 1));

-- ============================================
-- 3.387. PROCÉDURE: REDEVANCE ET RECOUVREMENT DE RÉGULATION SUR LES MARCHÉS PUBLICS
-- ============================================

-- Insertion de la procédure
INSERT INTO procedures (nom, titre, delai, description, categorie_id, sous_categorie_id, date_creation) VALUES
('Redevance et recouvrement de régulation sur les marchés publics', 'Payer la redevance de régulation', 'Variable selon le type de marché', 
 'La Redevance et recouvrement de régulation sur les marchés publics est un impôt direct qui s''applique aux bénéficiaires de marchés publics au Mali. Elle concerne tous les types de marchés publics : fournitures, services, travaux, et autres prestations. La redevance de régulation est calculée selon un barème différencié selon le montant du marché et le type de prestation. Elle est destinée à financer la régulation et le contrôle des marchés publics, ainsi que le développement des équipements collectifs. Le paiement de cette redevance est obligatoire pour tous les bénéficiaires de marchés publics.',
 (SELECT id FROM categories WHERE titre = 'Impôt et Douane' LIMIT 1),
 (SELECT id FROM sous_categories WHERE titre = 'Redevance et recouvrement de régulation sur les marchés publics' LIMIT 1),
 NOW());

-- ============================================
-- 3.388. ÉTAPES DE LA PROCÉDURE REDEVANCE MARCHÉS
-- ============================================

INSERT INTO etapes (nom, description, niveau, procedure_id) VALUES
-- Étape 1: Vérification de l'assujettissement
('Vérification de l''assujettissement', 'Vérifier que l''entreprise est assujettie à la redevance de régulation selon la DGI : bénéficiaire de marchés publics (fournitures, services, travaux, etc.).', 1,
 (SELECT id FROM procedures WHERE nom = 'Redevance et recouvrement de régulation sur les marchés publics' LIMIT 1)),

-- Étape 2: Calcul du montant du marché
('Calcul du montant du marché', 'Calculer le montant total du marché public attribué et les sommes encaissées au cours de la période.', 2,
 (SELECT id FROM procedures WHERE nom = 'Redevance et recouvrement de régulation sur les marchés publics' LIMIT 1)),

-- Étape 3: Détermination du taux
('Détermination du taux', 'Déterminer le taux de redevance applicable selon le montant du marché et le type de prestation.', 3,
 (SELECT id FROM procedures WHERE nom = 'Redevance et recouvrement de régulation sur les marchés publics' LIMIT 1)),

-- Étape 4: Calcul de la redevance
('Calcul de la redevance', 'Calculer le montant de la redevance selon le barème applicable, en fonction du montant du marché et du taux applicable.', 4,
 (SELECT id FROM procedures WHERE nom = 'Redevance et recouvrement de régulation sur les marchés publics' LIMIT 1)),

-- Étape 5: Déclaration et paiement
('Déclaration et paiement', 'Établir et déposer la déclaration de redevance et effectuer le paiement selon les modalités et échéances fixées par la Direction Générale des Impôts.', 5,
 (SELECT id FROM procedures WHERE nom = 'Redevance et recouvrement de régulation sur les marchés publics' LIMIT 1));

-- ============================================
-- 3.389. DOCUMENTS REQUIS POUR REDEVANCE MARCHÉS
-- ============================================

INSERT INTO documents_requis (nom, description, obligatoire, procedure_id) VALUES
('Déclaration redevance', 'Formulaire de déclaration de redevance et recouvrement de régulation sur les marchés publics, disponible auprès des services fiscaux.', true,
 (SELECT id FROM procedures WHERE nom = 'Redevance et recouvrement de régulation sur les marchés publics' LIMIT 1)),

('Contrats de marchés publics', 'Contrats de marchés publics attribués avec indication des montants et dates d''exécution.', true,
 (SELECT id FROM procedures WHERE nom = 'Redevance et recouvrement de régulation sur les marchés publics' LIMIT 1)),

('Justificatifs des encaissements', 'Justificatifs des montants encaissés sur les marchés publics : factures, bons de livraison, attestations de réception, etc.', true,
 (SELECT id FROM procedures WHERE nom = 'Redevance et recouvrement de régulation sur les marchés publics' LIMIT 1)),

('Pièce d''identité', 'Pièce d''identité du représentant légal de l''entreprise (carte d''identité, passeport).', true,
 (SELECT id FROM procedures WHERE nom = 'Redevance et recouvrement de régulation sur les marchés publics' LIMIT 1)),

('Justificatif d''activité', 'Justificatif de l''activité de l''entreprise : certificat d''immatriculation, autorisation d''exercice, etc.', false,
 (SELECT id FROM procedures WHERE nom = 'Redevance et recouvrement de régulation sur les marchés publics' LIMIT 1));

-- ============================================
-- 3.390. COÛTS DE LA PROCÉDURE REDEVANCE MARCHÉS
-- ============================================

INSERT INTO couts (nom, prix, description) VALUES
('Barème redevance marchés', 0, 'Montant de la redevance calculé selon le barème applicable sur le montant du marché - Variable selon le type de prestation'),
('Frais de déclaration', 0, 'Frais de traitement de la déclaration de redevance - Montant fixé par la DGI'),
('Pénalités de retard', 0, 'Pénalités applicables en cas de retard dans la déclaration ou le paiement de la redevance'),
('Intérêts de retard', 0, 'Intérêts de retard calculés sur le montant de la redevance non payée dans les délais');

-- Association des coûts à la procédure
UPDATE procedures 
SET cout_id = (SELECT id FROM couts WHERE nom = 'Barème redevance marchés' LIMIT 1)
WHERE nom = 'Redevance et recouvrement de régulation sur les marchés publics';

-- ============================================
-- 3.391. ASSOCIATION DU CENTRE POUR REDEVANCE MARCHÉS
-- ============================================

-- Association du centre à la procédure
UPDATE procedures 
SET centre_id = (SELECT id FROM centres WHERE nom = 'Direction Générale des Impôts (DGI)' LIMIT 1)
WHERE nom = 'Redevance et recouvrement de régulation sur les marchés publics';

-- ============================================
-- 3.392. ARTICLES DE LOI POUR REDEVANCE MARCHÉS
-- ============================================

INSERT INTO lois_articles (description, consulter_article, procedure_id) VALUES
-- Redevance de régulation sur les marchés publics
('Redevance de régulation sur les marchés publics', 
 'La redevance et recouvrement de régulation sur les marchés publics s''applique aux bénéficiaires de marchés publics au Mali : fournitures, services, travaux, et autres prestations.',
 (SELECT id FROM procedures WHERE nom = 'Redevance et recouvrement de régulation sur les marchés publics' LIMIT 1)),

-- Délai de déclaration
('Délai de déclaration', 
 'La déclaration et le paiement de la redevance doivent être effectués selon les modalités et échéances fixées par la Direction Générale des Impôts.',
 (SELECT id FROM procedures WHERE nom = 'Redevance et recouvrement de régulation sur les marchés publics' LIMIT 1)),

-- Base d'imposition
('Base d''imposition', 
 'La redevance est calculée sur le montant des marchés publics attribués selon un barème différencié selon le montant du marché et le type de prestation.',
 (SELECT id FROM procedures WHERE nom = 'Redevance et recouvrement de régulation sur les marchés publics' LIMIT 1)),

-- Obligations déclaratives
('Obligations déclaratives', 
 'Les bénéficiaires de marchés publics sont tenus de déclarer et payer la redevance de régulation selon les modalités fixées par la Direction Générale des Impôts.',
 (SELECT id FROM procedures WHERE nom = 'Redevance et recouvrement de régulation sur les marchés publics' LIMIT 1));

-- ============================================
-- 3.393. PROCÉDURE: TAXE SUR LES ARMES À FEU
-- ============================================

-- Insertion de la procédure
INSERT INTO procedures (nom, titre, delai, description, categorie_id, sous_categorie_id, date_creation) VALUES
('Taxe sur les armes à feu', 'Déclarer et payer la taxe sur les armes à feu', 'Mensuel - dans la 1ère quinzaine du mois suivant', 
 'La Taxe sur les armes à feu est un impôt indirect qui s''applique aux armes à feu au Mali. Elle concerne l''importation, la vente, la détention, et l''utilisation d''armes à feu par les particuliers, les entreprises de sécurité, les forces de l''ordre, et autres détenteurs autorisés. La taxe est calculée selon un barème différencié selon le type d''arme, son calibre, et son usage. Elle est destinée à financer la régulation et le contrôle des armes à feu, ainsi que la sécurité publique. Le paiement de cette taxe est obligatoire pour tous les détenteurs d''armes à feu.',
 (SELECT id FROM categories WHERE titre = 'Impôt et Douane' LIMIT 1),
 (SELECT id FROM sous_categories WHERE titre = 'Taxe sur les armes à feu' LIMIT 1),
 NOW());

-- ============================================
-- 3.394. ÉTAPES DE LA PROCÉDURE TAXE ARMES
-- ============================================

INSERT INTO etapes (nom, description, niveau, procedure_id) VALUES
-- Étape 1: Vérification de l'assujettissement
('Vérification de l''assujettissement', 'Vérifier que l''activité exercée est soumise à la taxe sur les armes à feu selon la DGI : détenteur d''armes à feu, importateur, vendeur, etc.', 1,
 (SELECT id FROM procedures WHERE nom = 'Taxe sur les armes à feu' LIMIT 1)),

-- Étape 2: Inventaire des armes
('Inventaire des armes', 'Établir l''inventaire des armes à feu détenues, importées, vendues, ou utilisées au cours du mois.', 2,
 (SELECT id FROM procedures WHERE nom = 'Taxe sur les armes à feu' LIMIT 1)),

-- Étape 3: Détermination du taux
('Détermination du taux', 'Déterminer le taux de taxe applicable selon le type d''arme, son calibre, et son usage.', 3,
 (SELECT id FROM procedures WHERE nom = 'Taxe sur les armes à feu' LIMIT 1)),

-- Étape 4: Calcul de la taxe
('Calcul de la taxe', 'Calculer le montant de la taxe selon le barème applicable, en fonction du nombre d''armes et du taux applicable.', 4,
 (SELECT id FROM procedures WHERE nom = 'Taxe sur les armes à feu' LIMIT 1)),

-- Étape 5: Déclaration et paiement
('Déclaration et paiement', 'Établir et déposer la déclaration de taxe sur les armes à feu et effectuer le paiement dans la 1ère quinzaine du mois suivant selon les modalités fixées par la Direction Générale des Impôts.', 5,
 (SELECT id FROM procedures WHERE nom = 'Taxe sur les armes à feu' LIMIT 1));

-- ============================================
-- 3.395. DOCUMENTS REQUIS POUR TAXE ARMES
-- ============================================

INSERT INTO documents_requis (nom, description, obligatoire, procedure_id) VALUES
('Déclaration taxe armes', 'Formulaire de déclaration de taxe sur les armes à feu, disponible auprès des services fiscaux.', true,
 (SELECT id FROM procedures WHERE nom = 'Taxe sur les armes à feu' LIMIT 1)),

('Autorisation de détention', 'Autorisation de détention d''armes à feu délivrée par les autorités compétentes.', true,
 (SELECT id FROM procedures WHERE nom = 'Taxe sur les armes à feu' LIMIT 1)),

('Inventaire des armes', 'Inventaire détaillé des armes à feu détenues, importées, vendues, ou utilisées au cours du mois.', true,
 (SELECT id FROM procedures WHERE nom = 'Taxe sur les armes à feu' LIMIT 1)),

('Pièce d''identité', 'Pièce d''identité du représentant légal (carte d''identité, passeport).', true,
 (SELECT id FROM procedures WHERE nom = 'Taxe sur les armes à feu' LIMIT 1)),

('Certificats d''armes', 'Certificats d''armes à feu pour justifier la détention et l''utilisation des armes déclarées.', false,
 (SELECT id FROM procedures WHERE nom = 'Taxe sur les armes à feu' LIMIT 1));

-- ============================================
-- 3.396. COÛTS DE LA PROCÉDURE TAXE ARMES
-- ============================================

INSERT INTO couts (nom, prix, description) VALUES
('Barème taxe armes', 0, 'Montant de la taxe sur les armes à feu calculé selon le barème applicable - Variable selon le type d''arme'),
('Frais de déclaration', 0, 'Frais de traitement de la déclaration de taxe sur les armes à feu - Montant fixé par la DGI'),
('Pénalités de retard', 0, 'Pénalités applicables en cas de retard dans la déclaration ou le paiement de la taxe sur les armes à feu'),
('Intérêts de retard', 0, 'Intérêts de retard calculés sur le montant de la taxe non payée dans les délais');

-- Association des coûts à la procédure
UPDATE procedures 
SET cout_id = (SELECT id FROM couts WHERE nom = 'Barème taxe armes' LIMIT 1)
WHERE nom = 'Taxe sur les armes à feu';

-- ============================================
-- 3.397. ASSOCIATION DU CENTRE POUR TAXE ARMES
-- ============================================

-- Association du centre à la procédure
UPDATE procedures 
SET centre_id = (SELECT id FROM centres WHERE nom = 'Direction Générale des Impôts (DGI)' LIMIT 1)
WHERE nom = 'Taxe sur les armes à feu';

-- ============================================
-- 3.398. ARTICLES DE LOI POUR TAXE ARMES
-- ============================================

INSERT INTO lois_articles (description, consulter_article, procedure_id) VALUES
-- Taxe sur les armes à feu
('Taxe sur les armes à feu', 
 'La taxe sur les armes à feu s''applique aux armes à feu au Mali : importation, vente, détention, et utilisation d''armes à feu par les particuliers, entreprises de sécurité, forces de l''ordre, et autres détenteurs autorisés.',
 (SELECT id FROM procedures WHERE nom = 'Taxe sur les armes à feu' LIMIT 1)),

-- Délai de déclaration
('Délai de déclaration', 
 'La déclaration et le paiement de la taxe sur les armes à feu doivent être effectués dans la 1ère quinzaine du mois suivant celui pendant lequel les opérations sont réalisées.',
 (SELECT id FROM procedures WHERE nom = 'Taxe sur les armes à feu' LIMIT 1)),

-- Base d'imposition
('Base d''imposition', 
 'La taxe sur les armes à feu est calculée selon un barème différencié selon le type d''arme, son calibre, et son usage.',
 (SELECT id FROM procedures WHERE nom = 'Taxe sur les armes à feu' LIMIT 1)),

-- Obligations déclaratives
('Obligations déclaratives', 
 'Les détenteurs d''armes à feu sont tenus de déclarer et payer cette taxe selon les modalités fixées par la Direction Générale des Impôts.',
 (SELECT id FROM procedures WHERE nom = 'Taxe sur les armes à feu' LIMIT 1));

-- ============================================
-- 3.399. PROCÉDURE: PERMIS DE CONDUIRE (OBTENTION)
-- ============================================

-- Insertion de la procédure
INSERT INTO procedures (nom, titre, delai, description, categorie_id, sous_categorie_id, date_creation) VALUES
('Permis de conduire (obtention)', 'Obtenir un permis de conduire', 'Variable selon la disponibilité des examens', 
 'L''obtention du permis de conduire au Mali suit une procédure standardisée bien que l''instruction dans une auto-école ne soit pas légalement obligatoire. La procédure comprend la préparation du dossier avec tous les documents requis, le dépôt auprès de la Direction Régionale des Transports, la réussite aux examens théorique et pratique, et enfin la délivrance du permis. Cette procédure est régie par le Code de la route malien et le Décret N°99-134/PRM du 26 mai 1999. Depuis 2025, une redevance de 15 000 FCFA est exigée en plus des timbres fiscaux pour la délivrance du permis.',
 (SELECT id FROM categories WHERE titre = 'Documents auto' LIMIT 1),
 (SELECT id FROM sous_categories WHERE titre = 'Permis de conduire (obtention)' LIMIT 1),
 NOW());

-- ============================================
-- 3.400. ÉTAPES DE LA PROCÉDURE PERMIS DE CONDUIRE
-- ============================================

INSERT INTO etapes (nom, description, niveau, procedure_id) VALUES
-- Étape 1: Préparation du dossier
('Préparation du dossier', 'Rassembler tous les documents requis : extrait d''acte de naissance, certificat de résidence, 4 photos d''identité, timbres fiscaux, certificat de visite médicale, et certificat de nationalité pour les étrangers.', 1,
 (SELECT id FROM procedures WHERE nom = 'Permis de conduire (obtention)' LIMIT 1)),

-- Étape 2: Dépôt du dossier
('Dépôt du dossier', 'Se rendre à la Direction Régionale des Transports ou dans une subdivision des transports au niveau du cercle pour déposer le dossier complet avec tous les documents requis.', 2,
 (SELECT id FROM procedures WHERE nom = 'Permis de conduire (obtention)' LIMIT 1)),

-- Étape 3: Validation du dossier
('Validation du dossier', 'Attendre la validation du dossier par les services compétents et la programmation des examens théorique et pratique.', 3,
 (SELECT id FROM procedures WHERE nom = 'Permis de conduire (obtention)' LIMIT 1)),

-- Étape 4: Passage des examens
('Passage des examens', 'Passer l''examen théorique sur le code de la route et l''examen pratique de conduite selon les modalités fixées par la Direction Régionale des Transports.', 4,
 (SELECT id FROM procedures WHERE nom = 'Permis de conduire (obtention)' LIMIT 1)),

-- Étape 5: Délivrance du permis
('Délivrance du permis', 'Une fois les examens réussis, payer la redevance de 15 000 FCFA et retirer le permis de conduire auprès du centre de traitement.', 5,
 (SELECT id FROM procedures WHERE nom = 'Permis de conduire (obtention)' LIMIT 1));

-- ============================================
-- 3.401. DOCUMENTS REQUIS POUR PERMIS DE CONDUIRE
-- ============================================

INSERT INTO documents_requis (nom, description, obligatoire, procedure_id) VALUES
('Extrait d''acte de naissance', 'Copie de l''extrait d''acte de naissance du demandeur.', true,
 (SELECT id FROM procedures WHERE nom = 'Permis de conduire (obtention)' LIMIT 1)),

('Certificat de résidence', 'Certificat de résidence attestant du domicile du demandeur.', true,
 (SELECT id FROM procedures WHERE nom = 'Permis de conduire (obtention)' LIMIT 1)),

('Photos d''identité', '4 photos d''identité récentes du demandeur selon les normes en vigueur.', true,
 (SELECT id FROM procedures WHERE nom = 'Permis de conduire (obtention)' LIMIT 1)),

('Timbres fiscaux', 'Timbres fiscaux d''une valeur de 5 750 francs CFA pour les frais de dossier et d''examens.', true,
 (SELECT id FROM procedures WHERE nom = 'Permis de conduire (obtention)' LIMIT 1)),

('Certificat de visite médicale', 'Certificat de visite médicale obligatoire pour certaines catégories de permis selon le Décret N°99-134/PRM.', true,
 (SELECT id FROM procedures WHERE nom = 'Permis de conduire (obtention)' LIMIT 1)),

('Certificat de nationalité', 'Certificat de nationalité requis pour les étrangers résidant au Mali.', false,
 (SELECT id FROM procedures WHERE nom = 'Permis de conduire (obtention)' LIMIT 1));

-- ============================================
-- 3.402. COÛTS DE LA PROCÉDURE PERMIS DE CONDUIRE
-- ============================================

INSERT INTO couts (nom, prix, description) VALUES
('Redevance délivrance permis', 15000, 'Redevance fixe de 15 000 FCFA pour la délivrance du permis de conduire (depuis 2025)'),
('Timbres fiscaux', 5750, 'Timbres fiscaux pour le dossier et les examens : 5 750 francs CFA'),
('Frais visite médicale', 0, 'Frais de la visite médicale obligatoire - Variable selon le centre médical'),
('Frais formation auto-école', 0, 'Frais de formation en auto-école (non obligatoire mais recommandé) - Variable selon l''auto-école');

-- Association des coûts à la procédure
UPDATE procedures 
SET cout_id = (SELECT id FROM couts WHERE nom = 'Redevance délivrance permis' LIMIT 1)
WHERE nom = 'Permis de conduire (obtention)';

-- ============================================
-- 3.403. ASSOCIATION DU CENTRE POUR PERMIS DE CONDUIRE
-- ============================================

-- Association du centre à la procédure
UPDATE procedures 
SET centre_id = (SELECT id FROM centres WHERE nom = 'Direction Régionale des Transports' LIMIT 1)
WHERE nom = 'Permis de conduire (obtention)';

-- ============================================
-- 3.404. ARTICLES DE LOI POUR PERMIS DE CONDUIRE
-- ============================================

INSERT INTO lois_articles (description, consulter_article, procedure_id) VALUES
-- Code de la route malien
('Code de la route malien', 
 'Le Code de la route malien est la référence principale pour l''obtention du permis de conduire. Il définit les procédures, les obligations et les conditions d''obtention du permis de conduire au Mali.',
 (SELECT id FROM procedures WHERE nom = 'Permis de conduire (obtention)' LIMIT 1)),

-- Décret N°99-134/PRM du 26 mai 1999
('Décret N°99-134/PRM du 26 mai 1999', 
 'Le Décret N°99-134/PRM du 26 mai 1999 détaille les procédures et les obligations pour l''obtention du permis de conduire, notamment concernant le renouvellement et les documents requis pour la commission médicale.',
 (SELECT id FROM procedures WHERE nom = 'Permis de conduire (obtention)' LIMIT 1)),

-- Redevance délivrance permis
('Redevance délivrance permis', 
 'Depuis 2025, une redevance de 15 000 FCFA est exigée pour la délivrance du permis de conduire en plus des timbres fiscaux, conformément aux nouvelles dispositions réglementaires.',
 (SELECT id FROM procedures WHERE nom = 'Permis de conduire (obtention)' LIMIT 1)),

-- Procédures d''examen
('Procédures d''examen', 
 'Les procédures d''examen théorique et pratique sont définies par la Direction Régionale des Transports selon les modalités fixées par le Code de la route et les décrets d''application.',
 (SELECT id FROM procedures WHERE nom = 'Permis de conduire (obtention)' LIMIT 1));

-- ============================================
-- 3.405. PROCÉDURE: PERMIS DE CONDUIRE RENOUVELLEMENT
-- ============================================

-- Insertion de la procédure
INSERT INTO procedures (nom, titre, delai, description, categorie_id, sous_categorie_id, date_creation) VALUES
('Permis de conduire renouvellement', 'Renouveler un permis de conduire', 'Variable selon le traitement administratif', 
 'Le renouvellement d''un permis de conduire au Mali implique la mise à jour des informations du titulaire et, dans certains cas, le passage à un format plus récent. La procédure comprend le dépôt du dossier avec les documents requis, la mise à jour des informations du titulaire, et la délivrance du nouveau permis après paiement des frais. Cette procédure est régie par le Code de la route malien et le Décret N°99-134/PRM du 26 mai 1999. Depuis février 2025, une redevance de 15 000 FCFA est exigée en plus des timbres fiscaux. Des frais spécifiques peuvent être appliqués selon la situation (duplicata, permis biométrique, etc.).',
 (SELECT id FROM categories WHERE titre = 'Documents auto' LIMIT 1),
 (SELECT id FROM sous_categories WHERE titre = 'Permis de conduire renouvellement' LIMIT 1),
 NOW());

-- ============================================
-- 3.406. ÉTAPES DE LA PROCÉDURE RENOUVELLEMENT PERMIS
-- ============================================

INSERT INTO etapes (nom, description, niveau, procedure_id) VALUES
-- Étape 1: Préparation du dossier
('Préparation du dossier', 'Rassembler tous les documents requis : permis de conduire périmé, copie de la carte d''identité, certificat de résidence, 4 photos d''identité récentes, déclaration de perte si nécessaire, et certificat médical selon le cas.', 1,
 (SELECT id FROM procedures WHERE nom = 'Permis de conduire renouvellement' LIMIT 1)),

-- Étape 2: Dépôt du dossier
('Dépôt du dossier', 'Se rendre à la Direction régionale des transports terrestres et fluviaux du district de Bamako ou dans ses antennes en région pour déposer le dossier de renouvellement.', 2,
 (SELECT id FROM procedures WHERE nom = 'Permis de conduire renouvellement' LIMIT 1)),

-- Étape 3: Mise à jour des informations
('Mise à jour des informations', 'Les services compétents mettent à jour les informations du titulaire dans le système pour la production du nouveau permis, notamment pour le passage au format biométrique si applicable.', 3,
 (SELECT id FROM procedures WHERE nom = 'Permis de conduire renouvellement' LIMIT 1)),

-- Étape 4: Paiement des frais
('Paiement des frais', 'Effectuer le paiement de la redevance de 15 000 FCFA et des timbres fiscaux, ainsi que des frais spécifiques selon la situation (duplicata, permis biométrique, etc.).', 4,
 (SELECT id FROM procedures WHERE nom = 'Permis de conduire renouvellement' LIMIT 1)),

-- Étape 5: Délivrance du nouveau permis
('Délivrance du nouveau permis', 'Retirer le nouveau permis de conduire après traitement du dossier et validation du paiement des frais.', 5,
 (SELECT id FROM procedures WHERE nom = 'Permis de conduire renouvellement' LIMIT 1));

-- ============================================
-- 3.407. DOCUMENTS REQUIS POUR RENOUVELLEMENT PERMIS
-- ============================================

INSERT INTO documents_requis (nom, description, obligatoire, procedure_id) VALUES
('Permis de conduire périmé', 'Le permis de conduire périmé en original à renouveler.', true,
 (SELECT id FROM procedures WHERE nom = 'Permis de conduire renouvellement' LIMIT 1)),

('Copie carte d''identité', 'Une copie de la carte d''identité ou de l''attestation d''identité (présenter l''original pour vérification).', true,
 (SELECT id FROM procedures WHERE nom = 'Permis de conduire renouvellement' LIMIT 1)),

('Certificat de résidence', 'Certificat de résidence attestant du domicile actuel du titulaire.', true,
 (SELECT id FROM procedures WHERE nom = 'Permis de conduire renouvellement' LIMIT 1)),

('Photos d''identité', 'Quatre photos d''identité récentes du titulaire selon les normes en vigueur.', true,
 (SELECT id FROM procedures WHERE nom = 'Permis de conduire renouvellement' LIMIT 1)),

('Déclaration de perte', 'Déclaration de perte du permis de conduire (pour un duplicata en cas de perte).', false,
 (SELECT id FROM procedures WHERE nom = 'Permis de conduire renouvellement' LIMIT 1)),

('Certificat médical', 'Certificat médical délivré par un médecin agréé de la commission médicale pour certaines catégories ou selon le cas.', false,
 (SELECT id FROM procedures WHERE nom = 'Permis de conduire renouvellement' LIMIT 1));

-- ============================================
-- 3.408. COÛTS DE LA PROCÉDURE RENOUVELLEMENT PERMIS
-- ============================================

INSERT INTO couts (nom, prix, description) VALUES
('Redevance renouvellement', 15000, 'Redevance de 15 000 FCFA pour le renouvellement du permis de conduire (depuis février 2025)'),
('Timbres fiscaux', 0, 'Timbres fiscaux pour le renouvellement - Montant variable selon les frais spécifiques'),
('Frais duplicata', 0, 'Frais spécifiques pour un duplicata en cas de perte - Variable selon la situation'),
('Frais permis biométrique', 0, 'Frais spécifiques pour le passage au format biométrique - Variable selon les nouvelles dispositions');

-- Association des coûts à la procédure
UPDATE procedures 
SET cout_id = (SELECT id FROM couts WHERE nom = 'Redevance renouvellement' LIMIT 1)
WHERE nom = 'Permis de conduire renouvellement';

-- ============================================
-- 3.409. ASSOCIATION DU CENTRE POUR RENOUVELLEMENT PERMIS
-- ============================================

-- Association du centre à la procédure
UPDATE procedures 
SET centre_id = (SELECT id FROM centres WHERE nom = 'Direction Régionale des Transports' LIMIT 1)
WHERE nom = 'Permis de conduire renouvellement';

-- ============================================
-- 3.410. ARTICLES DE LOI POUR RENOUVELLEMENT PERMIS
-- ============================================

INSERT INTO lois_articles (description, consulter_article, procedure_id) VALUES
-- Code de la route malien
('Code de la route malien', 
 'Le Code de la route malien régit les procédures de renouvellement du permis de conduire, définissant les conditions et modalités de renouvellement selon la législation malienne sur les transports.',
 (SELECT id FROM procedures WHERE nom = 'Permis de conduire renouvellement' LIMIT 1)),

-- Décret N°99-134/PRM du 26 mai 1999
('Décret N°99-134/PRM du 26 mai 1999', 
 'Le Décret N°99-134/PRM du 26 mai 1999 détaille les procédures de renouvellement du permis de conduire et les décrets associés, notamment concernant les documents requis et les conditions de renouvellement.',
 (SELECT id FROM procedures WHERE nom = 'Permis de conduire renouvellement' LIMIT 1)),

-- Redevance renouvellement
('Redevance renouvellement', 
 'Depuis février 2025, une redevance de 15 000 FCFA est exigée pour le renouvellement du permis de conduire en plus des timbres fiscaux, conformément aux nouvelles dispositions réglementaires.',
 (SELECT id FROM procedures WHERE nom = 'Permis de conduire renouvellement' LIMIT 1)),

-- Permis biométrique
('Permis biométrique', 
 'Des communications et circulaires du ministère de la Sécurité apportent des précisions sur la mise en place du permis biométrique et les procédures de renouvellement associées.',
 (SELECT id FROM procedures WHERE nom = 'Permis de conduire renouvellement' LIMIT 1));

-- ============================================
-- 3.411. PROCÉDURE: DÉCLARATION DE VOL
-- ============================================

-- Insertion de la procédure
INSERT INTO procedures (nom, titre, delai, description, categorie_id, sous_categorie_id, date_creation) VALUES
('Déclaration de vol', 'Déclarer un vol auprès des autorités', 'Immédiat après la découverte du vol', 
 'La déclaration de vol au Mali se fait auprès d''un commissariat de police ou d''une brigade de gendarmerie. Cette procédure permet d''enregistrer officiellement le vol dans un registre de main courante et d''obtenir une attestation de perte ou de vol nécessaire pour les démarches administratives ou d''assurance. La déclaration doit être faite le plus rapidement possible après la découverte du vol pour faciliter l''enquête. Pour les documents officiels comme un passeport, la déclaration peut également se faire auprès du préfet. Les procédures pénales concernant les vols sont régies par le Code de procédure pénale malien.',
 (SELECT id FROM categories WHERE titre = 'Justice' LIMIT 1),
 (SELECT id FROM sous_categories WHERE titre = 'Déclaration de vol' LIMIT 1),
 NOW());

-- ============================================
-- 3.412. ÉTAPES DE LA PROCÉDURE DÉCLARATION DE VOL
-- ============================================

INSERT INTO etapes (nom, description, niveau, procedure_id) VALUES
-- Étape 1: Se rendre aux autorités compétentes
('Se rendre aux autorités compétentes', 'Se rendre immédiatement au commissariat de police ou à la brigade de gendarmerie la plus proche pour déposer une plainte.', 1,
 (SELECT id FROM procedures WHERE nom = 'Déclaration de vol' LIMIT 1)),

-- Étape 2: Décrire les circonstances
('Décrire les circonstances', 'Expliquer en détail les circonstances du vol, y compris le lieu, l''heure, la description des biens volés et tout élément pouvant aider à l''enquête.', 2,
 (SELECT id FROM procedures WHERE nom = 'Déclaration de vol' LIMIT 1)),

-- Étape 3: Fournir les informations nécessaires
('Fournir les informations nécessaires', 'Fournir toutes les informations requises : numéro IMEI pour un téléphone portable, description détaillée des biens, preuves de propriété si disponibles, et pièce d''identité.', 3,
 (SELECT id FROM procedures WHERE nom = 'Déclaration de vol' LIMIT 1)),

-- Étape 4: Enregistrement de la déclaration
('Enregistrement de la déclaration', 'L''officier de police judiciaire enregistre la déclaration dans un procès-verbal et délivre un récépissé ou une attestation de perte/vol.', 4,
 (SELECT id FROM procedures WHERE nom = 'Déclaration de vol' LIMIT 1)),

-- Étape 5: Suivi de l'enquête
('Suivi de l''enquête', 'Le procès-verbal est transmis sans délai au procureur de la République pour le suivi de l''affaire. Conserver le récépissé pour les démarches administratives ou d''assurance.', 5,
 (SELECT id FROM procedures WHERE nom = 'Déclaration de vol' LIMIT 1));

-- ============================================
-- 3.413. DOCUMENTS REQUIS POUR DÉCLARATION DE VOL
-- ============================================

INSERT INTO documents_requis (nom, description, obligatoire, procedure_id) VALUES
('Pièce d''identité', 'Votre pièce d''identité (carte d''identité, passeport, etc.) pour établir votre identité.', true,
 (SELECT id FROM procedures WHERE nom = 'Déclaration de vol' LIMIT 1)),

('Description détaillée', 'Description détaillée de l''objet volé avec toutes les caractéristiques possibles.', true,
 (SELECT id FROM procedures WHERE nom = 'Déclaration de vol' LIMIT 1)),

('Numéro IMEI', 'Numéro IMEI du téléphone portable volé (trouvable sur la boîte d''origine ou en composant *#06#).', false,
 (SELECT id FROM procedures WHERE nom = 'Déclaration de vol' LIMIT 1)),

('Carte grise', 'Carte grise et informations d''identification du véhicule (numéro d''immatriculation, etc.) pour un vol de véhicule.', false,
 (SELECT id FROM procedures WHERE nom = 'Déclaration de vol' LIMIT 1)),

('Preuves de propriété', 'Factures d''achat ou autres preuves de propriété des biens volés si disponibles.', false,
 (SELECT id FROM procedures WHERE nom = 'Déclaration de vol' LIMIT 1));

-- ============================================
-- 3.414. COÛTS DE LA PROCÉDURE DÉCLARATION DE VOL
-- ============================================

INSERT INTO couts (nom, prix, description) VALUES
('Déclaration de vol', 0, 'La déclaration de vol elle-même est gratuite - Aucun frais à payer pour déposer plainte'),
('Frais duplicata documents', 0, 'Frais de dossier pour l''obtention d''un duplicata de documents administratifs (passeport, carte d''identité) - Variable selon le document'),
('Frais enquête', 0, 'Aucun frais pour l''enquête - Prise en charge par les services publics'),
('Frais attestation', 0, 'L''attestation de perte ou de vol est délivrée gratuitement');

-- Association des coûts à la procédure
UPDATE procedures 
SET cout_id = (SELECT id FROM couts WHERE nom = 'Déclaration de vol' LIMIT 1)
WHERE nom = 'Déclaration de vol';

-- ============================================
-- 3.415. ASSOCIATION DU CENTRE POUR DÉCLARATION DE VOL
-- ============================================

-- Association du centre à la procédure
UPDATE procedures 
SET centre_id = (SELECT id FROM centres WHERE nom = 'Commissariat de Police' LIMIT 1)
WHERE nom = 'Déclaration de vol';

-- ============================================
-- 3.416. ARTICLES DE LOI POUR DÉCLARATION DE VOL
-- ============================================

INSERT INTO lois_articles (description, consulter_article, procedure_id) VALUES
-- Code de procédure pénale
('Code de procédure pénale', 
 'Les procédures pénales au Mali concernant les vols sont régies par le Code de procédure pénale malien, qui définit les modalités de déclaration et de traitement des infractions.',
 (SELECT id FROM procedures WHERE nom = 'Déclaration de vol' LIMIT 1)),

-- Article 36 de la loi n°2001-080
('Article 36 de la loi n°2001-080 du 20 août 2001', 
 'L''article 36 de la loi n°2001-080 du 20 août 2001, portant Code de procédure pénale, stipule que les officiers de police judiciaire sont tenus d''informer sans délai le procureur de la République des infractions constatées.',
 (SELECT id FROM procedures WHERE nom = 'Déclaration de vol' LIMIT 1)),

-- Procédures d''enquête
('Procédures d''enquête', 
 'Les procès-verbaux de déclaration de vol sont transmis sans délai au procureur de la République pour le suivi de l''affaire et l''ouverture d''une enquête si nécessaire.',
 (SELECT id FROM procedures WHERE nom = 'Déclaration de vol' LIMIT 1)),

-- Attestation de perte/vol
('Attestation de perte/vol', 
 'L''attestation de perte ou de vol délivrée par les autorités compétentes est nécessaire pour les démarches administratives de demande de duplicata de documents officiels.',
 (SELECT id FROM procedures WHERE nom = 'Déclaration de vol' LIMIT 1));

-- ============================================
-- 3.417. PROCÉDURE: CRÉATION D'UNE SOCIÉTÉ EN NOM COLLECTIF (SNC)
-- ============================================

-- Insertion de la procédure
INSERT INTO procedures (nom, titre, delai, description, categorie_id, sous_categorie_id, date_creation) VALUES
('Création d''une Société en Nom Collectif (SNC)', 'Créer une SNC', '72 heures après validation du dossier', 
 'La Société en Nom Collectif (SNC) est une forme juridique d''entreprise réglementée par l''Acte uniforme OHADA relatif au droit des sociétés commerciales. Elle se caractérise par une forte confiance mutuelle entre des associés qui ont tous la qualité de commerçants et une responsabilité solidaire et indéfinie. Au moins deux associés sont requis, sans capital social minimum. Les associés sont responsables des dettes de manière indéfinie et solidaire. La création s''effectue au Guichet Unique de l''API-Mali qui centralise toutes les formalités administratives. Cette forme est particulièrement adaptée aux petites entreprises familiales où la confiance entre associés est forte.',
 (SELECT id FROM categories WHERE titre = 'Création d''entreprise' LIMIT 1),
 (SELECT id FROM sous_categories WHERE titre = 'Société en Nom Collectif (SNC)' LIMIT 1),
 NOW());

-- ============================================
-- 3.418. ÉTAPES DE LA PROCÉDURE CRÉATION SNC
-- ============================================

INSERT INTO etapes (nom, description, niveau, procedure_id) VALUES
-- Étape 1: Rédaction des statuts
('Rédaction des statuts', 'Rédiger les statuts de la SNC par écrit avec les mentions obligatoires : objet social, siège social, dénomination sociale, apports des associés. L''Acte uniforme OHADA autorise la création par acte sous seing privé (sans notaire), bien que le recours à un notaire soit possible.', 1,
 (SELECT id FROM procedures WHERE nom = 'Création d''une Société en Nom Collectif (SNC)' LIMIT 1)),

-- Étape 2: Dépôt du capital social
('Dépôt du capital social', 'Verser les apports des associés (numéraires et/ou en nature) conformément aux statuts. Bien qu''il n''y ait pas de capital social minimum requis, les fonds doivent être déposés dans une banque si un capital a été défini dans les statuts.', 2,
 (SELECT id FROM procedures WHERE nom = 'Création d''une Société en Nom Collectif (SNC)' LIMIT 1)),

-- Étape 3: Dépôt du dossier au Guichet unique
('Dépôt du dossier au Guichet unique', 'Déposer la demande d''immatriculation et le dossier complet auprès du Guichet unique de l''Agence pour la Promotion des Investissements au Mali (API-Mali). L''API-Mali centralise toutes les formalités administratives.', 3,
 (SELECT id FROM procedures WHERE nom = 'Création d''une Société en Nom Collectif (SNC)' LIMIT 1)),

-- Étape 4: Immatriculation au RCCM
('Immatriculation au RCCM', 'Après vérification des documents, l''API-Mali procède à l''immatriculation de la SNC au Registre du Commerce et du Crédit Mobilier (RCCM) et délivre un certificat d''immatriculation.', 4,
 (SELECT id FROM procedures WHERE nom = 'Création d''une Société en Nom Collectif (SNC)' LIMIT 1)),

-- Étape 5: Obtention des documents légaux
('Obtention des documents légaux', 'Recevoir les documents officiels : certificat d''immatriculation au RCCM, numéro d''identification fiscale (NIF), et organiser la publication d''un avis de constitution dans un journal d''annonces légales.', 5,
 (SELECT id FROM procedures WHERE nom = 'Création d''une Société en Nom Collectif (SNC)' LIMIT 1));

-- ============================================
-- 3.419. DOCUMENTS REQUIS POUR CRÉATION SNC
-- ============================================

INSERT INTO documents_requis (nom, description, obligatoire, procedure_id) VALUES
('Statuts de la société', 'Un exemplaire original des statuts de la SNC signés par tous les associés avec les mentions obligatoires : objet social, siège social, dénomination sociale.', true,
 (SELECT id FROM procedures WHERE nom = 'Création d''une Société en Nom Collectif (SNC)' LIMIT 1)),

('Pièce d''identité des associés', 'Une copie de la pièce d''identité ou du passeport de chaque associé de la SNC.', true,
 (SELECT id FROM procedures WHERE nom = 'Création d''une Société en Nom Collectif (SNC)' LIMIT 1)),

('Extrait de casier judiciaire', 'Un extrait de casier judiciaire datant de moins de 3 mois pour chaque associé (ou une déclaration sur l''honneur si le document n''est pas disponible).', true,
 (SELECT id FROM procedures WHERE nom = 'Création d''une Société en Nom Collectif (SNC)' LIMIT 1)),

('Extrait d''acte de naissance', 'Un extrait d''acte de naissance de chaque associé de la SNC.', true,
 (SELECT id FROM procedures WHERE nom = 'Création d''une Société en Nom Collectif (SNC)' LIMIT 1)),

('Certificat de nationalité', 'Un certificat de nationalité de chaque associé de la SNC.', true,
 (SELECT id FROM procedures WHERE nom = 'Création d''une Société en Nom Collectif (SNC)' LIMIT 1)),

('Déclaration de non-condamnation', 'Une déclaration sur l''honneur de non-condamnation de chaque associé de la SNC.', true,
 (SELECT id FROM procedures WHERE nom = 'Création d''une Société en Nom Collectif (SNC)' LIMIT 1)),

('Attestation de dépôt de capital', 'L''attestation de dépôt du capital social à la banque, si un capital minimum a été défini dans les statuts.', false,
 (SELECT id FROM procedures WHERE nom = 'Création d''une Société en Nom Collectif (SNC)' LIMIT 1)),

('Certificat de résidence', 'Un certificat de résidence pour chaque associé si nécessaire selon les exigences de l''API-Mali.', false,
 (SELECT id FROM procedures WHERE nom = 'Création d''une Société en Nom Collectif (SNC)' LIMIT 1));

-- ============================================
-- 3.420. COÛTS DE LA PROCÉDURE CRÉATION SNC
-- ============================================

INSERT INTO couts (nom, prix, description) VALUES
('Frais d''immatriculation RCCM', 40000, 'Frais d''immatriculation au RCCM : 30 000 à 50 000 FCFA selon l''activité - Moyenne 40 000 FCFA'),
('Frais de publication', 0, 'Coût de l''avis de publication dans le journal officiel ou un journal d''annonces légales - Variable selon le journal'),
('Frais de rédaction statuts', 0, 'Coûts de rédaction des statuts si un conseil externe est engagé - Variable selon le prestataire'),
('Frais administratifs', 0, 'Copies et autres dépenses administratives - Variable selon les besoins');

-- Association des coûts à la procédure
UPDATE procedures 
SET cout_id = (SELECT id FROM couts WHERE nom = 'Frais d''immatriculation RCCM' LIMIT 1)
WHERE nom = 'Création d''une Société en Nom Collectif (SNC)';

-- ============================================
-- 3.421. ASSOCIATION DU CENTRE POUR CRÉATION SNC
-- ============================================

-- Association du centre à la procédure
UPDATE procedures 
SET centre_id = (SELECT id FROM centres WHERE nom = 'Agence pour la Promotion des Investissements au Mali (API-Mali)' LIMIT 1)
WHERE nom = 'Création d''une Société en Nom Collectif (SNC)';

-- ============================================
-- 3.422. ARTICLES DE LOI POUR CRÉATION SNC
-- ============================================

INSERT INTO lois_articles (description, consulter_article, procedure_id) VALUES
-- Acte uniforme OHADA
('Acte uniforme OHADA', 
 'Le cadre juridique régissant la création et le fonctionnement des SNC au Mali est l''Acte uniforme de l''Organisation pour l''Harmonisation en Afrique du Droit des Affaires (OHADA) relatif au droit des sociétés commerciales et du groupement d''intérêt économique.',
 (SELECT id FROM procedures WHERE nom = 'Création d''une Société en Nom Collectif (SNC)' LIMIT 1)),

-- AUSCGIE
('Acte Uniforme révisé portant sur le Droit des Sociétés Commerciales et du Groupement d''Intérêt Économique (AUSCGIE)', 
 'Ce texte définit les caractéristiques de la SNC, notamment la responsabilité indéfinie et solidaire des associés, le caractère intuitu personae et les règles de gestion selon l''OHADA.',
 (SELECT id FROM procedures WHERE nom = 'Création d''une Société en Nom Collectif (SNC)' LIMIT 1)),

-- Caractéristiques SNC
('Caractéristiques de la SNC', 
 'La SNC se caractérise par : au moins deux associés ayant la qualité de commerçants, responsabilité solidaire et indéfinie, aucun capital social minimum, parts sociales non librement cessibles, et dénomination incluant le nom d''un ou plusieurs associés.',
 (SELECT id FROM procedures WHERE nom = 'Création d''une Société en Nom Collectif (SNC)' LIMIT 1)),

-- Procédures de création
('Procédures de création', 
 'Les procédures de création d''une SNC au Mali s''effectuent au Guichet Unique de l''API-Mali qui centralise les formalités administratives et délivre les documents officiels dans un délai de 72 heures.',
 (SELECT id FROM procedures WHERE nom = 'Création d''une Société en Nom Collectif (SNC)' LIMIT 1));

-- ============================================
-- 3.423. PROCÉDURE: ATTRIBUTION DES LOGEMENTS SOCIAUX
-- ============================================

-- Insertion de la procédure
INSERT INTO procedures (nom, titre, delai, description, categorie_id, sous_categorie_id, date_creation) VALUES
('Attribution des logements sociaux', 'Obtenir un logement social', 'Variable selon la disponibilité et l''examen des dossiers', 
 'L''attribution des logements sociaux au Mali est régie par la Décision N°2018-086/MHU-SG du 09 mai 2018 fixant les critères d''attribution des 12 566 logements sociaux réalisés dans diverses localités du Mali. Cette procédure concerne deux catégories de bénéficiaires : les salariés de la fonction publique, du secteur para-public et du secteur privé, et les personnes démunies. Les logements sont de type F3 Tôle et F3 Dalle, répartis dans les régions de Kayes, Koulikoro, Sikasso, Ségou, Mopti, Tombouctou et Gao. La procédure comprend le dépôt de dossier, l''examen par une commission d''attribution, et l''acquisition du logement selon les modalités fixées par l''Office Malien de l''Habitat (OMH).',
 (SELECT id FROM categories WHERE titre = 'Service fonciers' LIMIT 1),
 (SELECT id FROM sous_categories WHERE titre = 'Attribution des logements sociaux' LIMIT 1),
 NOW());

-- ============================================
-- 3.424. ÉTAPES DE LA PROCÉDURE LOGEMENTS SOCIAUX
-- ============================================

INSERT INTO etapes (nom, description, niveau, procedure_id) VALUES
-- Étape 1: Vérification des critères d'éligibilité
('Vérification des critères d''éligibilité', 'Vérifier que le demandeur répond aux critères d''éligibilité : nationalité malienne, salaire entre 80 000 et 180 000 FCFA pour les salariés, ou inscription au répertoire des personnes démunies, non-bénéficiaire d''un logement subventionné, non-propriétaire dans la localité du projet.', 1,
 (SELECT id FROM procedures WHERE nom = 'Attribution des logements sociaux' LIMIT 1)),

-- Étape 2: Constitution du dossier
('Constitution du dossier', 'Rassembler tous les documents requis selon la situation familiale (marié, divorcé, veuf, célibataire) : demande timbrée, attestations, bulletins de salaire, actes d''état civil, certificats, déclarations sur l''honneur, et attestation bancaire pour l''apport personnel.', 2,
 (SELECT id FROM procedures WHERE nom = 'Attribution des logements sociaux' LIMIT 1)),

-- Étape 3: Paiement des frais de dossier
('Paiement des frais de dossier', 'Effectuer le paiement de 5 000 FCFA à l''Office Malien de l''Habitat (OMH) contre quittance du trésor ou dans une des banques retenues (BMS, BDM, BNDA) contre reçu de paiement. Ces frais ne sont pas remboursables.', 3,
 (SELECT id FROM procedures WHERE nom = 'Attribution des logements sociaux' LIMIT 1)),

-- Étape 4: Dépôt du dossier
('Dépôt du dossier', 'Déposer le dossier complet sous pli fermé contre récépissé au lieu indiqué par le représentant de l''Etat au niveau de la localité concernée, dans les délais fixés (généralement du 10 mai au 11 juin, 25 juin pour les Maliens de l''extérieur).', 4,
 (SELECT id FROM procedures WHERE nom = 'Attribution des logements sociaux' LIMIT 1)),

-- Étape 5: Examen et attribution
('Examen et attribution', 'La Commission d''attribution examine les dossiers reçus, fixe des sous-critères supplémentaires, et établit la liste des bénéficiaires. Les intéressés sont invités pour les formalités d''acquisition des logements.', 5,
 (SELECT id FROM procedures WHERE nom = 'Attribution des logements sociaux' LIMIT 1));

-- ============================================
-- 3.425. DOCUMENTS REQUIS POUR LOGEMENTS SOCIAUX
-- ============================================

INSERT INTO documents_requis (nom, description, obligatoire, procedure_id) VALUES
('Demande timbrée', 'Demande timbrée à 500 FCFA adressée au Président de la Commission d''attribution, précisant le site et le type du logement sollicité.', true,
 (SELECT id FROM procedures WHERE nom = 'Attribution des logements sociaux' LIMIT 1)),

('Attestation de domiciliation bancaire', 'Attestation de domiciliation bancaire dans une des banques retenues (BMS, BDM, BNDA) pour les salariés.', true,
 (SELECT id FROM procedures WHERE nom = 'Attribution des logements sociaux' LIMIT 1)),

('Bulletins de salaire', 'Trois derniers bulletins de salaire pour les salariés de la fonction publique, para-public et privé.', true,
 (SELECT id FROM procedures WHERE nom = 'Attribution des logements sociaux' LIMIT 1)),

('Extrait d''acte de naissance', 'Extrait d''acte de naissance du demandeur.', true,
 (SELECT id FROM procedures WHERE nom = 'Attribution des logements sociaux' LIMIT 1)),

('Pièce d''identité', 'Photocopie de la pièce d''identité en cours de validité ou de la carte NINA.', true,
 (SELECT id FROM procedures WHERE nom = 'Attribution des logements sociaux' LIMIT 1)),

('Certificat de nationalité', 'Certificat de nationalité malienne du demandeur.', true,
 (SELECT id FROM procedures WHERE nom = 'Attribution des logements sociaux' LIMIT 1)),

('Certificat de résidence', 'Certificat de résidence du demandeur.', true,
 (SELECT id FROM procedures WHERE nom = 'Attribution des logements sociaux' LIMIT 1)),

('Déclaration sur l''honneur', 'Déclaration sur l''honneur selon le modèle défini par l''OMH.', true,
 (SELECT id FROM procedures WHERE nom = 'Attribution des logements sociaux' LIMIT 1)),

('Attestation bancaire apport personnel', 'Attestation bancaire justifiant le paiement de l''apport personnel de 150 000 FCFA pour les salariés.', false,
 (SELECT id FROM procedures WHERE nom = 'Attribution des logements sociaux' LIMIT 1)),

('Attestation inscription personnes démunies', 'Attestation d''inscription au répertoire des personnes démunies délivrée par le Ministre en charge du développement social pour les personnes démunies.', false,
 (SELECT id FROM procedures WHERE nom = 'Attribution des logements sociaux' LIMIT 1));

-- ============================================
-- 3.426. COÛTS DE LA PROCÉDURE LOGEMENTS SOCIAUX
-- ============================================

INSERT INTO couts (nom, prix, description) VALUES
('Frais de constitution dossier', 5000, 'Frais de constitution des dossiers payables à l''OMH contre quittance du trésor ou dans une banque retenue - Non remboursables'),
('Apport personnel', 150000, 'Apport personnel d''un montant équivalent à 150 000 FCFA pour les salariés de la fonction publique, para-public et privé'),
('Frais d''acte notarié', 0, 'Frais d''acte notarié à payer par les bénéficiaires lors de l''acquisition - Variable selon le notaire'),
('Frais police abonnement', 0, 'Frais de police d''abonnement en eau et en électricité à payer par les bénéficiaires - Variable selon les services');

-- Association des coûts à la procédure
UPDATE procedures 
SET cout_id = (SELECT id FROM couts WHERE nom = 'Frais de constitution dossier' LIMIT 1)
WHERE nom = 'Attribution des logements sociaux';

-- ============================================
-- 3.427. ASSOCIATION DU CENTRE POUR LOGEMENTS SOCIAUX
-- ============================================

-- Association du centre à la procédure
UPDATE procedures 
SET centre_id = (SELECT id FROM centres WHERE nom = 'Office Malien de l''Habitat (OMH)' LIMIT 1)
WHERE nom = 'Attribution des logements sociaux';

-- ============================================
-- 3.428. ARTICLES DE LOI POUR LOGEMENTS SOCIAUX
-- ============================================

INSERT INTO lois_articles (description, consulter_article, procedure_id) VALUES
-- Décision N°2018-086/MHU-SG
('Décision N°2018-086/MHU-SG du 09 mai 2018', 
 'La Décision N°2018-086/MHU-SG du 09 mai 2018 fixe les critères d''attribution des 12 566 logements sociaux réalisés dans diverses localités du Mali, définissant les conditions d''éligibilité et les modalités d''attribution.',
 (SELECT id FROM procedures WHERE nom = 'Attribution des logements sociaux' LIMIT 1)),

-- Décret n°2015-0351/P-RM
('Décret n°2015-0351/P-RM du 08 mai 2015', 
 'Le Décret n°2015-0351/P-RM du 08 mai 2015 fixe les modalités d''attribution et de gestion des logements sociaux, constituant le cadre réglementaire principal pour l''attribution des logements sociaux au Mali.',
 (SELECT id FROM procedures WHERE nom = 'Attribution des logements sociaux' LIMIT 1)),

-- Critères d''éligibilité
('Critères d''éligibilité', 
 'Les critères d''éligibilité comprennent : nationalité malienne, salaire entre 80 000 et 180 000 FCFA pour les salariés, apport personnel de 150 000 FCFA, non-bénéficiaire d''un logement subventionné, et domiciliation bancaire dans une banque retenue.',
 (SELECT id FROM procedures WHERE nom = 'Attribution des logements sociaux' LIMIT 1)),

-- Modalités d''acquisition
('Modalités d''acquisition', 
 'Les bénéficiaires s''engagent par acte notarié qu''au bout de trois mensualités impayées ou en cas de fausse déclaration, ils se soumettent à la clause résolutoire et à l''expulsion sans remboursement des échéances payées.',
 (SELECT id FROM procedures WHERE nom = 'Attribution des logements sociaux' LIMIT 1));

-- ============================================
-- 3.429. PROCÉDURE: DEMANDE DE BAIL
-- ============================================

-- Insertion de la procédure
INSERT INTO procedures (nom, titre, delai, description, categorie_id, sous_categorie_id, date_creation) VALUES
('Demande de bail', 'Obtenir un bail de location', 'Variable selon la diligence des parties et l''obtention des documents', 
 'La demande de bail au Mali consiste à adresser une lettre au propriétaire ou à l''agence immobilière et constituer un dossier contenant les pièces justificatives demandées. Le bail est un contrat de location écrit qui peut être sous seing privé (entre les parties) ou rédigé par un professionnel. La procédure comprend la rédaction du contrat de bail, l''enregistrement auprès des services fiscaux pour lui donner une valeur légale, et la réalisation d''un état des lieux. Cette procédure est régie par le décret n°146 du 17 mai 1967 sur la réglementation des loyers et l''Acte uniforme OHADA relatif au droit commercial général pour les baux commerciaux.',
 (SELECT id FROM categories WHERE titre = 'Service fonciers' LIMIT 1),
 (SELECT id FROM sous_categories WHERE titre = 'Demande de bail' LIMIT 1),
 NOW());

-- ============================================
-- 3.430. ÉTAPES DE LA PROCÉDURE DEMANDE DE BAIL
-- ============================================

INSERT INTO etapes (nom, description, niveau, procedure_id) VALUES
-- Étape 1: Rédaction de la demande
('Rédaction de la demande', 'Rédiger une lettre de demande de bail adressée au propriétaire ou à l''agence immobilière, précisant l''adresse du logement, la profession du demandeur, les revenus stables, et l''intention d''en faire sa résidence principale.', 1,
 (SELECT id FROM procedures WHERE nom = 'Demande de bail' LIMIT 1)),

-- Étape 2: Constitution du dossier
('Constitution du dossier', 'Rassembler tous les documents justificatifs : pièce d''identité, justificatif de domicile actuel, justificatifs de revenus (bulletins de salaire, avis d''imposition, attestation d''employeur) pour prouver la solvabilité du locataire.', 2,
 (SELECT id FROM procedures WHERE nom = 'Demande de bail' LIMIT 1)),

-- Étape 3: Rédaction du contrat de bail
('Rédaction du contrat de bail', 'Le propriétaire et le locataire rédigent et signent le contrat de bail. Cet accord peut être sous seing privé (entre les parties) ou devant notaire pour une force probante renforcée. Le contrat doit spécifier les coordonnées des parties, les détails du bien, la durée, le loyer, le dépôt de garantie et les conditions de renouvellement.', 3,
 (SELECT id FROM procedures WHERE nom = 'Demande de bail' LIMIT 1)),

-- Étape 4: Enregistrement du bail
('Enregistrement du bail', 'Enregistrer le contrat de bail auprès des services fiscaux (centre des impôts) pour lui donner une valeur légale et le rendre opposable aux tiers. Cette étape est essentielle pour la validité du contrat.', 4,
 (SELECT id FROM procedures WHERE nom = 'Demande de bail' LIMIT 1)),

-- Étape 5: État des lieux
('État des lieux', 'Réaliser un état des lieux d''entrée lors de la remise des clés pour constater l''état du logement. Un état des lieux de sortie sera réalisé en fin de bail pour déterminer d''éventuelles réparations locatives.', 5,
 (SELECT id FROM procedures WHERE nom = 'Demande de bail' LIMIT 1));

-- ============================================
-- 3.431. DOCUMENTS REQUIS POUR DEMANDE DE BAIL
-- ============================================

INSERT INTO documents_requis (nom, description, obligatoire, procedure_id) VALUES
('Lettre de demande de bail', 'Lettre de demande de bail adressée au propriétaire ou à l''agence immobilière, précisant l''adresse du logement et les motivations du demandeur.', true,
 (SELECT id FROM procedures WHERE nom = 'Demande de bail' LIMIT 1)),

('Pièce d''identité', 'Pièce d''identité valide du locataire (carte d''identité nationale, passeport).', true,
 (SELECT id FROM procedures WHERE nom = 'Demande de bail' LIMIT 1)),

('Justificatif de domicile', 'Justificatif de domicile actuel : dernière quittance de loyer ou facture d''eau/électricité de moins de 3 mois.', true,
 (SELECT id FROM procedures WHERE nom = 'Demande de bail' LIMIT 1)),

('Justificatifs de revenus', 'Justificatifs de revenus pour prouver la solvabilité : bulletins de salaire, avis d''imposition, attestation d''employeur.', true,
 (SELECT id FROM procedures WHERE nom = 'Demande de bail' LIMIT 1)),

('Contrat de bail', 'Contrat de bail rédigé et signé par le propriétaire et le locataire, spécifiant toutes les conditions de location.', true,
 (SELECT id FROM procedures WHERE nom = 'Demande de bail' LIMIT 1)),

('Titre de propriété', 'Titre de propriété ou document attestant que le propriétaire est propriétaire du bien (pour le propriétaire).', true,
 (SELECT id FROM procedures WHERE nom = 'Demande de bail' LIMIT 1)),

('Dossier diagnostic technique', 'Dossier de diagnostic technique selon le type de bail (pour le propriétaire).', false,
 (SELECT id FROM procedures WHERE nom = 'Demande de bail' LIMIT 1)),

('État des lieux', 'État des lieux d''entrée documenté lors de la remise des clés pour constater l''état du logement.', false,
 (SELECT id FROM procedures WHERE nom = 'Demande de bail' LIMIT 1));

-- ============================================
-- 3.432. COÛTS DE LA PROCÉDURE DEMANDE DE BAIL
-- ============================================

INSERT INTO couts (nom, prix, description) VALUES
('Frais d''enregistrement', 0, 'Frais d''enregistrement du bail auprès du centre des impôts - Variable selon le loyer et la durée du bail'),
('Frais d''agence', 0, 'Frais de commission d''agence immobilière si vous passez par une agence - Variable selon l''agence'),
('Frais de notaire', 0, 'Frais de rédaction si le bail est signé chez un notaire - Variable selon le notaire'),
('Dépôt de garantie', 0, 'Dépôt de garantie généralement équivalent à un ou deux mois de loyer - Variable selon le propriétaire');

-- Association des coûts à la procédure
UPDATE procedures 
SET cout_id = (SELECT id FROM couts WHERE nom = 'Frais d''enregistrement' LIMIT 1)
WHERE nom = 'Demande de bail';

-- ============================================
-- 3.433. ASSOCIATION DU CENTRE POUR DEMANDE DE BAIL
-- ============================================

-- Association du centre à la procédure
UPDATE procedures 
SET centre_id = (SELECT id FROM centres WHERE nom = 'Centre des Impôts' LIMIT 1)
WHERE nom = 'Demande de bail';

-- ============================================
-- 3.434. ARTICLES DE LOI POUR DEMANDE DE BAIL
-- ============================================

INSERT INTO lois_articles (description, consulter_article, procedure_id) VALUES
-- Décret n°146 du 17 mai 1967
('Décret n°146 du 17 mai 1967', 
 'Le décret n°146 du 17 mai 1967 régit la réglementation des loyers des locaux d''habitation au Mali, définissant les modalités et conditions de location des biens immobiliers.',
 (SELECT id FROM procedures WHERE nom = 'Demande de bail' LIMIT 1)),

-- Acte uniforme OHADA
('Acte uniforme OHADA relatif au droit commercial général (AUDCG)', 
 'L''Acte uniforme OHADA relatif au droit commercial général contient des dispositions relatives aux baux commerciaux, applicable au Mali en tant que membre de l''OHADA.',
 (SELECT id FROM procedures WHERE nom = 'Demande de bail' LIMIT 1)),

-- Contrat de bail
('Contrat de bail', 
 'Le bail est un contrat de location écrit qui peut être sous seing privé (entre les parties) ou rédigé par un professionnel. Il doit spécifier les coordonnées des parties, les détails du bien, la durée, le loyer et les conditions de renouvellement.',
 (SELECT id FROM procedures WHERE nom = 'Demande de bail' LIMIT 1)),

-- Enregistrement du bail
('Enregistrement du bail', 
 'L''enregistrement du contrat de bail auprès des services fiscaux (centre des impôts) est essentiel pour lui donner une valeur légale et le rendre opposable aux tiers. Le délai d''enregistrement varie selon la législation en vigueur.',
 (SELECT id FROM procedures WHERE nom = 'Demande de bail' LIMIT 1));

-- ============================================
-- 3.435. PROCÉDURE: CARTE NATIONALE D'IDENTITÉ BIOMÉTRIQUE SÉCURISÉE (CNIBS)
-- ============================================

-- Insertion de la procédure
INSERT INTO procedures (nom, titre, delai, description, categorie_id, sous_categorie_id, date_creation) VALUES
('Carte nationale d''identité biométrique sécurisée (CNIBS)', 'Obtenir une carte d''identité biométrique', 'Variable selon le service choisi (48h pour service premium)', 
 'La Carte nationale d''identité biométrique sécurisée (CNIBS) au Mali remplace l''ancienne carte NINA et la carte d''identité nationale. Cette procédure comprend l''enrôlement et la collecte des données biométriques (empreintes digitales, photo), la préparation des documents requis, le paiement des frais, et le retrait de la carte. La CNIBS est produite à partir du fichier du Numéro d''Identification Nationale (NINA) et a une validité de cinq ans. Le retrait s''effectue via la reconnaissance faciale et les empreintes digitales. Cette procédure est régie par le Décret n°2022-0639/PT-RM du 03 novembre 2022 et l''arrêté interministériel de juin 2024.',
 (SELECT id FROM categories WHERE titre = 'Identité et citoyenneté' LIMIT 1),
 (SELECT id FROM sous_categories WHERE titre = 'Carte nationale d''identité biométrique sécurisée (CNIBS)' LIMIT 1),
 NOW());

-- ============================================
-- 3.436. ÉTAPES DE LA PROCÉDURE CNIBS
-- ============================================

INSERT INTO etapes (nom, description, niveau, procedure_id) VALUES
-- Étape 1: Préparation des documents
('Préparation des documents', 'Réunir les pièces nécessaires : Numéro d''Identification Nationale (NINA) et carte ou fiche NINA existante, 3 photos d''identité, carte d''identité périmée, extrait d''acte de naissance ou de mariage, et deux témoins munis de leurs pièces d''identité valides.', 1,
 (SELECT id FROM procedures WHERE nom = 'Carte nationale d''identité biométrique sécurisée (CNIBS)' LIMIT 1)),

-- Étape 2: Enrôlement et collecte des données
('Enrôlement et collecte des données', 'Se présenter dans un centre agréé (commissariat de police, brigade de gendarmerie, sous-préfecture) pour l''enrôlement et la collecte des données biométriques : empreintes digitales et photo d''identité.', 2,
 (SELECT id FROM procedures WHERE nom = 'Carte nationale d''identité biométrique sécurisée (CNIBS)' LIMIT 1)),

-- Étape 3: Paiement des frais
('Paiement des frais', 'Effectuer le paiement des frais selon le service choisi : 5 000 FCFA pour les demandes à l''intérieur du pays, 8 000 FCFA pour les Maliens de l''extérieur, ou 11 000 FCFA pour le service premium (48h). Le paiement peut se faire par versement bancaire, carte bancaire ou mobile money.', 3,
 (SELECT id FROM procedures WHERE nom = 'Carte nationale d''identité biométrique sécurisée (CNIBS)' LIMIT 1)),

-- Étape 4: Production de la carte
('Production de la carte', 'La carte est produite à partir du fichier du Numéro d''Identification Nationale (NINA) par les services compétents. Le demandeur peut vérifier la disponibilité de sa carte en envoyant son numéro NINA au 36223.', 4,
 (SELECT id FROM procedures WHERE nom = 'Carte nationale d''identité biométrique sécurisée (CNIBS)' LIMIT 1)),

-- Étape 5: Retrait de la carte
('Retrait de la carte', 'Retirer la carte biométrique dans les centres de distribution (mairies, centres d''état civil, commissariats, gendarmeries) via la reconnaissance faciale et les empreintes digitales. La carte a une validité de cinq ans.', 5,
 (SELECT id FROM procedures WHERE nom = 'Carte nationale d''identité biométrique sécurisée (CNIBS)' LIMIT 1));

-- ============================================
-- 3.437. DOCUMENTS REQUIS POUR CNIBS
-- ============================================

INSERT INTO documents_requis (nom, description, obligatoire, procedure_id) VALUES
('Numéro NINA', 'Le Numéro d''Identification Nationale (NINA) et la carte ou fiche NINA existante du demandeur.', true,
 (SELECT id FROM procedures WHERE nom = 'Carte nationale d''identité biométrique sécurisée (CNIBS)' LIMIT 1)),

('Photos d''identité', 'Trois photos d''identité récentes du demandeur selon les normes en vigueur.', true,
 (SELECT id FROM procedures WHERE nom = 'Carte nationale d''identité biométrique sécurisée (CNIBS)' LIMIT 1)),

('Carte d''identité périmée', 'La carte d''identité périmée du demandeur si disponible.', true,
 (SELECT id FROM procedures WHERE nom = 'Carte nationale d''identité biométrique sécurisée (CNIBS)' LIMIT 1)),

('Extrait d''acte de naissance', 'Un extrait d''acte de naissance du demandeur ou un acte de mariage selon le cas.', true,
 (SELECT id FROM procedures WHERE nom = 'Carte nationale d''identité biométrique sécurisée (CNIBS)' LIMIT 1)),

('Témoins', 'Deux témoins connus du quartier, munis de leurs propres pièces d''identité valides pour attester de l''identité du demandeur.', true,
 (SELECT id FROM procedures WHERE nom = 'Carte nationale d''identité biométrique sécurisée (CNIBS)' LIMIT 1)),

('Timbres fiscaux', 'Timbres fiscaux d''une valeur totale de 700 FCFA (500 + 200) pour les frais administratifs.', true,
 (SELECT id FROM procedures WHERE nom = 'Carte nationale d''identité biométrique sécurisée (CNIBS)' LIMIT 1)),

('Fiche Descriptive Individuelle', 'Copie de la Fiche Descriptive Individuelle ou de la carte NINA pour ceux ne possédant pas de carte NINA biométrique.', false,
 (SELECT id FROM procedures WHERE nom = 'Carte nationale d''identité biométrique sécurisée (CNIBS)' LIMIT 1)),

('Carnet de famille', 'Carnet de famille du demandeur si disponible comme preuve d''identité supplémentaire.', false,
 (SELECT id FROM procedures WHERE nom = 'Carte nationale d''identité biométrique sécurisée (CNIBS)' LIMIT 1));

-- ============================================
-- 3.438. COÛTS DE LA PROCÉDURE CNIBS
-- ============================================

INSERT INTO couts (nom, prix, description) VALUES
('Coût standard', 5000, 'Coût standard de 5 000 FCFA pour les demandes à l''intérieur du pays selon l''arrêté interministériel de juin 2024'),
('Coût Maliens de l''extérieur', 8000, 'Coût de 8 000 FCFA pour les Maliens de l''extérieur dans les missions diplomatiques et consulaires'),
('Service premium', 11000, 'Service premium de 11 000 FCFA pour une obtention rapide sous 48 heures'),
('Timbres fiscaux', 700, 'Timbres fiscaux d''une valeur totale de 700 FCFA (500 + 200) pour les frais administratifs');

-- Association des coûts à la procédure
UPDATE procedures 
SET cout_id = (SELECT id FROM couts WHERE nom = 'Coût standard' LIMIT 1)
WHERE nom = 'Carte nationale d''identité biométrique sécurisée (CNIBS)';

-- ============================================
-- 3.439. ASSOCIATION DU CENTRE POUR CNIBS
-- ============================================

-- Association du centre à la procédure
UPDATE procedures 
SET centre_id = (SELECT id FROM centres WHERE nom = 'Commissariat de Police' LIMIT 1)
WHERE nom = 'Carte nationale d''identité biométrique sécurisée (CNIBS)';

-- ============================================
-- 3.440. ARTICLES DE LOI POUR CNIBS
-- ============================================

INSERT INTO lois_articles (description, consulter_article, procedure_id) VALUES
-- Décret n°2022-0639/PT-RM
('Décret n°2022-0639/PT-RM du 03 novembre 2022', 
 'Le Décret n°2022-0639/PT-RM du 03 novembre 2022 institue et réglemente la Carte nationale d''identité biométrique sécurisée (CNIBS) au Mali. Il abroge et remplace la carte NINA, la carte d''identité nationale et la carte consulaire.',
 (SELECT id FROM procedures WHERE nom = 'Carte nationale d''identité biométrique sécurisée (CNIBS)' LIMIT 1)),

-- Arrêté interministériel juin 2024
('Arrêté interministériel de juin 2024', 
 'L''arrêté interministériel de juin 2024 fixe les détails d''application du décret, notamment les frais de délivrance : 5 000 FCFA pour les demandes à l''intérieur du pays, 8 000 FCFA pour les Maliens de l''extérieur, et 11 000 FCFA pour le service premium.',
 (SELECT id FROM procedures WHERE nom = 'Carte nationale d''identité biométrique sécurisée (CNIBS)' LIMIT 1)),

-- Caractéristiques de la CNIBS
('Caractéristiques de la CNIBS', 
 'La CNIBS est produite à partir du fichier du Numéro d''Identification Nationale (NINA), a une validité de cinq ans, et le retrait s''effectue via la reconnaissance faciale et les empreintes digitales pour garantir la sécurité.',
 (SELECT id FROM procedures WHERE nom = 'Carte nationale d''identité biométrique sécurisée (CNIBS)' LIMIT 1)),

-- Centres de traitement
('Centres de traitement et distribution', 
 'Les enrôlements se font dans les commissariats de police, brigades de gendarmerie, et sous-préfectures. Le retrait s''effectue dans les mairies, centres d''état civil, commissariats, et gendarmeries. Des équipes mobiles sont déployées dans certaines zones.',
 (SELECT id FROM procedures WHERE nom = 'Carte nationale d''identité biométrique sécurisée (CNIBS)' LIMIT 1));

-- ============================================
-- 3.441. PROCÉDURE: FICHE DESCRIPTIVE INDIVIDUELLE (FDI) NINA
-- ============================================

-- Insertion de la procédure
INSERT INTO procedures (nom, titre, delai, description, categorie_id, sous_categorie_id, date_creation) VALUES
('Fiche Descriptive Individuelle (FDI) NINA', 'Obtenir sa fiche individuelle NINA', 'Variable selon la méthode de demande', 
 'La Fiche Descriptive Individuelle (FDI) NINA au Mali est un document officiel qui peut être obtenu via une plateforme de télé-demande dématérialisée. Cette procédure comprend l''enrôlement au Recensement Administratif à Vocation d''État Civil (RAVEC) pour obtenir un numéro NINA, puis la demande de la fiche individuelle via la plateforme www.citede.ml ou par email à fidi@ctdec.ml. Le processus est largement dématérialisé et gratuit. Pour les Maliens résidant à l''étranger, les consulats proposent également des formulaires de demande. Cette procédure est régie par la Loi n°06-040 du 11 août 2006 instituant le Numéro d''Identification Nationale (NINA) au Mali.',
 (SELECT id FROM categories WHERE titre = 'Identité et citoyenneté' LIMIT 1),
 (SELECT id FROM sous_categories WHERE titre = 'Fiche Descriptive Individuelle (FDI) NINA' LIMIT 1),
 NOW());

-- ============================================
-- 3.442. ÉTAPES DE LA PROCÉDURE FDI NINA
-- ============================================

INSERT INTO etapes (nom, description, niveau, procedure_id) VALUES
-- Étape 1: Enrôlement RAVEC
('Enrôlement RAVEC', 'Effectuer l''enrôlement dans le Recensement Administratif à Vocation d''État Civil (RAVEC) dans un centre dédié pour obtenir un numéro NINA. Cette étape est nécessaire si vous n''êtes pas encore enrôlé.', 1,
 (SELECT id FROM procedures WHERE nom = 'Fiche Descriptive Individuelle (FDI) NINA' LIMIT 1)),

-- Étape 2: Demande en ligne
('Demande en ligne', 'Utiliser la plateforme de télé-demande du gouvernement accessible via www.citede.ml pour demander la fiche individuelle ou corriger des informations erronées. Cette plateforme vise à faciliter l''accès au document, y compris pour les Maliens résidant à l''étranger.', 2,
 (SELECT id FROM procedures WHERE nom = 'Fiche Descriptive Individuelle (FDI) NINA' LIMIT 1)),

-- Étape 3: Demande par email
('Demande par email', 'Envoyer le numéro de récépissé par email à fidi@ctdec.ml pour obtenir la fiche individuelle. Cette méthode alternative permet d''obtenir le document sans se déplacer.', 3,
 (SELECT id FROM procedures WHERE nom = 'Fiche Descriptive Individuelle (FDI) NINA' LIMIT 1)),

-- Étape 4: Confirmation par SMS
('Confirmation par SMS', 'Envoyer le numéro NINA par SMS au 36223 pour savoir si la carte biométrique NINA ou la fiche individuelle est disponible. Ce service permet de vérifier l''état d''avancement de la demande.', 4,
 (SELECT id FROM procedures WHERE nom = 'Fiche Descriptive Individuelle (FDI) NINA' LIMIT 1)),

-- Étape 5: Obtention du document
('Obtention du document', 'Recevoir la Fiche Descriptive Individuelle (FDI) NINA via les canaux choisis (plateforme en ligne, email, ou consulat pour les Maliens à l''étranger). Le document est généralement délivré gratuitement.', 5,
 (SELECT id FROM procedures WHERE nom = 'Fiche Descriptive Individuelle (FDI) NINA' LIMIT 1));

-- ============================================
-- 3.443. DOCUMENTS REQUIS POUR FDI NINA
-- ============================================

INSERT INTO documents_requis (nom, description, obligatoire, procedure_id) VALUES
('Acte de naissance', 'Un original de l''acte de naissance (Volet 3) ou un extrait d''acte de naissance pour l''enrôlement initial au RAVEC.', true,
 (SELECT id FROM procedures WHERE nom = 'Fiche Descriptive Individuelle (FDI) NINA' LIMIT 1)),

('Numéro NINA', 'Le numéro NINA obtenu lors de l''enrôlement au Recensement Administratif à Vocation d''État Civil (RAVEC).', true,
 (SELECT id FROM procedures WHERE nom = 'Fiche Descriptive Individuelle (FDI) NINA' LIMIT 1)),

('Numéro de récépissé', 'Le numéro de récépissé de l''enrôlement RAVEC pour les demandes par email à fidi@ctdec.ml.', true,
 (SELECT id FROM procedures WHERE nom = 'Fiche Descriptive Individuelle (FDI) NINA' LIMIT 1)),

('Jugement supplétif', 'Un jugement supplétif avec le visa et le cachet de la mairie si nécessaire pour l''enrôlement initial.', false,
 (SELECT id FROM procedures WHERE nom = 'Fiche Descriptive Individuelle (FDI) NINA' LIMIT 1)),

('Pièce d''identité', 'Une carte d''identité ou un passeport valide peut être demandé dans certains cas, bien que les services en ligne simplifient la procédure.', false,
 (SELECT id FROM procedures WHERE nom = 'Fiche Descriptive Individuelle (FDI) NINA' LIMIT 1));

-- ============================================
-- 3.444. COÛTS DE LA PROCÉDURE FDI NINA
-- ============================================

INSERT INTO couts (nom, prix, description) VALUES
('Fiche Descriptive Individuelle', 0, 'L''obtention de la Fiche Descriptive Individuelle (FDI) NINA est gratuite via les canaux officiels comme la plateforme de télé-demande'),
('Enrôlement RAVEC', 0, 'L''enrôlement au Recensement Administratif à Vocation d''État Civil (RAVEC) est gratuit pour obtenir le numéro NINA'),
('Demande en ligne', 0, 'L''utilisation de la plateforme www.citede.ml est gratuite pour les demandes de fiche individuelle'),
('Demande par email', 0, 'L''envoi d''email à fidi@ctdec.ml est gratuit pour obtenir la fiche individuelle');

-- Association des coûts à la procédure
UPDATE procedures 
SET cout_id = (SELECT id FROM couts WHERE nom = 'Fiche Descriptive Individuelle' LIMIT 1)
WHERE nom = 'Fiche Descriptive Individuelle (FDI) NINA';

-- ============================================
-- 3.445. ASSOCIATION DU CENTRE POUR FDI NINA
-- ============================================

-- Association du centre à la procédure
UPDATE procedures 
SET centre_id = (SELECT id FROM centres WHERE nom = 'Centre de Traitement des Données d''État Civil (CTDEC)' LIMIT 1)
WHERE nom = 'Fiche Descriptive Individuelle (FDI) NINA';

-- ============================================
-- 3.446. ARTICLES DE LOI POUR FDI NINA
-- ============================================

INSERT INTO lois_articles (description, consulter_article, procedure_id) VALUES
-- Loi n°06-040 du 11 août 2006
('Loi n°06-040 du 11 août 2006', 
 'La Loi n°06-040 du 11 août 2006 institue le Numéro d''Identification Nationale (NINA) au Mali pour identifier de manière unique chaque personne physique ou morale, constituant la base légale pour l''obtention de la Fiche Descriptive Individuelle.',
 (SELECT id FROM procedures WHERE nom = 'Fiche Descriptive Individuelle (FDI) NINA' LIMIT 1)),

-- Plateforme de télé-demande
('Plateforme de télé-demande', 
 'La mise en place de la plateforme de télé-demande accessible via www.citede.ml fait partie du programme de modernisation de l''administration publique, visant à améliorer la qualité et l''accès aux services administratifs.',
 (SELECT id FROM procedures WHERE nom = 'Fiche Descriptive Individuelle (FDI) NINA' LIMIT 1)),

-- Dématérialisation
('Dématérialisation et modernisation', 
 'Le processus de dématérialisation permet d''obtenir la Fiche Descriptive Individuelle gratuitement via les canaux officiels en ligne, par email à fidi@ctdec.ml, ou par SMS au 36223 pour vérifier la disponibilité.',
 (SELECT id FROM procedures WHERE nom = 'Fiche Descriptive Individuelle (FDI) NINA' LIMIT 1)),

-- Procédures consulaires
('Procédures consulaires', 
 'Pour les Maliens résidant à l''étranger, les consulats proposent des formulaires de demande de fiche NINA. Le Consulat Général du Mali à Paris a mis en place une procédure spécifique, parfois en ligne, pour faciliter l''accès au document.',
 (SELECT id FROM procedures WHERE nom = 'Fiche Descriptive Individuelle (FDI) NINA' LIMIT 1));

-- ============================================
-- 3.447. PROCÉDURE: PASSEPORT BIOMÉTRIQUE
-- ============================================

-- Insertion de la procédure
INSERT INTO procedures (nom, titre, delai, description, categorie_id, sous_categorie_id, date_creation) VALUES
('Passeport biométrique', 'Obtenir un passeport biométrique', 'Variable selon le type de passeport et le centre de traitement', 
 'La délivrance du passeport biométrique au Mali est centralisée au Centre de Traitement des Documents d''Enrôlement et de Commandement (CTDEC) à Bamako. Le nouveau passeport biométrique de la Confédération des États du Sahel (AES), dont le Mali fait partie, est mis en circulation depuis le 29 janvier 2025. La procédure comprend le paiement des frais auprès de la Banque Malienne de Solidarité (BMS S.A.) ou en ligne, la constitution du dossier avec les documents requis, le dépôt au CTDEC pour l''enrôlement biométrique, et le retrait du passeport. Cette procédure est régie par le Décret n°2022-0639/PT-RM du 03 novembre 2022 et les nouvelles dispositions du passeport AES.',
 (SELECT id FROM categories WHERE titre = 'Identité et citoyenneté' LIMIT 1),
 (SELECT id FROM sous_categories WHERE titre = 'Passeport biométrique' LIMIT 1),
 NOW());

-- ============================================
-- 3.448. ÉTAPES DE LA PROCÉDURE PASSEPORT BIOMÉTRIQUE
-- ============================================

INSERT INTO etapes (nom, description, niveau, procedure_id) VALUES
-- Étape 1: Paiement des frais
('Paiement des frais', 'Effectuer le paiement des frais de passeport dans l''une des agences de la Banque Malienne de Solidarité (BMS S.A.) ou en ligne sur www.paiementpasseport-mali.com. Recevoir le reçu de paiement (Code Voucher) : 45 000 FCFA pour passeport ordinaire, 90 000 FCFA pour passeport premium.', 1,
 (SELECT id FROM procedures WHERE nom = 'Passeport biométrique' LIMIT 1)),

-- Étape 2: Constitution du dossier
('Constitution du dossier', 'Rassembler tous les documents nécessaires : reçu de paiement (Code Voucher), photocopie de pièce d''identité, carte NINA ou fiche individuelle (ou CNIBS), et copie d''acte de mariage pour les femmes mariées souhaitant porter le nom de leur époux.', 2,
 (SELECT id FROM procedures WHERE nom = 'Passeport biométrique' LIMIT 1)),

-- Étape 3: Dépôt du dossier et enrôlement biométrique
('Dépôt du dossier et enrôlement biométrique', 'Se rendre au Centre de Traitement des Documents d''Enrôlement et de Commandement (CTDEC) à Bamako pour déposer le dossier et procéder à la prise des données biométriques : empreintes digitales, photo, et signature.', 3,
 (SELECT id FROM procedures WHERE nom = 'Passeport biométrique' LIMIT 1)),

-- Étape 4: Production du passeport
('Production du passeport', 'Le passeport biométrique est produit par les services compétents. Le demandeur peut vérifier l''état d''avancement de sa demande auprès du CTDEC ou via les canaux de communication mis en place.', 4,
 (SELECT id FROM procedures WHERE nom = 'Passeport biométrique' LIMIT 1)),

-- Étape 5: Retrait du passeport
('Retrait du passeport', 'Retirer le passeport biométrique au centre où la demande a été effectuée (CTDEC à Bamako ou consulat pour les Maliens de l''étranger). Le nouveau passeport AES est commun au Mali, Burkina Faso et Niger.', 5,
 (SELECT id FROM procedures WHERE nom = 'Passeport biométrique' LIMIT 1));

-- ============================================
-- 3.449. DOCUMENTS REQUIS POUR PASSEPORT BIOMÉTRIQUE
-- ============================================

INSERT INTO documents_requis (nom, description, obligatoire, procedure_id) VALUES
('Reçu de paiement', 'Le reçu de paiement (Code Voucher) des frais de passeport délivré par la BMS S.A. ou le site de paiement en ligne.', true,
 (SELECT id FROM procedures WHERE nom = 'Passeport biométrique' LIMIT 1)),

('Photocopie pièce d''identité', 'Une photocopie de la pièce d''identité : ancien passeport ou carte d''identité consulaire si disponible.', true,
 (SELECT id FROM procedures WHERE nom = 'Passeport biométrique' LIMIT 1)),

('Carte NINA ou fiche individuelle', 'La carte NINA ou une fiche individuelle. Si vous possédez déjà la Carte Nationale d''Identité Biométrique Sécurisée (CNIBS), celle-ci remplace de plein droit la carte NINA et la fiche individuelle.', true,
 (SELECT id FROM procedures WHERE nom = 'Passeport biométrique' LIMIT 1)),

('Acte de mariage', 'Une copie de l''acte de mariage pour les femmes mariées désirant porter le nom de leur époux sur leur passeport.', false,
 (SELECT id FROM procedures WHERE nom = 'Passeport biométrique' LIMIT 1));

-- ============================================
-- 3.450. COÛTS DE LA PROCÉDURE PASSEPORT BIOMÉTRIQUE
-- ============================================

INSERT INTO couts (nom, prix, description) VALUES
('Passeport ordinaire', 45000, 'Coût du passeport ordinaire : 45 000 FCFA (baisse de prix entrée en vigueur le 25 octobre 2025 dans le cadre du passeport AES)'),
('Passeport premium', 90000, 'Coût du passeport premium : 90 000 FCFA pour un traitement accéléré'),
('Paiement en ligne', 0, 'Paiement en ligne possible sur www.paiementpasseport-mali.com sans frais supplémentaires'),
('Paiement BMS S.A.', 0, 'Paiement dans les agences BMS S.A. : siège ACI 2000, Ex IMACY, Bacodjicoroni, Daoudabougou, Djelibougou 1, Koulikoro');

-- Association des coûts à la procédure
UPDATE procedures 
SET cout_id = (SELECT id FROM couts WHERE nom = 'Passeport ordinaire' LIMIT 1)
WHERE nom = 'Passeport biométrique';

-- ============================================
-- 3.451. ASSOCIATION DU CENTRE POUR PASSEPORT BIOMÉTRIQUE
-- ============================================

-- Association du centre à la procédure
UPDATE procedures 
SET centre_id = (SELECT id FROM centres WHERE nom = 'Centre de Traitement des Documents d''Enrôlement et de Commandement (CTDEC)' LIMIT 1)
WHERE nom = 'Passeport biométrique';

-- ============================================
-- 3.452. ARTICLES DE LOI POUR PASSEPORT BIOMÉTRIQUE
-- ============================================

INSERT INTO lois_articles (description, consulter_article, procedure_id) VALUES
-- Décret n°2022-0639/PT-RM
('Décret n°2022-0639/PT-RM du 03 novembre 2022', 
 'Le Décret n°2022-0639/PT-RM du 03 novembre 2022 institue et réglemente la Carte Nationale d''Identité Biométrique Sécurisée au Mali, et a un impact direct sur les documents requis pour la demande de passeport biométrique.',
 (SELECT id FROM procedures WHERE nom = 'Passeport biométrique' LIMIT 1)),

-- Passeport AES
('Passeport de la Confédération des États du Sahel (AES)', 
 'Le nouveau passeport biométrique de la Confédération des États du Sahel (AES), dont le Mali fait partie, est mis en circulation depuis le 29 janvier 2025. Il est commun au Mali, au Burkina Faso et au Niger.',
 (SELECT id FROM procedures WHERE nom = 'Passeport biométrique' LIMIT 1)),

-- Baisse des prix
('Baisse des prix du passeport', 
 'À la suite d''une décision prise le 8 octobre 2025, le coût du passeport ordinaire a été ajusté à 45 000 FCFA (au lieu de 55 000 FCFA précédemment) et le passeport premium à 90 000 FCFA. Cette baisse est entrée en vigueur le 25 octobre 2025.',
 (SELECT id FROM procedures WHERE nom = 'Passeport biométrique' LIMIT 1)),

-- Centres de traitement
('Centres de traitement et paiement', 
 'La délivrance est centralisée au CTDEC à Bamako. Le paiement se fait dans les agences BMS S.A. ou en ligne sur www.paiementpasseport-mali.com. Pour la diaspora, le paiement peut se faire via un proche au Mali dans une agence Ecobank à Bamako.',
 (SELECT id FROM procedures WHERE nom = 'Passeport biométrique' LIMIT 1));

-- ============================================
-- 3.453. PROCÉDURE: CERTIFICAT DE RÉSIDENCE
-- ============================================

-- Insertion de la procédure
INSERT INTO procedures (nom, titre, delai, description, categorie_id, sous_categorie_id, date_creation) VALUES
('Certificat de résidence', 'Obtenir un certificat de résidence', 'Moins de 24 heures', 
 'Le certificat de résidence au Mali est un document administratif simple et rapide à obtenir pour les citoyens maliens. Cette procédure consiste à se présenter au commissariat de police ou à la mairie de son lieu de résidence avec les documents requis, remplir un formulaire, répondre aux questions de l''officier sur la durée de résidence, et s''acquitter du timbre fiscal. Le document est délivré gratuitement, seul le timbre fiscal coûte 200 francs CFA. Pour les étrangers, des procédures spécifiques existent pour l''obtention d''une carte de résident ordinaire valable trois ans. Cette procédure est régie par la Loi 04-058 du 25 novembre 2004 et le Décret 05-322 du 11 février 2009.',
 (SELECT id FROM categories WHERE titre = 'Identité et citoyenneté' LIMIT 1),
 (SELECT id FROM sous_categories WHERE titre = 'Certificat de résidence' LIMIT 1),
 NOW());

-- ============================================
-- 3.454. ÉTAPES DE LA PROCÉDURE CERTIFICAT DE RÉSIDENCE
-- ============================================

INSERT INTO etapes (nom, description, niveau, procedure_id) VALUES
-- Étape 1: Se présenter au centre compétent
('Se présenter au centre compétent', 'Se rendre au commissariat de police ou à la mairie de son lieu de résidence pour initier la procédure d''obtention du certificat de résidence. Vérifier les horaires d''ouverture avant de se déplacer.', 1,
 (SELECT id FROM procedures WHERE nom = 'Certificat de résidence' LIMIT 1)),

-- Étape 2: Fournir les documents requis
('Fournir les documents requis', 'Présenter les documents nécessaires : acte de naissance, carte NINA, et carte d''identité nationale. Pour les enfants mineurs, fournir une copie de la carte d''identité ou de l''acte de naissance du tuteur.', 2,
 (SELECT id FROM procedures WHERE nom = 'Certificat de résidence' LIMIT 1)),

-- Étape 3: Remplir le formulaire
('Remplir le formulaire', 'Remplir le formulaire de demande de certificat de résidence et répondre aux questions de l''officier, notamment sur la durée de la résidence dans le lieu concerné.', 3,
 (SELECT id FROM procedures WHERE nom = 'Certificat de résidence' LIMIT 1)),

-- Étape 4: Paiement du timbre fiscal
('Paiement du timbre fiscal', 'S''acquitter du timbre fiscal de 200 francs CFA, seul coût de la procédure. Le certificat de résidence lui-même est délivré gratuitement.', 4,
 (SELECT id FROM procedures WHERE nom = 'Certificat de résidence' LIMIT 1)),

-- Étape 5: Réception du certificat
('Réception du certificat', 'Recevoir le certificat de résidence dans la même journée, généralement en moins de 24 heures selon l''affluence et la nécessité d''une signature.', 5,
 (SELECT id FROM procedures WHERE nom = 'Certificat de résidence' LIMIT 1));

-- ============================================
-- 3.455. DOCUMENTS REQUIS POUR CERTIFICAT DE RÉSIDENCE
-- ============================================

INSERT INTO documents_requis (nom, description, obligatoire, procedure_id) VALUES
('Acte de naissance', 'L''acte de naissance du demandeur pour établir son identité et sa nationalité.', true,
 (SELECT id FROM procedures WHERE nom = 'Certificat de résidence' LIMIT 1)),

('Carte NINA', 'La carte NINA (Numéro d''Identification Nationale) du demandeur pour l''identification administrative.', true,
 (SELECT id FROM procedures WHERE nom = 'Certificat de résidence' LIMIT 1)),

('Carte d''identité nationale', 'La carte d''identité nationale du demandeur comme pièce d''identité officielle.', true,
 (SELECT id FROM procedures WHERE nom = 'Certificat de résidence' LIMIT 1)),

('Carte d''identité du tuteur', 'Pour les enfants mineurs, une copie de la carte d''identité du tuteur légal.', false,
 (SELECT id FROM procedures WHERE nom = 'Certificat de résidence' LIMIT 1)),

('Acte de naissance du tuteur', 'Pour les enfants mineurs, une copie de l''acte de naissance du tuteur légal si la carte d''identité n''est pas disponible.', false,
 (SELECT id FROM procedures WHERE nom = 'Certificat de résidence' LIMIT 1));

-- ============================================
-- 3.456. COÛTS DE LA PROCÉDURE CERTIFICAT DE RÉSIDENCE
-- ============================================

INSERT INTO couts (nom, prix, description) VALUES
('Timbre fiscal', 200, 'Timbre fiscal de 200 francs CFA - Seul coût de la procédure'),
('Certificat de résidence', 0, 'Le certificat de résidence est délivré gratuitement - Aucun frais administratif'),
('Frais de dossier', 0, 'Aucun frais de dossier pour l''obtention du certificat de résidence'),
('Frais de traitement', 0, 'Aucun frais de traitement pour la délivrance du certificat');

-- Association des coûts à la procédure
UPDATE procedures 
SET cout_id = (SELECT id FROM couts WHERE nom = 'Timbre fiscal' LIMIT 1)
WHERE nom = 'Certificat de résidence';

-- ============================================
-- 3.457. ASSOCIATION DU CENTRE POUR CERTIFICAT DE RÉSIDENCE
-- ============================================

-- Association du centre à la procédure
UPDATE procedures 
SET centre_id = (SELECT id FROM centres WHERE nom = 'Commissariat de Police' LIMIT 1)
WHERE nom = 'Certificat de résidence';

-- ============================================
-- 3.458. ARTICLES DE LOI POUR CERTIFICAT DE RÉSIDENCE
-- ============================================

INSERT INTO lois_articles (description, consulter_article, procedure_id) VALUES
-- Loi 04-058 du 25 novembre 2004
('Loi 04-058 du 25 novembre 2004', 
 'La Loi 04-058 du 25 novembre 2004 est relative aux conditions d''entrée, de séjour et d''établissement des étrangers au Mali. Elle fait la distinction entre les étrangers non-immigrants et les immigrants, et régit les procédures de résidence.',
 (SELECT id FROM procedures WHERE nom = 'Certificat de résidence' LIMIT 1)),

-- Décret 05-322 du 11 février 2009
('Décret 05-322 du 11 février 2009', 
 'Le Décret 05-322 du 11 février 2009 fixe les conditions d''établissement et de séjour des étrangers, y compris les modalités d''application de la loi 04-058 pour l''obtention des documents de résidence au Mali.',
 (SELECT id FROM procedures WHERE nom = 'Certificat de résidence' LIMIT 1)),

-- Procédure pour citoyens maliens
('Procédure pour citoyens maliens', 
 'Pour les citoyens maliens, le certificat de résidence est un document administratif simple et rapide à obtenir au commissariat de police ou à la mairie, avec un délai de moins de 24 heures et un coût limité au timbre fiscal de 200 FCFA.',
 (SELECT id FROM procedures WHERE nom = 'Certificat de résidence' LIMIT 1)),

-- Procédure pour étrangers
('Procédure pour étrangers', 
 'Pour les étrangers, les formalités de résidence sont régies par des lois spécifiques et peuvent nécessiter de se présenter à la Direction générale de la Sûreté nationale (DGSN) pour l''obtention de la carte de résident ordinaire, valable trois ans.',
 (SELECT id FROM procedures WHERE nom = 'Certificat de résidence' LIMIT 1));

-- ============================================
-- 3.459. PROCÉDURE: CHANGER SA VOITURE EN TAXI
-- ============================================

-- Insertion de la procédure
INSERT INTO procedures (nom, titre, delai, description, categorie_id, sous_categorie_id, date_creation) VALUES
('Changer sa voiture en taxi', 'Transformer sa voiture personnelle en taxi', 'Plusieurs semaines pour l''ensemble des démarches', 
 'La transformation d''une voiture personnelle en taxi au Mali implique un processus administratif complexe qui nécessite le changement d''usage du véhicule et l''obtention de plusieurs documents spécifiques au transport public. Cette procédure comprend la vérification des conditions préalables, le passage au contrôle technique, l''obtention de la licence de transport, la souscription d''une assurance spécifique, et les démarches administratives pour le véhicule et le conducteur. Le processus implique plusieurs entités : Direction Nationale des Transports, Mairie du District de Bamako, et Agence Nationale de la Sécurité Routière (ANASER). Cette procédure est régie par les lois et décrets sur les transports routiers du Ministère des Transports et des Infrastructures.',
 (SELECT id FROM categories WHERE titre = 'Documents auto' LIMIT 1),
 (SELECT id FROM sous_categories WHERE titre = 'changer sa voiture en taxi' LIMIT 1),
 NOW());

-- ============================================
-- 3.460. ÉTAPES DE LA PROCÉDURE CHANGER VOITURE EN TAXI
-- ============================================

INSERT INTO etapes (nom, description, niveau, procedure_id) VALUES
-- Étape 1: Vérification des conditions préalables
('Vérification des conditions préalables', 'Vérifier que la voiture répond aux normes techniques requises pour le transport public (état général, sécurité) et que le conducteur remplit les conditions (permis de conduire valide, âge requis) pour exercer la profession de chauffeur de taxi.', 1,
 (SELECT id FROM procedures WHERE nom = 'Changer sa voiture en taxi' LIMIT 1)),

-- Étape 2: Passage au contrôle technique
('Passage au contrôle technique', 'Faire expertiser le véhicule par un centre de contrôle technique agréé (comme Mali Technique Services - MTS) pour obtenir le certificat de visite technique obligatoire, garantissant que le véhicule respecte les normes de sécurité pour le transport de personnes.', 2,
 (SELECT id FROM procedures WHERE nom = 'Changer sa voiture en taxi' LIMIT 1)),

-- Étape 3: Obtention de la licence de transport
('Obtention de la licence de transport', 'Obtenir la licence d''exploitation délivrée par la Direction Nationale des Transports et la Mairie du district de Bamako. Cette étape officialise le changement d''usage du véhicule de privé à transport public.', 3,
 (SELECT id FROM procedures WHERE nom = 'Changer sa voiture en taxi' LIMIT 1)),

-- Étape 4: Assurance spécifique
('Assurance spécifique', 'Contracter une police d''assurance couvrant les risques liés au transport public de personnes. Une assurance classique pour véhicule personnel ne sera pas suffisante pour exercer l''activité de taxi.', 4,
 (SELECT id FROM procedures WHERE nom = 'Changer sa voiture en taxi' LIMIT 1)),

-- Étape 5: Démarches administratives finales
('Démarches administratives finales', 'Régulariser l''immatriculation du véhicule en tant que transport public, acquitter la vignette fiscale au tarif transport public, obtenir la carte municipale d''autorisation de transport, et passer une visite médicale si nécessaire pour le certificat d''aptitude.', 5,
 (SELECT id FROM procedures WHERE nom = 'Changer sa voiture en taxi' LIMIT 1));

-- ============================================
-- 3.461. DOCUMENTS REQUIS POUR CHANGER VOITURE EN TAXI
-- ============================================

INSERT INTO documents_requis (nom, description, obligatoire, procedure_id) VALUES
('Demande manuscrite', 'Une demande manuscrite de transformation de véhicule personnel en taxi adressée aux autorités compétentes.', true,
 (SELECT id FROM procedures WHERE nom = 'Changer sa voiture en taxi' LIMIT 1)),

('Copie carte d''identité', 'Une copie de la carte d''identité ou du passeport du demandeur pour établir son identité.', true,
 (SELECT id FROM procedures WHERE nom = 'Changer sa voiture en taxi' LIMIT 1)),

('Copie carte grise', 'Une copie de la carte grise du véhicule à transformer en taxi pour vérifier la propriété et les caractéristiques du véhicule.', true,
 (SELECT id FROM procedures WHERE nom = 'Changer sa voiture en taxi' LIMIT 1)),

('Certificat de visite technique', 'Le certificat de visite technique délivré par un centre agréé (comme Mali Technique Services) attestant que le véhicule respecte les normes de sécurité pour le transport public.', true,
 (SELECT id FROM procedures WHERE nom = 'Changer sa voiture en taxi' LIMIT 1)),

('Attestation d''assurance', 'L''attestation d''assurance en cours de validité couvrant spécifiquement les risques du transport public de personnes.', true,
 (SELECT id FROM procedures WHERE nom = 'Changer sa voiture en taxi' LIMIT 1)),

('Copie permis de conduire', 'Une copie du permis de conduire valide du conducteur correspondant au type de véhicule.', true,
 (SELECT id FROM procedures WHERE nom = 'Changer sa voiture en taxi' LIMIT 1)),

('Certificat de résidence', 'Le certificat de résidence du demandeur pour établir son domicile.', true,
 (SELECT id FROM procedures WHERE nom = 'Changer sa voiture en taxi' LIMIT 1)),

('Photos d''identité', 'Des photos d''identité récentes du demandeur selon les normes en vigueur.', true,
 (SELECT id FROM procedures WHERE nom = 'Changer sa voiture en taxi' LIMIT 1)),

('Certificat d''aptitude médicale', 'Le certificat d''aptitude médicale délivré par un médecin agréé si requis pour l''exercice de la profession de chauffeur de taxi.', false,
 (SELECT id FROM procedures WHERE nom = 'Changer sa voiture en taxi' LIMIT 1));

-- ============================================
-- 3.462. COÛTS DE LA PROCÉDURE CHANGER VOITURE EN TAXI
-- ============================================

INSERT INTO couts (nom, prix, description) VALUES
('Frais de visite technique', 0, 'Frais de visite technique varient selon le type de véhicule - Variable selon le centre agréé'),
('Taxes d''immatriculation', 0, 'Coût pour la nouvelle carte grise reflétant l''usage commercial - Variable selon les services'),
('Prime d''assurance', 0, 'Coût de l''assurance spécifique au transport public - Variable selon la compagnie et le niveau de couverture'),
('Vignette fiscale', 0, 'Montant de la vignette fiscale au tarif transport public - Variable selon la puissance et l''âge du véhicule'),
('Frais de délivrance documents', 0, 'Frais pour la carte municipale et la licence de transport - Variable selon les services');

-- Association des coûts à la procédure
UPDATE procedures 
SET cout_id = (SELECT id FROM couts WHERE nom = 'Frais de visite technique' LIMIT 1)
WHERE nom = 'Changer sa voiture en taxi';

-- ============================================
-- 3.463. ASSOCIATION DU CENTRE POUR CHANGER VOITURE EN TAXI
-- ============================================

-- Association du centre à la procédure
UPDATE procedures 
SET centre_id = (SELECT id FROM centres WHERE nom = 'Direction Nationale des Transports' LIMIT 1)
WHERE nom = 'Changer sa voiture en taxi';

-- ============================================
-- 3.464. ARTICLES DE LOI POUR CHANGER VOITURE EN TAXI
-- ============================================

INSERT INTO lois_articles (description, consulter_article, procedure_id) VALUES
-- Lois et décrets sur les transports routiers
('Lois et décrets sur les transports routiers', 
 'La réglementation du transport public au Mali est encadrée par des textes législatifs et réglementaires du Ministère des Transports et des Infrastructures, définissant les conditions et modalités de transformation d''un véhicule personnel en véhicule de transport public.',
 (SELECT id FROM procedures WHERE nom = 'Changer sa voiture en taxi' LIMIT 1)),

-- Délibérations de la Mairie de Bamako
('Délibérations de la Mairie de Bamako', 
 'Le transport urbain est également régi par des textes spécifiques de la Mairie du District de Bamako, notamment pour l''obtention de la carte municipale d''autorisation de transport et les conditions d''exercice de la profession de chauffeur de taxi.',
 (SELECT id FROM procedures WHERE nom = 'Changer sa voiture en taxi' LIMIT 1)),

-- Arrêté interministériel N°02-0321
('Arrêté interministériel N°02-0321-M.CT-MEF du 22 février 2002', 
 'Cet arrêté interministériel régit les conditions d''importation et de commercialisation des véhicules automobiles, avec des implications sur les procédures de changement d''usage des véhicules pour le transport public.',
 (SELECT id FROM procedures WHERE nom = 'Changer sa voiture en taxi' LIMIT 1)),

-- Normes de sécurité et contrôle technique
('Normes de sécurité et contrôle technique', 
 'Les véhicules de transport public doivent respecter des normes de sécurité spécifiques, vérifiées lors du contrôle technique obligatoire par des centres agréés comme Mali Technique Services (MTS).',
 (SELECT id FROM procedures WHERE nom = 'Changer sa voiture en taxi' LIMIT 1));

-- ============================================

