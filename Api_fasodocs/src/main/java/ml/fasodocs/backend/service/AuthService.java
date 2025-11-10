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
import ml.fasodocs.backend.entity.Role;
import ml.fasodocs.backend.repository.CitoyenRepository;
import ml.fasodocs.backend.repository.RoleRepository;
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

import java.util.*;

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
    private RoleRepository roleRepository;

    @Autowired
    private PasswordEncoder encoder;

    @Autowired
    private JwtUtils jwtUtils;
    
    @Autowired
    private OrangeSmsService orangeSmsService;

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

        // Attribuer le rôle CITOYEN par défaut
        Role roleCitoyen = roleRepository.findByNom(Role.NomRole.ROLE_CITOYEN)
                .orElseThrow(() -> new RuntimeException("Erreur: Rôle non trouvé."));
        
        Set<Role> roles = new HashSet<>();
        roles.add(roleCitoyen);
        citoyen.setRoles(roles);

        // Sauvegarder le citoyen
        citoyenRepository.save(citoyen);

        logger.info("Nouveau citoyen inscrit avec le téléphone: {}", citoyen.getTelephone());

        return MessageResponse.success("Inscription réussie! Vous pouvez maintenant vous connecter.");
    }
    
    /**
     * Format phone number with +223 prefix if not already present
     */
    private String formatPhoneNumber(String telephone) {
        if (telephone == null || telephone.isEmpty()) {
            return telephone;
        }
        
        // Remove any existing + or spaces
        String cleanNumber = telephone.replaceAll("[+\\s]", "");
        
        // If it starts with 223, add the + prefix
        if (cleanNumber.startsWith("223")) {
            return "+" + cleanNumber;
        }
        
        // If it doesn't start with 223 but has 8 digits, assume it's a local Mali number
        if (!cleanNumber.startsWith("223") && cleanNumber.length() == 8) {
            return "+223" + cleanNumber;
        }
        
        // If it already has the +223 prefix, return as is
        if (cleanNumber.startsWith("+223")) {
            return cleanNumber;
        }
        
        // Return the original if we can't format it
        return telephone;
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
        citoyen.setCodeSmsExpiration(java.time.LocalDateTime.now().plusMinutes(5));
        citoyenRepository.save(citoyen);

        // 4. Envoyer le SMS UNIQUEMENT si toutes les vérifications sont OK
        try {
            orangeSmsService.envoyerSmsConnexion(citoyen.getTelephone(), codeSms);
            logger.info("Code SMS envoyé avec succès pour: {}", citoyen.getTelephone());
        } catch (RuntimeException e) {
            logger.error("Échec de l'envoi du SMS à {}: {}", citoyen.getTelephone(), e.getMessage());
            // Ne pas lever d'exception ici car le code est déjà généré et sauvegardé
            // L'utilisateur peut toujours utiliser le code manuellement si nécessaire
            // Mais on ne log pas "succès" si l'envoi a échoué
            throw new RuntimeException("Impossible d'envoyer le SMS. Veuillez réessayer plus tard ou contacter le support.");
        }

        return MessageResponse.success("Un code de vérification a été envoyé au " + 
                                      formattedTelephone.substring(0, 7) + "***");
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

        // Format phone number with +223 prefix for consistent SMS sending
        String formattedTelephone = formatPhoneNumber(citoyen.getTelephone());

        // Générer un code SMS
        String codeSms = orangeSmsService.genererCodeVerification();
        citoyen.setCodeSms(codeSms);
        citoyen.setCodeSmsExpiration(java.time.LocalDateTime.now().plusMinutes(5));
        citoyenRepository.save(citoyen);

        // Envoyer le SMS
        orangeSmsService.envoyerSmsConnexion(formattedTelephone, codeSms);

        logger.info("Code SMS envoyé pour la connexion: {}", formattedTelephone);

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

        // Mise à jour du nom si fourni
        if (request.getNom() != null && !request.getNom().trim().isEmpty()) {
            citoyen.setNom(request.getNom().trim());
        }
        
        // Mise à jour du prénom si fourni
        if (request.getPrenom() != null && !request.getPrenom().trim().isEmpty()) {
            citoyen.setPrenom(request.getPrenom().trim());
        }
        
        // Mise à jour du téléphone si fourni
        if (request.getTelephone() != null && !request.getTelephone().trim().isEmpty()) {
            citoyen.setTelephone(request.getTelephone().trim());
        }
        
        // Mise à jour de la langue si fournie
        if (request.getLanguePreferee() != null && !request.getLanguePreferee().trim().isEmpty()) {
            citoyen.setLanguePreferee(request.getLanguePreferee().trim());
        }
        
        // Mise à jour de la photo si fournie
        if (request.getPhotoProfil() != null && !request.getPhotoProfil().trim().isEmpty()) {
            citoyen.setPhotoProfil(request.getPhotoProfil());
            logger.info("Photo de profil mise à jour pour: {} {}", citoyen.getNom(), citoyen.getPrenom());
        }

        citoyenRepository.save(citoyen);

        logger.info("Profil mis à jour pour: {} {}", citoyen.getNom(), citoyen.getPrenom());

        return MessageResponse.success("Profil mis à jour avec succès!");
    }

    /**
     * Upload de photo de profil
     */
    public MessageResponse uploadPhotoProfil(UploadPhotoRequest request) {
        Citoyen citoyen = getProfilCitoyenConnecte();

        citoyen.setPhotoProfil(request.getPhotoProfil());
        citoyenRepository.save(citoyen);

        logger.info("Photo de profil mise à jour pour: {} {}", citoyen.getNom(), citoyen.getPrenom());

        return MessageResponse.success("Photo de profil mise à jour avec succès!");
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
}
