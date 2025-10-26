# FasoDocs API - Documentation Complète des Endpoints

## Vue d'ensemble
Cette documentation présente tous les endpoints disponibles dans l'API FasoDocs pour la gestion des procédures administratives au Mali.

**📊 Total: 46 endpoints disponibles**

**✨ Nouveauté**: Les réponses de procédures incluent maintenant **les références légales (238 articles de loi)** avec liens audio en bambara.

---

## 🔐 AUTHENTIFICATION (`/auth`)

### Inscription
- **POST** `/auth/inscription`
- **ID**: `POST /auth/inscription`
- **Description**: Inscription d'un nouveau citoyen
- **Body**: `InscriptionRequest`
- **Réponse**: `MessageResponse`

### Connexion par téléphone
- **POST** `/auth/connexion-telephone`
- **ID**: `POST /auth/connexion-telephone`
- **Description**: Connexion par téléphone uniquement - Envoie un code SMS
- **Body**: `ConnexionTelephoneRequest`
- **Réponse**: `MessageResponse`

### Connexion (ancienne méthode)
- **POST** `/auth/connexion`
- **ID**: `POST /auth/connexion`
- **Description**: Connexion d'un citoyen - Envoie un code SMS
- **Body**: `ConnexionRequest`
- **Réponse**: `MessageResponse`

### Vérification SMS
- **POST** `/auth/verifier-sms`
- **ID**: `POST /auth/verifier-sms`
- **Description**: Vérification du code SMS et connexion
- **Body**: `VerificationSmsRequest`
- **Réponse**: `JwtResponse`

### Vérification email
- **GET** `/auth/verify`
- **ID**: `GET /auth/verify`
- **Description**: Vérification de l'email via code
- **Paramètres**: `code` (query parameter)
- **Réponse**: `MessageResponse`

### Profil utilisateur
- **GET** `/auth/profil`
- **ID**: `GET /auth/profil`
- **Description**: Récupération du profil du citoyen connecté
- **Réponse**: `Citoyen`

### Mise à jour profil
- **PUT** `/auth/profil`
- **ID**: `PUT /auth/profil`
- **Description**: Mise à jour du profil du citoyen connecté
- **Body**: `MiseAJourProfilRequest`
- **Réponse**: `MessageResponse`

### Déconnexion
- **POST** `/auth/deconnexion`
- **ID**: `POST /auth/deconnexion`
- **Description**: Déconnexion du citoyen
- **Réponse**: `MessageResponse`

---

## 📂 CATÉGORIES (`/categories`)

### Lister toutes les catégories
- **GET** `/categories`
- **ID**: `GET /categories`
- **Description**: Récupère toutes les catégories
- **Réponse**: `List<CategorieResponse>`

### Obtenir une catégorie par ID
- **GET** `/categories/{id}`
- **ID**: `GET /categories/{id}`
- **Description**: Récupère une catégorie par son ID
- **Paramètres**: `id` (path parameter)
- **Réponse**: `CategorieResponse`

### Créer une catégorie (Admin)
- **POST** `/categories`
- **ID**: `POST /categories`
- **Description**: Crée une nouvelle catégorie (Admin uniquement)
- **Body**: `CategorieRequest`
- **Réponse**: `CategorieResponse`
- **Autorisation**: `ADMIN`

### Modifier une catégorie (Admin)
- **PUT** `/categories/{id}`
- **ID**: `PUT /categories/{id}`
- **Description**: Met à jour une catégorie (Admin uniquement)
- **Paramètres**: `id` (path parameter)
- **Body**: `CategorieRequest`
- **Réponse**: `CategorieResponse`
- **Autorisation**: `ADMIN`

### Supprimer une catégorie (Admin)
- **DELETE** `/categories/{id}`
- **ID**: `DELETE /categories/{id}`
- **Description**: Supprime une catégorie (Admin uniquement)
- **Paramètres**: `id` (path parameter)
- **Réponse**: `MessageResponse`
- **Autorisation**: `ADMIN`

---

## 📁 SOUS-CATÉGORIES (`/sous-categories`)

### Lister toutes les sous-catégories
- **GET** `/sous-categories`
- **ID**: `GET /sous-categories`
- **Description**: Récupère toutes les sous-catégories
- **Réponse**: `List<SousCategorieResponse>`

### Obtenir une sous-catégorie par ID
- **GET** `/sous-categories/{id}`
- **ID**: `GET /sous-categories/{id}`
- **Description**: Récupère une sous-catégorie par son ID
- **Paramètres**: `id` (path parameter)
- **Réponse**: `SousCategorieResponse`

### Obtenir les sous-catégories d'une catégorie
- **GET** `/sous-categories/categorie/{categorieId}`
- **ID**: `GET /sous-categories/categorie/{categorieId}`
- **Description**: Récupère les sous-catégories d'une catégorie
- **Paramètres**: `categorieId` (path parameter)
- **Réponse**: `List<SousCategorieResponse>`

### Créer une sous-catégorie (Admin)
- **POST** `/sous-categories`
- **ID**: `POST /sous-categories`
- **Description**: Crée une nouvelle sous-catégorie (Admin uniquement)
- **Body**: `SousCategorieRequest`
- **Réponse**: `SousCategorieResponse`
- **Autorisation**: `ADMIN`

### Modifier une sous-catégorie (Admin)
- **PUT** `/sous-categories/{id}`
- **ID**: `PUT /sous-categories/{id}`
- **Description**: Met à jour une sous-catégorie (Admin uniquement)
- **Paramètres**: `id` (path parameter)
- **Body**: `SousCategorieRequest`
- **Réponse**: `SousCategorieResponse`
- **Autorisation**: `ADMIN`

### Supprimer une sous-catégorie (Admin)
- **DELETE** `/sous-categories/{id}`
- **ID**: `DELETE /sous-categories/{id}`
- **Description**: Supprime une sous-catégorie (Admin uniquement)
- **Paramètres**: `id` (path parameter)
- **Réponse**: `MessageResponse`
- **Autorisation**: `ADMIN`

---

## 📋 PROCÉDURES (`/procedures`)

### Lister toutes les procédures
- **GET** `/procedures`
- **ID**: `GET /procedures`
- **Description**: Récupère toutes les procédures
- **Réponse**: `List<ProcedureResponse>`

### Obtenir une procédure par ID
- **GET** `/procedures/{id}`
- **ID**: `GET /procedures/{id}`
- **Description**: Récupère une procédure par son ID
- **Paramètres**: `id` (path parameter)
- **Réponse**: `ProcedureResponse`

### Obtenir les procédures par catégorie
- **GET** `/procedures/categorie/{categorieId}`
- **ID**: `GET /procedures/categorie/{categorieId}`
- **Description**: Récupère les procédures d'une catégorie
- **Paramètres**: `categorieId` (path parameter)
- **Réponse**: `List<ProcedureResponse>`

### Obtenir les procédures par sous-catégorie
- **GET** `/procedures/sous-categorie/{sousCategorieId}`
- **ID**: `GET /procedures/sous-categorie/{sousCategorieId}`
- **Description**: Récupère les procédures d'une sous-catégorie
- **Paramètres**: `sousCategorieId` (path parameter)
- **Réponse**: `List<ProcedureResponse>`

### Rechercher des procédures
- **GET** `/procedures/rechercher`
- **ID**: `GET /procedures/rechercher`
- **Description**: Recherche des procédures par nom ou titre
- **Paramètres**: `q` (query parameter)
- **Réponse**: `List<ProcedureResponse>`

### Créer une procédure (Admin)
- **POST** `/procedures`
- **ID**: `POST /procedures`
- **Description**: Crée une nouvelle procédure (Admin uniquement)
- **Body**: `ProcedureRequest`
- **Réponse**: `ProcedureResponse`
- **Autorisation**: `ADMIN`

### Modifier une procédure (Admin)
- **PUT** `/procedures/{id}`
- **ID**: `PUT /procedures/{id}`
- **Description**: Met à jour une procédure (Admin uniquement)
- **Paramètres**: `id` (path parameter)
- **Body**: `ProcedureRequest`
- **Réponse**: `ProcedureResponse`
- **Autorisation**: `ADMIN`

### Supprimer une procédure (Admin)
- **DELETE** `/procedures/{id}`
- **ID**: `DELETE /procedures/{id}`
- **Description**: Supprime une procédure (Admin uniquement)
- **Paramètres**: `id` (path parameter)
- **Réponse**: `MessageResponse`
- **Autorisation**: `ADMIN`

---

## 🤖 CHATBOT DJELIA (`/chatbot`)

### Chat simple
- **POST** `/chatbot/chat`
- **ID**: `POST /chatbot/chat`
- **Description**: Chat avec Djelia AI dans différentes langues
- **Body**: `ChatRequest`
- **Réponse**: `ChatResponse`

### Chat avec synthèse vocale
- **POST** `/chatbot/chat-audio`
- **ID**: `POST /chatbot/chat-audio`
- **Description**: Chat avec Djelia AI + génération audio en bambara
- **Body**: `ChatRequest`
- **Réponse**: `ChatResponse`

### Traduction de texte
- **POST** `/chatbot/translate`
- **ID**: `POST /chatbot/translate`
- **Description**: Traduit un texte du français vers le bambara ou vice versa
- **Body**: `TranslationRequest`
- **Réponse**: `TranslationResponse`

### Synthèse vocale
- **POST** `/chatbot/speak`
- **ID**: `POST /chatbot/speak`
- **Description**: Génère un audio à partir d'un texte en bambara
- **Body**: `SpeakRequest`
- **Réponse**: `SpeakResponse`

### Traduction rapide FR → BM
- **POST** `/chatbot/translate/fr-to-bm`
- **ID**: `POST /chatbot/translate/fr-to-bm`
- **Description**: Traduction rapide du français vers le bambara
- **Body**: `String` (texte à traduire)
- **Réponse**: `TranslationResponse`

### Traduction rapide BM → FR
- **POST** `/chatbot/translate/bm-to-fr`
- **ID**: `POST /chatbot/translate/bm-to-fr`
- **Description**: Traduction rapide du bambara vers le français
- **Body**: `String` (texte à traduire)
- **Réponse**: `TranslationResponse`

### Vérification connectivité
- **GET** `/chatbot/health`
- **ID**: `GET /chatbot/health`
- **Description**: Vérifie si le service Djelia AI est accessible
- **Réponse**: `{"status": "OK/KO", "message": "..."}`

### Lecture audio automatique
- **POST** `/chatbot/read-audio`
- **ID**: `POST /chatbot/read-audio`
- **Description**: Traduit un texte français et le lit en bambara
- **Body**: `String` (texte français à lire)
- **Réponse**: `SpeakResponse`

### Lecture audio rapide
- **POST** `/chatbot/read-quick`
- **ID**: `POST /chatbot/read-quick`
- **Description**: Version simplifiée pour l'icône audio du frontend
- **Body**: `String` (texte français à lire)
- **Réponse**: `{"success": boolean, "audioUrl": string, "originalText": string, "translatedText": string}`

### Test traduction
- **GET** `/chatbot/test-translate`
- **ID**: `GET /chatbot/test-translate`
- **Description**: Test rapide de traduction avec un texte prédéfini
- **Réponse**: `TranslationResponse`

---

## 🔔 NOTIFICATIONS (`/notifications`)

### Obtenir toutes les notifications
- **GET** `/notifications`
- **ID**: `GET /notifications`
- **Description**: Récupère toutes les notifications du citoyen connecté
- **Réponse**: `List<NotificationResponse>`

### Obtenir les notifications non lues
- **GET** `/notifications/non-lues`
- **ID**: `GET /notifications/non-lues`
- **Description**: Récupère les notifications non lues
- **Réponse**: `List<NotificationResponse>`

### Compter les notifications non lues
- **GET** `/notifications/count-non-lues`
- **ID**: `GET /notifications/count-non-lues`
- **Description**: Compte les notifications non lues
- **Réponse**: `Long`

### Marquer une notification comme lue
- **PUT** `/notifications/{id}/lire`
- **ID**: `PUT /notifications/{id}/lire`
- **Description**: Marque une notification comme lue
- **Paramètres**: `id` (path parameter)
- **Réponse**: `NotificationResponse`

### Marquer toutes les notifications comme lues
- **PUT** `/notifications/lire-tout`
- **ID**: `PUT /notifications/lire-tout`
- **Description**: Marque toutes les notifications comme lues
- **Réponse**: `Void`

---

## 📢 SIGNALEMENTS (`/signalements`)

### Créer un signalement
- **POST** `/signalements`
- **ID**: `POST /signalements`
- **Description**: Crée un nouveau signalement
- **Body**: `SignalementRequest`
- **Réponse**: `MessageResponse`

### Obtenir mes signalements
- **GET** `/signalements`
- **ID**: `GET /signalements`
- **Description**: Récupère tous les signalements du citoyen connecté
- **Réponse**: `List<SignalementSimpleResponse>`

### Obtenir un signalement spécifique
- **GET** `/signalements/{id}`
- **ID**: `GET /signalements/{id}`
- **Description**: Récupère un signalement spécifique
- **Paramètres**: `id` (path parameter)
- **Réponse**: `SignalementResponse`

### Modifier un signalement
- **PUT** `/signalements/{id}`
- **ID**: `PUT /signalements/{id}`
- **Description**: Modifie un signalement (seulement si moins de 15 minutes)
- **Paramètres**: `id` (path parameter)
- **Body**: `ModifierSignalementRequest`
- **Réponse**: `MessageResponse`

### Supprimer un signalement
- **DELETE** `/signalements/{id}`
- **ID**: `DELETE /signalements/{id}`
- **Description**: Supprime un signalement (seulement si moins de 15 minutes)
- **Paramètres**: `id` (path parameter)
- **Réponse**: `MessageResponse`

---

## 📊 STRUCTURE DES DONNÉES DES PROCÉDURES

**MISE À JOUR IMPORTANTE** : Depuis la dernière version, toutes les réponses de procédures incluent maintenant **les références légales (lois et articles)**.

Chaque procédure contient les informations suivantes :

### Informations de base
- **ID**: Identifiant unique
- **Nom**: Nom de la procédure
- **Titre**: Titre court de la procédure
- **Description**: Description détaillée
- **Délai**: Délai de traitement
- **URL vers formulaire**: Lien vers le formulaire en ligne

### Relations et détails
- **Catégorie**: Catégorie principale de la procédure
- **Sous-catégorie**: Sous-catégorie spécifique
- **Centre de traitement**: Centre où effectuer la procédure
  - Nom du centre
  - Adresse
  - Horaires d'ouverture
  - Coordonnées GPS
  - Téléphone
  - Email
- **Coût**: Frais associés à la procédure
  - Nom du coût
  - Prix en FCFA
  - Description
- **Documents requis**: Liste des documents nécessaires
  - Nom du document
  - Description
  - Obligatoire ou non
  - URL vers modèle si disponible
- **Étapes**: Étapes à suivre pour la procédure
  - Nom de l'étape
  - Description
  - Niveau d'ordre
- **Références légales**: Articles de loi associés
  - Description de la loi
  - Article consultable
  - Lien audio en bambara

### Métadonnées
- **Date de création**: Date de création de la procédure
- **Date de modification**: Dernière modification

---

## 🔒 SÉCURITÉ ET AUTORISATIONS

### Endpoints publics
- Tous les endpoints d'authentification
- Consultation des catégories, sous-catégories et procédures
- Endpoints du chatbot Djelia
- Création et consultation des signalements

### Endpoints protégés (authentification requise)
- Gestion du profil utilisateur
- Notifications
- Signalements personnels

### Endpoints administrateur (`ADMIN` uniquement)
- Création, modification et suppression des catégories
- Création, modification et suppression des sous-catégories
- Création, modification et suppression des procédures

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

## 🌐 CORS ET CONFIGURATION

- **Origins autorisées**: `*` (toutes)
- **Max Age**: 3600 secondes
- **Headers autorisés**: Tous les headers standards

---

*Cette documentation est générée automatiquement et reflète l'état actuel de l'API FasoDocs.*
