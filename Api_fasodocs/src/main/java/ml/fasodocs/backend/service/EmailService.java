package ml.fasodocs.backend.service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

/**
 * Service pour l'envoi d'emails
 */
@Service
public class EmailService {

    private static final Logger logger = LoggerFactory.getLogger(EmailService.class);

    @Autowired
    private JavaMailSender mailSender;

    @Value("${spring.mail.username}")
    private String fromEmail;

    /**
     * Formate l'adresse email avec le nom d'expéditeur FasoDocs
     */
    private String formatFromAddress() {
        return "FasoDocs <" + fromEmail + ">";
    }

    /**
     * Envoie un email de vérification
     */
    public void envoyerEmailVerification(String toEmail, String codeVerification) {
        try {
            SimpleMailMessage message = new SimpleMailMessage();
            message.setFrom(formatFromAddress());
            message.setTo(toEmail);
            message.setSubject("FasoDocs - Vérification de votre compte");
            message.setText("Bienvenue sur FasoDocs!\n\n" +
                    "Pour vérifier votre compte, veuillez cliquer sur le lien suivant:\n" +
                    "http://localhost:8080/api/auth/verify?code=" + codeVerification + "\n\n" +
                    "Si vous n'avez pas créé de compte, veuillez ignorer cet email.\n\n" +
                    "Cordialement,\n" +
                    "L'équipe FasoDocs");

            mailSender.send(message);
            logger.info("Email de vérification envoyé à: {}", toEmail);
        } catch (Exception e) {
            logger.error("Erreur lors de l'envoi de l'email de vérification: {}", e.getMessage());
        }
    }

    /**
     * Envoie une notification par email
     */
    public void envoyerNotificationEmail(String toEmail, String sujet, String contenu) {
        try {
            SimpleMailMessage message = new SimpleMailMessage();
            message.setFrom(formatFromAddress());
            message.setTo(toEmail);
            message.setSubject("FasoDocs - " + sujet);
            message.setText(contenu);

            mailSender.send(message);
            logger.info("Notification email envoyée à: {}", toEmail);
        } catch (Exception e) {
            logger.error("Erreur lors de l'envoi de la notification email: {}", e.getMessage());
        }
    }

    /**
     * Envoie un email de bienvenue lors de l'auto-inscription
     */
    public void envoyerEmailInscriptionReussie(String toEmail, String telephone) {
        try {
            SimpleMailMessage message = new SimpleMailMessage();
            message.setFrom(formatFromAddress());
            message.setTo(toEmail);
            message.setSubject("FasoDocs - Bienvenue ! Inscription réussie 🎉");
            
            String contenu = String.format(
                "Bonjour,\n\n" +
                "Félicitations ! Votre inscription sur FasoDocs a été effectuée avec succès ! 🎉\n\n" +
                "📱 Vos identifiants de connexion:\n" +
                "   • Téléphone: %s\n" +
                "   • Email: %s\n" +
                "   • Mot de passe: Celui que vous avez choisi lors de l'inscription\n\n" +
                "🔗 Pour vous connecter:\n" +
                "   • Application mobile FasoDocs\n" +
                "   • Site web: http://localhost:8080\n\n" +
                "✨ Découvrez toutes les fonctionnalités:\n" +
                "   • Consultation de plus de 100 procédures administratives\n" +
                "   • Recherche rapide par catégorie ou mot-clé\n" +
                "   • Suivi de vos démarches en cours\n" +
                "   • Signalement de problèmes\n" +
                "   • Notifications personnalisées\n" +
                "   • Support en français et bambara\n\n" +
                "💡 Conseils pour bien démarrer:\n" +
                "   1. Complétez votre profil (nom, prénom)\n" +
                "   2. Explorez les catégories disponibles\n" +
                "   3. Ajoutez vos procédures favorites\n" +
                "   4. Activez les notifications\n\n" +
                "🔒 Sécurité:\n" +
                "   • Ne partagez jamais votre mot de passe\n" +
                "   • Utilisez un mot de passe fort et unique\n" +
                "   • Déconnectez-vous après chaque session sur appareil partagé\n\n" +
                "📞 Besoin d'aide ?\n" +
                "Notre équipe est à votre disposition:\n" +
                "   • Email: support@fasodocs.ml\n" +
                "   • Téléphone: +223 74 32 38 74\n\n" +
                "Merci de nous faire confiance pour vos démarches administratives !\n\n" +
                "Cordialement,\n" +
                "L'équipe FasoDocs\n\n" +
                "---\n" +
                "Cet email a été envoyé automatiquement, merci de ne pas y répondre.",
                telephone, toEmail
            );
            
            message.setText(contenu);
            mailSender.send(message);
            logger.info("✅ Email d'inscription réussie envoyé à: {}", toEmail);
        } catch (Exception e) {
            logger.error("❌ Erreur lors de l'envoi de l'email d'inscription: {}", e.getMessage());
        }
    }

    /**
     * Envoie un email de bienvenue lors de la création de compte par l'admin
     */
    public void envoyerEmailCreationCompte(String toEmail, String nom, String prenom, String telephone, String motDePasseTemporaire) {
        try {
            SimpleMailMessage message = new SimpleMailMessage();
            message.setFrom(formatFromAddress());
            message.setTo(toEmail);
            message.setSubject("FasoDocs - Bienvenue ! Votre compte a été créé");
            
            String contenu = String.format(
                "Bonjour %s %s,\n\n" +
                "Bienvenue sur FasoDocs !\n\n" +
                "Un compte a été créé pour vous par un administrateur.\n\n" +
                "📱 Vos informations de connexion:\n" +
                "   • Téléphone: %s\n" +
                "   • Email: %s\n" +
                "   • Mot de passe temporaire: %s\n\n" +
                "⚠️ IMPORTANT: Pour votre sécurité, nous vous recommandons de changer ce mot de passe dès votre première connexion.\n\n" +
                "🔗 Pour vous connecter:\n" +
                "   • Application mobile FasoDocs\n" +
                "   • Site web: http://localhost:8080\n\n" +
                "Vous pouvez maintenant accéder à toutes les procédures administratives du Mali en quelques clics.\n\n" +
                "Si vous avez des questions, n'hésitez pas à nous contacter.\n\n" +
                "Cordialement,\n" +
                "L'équipe FasoDocs\n\n" +
                "---\n" +
                "Cet email a été envoyé automatiquement, merci de ne pas y répondre.",
                prenom, nom, telephone, toEmail, motDePasseTemporaire
            );
            
            message.setText(contenu);
            mailSender.send(message);
            logger.info("✅ Email de création de compte envoyé à: {}", toEmail);
        } catch (Exception e) {
            logger.error("❌ Erreur lors de l'envoi de l'email de création de compte: {}", e.getMessage());
        }
    }

    /**
     * Envoie un email de notification d'activation de compte
     */
    public void envoyerEmailActivationCompte(String toEmail, String nom, String prenom) {
        try {
            SimpleMailMessage message = new SimpleMailMessage();
            message.setFrom(formatFromAddress());
            message.setTo(toEmail);
            message.setSubject("FasoDocs - ✅ Votre compte a été activé");
            
            String contenu = String.format(
                "Bonjour %s %s,\n\n" +
                "Bonne nouvelle ! 🎉\n\n" +
                "Votre compte FasoDocs a été réactivé par un administrateur.\n\n" +
                "Vous pouvez désormais vous reconnecter et accéder à tous les services :\n" +
                "   • Consultation des procédures administratives\n" +
                "   • Suivi de vos démarches\n" +
                "   • Signalement de problèmes\n" +
                "   • Notifications personnalisées\n\n" +
                "🔗 Pour vous connecter:\n" +
                "   • Application mobile FasoDocs\n" +
                "   • Site web: http://localhost:8080\n\n" +
                "Nous sommes ravis de vous revoir !\n\n" +
                "Si vous n'êtes pas à l'origine de cette demande, veuillez contacter immédiatement notre support.\n\n" +
                "Cordialement,\n" +
                "L'équipe FasoDocs\n\n" +
                "---\n" +
                "Cet email a été envoyé automatiquement, merci de ne pas y répondre.",
                prenom, nom
            );
            
            message.setText(contenu);
            mailSender.send(message);
            logger.info("✅ Email d'activation de compte envoyé à: {}", toEmail);
        } catch (Exception e) {
            logger.error("❌ Erreur lors de l'envoi de l'email d'activation: {}", e.getMessage());
        }
    }

    /**
     * Envoie un email de notification de désactivation de compte
     */
    public void envoyerEmailDesactivationCompte(String toEmail, String nom, String prenom, String raison) {
        try {
            SimpleMailMessage message = new SimpleMailMessage();
            message.setFrom(formatFromAddress());
            message.setTo(toEmail);
            message.setSubject("FasoDocs - ⚠️ Votre compte a été désactivé");
            
            String raisonTexte = (raison != null && !raison.isEmpty()) 
                ? "\n📋 Raison: " + raison + "\n" 
                : "";
            
            String contenu = String.format(
                "Bonjour %s %s,\n\n" +
                "Nous vous informons que votre compte FasoDocs a été temporairement désactivé par un administrateur.\n" +
                "%s\n" +
                "⚠️ Conséquences de cette désactivation:\n" +
                "   • Vous ne pouvez plus vous connecter à votre compte\n" +
                "   • Vos données sont conservées en toute sécurité\n" +
                "   • Votre compte peut être réactivé à tout moment\n\n" +
                "📞 Pour plus d'informations:\n" +
                "Si vous pensez qu'il s'agit d'une erreur ou si vous souhaitez faire réactiver votre compte, \n" +
                "veuillez contacter notre support:\n" +
                "   • Email: support@fasodocs.ml\n" +
                "   • Téléphone: +223 XX XX XX XX\n\n" +
                "Nous restons à votre disposition pour toute question.\n\n" +
                "Cordialement,\n" +
                "L'équipe FasoDocs\n\n" +
                "---\n" +
                "Cet email a été envoyé automatiquement, merci de ne pas y répondre.",
                prenom, nom, raisonTexte
            );
            
            message.setText(contenu);
            mailSender.send(message);
            logger.info("✅ Email de désactivation de compte envoyé à: {}", toEmail);
        } catch (Exception e) {
            logger.error("❌ Erreur lors de l'envoi de l'email de désactivation: {}", e.getMessage());
        }
    }
}
