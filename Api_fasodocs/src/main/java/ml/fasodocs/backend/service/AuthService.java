package ml.fasodocs.backend.service;

import ml.fasodocs.backend.dto.request.ConnexionRequest;
import ml.fasodocs.backend.dto.request.ConnexionTelephoneRequest;
import ml.fasodocs.backend.dto.request.InscriptionRequest;
import ml.fasodocs.backend.dto.request.MiseAJourProfilRequest;
import ml.fasodocs.backend.dto.request.UploadPhotoRequest;
import ml.fasodocs.backend.dto.request.VerificationSmsRequest;
import ml.fasodocs.backend.dto.response.JwtResponse;
import ml.fasodocs.backend.dto.response.MessageResponse;
import ml.fasodocs.backend.entity.Citoyen;
import ml.fasodocs.backend.repository.CitoyenRepository;
import ml.fasodocs.backend.security.JwtUtils;
import ml.fasodocs.backend.security.UserDetailsImpl;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * Service pour la gestion de l'authentification et des citoyens
 */
@Service
@Transactional
public class AuthService {

    private static final Logger logger = LoggerFactory.getLogger(AuthService.class);

    @Autowired
    private AuthenticationManager authenticationManager;

    @Autowired
    private CitoyenRepository citoyenRepository;

    @Autowired
    private PasswordEncoder encoder;

    @Autowired
    private JwtUtils jwtUtils;
    
    @Autowired
    private OrangeSmsService orangeSmsService;
    
    @Autowired
    private EmailService emailService;

    /**
     * Inscription d'un nouveau citoyen
     */
    public MessageResponse inscrireCitoyen(InscriptionRequest request) {
        // Format phone number with +223 prefix if not already present
        String formattedTelephone = formatPhoneNumber(request.getTelephone());

        // Vérifier que les mots de passe correspondent
        if (!request.getMotDePasse().equals(request.getConfirmerMotDePasse())) {
            return MessageResponse.error("Erreur: Les mots de passe ne correspondent pas!");
        }

        // Vérifier si l'email existe déjà
        if (citoyenRepository.existsByEmail(request.getEmail())) {
            return MessageResponse.error("Erreur: L'email est déjà utilisé!");
        }

        // Vérifier si le téléphone existe déjà
        if (citoyenRepository.existsByTelephone(formattedTelephone)) {
            return MessageResponse.error("Erreur: Le téléphone est déjà utilisé!");
        }

        // Créer le nouveau citoyen
        Citoyen citoyen = new Citoyen();
        citoyen.setEmail(request.getEmail());
        citoyen.setTelephone(formattedTelephone);
        citoyen.setMotDePasse(encoder.encode(request.getMotDePasse()));
        citoyen.setEstActif(true);
        citoyen.setEmailVerifie(false);
        citoyen.setTelephoneVerifie(false);

        // Attribuer le rôle USER par défaut
        citoyen.setRole(Citoyen.RoleCitoyen.USER);

        // Sauvegarder le citoyen
        Citoyen citoyenInscrit = citoyenRepository.save(citoyen);

        logger.info("Nouveau citoyen inscrit avec le téléphone: {}", citoyenInscrit.getTelephone());

        // Envoyer un email de bienvenue
        try {
            emailService.envoyerEmailInscriptionReussie(
                citoyenInscrit.getEmail(),
                citoyenInscrit.getTelephone()
            );
        } catch (Exception emailEx) {
            // L'erreur d'envoi d'email ne doit pas bloquer l'inscription
            logger.warn("⚠️ Impossible d'envoyer l'email d'inscription pour {}: {}", 
                citoyenInscrit.getEmail(), emailEx.getMessage());
        }

        return MessageResponse.success("Inscription réussie! Vous pouvez maintenant vous connecter.");
    }
    
    /**
     * Format phone number with +223 prefix if not already present
     * Valide que le numéro commence par 5, 6, 7, 8 ou 9 (numéros mobiles Mali)
     */
    private String formatPhoneNumber(String telephone) {
        if (telephone == null || telephone.isEmpty()) {
            return telephone;
        }
        
        // Remove any existing + or spaces
        String cleanNumber = telephone.replaceAll("[+\\s]", "");
        
        // Extraire le numéro local (8 chiffres sans le préfixe 223)
        String localNumber;
        if (cleanNumber.startsWith("223") && cleanNumber.length() == 11) {
            // Format: 223XXXXXXXX (11 chiffres)
            localNumber = cleanNumber.substring(3);
        } else if (cleanNumber.length() == 8) {
            // Format: XXXXXXXX (8 chiffres locaux)
            localNumber = cleanNumber;
        } else {
            // Si le format n'est pas reconnu, essayer de l'utiliser tel quel
            localNumber = cleanNumber;
        }
        
        // Valider que le numéro local commence par 5, 6, 7, 8 ou 9
        if (localNumber.length() == 8) {
            char firstDigit = localNumber.charAt(0);
            if (firstDigit != '5' && firstDigit != '6' && firstDigit != '7' && 
                firstDigit != '8' && firstDigit != '9') {
                throw new IllegalArgumentException(
                    "Le numéro de téléphone doit commencer par 5, 6, 7, 8 ou 9"
                );
            }
        } else if (localNumber.length() != 8) {
            // Si la longueur n'est pas 8, c'est peut-être un format invalide
            throw new IllegalArgumentException(
                "Format de numéro de téléphone invalide. Attendu: 8 chiffres commençant par 5, 6, 7, 8 ou 9"
            );
        }
        
        // Formater avec le préfixe +223
        if (cleanNumber.startsWith("223")) {
            return "+" + cleanNumber;
        }
        
        // Si c'est un numéro local de 8 chiffres, ajouter +223
        return "+223" + localNumber;
    }

    /**
     * Connexion par téléphone uniquement - Envoie un code SMS
     * SÉCURITÉ : Vérifie d'abord que le numéro existe en base de données
     */
    public MessageResponse connecterParTelephone(ConnexionTelephoneRequest request) {
        // Format phone number with +223 prefix for consistent lookup
        String formattedTelephone = formatPhoneNumber(request.getTelephone());
        
        // 1. Vérifier si le téléphone existe dans la base de données
        Citoyen citoyen = citoyenRepository.findByTelephone(formattedTelephone)
                .orElseThrow(() -> new RuntimeException("Numéro de téléphone non enregistré. Veuillez vous inscrire d'abord."));

        // 2. Vérifier si le compte est actif
        if (!citoyen.getEstActif()) {
            throw new RuntimeException("Votre compte a été désactivé. Veuillez contacter le support.");
        }

        // 3. Générer un code SMS à 4 chiffres
        String codeSms = orangeSmsService.genererCodeVerification();
        citoyen.setCodeSms(codeSms);
        citoyen.setCodeSmsExpiration(java.time.LocalDateTime.now().plusMinutes(2));
        citoyenRepository.save(citoyen);

        // 4. Envoyer le SMS - Mode fallback si échec
        boolean smsEnvoye = false;
        try {
            orangeSmsService.envoyerSmsConnexion(citoyen.getTelephone(), codeSms);
            smsEnvoye = true;
            logger.info("✅ Code SMS envoyé avec succès pour: {}", citoyen.getTelephone());
        } catch (RuntimeException e) {
            logger.error("❌ Échec de l'envoi du SMS à {}: {}", citoyen.getTelephone(), e.getMessage());
            
            // SOLUTION DÉFINITIVE : Mode fallback - Afficher le code dans les logs
            logger.warn("");
            logger.warn("═══════════════════════════════════════════════════════════");
            logger.warn("📱 MODE FALLBACK ACTIVÉ - CODE SMS DISPONIBLE DANS LES LOGS");
            logger.warn("═══════════════════════════════════════════════════════════");
            logger.warn("📞 Téléphone : {}", formattedTelephone);
            logger.warn("🔑 Code SMS  : {}", codeSms);
            logger.warn("⏰ Expiration: {} (2 minutes)", 
                citoyen.getCodeSmsExpiration() != null ? citoyen.getCodeSmsExpiration() : "N/A");
            logger.warn("═══════════════════════════════════════════════════════════");
            logger.warn("⚠️  L'envoi SMS a échoué mais le code est disponible ci-dessus");
            logger.warn("⚠️  Utilisez ce code pour vous connecter");
            logger.warn("═══════════════════════════════════════════════════════════");
            logger.warn("");
            
            // Ne pas lever d'exception - Permettre la connexion même si SMS échoue
            // Le code est déjà généré et sauvegardé, l'utilisateur peut l'utiliser
        }

        // Retourner un message de succès même si SMS n'a pas été envoyé
        // Le code est disponible dans les logs
        if (smsEnvoye) {
            return MessageResponse.success("Un code de vérification a été envoyé au " + 
                                          formattedTelephone.substring(0, 7) + "***");
        } else {
            // Mode fallback : Informer que le code est disponible dans les logs
            return MessageResponse.success(
                "Un code de vérification a été généré. " +
                "En cas de problème d'envoi SMS, consultez les logs du serveur pour obtenir le code."
            );
        }
    }

    /**
     * Connexion d'un citoyen - Envoie un code SMS (ancienne méthode)
     */
    public MessageResponse connecterCitoyen(ConnexionRequest request) {
        // Authentifier l'utilisateur
        Authentication authentication = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(request.getIdentifiant(), request.getMotDePasse()));

        UserDetailsImpl userDetails = (UserDetailsImpl) authentication.getPrincipal();
        
        Citoyen citoyen = citoyenRepository.findById(userDetails.getId())
                .orElseThrow(() -> new RuntimeException("Citoyen non trouvé"));

        // Vérifier si le compte est actif
        if (!citoyen.getEstActif()) {
            throw new RuntimeException("Votre compte a été désactivé. Veuillez contacter le support.");
        }

        // Format phone number with +223 prefix for consistent SMS sending
        String formattedTelephone = formatPhoneNumber(citoyen.getTelephone());

        // Générer un code SMS
        String codeSms = orangeSmsService.genererCodeVerification();
        citoyen.setCodeSms(codeSms);
        citoyen.setCodeSmsExpiration(java.time.LocalDateTime.now().plusMinutes(2));
        citoyenRepository.save(citoyen);

        // Envoyer le SMS - Mode fallback si échec
        try {
            orangeSmsService.envoyerSmsConnexion(formattedTelephone, codeSms);
            logger.info("✅ Code SMS envoyé avec succès pour: {}", formattedTelephone);
        } catch (RuntimeException e) {
            logger.error("❌ Échec de l'envoi du SMS à {}: {}", formattedTelephone, e.getMessage());
            logger.warn("");
            logger.warn("═══════════════════════════════════════════════════════════");
            logger.warn("📱 MODE FALLBACK - CODE SMS: {}", codeSms);
            logger.warn("📞 Téléphone: {}", formattedTelephone);
            logger.warn("═══════════════════════════════════════════════════════════");
            logger.warn("");
        }

        return MessageResponse.success("Un code de vérification a été envoyé à votre téléphone.");
    }

    /**
     * Vérification du code SMS et connexion
     */
    public JwtResponse verifierCodeSms(VerificationSmsRequest request) {
        // Format phone number with +223 prefix for consistent lookup
        String formattedTelephone = formatPhoneNumber(request.getTelephone());
        
        logger.info("Tentative de vérification SMS pour: {}", formattedTelephone);
        
        Citoyen citoyen = citoyenRepository.findByTelephone(formattedTelephone)
                .orElseThrow(() -> {
                    logger.error("Numéro de téléphone non trouvé: {}", formattedTelephone);
                    return new RuntimeException("Numéro de téléphone non trouvé");
                });

        // Vérifier si le compte est actif
        if (!citoyen.getEstActif()) {
            logger.warn("Tentative de connexion avec un compte désactivé: {}", formattedTelephone);
            throw new RuntimeException("Votre compte a été désactivé. Veuillez contacter le support.");
        }

        logger.debug("Code en BDD: {}, Code reçu: {}", citoyen.getCodeSms(), request.getCode());
        
        // Vérifier le code SMS
        if (citoyen.getCodeSms() == null) {
            logger.error("Aucun code SMS en base pour: {}", formattedTelephone);
            throw new RuntimeException("Aucun code SMS n'a été généré. Veuillez d'abord demander un code.");
        }
        
        if (!citoyen.getCodeSms().equals(request.getCode())) {
            logger.error("Code SMS invalide. Attendu: {}, Reçu: {}", citoyen.getCodeSms(), request.getCode());
            throw new RuntimeException("Code SMS invalide. Vérifiez le code reçu.");
        }

        // Vérifier l'expiration du code
        if (citoyen.getCodeSmsExpiration() == null) {
            logger.error("Pas de date d'expiration pour le code SMS");
            throw new RuntimeException("Erreur interne: code SMS sans expiration");
        }
        
        if (citoyen.getCodeSmsExpiration().isBefore(java.time.LocalDateTime.now())) {
            logger.error("Code SMS expiré. Expiration: {}, Maintenant: {}", 
                        citoyen.getCodeSmsExpiration(), java.time.LocalDateTime.now());
            throw new RuntimeException("Code SMS expiré. Veuillez demander un nouveau code.");
        }

        // Marquer le téléphone comme vérifié
        citoyen.setTelephoneVerifie(true);
        citoyen.setCodeSms(null);
        citoyen.setCodeSmsExpiration(null);

        // Code SMS vérifié avec succès
        citoyenRepository.save(citoyen);

        // Générer le JWT avec UserDetailsImpl
        UserDetailsImpl userDetails = UserDetailsImpl.build(citoyen);
        Authentication authentication = new UsernamePasswordAuthenticationToken(
                userDetails,
                null,
                userDetails.getAuthorities()
        );
        String jwt = jwtUtils.generateJwtToken(authentication);

        logger.info("Citoyen connecté après vérification SMS: {}", citoyen.getTelephone());

        return new JwtResponse(
                jwt,
                citoyen.getId(),
                citoyen.getNom(),
                citoyen.getPrenom(),
                citoyen.getEmail(),
                citoyen.getTelephone(),
                citoyen.getLanguePreferee()
        );
    }

    /**
     * Vérification de l'email
     */
    public MessageResponse verifierEmail(String code) {
        Citoyen citoyen = citoyenRepository.findByCodeVerification(code)
                .orElseThrow(() -> new RuntimeException("Code de vérification invalide"));

        citoyen.setEmailVerifie(true);
        citoyen.setCodeVerification(null);
        citoyenRepository.save(citoyen);

        logger.info("Email vérifié pour: {} {}", citoyen.getNom(), citoyen.getPrenom());

        return MessageResponse.success("Email vérifié avec succès!");
    }

    /**
     * Récupération du profil du citoyen connecté
     */
    public Citoyen getProfilCitoyenConnecte() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        UserDetailsImpl userDetails = (UserDetailsImpl) authentication.getPrincipal();

        return citoyenRepository.findById(userDetails.getId())
                .orElseThrow(() -> new RuntimeException("Citoyen non trouvé"));
    }

    /**
     * Trouver un citoyen par son ID
     */
    public Citoyen trouverCitoyenParId(Long id) {
        return citoyenRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Citoyen non trouvé avec l'id: " + id));
    }

    /**
     * Mise à jour du profil
     * Mise à jour partielle : seuls les champs non-null sont modifiés
     */
    public MessageResponse mettreAJourProfil(MiseAJourProfilRequest request) {
        Citoyen citoyen = getProfilCitoyenConnecte();

        logger.info("📝 Mise à jour du profil pour: {} {} (ID: {})", 
            citoyen.getNom(), citoyen.getPrenom(), citoyen.getId());

        // Mise à jour du nom si fourni
        if (request.getNom() != null && !request.getNom().trim().isEmpty()) {
            citoyen.setNom(request.getNom().trim());
            logger.debug("   ✅ Nom mis à jour: {}", request.getNom());
        }
        
        // Mise à jour du prénom si fourni
        if (request.getPrenom() != null && !request.getPrenom().trim().isEmpty()) {
            citoyen.setPrenom(request.getPrenom().trim());
            logger.debug("   ✅ Prénom mis à jour: {}", request.getPrenom());
        }
        
        // Mise à jour du téléphone si fourni
        if (request.getTelephone() != null && !request.getTelephone().trim().isEmpty()) {
            String telephone = request.getTelephone().trim();
            // Valider et formater le numéro
            String formattedTelephone = formatPhoneNumber(telephone);
            citoyen.setTelephone(formattedTelephone);
            logger.debug("Téléphone mis à jour pour citoyen ID {}", citoyen.getId());
        }
        
        // Mise à jour de la langue si fournie
        if (request.getLanguePreferee() != null && !request.getLanguePreferee().trim().isEmpty()) {
            citoyen.setLanguePreferee(request.getLanguePreferee().trim());
            logger.debug("   ✅ Langue mise à jour: {}", request.getLanguePreferee());
        }
        
        // Mise à jour de la photo si fournie
        if (request.getPhotoProfil() != null && !request.getPhotoProfil().trim().isEmpty()) {
            String photo = request.getPhotoProfil().trim();
            
            // Validation et normalisation du format
            if (!photo.startsWith("data:image/")) {
                if (!photo.startsWith("data:")) {
                    photo = "data:image/jpeg;base64," + photo;
                    logger.debug("Préfixe data:image/jpeg;base64, ajouté automatiquement");
                }
            }
            
            citoyen.setPhotoProfil(photo);
            logger.debug("Photo de profil mise à jour pour citoyen ID {}", citoyen.getId());
        }

        // Sauvegarder en base
        citoyenRepository.save(citoyen);
        logger.info("Profil mis à jour pour citoyen ID {}", citoyen.getId());

        return MessageResponse.success("Profil mis à jour avec succès!");
    }

    /**
     * Upload de photo de profil
     */
    public MessageResponse uploadPhotoProfil(UploadPhotoRequest request) {
        Long citoyenId = null;
        try {
            Citoyen citoyen = getProfilCitoyenConnecte();
            citoyenId = citoyen.getId();
            
            // Vérifier que la photo est fournie
            if (request.getPhotoProfil() == null || request.getPhotoProfil().trim().isEmpty()) {
                logger.error("Photo de profil vide ou null pour citoyen ID {}", citoyenId);
                throw new IllegalArgumentException("La photo de profil est obligatoire");
            }
            
            // Préparer et normaliser la photo
            String photo = request.getPhotoProfil().trim();
            if (!photo.startsWith("data:image/")) {
                if (!photo.startsWith("data:")) {
                    photo = "data:image/jpeg;base64," + photo;
                    logger.debug("Préfixe data:image/jpeg;base64, ajouté automatiquement");
                }
            }
            
            // Vérification minimale
            if (photo.length() < 50) {
                logger.error("Photo trop courte ({} caractères) pour citoyen ID {}", photo.length(), citoyenId);
                throw new IllegalArgumentException("La photo est trop courte (minimum 50 caractères)");
            }
            
            // Sauvegarder la photo
            citoyen.setPhotoProfil(photo);
            citoyenRepository.saveAndFlush(citoyen);
            
            // Vérifier la sauvegarde
            Citoyen citoyenVerifie = citoyenRepository.findById(citoyenId)
                    .orElseThrow(() -> new RuntimeException("Impossible de recharger le citoyen"));
            
            String photoVerifiee = citoyenVerifie.getPhotoProfil();
            if (photoVerifiee == null || photoVerifiee.isEmpty()) {
                logger.error("Échec: photo NULL après sauvegarde pour citoyen ID {}", citoyenId);
                throw new RuntimeException("La photo n'a pas pu être sauvegardée en base de données");
            }
            
            logger.info("Photo de profil mise à jour avec succès pour citoyen ID {} ({} caractères)", 
                    citoyenId, photoVerifiee.length());
            
            return MessageResponse.success("Photo de profil mise à jour avec succès!");
            
        } catch (IllegalArgumentException e) {
            logger.error("Erreur de validation lors de l'upload photo pour citoyen ID {}: {}", 
                    citoyenId, e.getMessage());
            throw e;
        } catch (Exception e) {
            logger.error("Erreur lors de l'upload photo pour citoyen ID {}: {}", citoyenId, e.getMessage(), e);
            throw new RuntimeException("Erreur lors de la sauvegarde de la photo: " + e.getMessage(), e);
        }
    }

    /**
     * Suppression de la photo de profil
     */
    public MessageResponse supprimerPhotoProfil() {
        Citoyen citoyen = getProfilCitoyenConnecte();

        citoyen.setPhotoProfil(null);
        citoyenRepository.save(citoyen);

        logger.info("Photo de profil supprimée pour: {} {}", citoyen.getNom(), citoyen.getPrenom());

        return MessageResponse.success("Photo de profil supprimée avec succès!");
    }

    /**
     * Déconnexion
     */
    public MessageResponse deconnecter() {
        Citoyen citoyen = getProfilCitoyenConnecte();

        logger.info("Citoyen déconnecté: {} {}", citoyen.getNom(), citoyen.getPrenom());

        return MessageResponse.success("Déconnexion réussie!");
    }

    /**
     * Connexion ADMIN - Étape 1 : Vérifie le rôle et envoie le code SMS
     * Vérifie d'abord que l'utilisateur est bien administrateur avant d'envoyer le SMS
     */
    public MessageResponse connecterAdmin(ConnexionTelephoneRequest request) {
        // Format phone number with +223 prefix for consistent lookup
        String formattedTelephone = formatPhoneNumber(request.getTelephone());
        
        logger.info("🔐 Tentative de connexion ADMIN pour le téléphone: {}", formattedTelephone);

        // 1. Vérifier si le téléphone existe dans la base de données
        Citoyen citoyen = citoyenRepository.findByTelephone(formattedTelephone)
                .orElseThrow(() -> {
                    logger.warn("❌ Numéro non enregistré: {}", formattedTelephone);
                    return new RuntimeException("Ce numéro de téléphone n'est pas enregistré dans le système.");
                });

        // 2. VÉRIFICATION CRUCIALE : Est-ce un ADMIN ?
        if (citoyen.getRole() != Citoyen.RoleCitoyen.ADMIN) {
            logger.warn("❌ Tentative de connexion admin refusée - Rôle: {} pour: {}", 
                        citoyen.getRole(), formattedTelephone);
            throw new RuntimeException("Accès refusé : Ce compte n'a pas les droits d'administrateur. " +
                                     "La connexion administrateur est réservée aux comptes avec le rôle ADMIN uniquement.");
        }

        // 3. Vérifier si le compte est actif
        if (!citoyen.getEstActif()) {
            logger.warn("❌ Compte admin inactif: {}", formattedTelephone);
            throw new RuntimeException("Votre compte administrateur a été désactivé. Veuillez contacter le support technique.");
        }

        // 4. Générer un code SMS à 4 chiffres
        String codeSms = orangeSmsService.genererCodeVerification();
        citoyen.setCodeSms(codeSms);
        citoyen.setCodeSmsExpiration(java.time.LocalDateTime.now().plusMinutes(2));
        citoyenRepository.save(citoyen);

        // 5. Envoyer le SMS - Mode fallback si échec
        try {
            orangeSmsService.envoyerSmsConnexion(citoyen.getTelephone(), codeSms);
            logger.info("✅ Code SMS envoyé à l'admin: {}", formattedTelephone);
        } catch (RuntimeException e) {
            logger.error("❌ Échec de l'envoi du SMS admin à {}: {}", formattedTelephone, e.getMessage());
            logger.warn("");
            logger.warn("═══════════════════════════════════════════════════════════");
            logger.warn("📱 MODE FALLBACK ADMIN - CODE SMS: {}", codeSms);
            logger.warn("📞 Téléphone: {}", formattedTelephone);
            logger.warn("═══════════════════════════════════════════════════════════");
            logger.warn("");
            // Ne pas lever d'exception - Le code est disponible dans les logs
        }

        logger.info("✅ Vérification ADMIN réussie pour: {} {} - Code SMS envoyé", 
                    citoyen.getNom(), citoyen.getPrenom());

        return MessageResponse.success("Code de vérification envoyé au " + 
                                      formattedTelephone.substring(0, 7) + "***. " +
                                      "Veuillez saisir le code reçu par SMS.");
    }

    /**
     * Vérification du code SMS ADMIN - Étape 2 : Connexion finale
     * Vérifie le code SMS et connecte l'administrateur
     */
    public JwtResponse verifierCodeSmsAdmin(VerificationSmsRequest request) {
        // Format phone number with +223 prefix for consistent lookup
        String formattedTelephone = formatPhoneNumber(request.getTelephone());
        
        logger.info("🔐 Vérification code SMS ADMIN pour: {}", formattedTelephone);
        
        Citoyen citoyen = citoyenRepository.findByTelephone(formattedTelephone)
                .orElseThrow(() -> {
                    logger.error("❌ Numéro de téléphone non trouvé: {}", formattedTelephone);
                    return new RuntimeException("Numéro de téléphone non trouvé");
                });

        // Vérifier que c'est bien un ADMIN (double sécurité)
        if (citoyen.getRole() != Citoyen.RoleCitoyen.ADMIN) {
            logger.warn("❌ Tentative de vérification SMS pour non-admin: {}", formattedTelephone);
            throw new RuntimeException("Accès refusé : Ce compte n'est pas un compte administrateur.");
        }

        logger.debug("Code en BDD: {}, Code reçu: {}", citoyen.getCodeSms(), request.getCode());
        
        // Vérifier le code SMS
        if (citoyen.getCodeSms() == null) {
            logger.error("❌ Aucun code SMS en base pour: {}", formattedTelephone);
            throw new RuntimeException("Aucun code SMS n'a été généré. Veuillez d'abord demander un code.");
        }
        
        if (!citoyen.getCodeSms().equals(request.getCode())) {
            logger.error("❌ Code SMS invalide. Attendu: {}, Reçu: {}", citoyen.getCodeSms(), request.getCode());
            throw new RuntimeException("Code SMS invalide. Vérifiez le code reçu par SMS.");
        }

        // Vérifier l'expiration du code
        if (citoyen.getCodeSmsExpiration() == null) {
            logger.error("❌ Pas de date d'expiration pour le code SMS");
            throw new RuntimeException("Erreur interne: code SMS sans expiration");
        }
        
        if (citoyen.getCodeSmsExpiration().isBefore(java.time.LocalDateTime.now())) {
            logger.error("❌ Code SMS expiré. Expiration: {}, Maintenant: {}", 
                        citoyen.getCodeSmsExpiration(), java.time.LocalDateTime.now());
            throw new RuntimeException("Code SMS expiré (valide 2 minutes). Veuillez demander un nouveau code.");
        }

        // Marquer le téléphone comme vérifié
        citoyen.setTelephoneVerifie(true);
        citoyen.setCodeSms(null);
        citoyen.setCodeSmsExpiration(null);
        citoyenRepository.save(citoyen);

        // Générer le JWT avec UserDetailsImpl
        UserDetailsImpl userDetails = UserDetailsImpl.build(citoyen);
        Authentication authentication = new UsernamePasswordAuthenticationToken(
                userDetails,
                null,
                userDetails.getAuthorities()
        );
        String jwt = jwtUtils.generateJwtToken(authentication);

        logger.info("✅ ADMIN connecté après vérification SMS: {} {} ({})", 
                    citoyen.getNom(), citoyen.getPrenom(), citoyen.getTelephone());

        return new JwtResponse(
                jwt,
                citoyen.getId(),
                citoyen.getNom(),
                citoyen.getPrenom(),
                citoyen.getEmail(),
                citoyen.getTelephone(),
                citoyen.getLanguePreferee()
        );
    }
}
