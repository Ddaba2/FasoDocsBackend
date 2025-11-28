package ml.fasodocs.backend.service;

import ml.fasodocs.backend.dto.request.QuizParticipationRequest;
import ml.fasodocs.backend.dto.response.*;
import ml.fasodocs.backend.entity.*;
import ml.fasodocs.backend.repository.*;
import ml.fasodocs.backend.security.UserDetailsImpl;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.*;
import java.util.Comparator;
import java.util.stream.Collectors;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;

/**
 * Service pour la gestion des quiz
 */
@Service
@Transactional
public class QuizService {

    private static final Logger logger = LoggerFactory.getLogger(QuizService.class);

    @Autowired
    private QuizJournalierRepository quizJournalierRepository;

    @Autowired
    private QuizQuestionRepository quizQuestionRepository;

    @Autowired
    private QuizReponseRepository quizReponseRepository;

    @Autowired
    private QuizParticipationRepository quizParticipationRepository;

    @Autowired
    private QuizReponseUtilisateurRepository quizReponseUtilisateurRepository;

    @Autowired
    private QuizStatistiqueRepository quizStatistiqueRepository;

    @Autowired
    private CitoyenRepository citoyenRepository;

    @Autowired
    private QuizNotificationService quizNotificationService;

    @Autowired
    private QuizProgressionRepository quizProgressionRepository;

    @Autowired
    private QuizQuestionDebloqueeRepository quizQuestionDebloqueeRepository;

    @org.springframework.beans.factory.annotation.Value("${quiz.requis-pour-debloquer.moyen:25}")
    private int quizRequisPourMoyen;

    @org.springframework.beans.factory.annotation.Value("${quiz.requis-pour-debloquer.difficile:25}")
    private int quizRequisPourDifficile;

    @org.springframework.beans.factory.annotation.Value("${quiz.pourcentage-deblocage-question:0.5}")
    private double pourcentageDeblocageQuestion;


    /**
     * Récupère TOUS les quiz disponibles pour un niveau donné (pas seulement ceux d'aujourd'hui)
     */
    public List<QuizJournalierResponse> obtenirQuizAujourdhui(String langue, String niveau) {
        // Si aucun niveau n'est spécifié, utiliser FACILE par défaut
        final String niveauFinal = (niveau == null || niveau.isEmpty()) ? "FACILE" : niveau;
        
        Citoyen citoyen = getCitoyenConnecte();
        
        // Pour FACILE, s'assurer que la progression existe (créer si nécessaire)
        if ("FACILE".equals(niveauFinal)) {
            if (!quizProgressionRepository.existsByCitoyenIdAndNiveau(citoyen.getId(), "FACILE")) {
                // Créer la progression FACILE si elle n'existe pas
                QuizProgression progressionFacile = new QuizProgression();
                progressionFacile.setCitoyen(citoyen);
                progressionFacile.setNiveau("FACILE");
                progressionFacile.setQuizCompletes(0);
                progressionFacile.setMeilleurScore(0);
                quizProgressionRepository.save(progressionFacile);
                logger.info("✅ Progression FACILE créée automatiquement pour l'utilisateur {}", citoyen.getId());
            }
        }
        
        // Vérifier si le niveau est débloqué
        if (!estNiveauDebloque(citoyen.getId(), niveauFinal)) {
            throw new RuntimeException("Le niveau " + niveauFinal + " n'est pas encore débloqué. Complétez d'abord le niveau précédent.");
        }
        
        // OPTIMISATION : Vérifier et débloquer les ordres globalement une seule fois
        verifierEtDebloquerOrdreGlobal(citoyen.getId(), niveauFinal);
        
        // OPTIMISATION : Charger tous les quiz d'un niveau avec toutes leurs relations en une seule requête
        List<QuizJournalier> tousLesQuiz = quizJournalierRepository.findByNiveauWithQuestions(niveauFinal);
        
        if (tousLesQuiz.isEmpty()) {
            throw new RuntimeException("Aucun quiz " + niveauFinal + " disponible. Les quiz seront générés au démarrage de l'application.");
        }
        
        // OPTIMISATION : Charger toutes les questions débloquées en batch pour tous les quiz
        List<Long> quizIds = tousLesQuiz.stream()
                .map(QuizJournalier::getId)
                .collect(Collectors.toList());
        
        List<Object[]> questionsDebloqueesBatch = quizQuestionDebloqueeRepository
                .findQuestionIdsDebloqueesByQuizIds(citoyen.getId(), quizIds);
        
        // Créer un Map pour accès rapide : quizId -> Set<questionId>
        Map<Long, Set<Long>> questionsDebloqueesParQuiz = new HashMap<>();
        for (Object[] row : questionsDebloqueesBatch) {
            Long quizId = (Long) row[0];
            Long questionId = (Long) row[1];
            questionsDebloqueesParQuiz.computeIfAbsent(quizId, k -> new HashSet<>()).add(questionId);
        }
        
        // Convertir tous les quiz en responses (sans requêtes supplémentaires)
        List<QuizJournalierResponse> responses = new ArrayList<>();
        for (QuizJournalier quiz : tousLesQuiz) {
            Set<Long> questionsDebloquees = questionsDebloqueesParQuiz.getOrDefault(quiz.getId(), new HashSet<>());
            responses.add(convertirQuizEnResponseOptimise(quiz, langue, citoyen.getId(), questionsDebloquees));
        }
        
        logger.info("Récupération optimisée de {} quiz {} pour l'utilisateur {}", responses.size(), niveauFinal, citoyen.getId());
        
        return responses;
    }

    /**
     * Récupère TOUS les quiz disponibles avec leurs niveaux de déblocage
     */
    public Map<String, Object> obtenirTousQuizAujourdhui(String langue) {
        Citoyen citoyen = getCitoyenConnecte();
        
        List<String> niveauxDebloques = obtenirNiveauxDebloques(citoyen.getId());
        Map<String, Object> result = new HashMap<>();
        Map<String, List<QuizJournalierResponse>> quizParNiveau = new HashMap<>();
        
        String[] tousNiveaux = {"FACILE", "MOYEN", "DIFFICILE"};
        for (String niveau : tousNiveaux) {
            boolean estDebloque = niveauxDebloques.contains(niveau);
            result.put(niveau.toLowerCase() + "_debloque", estDebloque);
            
            if (estDebloque) {
                try {
                    // OPTIMISATION : Vérifier et débloquer les ordres globalement une seule fois
                    verifierEtDebloquerOrdreGlobal(citoyen.getId(), niveau);
                    
                    // OPTIMISATION : Charger tous les quiz d'un niveau avec toutes leurs relations en une seule requête
                    List<QuizJournalier> tousLesQuiz = quizJournalierRepository.findByNiveauWithQuestions(niveau);
                    
                    // OPTIMISATION : Charger toutes les questions débloquées en batch
                    List<Long> quizIds = tousLesQuiz.stream()
                            .map(QuizJournalier::getId)
                            .collect(Collectors.toList());
                    
                    List<Object[]> questionsDebloqueesBatch = quizQuestionDebloqueeRepository
                            .findQuestionIdsDebloqueesByQuizIds(citoyen.getId(), quizIds);
                    
                    // Créer un Map pour accès rapide
                    Map<Long, Set<Long>> questionsDebloqueesParQuiz = new HashMap<>();
                    for (Object[] row : questionsDebloqueesBatch) {
                        Long quizId = (Long) row[0];
                        Long questionId = (Long) row[1];
                        questionsDebloqueesParQuiz.computeIfAbsent(quizId, k -> new HashSet<>()).add(questionId);
                    }
                    
                    // Convertir tous les quiz en responses (sans requêtes supplémentaires)
                    List<QuizJournalierResponse> quizResponses = new ArrayList<>();
                    for (QuizJournalier quiz : tousLesQuiz) {
                        Set<Long> questionsDebloquees = questionsDebloqueesParQuiz.getOrDefault(quiz.getId(), new HashSet<>());
                        quizResponses.add(convertirQuizEnResponseOptimise(quiz, langue, citoyen.getId(), questionsDebloquees));
                    }
                    
                    quizParNiveau.put(niveau.toLowerCase(), quizResponses);
                    logger.info("Récupération optimisée de {} quiz {} pour l'utilisateur {}", quizResponses.size(), niveau, citoyen.getId());
                } catch (Exception e) {
                    logger.warn("Erreur lors de la récupération des quiz {}: {}", niveau, e.getMessage());
                    quizParNiveau.put(niveau.toLowerCase(), new ArrayList<>());
                }
            } else {
                quizParNiveau.put(niveau.toLowerCase(), new ArrayList<>());
            }
        }
        
        result.put("quiz", quizParNiveau);
        result.put("niveaux_debloques", niveauxDebloques);
        
        return result;
    }

    /**
     * Soumet les réponses d'un utilisateur à un quiz
     * Permet de refaire un quiz même s'il est déjà complété (remplace l'ancienne participation)
     */
    public QuizParticipationResponse participerAuQuiz(QuizParticipationRequest request) {
        Citoyen citoyen = getCitoyenConnecte();
        
        QuizJournalier quiz = quizJournalierRepository.findById(request.getQuizJournalierId())
                .orElseThrow(() -> new RuntimeException("Quiz non trouvé"));

        // Vérifier si l'utilisateur a déjà participé
        Optional<QuizParticipation> participationExistante = 
                quizParticipationRepository.findByCitoyenIdAndQuizJournalierId(
                        citoyen.getId(), 
                        request.getQuizJournalierId()
                );

        QuizParticipation participation;
        int ancienScore = 0;
        boolean estNouvelleParticipation = false;

        if (participationExistante.isPresent()) {
            participation = participationExistante.get();
            // Si la participation est complète, on va la mettre à jour
            // Sauvegarder l'ancien score pour ajuster les statistiques
            ancienScore = participation.getScore() != null ? participation.getScore() : 0;
            
            // Supprimer les anciennes réponses si elles existent
            List<QuizReponseUtilisateur> anciennesReponses = 
                    quizReponseUtilisateurRepository.findByParticipationId(participation.getId());
            if (!anciennesReponses.isEmpty()) {
                quizReponseUtilisateurRepository.deleteAll(anciennesReponses);
                logger.info("Anciennes réponses supprimées pour la participation {}", participation.getId());
            }
        } else {
            participation = new QuizParticipation();
            participation.setCitoyen(citoyen);
            participation.setQuizJournalier(quiz);
            estNouvelleParticipation = true;
        }

        participation.setNombreQuestions(request.getReponses().size());
        participation.setTempsSecondes(request.getTempsSecondes());

        int score = 0;
        int bonnesReponses = 0;
        List<QuizReponseUtilisateur> reponsesUtilisateur = new ArrayList<>();

        // Traiter chaque réponse
        for (QuizParticipationRequest.ReponseQuestion reponseReq : request.getReponses()) {
            QuizQuestion question = quizQuestionRepository.findById(reponseReq.getQuestionId())
                    .orElseThrow(() -> new RuntimeException("Question non trouvée"));

            QuizReponse reponseChoisie = quizReponseRepository.findById(reponseReq.getReponseChoisieId())
                    .orElseThrow(() -> new RuntimeException("Réponse non trouvée"));

            boolean estCorrecte = reponseChoisie.getEstCorrecte();
            int pointsObtenus = estCorrecte ? question.getPoints() : 0;

            if (estCorrecte) {
                bonnesReponses++;
                score += pointsObtenus;
            }

            QuizReponseUtilisateur reponseUtilisateur = new QuizReponseUtilisateur();
            reponseUtilisateur.setParticipation(participation);
            reponseUtilisateur.setQuestion(question);
            reponseUtilisateur.setReponseChoisie(reponseChoisie);
            reponseUtilisateur.setEstCorrecte(estCorrecte);
            reponseUtilisateur.setPointsObtenus(pointsObtenus);
            reponsesUtilisateur.add(reponseUtilisateur);
        }

        participation.setScore(score);
        participation.setNombreBonnesReponses(bonnesReponses);
        participation.setEstComplete(true);

        participation = quizParticipationRepository.save(participation);
        quizReponseUtilisateurRepository.saveAll(reponsesUtilisateur);

        // Débloquer les questions suivantes globalement par ordre (après avoir soumis les réponses)
        debloquerQuestionsSuivantes(citoyen.getId(), quiz.getNiveau());

        // Mettre à jour la progression du niveau (seulement si c'est une nouvelle participation)
        QuizProgression progression = mettreAJourProgressionNiveau(citoyen, quiz.getNiveau(), score, estNouvelleParticipation);

        // Débloquer le niveau suivant si le nombre requis de quiz est atteint (25 au lieu de 30)
        String niveauSuivant = obtenirNiveauSuivant(quiz.getNiveau());
        if (niveauSuivant != null) {
            verifierEtDebloquerNiveau(citoyen, quiz.getNiveau(), progression);
        }

        // Mettre à jour les statistiques
        // Si c'est une nouvelle participation, ajouter normalement
        // Si c'est une mise à jour, ajuster en soustrayant l'ancien score et ajoutant le nouveau
        if (estNouvelleParticipation) {
            mettreAJourStatistiques(citoyen, score, bonnesReponses);
        } else {
            // Ajuster les statistiques : soustraire l'ancien score, ajouter le nouveau
            mettreAJourStatistiquesAvecAjustement(citoyen, ancienScore, score, bonnesReponses);
        }

        logger.info("Participation au quiz {} {} pour l'utilisateur {} - Score: {}/{}", 
                quiz.getNiveau(),
                estNouvelleParticipation ? "enregistrée" : "mise à jour",
                citoyen.getId(), score, participation.getNombreQuestions() * 10);

        return convertirParticipationEnResponse(participation);
    }

    /**
     * Récupère les statistiques de l'utilisateur connecté
     */
    public QuizStatistiqueResponse obtenirStatistiques() {
        Citoyen citoyen = getCitoyenConnecte();
        
        QuizStatistique stats = quizStatistiqueRepository.findByCitoyenId(citoyen.getId())
                .orElseGet(() -> creerStatistiquesInitiales(citoyen));

        return convertirStatistiquesEnResponse(stats);
    }

    /**
     * Récupère le classement hebdomadaire
     */
    public ClassementResponse obtenirClassementHebdomadaire() {
        Pageable pageable = PageRequest.of(0, 50);
        List<QuizStatistique> classement = quizStatistiqueRepository.findTopByTotalPoints(pageable);
        
        Citoyen citoyen = getCitoyenConnecte();
        int position = trouverPositionUtilisateur(classement, citoyen.getId());

        ClassementResponse response = new ClassementResponse();
        response.setPeriode("HEBDOMADAIRE");
        response.setClassement(classement.stream()
                .map(this::convertirStatistiquesEnResponse)
                .collect(Collectors.toList()));
        response.setPositionUtilisateur(position);

        return response;
    }

    /**
     * Récupère le classement mensuel
     */
    public ClassementResponse obtenirClassementMensuel() {
        LocalDate debutMois = LocalDate.now().withDayOfMonth(1);
        Pageable pageable = PageRequest.of(0, 50);
        List<QuizStatistique> classement = quizStatistiqueRepository.findTopByTotalPointsSince(debutMois, pageable);
        
        Citoyen citoyen = getCitoyenConnecte();
        int position = trouverPositionUtilisateur(classement, citoyen.getId());

        ClassementResponse response = new ClassementResponse();
        response.setPeriode("MENSUEL");
        response.setClassement(classement.stream()
                .map(this::convertirStatistiquesEnResponse)
                .collect(Collectors.toList()));
        response.setPositionUtilisateur(position);

        return response;
    }

    // Méthodes privées

    private void mettreAJourStatistiques(Citoyen citoyen, int score, int bonnesReponses) {
        QuizStatistique stats = quizStatistiqueRepository.findByCitoyenId(citoyen.getId())
                .orElseGet(() -> creerStatistiquesInitiales(citoyen));

        stats.setTotalPoints(stats.getTotalPoints() + score);
        stats.setTotalQuizCompletes(stats.getTotalQuizCompletes() + 1);
        stats.setDerniereParticipation(LocalDate.now());

        // Mettre à jour le streak
        LocalDate hier = LocalDate.now().minusDays(1);
        if (stats.getDerniereParticipation() != null && 
            stats.getDerniereParticipation().equals(hier)) {
            // Streak continue
            stats.setStreakJours(stats.getStreakJours() + 1);
        } else if (stats.getDerniereParticipation() == null || 
                   !stats.getDerniereParticipation().equals(LocalDate.now())) {
            // Nouveau streak
            stats.setStreakJours(1);
        }

        if (stats.getStreakJours() > stats.getMeilleurStreak()) {
            stats.setMeilleurStreak(stats.getStreakJours());
        }

        // Badges - Vérifier et notifier les nouveaux badges débloqués
        boolean badgeExpertDebloque = false;
        boolean badgeStreakDebloque = false;

        if (stats.getTotalPoints() >= 1000 && !stats.getBadgeExpert()) {
            stats.setBadgeExpert(true);
            badgeExpertDebloque = true;
        }

        if (stats.getStreakJours() >= 30 && !stats.getBadgeStreakMaster()) {
            stats.setBadgeStreakMaster(true);
            badgeStreakDebloque = true;
        }

        quizStatistiqueRepository.save(stats);

        // Envoyer les notifications de badges débloqués
        if (badgeExpertDebloque) {
            try {
                quizNotificationService.envoyerNotificationBadge(citoyen, "Expert");
                logger.info("Badge Expert débloqué pour l'utilisateur {}", citoyen.getId());
            } catch (Exception e) {
                logger.error("Erreur lors de l'envoi de la notification de badge Expert: {}", e.getMessage());
            }
        }

        if (badgeStreakDebloque) {
            try {
                quizNotificationService.envoyerNotificationBadge(citoyen, "Streak Master");
                logger.info("Badge Streak Master débloqué pour l'utilisateur {}", citoyen.getId());
            } catch (Exception e) {
                logger.error("Erreur lors de l'envoi de la notification de badge Streak Master: {}", e.getMessage());
            }
        }
    }

    /**
     * Met à jour les statistiques en ajustant l'ancien score (pour les quiz refaits)
     * Ne compte pas comme un nouveau quiz complété, mais ajuste seulement les points
     */
    private void mettreAJourStatistiquesAvecAjustement(Citoyen citoyen, int ancienScore, int nouveauScore, int bonnesReponses) {
        QuizStatistique stats = quizStatistiqueRepository.findByCitoyenId(citoyen.getId())
                .orElseGet(() -> creerStatistiquesInitiales(citoyen));

        // Ajuster les points : soustraire l'ancien score et ajouter le nouveau
        int differenceScore = nouveauScore - ancienScore;
        stats.setTotalPoints(Math.max(0, stats.getTotalPoints() + differenceScore));
        
        // Ne pas incrémenter le nombre de quiz complétés car c'est une mise à jour
        // stats.setTotalQuizCompletes reste inchangé
        
        stats.setDerniereParticipation(LocalDate.now());

        // Le streak reste inchangé car c'est le même quiz (même jour)
        // Pas besoin de recalculer le streak pour une mise à jour

        // Badges - Vérifier et notifier les nouveaux badges débloqués
        boolean badgeExpertDebloque = false;
        boolean badgeStreakDebloque = false;

        if (stats.getTotalPoints() >= 1000 && !stats.getBadgeExpert()) {
            stats.setBadgeExpert(true);
            badgeExpertDebloque = true;
        }

        if (stats.getStreakJours() >= 30 && !stats.getBadgeStreakMaster()) {
            stats.setBadgeStreakMaster(true);
            badgeStreakDebloque = true;
        }

        quizStatistiqueRepository.save(stats);

        // Envoyer les notifications de badges débloqués
        if (badgeExpertDebloque) {
            try {
                quizNotificationService.envoyerNotificationBadge(citoyen, "Expert");
                logger.info("Badge Expert débloqué pour l'utilisateur {}", citoyen.getId());
            } catch (Exception e) {
                logger.error("Erreur lors de l'envoi de la notification de badge Expert: {}", e.getMessage());
            }
        }

        if (badgeStreakDebloque) {
            try {
                quizNotificationService.envoyerNotificationBadge(citoyen, "Streak Master");
                logger.info("Badge Streak Master débloqué pour l'utilisateur {}", citoyen.getId());
            } catch (Exception e) {
                logger.error("Erreur lors de l'envoi de la notification de badge Streak Master: {}", e.getMessage());
            }
        }
    }

    private QuizStatistique creerStatistiquesInitiales(Citoyen citoyen) {
        QuizStatistique stats = new QuizStatistique();
        stats.setCitoyen(citoyen);
        stats.setTotalPoints(0);
        stats.setTotalQuizCompletes(0);
        stats.setStreakJours(0);
        stats.setMeilleurStreak(0);
        stats.setBadgeExpert(false);
        stats.setBadgeStreakMaster(false);
        return quizStatistiqueRepository.save(stats);
    }

    private int trouverPositionUtilisateur(List<QuizStatistique> classement, Long citoyenId) {
        for (int i = 0; i < classement.size(); i++) {
            if (classement.get(i).getCitoyen().getId().equals(citoyenId)) {
                return i + 1;
            }
        }
        return -1; // Utilisateur pas dans le top
    }

    /**
     * Convertit un QuizJournalier en QuizJournalierResponse
     * Méthode publique pour permettre l'utilisation depuis les contrôleurs admin
     * Retourne seulement les questions débloquées pour l'utilisateur connecté
     */
    public QuizJournalierResponse convertirQuizEnResponse(QuizJournalier quiz, String langue) {
        Citoyen citoyen = getCitoyenConnecte();
        return convertirQuizEnResponse(quiz, langue, citoyen.getId());
    }

    /**
     * Convertit un QuizJournalier en QuizJournalierResponse avec l'ID utilisateur spécifié
     * Retourne seulement les questions débloquées pour cet utilisateur
     * VERSION OPTIMISÉE : Utilise un Set de questions débloquées pré-chargé
     */
    public QuizJournalierResponse convertirQuizEnResponse(QuizJournalier quiz, String langue, Long citoyenId) {
        // Charger les questions débloquées pour ce quiz
        List<Long> questionsDebloquees = quizQuestionDebloqueeRepository
                .findQuestionIdsDebloquees(citoyenId, quiz.getId());
        Set<Long> questionsDebloqueesSet = new HashSet<>(questionsDebloquees);
        
        return convertirQuizEnResponseOptimise(quiz, langue, citoyenId, questionsDebloqueesSet);
    }
    
    /**
     * Version optimisée de convertirQuizEnResponse qui utilise un Set pré-chargé
     */
    private QuizJournalierResponse convertirQuizEnResponseOptimise(QuizJournalier quiz, String langue, 
                                                                   Long citoyenId, Set<Long> questionsDebloquees) {
        QuizJournalierResponse response = new QuizJournalierResponse();
        response.setId(quiz.getId());
        response.setDateQuiz(quiz.getDateQuiz());
        response.setNiveau(quiz.getNiveau());
        
        if (quiz.getProcedure() != null) {
            response.setProcedureId(quiz.getProcedure().getId());
            response.setProcedureNom("en".equals(langue) ? 
                (quiz.getProcedure().getTitreEn() != null ? quiz.getProcedure().getTitreEn() : quiz.getProcedure().getTitre()) :
                quiz.getProcedure().getTitre());
        }
        
        if (quiz.getCategorie() != null) {
            response.setCategorieId(quiz.getCategorie().getId());
            response.setCategorieTitre("en".equals(langue) ?
                (quiz.getCategorie().getTitreEn() != null ? quiz.getCategorie().getTitreEn() : quiz.getCategorie().getTitre()) :
                quiz.getCategorie().getTitre());
        }

        response.setEstActif(quiz.getEstActif());

        // Convertir seulement les questions débloquées (Set pour accès O(1))
        if (quiz.getQuestions() != null && !quiz.getQuestions().isEmpty()) {
            List<QuizQuestionResponse> questionsResponse = quiz.getQuestions().stream()
                    .filter(q -> questionsDebloquees.contains(q.getId()))
                    .sorted(Comparator.comparing(q -> q.getOrdre() != null ? q.getOrdre() : 0))
                    .map(q -> convertirQuestionEnResponse(q, langue, true))
                    .collect(Collectors.toList());
            response.setQuestions(questionsResponse);
        } else {
            response.setQuestions(new ArrayList<>());
        }

        return response;
    }

    private QuizQuestionResponse convertirQuestionEnResponse(QuizQuestion question, String langue) {
        return convertirQuestionEnResponse(question, langue, true);
    }

    private QuizQuestionResponse convertirQuestionEnResponse(QuizQuestion question, String langue, boolean estDebloquee) {
        QuizQuestionResponse response = new QuizQuestionResponse();
        response.setId(question.getId());
        response.setQuestion("en".equals(langue) ? question.getQuestionEn() : question.getQuestionFr());
        response.setTypeQuestion(question.getTypeQuestion());
        response.setPoints(question.getPoints());
        response.setNiveau(question.getNiveau());
        response.setOrdre(question.getOrdre());
        response.setEstDebloquee(estDebloquee);

        // Convertir les réponses (sans révéler la bonne réponse)
        // Gérer le cas où reponses est null ou vide
        if (question.getReponses() != null && !question.getReponses().isEmpty()) {
            List<QuizReponseResponse> reponsesResponse = question.getReponses().stream()
                    .sorted(Comparator.comparing(QuizReponse::getOrdre))
                    .map(r -> convertirReponseEnResponse(r, langue))
                    .collect(Collectors.toList());
            response.setReponses(reponsesResponse);
        } else {
            response.setReponses(new ArrayList<>());
        }

        return response;
    }

    private QuizReponseResponse convertirReponseEnResponse(QuizReponse reponse, String langue) {
        QuizReponseResponse response = new QuizReponseResponse();
        response.setId(reponse.getId());
        response.setReponse("en".equals(langue) ? reponse.getReponseEn() : reponse.getReponseFr());
        response.setEstCorrecte(null); // Ne pas révéler la bonne réponse avant soumission
        response.setOrdre(reponse.getOrdre());
        return response;
    }

    private QuizParticipationResponse convertirParticipationEnResponse(QuizParticipation participation) {
        QuizParticipationResponse response = new QuizParticipationResponse();
        response.setId(participation.getId());
        response.setQuizJournalierId(participation.getQuizJournalier().getId());
        response.setDateQuiz(participation.getQuizJournalier().getDateQuiz());
        response.setScore(participation.getScore());
        response.setNombreBonnesReponses(participation.getNombreBonnesReponses());
        response.setNombreQuestions(participation.getNombreQuestions());
        response.setTempsSecondes(participation.getTempsSecondes());
        response.setEstComplete(participation.getEstComplete());
        response.setDateParticipation(participation.getDateParticipation());

        // Récupérer les réponses avec les bonnes/mauvaises réponses révélées
        List<QuizReponseUtilisateur> reponses = quizReponseUtilisateurRepository
                .findByParticipationId(participation.getId());
        
        List<QuizReponseUtilisateurResponse> reponsesResponse = reponses.stream()
                .map(r -> {
                    QuizReponseUtilisateurResponse resp = new QuizReponseUtilisateurResponse();
                    resp.setQuestionId(r.getQuestion().getId());
                    resp.setReponseChoisieId(r.getReponseChoisie() != null ? r.getReponseChoisie().getId() : null);
                    resp.setEstCorrecte(r.getEstCorrecte());
                    resp.setPointsObtenus(r.getPointsObtenus());
                    return resp;
                })
                .collect(Collectors.toList());
        
        response.setReponses(reponsesResponse);

        return response;
    }

    private QuizStatistiqueResponse convertirStatistiquesEnResponse(QuizStatistique stats) {
        QuizStatistiqueResponse response = new QuizStatistiqueResponse();
        response.setCitoyenId(stats.getCitoyen().getId());
        response.setCitoyenNom(stats.getCitoyen().getNom());
        response.setCitoyenPrenom(stats.getCitoyen().getPrenom());
        response.setTotalPoints(stats.getTotalPoints());
        response.setTotalQuizCompletes(stats.getTotalQuizCompletes());
        response.setStreakJours(stats.getStreakJours());
        response.setMeilleurStreak(stats.getMeilleurStreak());
        response.setDerniereParticipation(stats.getDerniereParticipation());
        response.setBadgeExpert(stats.getBadgeExpert());
        response.setBadgeStreakMaster(stats.getBadgeStreakMaster());
        return response;
    }

    private Citoyen getCitoyenConnecte() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        UserDetailsImpl userDetails = (UserDetailsImpl) authentication.getPrincipal();
        
        return citoyenRepository.findById(userDetails.getId())
                .orElseThrow(() -> new RuntimeException("Citoyen non trouvé"));
    }

    /**
     * Met à jour la progression d'un utilisateur pour un niveau donné
     * Retourne la progression mise à jour
     * @param estNouvelleParticipation Si true, incrémente le nombre de quiz complétés
     */
    private QuizProgression mettreAJourProgressionNiveau(Citoyen citoyen, String niveau, int score, boolean estNouvelleParticipation) {
        QuizProgression progression = quizProgressionRepository
                .findByCitoyenIdAndNiveau(citoyen.getId(), niveau)
                .orElseGet(() -> {
                    QuizProgression newProgression = new QuizProgression();
                    newProgression.setCitoyen(citoyen);
                    newProgression.setNiveau(niveau);
                    newProgression.setQuizCompletes(0);
                    newProgression.setMeilleurScore(0);
                    return newProgression;
                });

        // Incrémenter seulement si c'est une nouvelle participation
        if (estNouvelleParticipation) {
            progression.setQuizCompletes(progression.getQuizCompletes() + 1);
        }
        
        // Toujours mettre à jour le meilleur score si c'est meilleur
        if (score > progression.getMeilleurScore()) {
            progression.setMeilleurScore(score);
        }

        quizProgressionRepository.save(progression);
        logger.info("Progression mise à jour pour l'utilisateur {} - Niveau: {}, Quiz complétés: {}, Meilleur score: {}", 
                citoyen.getId(), niveau, progression.getQuizCompletes(), progression.getMeilleurScore());
        
        return progression;
    }

    /**
     * Débloque une question pour un utilisateur
     */
    private void debloquerQuestion(Long citoyenId, Long quizJournalierId, Long questionId) {
        if (!quizQuestionDebloqueeRepository.existsByCitoyenIdAndQuizJournalierIdAndQuestionId(
                citoyenId, quizJournalierId, questionId)) {
            Citoyen citoyen = citoyenRepository.findById(citoyenId)
                    .orElseThrow(() -> new RuntimeException("Citoyen non trouvé"));
            QuizJournalier quiz = quizJournalierRepository.findById(quizJournalierId)
                    .orElseThrow(() -> new RuntimeException("Quiz non trouvé"));
            QuizQuestion question = quizQuestionRepository.findById(questionId)
                    .orElseThrow(() -> new RuntimeException("Question non trouvée"));

            QuizQuestionDebloquee questionDebloquee = new QuizQuestionDebloquee();
            questionDebloquee.setCitoyen(citoyen);
            questionDebloquee.setQuizJournalier(quiz);
            questionDebloquee.setQuestion(question);
            quizQuestionDebloqueeRepository.save(questionDebloquee);
            logger.info("✅ Question {} débloquée pour l'utilisateur {} dans le quiz {}", 
                    questionId, citoyenId, quizJournalierId);
        }
    }

    /**
     * Débloque les questions suivantes globalement par ordre
     * Après avoir soumis des réponses, vérifie si toutes les questions d'un ordre sont complétées avec ≥50%
     * Si oui, débloque toutes les questions de l'ordre suivant pour tous les quiz du même niveau
     */
    private void debloquerQuestionsSuivantes(Long citoyenId, String niveau) {
        // Vérifier et débloquer les ordres suivants
        verifierEtDebloquerOrdreGlobal(citoyenId, niveau);
    }

    /**
     * Vérifie et débloque globalement les questions par ordre
     * Toutes les questions d'ordre 1 sont débloquées par défaut
     * Pour débloquer l'ordre N+1, l'utilisateur doit avoir répondu à TOUTES les questions d'ordre N avec ≥50% des points
     */
    private void verifierEtDebloquerOrdreGlobal(Long citoyenId, String niveau) {
        // Ordre 1 : toujours débloqué pour tous les quiz
        int ordreMax = 5; // Maximum 5 questions par quiz
        
        for (int ordre = 1; ordre <= ordreMax; ordre++) {
            // Récupérer toutes les questions de cet ordre pour ce niveau
            List<QuizQuestion> questionsOrdre = quizQuestionRepository.findByNiveauAndOrdre(niveau, ordre);
            
            if (questionsOrdre.isEmpty()) {
                continue; // Pas de questions pour cet ordre
            }
            
            // Pour l'ordre 1, débloquer toutes les questions
            if (ordre == 1) {
                for (QuizQuestion question : questionsOrdre) {
                    if (!quizQuestionDebloqueeRepository.existsByCitoyenIdAndQuizJournalierIdAndQuestionId(
                            citoyenId, question.getQuizJournalier().getId(), question.getId())) {
                        debloquerQuestion(citoyenId, question.getQuizJournalier().getId(), question.getId());
                    }
                }
                continue;
            }
            
            // Pour les ordres suivants, vérifier si toutes les questions de l'ordre précédent sont complétées avec ≥50%
            boolean toutesQuestionsOrdrePrecedentCompletes = true;
            
            // Récupérer toutes les questions de l'ordre précédent
            List<QuizQuestion> questionsOrdrePrecedent = quizQuestionRepository.findByNiveauAndOrdre(niveau, ordre - 1);
            
            for (QuizQuestion questionPrecedente : questionsOrdrePrecedent) {
                // Vérifier si l'utilisateur a répondu à cette question
                List<QuizReponseUtilisateur> reponses = quizReponseUtilisateurRepository
                        .findByCitoyenIdAndQuestionId(citoyenId, questionPrecedente.getId());
                
                if (reponses.isEmpty()) {
                    // Pas de réponse pour cette question
                    toutesQuestionsOrdrePrecedentCompletes = false;
                    break;
                }
                
                // Prendre la réponse la plus récente
                QuizReponseUtilisateur reponseRecente = reponses.get(0);
                int pointsObtenus = reponseRecente.getPointsObtenus() != null ? reponseRecente.getPointsObtenus() : 0;
                int pointsMax = questionPrecedente.getPoints() != null ? questionPrecedente.getPoints() : 10;
                
                // Vérifier si ≥50% des points sont obtenus
                double pourcentageObtenu = pointsMax > 0 ? (double) pointsObtenus / pointsMax : 0.0;
                
                if (pourcentageObtenu < pourcentageDeblocageQuestion) {
                    // Moins de 50% des points obtenus
                    toutesQuestionsOrdrePrecedentCompletes = false;
                    break;
                }
            }
            
            // Si toutes les questions de l'ordre précédent sont complétées avec ≥50%, débloquer toutes les questions de l'ordre actuel
            if (toutesQuestionsOrdrePrecedentCompletes) {
                for (QuizQuestion question : questionsOrdre) {
                    if (!quizQuestionDebloqueeRepository.existsByCitoyenIdAndQuizJournalierIdAndQuestionId(
                            citoyenId, question.getQuizJournalier().getId(), question.getId())) {
                        debloquerQuestion(citoyenId, question.getQuizJournalier().getId(), question.getId());
                        logger.info("🎉 Question d'ordre {} débloquée globalement pour l'utilisateur {} (toutes les questions d'ordre {} complétées avec ≥50%)", 
                                ordre, citoyenId, ordre - 1);
                    }
                }
            } else {
                // Si l'ordre précédent n'est pas complété, arrêter (pas besoin de vérifier les ordres suivants)
                break;
            }
        }
    }

    /**
     * Vérifie si le niveau suivant peut être débloqué et le débloque si les conditions sont remplies
     */
    private void verifierEtDebloquerNiveau(Citoyen citoyen, String niveauActuel, QuizProgression progressionActuelle) {
        String niveauSuivant = obtenirNiveauSuivant(niveauActuel);
        if (niveauSuivant == null) {
            return; // Pas de niveau suivant
        }

        // Vérifier si le niveau suivant est déjà débloqué
        if (quizProgressionRepository.existsByCitoyenIdAndNiveau(citoyen.getId(), niveauSuivant)) {
            return; // Déjà débloqué
        }

        // Déterminer le nombre de quiz requis pour débloquer le niveau suivant
        int quizRequis;
        if ("FACILE".equals(niveauActuel)) {
            quizRequis = quizRequisPourMoyen;
        } else if ("MOYEN".equals(niveauActuel)) {
            quizRequis = quizRequisPourDifficile;
        } else {
            return; // Pas de niveau suivant pour DIFFICILE
        }

        // Vérifier si le nombre de quiz complétés atteint le seuil requis
        if (progressionActuelle.getQuizCompletes() >= quizRequis) {
            // Débloquer le niveau suivant
            QuizProgression nouvelleProgression = new QuizProgression();
            nouvelleProgression.setCitoyen(citoyen);
            nouvelleProgression.setNiveau(niveauSuivant);
            nouvelleProgression.setQuizCompletes(0);
            nouvelleProgression.setMeilleurScore(0);

            quizProgressionRepository.save(nouvelleProgression);
            logger.info("🎉 Niveau {} débloqué pour l'utilisateur {} après avoir complété {} quiz {}", 
                    niveauSuivant, citoyen.getId(), progressionActuelle.getQuizCompletes(), niveauActuel);
            
            // Envoyer une notification de déblocage si possible
            try {
                quizNotificationService.envoyerNotificationDeblocageNiveau(citoyen, niveauSuivant);
            } catch (Exception e) {
                logger.warn("Impossible d'envoyer la notification de déblocage: {}", e.getMessage());
            }
        } else {
            int quizRestants = quizRequis - progressionActuelle.getQuizCompletes();
            logger.debug("Utilisateur {} a complété {}/{} quiz {} pour débloquer {}. Il reste {} quiz à compléter", 
                    citoyen.getId(), progressionActuelle.getQuizCompletes(), quizRequis, niveauActuel, 
                    niveauSuivant, quizRestants);
        }
    }

    /**
     * Retourne le niveau suivant
     */
    private String obtenirNiveauSuivant(String niveau) {
        switch (niveau) {
            case "FACILE":
                return "MOYEN";
            case "MOYEN":
                return "DIFFICILE";
            case "DIFFICILE":
                return null; // Pas de niveau suivant
            default:
                return null;
        }
    }

    /**
     * Retourne le niveau précédent
     */
    private String obtenirNiveauPrecedent(String niveau) {
        switch (niveau) {
            case "MOYEN":
                return "FACILE";
            case "DIFFICILE":
                return "MOYEN";
            case "FACILE":
                return null; // Pas de niveau précédent
            default:
                return null;
        }
    }

    /**
     * Vérifie si un utilisateur a débloqué un niveau
     */
    public boolean estNiveauDebloque(Long citoyenId, String niveau) {
        // FACILE est toujours débloqué
        if ("FACILE".equals(niveau)) {
            return true;
        }
        return quizProgressionRepository.existsByCitoyenIdAndNiveau(citoyenId, niveau);
    }

    /**
     * Diagnostic: Vérifie l'état de déblocage des niveaux pour l'utilisateur connecté
     */
    public Map<String, Object> diagnosticDeblocage() {
        Citoyen citoyen = getCitoyenConnecte();
        Map<String, Object> diagnostic = new HashMap<>();
        
        diagnostic.put("citoyenId", citoyen.getId());
        diagnostic.put("citoyenNom", citoyen.getNom());
        diagnostic.put("citoyenPrenom", citoyen.getPrenom());
        
        // Vérifier les progressions existantes
        List<QuizProgression> progressions = quizProgressionRepository
                .findByCitoyenIdOrderByDateDeblocageAsc(citoyen.getId());
        
        Map<String, Object> niveaux = new HashMap<>();
        String[] tousNiveaux = {"FACILE", "MOYEN", "DIFFICILE"};
        
        for (String niveau : tousNiveaux) {
            Map<String, Object> infoNiveau = new HashMap<>();
            Optional<QuizProgression> progressionOpt = progressions.stream()
                    .filter(p -> niveau.equals(p.getNiveau()))
                    .findFirst();
            
            if ("FACILE".equals(niveau)) {
                infoNiveau.put("estDebloque", true);
                infoNiveau.put("raison", "FACILE est toujours débloqué par défaut");
                if (progressionOpt.isPresent()) {
                    infoNiveau.put("progressionExiste", true);
                    infoNiveau.put("quizCompletes", progressionOpt.get().getQuizCompletes());
                } else {
                    infoNiveau.put("progressionExiste", false);
                    infoNiveau.put("action", "La progression FACILE sera créée automatiquement lors de la prochaine requête");
                }
            } else {
                boolean existe = progressionOpt.isPresent();
                infoNiveau.put("progressionExiste", existe);
                infoNiveau.put("estDebloque", existe);
                if (existe) {
                    infoNiveau.put("quizCompletes", progressionOpt.get().getQuizCompletes());
                    infoNiveau.put("dateDeblocage", progressionOpt.get().getDateDeblocage());
                } else {
                    infoNiveau.put("raison", "Niveau non débloqué - complétez le niveau précédent");
                }
            }
            
            niveaux.put(niveau, infoNiveau);
        }
        
        diagnostic.put("niveaux", niveaux);
        diagnostic.put("niveauxDebloques", obtenirNiveauxDebloques(citoyen.getId()));
        
        return diagnostic;
    }

    /**
     * Récupère tous les niveaux débloqués pour un utilisateur
     */
    public List<String> obtenirNiveauxDebloques(Long citoyenId) {
        List<QuizProgression> progressions = quizProgressionRepository
                .findByCitoyenIdOrderByDateDeblocageAsc(citoyenId);
        
        List<String> niveaux = new ArrayList<>();
        niveaux.add("FACILE"); // Toujours débloqué
        
        for (QuizProgression progression : progressions) {
            if (!"FACILE".equals(progression.getNiveau())) {
                niveaux.add(progression.getNiveau());
            }
        }
        
        return niveaux;
    }

    /**
     * Récupère la progression complète de l'utilisateur connecté pour tous les niveaux
     */
    public QuizProgressionUtilisateurResponse obtenirProgression() {
        Citoyen citoyen = getCitoyenConnecte();
        
        // S'assurer que la progression FACILE existe (créer si nécessaire)
        if (!quizProgressionRepository.existsByCitoyenIdAndNiveau(citoyen.getId(), "FACILE")) {
            QuizProgression progressionFacile = new QuizProgression();
            progressionFacile.setCitoyen(citoyen);
            progressionFacile.setNiveau("FACILE");
            progressionFacile.setQuizCompletes(0);
            progressionFacile.setMeilleurScore(0);
            quizProgressionRepository.save(progressionFacile);
            logger.info("✅ Progression FACILE créée automatiquement pour l'utilisateur {} dans obtenirProgression", citoyen.getId());
        }
        
        // Récupérer toutes les progressions
        List<QuizProgression> progressions = quizProgressionRepository
                .findByCitoyenIdOrderByDateDeblocageAsc(citoyen.getId());
        
        // Récupérer les statistiques globales
        QuizStatistique stats = quizStatistiqueRepository.findByCitoyenId(citoyen.getId())
                .orElseGet(() -> creerStatistiquesInitiales(citoyen));
        
        // Créer la réponse
        QuizProgressionUtilisateurResponse response = new QuizProgressionUtilisateurResponse();
        response.setCitoyenId(citoyen.getId());
        response.setCitoyenNom(citoyen.getNom());
        response.setCitoyenPrenom(citoyen.getPrenom());
        response.setTotalQuizCompletes(stats.getTotalQuizCompletes());
        response.setTotalPoints(stats.getTotalPoints());
        
        // Créer les progressions pour chaque niveau
        List<QuizProgressionResponse> progressionsResponse = new ArrayList<>();
        String[] tousNiveaux = {"FACILE", "MOYEN", "DIFFICILE"};
        String niveauActuel = "FACILE"; // Par défaut
        
        // Trouver le niveau actuel (dernier niveau avec des quiz complétés)
        for (int i = tousNiveaux.length - 1; i >= 0; i--) {
            String niveau = tousNiveaux[i];
            Optional<QuizProgression> progressionOpt = progressions.stream()
                    .filter(p -> niveau.equals(p.getNiveau()))
                    .findFirst();
            
            if (progressionOpt.isPresent() && progressionOpt.get().getQuizCompletes() > 0) {
                niveauActuel = niveau;
                break;
            }
        }
        
        response.setNiveauActuel(niveauActuel);
        
        // Créer les réponses pour chaque niveau
        for (String niveau : tousNiveaux) {
            QuizProgressionResponse progressionResponse = new QuizProgressionResponse();
            progressionResponse.setNiveau(niveau);
            
            Optional<QuizProgression> progressionOpt = progressions.stream()
                    .filter(p -> niveau.equals(p.getNiveau()))
                    .findFirst();
            
            if ("FACILE".equals(niveau)) {
                // FACILE est toujours débloqué
                progressionResponse.setEstDebloque(true);
                progressionResponse.setDateDeblocage(null); // Pas de date car toujours débloqué
                
                // Chercher la progression FACILE si elle existe
                if (progressionOpt.isPresent()) {
                    QuizProgression p = progressionOpt.get();
                    progressionResponse.setQuizCompletes(p.getQuizCompletes());
                    progressionResponse.setMeilleurScore(p.getMeilleurScore());
                } else {
                    progressionResponse.setQuizCompletes(0);
                    progressionResponse.setMeilleurScore(0);
                }
            } else {
                // MOYEN et DIFFICILE
                if (progressionOpt.isPresent()) {
                    QuizProgression p = progressionOpt.get();
                    progressionResponse.setEstDebloque(true);
                    progressionResponse.setDateDeblocage(p.getDateDeblocage());
                    progressionResponse.setQuizCompletes(p.getQuizCompletes());
                    progressionResponse.setMeilleurScore(p.getMeilleurScore());
                } else {
                    progressionResponse.setEstDebloque(false);
                    progressionResponse.setDateDeblocage(null);
                    progressionResponse.setQuizCompletes(0);
                    progressionResponse.setMeilleurScore(0);
                }
            }
            
            progressionResponse.setEstNiveauActuel(niveau.equals(niveauActuel));
            progressionsResponse.add(progressionResponse);
        }
        
        response.setProgressions(progressionsResponse);
        
        return response;
    }
}

