# 🇲🇱 FASODOCS API - TOUS LES ENDPOINTS DISPONIBLES

## 📊 Vue d'ensemble
**Total: 46 endpoints** couvrant l'ensemble des fonctionnalités FasoDocs pour la gestion des procédures administratives au Mali.

---

## 🔐 AUTHENTIFICATION (`/auth`)

### 1. Création de compte
- **POST** `/auth/inscription`
- **Description**: Inscription d'un nouveau citoyen
- **Body**: `InscriptionRequest`
- **Réponse**: `MessageResponse`

### 2. Connexion par téléphone
- **POST** `/auth/connexion-telephone`
- **Description**: Connexion par téléphone uniquement - Envoie un code SMS
- **Body**: `ConnexionTelephoneRequest` (téléphone uniquement)
- **Réponse**: `MessageResponse` (confirmation envoi SMS)

### 3. Connexion (ancienne méthode)
- **POST** `/auth/connexion`
- **Description**: Connexion d'un citoyen - Envoie un code SMS
- **Body**: `ConnexionRequest` (téléphone + email)
- **Réponse**: `MessageResponse`

### 4. Vérification SMS
- **POST** `/auth/verifier-sms`
- **Description**: Vérification du code SMS et connexion
- **Body**: `VerificationSmsRequest` (téléphone + code)
- **Réponse**: `JwtResponse` (token JWT)

### 5. Vérification email
- **GET** `/auth/verify?code={code}`
- **Description**: Vérification de l'email via code
- **Paramètres**: `code` (query parameter)
- **Réponse**: `MessageResponse`

### 6. Récupération profil
- **GET** `/auth/profil`
- **Description**: Récupération du profil du citoyen connecté
- **Authentification**: Requise (Header: `Authorization: Bearer {token}`)
- **Réponse**: `Citoyen` (données complètes)

### 7. Mise à jour profil
- **PUT** `/auth/profil`
- **Description**: Mise à jour du profil du citoyen connecté
- **Authentification**: Requise
- **Body**: `MiseAJourProfilRequest`
- **Réponse**: `MessageResponse`

### 8. Déconnexion
- **POST** `/auth/deconnexion`
- **Description**: Déconnexion du citoyen
- **Authentification**: Requise
- **Réponse**: `MessageResponse`

---

## 📂 CATÉGORIES (`/categories`)

### 9. Liste toutes les catégories
- **GET** `/categories`
- **Description**: Récupère toutes les catégories
- **Accès**: Public
- **Réponse**: `List<CategorieResponse>`

### 10. Détails d'une catégorie
- **GET** `/categories/{id}`
- **Description**: Récupère une catégorie par son ID
- **Accès**: Public
- **Réponse**: `CategorieResponse`

### 11. Créer une catégorie (Admin)
- **POST** `/categories`
- **Description**: Crée une nouvelle catégorie
- **Autorisation**: `ADMIN` uniquement
- **Body**: `CategorieRequest`
- **Réponse**: `CategorieResponse`

### 12. Modifier une catégorie (Admin)
- **PUT** `/categories/{id}`
- **Description**: Met à jour une catégorie
- **Autorisation**: `ADMIN` uniquement
- **Body**: `CategorieRequest`
- **Réponse**: `CategorieResponse`

### 13. Supprimer une catégorie (Admin)
- **DELETE** `/categories/{id}`
- **Description**: Supprime une catégorie
- **Autorisation**: `ADMIN` uniquement
- **Réponse**: `MessageResponse`

---

## 📁 SOUS-CATÉGORIES (`/sous-categories`)

### 14. Liste toutes les sous-catégories
- **GET** `/sous-categories`
- **Description**: Récupère toutes les sous-catégories
- **Accès**: Public
- **Réponse**: `List<SousCategorieResponse>`

### 15. Détails d'une sous-catégorie
- **GET** `/sous-categories/{id}`
- **Description**: Récupère une sous-catégorie par son ID
- **Accès**: Public
- **Réponse**: `SousCategorieResponse`

### 16. Sous-catégories d'une catégorie
- **GET** `/sous-categories/categorie/{categorieId}`
- **Description**: Récupère les sous-catégories d'une catégorie
- **Accès**: Public
- **Réponse**: `List<SousCategorieResponse>`

### 17. Créer une sous-catégorie (Admin)
- **POST** `/sous-categories`
- **Description**: Crée une nouvelle sous-catégorie
- **Autorisation**: `ADMIN` uniquement
- **Body**: `SousCategorieRequest`
- **Réponse**: `SousCategorieResponse`

### 18. Modifier une sous-catégorie (Admin)
- **PUT** `/sous-categories/{id}`
- **Description**: Met à jour une sous-catégorie
- **Autorisation**: `ADMIN` uniquement
- **Body**: `SousCategorieRequest`
- **Réponse**: `SousCategorieResponse`

### 19. Supprimer une sous-catégorie (Admin)
- **DELETE** `/sous-categories/{id}`
- **Description**: Supprime une sous-catégorie
- **Autorisation**: `ADMIN` uniquement
- **Réponse**: `MessageResponse`

---

## 📋 PROCÉDURES (`/procedures`)

**IMPORTANT**: Toutes les réponses de procédures incluent maintenant:
- ✅ Étapes (`etapes`)
- ✅ Documents requis (`documentsRequis`)
- ✅ Coût (`cout`, `coutDescription`)
- ✅ Centre de traitement (`centre`)
- ✅ Références légales (`loisArticles`) - **NOUVEAU**
- ✅ Catégorie et sous-catégorie

### 20. Liste toutes les procédures
- **GET** `/procedures`
- **Description**: Récupère toutes les procédures avec tous les détails
- **Accès**: Public
- **Réponse**: `List<ProcedureResponse>`

### 21. Détails d'une procédure
- **GET** `/procedures/{id}`
- **Description**: Récupère une procédure par son ID avec tous les détails
- **Accès**: Public
- **Réponse**: `ProcedureResponse` avec:
  - Informations de base
  - Étapes détaillées
  - Documents requis
  - Coût en FCFA
  - Centre de traitement (nom, adresse, horaires, coordonnées GPS, téléphone, email)
  - Catégorie et sous-catégorie
  - **Références légales** (lois et articles avec lien audio bambara)

### 22. Procédures par catégorie
- **GET** `/procedures/categorie/{categorieId}`
- **Description**: Récupère les procédures d'une catégorie
- **Accès**: Public
- **Réponse**: `List<ProcedureResponse>`

### 23. Procédures par sous-catégorie
- **GET** `/procedures/sous-categorie/{sousCategorieId}`
- **Description**: Récupère les procédures d'une sous-catégorie
- **Accès**: Public
- **Réponse**: `List<ProcedureResponse>`

### 24. Rechercher des procédures
- **GET** `/procedures/rechercher?q={terme}`
- **Description**: Recherche des procédures par nom ou titre
- **Accès**: Public
- **Réponse**: `List<ProcedureResponse>`

### 25. Créer une procédure (Admin)
- **POST** `/procedures`
- **Description**: Crée une nouvelle procédure
- **Autorisation**: `ADMIN` uniquement
- **Body**: `ProcedureRequest`
- **Réponse**: `ProcedureResponse`

### 26. Modifier une procédure (Admin)
- **PUT** `/procedures/{id}`
- **Description**: Met à jour une procédure
- **Autorisation**: `ADMIN` uniquement
- **Body**: `ProcedureRequest`
- **Réponse**: `ProcedureResponse`

### 27. Supprimer une procédure (Admin)
- **DELETE** `/procedures/{id}`
- **Description**: Supprime une procédure
- **Autorisation**: `ADMIN` uniquement
- **Réponse**: `MessageResponse`

---

## 🔔 NOTIFICATIONS (`/notifications`)

### 28. Liste toutes les notifications
- **GET** `/notifications`
- **Description**: Récupère toutes les notifications du citoyen connecté
- **Authentification**: Requise
- **Réponse**: `List<NotificationResponse>`

### 29. Notifications non lues
- **GET** `/notifications/non-lues`
- **Description**: Récupère les notifications non lues
- **Authentification**: Requise
- **Réponse**: `List<NotificationResponse>`

### 30. Nombre de notifications non lues
- **GET** `/notifications/count-non-lues`
- **Description**: Compte les notifications non lues
- **Authentification**: Requise
- **Réponse**: `Long` (nombre)

### 31. Marquer comme lue
- **PUT** `/notifications/{id}/lire`
- **Description**: Marque une notification comme lue
- **Authentification**: Requise
- **Réponse**: `NotificationResponse`

### 32. Marquer toutes comme lues
- **PUT** `/notifications/lire-tout`
- **Description**: Marque toutes les notifications comme lues
- **Authentification**: Requise
- **Réponse**: `Void`

---

## 📢 SIGNALEMENTS (`/signalements`)

### 33. Créer un signalement
- **POST** `/signalements`
- **Description**: Crée un nouveau signalement
- **Accès**: Public (pas d'authentification requise)
- **Body**: `SignalementRequest`
- **Réponse**: `MessageResponse`

### 34. Mes signalements
- **GET** `/signalements`
- **Description**: Récupère tous les signalements du citoyen connecté
- **Authentification**: Requise
- **Réponse**: `List<SignalementSimpleResponse>`

### 35. Détails d'un signalement
- **GET** `/signalements/{id}`
- **Description**: Récupère un signalement spécifique
- **Authentification**: Requise
- **Réponse**: `SignalementResponse`

### 36. Modifier un signalement
- **PUT** `/signalements/{id}`
- **Description**: Modifie un signalement (seulement si moins de 15 minutes)
- **Authentification**: Requise
- **Body**: `ModifierSignalementRequest`
- **Réponse**: `MessageResponse`

### 37. Supprimer un signalement
- **DELETE** `/signalements/{id}`
- **Description**: Supprime un signalement (seulement si moins de 15 minutes)
- **Authentification**: Requise
- **Réponse**: `MessageResponse`

---

## 🤖 CHATBOT DJELIA (`/chatbot`)

### 38. Chat simple
- **POST** `/chatbot/chat`
- **Description**: Chat avec Djelia AI dans différentes langues (français, bambara, etc.)
- **Body**: `ChatRequest`
- **Réponse**: `ChatResponse`

### 39. Chat avec synthèse vocale
- **POST** `/chatbot/chat-audio`
- **Description**: Chat avec Djelia AI + génération audio en bambara
- **Body**: `ChatRequest`
- **Réponse**: `ChatResponse` (avec URL audio)

### 40. Traduction de texte
- **POST** `/chatbot/translate`
- **Description**: Traduit un texte du français vers le bambara ou vice versa
- **Body**: `TranslationRequest`
- **Réponse**: `TranslationResponse`

### 41. Synthèse vocale
- **POST** `/chatbot/speak`
- **Description**: Génère un audio à partir d'un texte en bambara
- **Body**: `SpeakRequest`
- **Réponse**: `SpeakResponse` (URL audio)

### 42. Traduction rapide FR → BM
- **POST** `/chatbot/translate/fr-to-bm`
- **Description**: Traduction rapide du français vers le bambara
- **Body**: `String` (texte à traduire)
- **Réponse**: `TranslationResponse`

### 43. Traduction rapide BM → FR
- **POST** `/chatbot/translate/bm-to-fr`
- **Description**: Traduction rapide du bambara vers le français
- **Body**: `String` (texte à traduire)
- **Réponse**: `TranslationResponse`

### 44. Lecture audio automatique
- **POST** `/chatbot/read-audio`
- **Description**: Traduit un texte français et le lit en bambara
- **Body**: `String` (texte français)
- **Réponse**: `SpeakResponse`

### 45. Lecture audio rapide
- **POST** `/chatbot/read-quick`
- **Description**: Version simplifiée pour l'icône audio du frontend
- **Body**: `String` (texte français)
- **Réponse**: `{"success": boolean, "audioUrl": string, "originalText": string, "translatedText": string}`

### 46. Vérification connectivité
- **GET** `/chatbot/health`
- **Description**: Vérifie si le service Djelia AI est accessible
- **Réponse**: `{"status": "OK/KO", "message": "..."}`

---

## 📊 STRUCTURE COMPLÈTE DES PROCÉDURES

Chaque procédure retournée contient:

```json
{
  "id": 1,
  "nom": "CARTE_NINA",
  "titre": "Carte d'Identité Nationale NINA",
  "description": "Demande de carte d'identité nationale biométrique NINA",
  "delai": "15 jours",
  "urlVersFormulaire": "https://anpe.gov.ml/formulaires/nina",
  "dateCreation": "2025-10-13T10:00:00",
  "dateModification": "2025-10-13T10:00:00",
  
  "categorie": {
    "id": 2,
    "titre": "Documents d'Identité",
    "description": "Cartes d'identité, passeports, permis de conduire",
    "iconeUrl": "https://example.com/icons/identite.png"
  },
  
  "sousCategorie": {
    "id": 5,
    "titre": "Cartes d'identité",
    "description": "Cartes d'identité maliennes"
  },
  
  "cout": 5000,
  "coutDescription": "Frais de carte NINA",
  
  "centre": {
    "id": 4,
    "nom": "Centre d'Enrôlement NINA - Bamako Centre",
    "adresse": "ACI 2000, Bamako",
    "horaires": "Lundi-Samedi: 8h-17h",
    "coordonneesGPS": "12.6550,-7.9900",
    "telephone": "+223 76 12 34 56",
    "email": "nina.bamako@anpe.ml"
  },
  
  "etapes": [
    {
      "id": 1,
      "nom": "Se rendre au centre",
      "description": "Se rendre au centre d'enrôlement",
      "niveau": 1
    },
    {
      "id": 2,
      "nom": "Présenter les documents",
      "description": "Présenter les documents requis",
      "niveau": 2
    }
  ],
  
  "documentsRequis": [
    {
      "id": 1,
      "description": "Acte de naissance ou jugement supplétif",
      "estObligatoire": true,
      "modeleUrl": null
    },
    {
      "id": 2,
      "description": "Photo d'identité récente",
      "estObligatoire": true,
      "modeleUrl": null
    }
  ],
  
  "loisArticles": [
    {
      "id": 1,
      "description": "Décret n°95-255/P-RM du 30/06/95 article 66",
      "consulterArticle": "Décret n°95-255/P-RM du 30/06/95 article 66 fixant le prix des bulletins du casier judiciaire. Ce décret définit le coût et les conditions d'établissement du certificat de casier judiciaire.",
      "lienAudio": "https://example.com/audio/loi-bambara.mp3"
    }
  ]
}
```

---

## 🔒 SÉCURITÉ ET AUTORISATIONS

### Endpoints publics (pas d'authentification)
- Tous les endpoints d'authentification
- Consultation des catégories, sous-catégories et procédures
- Endpoints du chatbot Djelia
- Création des signalements

### Endpoints protégés (authentification requise)
- Gestion du profil utilisateur (`/auth/profil`)
- Toutes les notifications (`/notifications/*`)
- Consultation et gestion des signalements personnels

### Endpoints administrateur (`ADMIN` uniquement)
- Création, modification et suppression des catégories
- Création, modification et suppression des sous-catégories
- Création, modification et suppression des procédures

### Authentification
Pour les endpoints protégés, ajouter dans les headers:
```
Authorization: Bearer {token-jwt}
```

---

## 📝 CODES DE RÉPONSE

- **200 OK**: Succès
- **201 Created**: Ressource créée avec succès
- **400 Bad Request**: Erreur dans la requête
- **401 Unauthorized**: Non authentifié
- **403 Forbidden**: Accès refusé (pas les droits)
- **404 Not Found**: Ressource non trouvée
- **500 Internal Server Error**: Erreur serveur
- **503 Service Unavailable**: Service temporairement indisponible

---

## 📈 DONNÉES DISPONIBLES DANS L'API

L'API expose **83 procédures complètes** incluant:

- ✅ **7 catégories** principales
- ✅ **86 sous-catégories**
- ✅ **458 étapes** détaillées
- ✅ **460+ documents requis**
- ✅ **344 coûts** documentés
- ✅ **67 centres** de traitement
- ✅ **238 articles de loi** référencés
- ✅ **Liens audio bambara** pour les lois

---

## 🌐 BASE URL

**Local**: `http://localhost:8080/api`  
**Production**: (à configurer selon votre déploiement)

**Swagger UI**: `http://localhost:8080/api/swagger-ui.html`

---

## 📞 SUPPORT

Pour toute question ou problème, consultez la documentation complète ou contactez l'équipe de développement.

---

**© 2025 FasoDocs - Simplifiant les procédures administratives au Mali** 🇲🇱
