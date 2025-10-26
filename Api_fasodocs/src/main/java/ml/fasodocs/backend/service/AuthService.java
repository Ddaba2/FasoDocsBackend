package ml.fasodocs.backend.service;

import ml.fasodocs.backend.dto.request.ConnexionRequest;
import ml.fasodocs.backend.dto.request.ConnexionTelephoneRequest;
import ml.fasodocs.backend.dto.request.InscriptionRequest;
import ml.fasodocs.backend.dto.request.MiseAJourProfilRequest;
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
        // Vérifier que les mots de passe correspondent
        if (!request.getMotDePasse().equals(request.getConfirmerMotDePasse())) {
            return MessageResponse.error("Erreur: Les mots de passe ne correspondent pas!");
        }

        // Vérifier si l'email existe déjà
        if (citoyenRepository.existsByEmail(request.getEmail())) {
            return MessageResponse.error("Erreur: L'email est déjà utilisé!");
        }

        // Vérifier si le téléphone existe déjà
        if (citoyenRepository.existsByTelephone(request.getTelephone())) {
            return MessageResponse.error("Erreur: Le téléphone est déjà utilisé!");
        }

        // Créer le nouveau citoyen
        Citoyen citoyen = new Citoyen();
        citoyen.setEmail(request.getEmail());
        citoyen.setTelephone(request.getTelephone());
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
     * Connexion par téléphone uniquement - Envoie un code SMS
     * SÉCURITÉ : Vérifie d'abord que le numéro existe en base de données
     */
    public MessageResponse connecterParTelephone(ConnexionTelephoneRequest request) {
        // 1. Vérifier si le téléphone existe dans la base de données
        Citoyen citoyen = citoyenRepository.findByTelephone(request.getTelephone())
                .orElseThrow(() -> new RuntimeException("Numéro de téléphone non enregistré. Veuillez vous inscrire d'abord."));

        // 2. Vérifier si le compte est actif
        if (!citoyen.getEstActif()) {
            throw new RuntimeException("Votre compte a été désactivé. Veuillez contacter le support.");
        }

        // 3. Générer un code SMS à 6 chiffres
        String codeSms = orangeSmsService.genererCodeVerification();
        citoyen.setCodeSms(codeSms);
        citoyen.setCodeSmsExpiration(java.time.LocalDateTime.now().plusMinutes(5));
        citoyenRepository.save(citoyen);

        // 4. Envoyer le SMS UNIQUEMENT si toutes les vérifications sont OK
        orangeSmsService.envoyerSmsConnexion(citoyen.getTelephone(), codeSms);
        logger.info("Code SMS envoyé avec succès pour: {}", citoyen.getTelephone());

        return MessageResponse.success("Un code de vérification a été envoyé au " + 
                                      request.getTelephone().substring(0, 7) + "***");
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

        // Générer un code SMS
        String codeSms = orangeSmsService.genererCodeVerification();
        citoyen.setCodeSms(codeSms);
        citoyen.setCodeSmsExpiration(java.time.LocalDateTime.now().plusMinutes(5));
        citoyenRepository.save(citoyen);

        // Envoyer le SMS
        orangeSmsService.envoyerSmsConnexion(citoyen.getTelephone(), codeSms);

        logger.info("Code SMS envoyé pour la connexion: {}", citoyen.getTelephone());

        return MessageResponse.success("Un code de vérification a été envoyé à votre téléphone.");
    }

    /**
     * Vérification du code SMS et connexion
     */
    public JwtResponse verifierCodeSms(VerificationSmsRequest request) {
        logger.info("Tentative de vérification SMS pour: {}", request.getTelephone());
        
        Citoyen citoyen = citoyenRepository.findByTelephone(request.getTelephone())
                .orElseThrow(() -> {
                    logger.error("Numéro de téléphone non trouvé: {}", request.getTelephone());
                    return new RuntimeException("Numéro de téléphone non trouvé");
                });

        logger.debug("Code en BDD: {}, Code reçu: {}", citoyen.getCodeSms(), request.getCode());
        
        // Vérifier le code SMS
        if (citoyen.getCodeSms() == null) {
            logger.error("Aucun code SMS en base pour: {}", request.getTelephone());
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
     */
    public MessageResponse mettreAJourProfil(MiseAJourProfilRequest request) {
        Citoyen citoyen = getProfilCitoyenConnecte();

        citoyen.setNom(request.getNom());
        citoyen.setPrenom(request.getPrenom());
        
        if (request.getTelephone() != null) {
            citoyen.setTelephone(request.getTelephone());
        }
        
        if (request.getLanguePreferee() != null) {
            citoyen.setLanguePreferee(request.getLanguePreferee());
        }

        citoyenRepository.save(citoyen);

        logger.info("Profil mis à jour pour: {} {}", citoyen.getNom(), citoyen.getPrenom());

        return MessageResponse.success("Profil mis à jour avec succès!");
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
