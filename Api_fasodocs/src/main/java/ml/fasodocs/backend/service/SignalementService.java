package ml.fasodocs.backend.service;

import ml.fasodocs.backend.dto.request.ModifierSignalementRequest;
import ml.fasodocs.backend.dto.request.SignalementRequest;
import ml.fasodocs.backend.dto.response.MessageResponse;
import ml.fasodocs.backend.dto.response.SignalementResponse;
import ml.fasodocs.backend.dto.response.SignalementSimpleResponse;
import ml.fasodocs.backend.entity.Citoyen;
import ml.fasodocs.backend.entity.Procedure;
import ml.fasodocs.backend.entity.Signalement;
import ml.fasodocs.backend.repository.CitoyenRepository;
import ml.fasodocs.backend.repository.ProcedureRepository;
import ml.fasodocs.backend.repository.SignalementRepository;
import ml.fasodocs.backend.security.UserDetailsImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

/**
 * Service pour la gestion des signalements
 */
@Service
public class SignalementService {

    @Autowired
    private SignalementRepository signalementRepository;

    @Autowired
    private CitoyenRepository citoyenRepository;

    @Autowired
    private ProcedureRepository procedureRepository;

    /**
     * Crée un nouveau signalement
     */
    public MessageResponse creerSignalement(SignalementRequest request) {
        try {
            // Validate and set defaults for the request
            request.validateAndSetDefaults();
            
            // Récupérer le citoyen connecté
            Citoyen citoyen = getCitoyenConnecte();
            if (citoyen == null) {
                return MessageResponse.error("Utilisateur non connecté");
            }

            // Vérifier si la procédure existe (si spécifiée)
            Procedure procedure = null;
            if (request.getProcedureId() != null) {
                Optional<Procedure> procedureOpt = procedureRepository.findById(request.getProcedureId());
                if (procedureOpt.isEmpty()) {
                    return MessageResponse.error("Procédure non trouvée");
                }
                procedure = procedureOpt.get();
            }

            // Créer le signalement
            Signalement signalement = new Signalement();
            signalement.setTitre(request.getTitre());
            signalement.setDescription(request.getDescription());
            signalement.setType(request.getType());
            signalement.setStructure(request.getStructure());
            signalement.setCitoyen(citoyen);
            signalement.setProcedure(procedure);

            signalementRepository.save(signalement);

            return MessageResponse.success("Signalement créé avec succès", new SignalementResponse(signalement));

        } catch (Exception e) {
            e.printStackTrace(); // Pour aider au débogage
            return MessageResponse.error("Erreur lors de la création du signalement: " + e.getMessage());
        }
    }

    /**
     * Récupère tous les signalements du citoyen connecté
     */
    public List<SignalementSimpleResponse> obtenirMesSignalements() {
        Citoyen citoyen = getCitoyenConnecte();
        if (citoyen == null) {
            return List.of();
        }

        List<Signalement> signalements = signalementRepository.findByCitoyenIdOrderByDateCreationDesc(citoyen.getId());
        return signalements.stream()
                .map(SignalementSimpleResponse::new)
                .collect(Collectors.toList());
    }

    /**
     * Récupère un signalement spécifique
     */
    public SignalementResponse obtenirSignalement(Long id) {
        Optional<Signalement> signalementOpt = signalementRepository.findById(id);
        if (signalementOpt.isEmpty()) {
            return null;
        }

        Signalement signalement = signalementOpt.get();
        Citoyen citoyenConnecte = getCitoyenConnecte();

        // Vérifier que le citoyen peut voir ce signalement
        if (citoyenConnecte == null || !signalement.getCitoyen().getId().equals(citoyenConnecte.getId())) {
            return null;
        }

        return new SignalementResponse(signalement);
    }

    /**
     * Modifie un signalement (seulement si moins de 15 minutes)
     */
    public MessageResponse modifierSignalement(Long id, ModifierSignalementRequest request) {
        try {
            Optional<Signalement> signalementOpt = signalementRepository.findById(id);
            if (signalementOpt.isEmpty()) {
                return MessageResponse.error("Signalement non trouvé");
            }

            Signalement signalement = signalementOpt.get();
            Citoyen citoyenConnecte = getCitoyenConnecte();

            // Vérifier que le citoyen peut modifier ce signalement
            if (citoyenConnecte == null || !signalement.getCitoyen().getId().equals(citoyenConnecte.getId())) {
                return MessageResponse.error("Vous ne pouvez pas modifier ce signalement");
            }

            // Vérifier si le signalement peut encore être modifié (15 minutes)
            if (!signalement.peutEtreModifie()) {
                return MessageResponse.error("Le signalement ne peut plus être modifié après 15 minutes");
            }

            // Modifier le signalement
            signalement.setTitre(request.getTitre());
            signalement.setDescription(request.getDescription());

            signalementRepository.save(signalement);

            return MessageResponse.success("Signalement modifié avec succès", new SignalementResponse(signalement));

        } catch (Exception e) {
            return MessageResponse.error("Erreur lors de la modification du signalement: " + e.getMessage());
        }
    }

    /**
     * Supprime un signalement (seulement si moins de 15 minutes)
     */
    public MessageResponse supprimerSignalement(Long id) {
        try {
            Optional<Signalement> signalementOpt = signalementRepository.findById(id);
            if (signalementOpt.isEmpty()) {
                return MessageResponse.error("Signalement non trouvé");
            }

            Signalement signalement = signalementOpt.get();
            Citoyen citoyenConnecte = getCitoyenConnecte();

            // Vérifier que le citoyen peut supprimer ce signalement
            if (citoyenConnecte == null || !signalement.getCitoyen().getId().equals(citoyenConnecte.getId())) {
                return MessageResponse.error("Vous ne pouvez pas supprimer ce signalement");
            }

            // Vérifier si le signalement peut encore être supprimé (15 minutes)
            if (!signalement.peutEtreModifie()) {
                return MessageResponse.error("Le signalement ne peut plus être supprimé après 15 minutes");
            }

            signalementRepository.delete(signalement);

            return MessageResponse.success("Signalement supprimé avec succès");

        } catch (Exception e) {
            return MessageResponse.error("Erreur lors de la suppression du signalement: " + e.getMessage());
        }
    }

    /**
     * Récupère le citoyen connecté
     */
    private Citoyen getCitoyenConnecte() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication != null && authentication.getPrincipal() instanceof UserDetailsImpl) {
            UserDetailsImpl userDetails = (UserDetailsImpl) authentication.getPrincipal();
            return citoyenRepository.findById(userDetails.getId()).orElse(null);
        }
        return null;
    }
}