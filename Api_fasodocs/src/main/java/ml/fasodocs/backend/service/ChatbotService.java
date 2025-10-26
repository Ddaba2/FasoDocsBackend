package ml.fasodocs.backend.service;

import ml.fasodocs.backend.dto.request.ChatRequest;
import ml.fasodocs.backend.dto.request.TranslationRequest;
import ml.fasodocs.backend.dto.request.SpeakRequest;
import ml.fasodocs.backend.dto.response.ChatResponse;
import ml.fasodocs.backend.dto.response.TranslationResponse;
import ml.fasodocs.backend.dto.response.SpeakResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * Service pour la gestion du chatbot Djelia AI
 * 
 * Ce service fait le lien entre l'application FasoDocs et le backend Djelia AI
 * pour fournir des fonctionnalités de :
 * - Chat conversationnel en français et bambara
 * - Traduction automatique entre français et bambara
 * - Synthèse vocale en bambara pour l'accessibilité
 * 
 * Le backend Djelia AI est un service externe Flask (Python) qui fournit
 * ces fonctionnalités IA pour le Mali.
 * 
 * @see ml.fasodocs.backend.service.DjeliaIntegrationService
 * @see ml.fasodocs.backend.controller.ChatbotController
 */
@Service
public class ChatbotService {

    /** Service d'intégration avec Djelia AI Backend */
    @Autowired
    private DjeliaIntegrationService djeliaIntegrationService;

    /**
     * Traite une demande de chat avec Djelia AI
     * 
     * Envoie un message à Djelia AI et retourne la réponse.
     * Supporte le français et le bambara.
     * 
     * @param request Requête de chat contenant le message et la langue
     * @return Réponse de chat avec le texte de Djelia AI
     */
    public ChatResponse traiterChat(ChatRequest request) {
        try {
            String response = djeliaIntegrationService.chatAvecDjelia(
                request.getMessage(), 
                request.getLanguage()
            );

            return new ChatResponse(
                response,
                request.getLanguage(),
                null, // Pas d'audio pour le chat simple
                true,
                null
            );

        } catch (Exception e) {
            return new ChatResponse(
                "Désolé, je ne peux pas répondre pour le moment.",
                request.getLanguage(),
                null,
                false,
                e.getMessage()
            );
        }
    }

    /**
     * Traduit un texte entre le français et le bambara (ou vice versa)
     * 
     * Utilise le service de traduction de Djelia AI.
     * 
     * @param request Requête de traduction contenant le texte, la langue source et cible
     * @return Réponse de traduction avec le texte original et traduit
     */
    public TranslationResponse traduireTexte(TranslationRequest request) {
        try {
            String translatedText = djeliaIntegrationService.traduireTexte(
                request.getText(),
                request.getSourceLang(),
                request.getTargetLang()
            );

            return new TranslationResponse(
                request.getText(),
                translatedText,
                request.getSourceLang(),
                request.getTargetLang(),
                true,
                null
            );

        } catch (Exception e) {
            return new TranslationResponse(
                request.getText(),
                request.getText(), // Retourne le texte original en cas d'erreur
                request.getSourceLang(),
                request.getTargetLang(),
                false,
                e.getMessage()
            );
        }
    }

    /**
     * Génère une synthèse vocale à partir d'un texte en bambara
     * 
     * Utilise le service de synthèse vocale de Djelia AI pour générer
     * un audio en bambara à partir d'un texte.
     * 
     * @param request Requête contenant le texte à vocaliser en bambara
     * @return Réponse avec l'URL de l'audio généré
     */
    public SpeakResponse genererSynthèseVocale(SpeakRequest request) {
        try {
            String audioUrl = djeliaIntegrationService.genererSynthèseVocale(
                request.getText(),
                "bm" // Bambara par défaut pour la synthèse vocale
            );

            if (audioUrl != null) {
                return new SpeakResponse(
                    request.getText(),
                    "bm",
                    audioUrl,
                    true,
                    null
                );
            } else {
                return new SpeakResponse(
                    request.getText(),
                    "bm",
                    null,
                    false,
                    "Impossible de générer l'audio"
                );
            }

        } catch (Exception e) {
            return new SpeakResponse(
                request.getText(),
                "bm",
                null,
                false,
                e.getMessage()
            );
        }
    }

    /**
     * Chat avec synthèse vocale en bambara
     * 
     * Cette méthode combine chat, traduction et synthèse vocale :
     * 1. Obtient une réponse de Djelia AI
     * 2. Traduit la réponse en bambara si nécessaire
     * 3. Génère un fichier audio en bambara
     * 
     * Utile pour permettre aux utilisateurs d'écouter les réponses du chatbot.
     * 
     * @param request Requête de chat avec message et langue
     * @return Réponse de chat avec texte et URL audio en bambara
     */
    public ChatResponse chatAvecSynthèseVocale(ChatRequest request) {
        try {
            // 1. Obtenir la réponse du chat
            String response = djeliaIntegrationService.chatAvecDjelia(
                request.getMessage(), 
                request.getLanguage()
            );

            // 2. Traduire en bambara si nécessaire
            String responseBambara = response;
            if (!"bm".equals(request.getLanguage())) {
                responseBambara = djeliaIntegrationService.traduireTexte(
                    response, "fr", "bm"
                );
            }

            // 3. Générer la synthèse vocale
            String audioUrl = djeliaIntegrationService.genererSynthèseVocale(
                responseBambara, "bm"
            );

            return new ChatResponse(
                response,
                request.getLanguage(),
                audioUrl,
                true,
                null
            );

        } catch (Exception e) {
            return new ChatResponse(
                "Désolé, je ne peux pas répondre pour le moment.",
                request.getLanguage(),
                null,
                false,
                e.getMessage()
            );
        }
    }

    /**
     * Vérifie la connectivité avec Djelia AI
     * 
     * Teste si le backend Djelia AI est accessible.
     * Utilisé pour le endpoint /chatbot/health.
     * 
     * @return true si Djelia AI est accessible, false sinon
     */
    public boolean verifierConnectivité() {
        return djeliaIntegrationService.verifierConnexion();
    }
}
