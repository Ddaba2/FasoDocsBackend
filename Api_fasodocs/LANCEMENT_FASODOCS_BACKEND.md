# 🚀 Lancer FasoDocs Backend avec Djelia AI Intégré

## ✅ Votre Configuration Actuelle

Djelia AI est **intégré** dans FasoDocs Backend via :
- **ChatbotController** (`/api/chatbot/*`)
- **DjeliaIntegrationService** (appelle Djelia AI sur port 5000)
- **ChatbotService** (logique métier)

---

## 🚀 Comment Lancer FasoDocs Backend

### Étape 1 : Démarrez Djelia AI d'abord (Requis)

**Ouvrir un Terminal** :

```bash
cd ../Djelia-AI-Backend
python app.py
```

**Logs attendus** :
```
* Running on http://127.0.0.1:5000
* Running on http://[::]:5000
Press CTRL+C to quit
```

**Important** : Laissez ce terminal ouvert. Djelia AI doit continuer à tourner.

---

### Étape 2 : Lancer FasoDocs Backend

**Ouvrir un Nouveau Terminal** :

```bash
cd Api_fasodocs
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
========================================
```

---

## 🎯 Vos Endpoints Disponibles

Une fois démarré, vous avez accès à :

### Chatbot / Djelia AI

```
POST http://localhost:8080/api/chatbot/read-quick
POST http://localhost:8080/api/chatbot/chat
POST http://localhost:8080/api/chatbot/translate
POST http://localhost:8080/api/chatbot/speak
GET  http://localhost:8080/api/chatbot/health
```

### Autres Endpoints

```
GET  http://localhost:8080/api/procedures
GET  http://localhost:8080/api/categories
GET  http://localhost:8080/api/auth/...
```

---

## ✅ Ordre de Démarrage

### 📌 IMPORTANT : Démarrer dans le bon ordre

```
1️⃣ D'abord : Djelia AI (port 5000)
   Terminal 1: cd ../Djelia-AI-Backend && python app.py

2️⃣ Ensuite : FasoDocs Backend (port 8080)
   Terminal 2: cd Api_fasodocs && mvn spring-boot:run
```

Si vous démarrez FasoDocs avant Djelia AI, vous verrez :
```
⚠️ Djelia AI n'est pas accessible
```

Mais l'application démarrera quand même. Les fonctionnalités chatbot ne fonctionneront pas tant que Djelia AI n'est pas démarré.

---

## 🧪 Test Rapide

### Test 1 : Vérifier Djelia AI
```bash
curl http://localhost:5000/health

# Réponse
{"status": "OK"}
```

### Test 2 : Vérifier FasoDocs
```bash
curl http://localhost:8080/api/chatbot/health

# Réponse
{"status": "OK", "message": "Djelia AI est accessible"}
```

### Test 3 : Test de Traduction
```bash
curl -X POST http://localhost:8080/api/chatbot/read-quick \
  -H "Content-Type: application/json" \
  -d "Bonjour"

# Réponse
{
  "success": true,
  "audioUrl": "http://localhost:5000/audio/...",
  "originalText": "Bonjour",
  "translatedText": "I ni ce"
}
```

---

## 📋 Résumé

### Configuration

```properties
# application.properties
djelia.backend.url=http://localhost:5000
djelia.api.key=83c313b9-aeba-441b-8b7f-a194720ad1d3
```

### Services Intégrés

1. ✅ **FasoDocs Backend** : Port 8080 (point d'entrée unique)
2. ✅ **Djelia AI** : Port 5000 (service interne appelé par FasoDocs)
3. ✅ **Health Checker** : Vérifie Djelia au démarrage
4. ✅ **Endpoints Chatbot** : `/api/chatbot/*`

### Pour Lancer

```bash
# Terminal 1
cd ../Djelia-AI-Backend
python app.py

# Terminal 2 (après 5 secondes)
cd Api_fasodocs
mvn spring-boot:run
```

---

**✅ FasoDocs Backend inclut déjà Djelia AI via le chatbot !**

Il suffit de démarrer le backend Flask Djelia séparément, FasoDocs s'en occupe automatiquement.

