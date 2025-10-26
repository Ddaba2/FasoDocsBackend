# 🚀 Guide de Démarrage Complet - FasoDocs + Djelia AI

## ✅ Backend Djelia AI Créé !

J'ai créé le backend Djelia AI dans : `../Djelia-AI-Backend`

---

## 📦 Installation et Démarrage

### Étape 1 : Installer les Dépendances Python

```bash
# Aller dans le dossier Djelia-AI-Backend
cd ..\Djelia-AI-Backend

# Installer les dépendances
python -m pip install flask flask-cors

# OU utiliser le script
install.bat
```

### Étape 2 : Démarrer Djelia AI

#### Terminal 1 : Djelia AI

```bash
cd ..\Djelia-AI-Backend

# Démarrage
python app.py

# OU utiliser le script
demarrer.bat
```

**Logs attendus** :
```
🚀 Démmarrage Djelia AI Backend sur http://localhost:5000
* Running on http://127.0.0.1:5000
* Running on http://[::]:5000
Press CTRL+C to quit
```

**Important** : Laissez ce terminal ouvert.

---

### Étape 3 : Démarrer FasoDocs Backend

#### Terminal 2 : FasoDocs Backend

```bash
cd Api_fasodocs

# Démarrage
mvn spring-boot:run
```

**Logs attendus** :
```
🔍 Vérification de la connectivité avec Djelia AI...
✅ Djelia AI est accessible et fonctionnel
   → Traduction FR↔BM : Disponible
   → Synthèse vocale : Disponible
   → Chat : Disponible
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

   FasoDocs Backend démarré avec succès!
   API Documentation: http://localhost:8080/api/swagger-ui.html
```

---

## ✅ Vérification

### Test 1 : Djelia AI

```bash
curl http://localhost:5000/health

# Réponse attendue
{"status": "OK", "service": "Djelia AI"}
```

### Test 2 : FasoDocs via Djelia

```bash
curl http://localhost:8080/api/chatbot/health

# Réponse attendue
{"status": "OK", "message": "Djelia AI est accessible"}
```

### Test 3 : Traduction (Icône Micro)

```bash
curl -X POST http://localhost:8080/api/chatbot/read-quick \
  -H "Content-Type: application/json" \
  -d "Bonjour"

# Réponse attendue
{
  "success": true,
  "audioUrl": "http://localhost:5000/audio/...",
  "originalText": "Bonjour",
  "translatedText": "..."
}
```

---

## 📋 Fichiers Créés

### Backend Djelia AI

```
Djelia-AI-Backend/
├── app.py                    ← Application Flask
├── requirements.txt          ← Dépendances Python
├── README.md                 ← Documentation
├── install.bat              ← Script installation Windows
└── demarrer.bat             ← Script démarrage Windows
```

### FasoDocs Backend

```
Api_fasodocs/
├── src/                     ← Votre code
├── start.bat                ← Démarrage automatique
├── start.sh                 ← Démarrage automatique Linux
└── GUIDE_DEMARRAGE_COMPLET.md ← Ce fichier
```

---

## 🎯 Ordre de Démarrage RAPIDE

### Option Simple (2 Terminaux)

**Terminal 1** :
```bash
cd ..\Djelia-AI-Backend
python app.py
```

**Terminal 2** :
```bash
cd Api_fasodocs
mvn spring-boot:run
```

---

## 🎉 Votre Application est PRÊTE !

### Endpoints Disponibles

#### Chatbot / Djelia AI
```
POST /api/chatbot/read-quick    ← Icône micro (FR→BM+Audio)
POST /api/chatbot/chat          ← Chat conversationnel
POST /api/chatbot/translate    ← Traduction
POST /api/chatbot/speak         ← Synthèse vocale
GET  /api/chatbot/health        ← Vérification
```

#### Autres
```
GET  /api/procedures            ← Toutes les procédures
GET  /api/categories            ← Toutes les catégories
POST /api/auth/inscription      ← Inscription
POST /api/auth/connexion-telephone ← Connexion SMS
```

---

## ✅ Tout est Configuré !

**FasoDocs Backend** : Port 8080 ✅
**Djelia AI Backend** : Port 5000 ✅
**Configuration CORS** : Émulateur Android autorisé ✅
**StackOverflowError** : Corrigé ✅
**Documentation** : Complète ✅

---

**Démarrez simplement** :
1. Terminal 1 : `python app.py` dans `../Djelia-AI-Backend`
2. Terminal 2 : `mvn spring-boot:run` dans `Api_fasodocs`

🎉 **L'application FasoDocs est prête !**

