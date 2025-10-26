# 🎯 Architecture : Utiliser le Même Port pour FasoDocs et Djelia AI

## ❓ Pourquoi Deux Ports Sépares Actuellement ?

### 🔧 Raisons Techniques

1. **Deux Applications Différentes**
   - **FasoDocs Backend** : Spring Boot (Java) - Port 8080
   - **Djelia AI** : Flask (Python) - Port 5000

2. **Séparation des Responsabilités** (Microservices)
   ```
   Port 8080 : API FasoDocs
   ├── /api/auth
   ├── /api/procedures
   ├── /api/categories
   └── /api/chatbot  → Appelle Djelia AI
   
   Port 5000 : Service Djelia AI
   ├── /translate
   ├── /speak
   └── /chat
   ```

3. **Avantages de la Séparation**
   - ✅ Indépendance des services
   - ✅ Déploiement séparé
   - ✅ Scaling indépendant
   - ✅ Debugging plus facile

---

## 🎯 Solution : Reverse Proxy (Même Port pour le Frontend)

### Architecture Proposée

```
┌────────────────────────────────────────────────────┐
│              Frontend (Angular/React)             │
│                   Port : 4200                     │
└────────────────────┬──────────────────────────────┘
                     │ HTTP
                     ↓
┌────────────────────────────────────────────────────┐
│            Nginx Reverse Proxy                     │
│                   Port : 8080                      │
│                                                    │
│  /api/*         → FasoDocs Backend (:8080)        │
│  /djelia/*      → Djelia AI (:5000)              │
└─────┬──────────────────────────┬──────────────────┘
      │                          │
      ↓                          ↓
┌─────────────┐          ┌─────────────┐
│  FasoDocs   │          │  Djelia AI │
│  :8080     │          │  :5000      │
└─────────────┘          └─────────────┘
```

---

## 🔧 Configuration Nginx

### Fichier `nginx.conf`

```nginx
server {
    listen 8080;
    server_name localhost;

    # API FasoDocs
    location /api/ {
        proxy_pass http://localhost:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    # Djelia AI
    location /djelia/ {
        proxy_pass http://localhost:5000/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    # CORS headers
    add_header 'Access-Control-Allow-Origin' '*' always;
    add_header 'Access-Control-Allow-Methods' 'GET, POST, PUT, DELETE, OPTIONS' always;
    add_header 'Access-Control-Allow-Headers' 'Authorization, Content-Type' always;
}
```

---

## ⚙️ Solution Alternative : Intégration Directe

### Option 1 : Router d'API dans FasoDocs

**Avantages** : 
- ✅ Un seul port
- ✅ Gestion centralisée
- ✅ Plus simple pour le déploiement

**Inconvénients** :
- ❌ Plus lourd (deux technologies)
- ❌ Maintenance plus complexe

### Mise en Œuvre

Créer un contrôleur proxy dans FasoDocs :

```java
@RestController
@RequestMapping("/api/djelia")
public class DjeliaProxyController {
    
    @Autowired
    private DjeliaIntegrationService djeliaService;
    
    @PostMapping("/translate")
    public ResponseEntity<?> translate(@RequestBody TranslationRequest request) {
        String result = djeliaService.traduireTexte(
            request.getText(), 
            request.getSourceLang(), 
            request.getTargetLang()
        );
        return ResponseEntity.ok(result);
    }
    
    @PostMapping("/speak")
    public ResponseEntity<?> speak(@RequestBody SpeakRequest request) {
        String audioUrl = djeliaService.genererSynthèseVocale(
            request.getText(), 
            request.getLanguage()
        );
        return ResponseEntity.ok(Map.of("audioUrl", audioUrl));
    }
}
```

**Endpoints finaux** :
```
POST http://localhost:8080/api/djelia/translate
POST http://localhost:8080/api/djelia/speak
```

---

## 🎯 Solution RECOMMANDÉE : Garder Deux Ports

### Pourquoi ?

1. **Meilleure Séparation des Concerns**
   ```
   FasoDocs : Métier et logique
   Djelia AI : Traitement linguistique
   ```

2. **Scalabilité Indépendante**
   - Si beaucoup de traductions → Scale Djelia AI
   - Si beaucoup d'API requests → Scale FasoDocs

3. **Technologies Différentes**
   - FasoDocs : Java Spring
   - Djelia AI : Python Flask

---

## 📝 Configuration Frontend : Utiliser Deux Ports

### Exemple TypeScript

```typescript
// configuration.ts
export const API_CONFIG = {
  // FasoDocs Backend
  FASODOCS_BASE_URL: 'http://localhost:8080/api',
  
  // Djelia AI (si appelé directement)
  DJELIA_BASE_URL: 'http://localhost:5000',
  
  // OU tout passe par FasoDocs
  TRANSLATE_ENDPOINT: 'http://localhost:8080/api/chatbot/read-quick'
};

// usage.service.ts
import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { API_CONFIG } from './configuration';

@Injectable({
  providedIn: 'root'
})
export class AudioService {
  
  constructor(private http: HttpClient) {}
  
  // Option 1 : Tout passe par FasoDocs (RECOMMANDÉ)
  jouerAudio(texte: string) {
    return this.http.post(
      `${API_CONFIG.TRANSLATE_ENDPOINT}`, 
      texte
    );
  }
  
  // Option 2 : Appeler Djelia directement (si nécessaire)
  // jouerAudioDirect(texte: string) {
  //   return this.http.post(
  //     `${API_CONFIG.DJELIA_BASE_URL}/speak`,
  //     { text: texte, language: 'bm' }
  //   );
  // }
}
```

---

## 🎉 Recommandation Finale

### ✅ Utiliser le Frontend FasoDocs comme Point d'Entrée Unique

**Flux actuel** (recommandé) :
```
Frontend 
  ↓
/api/chatbot/read-quick (Port 8080)
  ↓
FasoDocs Backend s'occupe de tout
  ├─→ Appelle Djelia AI (interne, port 5000)
  └─→ Retourne audio au Frontend
```

**Avantages** :
- ✅ Frontend voit un seul port (8080)
- ✅ Logique métier centralisée dans FasoDocs
- ✅ Djelia AI reste interne et séparé

### Le Frontend n'utilise JAMAIS directement le port 5000

```typescript
// ✅ CORRECT : Tout passe par FasoDocs
this.http.post('http://localhost:8080/api/chatbot/read-quick', texte)

// ❌ INCORRECT : Ne pas appeler Djelia directement
this.http.post('http://localhost:5000/speak', data)
```

---

## 📊 Récapitulatif

| Port | Service | Accessible par Frontend |
|------|---------|-------------------------|
| 8080 | FasoDocs Backend | ✅ OUI |
| 5000 | Djelia AI | ❌ NON (interne) |

**Le frontend utilise UNIQUEMENT le port 8080 !**

Djelia AI sur le port 5000 est **interne** à FasoDocs. Le frontend appelle `/api/chatbot/*` qui utilise Djelia en interne.

---

## 🎯 Réponse Directe

**Pourquoi pas sur le même port ?**

Parce que :
1. Djelia AI est un service Python séparé
2. FasoDocs est un service Java séparé
3. **Le frontend utilise UNIQUEMENT le port 8080**

Le port 5000 est **invisible au frontend**. FasoDocs orchestre tout et appelle Djelia en interne.

**Vous n'avez qu'UN SEUL port à utiliser dans votre frontend : 8080** ✅

