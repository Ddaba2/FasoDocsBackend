# 🎯 Architecture Frontend ↔ Backend FasoDocs

## ✅ Votre Architecture est CORRECTE

### Vue d'Ensemble

```
┌─────────────────────────────────────────────┐
│            Frontend (Angular)               │
│          Port 4200 ou 3000                 │
│                                             │
│  Connaît UNIQUEMENT :                      │
│  → http://localhost:8080/api/              │
└────────────────────┬────────────────────────┘
                     │
                     │ HTTP Requests
                     ↓
┌─────────────────────────────────────────────┐
│       FasoDocs Backend (Spring Boot)       │
│              Port 8080                      │
│                                             │
│  Endpoints exposés :                       │
│  /api/auth/**                              │
│  /api/procedures/**                        │
│  /api/categories/**                        │
│  /api/chatbot/**     ← Utilise Djelia      │
│  /api/signalements/**                      │
└────────────┬────────────────────────────────┘
             │
             │ (Interne au backend)
             │ Appelle Djelia AI si nécessaire
             ↓
┌─────────────────────────────────────────────┐
│      Djelia AI Backend (Python Flask)      │
│              Port 5000                      │
│                                             │
│  Service INTERNE                           │
│  Utilisé par FasoDocs uniquement         │
│                                             │
│  Fonctions :                               │
│  - Traduction FR↔BM                       │
│  - Synthèse vocale (bambara)              │
│  - Chat conversationnel                   │
└─────────────────────────────────────────────┘
```

---

## 🎤 Exemple : Icône Micro

### Ce que le Frontend fait

```typescript
// Dans votre service Angular
jouerAudio(texte: string) {
  // ✅ LE FRONTEND APPelle UNIQUEMENT LE PORT 8080
  return this.http.post(
    'http://localhost:8080/api/chatbot/read-quick', 
    texte
  );
}
```

### Ce que FasoDocs Backend fait ensuite (INTERNE)

```java
// 1. Reçoit la requête du frontend sur /api/chatbot/read-quick
// 2. Appelle Djelia AI sur le port 5000 (INTERNE)
String traduction = djeliaIntegrationService.traduireTexte(texte, "fr", "bm");
// 3. Appelle Djelia AI pour générer l'audio
String audioUrl = djeliaIntegrationService.genererSynthèseVocale(traduction, "bm");
// 4. Retourne l'audioUrl au frontend
return new SpeakResponse(audioUrl);
```

### Résultat

```json
// Le frontend reçoit (depuis le port 8080 uniquement)
{
  "success": true,
  "audioUrl": "http://localhost:5000/audio/...",  // ← URL interne, visible
  "originalText": "Je veux faire une carte d'identité",
  "translatedText": "N b'a fɛ ka karti kɛ"
}
```

**Le frontend joue l'audio sans connaître l'existence de Djelia AI.**

---

## 📊 Configuration Frontend TypeScript/Angular

### configuration.ts

```typescript
export const environment = {
  production: false,
  
  // ✅ UN SEUL URL pour tout le backend
  apiUrl: 'http://localhost:8080/api',
  
  // ✅ Le frontend ne connaît PAS le port 5000
};
```

### audio.service.ts

```typescript
import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { environment } from '../environments/environment';

@Injectable({
  providedIn: 'root'
})
export class AudioService {
  
  constructor(private http: HttpClient) {}
  
  // ✅ Appelle UNIQUEMENT FasoDocs (port 8080)
  jouerAudio(texteFrancais: string) {
    return this.http.post<any>(
      `${environment.apiUrl}/chatbot/read-quick`,
      texteFrancais
    );
  }
  
  // Le backend FasoDocs s'occupe de :
  // 1. Traduire FR → BM
  // 2. Appeler Djelia AI (port 5000)
  // 3. Retourner l'audio au frontend
}
```

---

## ✅ Le Frontend ne VOIT JAMAIS le Port 5000

### Architecture Perspective Frontend

```
Frontend Vision
┌────────────────────────────────────────┐
│  Un seul backend : Port 8080          │
│                                        │
│  API disponibles :                    │
│  - http://localhost:8080/api/auth     │
│  - http://localhost:8080/api/procedures│
│  - http://localhost:8080/api/categories│
│  - http://localhost:8080/api/chatbot │
│    ↓                                   │
│    (traduction, audio, chat)          │
│                                        │
│  Le Frontend ne sait PAS que :        │
│  ❌ Djelia AI existe                  │
│  ❌ Il y a un port 5000               │
│  ❌ Il y a un backend Python          │
└────────────────────────────────────────┘
```

---

## 🔧 Endpoints Disponibles pour le Frontend

### Sur le Port 8080 uniquement

```typescript
// Authentification
POST /api/auth/inscription
POST /api/auth/connexion-telephone
POST /api/auth/verifier-sms

// Procédures
GET  /api/procedures
GET  /api/procedures/{id}
POST /api/procedures/rechercher?q=...

// Catégories
GET  /api/categories

// Chatbot (utilise Djelia en interne)
POST /api/chatbot/chat
POST /api/chatbot/translate
POST /api/chatbot/speak
POST /api/chatbot/read-quick     ← Icône micro
```

---

## 📝 Configuration CORS

### Dans application.properties

```properties
# Le CORS autorise le frontend (port 4200)
app.cors.allowed-origins=http://localhost:3000,http://localhost:4200
```

### Dans SecurityConfig.java

```java
// Autorise les requêtes depuis :
// - http://localhost:4200 (Angular)
// - http://localhost:3000 (React)
```

---

## 🎯 Résumé pour le Frontend

### ✅ Configuration

**1 fichier de configuration uniquement** :

```typescript
// environment.ts
export const environment = {
  apiUrl: 'http://localhost:8080/api'
};
```

### ✅ Appels API

**Tous les appels utilisent cette URL** :

```typescript
// Authentification
POST ${apiUrl}/auth/inscription

// Procédures
GET ${apiUrl}/procedures

// Chatbot/Audio
POST ${apiUrl}/chatbot/read-quick
```

### ✅ Fonctionnement

```
1. Frontend appelle FasoDocs (port 8080)
   ↓
2. FasoDocs fait le travail (interne)
   ↓
3. Djelia AI est appelé si nécessaire (port 5000 - interne)
   ↓
4. FasoDocs retourne la réponse au frontend (port 8080)
   ↓
5. Frontend affiche/joue/update l'UI
```

---

## 🎉 Conclusion

### Votre Architecture est CORRECTE ✅

1. ✅ **Frontend** : Un seul port (8080) à connaître
2. ✅ **Backend FasoDocs** : Point d'entrée unique pour le frontend
3. ✅ **Djelia AI** : Service interne, invisible au frontend
4. ✅ **Séparation des rôles** : FasoDocs = Métier, Djelia = Linguistique

### Le Frontend n'a BESOIN de CONNAÎTRE QUE :

```typescript
// Un seul URL
apiUrl: 'http://localhost:8080/api'
```

**C'est tout ! Le reste est géré par FasoDocs Backend.**

---

## 🚀 Pour Démarrer

```bash
# Terminal 1 : Démarrer Djelia AI
cd ../Djelia-AI-Backend
python app.py
# Démarré sur http://localhost:5000

# Terminal 2 : Démarrer FasoDocs Backend
cd Api_fasodocs
mvn spring-boot:run
# Démarré sur http://localhost:8080

# Le frontend utilise UNIQUEMENT http://localhost:8080/api
```

**Votre frontend fonctionne parfaitement ainsi ! 🎉**

