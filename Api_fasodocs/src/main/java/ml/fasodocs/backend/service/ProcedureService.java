package ml.fasodocs.backend.service;

import ml.fasodocs.backend.dto.request.ProcedureRequest;
import ml.fasodocs.backend.dto.response.*;
import ml.fasodocs.backend.entity.*;
import ml.fasodocs.backend.repository.*;
import ml.fasodocs.backend.repository.CoutRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

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

        // Gestion du coût
        if (request.getCoutId() != null) {
            Cout cout = coutRepository.findById(request.getCoutId())
                    .orElseThrow(() -> new RuntimeException("Coût non trouvé"));
            procedure.setCout(cout);
        }

        // Gestion du centre
        if (request.getCentreId() != null) {
            Centre centre = centreRepository.findById(request.getCentreId())
                    .orElseThrow(() -> new RuntimeException("Centre non trouvé"));
            procedure.setCentre(centre);
        }

        Procedure savedProcedure = procedureRepository.save(procedure);

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
     */
    public ProcedureResponse mettreAJourProcedure(Long id, ProcedureRequest request) {
        Procedure procedure = procedureRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Procédure non trouvée"));

        // Sauvegarder les anciennes valeurs pour détecter les changements
        String ancienDelai = procedure.getDelai();

        procedure.setNom(request.getNom());
        procedure.setTitre(request.getTitre());
        procedure.setUrlVersFormulaire(request.getUrlVersFormulaire());
        // Cout is handled as a separate entity, not a direct field
        procedure.setDelai(request.getDelai());
        procedure.setDescription(request.getDescription());

        // Gestion de la catégorie (par ID ou par nom)
        if (request.getCategorieId() != null) {
            Categorie categorie = categorieRepository.findById(request.getCategorieId())
                    .orElseThrow(() -> new RuntimeException("Catégorie non trouvée avec l'ID: " + request.getCategorieId()));
            procedure.setCategorie(categorie);
        } else if (request.getCategorieNom() != null && !request.getCategorieNom().isEmpty()) {
            Categorie categorie = categorieRepository.findByTitre(request.getCategorieNom())
                    .orElseThrow(() -> new RuntimeException("Catégorie non trouvée avec le nom: " + request.getCategorieNom()));
            procedure.setCategorie(categorie);
        }

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

        Procedure updatedProcedure = procedureRepository.save(procedure);

        // Envoyer des notifications si des attributs clés ont changé
        if (!ancienDelai.equals(procedure.getDelai())) {
            notificationService.notifierMiseAJourProcedure(updatedProcedure);
        }

        logger.info("Procédure mise à jour: {}", updatedProcedure.getNom());

        return convertirEnResponse(updatedProcedure);
    }

    /**
     * Supprime une procédure (Admin)
     */
    public MessageResponse supprimerProcedure(Long id) {
        Procedure procedure = procedureRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Procédure non trouvée"));

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
        response.setNom(procedure.getNom());
        response.setTitre(procedure.getTitre());
        response.setUrlVersFormulaire(procedure.getUrlVersFormulaire());
        response.setDelai(procedure.getDelai());
        // ✅ Ne jamais renvoyer null pour la description - utiliser le titre comme fallback
        response.setDescription(procedure.getDescription() != null ? procedure.getDescription() : procedure.getTitre());
        response.setDateCreation(procedure.getDateCreation());
        response.setDateModification(procedure.getDateModification());

        // Catégorie
        if (procedure.getCategorie() != null) {
            CategorieSimpleResponse categorieResponse = new CategorieSimpleResponse();
            categorieResponse.setId(procedure.getCategorie().getId());
            categorieResponse.setTitre(procedure.getCategorie().getTitre());
            categorieResponse.setDescription(procedure.getCategorie().getDescription());
            categorieResponse.setIconeUrl(procedure.getCategorie().getIconeUrl());
            response.setCategorie(categorieResponse);
        }

        // Sous-catégorie
        if (procedure.getSousCategorie() != null) {
            CategorieSimpleResponse sousCategorieResponse = new CategorieSimpleResponse();
            sousCategorieResponse.setId(procedure.getSousCategorie().getId());
            sousCategorieResponse.setTitre(procedure.getSousCategorie().getTitre());
            sousCategorieResponse.setDescription(procedure.getSousCategorie().getDescription());
            response.setSousCategorie(sousCategorieResponse);
        }

        // Coût
        if (procedure.getCout() != null) {
            response.setCout(procedure.getCout().getPrix());
            response.setCoutDescription(procedure.getCout().getNom());
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
        response.setDescription(document.getDescription());
        response.setEstObligatoire(document.getEstObligatoire());
        response.setModeleUrl(document.getModeleUrl());
        return response;
    }


    private CentreResponse convertirCentreEnResponse(Centre centre) {
        CentreResponse response = new CentreResponse();
        response.setId(centre.getId());
        response.setNom(centre.getNom());
        response.setAdresse(centre.getAdresse());
        response.setHoraires(centre.getHoraires());
        response.setCoordonneesGPS(centre.getCoordonneesGPS());
        response.setTelephone(centre.getTelephone());
        response.setEmail(centre.getEmail());
        return response;
    }

    private EtapeResponse convertirEtapeEnResponse(Etape etape) {
        EtapeResponse response = new EtapeResponse();
        response.setId(etape.getId());
        response.setNom(etape.getNom());
        response.setDescription(etape.getDescription());
        response.setNiveau(etape.getNiveau());
        return response;
    }

    private LoiArticleResponse convertirLoiArticleEnResponse(LoiArticle loiArticle) {
        LoiArticleResponse response = new LoiArticleResponse();
        response.setId(loiArticle.getId());
        response.setDescription(loiArticle.getDescription());
        response.setConsulterArticle(loiArticle.getConsulterArticle());
        response.setLienAudio(loiArticle.getLienAudio());
        return response;
    }
}
