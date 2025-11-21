package ml.fasodocs.backend.service;

import ml.fasodocs.backend.dto.request.ProcedureRequest;
import ml.fasodocs.backend.dto.request.ProcedureUpdateRequest;
import ml.fasodocs.backend.dto.request.DocumentRequisUpdateRequest;
import ml.fasodocs.backend.dto.request.LoiArticleUpdateRequest;
import ml.fasodocs.backend.dto.response.*;
import ml.fasodocs.backend.entity.*;
import ml.fasodocs.backend.repository.*;
import ml.fasodocs.backend.repository.CoutRepository;
import ml.fasodocs.backend.repository.DocumentRequisRepository;
import ml.fasodocs.backend.repository.LoiArticleRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

/**
 * Service pour la gestion des procédures administratives
 */
@Service
@Transactional
public class ProcedureService {

    private static final Logger logger = LoggerFactory.getLogger(ProcedureService.class);

    @Autowired
    private ProcedureRepository procedureRepository;

    @Autowired
    private CategorieRepository categorieRepository;

    @Autowired
    private NotificationService notificationService;

    @Autowired
    private HistoriqueService historiqueService;

    @Autowired
    private CoutRepository coutRepository;

    @Autowired
    private CentreRepository centreRepository;

    @Autowired
    private EtapeRepository etapeRepository;

    @Autowired
    private SousCategorieRepository sousCategorieRepository;

    @Autowired
    private DocumentRequisRepository documentRequisRepository;

    @Autowired
    private LoiArticleRepository loiArticleRepository;

    @Autowired
    private TranslationHelper translationHelper;

    /**
     * Récupère toutes les procédures
     */
    public List<ProcedureResponse> obtenirToutesProcedures() {
        return procedureRepository.findAll().stream()
                .map(this::convertirEnResponse)
                .collect(Collectors.toList());
    }

    /**
     * Récupère une procédure par ID
     */
    public ProcedureResponse obtenirProcedureParId(Long id) {
        Procedure procedure = procedureRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Procédure non trouvée"));
        
        // Enregistrer l'historique de consultation
        historiqueService.enregistrerConsultation(procedure);
        
        return convertirEnResponse(procedure);
    }

    /**
     * Récupère les procédures par catégorie
     */
    public List<ProcedureResponse> obtenirProceduresParCategorie(Long categorieId) {
        return procedureRepository.findByCategorieId(categorieId).stream()
                .map(this::convertirEnResponse)
                .collect(Collectors.toList());
    }

    /**
     * Récupère les procédures par sous-catégorie
     */
    public List<ProcedureResponse> obtenirProceduresParSousCategorie(Long sousCategorieId) {
        return procedureRepository.findBySousCategorieId(sousCategorieId).stream()
                .map(this::convertirEnResponse)
                .collect(Collectors.toList());
    }

    /**
     * Récupère les procédures par centre
     */
    public List<ProcedureResponse> obtenirProceduresParCentre(Long centreId) {
        return procedureRepository.findByCentreId(centreId).stream()
                .map(this::convertirEnResponse)
                .collect(Collectors.toList());
    }

    /**
     * Recherche des procédures par nom
     */
    public List<ProcedureResponse> rechercherProcedures(String recherche) {
        List<Procedure> procedures = procedureRepository.rechercherParNom(recherche);
        procedures.addAll(procedureRepository.rechercherParTitre(recherche));
        
        return procedures.stream()
                .distinct()
                .map(this::convertirEnResponse)
                .collect(Collectors.toList());
    }

    /**
     * Crée une nouvelle procédure (Admin)
     */
    public ProcedureResponse creerProcedure(ProcedureRequest request) {
        // Gestion de la catégorie (par ID ou par nom)
        Categorie categorie;
        if (request.getCategorieId() != null) {
            categorie = categorieRepository.findById(request.getCategorieId())
                    .orElseThrow(() -> new RuntimeException("Catégorie non trouvée avec l'ID: " + request.getCategorieId()));
        } else if (request.getCategorieNom() != null && !request.getCategorieNom().isEmpty()) {
            categorie = categorieRepository.findByTitre(request.getCategorieNom())
                    .orElseThrow(() -> new RuntimeException("Catégorie non trouvée avec le nom: " + request.getCategorieNom()));
        } else {
            throw new RuntimeException("Vous devez fournir soit l'ID soit le nom de la catégorie");
        }

        Procedure procedure = new Procedure();
        procedure.setNom(request.getNom());
        procedure.setTitre(request.getTitre());
        procedure.setUrlVersFormulaire(request.getUrlVersFormulaire());
        procedure.setDelai(request.getDelai());
        procedure.setDescription(request.getDescription());
        procedure.setCategorie(categorie);

        // Gestion de la sous-catégorie (par ID ou par nom)
        if (request.getSousCategorieId() != null) {
            SousCategorie sousCategorie = sousCategorieRepository.findById(request.getSousCategorieId())
                    .orElseThrow(() -> new RuntimeException("Sous-catégorie non trouvée avec l'ID: " + request.getSousCategorieId()));
            procedure.setSousCategorie(sousCategorie);
        } else if (request.getSousCategorieNom() != null && !request.getSousCategorieNom().isEmpty()) {
            SousCategorie sousCategorie = sousCategorieRepository.findByTitre(request.getSousCategorieNom())
                    .orElseThrow(() -> new RuntimeException("Sous-catégorie non trouvée avec le nom: " + request.getSousCategorieNom()));
            procedure.setSousCategorie(sousCategorie);
        }

        // Gestion du coût : priorité au prix direct, sinon par ID
        if (request.getCout() != null) {
            // Créer un nouveau coût
            Cout cout = new Cout();
            cout.setNom("Coût de " + request.getNom());
            cout.setPrix(request.getCout());
            String typeMonnaie = request.getTypeMonnaie() != null ? request.getTypeMonnaie() : "FCFA";
            cout.setDescription(request.getCout() + " " + typeMonnaie);
            cout = coutRepository.save(cout);
            procedure.setCout(cout);
        } else if (request.getCoutId() != null) {
            // Utiliser un coût existant par ID
            Cout cout = coutRepository.findById(request.getCoutId())
                    .orElseThrow(() -> new RuntimeException("Coût non trouvé avec l'ID: " + request.getCoutId()));
            procedure.setCout(cout);
        }

        // Gestion du centre
        if (request.getCentreId() != null) {
            Centre centre = centreRepository.findById(request.getCentreId())
                    .orElseThrow(() -> new RuntimeException("Centre non trouvé"));
            procedure.setCentre(centre);
        }

        Procedure savedProcedure = procedureRepository.save(procedure);

        // Notifier tous les citoyens de la création
        try {
            notificationService.notifierCreationProcedure(savedProcedure);
        } catch (Exception e) {
            logger.warn("Impossible d'envoyer les notifications de création: {}", e.getMessage());
        }

        // Créer les étapes si fournies
        if (request.getEtapes() != null && !request.getEtapes().isEmpty()) {
            int niveau = 1;
            for (String etapeDescription : request.getEtapes()) {
                Etape etape = new Etape();
                etape.setNom("Étape " + niveau);
                etape.setDescription(etapeDescription);
                etape.setNiveau(niveau);
                etape.setProcedure(savedProcedure);
                etapeRepository.save(etape);
                niveau++;
            }
        }
        
        logger.info("Nouvelle procédure créée: {}", savedProcedure.getNom());

        return convertirEnResponse(savedProcedure);
    }

    /**
     * Met à jour une procédure (Admin)
     * Mise à jour partielle : seuls les champs non-null sont modifiés
     */
    public ProcedureResponse mettreAJourProcedure(Long id, ProcedureUpdateRequest request) {
        Procedure procedure = procedureRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Procédure non trouvée"));

        // Sauvegarder les anciennes valeurs pour détecter les changements
        String ancienDelai = procedure.getDelai();
        String ancienTitre = procedure.getTitre();
        String ancienNom = procedure.getNom();
        String ancienneDescription = procedure.getDescription();
        Long ancienCategorieId = procedure.getCategorie() != null ? procedure.getCategorie().getId() : null;
        Long ancienSousCategorieId = procedure.getSousCategorie() != null ? procedure.getSousCategorie().getId() : null;
        Long ancienCentreId = procedure.getCentre() != null ? procedure.getCentre().getId() : null;
        int ancienNombreEtapes = procedure.getEtapes() != null ? procedure.getEtapes().size() : 0;
        int ancienNombreDocuments = procedure.getDocumentsRequis() != null ? procedure.getDocumentsRequis().size() : 0;
        int ancienNombreLois = procedure.getLoisArticles() != null ? procedure.getLoisArticles().size() : 0;
        
        // Liste pour collecter les changements détectés
        List<String> changements = new ArrayList<>();

        // Mise à jour partielle : ne mettre à jour que les champs fournis (non-null)
        if (request.getNom() != null && !request.getNom().trim().isEmpty()) {
            String nouveauNom = request.getNom().trim();
            if (!nouveauNom.equals(ancienNom)) {
                procedure.setNom(nouveauNom);
                changements.add("Nom de la procédure modifié");
            }
        }

        if (request.getTitre() != null && !request.getTitre().trim().isEmpty()) {
            String nouveauTitre = request.getTitre().trim();
            if (!nouveauTitre.equals(ancienTitre)) {
                procedure.setTitre(nouveauTitre);
                changements.add("Titre modifié");
            }
        }

        if (request.getUrlVersFormulaire() != null) {
            procedure.setUrlVersFormulaire(request.getUrlVersFormulaire().trim().isEmpty() ? null : request.getUrlVersFormulaire().trim());
        }

        if (request.getDelai() != null && !request.getDelai().trim().isEmpty()) {
            String nouveauDelai = request.getDelai().trim();
            if (!nouveauDelai.equals(ancienDelai)) {
                procedure.setDelai(nouveauDelai);
                changements.add(String.format("Délai modifié : %s → %s", ancienDelai, nouveauDelai));
            }
        }

        if (request.getDescription() != null) {
            String nouvelleDescription = request.getDescription().trim().isEmpty() ? null : request.getDescription().trim();
            if ((ancienneDescription == null && nouvelleDescription != null) || 
                (ancienneDescription != null && !ancienneDescription.equals(nouvelleDescription))) {
                procedure.setDescription(nouvelleDescription);
                changements.add("Description mise à jour");
            }
        }

        // Gestion de la catégorie (par ID ou par nom) - mise à jour indépendante
        if (request.getCategorieId() != null) {
            if (!request.getCategorieId().equals(ancienCategorieId)) {
                Categorie categorie = categorieRepository.findById(request.getCategorieId())
                        .orElseThrow(() -> new RuntimeException("Catégorie non trouvée avec l'ID: " + request.getCategorieId()));
                procedure.setCategorie(categorie);
                changements.add(String.format("Catégorie modifiée : %s", categorie.getTitre()));
            }
        } else if (request.getCategorieNom() != null && !request.getCategorieNom().trim().isEmpty()) {
            Categorie categorie = categorieRepository.findByTitre(request.getCategorieNom().trim())
                    .orElseThrow(() -> new RuntimeException("Catégorie non trouvée avec le nom: " + request.getCategorieNom()));
            if (!categorie.getId().equals(ancienCategorieId)) {
                procedure.setCategorie(categorie);
                changements.add(String.format("Catégorie modifiée : %s", categorie.getTitre()));
            }
        }

        // Gestion de la sous-catégorie (par ID ou par nom) - mise à jour indépendante
        if (request.getSousCategorieId() != null) {
            if (!request.getSousCategorieId().equals(ancienSousCategorieId)) {
                SousCategorie sousCategorie = sousCategorieRepository.findById(request.getSousCategorieId())
                        .orElseThrow(() -> new RuntimeException("Sous-catégorie non trouvée avec l'ID: " + request.getSousCategorieId()));
                procedure.setSousCategorie(sousCategorie);
                changements.add(String.format("Sous-catégorie modifiée : %s", sousCategorie.getTitre()));
            }
        } else if (request.getSousCategorieNom() != null && !request.getSousCategorieNom().trim().isEmpty()) {
            SousCategorie sousCategorie = sousCategorieRepository.findByTitre(request.getSousCategorieNom().trim())
                    .orElseThrow(() -> new RuntimeException("Sous-catégorie non trouvée avec le nom: " + request.getSousCategorieNom()));
            if (!sousCategorie.getId().equals(ancienSousCategorieId)) {
                procedure.setSousCategorie(sousCategorie);
                changements.add(String.format("Sous-catégorie modifiée : %s", sousCategorie.getTitre()));
            }
        }
        // Si aucun des deux n'est fourni, la sous-catégorie reste inchangée

        // Gestion du coût - mise à jour indépendante
        // Priorité au prix direct (cout), sinon par ID (coutId)
        // Si cout est fourni (même 0), on met à jour/crée le coût
        if (request.getCout() != null) {
            String typeMonnaie = request.getTypeMonnaie() != null && !request.getTypeMonnaie().trim().isEmpty() 
                ? request.getTypeMonnaie().trim() : "FCFA";
            
            // Si un coût existe déjà pour cette procédure, le mettre à jour
            Cout cout;
            if (procedure.getCout() != null) {
                cout = procedure.getCout();
                Integer ancienPrixLocal = cout.getPrix();
                cout.setPrix(request.getCout());
                
                // Détecter le changement de prix
                if (!request.getCout().equals(ancienPrixLocal)) {
                    if (ancienPrixLocal != null) {
                        changements.add(String.format("Coût modifié : %d %s → %d %s", 
                            ancienPrixLocal, typeMonnaie, request.getCout(), typeMonnaie));
                    } else {
                        changements.add(String.format("Coût ajouté : %d %s", request.getCout(), typeMonnaie));
                    }
                }
                
                // Toujours mettre à jour la description pour refléter le nouveau prix
                // Si le prix a changé ou si la description est vide/null, on la met à jour
                if (!request.getCout().equals(ancienPrixLocal) || 
                    cout.getDescription() == null || 
                    cout.getDescription().isEmpty() ||
                    cout.getDescription().equals(String.valueOf(ancienPrixLocal) + " " + typeMonnaie)) {
                    String nouvelleDescription = request.getCout() + " " + typeMonnaie;
                    cout.setDescription(nouvelleDescription);
                }
                coutRepository.save(cout);
            } else {
                // Créer un nouveau coût
                cout = new Cout();
                cout.setNom("Coût de " + procedure.getNom());
                cout.setPrix(request.getCout());
                cout.setDescription(request.getCout() + " " + typeMonnaie);
                cout = coutRepository.save(cout);
                changements.add(String.format("Coût ajouté : %d %s", request.getCout(), typeMonnaie));
            }
            procedure.setCout(cout);
        } else if (request.getCoutId() != null) {
            // Utiliser un coût existant par ID
            Cout cout = coutRepository.findById(request.getCoutId())
                    .orElseThrow(() -> new RuntimeException("Coût non trouvé avec l'ID: " + request.getCoutId()));
            if (procedure.getCout() == null || !procedure.getCout().getId().equals(cout.getId())) {
                procedure.setCout(cout);
                changements.add(String.format("Coût modifié : %d %s", cout.getPrix(), 
                    cout.getDescription() != null && cout.getDescription().contains("FCFA") ? "FCFA" : ""));
            }
        }
        // Si ni cout ni coutId ne sont fournis, le coût reste inchangé

        // Gestion du centre - mise à jour indépendante
        // Si centres est fourni comme liste vide, supprimer le centre
        if (request.getCentres() != null) {
            if (request.getCentres().isEmpty()) {
                // Liste vide = supprimer le centre
                if (ancienCentreId != null) {
                    procedure.setCentre(null);
                    changements.add("Centre supprimé");
                }
            } else if (request.getCentres().size() == 1) {
                // Un seul centre dans la liste = l'associer
                Long nouveauCentreId = request.getCentres().get(0);
                if (!nouveauCentreId.equals(ancienCentreId)) {
                    Centre centre = centreRepository.findById(nouveauCentreId)
                            .orElseThrow(() -> new RuntimeException("Centre non trouvé avec l'ID: " + nouveauCentreId));
                    procedure.setCentre(centre);
                    changements.add(String.format("Centre modifié : %s", centre.getNom()));
                }
            }
            // Si plusieurs centres, on prend le premier (pour l'instant, une procédure a un seul centre)
        } else if (request.getCentreId() != null) {
            // Support de l'ancien format avec centreId unique
            if (!request.getCentreId().equals(ancienCentreId)) {
                Centre centre = centreRepository.findById(request.getCentreId())
                        .orElseThrow(() -> new RuntimeException("Centre non trouvé avec l'ID: " + request.getCentreId()));
                procedure.setCentre(centre);
                changements.add(String.format("Centre modifié : %s", centre.getNom()));
            }
        }
        // Si ni centres ni centreId ne sont fournis, le centre reste inchangé

        Procedure updatedProcedure = procedureRepository.save(procedure);

        // Gestion des étapes - mise à jour indépendante
        // Si etapes est fourni, remplace toutes les étapes existantes
        if (request.getEtapes() != null) {
            int nouveauNombreEtapes = request.getEtapes().size();
            if (nouveauNombreEtapes != ancienNombreEtapes) {
                // Supprimer les anciennes étapes
                etapeRepository.deleteAll(procedure.getEtapes());
                procedure.getEtapes().clear();
                
                // Créer les nouvelles étapes
                int niveau = 1;
                for (String etapeDescription : request.getEtapes()) {
                    if (etapeDescription != null && !etapeDescription.trim().isEmpty()) {
                        Etape etape = new Etape();
                        etape.setNom("Étape " + niveau);
                        etape.setDescription(etapeDescription.trim());
                        etape.setNiveau(niveau);
                        etape.setProcedure(updatedProcedure);
                        etapeRepository.save(etape);
                        niveau++;
                    }
                }
                changements.add(String.format("Étapes modifiées : %d → %d étapes", 
                    ancienNombreEtapes, nouveauNombreEtapes));
                logger.debug("Étapes mises à jour pour la procédure ID: {}", id);
            }
        }
        // Si etapes n'est pas fourni, les étapes restent inchangées

        // Gestion des documents requis - mise à jour indépendante
        // Si documentsRequis est fourni, remplace tous les documents existants
        if (request.getDocumentsRequis() != null) {
            int nouveauNombreDocuments = request.getDocumentsRequis().size();
            if (nouveauNombreDocuments != ancienNombreDocuments) {
                // Supprimer les anciens documents
                documentRequisRepository.deleteAll(procedure.getDocumentsRequis());
                procedure.getDocumentsRequis().clear();
                
                // Créer les nouveaux documents
                for (DocumentRequisUpdateRequest docReq : request.getDocumentsRequis()) {
                    if (docReq != null) {
                        DocumentRequis document = new DocumentRequis();
                        // Les champs obligatoires
                        document.setNom(docReq.getNom() != null && !docReq.getNom().trim().isEmpty() 
                            ? docReq.getNom().trim() : "Document requis");
                        document.setDescription(docReq.getDescription() != null 
                            ? docReq.getDescription().trim() : "");
                        document.setEstObligatoire(docReq.getEstObligatoire() != null 
                            ? docReq.getEstObligatoire() : true);
                        document.setModeleUrl(docReq.getModeleUrl() != null && !docReq.getModeleUrl().trim().isEmpty()
                            ? docReq.getModeleUrl().trim() : null);
                        document.setProcedure(updatedProcedure);
                        documentRequisRepository.save(document);
                    }
                }
                changements.add(String.format("Documents requis modifiés : %d → %d documents", 
                    ancienNombreDocuments, nouveauNombreDocuments));
                logger.debug("Documents requis mis à jour pour la procédure ID: {}", id);
            }
        }
        // Si documentsRequis n'est pas fourni, les documents restent inchangés

        // Gestion des lois/articles - mise à jour indépendante
        // Si loisArticles est fourni, remplace tous les articles existants
        if (request.getLoisArticles() != null) {
            int nouveauNombreLois = request.getLoisArticles().size();
            if (nouveauNombreLois != ancienNombreLois) {
                // Supprimer les anciens articles
                loiArticleRepository.deleteAll(procedure.getLoisArticles());
                procedure.getLoisArticles().clear();
                
                // Créer les nouveaux articles
                for (LoiArticleUpdateRequest loiReq : request.getLoisArticles()) {
                    if (loiReq != null) {
                        LoiArticle loiArticle = new LoiArticle();
                        // Les champs obligatoires
                        loiArticle.setDescription(loiReq.getDescription() != null && !loiReq.getDescription().trim().isEmpty()
                            ? loiReq.getDescription().trim() : "Article de loi");
                        loiArticle.setConsulterArticle(loiReq.getConsulterArticle() != null
                            ? loiReq.getConsulterArticle().trim() : null);
                        loiArticle.setLienAudio(loiReq.getLienAudio() != null && !loiReq.getLienAudio().trim().isEmpty()
                            ? loiReq.getLienAudio().trim() : null);
                        loiArticle.setProcedure(updatedProcedure);
                        loiArticleRepository.save(loiArticle);
                    }
                }
                changements.add(String.format("Lois/articles modifiés : %d → %d articles", 
                    ancienNombreLois, nouveauNombreLois));
                logger.debug("Lois/articles mis à jour pour la procédure ID: {}", id);
            }
        }
        // Si loisArticles n'est pas fourni, les articles restent inchangés

        // Recharger la procédure pour avoir les relations à jour
        updatedProcedure = procedureRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Procédure non trouvée après mise à jour"));

        // Envoyer des notifications si des changements importants ont été détectés
        if (!changements.isEmpty()) {
            notificationService.notifierMiseAJourProcedure(updatedProcedure, changements);
            logger.info("Procédure mise à jour: {} avec {} changement(s) détecté(s)", 
                updatedProcedure.getNom(), changements.size());
        } else {
            logger.info("Procédure mise à jour: {} (aucun changement significatif détecté)", 
                updatedProcedure.getNom());
        }

        return convertirEnResponse(updatedProcedure);
    }

    /**
     * Supprime une procédure (Admin)
     */
    public MessageResponse supprimerProcedure(Long id) {
        Procedure procedure = procedureRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Procédure non trouvée"));

        // Notifier la suppression à tous les citoyens
        try {
            notificationService.notifierSuppressionProcedure(procedure);
        } catch (Exception e) {
            logger.warn("Impossible d'envoyer les notifications de suppression: {}", e.getMessage());
        }

        procedureRepository.delete(procedure);
        
        logger.info("Procédure supprimée: {}", procedure.getNom());

        return MessageResponse.success("Procédure supprimée avec succès!");
    }

    /**
     * Convertit une entité Procedure en ProcedureResponse
     */
    private ProcedureResponse convertirEnResponse(Procedure procedure) {
        ProcedureResponse response = new ProcedureResponse();
        response.setId(procedure.getId());
        response.setNom(translationHelper.getNom(procedure));
        response.setTitre(translationHelper.getTitre(procedure));
        response.setUrlVersFormulaire(procedure.getUrlVersFormulaire());
        response.setDelai(translationHelper.getDelai(procedure));
        // ✅ Ne jamais renvoyer null pour la description - utiliser le titre comme fallback
        String description = translationHelper.getDescription(procedure);
        response.setDescription(description != null ? description : translationHelper.getTitre(procedure));
        response.setAudioUrl(procedure.getAudioUrl()); // URL vers le fichier audio de fallback
        response.setPeutEtreDelegatee(procedure.getPeutEtreDelegatee()); // Si la procédure peut être déléguée
        response.setDateCreation(procedure.getDateCreation());
        response.setDateModification(procedure.getDateModification());

        // Catégorie
        if (procedure.getCategorie() != null) {
            CategorieSimpleResponse categorieResponse = new CategorieSimpleResponse();
            categorieResponse.setId(procedure.getCategorie().getId());
            categorieResponse.setTitre(translationHelper.getTitre(procedure.getCategorie()));
            categorieResponse.setDescription(translationHelper.getDescription(procedure.getCategorie()));
            categorieResponse.setIconeUrl(procedure.getCategorie().getIconeUrl());
            response.setCategorie(categorieResponse);
        }

        // Sous-catégorie
        if (procedure.getSousCategorie() != null) {
            CategorieSimpleResponse sousCategorieResponse = new CategorieSimpleResponse();
            sousCategorieResponse.setId(procedure.getSousCategorie().getId());
            sousCategorieResponse.setTitre(translationHelper.getTitre(procedure.getSousCategorie()));
            sousCategorieResponse.setDescription(translationHelper.getDescription(procedure.getSousCategorie()));
            response.setSousCategorie(sousCategorieResponse);
        }

        // Coût
        if (procedure.getCout() != null) {
            response.setCout(procedure.getCout().getPrix());
            // Utiliser la description traduite si disponible, sinon le nom
            String coutDescription = translationHelper.getDescription(procedure.getCout());
            response.setCoutDescription(coutDescription != null ? coutDescription : procedure.getCout().getNom());
        }

        // Centre
        if (procedure.getCentre() != null) {
            response.setCentre(convertirCentreEnResponse(procedure.getCentre()));
        }

        // Étapes
        if (procedure.getEtapes() != null) {
            response.setEtapes(
                procedure.getEtapes().stream()
                    .map(this::convertirEtapeEnResponse)
                    .collect(Collectors.toSet())
            );
        }

        // Documents requis
        if (procedure.getDocumentsRequis() != null) {
            response.setDocumentsRequis(
                procedure.getDocumentsRequis().stream()
                    .map(this::convertirDocumentEnResponse)
                    .collect(Collectors.toSet())
            );
        }

        // Références légales
        if (procedure.getLoisArticles() != null) {
            response.setLoisArticles(
                procedure.getLoisArticles().stream()
                    .map(this::convertirLoiArticleEnResponse)
                    .collect(Collectors.toSet())
            );
        }

        return response;
    }

    private DocumentRequisResponse convertirDocumentEnResponse(DocumentRequis document) {
        DocumentRequisResponse response = new DocumentRequisResponse();
        response.setId(document.getId());
        response.setNom(document.getNom());
        response.setDescription(translationHelper.getDescription(document));
        response.setEstObligatoire(document.getEstObligatoire());
        response.setModeleUrl(document.getModeleUrl());
        return response;
    }


    private CentreResponse convertirCentreEnResponse(Centre centre) {
        CentreResponse response = new CentreResponse();
        response.setId(centre.getId());
        response.setNom(translationHelper.getNom(centre));
        response.setAdresse(translationHelper.getAdresse(centre));
        response.setHoraires(translationHelper.getHoraires(centre));
        response.setCoordonneesGPS(centre.getCoordonneesGPS());
        response.setTelephone(centre.getTelephone());
        response.setEmail(centre.getEmail());
        return response;
    }

    private EtapeResponse convertirEtapeEnResponse(Etape etape) {
        EtapeResponse response = new EtapeResponse();
        response.setId(etape.getId());
        response.setNom(etape.getNom());
        response.setDescription(translationHelper.getDescription(etape));
        response.setNiveau(etape.getNiveau());
        return response;
    }

    private LoiArticleResponse convertirLoiArticleEnResponse(LoiArticle loiArticle) {
        LoiArticleResponse response = new LoiArticleResponse();
        response.setId(loiArticle.getId());
        response.setDescription(translationHelper.getDescription(loiArticle));
        response.setConsulterArticle(loiArticle.getConsulterArticle());
        response.setLienAudio(loiArticle.getLienAudio());
        return response;
    }
}
