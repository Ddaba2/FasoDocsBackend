package ml.fasodocs.backend.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import ml.fasodocs.backend.dto.request.CategorieRequest;
import ml.fasodocs.backend.dto.request.CreerUtilisateurRequest;
import ml.fasodocs.backend.dto.request.ModifierStatutDemandeRequest;
import ml.fasodocs.backend.dto.request.ProcedureRequest;
import ml.fasodocs.backend.dto.request.ProcedureUpdateRequest;
import ml.fasodocs.backend.dto.request.SousCategorieRequest;
import ml.fasodocs.backend.dto.response.DemandeServiceResponse;
import ml.fasodocs.backend.dto.response.*;
import ml.fasodocs.backend.entity.Citoyen;
import ml.fasodocs.backend.repository.CitoyenRepository;
import ml.fasodocs.backend.service.*;
import java.util.Map;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.stream.Collectors;

/**
 * Contrôleur REST pour les opérations d'administration
 */
@Tag(name = "Administration", description = "API pour les opérations d'administration")
@RestController
@RequestMapping("/admin")
@CrossOrigin(origins = "*", maxAge = 3600)
public class AdminController {

    private static final Logger logger = LoggerFactory.getLogger(AdminController.class);

    @Autowired
    private CategorieService categorieService;

    @Autowired
    private SousCategorieService sousCategorieService;

    @Autowired
    private ProcedureService procedureService;

    @Autowired
    private CitoyenRepository citoyenRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;
    
    @Autowired
    private OrangeSmsService orangeSmsService;
    
    @Autowired
    private EmailService emailService;

    @Autowired
    private ServiceService serviceService;

    // ==============================
    // GESTION DES UTILISATEURS
    // ==============================

    /**
     * Liste tous les utilisateurs enregistrés dans la base de données
     */
    @Operation(summary = "Liste tous les utilisateurs (Admin)")
    @PreAuthorize("hasRole('ADMIN')")
    @GetMapping("/utilisateurs")
    public ResponseEntity<List<CitoyenResponse>> listerTousLesUtilisateurs() {
        List<Citoyen> utilisateurs = citoyenRepository.findAll();
        List<CitoyenResponse> responses = utilisateurs.stream()
                .map(CitoyenResponse::new)
                .collect(Collectors.toList());
        return ResponseEntity.ok(responses);
    }

    /**
     * Crée un nouvel utilisateur
     */
    @Operation(summary = "Crée un nouvel utilisateur (Admin)")
    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping("/utilisateurs")
    public ResponseEntity<?> creerUtilisateur(@Valid @RequestBody CreerUtilisateurRequest request) {
        try {
            // Vérifier si l'email existe déjà
            if (citoyenRepository.findByEmail(request.getEmail()).isPresent()) {
                return ResponseEntity.badRequest()
                        .body(MessageResponse.error("Cet email est déjà utilisé"));
            }

            // Vérifier si le téléphone existe déjà
            if (citoyenRepository.findByTelephone(request.getTelephone()).isPresent()) {
                return ResponseEntity.badRequest()
                        .body(MessageResponse.error("Ce numéro de téléphone est déjà utilisé"));
            }

            // Créer le nouvel utilisateur
            Citoyen nouvelUtilisateur = new Citoyen();
            nouvelUtilisateur.setNom(request.getNom());
            nouvelUtilisateur.setPrenom(request.getPrenom());
            nouvelUtilisateur.setEmail(request.getEmail());
            nouvelUtilisateur.setTelephone(request.getTelephone());
            nouvelUtilisateur.setMotDePasse(passwordEncoder.encode(request.getMotDePasse()));
            nouvelUtilisateur.setEstActif(true);
            nouvelUtilisateur.setEmailVerifie(true);
            nouvelUtilisateur.setTelephoneVerifie(true);
            nouvelUtilisateur.setLanguePreferee("fr");

            // Assigner le rôle
            Citoyen.RoleCitoyen roleCitoyen;
            try {
                roleCitoyen = Citoyen.RoleCitoyen.valueOf(request.getRole());
            } catch (IllegalArgumentException e) {
                return ResponseEntity.badRequest()
                        .body(MessageResponse.error("Rôle invalide. Utilisez USER ou ADMIN"));
            }
            nouvelUtilisateur.setRole(roleCitoyen);

            // Sauvegarder l'utilisateur
            Citoyen utilisateurCree = citoyenRepository.save(nouvelUtilisateur);

            // Envoyer un email de bienvenue avec les informations de connexion
            try {
                emailService.envoyerEmailCreationCompte(
                    utilisateurCree.getEmail(),
                    utilisateurCree.getNom(),
                    utilisateurCree.getPrenom(),
                    utilisateurCree.getTelephone(),
                    request.getMotDePasse() // Mot de passe temporaire en clair
                );
            } catch (Exception emailEx) {
                // L'erreur d'envoi d'email ne doit pas bloquer la création du compte
                logger.warn("⚠️ Impossible d'envoyer l'email de création pour {}: {}", 
                    utilisateurCree.getEmail(), emailEx.getMessage());
            }

            return ResponseEntity.status(HttpStatus.CREATED)
                    .body(new CitoyenResponse(utilisateurCree));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(MessageResponse.error("Erreur lors de la création de l'utilisateur: " + e.getMessage()));
        }
    }

    /**
     * Obtient le statut du service SMS Orange
     */
    @Operation(summary = "Statut du service SMS Orange (Admin)")
    @PreAuthorize("hasRole('ADMIN')")
    @GetMapping("/sms/status")
    public ResponseEntity<?> getSmsStatus() {
        try {
            Map<String, Object> status = new java.util.HashMap<>();
            status.put("enabled", orangeSmsService.isSmsEnabled());
            status.put("configured", orangeSmsService.isOrangeSmsConfigured());
            status.put("rateLimitAvailable", orangeSmsService.getAvailablePermits());
            status.put("rateLimitMax", 5);
            status.put("info", "Rate limit: 5 SMS par seconde (limite Orange)");
            
            return ResponseEntity.ok(status);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(MessageResponse.error("Erreur lors de la récupération du statut SMS: " + e.getMessage()));
        }
    }

    /**
     * Teste uniquement l'authentification Orange (Admin uniquement)
     */
    @Operation(summary = "Tester l'authentification Orange SMS (Admin)")
    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping("/sms/test-auth")
    public ResponseEntity<?> testOrangeAuth() {
        try {
            if (!orangeSmsService.isSmsEnabled()) {
                return ResponseEntity.status(HttpStatus.SERVICE_UNAVAILABLE)
                        .body(MessageResponse.error("Service SMS désactivé. Activez-le dans application.properties (orange.sms.enabled=true)"));
            }
            
            if (!orangeSmsService.isOrangeSmsConfigured()) {
                return ResponseEntity.status(HttpStatus.SERVICE_UNAVAILABLE)
                        .body(MessageResponse.error("Service SMS mal configuré. Vérifiez les credentials Orange dans application.properties"));
            }
            
            boolean authOk = orangeSmsService.testAuthentication();
            
            Map<String, Object> response = new java.util.HashMap<>();
            if (authOk) {
                response.put("success", true);
                response.put("message", "✅ Authentification Orange réussie");
                response.put("status", "Les credentials Orange sont valides");
                return ResponseEntity.ok(response);
            } else {
                response.put("success", false);
                response.put("message", "❌ Authentification Orange échouée");
                response.put("status", "Les credentials Orange sont invalides ou expirés");
                response.put("suggestions", java.util.Arrays.asList(
                    "1. Vérifiez les credentials dans Orange Developer Portal",
                    "2. Vérifiez que les credentials ne sont pas expirés",
                    "3. Vérifiez que l'application SMS est activée",
                    "4. Contactez Orange Mali pour valider les credentials"
                ));
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response);
            }
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(MessageResponse.error("Erreur lors du test d'authentification: " + e.getMessage()));
        }
    }

    /**
     * Teste l'envoi d'un SMS (Admin uniquement)
     */
    @Operation(summary = "Tester l'envoi d'un SMS (Admin)")
    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping("/sms/test")
    public ResponseEntity<?> testSms(@io.swagger.v3.oas.annotations.parameters.RequestBody(
            description = "Numéro de téléphone pour le test",
            required = true) @org.springframework.web.bind.annotation.RequestParam String telephone) {
        try {
            if (telephone == null || telephone.trim().isEmpty()) {
                return ResponseEntity.badRequest()
                        .body(MessageResponse.error("Numéro de téléphone requis"));
            }
            
            if (!orangeSmsService.isSmsEnabled()) {
                return ResponseEntity.status(HttpStatus.SERVICE_UNAVAILABLE)
                        .body(MessageResponse.error("Service SMS désactivé. Activez-le dans application.properties (orange.sms.enabled=true)"));
            }
            
            if (!orangeSmsService.isOrangeSmsConfigured()) {
                return ResponseEntity.status(HttpStatus.SERVICE_UNAVAILABLE)
                        .body(MessageResponse.error("Service SMS mal configuré. Vérifiez les credentials Orange dans application.properties"));
            }
            
            // Générer un code de test
            String testCode = orangeSmsService.genererCodeVerification();
            
            // Envoyer le SMS de test
            orangeSmsService.envoyerSmsConnexion(telephone, testCode);
            
            Map<String, Object> response = new java.util.HashMap<>();
            response.put("success", true);
            response.put("message", "SMS de test envoyé avec succès");
            response.put("telephone", telephone);
            response.put("testCode", testCode);
            response.put("note", "Le code de test est affiché ici pour vérification. En production, ne pas afficher le code.");
            
            return ResponseEntity.ok(response);
            
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest()
                    .body(MessageResponse.error("Numéro de téléphone invalide: " + e.getMessage()));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(MessageResponse.error("Erreur lors de l'envoi du SMS de test: " + e.getMessage()));
        }
    }

    /**
     * Supprime un utilisateur
     */
    @Operation(summary = "Supprime un utilisateur (Admin)")
    @PreAuthorize("hasRole('ADMIN')")
    @DeleteMapping("/utilisateurs/{id}")
    public ResponseEntity<?> supprimerUtilisateur(@PathVariable Long id) {
        try {
            // Vérifier si l'utilisateur existe
            Citoyen utilisateur = citoyenRepository.findById(id)
                    .orElseThrow(() -> new RuntimeException("Utilisateur non trouvé avec l'ID: " + id));

            // Empêcher la suppression du dernier admin
            if (utilisateur.getRole() == Citoyen.RoleCitoyen.ADMIN) {
                long nombreAdmins = citoyenRepository.findAll().stream()
                        .filter(c -> c.getRole() == Citoyen.RoleCitoyen.ADMIN)
                        .count();

                if (nombreAdmins <= 1) {
                    return ResponseEntity.badRequest()
                            .body(MessageResponse.error("Impossible de supprimer le dernier administrateur"));
                }
            }

            // Supprimer l'utilisateur
            citoyenRepository.deleteById(id);

            return ResponseEntity.ok(MessageResponse.success("Utilisateur supprimé avec succès"));
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest()
                    .body(MessageResponse.error(e.getMessage()));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(MessageResponse.error("Erreur lors de la suppression de l'utilisateur: " + e.getMessage()));
        }
    }

    /**
     * Active un utilisateur (citoyen)
     */
    @Operation(summary = "Active un utilisateur (Admin)")
    @PreAuthorize("hasRole('ADMIN')")
    @PutMapping("/utilisateurs/{id}/activer")
    public ResponseEntity<?> activerUtilisateur(@PathVariable Long id) {
        try {
            // Vérifier si l'utilisateur existe
            Citoyen utilisateur = citoyenRepository.findById(id)
                    .orElseThrow(() -> new RuntimeException("Utilisateur non trouvé avec l'ID: " + id));

            // Vérifier si l'utilisateur est déjà actif
            if (utilisateur.getEstActif()) {
                return ResponseEntity.badRequest()
                        .body(MessageResponse.error("Cet utilisateur est déjà actif"));
            }

            // Activer l'utilisateur
            utilisateur.setEstActif(true);
            Citoyen utilisateurActive = citoyenRepository.save(utilisateur);

            // Envoyer un email de notification d'activation
            try {
                emailService.envoyerEmailActivationCompte(
                    utilisateurActive.getEmail(),
                    utilisateurActive.getNom(),
                    utilisateurActive.getPrenom()
                );
            } catch (Exception emailEx) {
                // L'erreur d'envoi d'email ne doit pas bloquer l'activation
                logger.warn("⚠️ Impossible d'envoyer l'email d'activation pour {}: {}", 
                    utilisateurActive.getEmail(), emailEx.getMessage());
            }

            return ResponseEntity.ok()
                    .body(Map.of(
                            "success", true,
                            "message", "Utilisateur activé avec succès",
                            "data", new CitoyenResponse(utilisateurActive)
                    ));
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest()
                    .body(MessageResponse.error(e.getMessage()));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(MessageResponse.error("Erreur lors de l'activation de l'utilisateur: " + e.getMessage()));
        }
    }

    /**
     * Désactive un utilisateur (citoyen)
     */
    @Operation(summary = "Désactive un utilisateur (Admin)")
    @PreAuthorize("hasRole('ADMIN')")
    @PutMapping("/utilisateurs/{id}/desactiver")
    public ResponseEntity<?> desactiverUtilisateur(@PathVariable Long id) {
        try {
            // Vérifier si l'utilisateur existe
            Citoyen utilisateur = citoyenRepository.findById(id)
                    .orElseThrow(() -> new RuntimeException("Utilisateur non trouvé avec l'ID: " + id));

            // Vérifier si l'utilisateur est déjà inactif
            if (!utilisateur.getEstActif()) {
                return ResponseEntity.badRequest()
                        .body(MessageResponse.error("Cet utilisateur est déjà désactivé"));
            }

            // Empêcher la désactivation du dernier admin actif
            if (utilisateur.getRole() == Citoyen.RoleCitoyen.ADMIN) {
                long nombreAdminsActifs = citoyenRepository.findAll().stream()
                        .filter(c -> c.getRole() == Citoyen.RoleCitoyen.ADMIN && c.getEstActif())
                        .count();

                if (nombreAdminsActifs <= 1) {
                    return ResponseEntity.badRequest()
                            .body(MessageResponse.error("Impossible de désactiver le dernier administrateur actif"));
                }
            }

            // Désactiver l'utilisateur
            utilisateur.setEstActif(false);
            Citoyen utilisateurDesactive = citoyenRepository.save(utilisateur);

            // Envoyer un email de notification de désactivation
            try {
                emailService.envoyerEmailDesactivationCompte(
                    utilisateurDesactive.getEmail(),
                    utilisateurDesactive.getNom(),
                    utilisateurDesactive.getPrenom(),
                    null // Aucune raison spécifique fournie pour l'instant
                );
            } catch (Exception emailEx) {
                // L'erreur d'envoi d'email ne doit pas bloquer la désactivation
                logger.warn("⚠️ Impossible d'envoyer l'email de désactivation pour {}: {}", 
                    utilisateurDesactive.getEmail(), emailEx.getMessage());
            }

            return ResponseEntity.ok()
                    .body(Map.of(
                            "success", true,
                            "message", "Utilisateur désactivé avec succès",
                            "data", new CitoyenResponse(utilisateurDesactive)
                    ));
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest()
                    .body(MessageResponse.error(e.getMessage()));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(MessageResponse.error("Erreur lors de la désactivation de l'utilisateur: " + e.getMessage()));
        }
    }

    // ==============================
    // GESTION DES CATÉGORIES
    // ==============================

    /**
     * Liste toutes les catégories
     */
    @Operation(summary = "Liste toutes les catégories (Admin)")
    @PreAuthorize("hasRole('ADMIN')")
    @GetMapping("/categories")
    public ResponseEntity<List<CategorieResponse>> listerToutesLesCategories() {
        return ResponseEntity.ok(categorieService.obtenirToutesCategories());
    }

    /**
     * Crée une nouvelle catégorie
     */
    @Operation(summary = "Crée une nouvelle catégorie (Admin)")
    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping("/categories")
    public ResponseEntity<?> creerCategorie(@Valid @RequestBody CategorieRequest request) {
        try {
            CategorieResponse response = categorieService.creerCategorie(request);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                    .body(MessageResponse.error("Erreur lors de la création: " + e.getMessage()));
        }
    }

    /**
     * Met à jour une catégorie
     */
    @Operation(summary = "Met à jour une catégorie (Admin)")
    @PreAuthorize("hasRole('ADMIN')")
    @PutMapping("/categories/{id}")
    public ResponseEntity<?> mettreAJourCategorie(@PathVariable Long id, 
                                                 @Valid @RequestBody CategorieRequest request) {
        try {
            CategorieResponse response = categorieService.mettreAJourCategorie(id, request);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                    .body(MessageResponse.error("Erreur lors de la mise à jour: " + e.getMessage()));
        }
    }

    /**
     * Supprime une catégorie
     */
    @Operation(summary = "Supprime une catégorie (Admin)")
    @PreAuthorize("hasRole('ADMIN')")
    @DeleteMapping("/categories/{id}")
    public ResponseEntity<?> supprimerCategorie(@PathVariable Long id) {
        try {
            MessageResponse response = categorieService.supprimerCategorie(id);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                    .body(MessageResponse.error("Erreur lors de la suppression: " + e.getMessage()));
        }
    }

    // ==============================
    // GESTION DES SOUS-CATÉGORIES
    // ==============================

    /**
     * Liste toutes les sous-catégories
     */
    @Operation(summary = "Liste toutes les sous-catégories (Admin)")
    @PreAuthorize("hasRole('ADMIN')")
    @GetMapping("/sous-categories")
    public ResponseEntity<List<SousCategorieResponse>> listerToutesLesSousCategories() {
        return ResponseEntity.ok(sousCategorieService.obtenirToutesSousCategories());
    }

    /**
     * Crée une nouvelle sous-catégorie
     */
    @Operation(summary = "Crée une nouvelle sous-catégorie (Admin)")
    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping("/sous-categories")
    public ResponseEntity<?> creerSousCategorie(@Valid @RequestBody SousCategorieRequest request) {
        try {
            SousCategorieResponse response = sousCategorieService.creerSousCategorie(request);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                    .body(MessageResponse.error("Erreur lors de la création: " + e.getMessage()));
        }
    }

    /**
     * Met à jour une sous-catégorie
     */
    @Operation(summary = "Met à jour une sous-catégorie (Admin)")
    @PreAuthorize("hasRole('ADMIN')")
    @PutMapping("/sous-categories/{id}")
    public ResponseEntity<?> mettreAJourSousCategorie(@PathVariable Long id, 
                                                     @Valid @RequestBody SousCategorieRequest request) {
        try {
            SousCategorieResponse response = sousCategorieService.mettreAJourSousCategorie(id, request);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                    .body(MessageResponse.error("Erreur lors de la mise à jour: " + e.getMessage()));
        }
    }

    /**
     * Supprime une sous-catégorie
     */
    @Operation(summary = "Supprime une sous-catégorie (Admin)")
    @PreAuthorize("hasRole('ADMIN')")
    @DeleteMapping("/sous-categories/{id}")
    public ResponseEntity<?> supprimerSousCategorie(@PathVariable Long id) {
        try {
            MessageResponse response = sousCategorieService.supprimerSousCategorie(id);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                    .body(MessageResponse.error("Erreur lors de la suppression: " + e.getMessage()));
        }
    }

    // ==============================
    // GESTION DES PROCÉDURES
    // ==============================

    /**
     * Liste toutes les procédures
     */
    @Operation(summary = "Liste toutes les procédures (Admin)")
    @PreAuthorize("hasRole('ADMIN')")
    @GetMapping("/procedures")
    public ResponseEntity<List<ProcedureResponse>> listerToutesLesProcedures() {
        return ResponseEntity.ok(procedureService.obtenirToutesProcedures());
    }

    /**
     * Récupère une procédure par ID
     */
    @Operation(summary = "Récupère une procédure par son ID (Admin)")
    @PreAuthorize("hasRole('ADMIN')")
    @GetMapping("/procedures/{id}")
    public ResponseEntity<?> obtenirProcedureParId(@PathVariable Long id) {
        try {
            ProcedureResponse response = procedureService.obtenirProcedureParId(id);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                    .body(MessageResponse.error("Procédure non trouvée: " + e.getMessage()));
        }
    }

    /**
     * Crée une nouvelle procédure
     */
    @Operation(summary = "Crée une nouvelle procédure (Admin)")
    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping("/procedures")
    public ResponseEntity<?> creerProcedure(@Valid @RequestBody ProcedureRequest request) {
        try {
            ProcedureResponse response = procedureService.creerProcedure(request);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                    .body(MessageResponse.error("Erreur lors de la création: " + e.getMessage()));
        }
    }

    /**
     * Met à jour une procédure
     */
    @Operation(summary = "Met à jour une procédure (Admin)")
    @PreAuthorize("hasRole('ADMIN')")
    @PutMapping("/procedures/{id}")
    public ResponseEntity<?> mettreAJourProcedure(@PathVariable Long id, 
                                                 @RequestBody ProcedureUpdateRequest request) {
        try {
            ProcedureResponse response = procedureService.mettreAJourProcedure(id, request);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                    .body(MessageResponse.error("Erreur lors de la mise à jour: " + e.getMessage()));
        }
    }

    /**
     * Supprime une procédure
     */
    @Operation(summary = "Supprime une procédure (Admin)")
    @PreAuthorize("hasRole('ADMIN')")
    @DeleteMapping("/procedures/{id}")
    public ResponseEntity<?> supprimerProcedure(@PathVariable Long id) {
        try {
            MessageResponse response = procedureService.supprimerProcedure(id);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                    .body(MessageResponse.error("Erreur lors de la suppression: " + e.getMessage()));
        }
    }

    // ==============================
    // GESTION DES SERVICES
    // ==============================

    /**
     * Liste toutes les demandes de service (Admin uniquement)
     */
    @Operation(summary = "Liste toutes les demandes de service (Admin)")
    @PreAuthorize("hasRole('ADMIN')")
    @GetMapping("/services/demandes")
    public ResponseEntity<?> listerToutesLesDemandesService(
            @RequestParam(required = false) String statut) {
        try {
            List<DemandeServiceResponse> demandes = serviceService.obtenirToutesLesDemandes(statut);
            return ResponseEntity.ok(demandes);
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                    .body(MessageResponse.error("Erreur lors de la récupération des demandes: " + e.getMessage()));
        }
    }

    /**
     * Modifie le statut d'une demande de service (Admin uniquement)
     * Transitions possibles : EN_ATTENTE -> EN_COURS -> TERMINEE
     */
    @Operation(summary = "Modifie le statut d'une demande de service (Admin)")
    @PreAuthorize("hasRole('ADMIN')")
    @PutMapping("/services/demandes/{id}/statut")
    public ResponseEntity<?> modifierStatutDemandeService(
            @PathVariable Long id,
            @Valid @RequestBody ModifierStatutDemandeRequest request) {
        try {
            ml.fasodocs.backend.entity.DemandeService.StatutDemande statutEnum;
            try {
                statutEnum = ml.fasodocs.backend.entity.DemandeService.StatutDemande.valueOf(
                        request.getStatut().toUpperCase());
            } catch (IllegalArgumentException e) {
                return ResponseEntity.badRequest()
                        .body(MessageResponse.error("Statut invalide: " + request.getStatut()));
            }

            DemandeServiceResponse response = serviceService.modifierStatutDemande(
                    id, statutEnum, request.getNotes());
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                    .body(MessageResponse.error("Erreur lors de la modification: " + e.getMessage()));
        }
    }

    /**
     * Récupère une demande de service spécifique (Admin uniquement)
     */
    @Operation(summary = "Récupère une demande de service par son ID (Admin)")
    @PreAuthorize("hasRole('ADMIN')")
    @GetMapping("/services/demandes/{id}")
    public ResponseEntity<?> obtenirDemandeServiceParId(@PathVariable Long id) {
        try {
            DemandeServiceResponse response = serviceService.obtenirDemandeParId(id);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                    .body(MessageResponse.error("Erreur lors de la récupération: " + e.getMessage()));
        }
    }
}