package ml.fasodocs.backend.service;

import ml.fasodocs.backend.dto.response.NotificationResponse;
import ml.fasodocs.backend.entity.Citoyen;
import ml.fasodocs.backend.entity.DemandeService;
import ml.fasodocs.backend.entity.Notification;
import ml.fasodocs.backend.entity.Procedure;
import ml.fasodocs.backend.repository.CitoyenRepository;
import ml.fasodocs.backend.repository.NotificationRepository;
import ml.fasodocs.backend.security.UserDetailsImpl;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

/**
 * Service pour la gestion des notifications
 */
@Service
@Transactional
public class NotificationService {

    private static final Logger logger = LoggerFactory.getLogger(NotificationService.class);

    @Autowired
    private NotificationRepository notificationRepository;

    @Autowired
    private CitoyenRepository citoyenRepository;

    @Autowired
    private EmailService emailService;


    /**
     * Récupère toutes les notifications du citoyen connecté
     */
    public List<NotificationResponse> obtenirNotificationsCitoyen() {
        Citoyen citoyen = getCitoyenConnecte();
        
        return notificationRepository.findByCitoyenIdOrderByDateEnvoiDesc(citoyen.getId()).stream()
                .map(this::convertirEnResponse)
                .collect(Collectors.toList());
    }

    /**
     * Récupère les notifications non lues du citoyen connecté
     */
    public List<NotificationResponse> obtenirNotificationsNonLues() {
        Citoyen citoyen = getCitoyenConnecte();
        
        return notificationRepository.findByCitoyenIdAndEstLueFalseOrderByDateEnvoiDesc(citoyen.getId()).stream()
                .map(this::convertirEnResponse)
                .collect(Collectors.toList());
    }

    /**
     * Compte les notifications non lues
     */
    public Long compterNotificationsNonLues() {
        Citoyen citoyen = getCitoyenConnecte();
        return notificationRepository.countByCitoyenIdAndEstLueFalse(citoyen.getId());
    }

    /**
     * Marque une notification comme lue
     */
    public NotificationResponse marquerCommeLue(Long notificationId) {
        Notification notification = notificationRepository.findById(notificationId)
                .orElseThrow(() -> new RuntimeException("Notification non trouvée"));
        
        notification.marquerLue();
        notificationRepository.save(notification);
        
        return convertirEnResponse(notification);
    }

    /**
     * Marque toutes les notifications comme lues
     */
    public void marquerToutesCommeLues() {
        Citoyen citoyen = getCitoyenConnecte();
        List<Notification> notifications = notificationRepository
                .findByCitoyenIdAndEstLueFalseOrderByDateEnvoiDesc(citoyen.getId());
        
        notifications.forEach(n -> n.marquerLue());
        notificationRepository.saveAll(notifications);
    }

    /**
     * Notifie tous les citoyens d'une mise à jour de procédure
     */
    public void notifierMiseAJourProcedure(Procedure procedure) {
        notifierMiseAJourProcedure(procedure, null);
    }

    /**
     * Notifie tous les citoyens d'une mise à jour de procédure avec détails des changements
     */
    public void notifierMiseAJourProcedure(Procedure procedure, List<String> changements) {
        List<Citoyen> citoyens = citoyenRepository.findAllActifs();
        
        // Construire le message de notification
        StringBuilder contenuBuilder = new StringBuilder();
        contenuBuilder.append(String.format("La procédure '%s' a été mise à jour.", procedure.getTitre()));
        
        if (changements != null && !changements.isEmpty()) {
            contenuBuilder.append("\n\nModifications apportées :");
            for (String changement : changements) {
                contenuBuilder.append("\n• ").append(changement);
            }
        } else {
            // Message par défaut si aucun détail n'est fourni
            contenuBuilder.append(String.format("\n\nNouveau délai: %s", procedure.getDelai()));
            if (procedure.getCout() != null) {
                contenuBuilder.append(String.format("\nCoût: %d %s", 
                    procedure.getCout().getPrix(), 
                    procedure.getCout().getDescription() != null && procedure.getCout().getDescription().contains("FCFA") ? "FCFA" : ""));
            }
        }
        
        String contenu = contenuBuilder.toString();
        
        for (Citoyen citoyen : citoyens) {
            // Créer la notification en base
            Notification notification = new Notification();
            notification.setContenu(contenu);
            notification.setType("MISE_A_JOUR");
            notification.setCitoyen(citoyen);
            notification.setProcedure(procedure);
            notificationRepository.save(notification);
        }
        
        logger.info("Notifications de mise à jour envoyées pour la procédure: {} ({} changements détectés)", 
            procedure.getNom(), changements != null ? changements.size() : 0);
    }

    /**
     * Notifie tous les citoyens de la création d'une nouvelle procédure
     */
    public void notifierCreationProcedure(Procedure procedure) {
        List<Citoyen> citoyens = citoyenRepository.findAllActifs();

        String contenu = String.format(
                "Nouvelle procédure publiée: '%s' — %s",
                procedure.getTitre(),
                procedure.getDescription() != null ? procedure.getDescription() : ""
        );

        for (Citoyen citoyen : citoyens) {
            Notification notification = new Notification();
            notification.setContenu(contenu);
            notification.setType("INFO");
            notification.setCitoyen(citoyen);
            notification.setProcedure(procedure);
            notificationRepository.save(notification);
        }

        logger.info("Notifications de création envoyées pour la procédure: {}", procedure.getNom());
    }

    /**
     * Notifie tous les citoyens de la suppression d'une procédure
     */
    public void notifierSuppressionProcedure(Procedure procedure) {
        List<Citoyen> citoyens = citoyenRepository.findAllActifs();

        String contenu = String.format(
                "La procédure '%s' a été supprimée.",
                procedure.getTitre()
        );

        for (Citoyen citoyen : citoyens) {
            Notification notification = new Notification();
            notification.setContenu(contenu);
            notification.setType("ALERTE");
            notification.setCitoyen(citoyen);
            notification.setProcedure(null); // la procédure n'existera plus
            notificationRepository.save(notification);
        }

        logger.info("Notifications de suppression envoyées pour la procédure supprimée: {}", procedure.getNom());
    }

    /**
     * Envoie une notification à un citoyen spécifique
     */
    public void envoyerNotification(Long citoyenId, String contenu, String type, Procedure procedure) {
        Citoyen citoyen = citoyenRepository.findById(citoyenId)
                .orElseThrow(() -> new RuntimeException("Citoyen non trouvé"));
        
        Notification notification = new Notification();
        notification.setContenu(contenu);
        notification.setType(type);
        notification.setCitoyen(citoyen);
        notification.setProcedure(procedure);
        notificationRepository.save(notification);
        
        // Notification en base de données uniquement
        
        logger.info("Notification envoyée au citoyen: {} {}", citoyen.getNom(), citoyen.getPrenom());
    }

    /**
     * Notifie la création d'une demande de service
     */
    public void notifierCreationDemandeService(DemandeService demande) {
        // Notification au client
        String contenuClient = String.format(
                "Votre demande de service pour '%s' a été soumise avec succès. Numéro de demande: #%d",
                demande.getProcedure().getNom(),
                demande.getId()
        );
        
        Notification notificationClient = new Notification();
        notificationClient.setContenu(contenuClient);
        notificationClient.setType("INFO");
        notificationClient.setCitoyen(demande.getCitoyen());
        notificationClient.setProcedure(demande.getProcedure());
        notificationRepository.save(notificationClient);

        // Notification aux admins (dans la base de données)
        List<Citoyen> admins = citoyenRepository.findByRole(Citoyen.RoleCitoyen.ADMIN);
        String contenuAdmin = String.format(
                "Nouvelle demande de service pour '%s' - Client: %s %s - Commune: %s - Tarif: %.0f FCFA",
                demande.getProcedure().getNom(),
                demande.getCitoyen().getPrenom(),
                demande.getCitoyen().getNom(),
                demande.getCommune(),
                demande.getTarif()
        );

        for (Citoyen admin : admins) {
            // Notification dans la base de données
            Notification notificationAdmin = new Notification();
            notificationAdmin.setContenu(contenuAdmin);
            notificationAdmin.setType("ALERTE");
            notificationAdmin.setCitoyen(admin);
            notificationAdmin.setProcedure(demande.getProcedure());
            notificationRepository.save(notificationAdmin);

            // Envoi d'email à l'admin (si l'admin a un email)
            if (admin.getEmail() != null && !admin.getEmail().trim().isEmpty()) {
                try {
                    String sujetEmail = "🔔 Nouvelle demande de service - FasoDocs";
                    String contenuEmail = String.format(
                            "Bonjour %s %s,\n\n" +
                            "Une nouvelle demande de service a été soumise sur FasoDocs.\n\n" +
                            "📋 Détails de la demande:\n" +
                            "   • Numéro de demande: #%d\n" +
                            "   • Procédure: %s\n" +
                            "   • Client: %s %s\n" +
                            "   • Téléphone client: %s\n" +
                            "   • Commune: %s\n" +
                            "   • Quartier: %s\n" +
                            "   • Tarif total: %.0f FCFA\n" +
                            "   • Tarif service: %.0f FCFA\n" +
                            "   • Coût légal: %s\n" +
                            "   • Date souhaitée: %s\n" +
                            "   • Date de création: %s\n" +
                            "   • Statut: EN ATTENTE\n\n" +
                            "%s\n\n" +
                            "🔗 Pour gérer cette demande:\n" +
                            "   • Connectez-vous au tableau de bord admin\n" +
                            "   • Accédez à la section services\n" +
                            "   • Consultez la demande #%d\n\n" +
                            "Merci de traiter cette demande dans les plus brefs délais.\n\n" +
                            "Cordialement,\n" +
                            "L'équipe FasoDocs\n\n" +
                            "---\n" +
                            "Cet email a été envoyé automatiquement, merci de ne pas y répondre.",
                            admin.getPrenom() != null ? admin.getPrenom() : "Admin",
                            admin.getNom() != null ? admin.getNom() : "",
                            demande.getId(),
                            demande.getProcedure().getNom(),
                            demande.getCitoyen().getPrenom() != null ? demande.getCitoyen().getPrenom() : "",
                            demande.getCitoyen().getNom() != null ? demande.getCitoyen().getNom() : "",
                            demande.getCitoyen().getTelephone() != null ? demande.getCitoyen().getTelephone() : "Non renseigné",
                            demande.getCommune(),
                            demande.getQuartier() != null && !demande.getQuartier().trim().isEmpty() ? demande.getQuartier() : "Non renseigné",
                            demande.getTarif(),
                            demande.getTarifService(),
                            demande.getCoutLegal() != null ? String.format("%.0f FCFA", demande.getCoutLegal()) : "Non applicable",
                            demande.getDateSouhaitee() != null ? demande.getDateSouhaitee().toString() : "Non spécifiée",
                            demande.getDateCreation() != null ? demande.getDateCreation().toString() : "Non disponible",
                            demande.getCommentaires() != null && !demande.getCommentaires().trim().isEmpty() 
                                ? "📝 Commentaires du client:\n   " + demande.getCommentaires().replace("\n", "\n   ")
                                : "",
                            demande.getId()
                    );

                    emailService.envoyerNotificationEmail(admin.getEmail(), sujetEmail, contenuEmail);
                    logger.info("Email de service envoyé à l'admin: {}", admin.getEmail());
                } catch (Exception e) {
                    logger.error("Erreur lors de l'envoi de l'email à l'admin {}: {}", admin.getEmail(), e.getMessage());
                }
            }
        }

        logger.info("Notifications et emails de service envoyés pour la demande: {}", demande.getId());
    }

    /**
     * Notifie un changement de statut d'une demande de service
     */
    public void notifierChangementStatutDemandeService(DemandeService demande, DemandeService.StatutDemande ancienStatut) {
        String statutLibelle = getLibelleStatut(demande.getStatut());
        String ancienStatutLibelle = getLibelleStatut(ancienStatut);
        
        String contenu;
        String type;
        
        // Personnaliser le message selon le nouveau statut
        switch (demande.getStatut()) {
            case EN_COURS:
                contenu = String.format(
                        "Votre demande de service pour '%s' est maintenant en cours de traitement. Numéro de demande: #%d",
                        demande.getProcedure().getNom(),
                        demande.getId()
                );
                type = "INFO";
                break;
            case TERMINEE:
                contenu = String.format(
                        "Votre demande de service pour '%s' est terminée. Vous pouvez récupérer vos documents. Numéro de demande: #%d",
                        demande.getProcedure().getNom(),
                        demande.getId()
                );
                type = "SUCCESS";
                break;
            default:
                contenu = String.format(
                        "Le statut de votre demande de service pour '%s' a changé: %s → %s. Numéro de demande: #%d",
                        demande.getProcedure().getNom(),
                        ancienStatutLibelle,
                        statutLibelle,
                        demande.getId()
                );
                type = "INFO";
        }
        
        Notification notification = new Notification();
        notification.setContenu(contenu);
        notification.setType(type);
        notification.setCitoyen(demande.getCitoyen());
        notification.setProcedure(demande.getProcedure());
        notificationRepository.save(notification);

        logger.info("Notification de changement de statut envoyée pour la demande: {}", demande.getId());
    }

    /**
     * Retourne le libellé d'un statut
     */
    private String getLibelleStatut(DemandeService.StatutDemande statut) {
        switch (statut) {
            case EN_ATTENTE: return "En attente";
            case EN_COURS: return "En cours";
            case TERMINEE: return "Terminée";
            default: return statut.name();
        }
    }

    /**
     * Récupère le citoyen connecté
     */
    private Citoyen getCitoyenConnecte() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        UserDetailsImpl userDetails = (UserDetailsImpl) authentication.getPrincipal();
        
        return citoyenRepository.findById(userDetails.getId())
                .orElseThrow(() -> new RuntimeException("Citoyen non trouvé"));
    }

    /**
     * Convertit une notification en NotificationResponse
     */
    private NotificationResponse convertirEnResponse(Notification notification) {
        NotificationResponse response = new NotificationResponse();
        response.setId(notification.getId());
        response.setContenu(notification.getContenu());
        response.setDateEnvoi(notification.getDateEnvoi());
        response.setEstLue(notification.getEstLue());
        response.setType(notification.getType());
        
        if (notification.getProcedure() != null) {
            response.setProcedureId(notification.getProcedure().getId());
            response.setProcedureNom(notification.getProcedure().getNom());
        }
        
        return response;
    }
}
