package ml.fasodocs.backend.service;

import ml.fasodocs.backend.dto.response.EtapeResponse;
import ml.fasodocs.backend.entity.Etape;
import ml.fasodocs.backend.repository.EtapeRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

/**
 * Service pour la gestion des étapes
 */
@Service
@Transactional
public class EtapeService {

    private static final Logger logger = LoggerFactory.getLogger(EtapeService.class);

    @Autowired
    private EtapeRepository etapeRepository;

    /**
     * Récupère toutes les étapes d'une procédure
     */
    public List<EtapeResponse> obtenirEtapesParProcedure(Long procedureId) {
        return etapeRepository.findByProcedureIdOrderByNiveauAsc(procedureId).stream()
                .map(this::convertirEnResponse)
                .collect(Collectors.toList());
    }

    /**
     * Récupère une étape par ID
     */
    public EtapeResponse obtenirEtapeParId(Long id) {
        Etape etape = etapeRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Étape non trouvée"));
        
        return convertirEnResponse(etape);
    }

    /**
     * Recherche des étapes par niveau
     */
    public List<EtapeResponse> obtenirEtapesParNiveau(Integer niveau) {
        return etapeRepository.findByNiveau(niveau).stream()
                .map(this::convertirEnResponse)
                .collect(Collectors.toList());
    }

    /**
     * Convertit une entité Etape en EtapeResponse
     */
    private EtapeResponse convertirEnResponse(Etape etape) {
        EtapeResponse response = new EtapeResponse();
        response.setId(etape.getId());
        response.setNom(etape.getNom());
        response.setDescription(etape.getDescription());
        response.setNiveau(etape.getNiveau());
        return response;
    }
}
