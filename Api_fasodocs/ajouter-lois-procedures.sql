-- ============================================================================
-- Script d'ajout des références de loi pour les procédures
-- ============================================================================

USE fasodocs;

-- ============================================================================
-- 1. VISITE TECHNIQUE (ID: 14)
-- ============================================================================
INSERT INTO lois_articles (description, consulter_article, lien_audio, procedure_id) VALUES
(
    'Arrêté n°2016-3748/MTTA-SG du 30 novembre 2016 fixant les modalités de la visite technique des véhicules',
    'Arrêté n°2016-3748/MTTA-SG du 30 novembre 2016 fixant les modalités de la visite technique des véhicules automobiles au Mali. Cet arrêté définit les conditions techniques, les périodicités et les procédures de contrôle technique obligatoire pour tous les véhicules en circulation.',
    NULL,
    14
);

-- ============================================================================
-- 2. VIGNETTE AUTOMOBILE (ID: 15 et 52)
-- ============================================================================
INSERT INTO lois_articles (description, consulter_article, lien_audio, procedure_id) VALUES
(
    'Loi n°2012-016 du 16 février 2012 portant Code général des impôts - Articles relatifs à la taxe sur les véhicules automobiles',
    'Articles 348 à 353 de la Loi n°2012-016 du 16 février 2012 portant Code général des impôts. Ces articles définissent les conditions, tarifs et modalités de paiement de la taxe sur les véhicules automobiles (vignette) au Mali. La taxe est due annuellement par tout propriétaire de véhicule.',
    NULL,
    15
),
(
    'Loi n°2012-016 du 16 février 2012 portant Code général des impôts - Articles relatifs à la taxe sur les véhicules automobiles',
    'Articles 348 à 353 de la Loi n°2012-016 du 16 février 2012 portant Code général des impôts. Ces articles définissent les conditions, tarifs et modalités de paiement de la taxe sur les véhicules automobiles (vignette) au Mali. La taxe est due annuellement par tout propriétaire de véhicule.',
    NULL,
    52
);

-- ============================================================================
-- 3. ENTREPRISE INDIVIDUELLE (ID: 22)
-- ============================================================================
INSERT INTO lois_articles (description, consulter_article, lien_audio, procedure_id) VALUES
(
    'Loi n°2016-062 du 30 décembre 2016 portant Code de commerce',
    'Articles 47 à 52 de la Loi n°2016-062 du 30 décembre 2016 portant Code de commerce. Ces articles définissent le statut de l''entreprise individuelle, les obligations du commerçant personne physique, notamment l''immatriculation au Registre du Commerce et du Crédit Mobilier (RCCM).',
    NULL,
    22
);

-- ============================================================================
-- 4. SARL (ID: 23)
-- ============================================================================
INSERT INTO lois_articles (description, consulter_article, lien_audio, procedure_id) VALUES
(
    'Acte uniforme OHADA relatif au droit des sociétés commerciales et du GIE - Articles sur la SARL',
    'Articles 309 à 384 de l''Acte uniforme relatif au droit des sociétés commerciales et du groupement d''intérêt économique (OHADA). Ces articles régissent la constitution, le fonctionnement, la gestion et la dissolution des Sociétés à Responsabilité Limitée (SARL).',
    NULL,
    23
),
(
    'Loi n°2016-062 du 30 décembre 2016 portant Code de commerce - Articles sur les sociétés commerciales',
    'Articles 88 à 125 de la Loi n°2016-062 du 30 décembre 2016 portant Code de commerce. Dispositions nationales complémentaires aux règles OHADA pour les SARL au Mali.',
    NULL,
    23
);

-- ============================================================================
-- 5. SARL UNIPERSONNELLE (ID: 43)
-- ============================================================================
INSERT INTO lois_articles (description, consulter_article, lien_audio, procedure_id) VALUES
(
    'Acte uniforme OHADA relatif au droit des sociétés commerciales - Articles sur la SARL unipersonnelle',
    'Articles 309 à 384 et spécifiquement l''article 309-1 de l''Acte uniforme OHADA relatif au droit des sociétés commerciales. Ces articles permettent la constitution d''une SARL par une seule personne (SARL U).',
    NULL,
    43
);

-- ============================================================================
-- 6. SOCIÉTÉ ANONYME (SA) (ID: 24)
-- ============================================================================
INSERT INTO lois_articles (description, consulter_article, lien_audio, procedure_id) VALUES
(
    'Acte uniforme OHADA relatif au droit des sociétés commerciales - Articles sur la SA',
    'Articles 385 à 823 de l''Acte uniforme OHADA relatif au droit des sociétés commerciales et du groupement d''intérêt économique. Ces articles régissent la constitution, le fonctionnement, la direction (conseil d''administration ou administrateur général) et la dissolution des Sociétés Anonymes (SA).',
    NULL,
    24
),
(
    'Loi n°2016-062 du 30 décembre 2016 portant Code de commerce - Dispositions sur les SA',
    'Articles 126 à 180 de la Loi n°2016-062 du 30 décembre 2016 portant Code de commerce. Dispositions nationales complémentaires pour les SA au Mali.',
    NULL,
    24
);

-- ============================================================================
-- 7. SOCIÉTÉ EN COMMANDITE SIMPLE (SCS) (ID: 26)
-- ============================================================================
INSERT INTO lois_articles (description, consulter_article, lien_audio, procedure_id) VALUES
(
    'Acte uniforme OHADA relatif au droit des sociétés commerciales - Articles sur la SCS',
    'Articles 270 à 292 de l''Acte uniforme OHADA relatif au droit des sociétés commerciales. Ces articles définissent les règles de constitution et de fonctionnement des Sociétés en Commandite Simple, avec distinction entre commandités (responsabilité illimitée) et commanditaires (responsabilité limitée).',
    NULL,
    26
);

-- ============================================================================
-- 8. SOCIÉTÉ PAR ACTIONS SIMPLIFIÉE (SAS) (ID: 25)
-- ============================================================================
INSERT INTO lois_articles (description, consulter_article, lien_audio, procedure_id) VALUES
(
    'Acte uniforme OHADA relatif au droit des sociétés commerciales - Articles sur la SAS',
    'Articles 853-1 à 853-21 de l''Acte uniforme OHADA révisé relatif au droit des sociétés commerciales. Ces articles, introduits par la réforme de 2014, régissent la Société par Actions Simplifiée (SAS), offrant une grande flexibilité statutaire.',
    NULL,
    25
);

-- ============================================================================
-- 9. SOCIÉTÉ PAR ACTIONS SIMPLIFIÉE UNIPERSONNELLE (SASU) (ID: 42)
-- ============================================================================
INSERT INTO lois_articles (description, consulter_article, lien_audio, procedure_id) VALUES
(
    'Acte uniforme OHADA relatif au droit des sociétés commerciales - Articles sur la SASU',
    'Articles 853-1 à 853-21 de l''Acte uniforme OHADA, notamment l''article 853-2 permettant la constitution d''une SAS par un associé unique (SASU). La SASU bénéficie des mêmes avantages de flexibilité que la SAS.',
    NULL,
    42
);

-- ============================================================================
-- 10. CHANGEMENT DE COULEUR DE PLAQUE (ID: 16)
-- ============================================================================
INSERT INTO lois_articles (description, consulter_article, lien_audio, procedure_id) VALUES
(
    'Arrêté n°2016-3747/MTTA-SG fixant les conditions de délivrance des plaques d''immatriculation',
    'Arrêté n°2016-3747/MTTA-SG du 30 novembre 2016 fixant les conditions et modalités de délivrance des plaques d''immatriculation des véhicules au Mali. Cet arrêté définit les différentes catégories de plaques (particulier, transport, administration) et les conditions de changement.',
    NULL,
    16
);

-- ============================================================================
-- 11. DÉCLARATION DE PERTE (ID: 18)
-- ============================================================================
INSERT INTO lois_articles (description, consulter_article, lien_audio, procedure_id) VALUES
(
    'Code de procédure pénale du Mali - Articles sur la déclaration de perte ou de vol',
    'Articles 27 à 32 du Code de procédure pénale de la République du Mali. Ces articles définissent les obligations de déclaration de perte ou de vol de documents officiels auprès des services de police ou de gendarmerie.',
    NULL,
    18
),
(
    'Loi n°06-024 du 28 juin 2006 régissant l''État Civil - Articles sur le duplicata',
    'Articles 107 à 112 de la Loi n°06-024 du 28 juin 2006 régissant l''État Civil au Mali. Ces articles définissent les procédures pour obtenir un duplicata ou une copie de documents d''état civil en cas de perte.',
    NULL,
    18
);

-- ============================================================================
-- 12. AUTORISATION D'ACHAT D'ARMES (ID: 20)
-- ============================================================================
INSERT INTO lois_articles (description, consulter_article, lien_audio, procedure_id) VALUES
(
    'Loi n°04-050 du 12 novembre 2004 portant détention et port d''armes et de munitions',
    'Loi n°04-050 du 12 novembre 2004 portant détention et port d''armes et de munitions au Mali. Cette loi définit les catégories d''armes, les conditions d''autorisation d''achat, de détention et de port, ainsi que les sanctions en cas d''infraction.',
    NULL,
    20
),
(
    'Décret n°05-079/P-RM du 17 février 2005 fixant les modalités d''application de la loi sur les armes',
    'Décret n°05-079/P-RM du 17 février 2005 fixant les modalités d''application de la loi n°04-050 portant détention et port d''armes et de munitions. Ce décret précise les procédures administratives pour l''obtention des autorisations.',
    NULL,
    20
);

-- ============================================================================
-- 13. DEMANDE DE LIBÉRATION CONDITIONNELLE (ID: 17)
-- ============================================================================
INSERT INTO lois_articles (description, consulter_article, lien_audio, procedure_id) VALUES
(
    'Code de procédure pénale - Articles sur la libération conditionnelle',
    'Articles 711 à 720 du Code de procédure pénale de la République du Mali. Ces articles définissent les conditions, la procédure et les effets de la libération conditionnelle, notamment les délais d''éligibilité selon la durée de la peine.',
    NULL,
    17
),
(
    'Loi n°01-079 du 20 août 2001 portant Code pénitentiaire',
    'Articles 42 à 48 de la Loi n°01-079 du 20 août 2001 portant Code pénitentiaire au Mali. Ces articles complètent les dispositions du Code de procédure pénale sur la libération conditionnelle.',
    NULL,
    17
);

-- ============================================================================
-- 14. TAXE SUR LES ARMES À FEU (ID: 72)
-- ============================================================================
INSERT INTO lois_articles (description, consulter_article, lien_audio, procedure_id) VALUES
(
    'Loi n°2012-016 du 16 février 2012 portant Code général des impôts - Taxe sur les armes',
    'Articles 354 à 358 de la Loi n°2012-016 du 16 février 2012 portant Code général des impôts. Ces articles instituent et définissent les modalités de perception de la taxe annuelle sur les armes à feu détenues par les particuliers.',
    NULL,
    72
);

-- ============================================================================
-- VÉRIFICATION DES AJOUTS
-- ============================================================================

-- Afficher toutes les lois ajoutées
SELECT 
    p.id,
    p.titre AS 'Procédure',
    COUNT(la.id) AS 'Nombre de lois',
    GROUP_CONCAT(LEFT(la.description, 50) SEPARATOR ' | ') AS 'Lois (extrait)'
FROM procedures p
LEFT JOIN lois_articles la ON la.procedure_id = p.id
WHERE p.id IN (14, 15, 52, 22, 23, 43, 24, 26, 25, 42, 16, 18, 20, 17, 72)
GROUP BY p.id, p.titre
ORDER BY p.id;

-- Comptage total
SELECT 
    '✅ Lois ajoutées avec succès!' AS 'Statut',
    COUNT(*) AS 'Total lois ajoutées'
FROM lois_articles
WHERE procedure_id IN (14, 15, 52, 22, 23, 43, 24, 26, 25, 42, 16, 18, 20, 17, 72);
