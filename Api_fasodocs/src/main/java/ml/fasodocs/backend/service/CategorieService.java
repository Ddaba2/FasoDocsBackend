package ml.fasodocs.backend.service;

import ml.fasodocs.backend.dto.request.CategorieRequest;
import ml.fasodocs.backend.dto.response.CategorieResponse;
import ml.fasodocs.backend.dto.response.MessageResponse;
import ml.fasodocs.backend.entity.Categorie;
import ml.fasodocs.backend.repository.CategorieRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

/**
 * Service pour la gestion des catégories
 */
@Service
@Transactional
public class CategorieService {

    @Autowired
    private CategorieRepository categorieRepository;

    @Autowired
    private TranslationHelper translationHelper;

    /**
     * Récupère toutes les catégories
     */
    @Transactional(readOnly = true)
    public List<CategorieResponse> obtenirToutesCategories() {
        return categorieRepository.findAll().stream()
                .map(cat -> new CategorieResponse(cat, translationHelper))
                .collect(Collectors.toList());
    }

    /**
     * Récupère une catégorie par ID
     */
    @Transactional(readOnly = true)
    public CategorieResponse obtenirCategorieParId(Long id) {
        Optional<Categorie> categorieOpt = categorieRepository.findById(id);
        if (categorieOpt.isEmpty()) {
            throw new RuntimeException("Catégorie non trouvée");
        }
        return new CategorieResponse(categorieOpt.get(), translationHelper);
    }

    /**
     * Crée une nouvelle catégorie
     */
    public CategorieResponse creerCategorie(CategorieRequest request) {
        // Vérifier si le titre existe déjà
        if (categorieRepository.existsByTitre(request.getTitre())) {
            throw new RuntimeException("Une catégorie avec ce titre existe déjà");
        }

        Categorie categorie = new Categorie();
        categorie.setTitre(request.getTitre());
        categorie.setDescription(request.getDescription());
        categorie.setNomCategorie(request.getNomCategorie());
        categorie.setIconeUrl(request.getIconeUrl());

        categorieRepository.save(categorie);
        return new CategorieResponse(categorie);
    }

    /**
     * Met à jour une catégorie
     */
    public CategorieResponse mettreAJourCategorie(Long id, CategorieRequest request) {
        Optional<Categorie> categorieOpt = categorieRepository.findById(id);
        if (categorieOpt.isEmpty()) {
            throw new RuntimeException("Catégorie non trouvée");
        }

        Categorie categorie = categorieOpt.get();
        
        // Vérifier si le nouveau titre existe déjà (sauf pour la catégorie actuelle)
        if (!categorie.getTitre().equals(request.getTitre()) && 
            categorieRepository.existsByTitre(request.getTitre())) {
            throw new RuntimeException("Une catégorie avec ce titre existe déjà");
        }

        categorie.setTitre(request.getTitre());
        categorie.setDescription(request.getDescription());
        categorie.setNomCategorie(request.getNomCategorie());
        categorie.setIconeUrl(request.getIconeUrl());

        categorieRepository.save(categorie);
        return new CategorieResponse(categorie);
    }

    /**
     * Supprime une catégorie
     */
    public MessageResponse supprimerCategorie(Long id) {
        Optional<Categorie> categorieOpt = categorieRepository.findById(id);
        if (categorieOpt.isEmpty()) {
            throw new RuntimeException("Catégorie non trouvée");
        }

        Categorie categorie = categorieOpt.get();
        
        // Vérifier si la catégorie a des procédures associées
        if (!categorie.getProcedures().isEmpty()) {
            throw new RuntimeException("Impossible de supprimer une catégorie qui contient des procédures");
        }

        categorieRepository.delete(categorie);
        return MessageResponse.success("Catégorie supprimée avec succès");
    }
}
