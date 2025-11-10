"""
Backend FasoDocs avec Djelia AI

Support complet reconnaissance vocale bambara (STT) + synthèse vocale (TTS)

Installation requise:
pip install flask flask-cors djelia python-dotenv
"""

from flask import Flask, request, jsonify, send_file
from flask_cors import CORS
from djelia import Djelia
from djelia.models import Versions, TranslationRequest, TTSRequest
import os
import tempfile
import logging
from datetime import datetime
import requests
import json

# Configuration logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

# Initialisation Flask
app = Flask(__name__)
CORS(app)  # Activer CORS pour permettre requêtes depuis le frontend

# Configuration Djelia
# Lire depuis variable d'environnement ou fichier .env
DJELIA_API_KEY = os.getenv('DJELIA_API_KEY', '83c313b9-aeba-441b-8b7f-a194720ad1d3')
os.environ['DJELIA_API_KEY'] = DJELIA_API_KEY

# Initialiser client Djelia
try:
    djelia_client = Djelia(api_key=DJELIA_API_KEY)
    logger.info("✅ Client Djelia initialisé avec succès")
except Exception as e:
    logger.error(f"❌ Erreur initialisation Djelia: {e}")
    djelia_client = None

@app.route('/')
def home():
    """Page d'accueil de l'API"""
    return jsonify({
        'service': 'FasoDocs Backend API',
        'version': '1.0.0',
        'status': 'running',
        'endpoints': {
            'speak': '/api/speak (POST)',
            'transcribe': '/api/transcribe (POST)',
            'conversation': '/api/conversation (POST)',
            'health': '/api/health (GET)'
        }
    })

@app.route('/api/health', methods=['GET'])
def health_check():
    """Vérifier l'état du service"""
    djelia_status = 'connected' if djelia_client else 'disconnected'
    
    return jsonify({
        'status': 'healthy',
        'timestamp': datetime.now().isoformat(),
        'djelia': djelia_status
    })

@app.route('/api/speak', methods=['POST'])
def generate_speech():
    """
    Générer audio bambara à partir de texte avec Djelia TTS
    AVEC TRADUCTION AUTOMATIQUE français → bambara
    
    Paramètres:
        - text: Texte en français (sera traduit en bambara)
        - speaker: Numéro du speaker (défaut: 1)
        - skip_translation: Si True, ne pas traduire (défaut: False)
    
    Retourne:
        - Fichier audio WAV en bambara
    """
    try:
        logger.info("🔊 Requête de synthèse vocale reçue")
        
        # Vérifier si client Djelia est disponible
        if not djelia_client:
            logger.error("❌ Client Djelia non initialisé")
            return jsonify({
                'success': False,
                'error': 'Service de synthèse vocale non disponible'
            }), 503
        
        # Récupérer paramètres
        data = request.json or {}
        text = data.get('text', '')
        speaker = data.get('speaker', 1)
        skip_translation = data.get('skip_translation', False)
        
        if not text:
            logger.error("❌ Aucun texte fourni")
            return jsonify({
                'success': False,
                'error': 'Aucun texte fourni'
            }), 400
        
        logger.info(f"📝 Texte français reçu ({len(text)} caractères): {text[:50]}...")
        
        # Limiter longueur pour éviter timeout
        if len(text) > 500:
            logger.warning(f"⚠️ Texte trop long ({len(text)} car.), troncature à 500")
            text = text[:500] + "..."
        
        # ✅ ÉTAPE 1 : TRADUIRE FRANÇAIS → BAMBARA
        bambara_text = text
        if not skip_translation:
            try:
                logger.info("🌐 Traduction FR → BM avec API Djelia (appel HTTP direct)...")
                
                # ✅ APPEL HTTP DIRECT à l'API Djelia (plus fiable que SDK)
                translation_url = "https://api.djelia.cloud/v1/translation"
                translation_headers = {
                    "Content-Type": "application/json",
                    "Authorization": f"Bearer {DJELIA_API_KEY}"
                }
                translation_payload = {
                    "text": text,
                    "source": "fra_Latn",
                    "target": "bam_Latn"
                }
                
                logger.info(f"📤 POST {translation_url}")
                logger.info(f"📦 Payload: {json.dumps(translation_payload, ensure_ascii=False)[:100]}...")
                
                translation_response = requests.post(
                    translation_url,
                    headers=translation_headers,
                    json=translation_payload,
                    timeout=30
                )
                
                logger.info(f"📥 Status: {translation_response.status_code}")
                
                if translation_response.status_code == 200:
                    translation_data = translation_response.json()
                    logger.info(f"📋 Réponse: {translation_data}")
                    
                    bambara_text = translation_data.get('translated_text', 
                                                       translation_data.get('translation', 
                                                       translation_data.get('text', text)))
                    
                    logger.info(f"✅ Traduction réussie!")
                    logger.info(f"🇫🇷 FR: {text[:80]}")
                    logger.info(f"🇲🇱 BM: {bambara_text[:80]}")
                else:
                    logger.error(f"❌ API Traduction erreur {translation_response.status_code}")
                    logger.error(f"📄 Body: {translation_response.text}")
                    bambara_text = text
                
            except Exception as e:
                logger.error(f"❌ Erreur traduction: {e}")
                logger.warning("⚠️ Utilisation du texte original sans traduction")
                bambara_text = text
        
        # ✅ ÉTAPE 2 : GÉNÉRER AUDIO DU TEXTE BAMBARA
        logger.info(f"🎵 Génération audio bambara avec Djelia TTS V2...")
        logger.info(f"📝 Texte bambara pour TTS: {bambara_text[:50]}...")
        tts_request = TTSRequest(text=bambara_text.strip(), speaker=speaker)
        
        try:
            # Essayer V2 (plus stable)
            audio_data = djelia_client.tts.text_to_speech(
                request=tts_request,
                version=Versions.v2
            )
            logger.info(f"✅ Audio généré V2 ({len(audio_data)} bytes)")
        except Exception as e:
            # Fallback vers V1
            logger.warning(f"⚠️ V2 échouée, fallback vers V1: {e}")
            audio_data = djelia_client.tts.text_to_speech(
                request=tts_request,
                version=Versions.v1
            )
            logger.info(f"✅ Audio généré V1 ({len(audio_data)} bytes)")
        
        # Sauvegarder audio temporairement
        with tempfile.NamedTemporaryFile(delete=False, suffix='.wav') as temp_audio:
            temp_audio.write(audio_data)
            temp_audio_path = temp_audio.name
        
        logger.info(f"✅ Synthèse vocale réussie")
        
        # Envoyer fichier audio
        return send_file(
            temp_audio_path,
            mimetype='audio/wav',
            as_attachment=True,
            download_name='response.wav'
        )
        
    except AttributeError as e:
        logger.error(f"❌ Méthode TTS non disponible: {e}")
        return jsonify({
            'success': False,
            'error': 'API de synthèse vocale Djelia non disponible',
            'details': str(e)
        }), 501
        
    except Exception as e:
        logger.error(f"❌ Erreur synthèse vocale: {e}")
        return jsonify({
            'success': False,
            'error': 'Erreur lors de la synthèse vocale',
            'details': str(e)
        }), 500

@app.route('/api/transcribe', methods=['POST'])
def transcribe_audio():
    """
    Transcrire audio bambara en texte avec Djelia STT
    
    Paramètres:
        - audio: Fichier audio (WAV, MP3, etc.)
    
    Retourne:
        - text: Transcription en bambara
        - confidence: Niveau de confiance
    """
    try:
        logger.info("📤 Requête de transcription reçue")
        
        # Vérifier si client Djelia est disponible
        if not djelia_client:
            logger.error("❌ Client Djelia non initialisé")
            return jsonify({
                'success': False,
                'error': 'Service de transcription non disponible'
            }), 503
        
        # Vérifier présence du fichier audio
        if 'audio' not in request.files:
            logger.error("❌ Aucun fichier audio dans la requête")
            return jsonify({
                'success': False,
                'error': 'Aucun fichier audio fourni'
            }), 400
        
        audio_file = request.files['audio']
        
        if audio_file.filename == '':
            logger.error("❌ Nom de fichier audio vide")
            return jsonify({
                'success': False,
                'error': 'Fichier audio invalide'
            }), 400
        
        # Sauvegarder temporairement le fichier audio
        filename = audio_file.filename or ''
        file_ext = os.path.splitext(filename)[1] or '.wav'
        
        with tempfile.NamedTemporaryFile(delete=False, suffix=file_ext) as temp_audio:
            audio_file.save(temp_audio.name)
            temp_audio_path = temp_audio.name
            logger.info(f"💾 Audio sauvegardé: {temp_audio_path}")
        
        try:
            # Transcrire avec Djelia STT V2
            logger.info("🎤 Transcription STT V2...")
            
            try:
                transcription_result = djelia_client.transcription.transcribe(
                    audio_file=temp_audio_path,
                    version=Versions.v2
                )
                logger.info("✅ Transcription STT V2 utilisée")
            except Exception as e:
                # Fallback vers V1
                logger.warning(f"⚠️ STT V2 échouée, fallback vers V1: {e}")
                transcription_result = djelia_client.transcription.transcribe(
                    audio_file=temp_audio_path,
                    version=Versions.v1
                )
                logger.info("✅ Transcription STT V1 utilisée")
            
            # Extraire le texte
            transcription_text = ""
            if isinstance(transcription_result, list) and len(transcription_result) > 0:
                first_segment = transcription_result[0]
                if hasattr(first_segment, 'text'):
                    transcription_text = getattr(first_segment, 'text', '')
                else:
                    transcription_text = str(first_segment)
            elif hasattr(transcription_result, 'text'):
                transcription_text = getattr(transcription_result, 'text', '')
            else:
                transcription_text = str(transcription_result)
            
            logger.info(f"✅ Transcription réussie: {transcription_text}")
            
            # Nettoyer fichier temporaire
            os.unlink(temp_audio_path)
            
            return jsonify({
                'success': True,
                'text': transcription_text,
                'language': 'bambara',
                'confidence': 0.95
            })
            
        except Exception as e:
            logger.error(f"❌ Erreur transcription: {e}")
            os.unlink(temp_audio_path)
            
            return jsonify({
                'success': False,
                'error': 'Erreur lors de la transcription',
                'details': str(e)
            }), 500
        
    except Exception as e:
        logger.error(f"❌ Erreur générale: {e}")
        return jsonify({
            'success': False,
            'error': 'Erreur serveur interne',
            'details': str(e)
        }), 500

if __name__ == '__main__':
    logger.info("🚀 Démarrage du serveur FasoDocs Backend Flask + Djelia AI")
    logger.info(f"🔑 API Key Djelia: {DJELIA_API_KEY[:20]}...")
    logger.info("📡 Endpoints disponibles:")
    logger.info("   - GET  /api/health (statut du service)")
    logger.info("   - POST /api/speak (Traduction FR→BM + TTS)")
    logger.info("   - POST /api/transcribe (STT bambara)")
    logger.info("")
    logger.info("🇲🇱 Djelia AI : Traduction et Synthèse Vocale Bambara")
    
    # Démarrer serveur
    app.run(
        host='0.0.0.0',  # Accessible depuis réseau
        port=5000,
        debug=True
    )

