# 🎤 Guide d'Intégration - Djelia AI

**Assistant Vocal Bambara pour FasoDocs**

---

## 📋 Table des Matières

- [Vue d'Ensemble](#vue-densemble)
- [Architecture](#architecture)
- [Fichiers Impliqués](#fichiers-impliqués)
- [Configuration](#configuration)
- [Intégration Frontend](#intégration-frontend)
- [Flux de Données](#flux-de-données)
- [Troubleshooting](#troubleshooting)

---

## 🎯 Vue d'Ensemble

Djelia AI permet aux utilisateurs maliens d'écouter les procédures administratives en **bambara** (langue locale).

### Fonctionnalités

- ✅ **Traduction** Français → Bambara
- ✅ **Synthèse Vocale (TTS)** en bambara
- ✅ **Reconnaissance Vocale (STT)** bambara (optionnel)
- ✅ **Cache** pour performances optimales
- ✅ **Voix claire et naturelle**

---

## 🏗️ Architecture

### Architecture Hybride

```
┌──────────────────┐
│  Flutter Mobile  │
│  (Port Variable) │
└────────┬─────────┘
         │ POST /api/chatbot/read-quick
         │ {"text": "Procédure...", ...}
         ↓
┌─────────────────────────────────────────┐
│      Spring Boot Backend                │
│         (Port 8080)                     │
│                                         │
│  • ChatbotController.java               │
│  • DjeliaAIService.java                 │
│  • Validation & Logging                 │
└────────┬────────────────────────────────┘
         │ POST /api/speak
         │ {"text": "Procédure...", "speaker": 1}
         ↓
┌─────────────────────────────────────────┐
│    Flask Backend Python                 │
│         (Port 5000)                     │
│                                         │
│  • backend_djelia.py                    │
│  • SDK Djelia Python                    │
│  • Traduction FR→BM (API HTTP)          │
│  • TTS Bambara (SDK Djelia)             │
└────────┬────────────────────────────────┘
         │ HTTPS API calls
         ↓
┌─────────────────────────────────────────┐
│       API Djelia Cloud                  │
│  https://api.djelia.cloud               │
│                                         │
│  • /v1/translation (Traduction)         │
│  • TTS API (Synthèse Vocale)            │
│  • STT API (Reconnaissance Vocale)      │
└─────────────────────────────────────────┘
```

### Pourquoi cette Architecture ?

| Raison | Explication |
|--------|-------------|
| **SDK Python** | Djelia fournit un SDK Python officiel (pas de SDK Java) |
| **Séparation** | Spring Boot = Logique métier, Flask = IA/Traduction |
| **Scalabilité** | Flask peut être déployé séparément |
| **Fiabilité** | SDK Python maintenu par Djelia |

---

## 📁 Fichiers Impliqués

### Backend Spring Boot

#### 1. **ChatbotController.java**
**Emplacement** : `src/main/java/ml/fasodocs/backend/controller/ChatbotController.java`

**Rôle** : Point d'entrée API pour les requêtes Djelia

**Endpoints** :
```java
@PostMapping("/chatbot/read-quick")
public ResponseEntity<TranslateAndSpeakResponse> readQuick(@RequestBody TranslateAndSpeakRequest request)
```

**Fonction** :
- Reçoit les requêtes du frontend
- Valide les paramètres (`@Valid`)
- Délègue à `DjeliaAIService`
- Retourne JSON avec traduction + audio Base64

---

#### 2. **DjeliaAIService.java**
**Emplacement** : `src/main/java/ml/fasodocs/backend/service/DjeliaAIService.java`

**Rôle** : Proxy intelligent vers Flask

**Méthodes Principales** :

```java
// Traduction + Synthèse vocale combinées
public TranslateAndSpeakResponse translateAndSpeak(TranslateAndSpeakRequest request)

// Appel Flask TTS
private byte[] callFlaskTTS(String text)

// Statistiques du cache
public DjeliaCacheStatsResponse getCacheStats()
```

**Fonction** :
- Appelle Flask `/api/speak`
- Encode l'audio en Base64
- Gère le cache (mémoire)
- Gère les erreurs et timeouts

---

#### 3. **TranslateAndSpeakRequest.java**
**Emplacement** : `src/main/java/ml/fasodocs/backend/dto/request/TranslateAndSpeakRequest.java`

**Rôle** : DTO pour les requêtes

**Structure** :
```java
public class TranslateAndSpeakRequest {
    @NotBlank(message = "Le texte ne peut pas être vide")
    private String text;              // Texte français à traduire
    
    private String voiceDescription;  // Description de la voix
    private Double chunkSize;         // Taille des chunks
}
```

---

#### 4. **TranslateAndSpeakResponse.java**
**Emplacement** : `src/main/java/ml/fasodocs/backend/dto/response/TranslateAndSpeakResponse.java`

**Rôle** : DTO pour les réponses

**Structure** :
```java
public class TranslateAndSpeakResponse {
    private String originalText;      // Texte français original
    private String translatedText;    // Texte bambara traduit
    private String audioBase64;       // Audio WAV encodé en Base64
    private String format;            // Format audio (wav)
    private Boolean fromCache;        // Depuis cache ou généré
    private String voiceDescription;  // Description voix
    private LocalDateTime timestamp;  // Horodatage
}
```

---

#### 5. **ProcedureService.java**
**Emplacement** : `src/main/java/ml/fasodocs/backend/service/ProcedureService.java`

**Modification** : Ligne 258

```java
// ✅ Ne jamais renvoyer null - utiliser titre comme fallback
response.setDescription(
    procedure.getDescription() != null 
        ? procedure.getDescription() 
        : procedure.getTitre()
);
```

**Fonction** : Garantit que la description n'est jamais null (important pour Djelia)

---

### Backend Flask Python

#### 6. **backend_djelia.py**
**Emplacement** : Racine du projet

**Rôle** : Backend Python Flask avec SDK Djelia

**Structure** :
```python
# Imports
from flask import Flask, request, jsonify, send_file
from flask_cors import CORS
from djelia import Djelia
from djelia.models import Versions, TTSRequest
import requests  # Pour appel HTTP direct API Djelia

# Configuration
DJELIA_API_KEY = "votre_cle_api"
djelia_client = Djelia(api_key=DJELIA_API_KEY)

# Endpoints
@app.route('/api/health')           # Statut
@app.route('/api/speak')            # Traduction + TTS
@app.route('/api/transcribe')       # STT (optionnel)
```

**Endpoints** :

| Route | Méthode | Fonction |
|-------|---------|----------|
| `/api/health` | GET | Vérifier statut Djelia |
| `/api/speak` | POST | Traduction FR→BM + TTS |
| `/api/transcribe` | POST | STT Bambara |

**Fonction `/api/speak`** :

```python
def generate_speech():
    # 1. Recevoir texte français
    text = request.json.get('text')
    
    # 2. TRADUIRE FR → BM (Appel HTTP direct)
    translation_response = requests.post(
        "https://api.djelia.cloud/v1/translation",
        headers={"Authorization": f"Bearer {DJELIA_API_KEY}"},
        json={"text": text, "source": "fra_Latn", "target": "bam_Latn"}
    )
    bambara_text = translation_response.json()['translated_text']
    
    # 3. GÉNÉRER AUDIO (SDK Djelia)
    tts_request = TTSRequest(text=bambara_text, speaker=1)
    audio_data = djelia_client.tts.text_to_speech(
        request=tts_request,
        version=Versions.v2
    )
    
    # 4. Retourner audio WAV
    return send_file(audio_data, mimetype='audio/wav')
```

---

### Configuration

#### 7. **application.properties**
**Emplacement** : `src/main/resources/application.properties`

**Section Djelia** :
```properties
# Configuration Djelia AI
djelia.ai.enabled=true
djelia.ai.base.url=http://localhost:5000/api  # URL Flask
djelia.ai.timeout=60000                        # 60 secondes
djelia.ai.cache.enabled=true
djelia.ai.cache.duration=24h
```

**Fonction** :
- `djelia.ai.base.url` : URL du backend Flask
- `djelia.ai.timeout` : Timeout des requêtes (ms)
- `djelia.ai.cache.enabled` : Activer le cache

---

## 🔄 Flux de Données Complet

### Exemple : Lecture d'une Procédure

```
1. Utilisateur clique sur 🔊 dans Flutter

2. Flutter envoie :
   POST http://192.168.X.X:8080/api/chatbot/read-quick
   Headers: {"Content-Type": "application/json"}
   Body: {
     "text": "Obtenir un permis de conduire. L'obtention...",
     "voiceDescription": "Voix claire et naturelle",
     "chunkSize": 1.0
   }

3. Spring Boot (ChatbotController) reçoit :
   • Valide le request (@Valid)
   • Log la requête
   • Appelle DjeliaAIService.translateAndSpeak()

4. DjeliaAIService appelle Flask :
   POST http://localhost:5000/api/speak
   Body: {
     "text": "Obtenir un permis de conduire...",
     "speaker": 1
   }

5. Flask (backend_djelia.py) :
   a) TRADUCTION (appel HTTP direct) :
      POST https://api.djelia.cloud/v1/translation
      Body: {
        "text": "Obtenir un permis de conduire...",
        "source": "fra_Latn",
        "target": "bam_Latn"
      }
      Réponse: {"translated_text": "Ka bolitigifaga sɔrɔ..."}
   
   b) TTS (SDK Djelia) :
      tts_request = TTSRequest(text="Ka bolitigifaga sɔrɔ...", speaker=1)
      audio = djelia_client.tts.text_to_speech(request, version=Versions.v2)
      
   c) Retourne audio WAV (bytes)

6. DjeliaAIService encode :
   audioBase64 = Base64.encode(audio_bytes)

7. Spring Boot retourne à Flutter :
   {
     "originalText": "Obtenir un permis de conduire...",
     "translatedText": "Ka bolitigifaga sɔrɔ...",
     "audioBase64": "UklGRi4QAABXQVZF...",
     "format": "wav",
     "fromCache": false
   }

8. Flutter :
   • Décode Base64
   • Joue l'audio WAV
   • 🔊 L'utilisateur entend la procédure en BAMBARA
```

---

## 📱 Intégration Frontend Flutter

### Configuration

**Fichier** : `lib/services/djelia_service.dart`

```dart
class DjeliaService {
  // URL du backend Spring Boot
  static const String baseUrl = 'http://192.168.X.X:8080/api';
  
  Future<Map<String, dynamic>?> translateAndSpeak(String text) async {
    final response = await http.post(
      Uri.parse('$baseUrl/chatbot/read-quick'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'text': text,
        'voiceDescription': 'Voix claire et naturelle',
        'chunkSize': 1.0,
      }),
    ).timeout(Duration(seconds: 60));
    
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return null;
  }
}
```

### Utilisation dans un Widget

```dart
Future<void> _lireEnBambara() async {
  // Récupérer le texte de la procédure
  String texte = procedure.description ?? procedure.titre;
  
  // Limiter à 400 caractères pour éviter timeout
  if (texte.length > 400) {
    texte = texte.substring(0, 400) + "...";
  }
  
  // Appeler Djelia
  final result = await DjeliaService().translateAndSpeak(texte);
  
  if (result != null) {
    // Décoder et jouer l'audio
    final audioBase64 = result['audioBase64'];
    final bytes = base64Decode(audioBase64);
    await AudioPlayer().play(BytesSource(bytes));
  }
}
```

### Dépendances Flutter

```yaml
dependencies:
  http: ^1.1.0
  audioplayers: ^5.2.1
```

---

## ⚙️ Configuration

### 1. Configuration Spring Boot

**Fichier** : `src/main/resources/application.properties`

```properties
# Djelia AI
djelia.ai.enabled=true
djelia.ai.base.url=http://localhost:5000/api
djelia.ai.timeout=60000
djelia.ai.cache.enabled=true
djelia.ai.cache.duration=24h
```

### 2. Configuration Flask

**Fichier** : `backend_djelia.py` (ligne 26)

```python
# Clé API Djelia Cloud
DJELIA_API_KEY = "83c313b9-aeba-441b-8b7f-a194720ad1d3"
os.environ['DJELIA_API_KEY'] = DJELIA_API_KEY

# Initialiser client
djelia_client = Djelia(api_key=DJELIA_API_KEY)
```

### 3. Obtenir une Clé API Djelia

1. Créer un compte sur https://djelia.cloud
2. Générer une clé API
3. Copier la clé dans `backend_djelia.py`

---

## 📁 Fichiers Impliqués (Détails)

### Spring Boot Java

| Fichier | Emplacement | Fonction |
|---------|-------------|----------|
| **ChatbotController** | `controller/ChatbotController.java` | Endpoint REST `/chatbot/read-quick` |
| **DjeliaAIController** | `controller/DjeliaAIController.java` | Endpoints `/djelia/*` (alternatifs) |
| **DjeliaAIService** | `service/DjeliaAIService.java` | Logique métier, appels Flask, cache |
| **TranslateAndSpeakRequest** | `dto/request/TranslateAndSpeakRequest.java` | DTO requête (validation) |
| **TranslateAndSpeakResponse** | `dto/response/TranslateAndSpeakResponse.java` | DTO réponse |
| **DjeliaAPIException** | `exception/DjeliaAPIException.java` | Exception personnalisée |
| **GlobalExceptionHandler** | `config/GlobalExceptionHandler.java` | Gestion erreurs Djelia |
| **ProcedureService** | `service/ProcedureService.java` | Fix description null → titre |

### Flask Python

| Fichier | Emplacement | Fonction |
|---------|-------------|----------|
| **backend_djelia.py** | Racine projet | Serveur Flask complet |

**Structure `backend_djelia.py`** :

```python
# Ligne 26-31 : Configuration Djelia
DJELIA_API_KEY = "..."
djelia_client = Djelia(api_key=DJELIA_API_KEY)

# Ligne 59-66 : Endpoint Health Check
@app.route('/api/health')

# Ligne 68-217 : Endpoint Principal TTS
@app.route('/api/speak')
def generate_speech():
    # Traduction FR→BM (HTTP direct)
    # TTS Bambara (SDK Djelia)
    # Retour audio WAV

# Ligne 218-284 : Endpoint STT (Optionnel)
@app.route('/api/transcribe')

# Ligne 329-344 : Démarrage serveur
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
```

### Configuration

| Fichier | Emplacement | Fonction |
|---------|-------------|----------|
| **application.properties** | `src/main/resources/application.properties` | Config Spring Boot (lignes 53-61) |

---

## 🔄 Flux Détaillé - Traduction + TTS

### Étape 1 : Flutter → Spring Boot

**Requête** :
```http
POST http://192.168.11.109:8080/api/chatbot/read-quick
Content-Type: application/json

{
  "text": "Obtenir un permis de conduire",
  "voiceDescription": "Voix claire et naturelle",
  "chunkSize": 1.0
}
```

**Code Java** :
```java
// ChatbotController.java:45
@PostMapping("/read-quick")
public ResponseEntity<TranslateAndSpeakResponse> readQuick(@Valid @RequestBody TranslateAndSpeakRequest request) {
    logger.info("🎤 Requête chatbot/read-quick REÇUE");
    logger.info("📝 Text: '{}'", request.getText());
    
    TranslateAndSpeakResponse response = djeliaService.translateAndSpeak(request);
    return ResponseEntity.ok(response);
}
```

---

### Étape 2 : Spring Boot → Flask

**Requête** :
```http
POST http://localhost:5000/api/speak
Content-Type: application/json

{
  "text": "Obtenir un permis de conduire",
  "speaker": 1
}
```

**Code Java** :
```java
// DjeliaAIService.java:314
private byte[] callFlaskTTS(String text) {
    HttpHeaders headers = new HttpHeaders();
    headers.setContentType(MediaType.APPLICATION_JSON);
    
    Map<String, Object> requestBody = Map.of("text", text, "speaker", 1);
    HttpEntity<Map<String, Object>> entity = new HttpEntity<>(requestBody, headers);
    
    String url = baseUrl + "/speak";  // http://localhost:5000/api/speak
    ResponseEntity<byte[]> response = restTemplate.exchange(url, HttpMethod.POST, entity, byte[].class);
    
    return response.getBody();  // Audio WAV bytes
}
```

---

### Étape 3 : Flask - Traduction

**Code Python** :
```python
# backend_djelia.py:117-165
# ÉTAPE 1 : TRADUIRE FR → BM
translation_url = "https://api.djelia.cloud/v1/translation"
translation_response = requests.post(
    translation_url,
    headers={"Authorization": f"Bearer {DJELIA_API_KEY}"},
    json={
        "text": "Obtenir un permis de conduire",
        "source": "fra_Latn",
        "target": "bam_Latn"
    },
    timeout=30
)

bambara_text = translation_response.json()['translated_text']
# Résultat : "Ka bolitigifaga sɔrɔ"
```

**Logs** :
```
🌐 Traduction FR → BM avec API Djelia (appel HTTP direct)...
📤 POST https://api.djelia.cloud/v1/translation
📥 Status: 200
✅ Traduction réussie!
🇫🇷 FR: Obtenir un permis de conduire
🇲🇱 BM: Ka bolitigifaga sɔrɔ
```

---

### Étape 4 : Flask - Synthèse Vocale

**Code Python** :
```python
# backend_djelia.py:167-186
# ÉTAPE 2 : GÉNÉRER AUDIO DU TEXTE BAMBARA
tts_request = TTSRequest(text=bambara_text.strip(), speaker=1)

audio_data = djelia_client.tts.text_to_speech(
    request=tts_request,
    version=Versions.v2  # Version 2 plus stable
)
# audio_data = bytes WAV
```

**Logs** :
```
🎵 Génération audio bambara avec Djelia TTS V2...
📝 Texte bambara pour TTS: Ka bolitigifaga sɔrɔ
✅ Audio bambara généré V2 (245678 bytes)
```

---

### Étape 5 : Flask → Spring Boot

**Réponse** :
```
Content-Type: audio/wav
Body: <bytes WAV>
```

**Code Java** :
```java
// DjeliaAIService.java:304-308
byte[] audioBytes = response.getBody();  // Audio WAV
logger.info("✅ Audio reçu de Flask: {} bytes", audioBytes.length);
return audioBytes;
```

---

### Étape 6 : Spring Boot - Encodage Base64

**Code Java** :
```java
// DjeliaAIService.java:291-301
byte[] audioBytes = callFlaskTTS(text);
String audioBase64 = Base64.getEncoder().encodeToString(audioBytes);

TranslateAndSpeakFlaskResponse response = new TranslateAndSpeakFlaskResponse();
response.setAudioBase64(audioBase64);
response.setTranslatedText("[Traduit en bambara]");
return response;
```

---

### Étape 7 : Spring Boot → Flutter

**Réponse** :
```json
{
  "originalText": "Obtenir un permis de conduire",
  "translatedText": "[Traduit en bambara]",
  "audioBase64": "UklGRi4QAABXQVZF...",
  "format": "wav",
  "fromCache": false,
  "voiceDescription": "Voix claire et naturelle",
  "timestamp": "2025-11-09T16:30:45"
}
```

---

### Étape 8 : Flutter - Lecture Audio

**Code Dart** :
```dart
// Décoder Base64
final bytes = base64Decode(result['audioBase64']);

// Jouer audio
await AudioPlayer().play(BytesSource(bytes));
```

**Résultat** : 🔊 L'utilisateur entend la procédure en **bambara**

---

## 🚀 Démarrage

### Terminal 1 : Flask (Djelia AI)

```bash
python backend_djelia.py
```

**Sortie attendue** :
```
✅ Client Djelia initialisé avec succès
🚀 Démarrage du serveur FasoDocs Backend Flask + Djelia AI
📡 Endpoints disponibles:
   - GET  /api/health
   - POST /api/speak (Traduction FR→BM + TTS)
🇲🇱 Djelia AI : Traduction et Synthèse Vocale Bambara
 * Running on http://0.0.0.0:5000
```

### Terminal 2 : Spring Boot

```bash
./mvnw spring-boot:run
```

**Sortie attendue** :
```
Started FasoDocsApplication in X seconds
Tomcat started on port(s): 8080 (http)
```

---

## 🧪 Tests

### Test 1 : Flask opérationnel

```bash
curl http://localhost:5000/api/health
```

**Attendu** :
```json
{
  "status": "healthy",
  "djelia": "connected"
}
```

### Test 2 : Spring Boot → Flask

```bash
curl -X POST http://localhost:8080/api/chatbot/read-quick \
  -H "Content-Type: application/json" \
  -d '{
    "text": "Bonjour test",
    "voiceDescription": "Voix claire",
    "chunkSize": 1.0
  }'
```

**Attendu** : JSON avec `audioBase64` rempli

### Test 3 : Depuis Flutter

1. Lance l'app Flutter
2. Affiche une procédure
3. Clique sur 🔊 (icône haut-parleur)
4. **Écoute** : Audio en bambara

---

## 🐛 Troubleshooting

### Erreur : Connection refused (Flask)

**Cause** : Backend Flask pas démarré  
**Solution** : `python backend_djelia.py`

### Erreur : Timeout après 60s

**Cause** : Texte trop long ou service Djelia lent  
**Solution** : Limiter le texte à 400 caractères max

### Erreur : 404 API Djelia

**Cause** : URL API Djelia incorrecte ou service hors ligne  
**Solution** : Vérifier `https://api.djelia.cloud/v1/translation`

### Erreur : Audio en français au lieu de bambara

**Cause** : Traduction échoue  
**Solution** : Vérifier logs Flask, voir section ci-dessous

---

## 📊 Logs à Surveiller

### Logs Flask (Bon Fonctionnement)

```
🔊 Requête de synthèse vocale reçue
📝 Texte français (136 car): Obtenir un permis de conduire...
🌐 Traduction FR → BM avec API Djelia...
📥 Status: 200
✅ Traduction réussie!
🇫🇷 FR: Obtenir un permis de conduire...
🇲🇱 BM: Ka bolitigifaga sɔrɔ...
🎵 Génération audio bambara...
✅ Audio bambara généré V2 (245678 bytes)
```

### Logs Flask (Problème de Traduction)

```
❌ API Traduction erreur 404
📄 Body: {"detail":"Not Found"}
⚠️ Utilisation du texte original sans traduction
```

**Action** : Vérifier clé API Djelia ou quota

---

## 📈 Performances

### Temps de Traitement Estimés

| Longueur Texte | Traduction | TTS | Total |
|----------------|------------|-----|-------|
| 100 caractères | ~2s | ~3s | **~5s** |
| 200 caractères | ~3s | ~6s | **~9s** |
| 300 caractères | ~5s | ~10s | **~15s** |
| 400 caractères | ~7s | ~15s | **~22s** |

**Recommandation** : Limiter le texte à **400 caractères** maximum

---

## 🔒 Sécurité

- ✅ **Endpoints publics** : Pas d'authentification requise
- ✅ **CORS** : Configuré pour Android/iOS/Web
- ✅ **Validation** : Champs obligatoires validés
- ✅ **Rate Limiting** : À implémenter si nécessaire
- ⚠️ **Clé API** : Ne pas commit dans Git (utiliser variables d'environnement)

---

## 🌍 Production

### Déploiement

1. **Flask** : Déployer sur serveur Python (Render, Railway, etc.)
2. **Spring Boot** : Déployer JAR sur serveur Java
3. **Configuration** :
   ```properties
   # Production
   djelia.ai.base.url=https://votre-flask.com/api
   ```

### Variables d'Environnement

```bash
export DJELIA_API_KEY=votre_cle_api
export FLASK_PORT=5000
```

---

## 📚 Ressources

- **API Djelia** : https://djelia.cloud
- **Documentation Djelia** : https://docs.djelia.cloud
- **SDK Python** : https://pypi.org/project/djelia/
- **Endpoints FasoDocs** : `TOUS_LES_ENDPOINTS_FASODOCS.md`

---

## 🎯 Points Clés

✅ **Architecture hybride** Spring Boot + Flask  
✅ **SDK Djelia Python** pour fiabilité  
✅ **Traduction automatique** FR → BM  
✅ **Audio bambara pur** avec voix claire  
✅ **Timeout optimisé** (60 secondes)  
✅ **Limite texte** (400 caractères)  

---

**© 2025 FasoDocs - Assistant Vocal Bambara** 🇲🇱🎤


