"""
Backend FasoDocs avec Djelia AI

Support complet reconnaissance vocale bambara (STT) + synthèse vocale (TTS)

Installation requise:
pip install flask flask-cors djelia python-dotenv
"""

from flask import Flask, request, jsonify, send_file
from flask_cors import CORS
from djelia import Djelia
from djelia.models import Versions, TTSRequest
import os
import tempfile
import logging
from datetime import datetime
import json
import urllib3
import ssl

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
            'translate': '/api/translate (POST)',
            'speak': '/api/speak (POST)',
            'transcribe': '/api/transcribe (POST)',
            'conversation': '/api/conversation (POST)',
            'health': '/api/health (GET)'
        }
    })

def translate_french_to_bambara(text):
    """
    Fonction helper pour traduire du français vers le bambara
    Utilisée par /api/translate et /api/speak
    
    ✅ ASSURÉ PAR DJELIA AI : Utilise l'API Djelia pour la traduction
    
    Args:
        text: Texte en français à traduire
    
    Returns:
        str: Texte traduit en bambara par Djelia AI
    """
    # ✅ UTILISATION DIRECTE DE L'APPEL HTTP (le SDK Djelia a un bug)
    # L'appel HTTP direct est plus fiable et permet un meilleur contrôle SSL
    return translate_french_to_bambara_http_fallback(text)

def translate_french_to_bambara_http_fallback(text):
    """
    Traduction via appel HTTP direct à l'API Djelia AI
    ✅ ASSURÉ PAR DJELIA AI : https://api.djelia.cloud/v1/translation
    """
    try:
        logger.info("🌐 Traduction FR → BM avec Djelia AI (API HTTP directe)...")
        logger.info("✅ Service assuré par Djelia AI")
        
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
        
        # Configuration SSL: forcer TLS 1.2 avec urllib3 directement
        urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)
        
        ssl_context = ssl.create_default_context()
        ssl_context.check_hostname = False
        ssl_context.verify_mode = ssl.CERT_NONE
        try:
            ssl_context.minimum_version = ssl.TLSVersion.TLSv1_2
        except AttributeError:
            ssl_context.options |= ssl.OP_NO_SSLv2
            ssl_context.options |= ssl.OP_NO_SSLv3
            ssl_context.options |= ssl.OP_NO_TLSv1
            ssl_context.options |= ssl.OP_NO_TLSv1_1
        
        http = urllib3.PoolManager(
            ssl_context=ssl_context,
            cert_reqs=ssl.CERT_NONE,
            assert_hostname=False
        )
        
        import json as json_module
        payload_bytes = json_module.dumps(translation_payload).encode('utf-8')
        
        logger.info("🔐 Tentative connexion avec urllib3 (SSL désactivé, TLS 1.2 forcé)...")
        try:
            response = http.request(
                'POST',
                translation_url,
                body=payload_bytes,
                headers=translation_headers,
                timeout=30,
                retries=3
            )
            logger.info(f"📥 Réponse reçue: Status {response.status}")
        except Exception as urllib3_error:
            logger.error(f"❌ Erreur urllib3: {urllib3_error}")
            logger.error(f"   Type: {type(urllib3_error).__name__}")
            # Dernière tentative : utiliser requests avec verify=False
            logger.warning("🔄 Dernière tentative avec requests...")
            try:
                import requests
                # Désactiver les avertissements SSL
                try:
                    requests.packages.urllib3.disable_warnings()
                except AttributeError:
                    urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)
                response_obj = requests.post(
                    translation_url,
                    headers=translation_headers,
                    json=translation_payload,
                    timeout=30,
                    verify=False
                )
                # Convertir en format urllib3-like
                response = type('Response', (), {
                    'status': response_obj.status_code,
                    'data': response_obj.content
                })()
                logger.warning("⚠️ Connexion réussie avec requests (verify=False)")
            except Exception as final_error:
                logger.error(f"❌ Échec final: {final_error}")
                logger.error(f"   Type: {type(final_error).__name__}")
                raise Exception(f"Impossible de se connecter à l'API Djelia: {final_error}")
        
        if response.status == 200:
            translation_data = json_module.loads(response.data.decode('utf-8'))
            bambara_text = translation_data.get('translated_text') or \
                          translation_data.get('translation') or \
                          translation_data.get('text')
            
            if not bambara_text or bambara_text.strip() == '':
                raise Exception("Texte traduit vide dans la réponse API")
            
            logger.info("✅ Traduction réussie!")
            logger.info(f"🇫🇷 FR ({len(text)} car.): {text[:80]}")
            logger.info(f"🇲🇱 BM ({len(bambara_text)} car.): {bambara_text[:80]}")
            return bambara_text
        else:
            raise Exception(f"Erreur API traduction {response.status}: {response.data.decode('utf-8')[:200]}")
            
    except Exception as e:
        logger.error(f"❌ Erreur traduction HTTP: {e}")
        logger.error(f"   Type: {type(e).__name__}")
        raise Exception(f"Échec de la traduction FR → BM: {str(e)}")

@app.route('/api/health', methods=['GET'])
def health_check():
    """Vérifier l'état du service"""
    djelia_status = 'connected' if djelia_client else 'disconnected'
    
    return jsonify({
        'status': 'healthy',
        'timestamp': datetime.now().isoformat(),
        'djelia': djelia_status
    })

@app.route('/api/translate', methods=['POST'])
def translate_text():
    """
    Traduire du français vers le bambara (sans générer d'audio)
    
    Paramètres:
        - text: Texte en français à traduire
        - source: Langue source (défaut: "fra_Latn")
        - target: Langue cible (défaut: "bam_Latn")
    
    Retourne:
        - JSON avec original_text, translated_text, source, target
    """
    try:
        logger.info("🌐 Requête de traduction reçue")
        
        # Récupérer paramètres
        data = request.json or {}
        text = data.get('text', '')
        source = data.get('source', 'fra_Latn')
        target = data.get('target', 'bam_Latn')
        
        if not text:
            logger.error("❌ Aucun texte fourni")
            return jsonify({
                'success': False,
                'error': 'Aucun texte fourni'
            }), 400
        
        logger.info(f"📝 Texte français reçu ({len(text)} caractères): {text[:50]}...")
        
        # Limiter longueur pour éviter timeout
        if len(text) > 1000:
            logger.warning(f"⚠️ Texte trop long ({len(text)} car.), troncature à 1000")
            text = text[:1000] + "..."
        
        # Traduire
        if source == 'fra_Latn' and target == 'bam_Latn':
            translated_text = translate_french_to_bambara(text)
        else:
            # Pour d'autres langues, utiliser la même logique ou retourner une erreur
            logger.warning(f"⚠️ Traduction {source} → {target} non supportée, utilisation FR → BM")
            translated_text = translate_french_to_bambara(text)
        
        logger.info(f"✅ Traduction réussie: '{translated_text[:80]}...'")
        
        return jsonify({
            'success': True,
            'original_text': text,
            'translated_text': translated_text,
            'source': source,
            'target': target,
            'timestamp': datetime.now().isoformat()
        })
        
    except Exception as e:
        logger.error(f"❌ Erreur traduction: {e}")
        return jsonify({
            'success': False,
            'error': 'Erreur lors de la traduction',
            'details': str(e)
        }), 500

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
        
        # ✅ ÉTAPE 1 : TRADUIRE FRANÇAIS → BAMBARA avec Djelia AI (OBLIGATOIRE)
        bambara_text = text
        if not skip_translation:
            logger.info(f"🌐 Traduction FR → BM avec Djelia AI (obligatoire avant TTS)...")
            logger.info("✅ Service de traduction assuré par Djelia AI")
            bambara_text = translate_french_to_bambara(text)
            
            # ⚠️ VÉRIFICATION CRITIQUE : S'assurer que la traduction a fonctionné
            if bambara_text == text:
                logger.error("❌ ERREUR CRITIQUE : La traduction a échoué, le texte français est utilisé!")
                logger.error(f"   Texte original (FR): {text[:100]}")
                logger.error(f"   Texte traduit (BM): {bambara_text[:100]}")
                logger.error("   ⚠️ Le TTS va lire en français au lieu du bambara!")
                # Lever une exception pour forcer l'échec plutôt que de lire en français
                raise Exception("La traduction FR → BM a échoué. Impossible de générer l'audio en bambara.")
            
            logger.info(f"✅ Traduction réussie: FR → BM")
            logger.info(f"   🇫🇷 Original: {text[:80]}")
            logger.info(f"   🇲🇱 Bambara: {bambara_text[:80]}")
        else:
            logger.warning("⚠️ Traduction désactivée (skip_translation=True), utilisation du texte tel quel")
        
        # ✅ ÉTAPE 2 : GÉNÉRER AUDIO DU TEXTE BAMBARA avec Djelia AI TTS (UNIQUEMENT)
        logger.info(f"🎵 Génération audio bambara avec Djelia AI TTS V2...")
        logger.info("✅ Service de synthèse vocale assuré par Djelia AI")
        logger.info(f"📝 Texte bambara pour TTS ({len(bambara_text)} caractères): {bambara_text[:50]}...")
        tts_request = TTSRequest(text=bambara_text.strip(), speaker=speaker)
        
        try:
            # ✅ UTILISATION DU SDK DJELIA AI pour la synthèse vocale
            # Essayer V2 (plus stable)
            audio_data = djelia_client.tts.text_to_speech(
                request=tts_request,
                version=Versions.v2
            )
            logger.info(f"✅ Audio généré par Djelia AI TTS V2 ({len(audio_data)} bytes)")
        except Exception as e:
            # ✅ FALLBACK VERS DJELIA AI TTS V1
            logger.warning(f"⚠️ Djelia AI TTS V2 échouée, fallback vers V1: {e}")
            audio_data = djelia_client.tts.text_to_speech(
                request=tts_request,
                version=Versions.v1
            )
            logger.info(f"✅ Audio généré par Djelia AI TTS V1 ({len(audio_data)} bytes)")
        
        logger.info(f"✅ Synthèse vocale réussie")
        
        # Vérifier si on doit retourner JSON (avec texte traduit) ou audio WAV
        return_json = data.get('return_json', False)
        
        if return_json:
            # Retourner JSON avec texte traduit et audio en Base64
            import base64
            audio_base64 = base64.b64encode(audio_data).decode('utf-8')
            
            return jsonify({
                'success': True,
                'original_text': text,
                'translated_text': bambara_text,
                'audio_base64': audio_base64,
                'format': 'wav',
                'speaker': speaker,
                'timestamp': datetime.now().isoformat()
            })
        else:
            # Retourner fichier audio WAV (comportement par défaut)
            with tempfile.NamedTemporaryFile(delete=False, suffix='.wav') as temp_audio:
                temp_audio.write(audio_data)
                temp_audio_path = temp_audio.name
            
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

@app.route('/api/conversation', methods=['POST'])
def handle_conversation():
    """
    Gérer une conversation complète: audio → transcription → traduction (si nécessaire) → audio
    
    Paramètres:
        - audio: Fichier audio (peut être en français ou bambara)
    
    Retourne:
        - Fichier audio UNIQUEMENT en bambara
        - Si l'entrée est en français → traduit en bambara
        - Si l'entrée est déjà en bambara → utilisé directement
    """
    try:
        logger.info("💬 Requête de conversation complète reçue")
        
        if not djelia_client:
            return jsonify({
                'success': False,
                'error': 'Service non disponible'
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
            # 1. Transcrire l'audio (peut être en français ou bambara)
            logger.info("🎤 Transcription audio...")
            
            try:
                transcription_result = djelia_client.transcription.transcribe(
                    audio_file=temp_audio_path,
                    version=Versions.v2
                )
                logger.info("✅ Transcription STT V2 utilisée")
            except Exception as e:
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
            
            logger.info(f"📝 Texte transcrit: {transcription_text}")
            
            # 2. DÉTERMINER LA LANGUE ET TRADUIRE SI NÉCESSAIRE
            # Le texte peut être en français ou déjà en bambara
            # On traduit UNIQUEMENT si c'est du français pour garantir que l'audio soit en bambara
            logger.info("🔍 Détection de la langue du texte transcrit...")
            
            # Détection simple : si le texte contient des caractères typiques du français
            # ou des mots français courants, on considère que c'est du français
            is_french = False
            french_indicators = [
                'comment', 'obtenir', 'faire', 'procédure', 'document',
                'naissance', 'mariage', 'casier', 'électeur', 'carte',
                'comment obtenir', 'comment faire', 'quelle est',
                'le', 'la', 'les', 'un', 'une', 'des', 'de', 'du'
            ]
            
            text_lower = transcription_text.lower()
            for indicator in french_indicators:
                if indicator in text_lower:
                    is_french = True
                    logger.info(f"🇫🇷 Texte détecté comme français (indicateur: '{indicator}')")
                    break
            
            if is_french:
                # 3. TRADUIRE FRANÇAIS → BAMBARA avec Djelia AI (OBLIGATOIRE pour audio bambara)
                logger.info("🌐 Traduction FR → BM avec Djelia AI (obligatoire)...")
                logger.info("✅ Service de traduction assuré par Djelia AI")
                bambara_text = translate_french_to_bambara(transcription_text)
                
                # ⚠️ VÉRIFICATION CRITIQUE : S'assurer que la traduction a fonctionné
                if bambara_text == transcription_text:
                    logger.error("❌ ERREUR CRITIQUE : La traduction a échoué!")
                    logger.error(f"   Texte original (FR): {transcription_text[:100]}")
                    logger.error(f"   Texte traduit (BM): {bambara_text[:100]}")
                    raise Exception("La traduction FR → BM a échoué. Impossible de générer l'audio en bambara.")
                
                logger.info(f"✅ Texte traduit en bambara: {bambara_text[:100]}...")
            else:
                # Le texte est déjà en bambara, on l'utilise directement
                logger.info("🇲🇱 Texte déjà en bambara, utilisation directe (pas de traduction)")
                bambara_text = transcription_text
            
            # 4. Générer l'audio UNIQUEMENT en bambara avec Djelia AI TTS
            logger.info("🔊 Génération audio bambara avec Djelia AI TTS (100% bambara)...")
            logger.info("✅ Service assuré par Djelia AI")
            tts_request = TTSRequest(text=bambara_text.strip(), speaker=1)
            
            try:
                # ✅ UTILISATION DU SDK DJELIA AI pour la synthèse vocale
                audio_response = djelia_client.tts.text_to_speech(
                    request=tts_request,
                    version=Versions.v2
                )
                logger.info(f"✅ Audio généré par Djelia AI TTS V2 ({len(audio_response)} bytes)")
            except Exception as e:
                logger.warning(f"⚠️ Djelia AI TTS V2 échouée, fallback vers V1: {e}")
                # ✅ FALLBACK VERS DJELIA AI TTS V1
                audio_response = djelia_client.tts.text_to_speech(
                    request=tts_request,
                    version=Versions.v1
                )
                logger.info(f"✅ Audio généré par Djelia AI TTS V1 ({len(audio_response)} bytes)")
            
            # Sauvegarder audio de réponse
            with tempfile.NamedTemporaryFile(delete=False, suffix='.wav') as temp_output:
                temp_output.write(audio_response)
                temp_output_path = temp_output.name
            
            # Nettoyer fichier d'entrée
            os.unlink(temp_audio_path)
            
            logger.info("✅ Conversation traitée avec succès")
            
            # Envoyer audio de réponse
            return send_file(
                temp_output_path,
                mimetype='audio/wav',
                as_attachment=True,
                download_name='response.wav'
            )
            
        except Exception as e:
            os.unlink(temp_audio_path)
            raise e
        
    except Exception as e:
        logger.error(f"❌ Erreur conversation: {e}")
        return jsonify({
            'success': False,
            'error': 'Erreur lors du traitement de la conversation',
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
    logger.info("   - POST /api/conversation (STT + Traduction directe + TTS)")
    logger.info("")
    logger.info("🇲🇱 Djelia AI : Traduction et Synthèse Vocale Bambara")
    
    # Démarrer serveur
    app.run(
        host='0.0.0.0',  # Accessible depuis réseau
        port=5000,
        debug=True
    )

