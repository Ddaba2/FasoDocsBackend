package ml.fasodocs.backend.service;

import ml.fasodocs.backend.dto.response.CentreResponse;
import ml.fasodocs.backend.entity.Centre;
import ml.fasodocs.backend.repository.CentreRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

/**
 * Service pour la gestion des centres
 */
@Service
@Transactional
public class CentreService {

    private static final Logger logger = LoggerFactory.getLogger(CentreService.class);

    @Autowired
    private CentreRepository centreRepository;

    @Autowired
    private TranslationHelper translationHelper;

    /**
     * Récupère tous les centres
     */
    public List<CentreResponse> obtenirTousCentres() {
        return centreRepository.findAll().stream()
                .map(this::convertirEnResponse)
                .collect(Collectors.toList());
    }

    /**
     * Récupère un centre par ID
     */
    public CentreResponse obtenirCentreParId(Long id) {
        Centre centre = centreRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Centre non trouvé"));
        
        return convertirEnResponse(centre);
    }

    /**
     * Recherche des centres par nom
     */
    public List<CentreResponse> rechercherCentres(String recherche) {
        return centreRepository.findByNomContainingIgnoreCase(recherche).stream()
                .map(this::convertirEnResponse)
                .collect(Collectors.toList());
    }

    /**
     * Recherche des centres par ville
     */
    public List<CentreResponse> rechercherCentresParVille(String ville) {
        return centreRepository.findByAdresseContainingIgnoreCase(ville).stream()
                .map(this::convertirEnResponse)
                .collect(Collectors.toList());
    }

    /**
     * Convertit une entité Centre en CentreResponse
     */
    private CentreResponse convertirEnResponse(Centre centre) {
        CentreResponse response = new CentreResponse();
        response.setId(centre.getId());
        response.setNom(translationHelper.getNom(centre));
        response.setAdresse(translationHelper.getAdresse(centre));
        response.setHoraires(translationHelper.getHoraires(centre));
        response.setCoordonneesGPS(centre.getCoordonneesGPS());
        response.setTelephone(centre.getTelephone());
        response.setEmail(centre.getEmail());
        return response;
    }
}
