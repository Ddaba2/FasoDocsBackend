# 🤖 Djelia AI - Guide Complet FasoDocs

## 📋 Table des Matières

1. [Introduction](#introduction)
2. [Installation](#installation)
3. [Démarrage](#démarrage)
4. [Fonctionnalités](#fonctionnalités)
5. [Endpoints API](#endpoints-api)
6. [Configuration](#configuration)
7. [Intégration](#intégration)
8. [Tests](#tests)
9. [Troubleshooting](#troubleshooting)

---

## 📖 Introduction

### Qu'est-ce que Djelia AI ?

Djelia AI est un backend Python (Flask) qui fournit des services d'IA pour FasoDocs :

- ✅ **STT (Speech-to-Text)** : Transcription bambara depuis audio
- ✅ **TTS (Text-to-Speech)** : Synthèse vocale en bambara
- ✅ **Translation** : Traduction FR↔BM
- ✅ **Chat** : Conversation intelligente avec détection d'intention

### Architecture

```
Frontend Flutter/Angular
       ↓ HTTP
   Spring Boot (Port 8080)
       ↓ HTTP
 Djelia AI Python (Port 5000)
       ↓ API REST
  Djelia Cloud API
```

---

## 📦 Installation

### Prérequis

- Python 3.8+
- pip (gestionnaire de paquets Python)

### Installation Automatique

```bash
cd ../Djelia-AI-Backend
pip install -r requirements.txt
```

### Installation Manuelle

```bash
pip install Flask==3.0.0
pip install flask-cors==4.0.0
pip install djelia
pip install python-dotenv==1.0.0
```

### Vérification

```bash
python -c "from flask import Flask; from flask_cors import CORS; from djelia import Djelia; print('✅ Toutes les dépendances sont installées')"
```

---

## 🚀 Démarrage

### Option 1 : Automatique (Recommandée)

Un seul script démarre Djelia AI + FasoDocs Spring Boot :

```bash
.\start.bat
```

Le script :
1. ✅ Démarrera Djelia AI sur port 5000
2. ✅ Attendra 5 secondes
3. ✅ Vérifiera la connectivité
4. ✅ Démarrera Spring Boot sur port 8080

---

### Option 2 : Manuel

**Terminal 1 - Djelia AI :**
```bash
cd ../Djelia-AI-Backend
python app.py
```

**Terminal 2 - FasoDocs Spring Boot :**
```bash
.\mvnw spring-boot:run
```

---

### Vérification

**Test Djelia AI :**
```powershell
Invoke-WebRequest -Uri http://localhost:5000/health
```

**Réponse attendue :**
```json
{
  "status": "healthy",
  "timestamp": "2025-01-26T...",
  "djelia": "connected"
}
```

**Test Spring Boot :**
```powershell
Invoke-WebRequest -Uri http://localhost:8080/api/chatbot/health
```

**Réponse attendue :**
```json
{
  "status": "OK",
  "djelia_available": true
}
```

---

## 🎯 Fonctionnalités

### 1. Transcription Bambara (STT)

Transcrit l'audio en texte bambara.

**Endpoint :** `POST /api/transcribe`

**Exemple :**
```bash
curl -X POST http://localhost:5000/api/transcribe \
  -F "audio=@recording.wav"
```

**Réponse :**
```json
{
  "success": true,
  "text": "I ni sogoma",
  "language": "bambara",
  "confidence": 0.95
}
```

---

### 2. Synthèse Vocale Bambara (TTS)

Génère un fichier audio à partir de texte bambara.

**Endpoint :** `POST /api/speak`

**Exemple :**
```bash
curl -X POST http://localhost:5000/api/speak \
  -H "Content-Type: application/json" \
  -d '{"text":"I ni sogoma","speaker":1}' \
  --output response.wav
```

**Réponse :** Fichier audio WAV

---

### 3. Conversation Complète

Pipeline complet : Audio → Transcription → Intention → Réponse Audio

**Endpoint :** `POST /api/conversation`

**Exemple :**
```bash
curl -X POST http://localhost:5000/api/conversation \
  -F "audio=@question.wav" \
  --output response.wav
```

**Flow :**
1. Transcrire audio bambara (STT V2)
2. Détecter intention (naissance, mariage, casier, électeur)
3. Sélectionner réponse bambara appropriée
4. Générer audio de réponse (TTS V2)

---

### 4. Traduction

Traduit du texte entre français et bambara.

**Endpoint :** `POST /translate`

**Exemple :**
```bash
curl -X POST http://localhost:5000/translate \
  -H "Content-Type: application/json" \
  -d '{"text":"Bonjour","source_lang":"fr","target_lang":"bm"}'
```

**Réponse :**
```json
{
  "translation": "I ni sogoma",
  "source_lang": "fr",
  "target_lang": "bm"
}
```

---

## 📡 Endpoints API

### Backend Djelia AI (Port 5000)

| Endpoint | Méthode | Description |
|----------|---------|-------------|
| `/` | GET | Accueil API |
| `/health` | GET | Santé backend |
| `/translate` | POST | Traduction FR↔BM |
| `/api/transcribe` | POST | STT bambara |
| `/api/speak` | POST | TTS bambara |
| `/api/conversation` | POST | Pipeline complet |

### FasoDocs Spring Boot (Port 8080)

| Endpoint | Méthode | Description |
|----------|---------|-------------|
| `/api/chatbot/health` | GET | Santé chatbot |
| `/api/chatbot/translate` | POST | Traduction via backend |
| `/api/chatbot/speak` | POST | Synthèse vocale via backend |

---

## ⚙️ Configuration

### Fichier : `../Djelia-AI-Backend/app.py`

**API Key Djelia :**
```python
DJELIA_API_KEY = "83c313b9-aeba-441b-8b7f-a194720ad1d3"
```

**Port :**
```python
app.run(host='0.0.0.0', port=5000, debug=True)
```

### Fichier : `src/main/resources/application.properties`

**URL Backend Djelia :**
```properties
djelia.backend.url=http://localhost:5000
djelia.api.key=83c313b9-aeba-441b-8b7f-a194720ad1d3
```

---

## 🔗 Intégration Spring Boot

### Service : `DjeliaIntegrationService.java`

Le service Spring Boot appelle les endpoints Djelia AI :

- **Traduction :** `/translate`
- **Synthèse vocale :** `/api/speak`
- **Chat :** `/chat`
- **Health check :** `/health`

**Fichier :** `src/main/java/ml/fasodocs/backend/service/DjeliaIntegrationService.java`

---

## 🧪 Tests

### Test 1 : Health Check
```bash
curl http://localhost:5000/health
```

### Test 2 : Traduction
```bash
curl -X POST http://localhost:5000/translate \
  -H "Content-Type: application/json" \
  -d "{\"text\":\"Bonjour\",\"source_lang\":\"fr\",\"target_lang\":\"bm\"}"
```

### Test 3 : Synthèse Vocale
```bash
curl -X POST http://localhost:5000/api/speak \
  -H "Content-Type: application/json" \
  -d "{\"text\":\"I ni sogoma\",\"speaker\":1}" \
  --output test.wav
```

### Test 4 : Spring Boot Integration
```bash
curl http://localhost:8080/api/chatbot/health
```

---

## 🐛 Troubleshooting

### Erreur : "Client Djelia non initialisé"

**Cause :** SDK Djelia non installé

**Solution :**
```bash
pip install djelia
```

---

### Erreur : "Port 5000 already in use"

**Cause :** Port déjà utilisé

**Solution :**
```powershell
# Trouver le processus
netstat -ano | findstr :5000

# Tuer le processus (remplacer <PID>)
taskkill /F /PID <PID>
```

---

### Erreur : "Backend Djelia non connecté"

**Cause :** Djelia AI n'est pas démarré

**Solution :**
1. Vérifier que Djelia AI est démarré : `curl http://localhost:5000/health`
2. Attendre 10 secondes et redémarrer Spring Boot

---

### Erreur : "Module 'djelia' not found"

**Cause :** SDK Djelia non installé

**Solution :**
```bash
pip install djelia
```

---

## 📊 Performance

- **STT** : ~1-2 secondes
- **TTS** : ~2-5 secondes (selon longueur)
- **Conversation complète** : ~3-7 secondes total

---

## 🎯 Détection d'Intention

Djelia AI détecte automatiquement l'intention de l'utilisateur :

- **naissance** : Extrait de naissance
- **mariage** : Acte de mariage
- **casier** : Casier judiciaire
- **electeur** : Carte d'électeur
- **bienvenue** : Salutation
- **incompris** : Réponse par défaut

---

## 📝 Réponses en Bambara

Djelia AI fournit des réponses pré-écrites en bambara pour chaque type de document :

- ✅ **Acte de naissance** : Procédure complète en bambara
- ✅ **Acte de mariage** : Procédure complète en bambara
- ✅ **Casier judiciaire** : Procédure complète en bambara
- ✅ **Carte d'électeur** : Procédure complète en bambara

---

## 🎉 Résumé

### Status : ✅ PRÊT À L'EMPLOI

**Backend :**
- ✅ SDK Djelia installé
- ✅ Flask, flask-cors, python-dotenv installés
- ✅ Syntaxe Python valide

**Démarrage :**
```bash
.\start.bat  # Automatique
# OU
python app.py  # Manuel (dans Djelia-AI-Backend)
```

**Fonctionnalités :**
- ✅ STT bambara
- ✅ TTS bambara
- ✅ Traduction FR↔BM
- ✅ Chat conversationnel
- ✅ Détection intention

---

**Date :** 2025-01-26  
**Version :** 1.0.0  
**Status :** ✅ OPÉRATIONNEL

