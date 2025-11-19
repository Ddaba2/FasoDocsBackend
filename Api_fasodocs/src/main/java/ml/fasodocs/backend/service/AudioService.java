package ml.fasodocs.backend.service;

import ml.fasodocs.backend.entity.Procedure;
import ml.fasodocs.backend.repository.ProcedureRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.Resource;
import org.springframework.core.io.ResourceLoader;
import org.springframework.stereotype.Service;

import javax.sound.sampled.*;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.Base64;

/**
 * Service pour gérer les fichiers audio de fallback des procédures
 * 
 * Ce service permet de :
 * - Récupérer les fichiers audio stockés localement
 * - Convertir les fichiers audio en Base64 pour l'API
 * - Gérer le fallback si Djelia AI ne fonctionne pas
 */
@Service
public class AudioService {

    private static final Logger logger = LoggerFactory.getLogger(AudioService.class);

    @Autowired
    private ProcedureRepository procedureRepository;

    @Autowired
    private ResourceLoader resourceLoader;

    @Value("${app.audio.volume.boost:1.0}")
    private double volumeBoost;

    /**
     * Récupère le fichier audio d'une procédure
     * 
     * @param procedureId ID de la procédure
     * @return Resource du fichier audio ou null si non trouvé
     */
    public Resource getAudioFile(Long procedureId) {
        try {
            Procedure procedure = procedureRepository.findById(procedureId)
                    .orElse(null);
            
            if (procedure == null || procedure.getAudioUrl() == null || procedure.getAudioUrl().isEmpty()) {
                logger.debug("Aucun fichier audio configuré pour la procédure {} (audio_url est null ou vide)", procedureId);
                return null;
            }

            String audioUrl = procedure.getAudioUrl();
            logger.debug("Recherche du fichier audio pour la procédure {}: {}", procedureId, audioUrl);

            // Si c'est une URL HTTP/HTTPS, utiliser ResourceLoader
            if (audioUrl.startsWith("http://") || audioUrl.startsWith("https://")) {
                logger.debug("URL HTTP détectée: {}", audioUrl);
                Resource resource = resourceLoader.getResource(audioUrl);
                if (resource.exists() && resource.isReadable()) {
                    logger.info("Fichier audio HTTP trouvé pour la procédure {}: {}", procedureId, audioUrl);
                    return resource;
                } else {
                    logger.warn("Fichier audio HTTP non accessible: {}", audioUrl);
                    return null;
                }
            }

            // Pour les fichiers dans src/main/resources/static/, utiliser le classpath
            // Le chemin doit être relatif depuis static/
            String classpathPath;
            if (audioUrl.startsWith("/")) {
                // Chemin absolu depuis static/
                classpathPath = "static" + audioUrl;
            } else {
                // Chemin relatif depuis static/audio/procedures/
                classpathPath = "static/audio/procedures/" + audioUrl;
            }

            logger.debug("Tentative de chargement depuis classpath: {}", classpathPath);
            Resource resource = new ClassPathResource(classpathPath);
            
            if (resource.exists() && resource.isReadable()) {
                logger.info("✅ Fichier audio trouvé pour la procédure {}: {}", procedureId, classpathPath);
                return resource;
            } else {
                logger.warn("⚠️ Fichier audio non trouvé dans le classpath: {}", classpathPath);
                
                // Essayer aussi avec le chemin direct depuis static/
                String alternativePath = "static/" + audioUrl;
                Resource altResource = new ClassPathResource(alternativePath);
                if (altResource.exists() && altResource.isReadable()) {
                    logger.info("✅ Fichier audio trouvé avec chemin alternatif pour la procédure {}: {}", procedureId, alternativePath);
                    return altResource;
                }
                
                return null;
            }
        } catch (Exception e) {
            logger.error("❌ Erreur lors de la récupération du fichier audio pour la procédure {}: {}", procedureId, e.getMessage(), e);
            return null;
        }
    }

    /**
     * Récupère le fichier audio d'une procédure en Base64 avec amplification du volume
     * 
     * @param procedureId ID de la procédure
     * @return Audio en Base64 ou null si non trouvé
     */
    public String getAudioBase64(Long procedureId) {
        try {
            byte[] audioBytes = getAudioBytes(procedureId);
            
            if (audioBytes == null) {
                return null;
            }
            
            String audioBase64 = Base64.getEncoder().encodeToString(audioBytes);
            
            logger.info("Audio converti en Base64 pour la procédure {} ({} bytes)", 
                    procedureId, audioBytes.length);
            
            return audioBase64;
        } catch (Exception e) {
            logger.error("Erreur lors de la conversion en Base64 pour la procédure {}", procedureId, e);
            return null;
        }
    }

    /**
     * Amplifie le volume d'un fichier audio WAV
     * 
     * @param audioBytes Bytes du fichier audio original
     * @param boostFactor Facteur d'amplification (1.0 = normal, 2.0 = double volume)
     * @return Bytes du fichier audio amplifié
     * @throws IOException Si erreur de lecture/écriture
     * @throws UnsupportedAudioFileException Si le format audio n'est pas supporté
     */
    private byte[] amplifyAudio(byte[] audioBytes, double boostFactor) 
            throws IOException, UnsupportedAudioFileException {
        try (ByteArrayInputStream bais = new ByteArrayInputStream(audioBytes);
             AudioInputStream audioInputStream = AudioSystem.getAudioInputStream(bais)) {
            
            AudioFormat format = audioInputStream.getFormat();
            logger.debug("Format audio: {}, channels: {}, sampleRate: {}, sampleSizeInBits: {}", 
                    format.getEncoding(), format.getChannels(), format.getSampleRate(), format.getSampleSizeInBits());
            
            // Lire tous les échantillons audio
            int frameSize = format.getFrameSize();
            int numFrames = (int) audioInputStream.getFrameLength();
            byte[] audioData = new byte[numFrames * frameSize];
            audioInputStream.read(audioData);
            
            // Amplifier les échantillons selon le format
            byte[] amplifiedData = amplifyAudioSamples(audioData, format, boostFactor);
            
            // Créer un nouveau fichier audio avec les données amplifiées
            try (ByteArrayOutputStream baos = new ByteArrayOutputStream()) {
                AudioInputStream amplifiedStream = new AudioInputStream(
                        new ByteArrayInputStream(amplifiedData),
                        format,
                        numFrames
                );
                AudioSystem.write(amplifiedStream, AudioFileFormat.Type.WAVE, baos);
                return baos.toByteArray();
            }
        }
    }

    /**
     * Amplifie les échantillons audio selon leur format
     * 
     * @param audioData Données audio brutes
     * @param format Format audio
     * @param boostFactor Facteur d'amplification
     * @return Données audio amplifiées
     */
    private byte[] amplifyAudioSamples(byte[] audioData, AudioFormat format, double boostFactor) {
        int sampleSizeInBits = format.getSampleSizeInBits();
        boolean bigEndian = format.isBigEndian();
        int channels = format.getChannels();
        boolean signed = format.getEncoding() == AudioFormat.Encoding.PCM_SIGNED;
        
        byte[] amplified = new byte[audioData.length];
        
        if (sampleSizeInBits == 16) {
            // Format 16-bit
            for (int i = 0; i < audioData.length - 1; i += 2) {
                int sample;
                if (bigEndian) {
                    sample = (audioData[i] << 8) | (audioData[i + 1] & 0xFF);
                } else {
                    sample = (audioData[i + 1] << 8) | (audioData[i] & 0xFF);
                }
                
                if (signed) {
                    if (sample > 32767) sample -= 65536; // Convertir en signed
                } else {
                    sample -= 32768; // Convertir en signed pour le traitement
                }
                
                // Amplifier avec limitation pour éviter la distorsion
                int amplifiedSample = (int) (sample * boostFactor);
                amplifiedSample = Math.max(-32768, Math.min(32767, amplifiedSample)); // Limiter à la plage 16-bit
                
                if (!signed) {
                    amplifiedSample += 32768; // Reconvertir en unsigned si nécessaire
                }
                
                if (bigEndian) {
                    amplified[i] = (byte) ((amplifiedSample >> 8) & 0xFF);
                    amplified[i + 1] = (byte) (amplifiedSample & 0xFF);
                } else {
                    amplified[i] = (byte) (amplifiedSample & 0xFF);
                    amplified[i + 1] = (byte) ((amplifiedSample >> 8) & 0xFF);
                }
            }
        } else if (sampleSizeInBits == 8) {
            // Format 8-bit
            for (int i = 0; i < audioData.length; i++) {
                int sample = audioData[i] & 0xFF;
                if (signed) {
                    if (sample > 127) sample -= 256;
                } else {
                    sample -= 128;
                }
                
                int amplifiedSample = (int) (sample * boostFactor);
                amplifiedSample = Math.max(-128, Math.min(127, amplifiedSample));
                
                if (!signed) {
                    amplifiedSample += 128;
                }
                
                amplified[i] = (byte) (amplifiedSample & 0xFF);
            }
        } else {
            // Format non supporté, retourner les données originales
            logger.warn("Format audio non supporté pour l'amplification: {} bits", sampleSizeInBits);
            return audioData;
        }
        
        return amplified;
    }

    /**
     * Récupère les bytes audio d'une procédure avec amplification du volume
     * 
     * @param procedureId ID de la procédure
     * @return Bytes du fichier audio (amplifié si configuré) ou null si non trouvé
     */
    public byte[] getAudioBytes(Long procedureId) {
        try {
            Resource audioResource = getAudioFile(procedureId);
            
            if (audioResource == null) {
                return null;
            }

            byte[] audioBytes = audioResource.getInputStream().readAllBytes();
            
            // Amplifier le volume si configuré
            if (volumeBoost > 1.0) {
                try {
                    audioBytes = amplifyAudio(audioBytes, volumeBoost);
                    logger.info("Audio amplifié avec facteur {} pour la procédure {}", volumeBoost, procedureId);
                } catch (Exception e) {
                    logger.warn("Impossible d'amplifier l'audio pour la procédure {}, utilisation de l'audio original: {}", 
                            procedureId, e.getMessage());
                    // Continuer avec l'audio original si l'amplification échoue
                }
            }
            
            return audioBytes;
        } catch (Exception e) {
            logger.error("Erreur lors de la récupération des bytes audio pour la procédure {}", procedureId, e);
            return null;
        }
    }

    /**
     * Vérifie si un fichier audio existe pour une procédure
     * 
     * @param procedureId ID de la procédure
     * @return true si un fichier audio existe, false sinon
     */
    public boolean hasAudioFile(Long procedureId) {
        Resource audioResource = getAudioFile(procedureId);
        return audioResource != null && audioResource.exists();
    }
}

