package ml.fasodocs.backend.service;

import ml.fasodocs.backend.dto.request.SousCategorieRequest;
import ml.fasodocs.backend.dto.response.MessageResponse;
import ml.fasodocs.backend.dto.response.SousCategorieResponse;
import ml.fasodocs.backend.entity.Categorie;
import ml.fasodocs.backend.entity.SousCategorie;
import ml.fasodocs.backend.repository.CategorieRepository;
import ml.fasodocs.backend.repository.SousCategorieRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

/**
 * Service pour la gestion des sous-catégories
 */
@Service
@Transactional
public class SousCategorieService {

    private static final Logger logger = LoggerFactory.getLogger(SousCategorieService.class);

    @Autowired
    private SousCategorieRepository sousCategorieRepository;

    @Autowired
    private CategorieRepository categorieRepository;

    @Autowired
    private TranslationHelper translationHelper;

    @Autowired
    private NotificationService notificationService;

    /**
     * Récupère toutes les sous-catégories
     */
    @Transactional(readOnly = true)
    public List<SousCategorieResponse> obtenirToutesSousCategories() {
        return sousCategorieRepository.findAllWithProcedures().stream()
                .map(sc -> new SousCategorieResponse(sc, translationHelper))
                .collect(Collectors.toList());
    }

    /**
     * Récupère une sous-catégorie par ID
     */
    @Transactional(readOnly = true)
    public SousCategorieResponse obtenirSousCategorieParId(Long id) {
        Optional<SousCategorie> sousCategorieOpt = sousCategorieRepository.findByIdWithProcedures(id);
        if (sousCategorieOpt.isEmpty()) {
            throw new RuntimeException("Sous-catégorie non trouvée");
        }
        return new SousCategorieResponse(sousCategorieOpt.get(), translationHelper);
    }

    /**
     * Récupère les sous-catégories d'une catégorie
     */
    @Transactional(readOnly = true)
    public List<SousCategorieResponse> obtenirSousCategoriesParCategorie(Long categorieId) {
        return sousCategorieRepository.findByCategorieIdWithProcedures(categorieId).stream()
                .map(sc -> new SousCategorieResponse(sc, translationHelper))
                .collect(Collectors.toList());
    }

    /**
     * Crée une nouvelle sous-catégorie
     */
    public SousCategorieResponse creerSousCategorie(SousCategorieRequest request) {
        // Vérifier si la catégorie parent existe
        Optional<Categorie> categorieOpt = categorieRepository.findById(request.getCategorieId());
        if (categorieOpt.isEmpty()) {
            throw new RuntimeException("Catégorie parent non trouvée");
        }

        // Vérifier si le titre existe déjà dans cette catégorie
        if (sousCategorieRepository.existsByTitre(request.getTitre())) {
            throw new RuntimeException("Une sous-catégorie avec ce titre existe déjà");
        }

        SousCategorie sousCategorie = new SousCategorie();
        sousCategorie.setTitre(request.getTitre());
        sousCategorie.setDescription(request.getDescription());
        sousCategorie.setIconeUrl(request.getIconeUrl());
        sousCategorie.setCategorie(categorieOpt.get());

        sousCategorieRepository.save(sousCategorie);
        return new SousCategorieResponse(sousCategorie);
    }

    /**
     * Met à jour une sous-catégorie
     */
    public SousCategorieResponse mettreAJourSousCategorie(Long id, SousCategorieRequest request) {
        Optional<SousCategorie> sousCategorieOpt = sousCategorieRepository.findById(id);
        if (sousCategorieOpt.isEmpty()) {
            throw new RuntimeException("Sous-catégorie non trouvée");
        }

        SousCategorie sousCategorie = sousCategorieOpt.get();
        
        // Vérifier si la catégorie parent existe
        if (request.getCategorieId() == null) {
            throw new RuntimeException("ID de catégorie parent requis");
        }
        
        Optional<Categorie> categorieOpt = categorieRepository.findById(request.getCategorieId());
        if (categorieOpt.isEmpty()) {
            throw new RuntimeException("Catégorie parent non trouvée");
        }

        // Vérifier si le nouveau titre existe déjà (sauf pour la sous-catégorie actuelle)
        if (!sousCategorie.getTitre().equals(request.getTitre()) && 
            sousCategorieRepository.existsByTitre(request.getTitre())) {
            throw new RuntimeException("Une sous-catégorie avec ce titre existe déjà");
        }

        sousCategorie.setTitre(request.getTitre());
        sousCategorie.setDescription(request.getDescription());
        sousCategorie.setIconeUrl(request.getIconeUrl());
        sousCategorie.setCategorie(categorieOpt.get());

        SousCategorie updatedSousCategorie = sousCategorieRepository.save(sousCategorie);
        
        // Notifier tous les citoyens de la mise à jour
        try {
            notificationService.notifierMiseAJourSousCategorie(updatedSousCategorie);
        } catch (Exception e) {
            logger.warn("Impossible d'envoyer les notifications de mise à jour de sous-catégorie: {}", e.getMessage());
        }
        
        return new SousCategorieResponse(updatedSousCategorie);
    }

    /**
     * Supprime une sous-catégorie
     */
    public MessageResponse supprimerSousCategorie(Long id) {
        Optional<SousCategorie> sousCategorieOpt = sousCategorieRepository.findById(id);
        if (sousCategorieOpt.isEmpty()) {
            throw new RuntimeException("Sous-catégorie non trouvée");
        }

        SousCategorie sousCategorie = sousCategorieOpt.get();
        
        // Vérifier si la sous-catégorie a des procédures associées
        if (!sousCategorie.getProcedures().isEmpty()) {
            throw new RuntimeException("Impossible de supprimer une sous-catégorie qui contient des procédures");
        }

        // Notifier tous les citoyens de la suppression (avant la suppression)
        try {
            notificationService.notifierSuppressionSousCategorie(sousCategorie);
        } catch (Exception e) {
            logger.warn("Impossible d'envoyer les notifications de suppression de sous-catégorie: {}", e.getMessage());
        }

        sousCategorieRepository.delete(sousCategorie);
        return MessageResponse.success("Sous-catégorie supprimée avec succès");
    }
}
