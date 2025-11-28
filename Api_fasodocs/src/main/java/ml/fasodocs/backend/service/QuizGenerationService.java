package ml.fasodocs.backend.service;

import ml.fasodocs.backend.entity.*;
import ml.fasodocs.backend.repository.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;

import java.time.LocalDate;
import java.util.*;

/**
 * Service pour la génération automatique des quiz quotidiens
 */
@Service
@Transactional
public class QuizGenerationService {

    private static final Logger logger = LoggerFactory.getLogger(QuizGenerationService.class);

    @Autowired
    private QuizJournalierRepository quizJournalierRepository;

    @Autowired
    private QuizQuestionRepository quizQuestionRepository;

    @Autowired
    private QuizReponseRepository quizReponseRepository;

    @Autowired
    private ProcedureRepository procedureRepository;

    @Autowired
    private TranslationHelper translationHelper;

    @PersistenceContext
    private EntityManager entityManager;

    @Value("${quiz.nombre-total.facile:30}")
    private int nombreTotalQuizFacile;

    @Value("${quiz.nombre-total.moyen:30}")
    private int nombreTotalQuizMoy;

    @Value("${quiz.nombre-total.difficile:30}")
    private int nombreTotalQuizDifficile;

    /**
     * Génère tous les quiz (30 par niveau) au démarrage
     * Les quiz ne sont plus liés à une date spécifique - disponibles en permanence
     */
    public void genererQuizQuotidien() {
        genererTousLesQuiz();
    }

    /**
     * Génère tous les quiz par niveau (30 FACILE, 30 MOYEN, 30 DIFFICILE)
     * Les quiz sont générés une seule fois et disponibles en permanence
     */
    public void genererTousLesQuiz() {
        // Générer tous les quiz FACILE
        genererTousLesQuizPourNiveau("FACILE", nombreTotalQuizFacile);
        
        // Générer tous les quiz MOYEN
        genererTousLesQuizPourNiveau("MOYEN", nombreTotalQuizMoyen);
        
        // Gé
        // %-321FDSQ²&é"'(-789/)=$*nérer tous les quiz DIFFICILE
        genererTousLesQuizPourNiveau("DIFFICILE", nombreTotalQuizDifficile);
        
        logger.info("Tous les quiz générés avec succès: {} FACILE, {} MOYEN, {} DIFFICILE", 
            nombreTotalQuizFacile, nombreTotalQuizMoyen, nombreTotalQuizDifficile);
    }

    /**
     * Génère tous les quiz d'un niveau (sans limite de date)
     */
    private void genererTousLesQuizPourNiveau(String niveau, int nombreTotal) {
        // Compter combien de quiz existent déjà pour ce niveau (toutes dates confondues)
        long nombreQuizExistants = quizJournalierRepository.findAll()
                .stream()
                .filter(q -> niveau.equals(q.getNiveau()))
                .count();
        
        int quizACreer = (int)(nombreTotal - nombreQuizExistants);
        
        if (quizACreer <= 0) {
            logger.info("Tous les {} quiz {} existent déjà ({} trouvés)", nombreTotal, niveau, nombreQuizExistants);
            return;
        }
        
        logger.info("Génération de {} quiz {} ({} existent déjà, total requis: {})", 
            quizACreer, niveau, nombreQuizExistants, nombreTotal);
        
        // Utiliser la date d'aujourd'hui pour tous les quiz (mais ils seront disponibles en permanence)
        LocalDate dateCreation = LocalDate.now();
        
        int succes = 0;
        int echecs = 0;
        
        for (int i = 0; i < quizACreer; i++) {
            try {
                // Générer dans une transaction séparée pour éviter la corruption de session
                genererQuizPourDateEtNiveauDansTransaction(dateCreation, niveau);
                succes++;
                
                // Nettoyer la session après chaque succès
                entityManager.flush();
                entityManager.clear();
            } catch (Exception e) {
                echecs++;
                // Nettoyer la session en cas d'erreur pour éviter les objets corrompus
                entityManager.clear();
                
                // Si erreur de contrainte unique, continuer avec le quiz suivant
                String errorMsg = e.getMessage() != null ? e.getMessage() : "";
                if (errorMsg.contains("Duplicate entry") || 
                    errorMsg.contains("constraint") || 
                    errorMsg.contains("UK") ||
                    errorMsg.contains("unique")) {
                    logger.debug("⚠️ Quiz {} #{} déjà existant (contrainte unique), passage au suivant", niveau, i+1);
                    continue;
                }
                // Pour les autres erreurs, logger et continuer
                logger.warn("⚠️ Erreur lors de la génération du quiz {} #{}: {}", niveau, i+1, errorMsg);
            }
        }
        
        logger.info("✅ Génération {} terminée: {} succès, {} échecs sur {} tentatives", niveau, succes, echecs, quizACreer);
    }
    
    /**
     * Génère un quiz dans une transaction séparée pour isoler les erreurs
     */
    @Transactional(propagation = org.springframework.transaction.annotation.Propagation.REQUIRES_NEW)
    public void genererQuizPourDateEtNiveauDansTransaction(LocalDate date, String niveau) {
        genererQuizPourDateEtNiveau(date, niveau);
    }

    /**
     * Génère plusieurs quiz par niveau pour une date spécifiée (pour compatibilité)
     */
    public void genererQuizPourDate(LocalDate date) {
        // Pour compatibilité, mais maintenant on génère tous les quiz en une fois
        genererTousLesQuiz();
    }

    /**
     * Génère un quiz pour une date et un niveau spécifiés
     * Peut être appelé plusieurs fois pour créer plusieurs quiz du même niveau le même jour
     */
    public QuizJournalier genererQuizPourDateEtNiveau(LocalDate date, String niveau) {
        // Sélectionner une procédure aléatoire
        List<Procedure> toutesProcedures = procedureRepository.findAll();
        if (toutesProcedures.isEmpty()) {
            throw new RuntimeException("Aucune procédure disponible pour générer un quiz");
        }

        Random random = new Random();
        Procedure procedure = toutesProcedures.get(random.nextInt(toutesProcedures.size()));

        logger.info("Génération du quiz {} pour le {} avec la procédure: {}", 
            niveau, date, procedure.getNom());

        // Créer le quiz journalier
        QuizJournalier quiz = new QuizJournalier();
        quiz.setDateQuiz(date);
        quiz.setNiveau(niveau);
        quiz.setProcedure(procedure);
        quiz.setCategorie(procedure.getCategorie());
        quiz.setEstActif(true);
        quiz = quizJournalierRepository.save(quiz);

        // Générer 5 questions automatiquement selon le niveau
        List<QuizQuestion> questions = genererQuestions(quiz, procedure, niveau);
        quiz.setQuestions(new HashSet<>(questions));

        logger.info("Quiz {} généré avec succès pour le {}: {} questions créées", 
            niveau, date, questions.size());

        return quiz;
    }

    /**
     * Génère 5 questions pour un quiz basées sur une procédure et un niveau
     */
    private List<QuizQuestion> genererQuestions(QuizJournalier quiz, Procedure procedure, String niveau) {
        List<QuizQuestion> questions = new ArrayList<>();

        // Charger les relations nécessaires
        procedure = procedureRepository.findById(procedure.getId())
                .orElseThrow(() -> new RuntimeException("Procédure non trouvée"));

        // Adapter les questions selon le niveau
        // FACILE: questions simples (délai, coût, centre)
        // MOYEN: questions moyennes (documents, étapes)
        // DIFFICILE: questions complexes (lois, détails, combinaisons)
        
        if ("FACILE".equals(niveau)) {
            int ordre = 1;
            // Question 1: Délai
            if (procedure.getDelai() != null && !procedure.getDelai().isEmpty()) {
                QuizQuestion q1 = creerQuestionDelai(quiz, procedure, niveau);
                q1.setOrdre(ordre++);
                questions.add(q1);
            }
            // Question 2: Coût
            if (procedure.getCout() != null && procedure.getCout().getPrix() != null) {
                QuizQuestion q2 = creerQuestionCout(quiz, procedure, niveau);
                q2.setOrdre(ordre++);
                questions.add(q2);
            }
            // Question 3: Centre
            if (procedure.getCentre() != null) {
                QuizQuestion q3 = creerQuestionCentre(quiz, procedure, niveau);
                q3.setOrdre(ordre++);
                questions.add(q3);
            }
            // Question 4: Catégorie
            QuizQuestion q4 = creerQuestionGenerique(quiz, procedure, niveau);
            q4.setOrdre(ordre++);
            questions.add(q4);
            // Question 5: Autre question simple
            if (procedure.getDocumentsRequis() != null && !procedure.getDocumentsRequis().isEmpty()) {
                QuizQuestion q5 = creerQuestionDocument(quiz, procedure, niveau);
                q5.setOrdre(ordre++);
                questions.add(q5);
            }
        } else if ("MOYEN".equals(niveau)) {
            int ordre = 1;
            // Question 1: Documents requis
            if (procedure.getDocumentsRequis() != null && !procedure.getDocumentsRequis().isEmpty()) {
                QuizQuestion q1 = creerQuestionDocument(quiz, procedure, niveau);
                q1.setOrdre(ordre++);
                questions.add(q1);
            }
            // Question 2: Étape
            if (procedure.getEtapes() != null && !procedure.getEtapes().isEmpty()) {
                QuizQuestion q2 = creerQuestionEtape(quiz, procedure, niveau);
                q2.setOrdre(ordre++);
                questions.add(q2);
            }
            // Question 3: Délai (plus détaillé)
            if (procedure.getDelai() != null && !procedure.getDelai().isEmpty()) {
                QuizQuestion q3 = creerQuestionDelai(quiz, procedure, niveau);
                q3.setOrdre(ordre++);
                questions.add(q3);
            }
            // Question 4: Coût (plus détaillé)
            if (procedure.getCout() != null && procedure.getCout().getPrix() != null) {
                QuizQuestion q4 = creerQuestionCout(quiz, procedure, niveau);
                q4.setOrdre(ordre++);
                questions.add(q4);
            }
            // Question 5: Centre (plus détaillé)
            if (procedure.getCentre() != null) {
                QuizQuestion q5 = creerQuestionCentre(quiz, procedure, niveau);
                q5.setOrdre(ordre++);
                questions.add(q5);
            }
        } else if ("DIFFICILE".equals(niveau)) {
            int ordre = 1;
            // Question 1: Tous les documents requis
            if (procedure.getDocumentsRequis() != null && !procedure.getDocumentsRequis().isEmpty()) {
                QuizQuestion q1 = creerQuestionDocument(quiz, procedure, niveau);
                q1.setOrdre(ordre++);
                questions.add(q1);
            }
            // Question 2: Toutes les étapes
            if (procedure.getEtapes() != null && !procedure.getEtapes().isEmpty()) {
                QuizQuestion q2 = creerQuestionEtape(quiz, procedure, niveau);
                q2.setOrdre(ordre++);
                questions.add(q2);
            }
            // Question 3: Lois/articles
            if (procedure.getLoisArticles() != null && !procedure.getLoisArticles().isEmpty()) {
                QuizQuestion q3 = creerQuestionLoi(quiz, procedure);
                q3.setOrdre(ordre++);
                questions.add(q3);
            }
            // Question 4: Combinaison de plusieurs éléments
            QuizQuestion q4 = creerQuestionComplexe(quiz, procedure);
            q4.setOrdre(ordre++);
            questions.add(q4);
            // Question 5: Détails spécifiques
            QuizQuestion q5 = creerQuestionDetail(quiz, procedure);
            q5.setOrdre(ordre++);
            questions.add(q5);
        }

        // Si moins de 5 questions, compléter avec des questions génériques
        while (questions.size() < 5) {
            QuizQuestion q = creerQuestionGenerique(quiz, procedure, niveau);
            questions.add(q);
        }

        return questions;
    }

    private QuizQuestion creerQuestionDelai(QuizJournalier quiz, Procedure procedure, String niveauQuiz) {
        QuizQuestion question = new QuizQuestion();
        question.setQuizJournalier(quiz);
        question.setProcedure(procedure);
        question.setTypeQuestion("DELAI");
        // Points selon le niveau: FACILE=10, MOYEN=15, DIFFICILE=20
        question.setPoints("FACILE".equals(niveauQuiz) ? 10 : "MOYEN".equals(niveauQuiz) ? 15 : 20);
        question.setNiveau(niveauQuiz);

        String titreFr = procedure.getTitre();
        String titreEn = procedure.getTitreEn() != null ? procedure.getTitreEn() : titreFr;
        String delaiFr = procedure.getDelai();
        String delaiEn = procedure.getDelaiEn() != null ? procedure.getDelaiEn() : delaiFr;

        question.setQuestionFr("Quel est le délai pour " + titreFr + " ?");
        question.setQuestionEn("What is the deadline for " + titreEn + "?");
        question.setReponseCorrecte(delaiFr);

        question = quizQuestionRepository.save(question);

        // Créer les réponses possibles
        creerReponsesDelai(question, delaiFr, delaiEn);

        return question;
    }

    private QuizQuestion creerQuestionCout(QuizJournalier quiz, Procedure procedure, String niveauQuiz) {
        QuizQuestion question = new QuizQuestion();
        question.setQuizJournalier(quiz);
        question.setProcedure(procedure);
        question.setTypeQuestion("COUT");
        // Points selon le niveau: FACILE=10, MOYEN=15, DIFFICILE=20
        question.setPoints("FACILE".equals(niveauQuiz) ? 10 : "MOYEN".equals(niveauQuiz) ? 15 : 20);
        question.setNiveau(niveauQuiz);

        String titreFr = procedure.getTitre();
        String titreEn = procedure.getTitreEn() != null ? procedure.getTitreEn() : titreFr;
        Integer prix = procedure.getCout().getPrix();
        String reponseCorrecte = prix + " FCFA";

        question.setQuestionFr("Combien coûte " + titreFr + " ?");
        question.setQuestionEn("How much does " + titreEn + " cost?");
        question.setReponseCorrecte(reponseCorrecte);

        question = quizQuestionRepository.save(question);

        // Créer les réponses possibles
        creerReponsesCout(question, prix);

        return question;
    }

    private QuizQuestion creerQuestionDocument(QuizJournalier quiz, Procedure procedure, String niveauQuiz) {
        QuizQuestion question = new QuizQuestion();
        question.setQuizJournalier(quiz);
        question.setProcedure(procedure);
        question.setTypeQuestion("DOCUMENT");
        // Points selon le niveau: FACILE=10, MOYEN=15, DIFFICILE=25
        question.setPoints("FACILE".equals(niveauQuiz) ? 10 : "MOYEN".equals(niveauQuiz) ? 15 : 25);
        question.setNiveau(niveauQuiz);

        String titreFr = procedure.getTitre();
        String titreEn = procedure.getTitreEn() != null ? procedure.getTitreEn() : titreFr;

        // Prendre le premier document requis
        DocumentRequis premierDoc = procedure.getDocumentsRequis().iterator().next();
        String docNomFr = premierDoc.getNom();
        String docNomEn = premierDoc.getDescriptionEn() != null ? premierDoc.getDescriptionEn() : docNomFr;

        question.setQuestionFr("Quel document est requis pour " + titreFr + " ?");
        question.setQuestionEn("What document is required for " + titreEn + "?");
        question.setReponseCorrecte(docNomFr);

        question = quizQuestionRepository.save(question);

        // Créer les réponses possibles
        creerReponsesDocument(question, docNomFr, docNomEn, procedure);

        return question;
    }

    private QuizQuestion creerQuestionCentre(QuizJournalier quiz, Procedure procedure, String niveauQuiz) {
        QuizQuestion question = new QuizQuestion();
        question.setQuizJournalier(quiz);
        question.setProcedure(procedure);
        question.setTypeQuestion("CENTRE");
        // Points selon le niveau: FACILE=10, MOYEN=15, DIFFICILE=20
        question.setPoints("FACILE".equals(niveauQuiz) ? 10 : "MOYEN".equals(niveauQuiz) ? 15 : 20);
        question.setNiveau(niveauQuiz);

        String titreFr = procedure.getTitre();
        String titreEn = procedure.getTitreEn() != null ? procedure.getTitreEn() : titreFr;
        String centreNomFr = translationHelper.getNom(procedure.getCentre());
        String centreNomEn = procedure.getCentre().getNomEn() != null ? 
            procedure.getCentre().getNomEn() : centreNomFr;

        question.setQuestionFr("Dans quel centre peut-on faire " + titreFr + " ?");
        question.setQuestionEn("In which center can you do " + titreEn + "?");
        question.setReponseCorrecte(centreNomFr);

        question = quizQuestionRepository.save(question);

        // Créer les réponses possibles
        creerReponsesCentre(question, centreNomFr, centreNomEn);

        return question;
    }

    private QuizQuestion creerQuestionEtape(QuizJournalier quiz, Procedure procedure, String niveauQuiz) {
        QuizQuestion question = new QuizQuestion();
        question.setQuizJournalier(quiz);
        question.setProcedure(procedure);
        question.setTypeQuestion("ETAPE");
        // Points selon le niveau: MOYEN=15, DIFFICILE=25
        question.setPoints("MOYEN".equals(niveauQuiz) ? 15 : 25);
        question.setNiveau(niveauQuiz);

        String titreFr = procedure.getTitre();
        String titreEn = procedure.getTitreEn() != null ? procedure.getTitreEn() : titreFr;

        // Prendre la première étape
        Etape premiereEtape = procedure.getEtapes().stream()
                .min(Comparator.comparing(Etape::getNiveau))
                .orElseThrow(() -> new RuntimeException("Aucune étape trouvée"));

        String etapeDescFr = premiereEtape.getDescription();
        String etapeDescEn = premiereEtape.getDescriptionEn() != null ? 
            premiereEtape.getDescriptionEn() : etapeDescFr;

        question.setQuestionFr("Quelle est la première étape pour " + titreFr + " ?");
        question.setQuestionEn("What is the first step for " + titreEn + "?");
        question.setReponseCorrecte(etapeDescFr);

        question = quizQuestionRepository.save(question);

        // Créer les réponses possibles
        creerReponsesEtape(question, etapeDescFr, etapeDescEn, procedure);

        return question;
    }

    private QuizQuestion creerQuestionGenerique(QuizJournalier quiz, Procedure procedure, String niveauQuiz) {
        QuizQuestion question = new QuizQuestion();
        question.setQuizJournalier(quiz);
        question.setProcedure(procedure);
        question.setTypeQuestion("GENERIQUE");
        // Points selon le niveau: FACILE=10, MOYEN=15, DIFFICILE=20
        question.setPoints("FACILE".equals(niveauQuiz) ? 10 : "MOYEN".equals(niveauQuiz) ? 15 : 20);
        question.setNiveau(niveauQuiz);

        String titreFr = procedure.getTitre();
        String titreEn = procedure.getTitreEn() != null ? procedure.getTitreEn() : titreFr;

        question.setQuestionFr("À quelle catégorie appartient " + titreFr + " ?");
        question.setQuestionEn("Which category does " + titreEn + " belong to?");
        question.setReponseCorrecte(procedure.getCategorie().getTitre());

        question = quizQuestionRepository.save(question);

        // Créer les réponses possibles
        creerReponsesGenerique(question, procedure);

        return question;
    }

    // Méthodes pour créer les réponses possibles
    private void creerReponsesDelai(QuizQuestion question, String delaiCorrect, String delaiCorrectEn) {
        List<QuizReponse> reponses = new ArrayList<>();

        // Réponse correcte
        QuizReponse correcte = new QuizReponse();
        correcte.setQuestion(question);
        correcte.setReponseFr(delaiCorrect);
        correcte.setReponseEn(delaiCorrectEn);
        correcte.setEstCorrecte(true);
        correcte.setOrdre(1);
        reponses.add(correcte);

        // Réponses incorrectes
        String[] faussesReponses = {"3 jours", "15 jours", "30 jours", "60 jours"};
        String[] faussesReponsesEn = {"3 days", "15 days", "30 days", "60 days"};

        for (int i = 0; i < 3 && i < faussesReponses.length; i++) {
            QuizReponse fausse = new QuizReponse();
            fausse.setQuestion(question);
            fausse.setReponseFr(faussesReponses[i]);
            fausse.setReponseEn(faussesReponsesEn[i]);
            fausse.setEstCorrecte(false);
            fausse.setOrdre(i + 2);
            reponses.add(fausse);
        }

        quizReponseRepository.saveAll(reponses);
    }

    private void creerReponsesCout(QuizQuestion question, Integer prixCorrect) {
        List<QuizReponse> reponses = new ArrayList<>();

        // Réponse correcte
        QuizReponse correcte = new QuizReponse();
        correcte.setQuestion(question);
        correcte.setReponseFr(prixCorrect + " FCFA");
        correcte.setReponseEn(prixCorrect + " FCFA");
        correcte.setEstCorrecte(true);
        correcte.setOrdre(1);
        reponses.add(correcte);

        // Réponses incorrectes (variations autour du prix)
        int[] variations = {prixCorrect - 5000, prixCorrect + 5000, prixCorrect * 2, prixCorrect / 2};
        for (int i = 0; i < 3 && i < variations.length; i++) {
            if (variations[i] > 0) {
                QuizReponse fausse = new QuizReponse();
                fausse.setQuestion(question);
                fausse.setReponseFr(variations[i] + " FCFA");
                fausse.setReponseEn(variations[i] + " FCFA");
                fausse.setEstCorrecte(false);
                fausse.setOrdre(i + 2);
                reponses.add(fausse);
            }
        }

        quizReponseRepository.saveAll(reponses);
    }

    private void creerReponsesDocument(QuizQuestion question, String docCorrect, String docCorrectEn, Procedure procedure) {
        List<QuizReponse> reponses = new ArrayList<>();

        // Réponse correcte
        QuizReponse correcte = new QuizReponse();
        correcte.setQuestion(question);
        correcte.setReponseFr(docCorrect);
        correcte.setReponseEn(docCorrectEn);
        correcte.setEstCorrecte(true);
        correcte.setOrdre(1);
        reponses.add(correcte);

        // Réponses incorrectes (autres documents d'autres procédures)
        List<Procedure> autresProcedures = procedureRepository.findAll();
        int count = 0;
        for (Procedure p : autresProcedures) {
            if (!p.getId().equals(procedure.getId()) && 
                p.getDocumentsRequis() != null && 
                !p.getDocumentsRequis().isEmpty() && 
                count < 3) {
                
                DocumentRequis doc = p.getDocumentsRequis().iterator().next();
                QuizReponse fausse = new QuizReponse();
                fausse.setQuestion(question);
                fausse.setReponseFr(doc.getNom());
                fausse.setReponseEn(doc.getDescriptionEn() != null ? doc.getDescriptionEn() : doc.getNom());
                fausse.setEstCorrecte(false);
                fausse.setOrdre(count + 2);
                reponses.add(fausse);
                count++;
            }
        }

        quizReponseRepository.saveAll(reponses);
    }

    private void creerReponsesCentre(QuizQuestion question, String centreCorrect, String centreCorrectEn) {
        List<QuizReponse> reponses = new ArrayList<>();

        // Réponse correcte
        QuizReponse correcte = new QuizReponse();
        correcte.setQuestion(question);
        correcte.setReponseFr(centreCorrect);
        correcte.setReponseEn(centreCorrectEn);
        correcte.setEstCorrecte(true);
        correcte.setOrdre(1);
        reponses.add(correcte);

        // Réponses incorrectes génériques
        String[] faussesReponses = {"Centre administratif", "Mairie", "Préfecture"};
        String[] faussesReponsesEn = {"Administrative center", "Town hall", "Prefecture"};

        for (int i = 0; i < 3 && i < faussesReponses.length; i++) {
            QuizReponse fausse = new QuizReponse();
            fausse.setQuestion(question);
            fausse.setReponseFr(faussesReponses[i]);
            fausse.setReponseEn(faussesReponsesEn[i]);
            fausse.setEstCorrecte(false);
            fausse.setOrdre(i + 2);
            reponses.add(fausse);
        }

        quizReponseRepository.saveAll(reponses);
    }

    private void creerReponsesEtape(QuizQuestion question, String etapeCorrecte, String etapeCorrecteEn, Procedure procedure) {
        List<QuizReponse> reponses = new ArrayList<>();

        // Réponse correcte
        QuizReponse correcte = new QuizReponse();
        correcte.setQuestion(question);
        correcte.setReponseFr(etapeCorrecte);
        correcte.setReponseEn(etapeCorrecteEn);
        correcte.setEstCorrecte(true);
        correcte.setOrdre(1);
        reponses.add(correcte);

        // Réponses incorrectes (autres étapes de la même procédure)
        int count = 0;
        for (Etape etape : procedure.getEtapes()) {
            if (!etape.getDescription().equals(etapeCorrecte) && count < 3) {
                QuizReponse fausse = new QuizReponse();
                fausse.setQuestion(question);
                fausse.setReponseFr(etape.getDescription());
                fausse.setReponseEn(etape.getDescriptionEn() != null ? etape.getDescriptionEn() : etape.getDescription());
                fausse.setEstCorrecte(false);
                fausse.setOrdre(count + 2);
                reponses.add(fausse);
                count++;
            }
        }

        quizReponseRepository.saveAll(reponses);
    }

    private void creerReponsesGenerique(QuizQuestion question, Procedure procedure) {
        List<QuizReponse> reponses = new ArrayList<>();

        // Réponse correcte
        String categorieCorrecte = procedure.getCategorie().getTitre();
        String categorieCorrecteEn = procedure.getCategorie().getTitreEn() != null ? 
            procedure.getCategorie().getTitreEn() : categorieCorrecte;

        QuizReponse correcte = new QuizReponse();
        correcte.setQuestion(question);
        correcte.setReponseFr(categorieCorrecte);
        correcte.setReponseEn(categorieCorrecteEn);
        correcte.setEstCorrecte(true);
        correcte.setOrdre(1);
        reponses.add(correcte);

        // Réponses incorrectes (autres catégories)
        // Pour simplifier, on utilise des catégories génériques
        String[] faussesReponses = {"Justice", "Éducation", "Santé", "Transport"};
        String[] faussesReponsesEn = {"Justice", "Education", "Health", "Transport"};

        for (int i = 0; i < 3 && i < faussesReponses.length; i++) {
            if (!faussesReponses[i].equals(categorieCorrecte)) {
                QuizReponse fausse = new QuizReponse();
                fausse.setQuestion(question);
                fausse.setReponseFr(faussesReponses[i]);
                fausse.setReponseEn(faussesReponsesEn[i]);
                fausse.setEstCorrecte(false);
                fausse.setOrdre(reponses.size() + 1);
                reponses.add(fausse);
            }
        }

        quizReponseRepository.saveAll(reponses);
    }

    /**
     * Crée une question sur les lois/articles (niveau DIFFICILE)
     */
    private QuizQuestion creerQuestionLoi(QuizJournalier quiz, Procedure procedure) {
        QuizQuestion question = new QuizQuestion();
        question.setQuizJournalier(quiz);
        question.setProcedure(procedure);
        question.setTypeQuestion("LOI");
        question.setPoints(25);
        question.setNiveau("DIFFICILE");

        String titreFr = procedure.getTitre();
        String titreEn = procedure.getTitreEn() != null ? procedure.getTitreEn() : titreFr;

        // Prendre le premier article de loi
        LoiArticle premierLoiArticle = procedure.getLoisArticles().iterator().next();
        String loiDescFr = premierLoiArticle.getDescription();
        String loiDescEn = premierLoiArticle.getDescriptionEn() != null ? 
            premierLoiArticle.getDescriptionEn() : loiDescFr;

        question.setQuestionFr("Quel article de loi régit " + titreFr + " ?");
        question.setQuestionEn("Which law article governs " + titreEn + "?");
        question.setReponseCorrecte(loiDescFr);

        question = quizQuestionRepository.save(question);

        // Créer les réponses possibles
        creerReponsesLoi(question, loiDescFr, loiDescEn, procedure);

        return question;
    }

    /**
     * Crée une question complexe combinant plusieurs éléments (niveau DIFFICILE)
     */
    private QuizQuestion creerQuestionComplexe(QuizJournalier quiz, Procedure procedure) {
        QuizQuestion question = new QuizQuestion();
        question.setQuizJournalier(quiz);
        question.setProcedure(procedure);
        question.setTypeQuestion("COMPLEXE");
        question.setPoints(30);
        question.setNiveau("DIFFICILE");

        String titreFr = procedure.getTitre();
        String titreEn = procedure.getTitreEn() != null ? procedure.getTitreEn() : titreFr;

        // Question combinant délai et coût
        String delaiFr = procedure.getDelai() != null ? procedure.getDelai() : "Non spécifié";
        Integer prix = procedure.getCout() != null && procedure.getCout().getPrix() != null ? 
            procedure.getCout().getPrix() : 0;
        String reponseCorrecte = "Délai: " + delaiFr + ", Coût: " + prix + " FCFA";

        question.setQuestionFr("Quel est le délai ET le coût pour " + titreFr + " ?");
        question.setQuestionEn("What is the deadline AND cost for " + titreEn + "?");
        question.setReponseCorrecte(reponseCorrecte);

        question = quizQuestionRepository.save(question);

        // Créer les réponses possibles
        creerReponsesComplexe(question, delaiFr, prix, procedure);

        return question;
    }

    /**
     * Crée une question sur les détails spécifiques (niveau DIFFICILE)
     */
    private QuizQuestion creerQuestionDetail(QuizJournalier quiz, Procedure procedure) {
        QuizQuestion question = new QuizQuestion();
        question.setQuizJournalier(quiz);
        question.setProcedure(procedure);
        question.setTypeQuestion("DETAIL");
        question.setPoints(25);
        question.setNiveau("DIFFICILE");

        String titreFr = procedure.getTitre();
        String titreEn = procedure.getTitreEn() != null ? procedure.getTitreEn() : titreFr;

        // Question sur le nombre de documents requis
        int nbDocuments = procedure.getDocumentsRequis() != null ? procedure.getDocumentsRequis().size() : 0;
        String reponseCorrecte = nbDocuments + " document(s) requis";

        question.setQuestionFr("Combien de documents sont requis pour " + titreFr + " ?");
        question.setQuestionEn("How many documents are required for " + titreEn + "?");
        question.setReponseCorrecte(reponseCorrecte);

        question = quizQuestionRepository.save(question);

        // Créer les réponses possibles
        creerReponsesDetail(question, nbDocuments);

        return question;
    }

    private void creerReponsesLoi(QuizQuestion question, String loiCorrecte, String loiCorrecteEn, Procedure procedure) {
        List<QuizReponse> reponses = new ArrayList<>();

        // Réponse correcte
        QuizReponse correcte = new QuizReponse();
        correcte.setQuestion(question);
        correcte.setReponseFr(loiCorrecte);
        correcte.setReponseEn(loiCorrecteEn);
        correcte.setEstCorrecte(true);
        correcte.setOrdre(1);
        reponses.add(correcte);

        // Réponses incorrectes (autres lois d'autres procédures)
        List<Procedure> autresProcedures = procedureRepository.findAll();
        int count = 0;
        for (Procedure p : autresProcedures) {
            if (!p.getId().equals(procedure.getId()) && 
                p.getLoisArticles() != null && 
                !p.getLoisArticles().isEmpty() && 
                count < 3) {
                
                LoiArticle loiArticle = p.getLoisArticles().iterator().next();
                QuizReponse fausse = new QuizReponse();
                fausse.setQuestion(question);
                fausse.setReponseFr(loiArticle.getDescription());
                fausse.setReponseEn(loiArticle.getDescriptionEn() != null ? 
                    loiArticle.getDescriptionEn() : loiArticle.getDescription());
                fausse.setEstCorrecte(false);
                fausse.setOrdre(count + 2);
                reponses.add(fausse);
                count++;
            }
        }

        quizReponseRepository.saveAll(reponses);
    }

    private void creerReponsesComplexe(QuizQuestion question, String delaiCorrect, Integer prixCorrect, Procedure procedure) {
        List<QuizReponse> reponses = new ArrayList<>();

        // Réponse correcte
        QuizReponse correcte = new QuizReponse();
        correcte.setQuestion(question);
        correcte.setReponseFr("Délai: " + delaiCorrect + ", Coût: " + prixCorrect + " FCFA");
        correcte.setReponseEn("Deadline: " + delaiCorrect + ", Cost: " + prixCorrect + " FCFA");
        correcte.setEstCorrecte(true);
        correcte.setOrdre(1);
        reponses.add(correcte);

        // Réponses incorrectes (variations)
        String[] variationsDelai = {"3 jours", "15 jours", "30 jours"};
        int[] variationsPrix = {prixCorrect - 5000, prixCorrect + 5000, prixCorrect * 2};
        
        for (int i = 0; i < 3 && i < variationsDelai.length; i++) {
            int prixVar = variationsPrix[i] > 0 ? variationsPrix[i] : prixCorrect;
            QuizReponse fausse = new QuizReponse();
            fausse.setQuestion(question);
            fausse.setReponseFr("Délai: " + variationsDelai[i] + ", Coût: " + prixVar + " FCFA");
            fausse.setReponseEn("Deadline: " + variationsDelai[i] + ", Cost: " + prixVar + " FCFA");
            fausse.setEstCorrecte(false);
            fausse.setOrdre(i + 2);
            reponses.add(fausse);
        }

        quizReponseRepository.saveAll(reponses);
    }

    private void creerReponsesDetail(QuizQuestion question, int nbDocumentsCorrect) {
        List<QuizReponse> reponses = new ArrayList<>();

        // Réponse correcte
        QuizReponse correcte = new QuizReponse();
        correcte.setQuestion(question);
        correcte.setReponseFr(nbDocumentsCorrect + " document(s) requis");
        correcte.setReponseEn(nbDocumentsCorrect + " document(s) required");
        correcte.setEstCorrecte(true);
        correcte.setOrdre(1);
        reponses.add(correcte);

        // Réponses incorrectes
        int[] variations = {nbDocumentsCorrect - 1, nbDocumentsCorrect + 1, nbDocumentsCorrect + 2};
        for (int i = 0; i < 3 && i < variations.length; i++) {
            if (variations[i] >= 0) {
                QuizReponse fausse = new QuizReponse();
                fausse.setQuestion(question);
                fausse.setReponseFr(variations[i] + " document(s) requis");
                fausse.setReponseEn(variations[i] + " document(s) required");
                fausse.setEstCorrecte(false);
                fausse.setOrdre(i + 2);
                reponses.add(fausse);
            }
        }

        quizReponseRepository.saveAll(reponses);
    }
}

