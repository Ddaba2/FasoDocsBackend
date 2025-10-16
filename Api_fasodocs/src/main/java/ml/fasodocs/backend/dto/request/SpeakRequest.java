package ml.fasodocs.backend.dto.request;

import lombok.Data;

/**
 * DTO pour les requêtes de synthèse vocale (TTS)
 */
@Data
public class SpeakRequest {
    private String text;
    private Integer speaker; // ID du locuteur (optionnel, défaut: 1)
}

