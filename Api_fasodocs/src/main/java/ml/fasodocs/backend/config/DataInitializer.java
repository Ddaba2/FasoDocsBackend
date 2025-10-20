package ml.fasodocs.backend.config;

import ml.fasodocs.backend.entity.*;
import ml.fasodocs.backend.repository.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

import java.util.HashSet;
import java.util.Set;

/**
 * Initialise les données de base de l'application
 */
@Component
public class DataInitializer implements CommandLineRunner {

    private static final Logger logger = LoggerFactory.getLogger(DataInitializer.class);

    @Autowired
    private RoleRepository roleRepository;

    @Autowired
    private CitoyenRepository citoyenRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;
    
    @Autowired
    private CategorieRepository categorieRepository;
    
    @Autowired
    private SousCategorieRepository sousCategorieRepository;
    
    @Value("${app.init.chatbot-data:true}")
    private boolean initChatbotData;

    @Override
    public void run(String... args) throws Exception {
        initializeRoles();
        initializeAdminAccount();
        
        // Initialiser les données du chatbot si activé
        if (initChatbotData) {
            initializeChatbotData();
        }
    }

    /**
     * Initialise les rôles par défaut
     */
    private void initializeRoles() {
        if (roleRepository.count() == 0) {
            Role roleCitoyen = new Role();
            roleCitoyen.setNom(Role.NomRole.ROLE_CITOYEN);
            roleRepository.save(roleCitoyen);

            Role roleAdmin = new Role();
            roleAdmin.setNom(Role.NomRole.ROLE_ADMIN);
            roleRepository.save(roleAdmin);

            logger.info("Rôles initialisés: ROLE_CITOYEN, ROLE_ADMIN");
        }
    }

    /**
     * Initialise un compte administrateur par défaut
     */
    private void initializeAdminAccount() {
        // Vérifier si un admin existe déjà
        Role roleAdmin = roleRepository.findByNom(Role.NomRole.ROLE_ADMIN)
                .orElseThrow(() -> new RuntimeException("Role ADMIN non trouvé"));

        boolean adminExists = citoyenRepository.findAll().stream()
                .anyMatch(c -> c.getRoles().contains(roleAdmin));

        if (!adminExists) {
            Citoyen admin = new Citoyen();
            admin.setNom("Admin");
            admin.setPrenom("FasoDocs");
            admin.setEmail("admin@fasodocs.ml");
            admin.setTelephone("+22370000000");
            admin.setMotDePasse(passwordEncoder.encode("Admin@2025"));
            admin.setEstActif(true);
            admin.setEmailVerifie(true);
            admin.setLanguePreferee("fr");

            Set<Role> roles = new HashSet<>();
            roles.add(roleAdmin);
            admin.setRoles(roles);

            citoyenRepository.save(admin);

            logger.info("================================================");
            logger.info("Compte administrateur créé avec succès !");
            logger.info("Email: admin@fasodocs.ml");
            logger.info("Mot de passe: Admin@2025");
            logger.info("⚠️  CHANGEZ CE MOT DE PASSE EN PRODUCTION !");
            logger.info("================================================");
        }
    }
    
    /**
     * Initialise les données du chatbot (catégories, procédures, lieux)
     */
    private void initializeChatbotData() {
        logger.info("📊 Initialisation des données du chatbot...");
        
        // Vérifier si des données existent déjà
        if (categorieRepository.count() > 0) {
            logger.info("✅ Données du chatbot déjà présentes. Initialisation ignorée.");
            return;
        }
        
        try {
            // 1. Créer les catégories et sous-catégories
            
            // Identité et citoyenneté
            Categorie catIdentite = creerCategorie("Identité et citoyenneté", 
                "Documents d'identité, état civil et citoyenneté", "🪪");
            creerSousCategorie("Extrait d'acte de naissance", catIdentite);
            creerSousCategorie("Extrait d'acte de mariage", catIdentite);
            creerSousCategorie("Demande de divorce", catIdentite);
            creerSousCategorie("Acte de décès", catIdentite);
            creerSousCategorie("Certificat de nationalité", catIdentite);
            creerSousCategorie("Certificat de casier judiciaire", catIdentite);
            creerSousCategorie("Carte d'identité nationale", catIdentite);
            creerSousCategorie("Passeport malien", catIdentite);
            creerSousCategorie("Nationalité(par voie de naturalisation, par mariage)", catIdentite);
            creerSousCategorie("Carte d'électeur", catIdentite);
            creerSousCategorie("Fiche de résidence", catIdentite);
            creerSousCategorie("Inscription liste électorale", catIdentite);
            
            // Création d'entreprise
            Categorie catEntreprise = creerCategorie("Création d'entreprise", 
                "Création et gestion d'entreprises", "🏢");
            creerSousCategorie("Entreprise individuel", catEntreprise);
            creerSousCategorie("Entreprise SARL", catEntreprise);
            creerSousCategorie("Entreprise unipersonnelle à responsabilité limitée (EURL, SARL unipersonnelle)", catEntreprise);
            creerSousCategorie("Sociétés Anonymes (SA)", catEntreprise);
            creerSousCategorie("Sociétés en Nom Collectif (SNC)", catEntreprise);
            creerSousCategorie("Sociétés en Commandite Simple (SCS)", catEntreprise);
            creerSousCategorie("Sociétés par Actions Simplifiées (SAS)", catEntreprise);
            creerSousCategorie("Sociétés par Actions Simplifiées Unipersonnelle (SASU)", catEntreprise);
            
            // Documents auto
            Categorie catAuto = creerCategorie("Documents auto", 
                "Permis, carte grise et documents automobiles", "🚗");
            creerSousCategorie("Permis de conduire(renouvellement)", catAuto);
            creerSousCategorie("Carte grise(obtention, mutation et renouvellement)", catAuto);
            creerSousCategorie("Visite technique", catAuto);
            creerSousCategorie("Vignette", catAuto);
            creerSousCategorie("Changement de couleur de plaque", catAuto);
            
            // Service fonciers
            Categorie catFoncier = creerCategorie("Service fonciers", 
                "Titres fonciers, permis de construire et gestion immobilière", "🏘️");
            creerSousCategorie("Permis de construire(à usage industriel, à usage personnelle)", catFoncier);
            creerSousCategorie("Demande de bail", catFoncier);
            creerSousCategorie("Titre foncier", catFoncier);
            creerSousCategorie("Vérification des titres de propriétés", catFoncier);
            creerSousCategorie("Lettre d'attribution du titre provisoire de concession rurale", catFoncier);
            creerSousCategorie("permis d'occupation", catFoncier);
            creerSousCategorie("Lettre de transfert de parcelle à usage d'habitation", catFoncier);
            creerSousCategorie("Titre provisoire en titre foncier(CUH, CRH et contrat de bail avec promesse de vente)", catFoncier);
            creerSousCategorie("Concession urbaine à usage d'habitation(CUH)", catFoncier);
            
            // Eau et électricité
            Categorie catEauElec = creerCategorie("Eau et électricité", 
                "Services d'eau et d'électricité", "💡");
            creerSousCategorie("Demande d'un compteur d'eau", catEauElec);
            creerSousCategorie("Demande d'un compteur d'électricité", catEauElec);
            creerSousCategorie("Récupérer un compteur d'eau suspendue", catEauElec);
            creerSousCategorie("Récupérer un compteur d'électricité suspendue", catEauElec);
            creerSousCategorie("Demande de transférer d'un compteur d'eau", catEauElec);
            creerSousCategorie("Demande de transférer d'un compteur d'électricité", catEauElec);
            
            // Justice
            Categorie catJustice = creerCategorie("Justice", 
                "Services judiciaires et procédures juridiques", "⚖️");
            creerSousCategorie("Déclaration de vol", catJustice);
            creerSousCategorie("Déclaration de perte", catJustice);
            creerSousCategorie("Règlement d'un litige", catJustice);
            creerSousCategorie("Demande de visite d'un prisonnier", catJustice);
            creerSousCategorie("Demande d'appel d'une décision de jugement", catJustice);
            creerSousCategorie("Demande de libération conditionnelle", catJustice);
            creerSousCategorie("Demande de libération provisoire", catJustice);
            creerSousCategorie("Autorisation d'achat d'armes et munitions", catJustice);
            creerSousCategorie("Autorisation de vente des biens d'un mineur", catJustice);
            
            // Impôt et Douane
            Categorie catImpot = creerCategorie("Impôt et Douane", 
                "Déclarations fiscales et douanières", "💰");
            creerSousCategorie("Déclaration de revenu foncier", catImpot);
            creerSousCategorie("Déclaration de TVA(Taxe sur la Valeur Ajoutée)", catImpot);
            creerSousCategorie("Enregistrement d'un contrat", catImpot);
            creerSousCategorie("L'Impôt sur les traitements et salaires (I.T.S)", catImpot);
            creerSousCategorie("La Contribution forfaitaire à la charge des employeurs (CFE)", catImpot);
            creerSousCategorie("La Taxe logement (TL)", catImpot);
            creerSousCategorie("La Contribution Générale de solidarité (CGS) (Loi 2018-010 du 12 Février 2018)", catImpot);
            creerSousCategorie("La Taxe de Solidarité et de Lutte contre le Tabagisme (TSLT) (Loi 2018-010 du 12 Février 2018)", catImpot);
            creerSousCategorie("L'Impôt sur les bénéfices industriels et commerciaux (IBIC /IS)", catImpot);
            creerSousCategorie("L'Impôt synthétique", catImpot);
            creerSousCategorie("L'Impôt sur les bénéfices agricoles (IBA)", catImpot);
            creerSousCategorie("L'Impôt sur les revenus de valeurs Mobilières (IRVM)", catImpot);
            creerSousCategorie("L'Impôt sur les revenus fonciers (IRF)", catImpot);
            creerSousCategorie("La Taxe foncière (T.F)", catImpot);
            creerSousCategorie("La Patente professionnelle et licence", catImpot);
            creerSousCategorie("La Patente sur marchés", catImpot);
            creerSousCategorie("La Taxe touristique (T.T)", catImpot);
            creerSousCategorie("La taxe sur les véhicules automobiles (Vignettes ordinaires)", catImpot);
            creerSousCategorie("La Taxe sur les transports routiers (TTR)", catImpot);
            creerSousCategorie("Les prélèvements", catImpot);
            creerSousCategorie("La redevance et le recouvrement de régulation sur les marchés publics", catImpot);
            creerSousCategorie("Impôt spécial sur certains produits (ISCP)", catImpot);
            creerSousCategorie("Taxe sur les activités financières(TAF)", catImpot);
            creerSousCategorie("Taxe intérieure sur les produits pétroliers (TIPP)", catImpot);
            creerSousCategorie("Contribution de solidarité sur les billets d'avion (CSB)", catImpot);
            creerSousCategorie("Taxe sur l'accès au réseau des télécommunications ouvert au public (TARTOP)", catImpot);
            creerSousCategorie("Taxe sur les contrats d'assurance (TCA)", catImpot);
            creerSousCategorie("Taxe sur les exportateurs d'or non régis par le code minier", catImpot);
            creerSousCategorie("Taxe sur les armes à feu", catImpot);
            
            logger.info("================================================");
            logger.info("🎉 Données du chatbot initialisées avec succès !");
            logger.info("📊 Statistiques:");
            logger.info("   - Catégories: {}", categorieRepository.count());
            logger.info("   - Sous-catégories: {}", sousCategorieRepository.count());
            logger.info("================================================");
            
        } catch (Exception e) {
            logger.error("❌ Erreur lors de l'initialisation des données du chatbot", e);
        }
    }
    
    private Categorie creerCategorie(String titre, String description, String icone) {
        Categorie categorie = new Categorie();
        categorie.setTitre(titre);
        categorie.setDescription(description);
        categorie.setIconeUrl(icone);
        // Définir le nom de catégorie basé sur le titre
        categorie.setNomCategorie(CategorieEnum.AUTRES_DOMAINES); // Valeur par défaut
        return categorieRepository.save(categorie);
    }
    
    private SousCategorie creerSousCategorie(String titre, Categorie categorie) {
        SousCategorie sousCategorie = new SousCategorie();
        sousCategorie.setTitre(titre);
        sousCategorie.setCategorie(categorie);
        return sousCategorieRepository.save(sousCategorie);
    }
}
