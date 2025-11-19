package ml.fasodocs.backend.service;

import ml.fasodocs.backend.dto.request.CreerDemandeServiceRequest;
import ml.fasodocs.backend.dto.response.DemandeServiceResponse;
import ml.fasodocs.backend.dto.response.MessageResponse;
import ml.fasodocs.backend.dto.response.TarifServiceResponse;
import ml.fasodocs.backend.entity.Citoyen;
import ml.fasodocs.backend.entity.DemandeService;
import ml.fasodocs.backend.entity.Procedure;
import ml.fasodocs.backend.repository.CitoyenRepository;
import ml.fasodocs.backend.repository.DemandeServiceRepository;
import ml.fasodocs.backend.repository.ProcedureRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * Service pour la gestion des services de procédures
 */
@Service
@Transactional
public class ServiceService {

    private static final Logger logger = LoggerFactory.getLogger(ServiceService.class);

    @Autowired
    private DemandeServiceRepository demandeServiceRepository;

    @Autowired
    private ProcedureRepository procedureRepository;

    @Autowired
    private CitoyenRepository citoyenRepository;

    @Autowired
    private NotificationService notificationService;

    /**
     * Tarifs de service par commune (hors coût légal)
     */
    private static final Map<String, Double> TARIFS_PAR_COMMUNE;
    
    static {
        Map<String, Double> tarifs = new java.util.HashMap<>();
        // Commune 1, 6, Kanadjiguila, Dialakorodji, Niamana
        tarifs.put("Commune I", 3000.0);
        tarifs.put("Commune 1", 3000.0);
        tarifs.put("Commune VI", 3000.0);
        tarifs.put("Commune 6", 3000.0);
        tarifs.put("Kanadjiguila", 3000.0);
        tarifs.put("Dialakorodji", 3000.0);
        tarifs.put("Niamana", 3000.0);
        // Commune 2, 3, 4, 5
        tarifs.put("Commune II", 2500.0);
        tarifs.put("Commune 2", 2500.0);
        tarifs.put("Commune III", 2500.0);
        tarifs.put("Commune 3", 2500.0);
        tarifs.put("Commune IV", 2500.0);
        tarifs.put("Commune 4", 2500.0);
        tarifs.put("Commune V", 2500.0);
        tarifs.put("Commune 5", 2500.0);
        // Kati
        tarifs.put("Kati", 4000.0);
        // Katibougou
        tarifs.put("Katibougou", 5000.0);
        // Banguineda
        tarifs.put("Banguineda", 3500.0);
        TARIFS_PAR_COMMUNE = java.util.Collections.unmodifiableMap(tarifs);
    }

    /**
     * Calcule le tarif de service selon la commune
     * 
     * @param commune Le nom de la commune
     * @return Le tarif de service, ou null si la commune n'est pas dans la liste
     * @throws RuntimeException si la commune n'est pas définie dans les tarifs
     */
    public Double calculerTarifService(String commune) {
        if (commune == null || commune.trim().isEmpty()) {
            throw new RuntimeException("La commune est obligatoire");
        }
        
        // Normaliser le nom de la commune
        String communeNormalisee = normaliserCommune(commune);
        
        Double tarif = TARIFS_PAR_COMMUNE.get(communeNormalisee);
        
        if (tarif == null) {
            logger.warn("Commune non trouvée dans la liste des tarifs: {}. Tarif à définir.", commune);
            throw new RuntimeException("Tarif non défini pour la commune: " + commune + ". Veuillez contacter l'administration.");
        }
        
        return tarif;
    }

    /**
     * Normalise le nom de la commune pour la recherche
     */
    private String normaliserCommune(String commune) {
        if (commune == null) {
            return null;
        }
        
        String normalisee = commune.trim();
        
        // Gérer les variations communes
        if (normalisee.equalsIgnoreCase("commune 1") || normalisee.equalsIgnoreCase("commune i")) {
            return "Commune I";
        }
        if (normalisee.equalsIgnoreCase("commune 2") || normalisee.equalsIgnoreCase("commune ii")) {
            return "Commune II";
        }
        if (normalisee.equalsIgnoreCase("commune 3") || normalisee.equalsIgnoreCase("commune iii")) {
            return "Commune III";
        }
        if (normalisee.equalsIgnoreCase("commune 4") || normalisee.equalsIgnoreCase("commune iv")) {
            return "Commune IV";
        }
        if (normalisee.equalsIgnoreCase("commune 5") || normalisee.equalsIgnoreCase("commune v")) {
            return "Commune V";
        }
        if (normalisee.equalsIgnoreCase("commune 6") || normalisee.equalsIgnoreCase("commune vi")) {
            return "Commune VI";
        }
        
        // Chercher dans la map (insensible à la casse)
        for (String key : TARIFS_PAR_COMMUNE.keySet()) {
            if (key.equalsIgnoreCase(normalisee)) {
                return key;
            }
        }
        
        return normalisee; // Retourner tel quel si non trouvé
    }

    /**
     * Récupère le tarif de service pour une procédure
     */
    public TarifServiceResponse obtenirTarifService(Long procedureId, String commune) {
        Procedure procedure = procedureRepository.findById(procedureId)
                .orElseThrow(() -> new RuntimeException("Procédure non trouvée"));

        if (!Boolean.TRUE.equals(procedure.getPeutEtreDelegatee())) {
            throw new RuntimeException("Cette procédure ne peut pas être déléguée");
        }

        // Vérifier si la commune est dans la liste des tarifs définis
        Double tarifServiceDouble;
        try {
            tarifServiceDouble = calculerTarifService(commune);
        } catch (RuntimeException e) {
            // Si la commune n'est pas définie, retourner une erreur claire
            throw new RuntimeException("Tarif non défini pour la commune '" + commune + "'. Veuillez contacter l'administration pour obtenir un devis personnalisé.");
        }

        BigDecimal tarifService = BigDecimal.valueOf(tarifServiceDouble);
        BigDecimal coutLegal = procedure.getCout() != null 
            ? BigDecimal.valueOf(procedure.getCout().getPrix()) 
            : null;
        BigDecimal tarifTotal = tarifService.add(coutLegal != null ? coutLegal : BigDecimal.ZERO);

        return TarifServiceResponse.builder()
                .procedureId(procedure.getId())
                .procedureNom(procedure.getNom())
                .tarifService(tarifService)
                .coutLegal(coutLegal)
                .tarifTotal(tarifTotal)
                .commune(commune)
                .description("Service complet incluant la prise en charge de votre procédure, le suivi des démarches et la récupération des documents.")
                .delaiEstime(procedure.getDelai())
                .build();
    }

    /**
     * Crée une nouvelle demande de service
     */
    public DemandeServiceResponse creerDemandeService(CreerDemandeServiceRequest request) {
        // Récupérer le citoyen connecté
        Citoyen citoyen = getCitoyenConnecte();
        if (citoyen == null) {
            throw new RuntimeException("Utilisateur non connecté");
        }

        // Vérifier la procédure
        Procedure procedure = procedureRepository.findById(request.getProcedureId())
                .orElseThrow(() -> new RuntimeException("Procédure non trouvée"));

        if (!Boolean.TRUE.equals(procedure.getPeutEtreDelegatee())) {
            throw new RuntimeException("Cette procédure ne peut pas être déléguée");
        }

        if (!request.getAccepteTarif()) {
            throw new RuntimeException("Vous devez accepter le tarif pour continuer");
        }

        // Calculer les tarifs
        Double tarifServiceDouble;
        try {
            tarifServiceDouble = calculerTarifService(request.getCommune());
        } catch (RuntimeException e) {
            throw new RuntimeException("Impossible de créer la demande: " + e.getMessage());
        }
        
        BigDecimal tarifService = BigDecimal.valueOf(tarifServiceDouble);
        BigDecimal coutLegal = procedure.getCout() != null 
            ? BigDecimal.valueOf(procedure.getCout().getPrix()) 
            : null;
        BigDecimal tarifTotal = tarifService.add(coutLegal != null ? coutLegal : BigDecimal.ZERO);

        // Créer la demande
        DemandeService demande = new DemandeService();
        demande.setCitoyen(citoyen);
        demande.setProcedure(procedure);
        demande.setStatut(DemandeService.StatutDemande.EN_ATTENTE);
        demande.setTarif(tarifTotal);
        demande.setTarifService(tarifService);
        demande.setCoutLegal(coutLegal);
        demande.setCommune(request.getCommune());
        demande.setQuartier(request.getQuartier());
        demande.setTelephoneContact(request.getTelephoneContact() != null ? request.getTelephoneContact() : citoyen.getTelephone());
        demande.setDateSouhaitee(request.getDateSouhaitee());
        demande.setCommentaires(request.getCommentaires());

        DemandeService savedDemande = demandeServiceRepository.save(demande);

        logger.info("Nouvelle demande de service créée: ID={}, Procédure={}, Citoyen={}", 
                savedDemande.getId(), procedure.getNom(), citoyen.getNom());

        // Envoyer des notifications
        try {
            notificationService.notifierCreationDemandeService(savedDemande);
        } catch (Exception e) {
            logger.warn("Impossible d'envoyer les notifications: {}", e.getMessage());
        }

        return convertirEnResponse(savedDemande);
    }

    /**
     * Récupère les demandes de l'utilisateur connecté
     */
    public List<DemandeServiceResponse> obtenirMesDemandes() {
        Citoyen citoyen = getCitoyenConnecte();
        if (citoyen == null) {
            throw new RuntimeException("Utilisateur non connecté");
        }

        return demandeServiceRepository.findByCitoyenIdOrderByDateCreationDesc(citoyen.getId())
                .stream()
                .map(this::convertirEnResponse)
                .collect(Collectors.toList());
    }

    /**
     * Récupère une demande spécifique
     */
    public DemandeServiceResponse obtenirDemandeParId(Long id) {
        DemandeService demande = demandeServiceRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Demande non trouvée"));

        // Vérifier que l'utilisateur est propriétaire ou admin
        Citoyen citoyen = getCitoyenConnecte();
        if (citoyen == null) {
            throw new RuntimeException("Utilisateur non connecté");
        }

        if (!demande.getCitoyen().getId().equals(citoyen.getId()) && 
            !citoyen.getRole().equals(Citoyen.RoleCitoyen.ADMIN)) {
            throw new RuntimeException("Vous n'avez pas accès à cette demande");
        }

        return convertirEnResponse(demande);
    }

    /**
     * Annule une demande (utilisateur uniquement)
     * Note: L'annulation n'est possible que si la demande est EN_ATTENTE
     * On ne change pas le statut mais on ajoute un commentaire d'annulation
     */
    public MessageResponse annulerDemande(Long id, String raison) {
        DemandeService demande = demandeServiceRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Demande non trouvée"));

        Citoyen citoyen = getCitoyenConnecte();
        if (citoyen == null || !demande.getCitoyen().getId().equals(citoyen.getId())) {
            throw new RuntimeException("Vous ne pouvez annuler que vos propres demandes");
        }

        if (demande.getStatut() != DemandeService.StatutDemande.EN_ATTENTE) {
            throw new RuntimeException("Seules les demandes en attente peuvent être annulées");
        }

        // Ajouter un commentaire d'annulation
        if (raison != null && !raison.trim().isEmpty()) {
            demande.setCommentaires((demande.getCommentaires() != null ? demande.getCommentaires() + "\n\n" : "") + 
                    "ANNULATION: " + raison);
        } else {
            demande.setCommentaires((demande.getCommentaires() != null ? demande.getCommentaires() + "\n\n" : "") + 
                    "ANNULATION: Demande annulée par l'utilisateur");
        }

        demandeServiceRepository.save(demande);

        logger.info("Demande annulée (commentaire): ID={}", id);

        return MessageResponse.success("Demande annulée avec succès. L'admin sera informé.");
    }

    /**
     * Récupère le citoyen connecté
     */
    private Citoyen getCitoyenConnecte() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || !authentication.isAuthenticated()) {
            return null;
        }

        String username = authentication.getName();
        return citoyenRepository.findByTelephone(username)
                .orElse(citoyenRepository.findByEmail(username).orElse(null));
    }

    /**
     * Convertit une entité en DTO
     */
    private DemandeServiceResponse convertirEnResponse(DemandeService demande) {
        DemandeServiceResponse.ProcedureSimpleResponse procedureResponse = 
                DemandeServiceResponse.ProcedureSimpleResponse.builder()
                        .id(demande.getProcedure().getId())
                        .nom(demande.getProcedure().getNom())
                        .titre(demande.getProcedure().getTitre())
                        .build();

        DemandeServiceResponse.CitoyenSimpleResponse agentResponse = null;
        if (demande.getAgent() != null) {
            agentResponse = DemandeServiceResponse.CitoyenSimpleResponse.builder()
                    .id(demande.getAgent().getId())
                    .nom(demande.getAgent().getNom())
                    .prenom(demande.getAgent().getPrenom())
                    .telephone(demande.getAgent().getTelephone())
                    .build();
        }

        return DemandeServiceResponse.builder()
                .id(demande.getId())
                .procedure(procedureResponse)
                .statut(demande.getStatut().name())
                .tarif(demande.getTarif())
                .tarifService(demande.getTarifService())
                .coutLegal(demande.getCoutLegal())
                .commune(demande.getCommune())
                .quartier(demande.getQuartier())
                .telephoneContact(demande.getTelephoneContact())
                .dateSouhaitee(demande.getDateSouhaitee())
                .commentaires(demande.getCommentaires())
                .notesAgent(demande.getNotesAgent())
                .agent(agentResponse)
                .dateAcceptation(demande.getDateAcceptation())
                .dateDebut(demande.getDateDebut())
                .dateFin(demande.getDateFin())
                .dateCreation(demande.getDateCreation())
                .dateModification(demande.getDateModification())
                .build();
    }

    /**
     * Récupère toutes les demandes de service (Admin uniquement)
     */
    public List<DemandeServiceResponse> obtenirToutesLesDemandes(String statut) {
        Citoyen citoyen = getCitoyenConnecte();
        if (citoyen == null || !citoyen.getRole().equals(Citoyen.RoleCitoyen.ADMIN)) {
            throw new RuntimeException("Accès refusé. Admin uniquement.");
        }

        List<DemandeService> demandes;
        if (statut != null && !statut.trim().isEmpty()) {
            try {
                DemandeService.StatutDemande statutEnum = DemandeService.StatutDemande.valueOf(statut.toUpperCase());
                demandes = demandeServiceRepository.findByStatut(statutEnum);
            } catch (IllegalArgumentException e) {
                throw new RuntimeException("Statut invalide: " + statut);
            }
        } else {
            demandes = demandeServiceRepository.findAll();
        }

        return demandes.stream()
                .sorted((d1, d2) -> d2.getDateCreation().compareTo(d1.getDateCreation())) // Plus récentes en premier
                .map(this::convertirEnResponse)
                .collect(Collectors.toList());
    }

    /**
     * Modifie le statut d'une demande (Admin uniquement)
     * Transitions possibles : EN_ATTENTE -> EN_COURS -> TERMINEE
     */
    public DemandeServiceResponse modifierStatutDemande(Long demandeId, DemandeService.StatutDemande nouveauStatut, String notes) {
        Citoyen admin = getCitoyenConnecte();
        if (admin == null || !admin.getRole().equals(Citoyen.RoleCitoyen.ADMIN)) {
            throw new RuntimeException("Accès refusé. Admin uniquement.");
        }

        DemandeService demande = demandeServiceRepository.findById(demandeId)
                .orElseThrow(() -> new RuntimeException("Demande non trouvée"));

        DemandeService.StatutDemande ancienStatut = demande.getStatut();
        
        // Valider la transition de statut
        if (!estTransitionValide(ancienStatut, nouveauStatut)) {
            throw new RuntimeException(
                String.format("Transition de statut invalide: %s -> %s. Transitions possibles: EN_ATTENTE -> EN_COURS -> TERMINEE", 
                    ancienStatut, nouveauStatut)
            );
        }

        demande.setStatut(nouveauStatut);

        // Mettre à jour les dates selon le statut
        if (nouveauStatut == DemandeService.StatutDemande.EN_COURS && demande.getDateDebut() == null) {
            demande.setDateDebut(java.time.LocalDateTime.now());
        } else if (nouveauStatut == DemandeService.StatutDemande.TERMINEE && demande.getDateFin() == null) {
            demande.setDateFin(java.time.LocalDateTime.now());
        }

        if (notes != null && !notes.trim().isEmpty()) {
            String notesExistantes = demande.getNotesAgent();
            if (notesExistantes != null && !notesExistantes.trim().isEmpty()) {
                demande.setNotesAgent(notesExistantes + "\n\n" + notes);
            } else {
                demande.setNotesAgent(notes);
            }
        }

        demandeServiceRepository.save(demande);

        logger.info("Statut modifié: Demande ID={}, {} -> {}", demandeId, ancienStatut, nouveauStatut);

        // Envoyer notification au client
        try {
            notificationService.notifierChangementStatutDemandeService(demande, ancienStatut);
        } catch (Exception e) {
            logger.warn("Impossible d'envoyer la notification: {}", e.getMessage());
        }

        return convertirEnResponse(demande);
    }

    /**
     * Vérifie si une transition de statut est valide
     */
    private boolean estTransitionValide(DemandeService.StatutDemande ancienStatut, DemandeService.StatutDemande nouveauStatut) {
        // Pas de changement
        if (ancienStatut == nouveauStatut) {
            return true;
        }
        
        // Transitions valides :
        // EN_ATTENTE -> EN_COURS
        // EN_ATTENTE -> TERMINEE (cas spécial si on veut terminer directement)
        // EN_COURS -> TERMINEE
        switch (ancienStatut) {
            case EN_ATTENTE:
                return nouveauStatut == DemandeService.StatutDemande.EN_COURS 
                    || nouveauStatut == DemandeService.StatutDemande.TERMINEE;
            case EN_COURS:
                return nouveauStatut == DemandeService.StatutDemande.TERMINEE;
            case TERMINEE:
                return false; // Une fois terminée, on ne peut plus changer
            default:
                return false;
        }
    }
}

