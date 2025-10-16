package ml.fasodocs.backend.service;

import ml.fasodocs.backend.dto.request.ConnexionRequest;
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
    private SmsService smsService;

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
     * Connexion d'un citoyen - Envoie un code SMS
     */
    public MessageResponse connecterCitoyen(ConnexionRequest request) {
        // Authentifier l'utilisateur
        Authentication authentication = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(request.getIdentifiant(), request.getMotDePasse()));

        UserDetailsImpl userDetails = (UserDetailsImpl) authentication.getPrincipal();
        
        Citoyen citoyen = citoyenRepository.findById(userDetails.getId())
                .orElseThrow(() -> new RuntimeException("Citoyen non trouvé"));

        // Générer un code SMS
        String codeSms = smsService.genererCodeVerification();
        citoyen.setCodeSms(codeSms);
        citoyen.setCodeSmsExpiration(java.time.LocalDateTime.now().plusMinutes(5));
        citoyenRepository.save(citoyen);

        // Envoyer le SMS
        smsService.envoyerSmsConnexion(citoyen.getTelephone(), codeSms);

        logger.info("Code SMS envoyé pour la connexion: {}", citoyen.getTelephone());

        return MessageResponse.success("Un code de vérification a été envoyé à votre téléphone.");
    }

    /**
     * Vérification du code SMS et connexion
     */
    public JwtResponse verifierCodeSms(VerificationSmsRequest request) {
        Citoyen citoyen = citoyenRepository.findByTelephone(request.getTelephone())
                .orElseThrow(() -> new RuntimeException("Téléphone non trouvé"));

        // Vérifier le code SMS
        if (citoyen.getCodeSms() == null || !citoyen.getCodeSms().equals(request.getCode())) {
            throw new RuntimeException("Code SMS invalide");
        }

        // Vérifier l'expiration du code
        if (citoyen.getCodeSmsExpiration().isBefore(java.time.LocalDateTime.now())) {
            throw new RuntimeException("Code SMS expiré");
        }

        // Marquer le téléphone comme vérifié
        citoyen.setTelephoneVerifie(true);
        citoyen.setCodeSms(null);
        citoyen.setCodeSmsExpiration(null);

        // Mettre à jour le token FCM si fourni
        if (request.getTokenFcm() != null) {
            citoyen.setTokenFcm(request.getTokenFcm());
        }

        citoyenRepository.save(citoyen);

        // Générer le JWT
        Authentication authentication = new UsernamePasswordAuthenticationToken(
                citoyen.getEmail() != null ? citoyen.getEmail() : citoyen.getTelephone(),
                null,
                new ArrayList<>()
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
     * Déconnexion (supprimer le token FCM)
     */
    public MessageResponse deconnecter() {
        Citoyen citoyen = getProfilCitoyenConnecte();
        citoyen.setTokenFcm(null);
        citoyenRepository.save(citoyen);

        logger.info("Citoyen déconnecté: {} {}", citoyen.getNom(), citoyen.getPrenom());

        return MessageResponse.success("Déconnexion réussie!");
    }
}
