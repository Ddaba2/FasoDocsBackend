# 🇲🇱 FasoDocs Backend - API REST

**Backend officiel de l'application FasoDocs** - Plateforme numérique pour simplifier les procédures administratives au Mali.

---

## 📋 Table des Matières

- [Vue d'Ensemble](#vue-densemble)
- [Fonctionnalités](#fonctionnalités)
- [Architecture](#architecture)
- [Technologies](#technologies)
- [Installation](#installation)
- [Configuration](#configuration)
- [Démarrage](#démarrage)
- [API Documentation](#api-documentation)
- [Intégrations](#intégrations)
- [Développement](#développement)

---

## 🎯 Vue d'Ensemble

FasoDocs est une plateforme qui aide les citoyens maliens à naviguer les procédures administratives en fournissant :
- ✅ **83 procédures complètes** (documents d'identité, état civil, justice, etc.)
- ✅ **Services de délégation** (prise en charge complète des démarches)
- ✅ **Authentification par SMS** (Orange SMS API)
- ✅ **Assistant vocal bambara** (Djelia AI + Voix off de fallback)
- ✅ **Signalement de problèmes**
- ✅ **Notifications en temps réel**
- ✅ **Interface multilingue** (Français / Bambara)

---

## ⚡ Fonctionnalités

### 🔐 Authentification & Profil
- Inscription et connexion par téléphone + SMS
- Authentification JWT
- Gestion du profil utilisateur
- Upload de photo de profil (Base64)
- Multi-rôles (Citoyen / Admin)

### 📂 Gestion des Procédures
- 83 procédures administratives complètes
- 7 catégories principales
- 86 sous-catégories
- 458 étapes détaillées
- 460+ documents requis
- 344 coûts documentés
- 67 centres de traitement
- 238 articles de loi référencés

### 🎤 Djelia AI (Assistant Vocal Bambara)
- Traduction Français → Bambara
- Synthèse vocale (TTS) en bambara
- Reconnaissance vocale (STT) bambara
- Architecture hybride (Spring Boot + Flask)
- **Note** : Actuellement désactivé (`djelia.ai.enabled=false`)
- **Fallback** : Utilisation de fichiers audio préenregistrés

### 📱 Orange SMS
- Envoi de codes de vérification par SMS
- Authentification sécurisée
- Rate limiting (5 SMS/seconde)
- Mode développement (logs des codes)

### 🛎️ Services de Délégation
- Demande de service pour prise en charge complète
- Tarifs selon la commune
- Suivi des demandes (EN_ATTENTE, EN_COURS, TERMINEE)
- Notifications automatiques aux admins par email
- Gestion admin des demandes

### 🔊 Audio & Voix Off
- Audio préenregistré pour chaque procédure
- Fallback automatique si Djelia AI indisponible
- Support formats : WAV, MP3, OGG, AAC
- Endpoints Base64 pour Flutter

### 🔔 Notifications
- Notifications en temps réel
- Système de marquage lu/non-lu
- Filtrage par statut
- Emails automatiques aux admins

### 📢 Signalements
- Signalement de problèmes
- Modification sous 15 minutes
- Suivi des signalements

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    Frontend Clients                      │
│  (Flutter Mobile, Angular Admin, Web)                   │
└────────────────┬────────────────────────────────────────┘
                 │ HTTP/REST
                 ↓
┌─────────────────────────────────────────────────────────┐
│           Spring Boot Backend (Port 8080)                │
│  • Authentification JWT                                  │
│  • Gestion Procédures/Catégories                        │
│  • Orange SMS API Integration                            │
│  • Proxy vers Flask pour Djelia AI                      │
└────┬──────────────────────────────────┬─────────────────┘
     │                                   │
     │ SMS                              │ HTTP
     ↓                                   ↓
┌─────────────────┐          ┌──────────────────────────┐
│  Orange SMS API │          │ Flask Backend (Port 5000)│
│  (Mali)         │          │ • SDK Djelia Python      │
└─────────────────┘          │ • Traduction FR→BM       │
                              │ • TTS/STT Bambara        │
                              └────────┬─────────────────┘
                                       │
                                       ↓
                              ┌──────────────────────────┐
                              │   API Djelia Cloud       │
                              │   (IA Langues Africaines)│
                              └──────────────────────────┘
```

---

## 🛠️ Technologies

### Backend Principal (Spring Boot)
- **Java 17+**
- **Spring Boot 3.x**
- **Spring Security** (JWT)
- **Spring Data JPA** (Hibernate)
- **MySQL 8.x**
- **Maven**

### Backend Djelia (Flask Python)
- **Python 3.8+**
- **Flask**
- **SDK Djelia** (Python officiel)
- **Requests**

### Services Externes
- **Orange SMS API** (Mali)
- **Djelia AI** (Traduction & Synthèse Vocale)
- **Gmail SMTP** (Emails de vérification)

---

## 📦 Installation

### Prérequis

- Java JDK 17 ou supérieur
- Maven 3.8+
- MySQL 8.x
- Python 3.8+ (pour Djelia AI)
- Git

### 1. Cloner le Projet

```bash
git clone https://github.com/votre-repo/fasodocs-backend.git
cd fasodocs-backend
```

### 2. Créer la Base de Données

```sql
CREATE DATABASE FasoDocs CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

> 💡 **Nouveau !** Le système importe automatiquement toutes les données au démarrage.
> Voir [GUIDE_EXPORT_IMPORT_DONNEES.md](GUIDE_EXPORT_IMPORT_DONNEES.md) pour plus de détails.

### 3. Installer les Dépendances Java

```bash
./mvnw clean install
```

### 4. Installer les Dépendances Python (Djelia)

```bash
pip install flask flask-cors djelia python-dotenv requests
```

---

## ⚙️ Configuration

### 1. Configuration Spring Boot

**Fichier** : `src/main/resources/application.properties`

```properties
# Base de données
spring.datasource.url=jdbc:mysql://localhost:3306/FasoDocs
spring.datasource.username=root
spring.datasource.password=votre_mot_de_passe

# JWT Secret
jwt.secret=VotreSecretTresLongPourHS512

# Email (Gmail)
spring.mail.username=votre-email@gmail.com
spring.mail.password=votre_mot_de_passe_app

# Orange SMS (Production uniquement)
orange.sms.enabled=false  # true en production
orange.sms.client.id=votre_client_id
orange.sms.client.secret=votre_client_secret

# Djelia AI (actuellement désactivé)
djelia.ai.enabled=false
djelia.ai.base.url=http://localhost:5000/api
djelia.ai.timeout=60000

# Audio Fallback (Voix Off)
app.audio.directory=src/main/resources/static/audio/procedures
```

### 2. Configuration Djelia AI

**Fichier** : `backend_djelia.py` (ligne 26)

```python
DJELIA_API_KEY = "votre_cle_djelia"
```

---

## 🚀 Démarrage

### Mode Développement (2 Terminaux)

#### Terminal 1 : Backend Flask (Djelia AI)

```bash
python backend_djelia.py
```

**Attendu** :
```
✅ Client Djelia initialisé avec succès
🚀 Démarrage du serveur FasoDocs Backend Flask + Djelia AI
📡 Endpoints disponibles:
   - GET  /api/health
   - POST /api/speak (Traduction FR→BM + TTS)
   - POST /api/transcribe (STT bambara)
 * Running on http://0.0.0.0:5000
```

#### Terminal 2 : Backend Spring Boot

```bash
./mvnw spring-boot:run
```

**Attendu** :
```
Started FasoDocsApplication in X seconds
Tomcat started on port(s): 8080 (http)
```

### URLs d'Accès

- **API REST** : http://localhost:8080/api
- **Swagger UI** : http://localhost:8080/api/swagger-ui.html
- **Djelia Flask** : http://localhost:5000
- **H2 Console** : Non activée (MySQL utilisé)

---

## 📚 API Documentation

Consultez **`TOUS_LES_ENDPOINTS_FASODOCS.md`** pour la liste complète des 54 endpoints.

### Endpoints Principaux

| Endpoint | Méthode | Description |
|----------|---------|-------------|
| `/auth/inscription` | POST | Inscription citoyen |
| `/auth/connexion-telephone` | POST | Connexion par téléphone |
| `/auth/verifier-sms` | POST | Vérification code SMS |
| `/auth/profil` | GET | Profil utilisateur |
| `/procedures` | GET | Liste des procédures |
| `/procedures/{id}` | GET | Détails procédure |
| `/procedures/{id}/audio/base64` | GET | Audio en Base64 (voix off) |
| `/services/procedures/{id}/tarif` | GET | Tarif d'un service |
| `/services/demandes` | POST | Créer demande de service |
| `/services/mes-demandes` | GET | Mes demandes de service |
| `/chatbot/read-quick` | POST | Djelia AI (traduction + audio) |
| `/categories` | GET | Liste catégories |
| `/notifications` | GET | Notifications utilisateur |
| `/signalements` | POST | Créer signalement |

**Documentation complète** :
- `TOUS_LES_ENDPOINTS_FASODOCS.md` - Tous les endpoints
- `NOUVEAUX_ENDPOINTS_SERVICE.md` - Endpoints Services (remplacement délégation)
- `ENDPOINTS_ADMIN_DELEGATIONS.md` - Endpoints Admin Services
- `ENDPOINTS_FLUTTER_VOIX_OFF.md` - Endpoints Audio/Voix Off

---

## 🔌 Intégrations

### 1. Djelia AI (Assistant Vocal Bambara)

**Voir** : `GUIDE_INTEGRATION_DJELIA_AI.md` pour les détails complets.

**Résumé** :
- Backend Flask (Python) utilise le SDK Djelia officiel
- Spring Boot sert de proxy vers Flask
- Traduction automatique FR → BM
- Synthèse vocale en bambara
- **Statut actuel** : Désactivé (`djelia.ai.enabled=false`)
- **Fallback** : Fichiers audio préenregistrés dans `src/main/resources/static/audio/procedures/`

### 2. Voix Off (Audio Fallback)

**Voir** : `POINT_VOIX_OFF_FALLBACK.md` et `ENDPOINTS_FLUTTER_VOIX_OFF.md`

**Résumé** :
- Fichiers audio préenregistrés pour chaque procédure
- Formats supportés : WAV, MP3, OGG, AAC
- Endpoints Base64 pour Flutter
- Chargement depuis le classpath Spring

### 3. Orange SMS API (Mali)

**Voir** : `GUIDE_INTEGRATION_ORANGE_SMS.md` pour les détails complets.

**Résumé** :
- Authentification OAuth 2.0
- Envoi de codes de vérification par SMS
- Rate limiting (5 SMS/seconde)
- Mode développement (codes dans les logs)

### 4. Gmail SMTP

- Envoi d'emails de vérification
- Emails automatiques aux admins pour nouvelles demandes de service
- Configuration dans `application.properties`

---

## 👨‍💻 Développement

### Structure du Projet

```
Api_fasodocs/
├── src/main/java/ml/fasodocs/backend/
│   ├── controller/          # Contrôleurs REST
│   ├── service/             # Logique métier
│   ├── entity/              # Entités JPA
│   ├── repository/          # Repositories JPA
│   ├── dto/                 # Data Transfer Objects
│   ├── security/            # Configuration sécurité JWT
│   ├── config/              # Configuration Spring
│   └── exception/           # Exceptions personnalisées
├── src/main/resources/
│   ├── application.properties  # Configuration
│   └── db/migration/           # Scripts SQL
├── backend_djelia.py           # Backend Flask (Djelia AI)
├── pom.xml                     # Dépendances Maven
└── README.md                   # Ce fichier
```

### Commandes Utiles

```bash
# Compilation
./mvnw clean compile

# Tests
./mvnw test

# Package (JAR)
./mvnw clean package

# Démarrage dev
./mvnw spring-boot:run

# Vérifier dépendances
./mvnw dependency:tree
```

---

## 🗄️ Base de Données

### Schéma Principal

- **citoyens** : Utilisateurs de l'application
- **roles** : Rôles (CITOYEN, ADMIN)
- **procedures** : Procédures administratives
- **categories** : Catégories de procédures
- **sous_categories** : Sous-catégories
- **etapes** : Étapes des procédures
- **documents_requis** : Documents nécessaires
- **couts** : Coûts des procédures
- **centres** : Centres de traitement
- **lois_articles** : Références légales
- **notifications** : Notifications utilisateurs
- **signalements** : Signalements de problèmes
- **historiques** : Historique des actions
- **demandes_service** : Demandes de service (remplacement délégation)

### Initialisation des Données

Les données sont chargées automatiquement au démarrage si `app.init.data=true`.

**Script SQL** : `src/main/resources/db/migration/`

---

## 🔒 Sécurité

- **JWT** : Authentification par token
- **Spring Security** : Configuration des accès
- **CORS** : Configuration pour Android/Web
- **Rate Limiting** : SMS (5/seconde)
- **Validation** : DTO avec annotations Jakarta

### Endpoints Publics
- Authentification (`/auth/*`)
- Consultation procédures (`/procedures/*`)
- Djelia AI (`/chatbot/*`, `/djelia/*`)

### Endpoints Protégés
- Profil utilisateur
- Notifications
- Signalements personnels

### Endpoints Admin
- Gestion utilisateurs (`/admin/utilisateurs/*`)
- CRUD Catégories (`/admin/categories/*`)
- CRUD Procédures (`/admin/procedures/*`)
- Gestion Services (`/admin/services/demandes/*`)
  - Lister toutes les demandes
  - Modifier le statut des demandes
  - Filtrer par statut (EN_ATTENTE, EN_COURS, TERMINEE)

---

## 🧪 Tests

```bash
# Tester l'API
curl http://localhost:8080/api/health

# Tester Djelia Flask
curl http://localhost:5000/api/health

# Tester Orange SMS
curl http://localhost:8080/api/admin/sms/status \
  -H "Authorization: Bearer <token_admin>"
```

---

## 📱 Frontend Clients

- **Flutter Mobile** : Application mobile iOS/Android
- **Angular Admin** : Interface d'administration web
- **Documentation** : Voir `TOUS_LES_ENDPOINTS_FASODOCS.md`

---

## 🌍 Déploiement

### Production

1. **Spring Boot** : Deployer sur Heroku, Railway, ou serveur Java
2. **Flask (Djelia)** : Deployer sur Python server séparé
3. **MySQL** : Base de données de production
4. **Configurer** :
   - `orange.sms.enabled=true`
   - URLs de production
   - Secrets en variables d'environnement

---

## 📞 Support

- **Email** : dabadiallo694@gmail.com
- **Documentation API** : `/swagger-ui.html`
- **Guide Endpoints** : `TOUS_LES_ENDPOINTS_FASODOCS.md`
- **Guide Services** : `NOUVEAUX_ENDPOINTS_SERVICE.md`
- **Guide Voix Off** : `ENDPOINTS_FLUTTER_VOIX_OFF.md` et `POINT_VOIX_OFF_FALLBACK.md`
- **Guide Djelia** : `GUIDE_INTEGRATION_DJELIA_AI.md`
- **Guide SMS** : `GUIDE_INTEGRATION_ORANGE_SMS.md`

---

## 📄 Licence

© 2025 FasoDocs - Simplifiant les procédures administratives au Mali 🇲🇱

---

## 🚀 Démarrage Rapide

```bash
# 1. Démarrer Flask (Djelia AI)
python backend_djelia.py

# 2. Démarrer Spring Boot (dans un autre terminal)
./mvnw spring-boot:run

# 3. Accéder à l'API
curl http://localhost:8080/api/procedures
```

**Consultez les guides d'intégration pour plus de détails !**
