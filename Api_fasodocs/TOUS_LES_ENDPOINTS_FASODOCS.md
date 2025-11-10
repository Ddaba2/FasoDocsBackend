# 🇲🇱 FASODOCS API - TOUS LES ENDPOINTS DISPONIBLES

## 📊 Vue d'ensemble
**Total: 54 endpoints** couvrant l'ensemble des fonctionnalités FasoDocs pour la gestion des procédures administratives au Mali.

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
  ```json
  {
    "nom": "Traoré",
    "prenom": "Amadou",
    "telephone": "76654321",
    "languePreferee": "bm",
    "photoProfil": "data:image/jpeg;base64,/9j/4AAQSkZJRg..."
  }
  ```
- **Réponse**: `MessageResponse`

### 8. Upload photo de profil
- **POST** `/auth/profil/photo`
- **Description**: Upload de la photo de profil du citoyen connecté
- **Authentification**: Requise
- **Body**: `UploadPhotoRequest`
  ```json
  {
    "photoProfil": "data:image/jpeg;base64,/9j/4AAQSkZJRg..."
  }
  ```
- **Réponse**: `MessageResponse`

### 9. Suppression photo de profil
- **DELETE** `/auth/profil/photo`
- **Description**: Suppression de la photo de profil du citoyen connecté
- **Authentification**: Requise
- **Réponse**: `MessageResponse`

### 10. Déconnexion
- **POST** `/auth/deconnexion`
- **Description**: Déconnexion du citoyen
- **Authentification**: Requise
- **Réponse**: `MessageResponse`

---

## 👤 ADMINISTRATION (`/admin`)

### 11. Liste tous les utilisateurs
- **GET** `/admin/utilisateurs`
- **Description**: Récupère tous les utilisateurs enregistrés dans la base de données
- **Autorisation**: `ADMIN` uniquement
- **Réponse**: `List<CitoyenResponse>`

### 12. Créer un utilisateur
- **POST** `/admin/utilisateurs`
- **Description**: Crée un nouvel utilisateur (citoyen ou admin)
- **Autorisation**: `ADMIN` uniquement
- **Body**: `CreerUtilisateurRequest`
  ```json
  {
    "nom": "Diallo",
    "prenom": "Amadou",
    "telephone": "+22370000001",
    "email": "utilisateur@example.com",
    "motDePasse": "motdepasse123",
    "role": "ROLE_CITOYEN"
  }
  ```
- **Réponse**: `CitoyenResponse`

### 13. Supprimer un utilisateur
- **DELETE** `/admin/utilisateurs/{id}`
- **Description**: Supprime un utilisateur par son ID (empêche la suppression du dernier admin)
- **Autorisation**: `ADMIN` uniquement
- **Paramètres**: `id` (path parameter)
- **Réponse**: `MessageResponse`

### 14. Statut du service SMS Orange
- **GET** `/admin/sms/status`
- **Description**: Consulte le statut du service SMS Orange et le rate limiting
- **Autorisation**: `ADMIN` uniquement
- **Réponse**: 
  ```json
  {
    "enabled": true,
    "configured": true,
    "rateLimitAvailable": 5,
    "rateLimitMax": 5,
    "info": "Rate limit: 5 SMS par seconde (limite Orange)"
  }
  ```

---

## 📂 CATÉGORIES (`/categories` ET `/admin/categories`)

### 15. Liste toutes les catégories (Public)
- **GET** `/categories`
- **Description**: Récupère toutes les catégories
- **Accès**: Public
- **Réponse**: `List<CategorieResponse>`

### 16. Détails d'une catégorie (Public)
- **GET** `/categories/{id}`
- **Description**: Récupère une catégorie par son ID
- **Accès**: Public
- **Réponse**: `CategorieResponse`

### 17. Liste toutes les catégories (Admin)
- **GET** `/admin/categories`
- **Description**: Récupère toutes les catégories
- **Autorisation**: `ADMIN` uniquement
- **Réponse**: `List<CategorieResponse>`

### 18. Créer une catégorie (Admin)
- **POST** `/admin/categories`
- **Description**: Crée une nouvelle catégorie
- **Autorisation**: `ADMIN` uniquement
- **Body**: `CategorieRequest`
- **Réponse**: `CategorieResponse`

### 19. Modifier une catégorie (Admin)
- **PUT** `/admin/categories/{id}`
- **Description**: Met à jour une catégorie
- **Autorisation**: `ADMIN` uniquement
- **Body**: `CategorieRequest`
- **Réponse**: `CategorieResponse`

### 20. Supprimer une catégorie (Admin)
- **DELETE** `/admin/categories/{id}`
- **Description**: Supprime une catégorie
- **Autorisation**: `ADMIN` uniquement
- **Réponse**: `MessageResponse`

---

## 📁 SOUS-CATÉGORIES (`/sous-categories` ET `/admin/sous-categories`)

### 21. Liste toutes les sous-catégories (Public)
- **GET** `/sous-categories`
- **Description**: Récupère toutes les sous-catégories
- **Accès**: Public
- **Réponse**: `List<SousCategorieResponse>`

### 22. Détails d'une sous-catégorie (Public)
- **GET** `/sous-categories/{id}`
- **Description**: Récupère une sous-catégorie par son ID
- **Accès**: Public
- **Réponse**: `SousCategorieResponse`

### 23. Sous-catégories d'une catégorie (Public)
- **GET** `/sous-categories/categorie/{categorieId}`
- **Description**: Récupère les sous-catégories d'une catégorie
- **Accès**: Public
- **Réponse**: `List<SousCategorieResponse>`

### 24. Liste toutes les sous-catégories (Admin)
- **GET** `/admin/sous-categories`
- **Description**: Récupère toutes les sous-catégories
- **Autorisation**: `ADMIN` uniquement
- **Réponse**: `List<SousCategorieResponse>`

### 25. Créer une sous-catégorie (Admin)
- **POST** `/admin/sous-categories`
- **Description**: Crée une nouvelle sous-catégorie
- **Autorisation**: `ADMIN` uniquement
- **Body**: `SousCategorieRequest`
- **Réponse**: `SousCategorieResponse`

### 26. Modifier une sous-catégorie (Admin)
- **PUT** `/admin/sous-categories/{id}`
- **Description**: Met à jour une sous-catégorie
- **Autorisation**: `ADMIN` uniquement
- **Body**: `SousCategorieRequest`
- **Réponse**: `SousCategorieResponse`

### 27. Supprimer une sous-catégorie (Admin)
- **DELETE** `/admin/sous-categories/{id}`
- **Description**: Supprime une sous-catégorie
- **Autorisation**: `ADMIN` uniquement
- **Réponse**: `MessageResponse`

---

## 📋 PROCÉDURES (`/procedures` ET `/admin/procedures`)

**IMPORTANT**: Toutes les réponses de procédures incluent maintenant:
- ✅ Étapes (`etapes`)
- ✅ Documents requis (`documentsRequis`)
- ✅ Coût (`cout`, `coutDescription`)
- ✅ Centre de traitement (`centre`)
- ✅ Références légales (`loisArticles`) - **NOUVEAU**
- ✅ Catégorie et sous-catégorie

### 28. Liste toutes les procédures (Public)
- **GET** `/procedures`
- **Description**: Récupère toutes les procédures avec tous les détails
- **Accès**: Public
- **Réponse**: `List<ProcedureResponse>`

### 29. Détails d'une procédure (Public)
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

### 30. Procédures par catégorie (Public)
- **GET** `/procedures/categorie/{categorieId}`
- **Description**: Récupère les procédures d'une catégorie
- **Accès**: Public
- **Réponse**: `List<ProcedureResponse>`

### 31. Procédures par sous-catégorie (Public)
- **GET** `/procedures/sous-categorie/{sousCategorieId}`
- **Description**: Récupère les procédures d'une sous-catégorie
- **Accès**: Public
- **Réponse**: `List<ProcedureResponse>`

### 32. Rechercher des procédures (Public)
- **GET** `/procedures/rechercher?q={terme}`
- **Description**: Recherche des procédures par nom ou titre
- **Accès**: Public
- **Réponse**: `List<ProcedureResponse>`

### 33. Liste toutes les procédures (Admin)
- **GET** `/admin/procedures`
- **Description**: Récupère toutes les procédures avec tous les détails
- **Autorisation**: `ADMIN` uniquement
- **Réponse**: `List<ProcedureResponse>`

### 34. Créer une procédure (Admin)
- **POST** `/admin/procedures`
- **Description**: Crée une nouvelle procédure
- **Autorisation**: `ADMIN` uniquement
- **Body**: `ProcedureRequest`
- **Réponse**: `ProcedureResponse`

**Exemple de requête (utilisation des IDs) :**
```json
{
  "nom": "demande-passeport-biometrique",
  "titre": "Demande de passeport biométrique",
  "delai": "7 jours ouvrables",
  "description": "Procédure pour obtenir un passeport biométrique",
  "categorieId": 1,
  "sousCategorieId": 7
}
```

**Exemple de requête (utilisation des noms - nouvelle méthode) :**
```json
{
  "nom": "demande-passeport-biometrique",
  "titre": "Demande de passeport biométrique",
  "delai": "7 jours ouvrables",
  "description": "Procédure pour obtenir un passeport biométrique",
  "categorieNom": "Identité et citoyenneté",
  "sousCategorieNom": "Passeport malien"
}
```

### 35. Modifier une procédure (Admin)
- **PUT** `/admin/procedures/{id}`
- **Description**: Met à jour une procédure
- **Autorisation**: `ADMIN` uniquement
- **Body**: `ProcedureRequest`
- **Réponse**: `ProcedureResponse`

### 36. Supprimer une procédure (Admin)
- **DELETE** `/admin/procedures/{id}`
- **Description**: Supprime une procédure
- **Autorisation**: `ADMIN` uniquement
- **Réponse**: `MessageResponse`

---

## 🔔 NOTIFICATIONS (`/notifications`)

### 37. Liste toutes les notifications
- **GET** `/notifications`
- **Description**: Récupère toutes les notifications du citoyen connecté
- **Authentification**: Requise
- **Réponse**: `List<NotificationResponse>`

### 38. Notifications non lues
- **GET** `/notifications/non-lues`
- **Description**: Récupère les notifications non lues
- **Authentification**: Requise
- **Réponse**: `List<NotificationResponse>`

### 39. Nombre de notifications non lues
- **GET** `/notifications/count-non-lues`
- **Description**: Compte les notifications non lues
- **Authentification**: Requise
- **Réponse**: `Long` (nombre)

### 40. Marquer comme lue
- **PUT** `/notifications/{id}/lire`
- **Description**: Marque une notification comme lue
- **Authentification**: Requise
- **Réponse**: `NotificationResponse`

### 41. Marquer toutes comme lues
- **PUT** `/notifications/lire-tout`
- **Description**: Marque toutes les notifications comme lues
- **Authentification**: Requise
- **Réponse**: `Void`

---

## 📢 SIGNALEMENTS (`/signalements`)

### 42. Créer un signalement
- **POST** `/signalements`
- **Description**: Crée un nouveau signalement
- **Accès**: Public (pas d'authentification requise)
- **Body**: `SignalementRequest`
- **Réponse**: `MessageResponse`

### 43. Mes signalements
- **GET** `/signalements`
- **Description**: Récupère tous les signalements du citoyen connecté
- **Authentification**: Requise
- **Réponse**: `List<SignalementSimpleResponse>`

### 44. Détails d'un signalement
- **GET** `/signalements/{id}`
- **Description**: Récupère un signalement spécifique
- **Authentification**: Requise
- **Réponse**: `SignalementResponse`

### 45. Modifier un signalement
- **PUT** `/signalements/{id}`
- **Description**: Modifie un signalement (seulement si moins de 15 minutes)
- **Authentification**: Requise
- **Body**: `ModifierSignalementRequest`
- **Réponse**: `MessageResponse`

### 46. Supprimer un signalement
- **DELETE** `/signalements/{id}`
- **Description**: Supprime un signalement (seulement si moins de 15 minutes)
- **Authentification**: Requise
- **Réponse**: `MessageResponse`

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

## 🎤 DJELIA AI & CHATBOT (`/djelia` ET `/chatbot`)

### 47. Lecture rapide avec traduction et audio
- **POST** `/chatbot/read-quick`
- **Description**: Traduit un texte français en bambara et génère l'audio en une seule requête (endpoint de compatibilité)
- **Accès**: Public
- **Body**: `TranslateAndSpeakRequest`
  ```json
  {
    "text": "Bienvenue dans FasoDocs",
    "voiceDescription": "Voix claire et naturelle",
    "chunkSize": 1.0
  }
  ```
- **Réponse**: `TranslateAndSpeakResponse`
  ```json
  {
    "originalText": "Bienvenue dans FasoDocs",
    "translatedText": "Aw bisimila FasoDocs kɔnɔ",
    "audioBase64": "UklGRi4QAABXQVZF...",
    "format": "wav",
    "fromCache": false
  }
  ```

### 48. Traduction français → bambara
- **POST** `/djelia/translate`
- **Description**: Traduit un texte du français vers le bambara
- **Accès**: Public
- **Body**: `TranslationRequest`
- **Réponse**: `TranslationResponse`

### 49. Synthèse vocale bambara
- **POST** `/djelia/text-to-speech`
- **Description**: Convertit du texte bambara en audio WAV (Base64)
- **Accès**: Public
- **Body**: `TextToSpeechRequest`
- **Réponse**: `TextToSpeechResponse`

### 50. Traduction + Synthèse vocale combinées
- **POST** `/djelia/translate-and-speak`
- **Description**: Combine traduction et audio (même fonction que `/chatbot/read-quick`)
- **Accès**: Public
- **Body**: `TranslateAndSpeakRequest`
- **Réponse**: `TranslateAndSpeakResponse`

### 51. Lecture rapide (alias)
- **POST** `/djelia/read-quick`
- **Description**: Alias de `/djelia/translate-and-speak`
- **Accès**: Public

### 52. Statistiques du cache Djelia
- **GET** `/djelia/cache/stats`
- **Description**: Retourne les statistiques d'utilisation du cache de traductions
- **Accès**: Public
- **Réponse**: `DjeliaCacheStatsResponse`

### 53. Vider le cache Djelia
- **DELETE** `/djelia/cache/clear`
- **Description**: Supprime toutes les traductions du cache
- **Accès**: Public
- **Réponse**: `MessageResponse`

### 54. Health check Djelia
- **GET** `/djelia/health`
- **Description**: Vérifie que le service Djelia AI est opérationnel
- **Accès**: Public
- **Réponse**: `MessageResponse`

---

## 🔒 SÉCURITÉ ET AUTORISATIONS

### Endpoints publics (pas d'authentification)
- Tous les endpoints d'authentification
- Consultation des catégories, sous-catégories et procédures
- Création des signalements

### Endpoints protégés (authentification requise)
- Gestion du profil utilisateur (`/auth/profil`)
- Toutes les notifications (`/notifications/*`)
- Consultation et gestion des signalements personnels

### Endpoints administrateur (`ADMIN` uniquement)
- Création, modification et suppression des catégories
- Création, modification et suppression des sous-catégories
- Création, modification et suppression des procédures
- Liste de tous les utilisateurs

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