-- Migration pour associer les fichiers audio aux procédures
-- Les fichiers audio sont dans src/main/resources/static/audio/procedures/
-- Format: .aac avec espaces dans les noms

-- Associer les fichiers audio selon le nom de la procédure
UPDATE procedures 
SET audio_url = CASE 
    -- Actes d'état civil
    WHEN nom LIKE '%acte%naissance%' OR titre LIKE '%acte%naissance%' 
        THEN 'Acte de naissance .aac'
    WHEN nom LIKE '%acte%mariage%' OR titre LIKE '%acte%mariage%' 
        THEN 'Acte de mariage .aac'
    WHEN (nom LIKE '%acte%décès%' OR nom LIKE '%acte%deces%') 
        OR (titre LIKE '%acte%décès%' OR titre LIKE '%acte%deces%')
        THEN 'Acte de décès .aac'
    
    -- Documents d'identité
    WHEN (nom LIKE '%carte%identité%' OR nom LIKE '%carte%identite%') 
        OR (titre LIKE '%carte%identité%' OR titre LIKE '%carte%identite%')
        THEN 'Carte d''identité biométrique .aac'
    WHEN nom LIKE '%passeport%' OR titre LIKE '%passeport%' 
        THEN 'Passeport .aac'
    WHEN nom LIKE '%carte%électeur%' OR nom LIKE '%carte%electeur%' 
        OR titre LIKE '%carte%électeur%' OR titre LIKE '%carte%electeur%'
        THEN 'Carte d''électeur .aac'
    
    -- Permis et licences
    WHEN nom LIKE '%permis%conduire%' OR titre LIKE '%permis%conduire%' 
        THEN 'Permis de conduire .aac'
    WHEN nom LIKE '%renouvellement%permis%' OR titre LIKE '%renouvellement%permis%' 
        THEN 'Renouvellement du permis de conduire .aac'
    
    -- Documents judiciaires
    WHEN nom LIKE '%casier%judiciaire%' OR titre LIKE '%casier%judiciaire%' 
        THEN 'Casier judiciaire .aac'
    WHEN nom LIKE '%certificat%nationalité%' OR nom LIKE '%certificat%nationalite%' 
        OR titre LIKE '%certificat%nationalité%' OR titre LIKE '%certificat%nationalite%'
        THEN 'Certificat de nationalité .aac'
    WHEN nom LIKE '%certificat%résidence%' OR nom LIKE '%certificat%residence%' 
        OR titre LIKE '%certificat%résidence%' OR titre LIKE '%certificat%residence%'
        THEN 'Certificat de résidence .aac'
    
    -- Véhicules
    WHEN nom LIKE '%carte%grise%' OR titre LIKE '%carte%grise%' 
        THEN 'Carte grise.aac'
    WHEN nom LIKE '%visite%technique%' OR titre LIKE '%visite%technique%' 
        THEN 'Visite technique .aac'
    WHEN nom LIKE '%vignette%' OR titre LIKE '%vignette%' 
        THEN 'Vignette .aac'
    WHEN nom LIKE '%mutation%carte%grise%' OR titre LIKE '%mutation%carte%grise%' 
        THEN 'Carte grise mutation .aac'
    WHEN nom LIKE '%renouvellement%carte%grise%' OR titre LIKE '%renouvellement%carte%grise%' 
        THEN 'Carte grise renouvellement .aac'
    
    -- Autres
    WHEN nom LIKE '%divorce%' OR titre LIKE '%divorce%' 
        THEN 'Divorce .aac'
    WHEN nom LIKE '%compteur%EDM%' OR nom LIKE '%compteur%edm%' 
        THEN 'Compteur EDM.aac'
    WHEN nom LIKE '%compteur%somagep%' OR nom LIKE '%compteur%Somagep%' 
        THEN 'Compteur somagep.aac'
    WHEN nom LIKE '%transfert%compteur%EDM%' OR nom LIKE '%transfert%compteur%edm%' 
        THEN 'Transfert compteur EDM .aac'
    WHEN nom LIKE '%transfert%compteur%Somagep%' OR nom LIKE '%transfert%compteur%somagep%' 
        THEN 'Transfert compteur Somagep .aac'
    WHEN nom LIKE '%déclaration%perte%' OR nom LIKE '%declaration%perte%' 
        THEN 'Déclaration de perte .aac'
    WHEN nom LIKE '%déclaration%vol%' OR nom LIKE '%declaration%vol%' 
        THEN 'Déclaration de vol.aac'
    WHEN nom LIKE '%logement%social%' OR titre LIKE '%logement%social%' 
        THEN 'Logement social .aac'
    WHEN nom LIKE '%inscription%liste%électorale%' OR nom LIKE '%inscription%liste%electorale%' 
        THEN 'Inscription liste électorale .aac'
    WHEN nom LIKE '%nationalité%naturalisation%' OR nom LIKE '%nationalite%naturalisation%' 
        THEN 'Nationalité par naturalisation .aac'
    WHEN nom LIKE '%liberté%provisoire%' OR nom LIKE '%liberte%provisoire%' 
        THEN 'Liberté provisoire .aac'
    WHEN nom LIKE '%permis%communiquer%prisonnier%' 
        THEN 'Permis de communiquer avec un prisonnier .aac'
    WHEN nom LIKE '%appel%jugement%' 
        THEN 'Appel d''un jugement .aac'
    WHEN nom LIKE '%armé%munition%' OR nom LIKE '%arme%munition%' 
        THEN 'Armé et munitions .aac'
    WHEN nom LIKE '%changer%couleur%plaque%' 
        THEN 'Changer la couleur des plaques .aac'
    WHEN nom LIKE '%changer%voiture%' 
        THEN 'Changer sa voiture .aac'
    WHEN nom LIKE '%transfert%parcelle%habitation%' 
        THEN 'Transfert de parcelle à usage d''habitation .aac'
    WHEN nom LIKE '%vente%biens%mineur%' 
        THEN 'Vente des biens d''un mineur .aac'
    WHEN nom LIKE '%entreprise%individuelle%' 
        THEN 'Entreprise individuelle .aac'
    WHEN nom LIKE '%fiche%individuelle%' 
        THEN 'Fiche individuelle .aac'
    
    ELSE audio_url
END
WHERE audio_url IS NULL OR audio_url = '';

-- Vérifier les associations
SELECT id, nom, audio_url 
FROM procedures 
WHERE audio_url IS NOT NULL 
ORDER BY id;

