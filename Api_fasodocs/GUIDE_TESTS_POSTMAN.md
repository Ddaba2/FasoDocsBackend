# 🧪 Guide de Tests Postman - FasoDocs API

## 📋 Vue d'ensemble

Cette collection Postman complète permet de tester toutes les fonctionnalités du backend FasoDocs de A à Z. Elle inclut des tests automatisés, des vérifications de sécurité, et des tests de performance.

## 🚀 Installation et Configuration

### 1. Import des fichiers
1. Ouvrez Postman
2. Importez la collection : `FasoDocs_API_Complete_Test.postman_collection.json`
3. Importez l'environnement : `FasoDocs_Environment.postman_environment.json`
4. Sélectionnez l'environnement "FasoDocs Environment"

### 2. Configuration de l'environnement
- **base_url** : `http://localhost:8080` (par défaut)
- Les autres variables sont automatiquement remplies lors des tests

## 📊 Structure de la Collection

### 🔐 1. Authentification (7 tests)
- **Inscription** : Création d'un nouveau compte citoyen
- **Connexion** : Envoi du code SMS de vérification
- **Vérification SMS** : Validation du code et obtention du JWT
- **Connexion Admin** : Connexion avec le compte administrateur
- **Profil** : Récupération et mise à jour du profil
- **Déconnexion** : Fermeture de session

### 📋 2. Procédures (7 tests)
- **Liste complète** : Récupération de toutes les procédures
- **Par ID** : Récupération d'une procédure spécifique
- **Recherche** : Recherche par mot-clé
- **Par catégorie** : Filtrage par catégorie
- **Création** : Création d'une nouvelle procédure (Admin)
- **Mise à jour** : Modification d'une procédure (Admin)
- **Suppression** : Suppression d'une procédure (Admin)

### 🔔 3. Notifications (5 tests)
- **Liste complète** : Toutes les notifications
- **Non lues** : Notifications non consultées
- **Compteur** : Nombre de notifications non lues
- **Marquer comme lue** : Marquage individuel
- **Tout marquer** : Marquage en lot

### 🔍 4. Tests de Sécurité (3 tests)
- **Sans token** : Accès refusé sans authentification
- **Token invalide** : Rejet des tokens corrompus
- **Permissions** : Vérification des rôles (Admin vs Utilisateur)

### 📊 5. Tests de Performance (2 tests)
- **Charge liste** : Temps de réponse < 2s
- **Charge recherche** : Temps de réponse < 1.5s

### 🌐 6. Tests d'Intégration (2 tests)
- **Flux inscription** : Inscription → Connexion automatique
- **Flux procédure** : Création → Récupération → Suppression

## 🎯 Ordre d'Exécution Recommandé

### Phase 1 : Tests de Base
1. **Authentification** → **Connexion Admin** (pour les tests admin)
2. **Procédures** → **Obtenir toutes les procédures** (pour récupérer les IDs)
3. **Notifications** → **Obtenir toutes les notifications**

### Phase 2 : Tests Fonctionnels
4. **Authentification** → **Inscription** → **Connexion** → **Vérification SMS**
5. **Procédures** → Tests de recherche et filtrage
6. **Notifications** → Tests de gestion

### Phase 3 : Tests Admin
7. **Procédures** → **Créer** → **Mettre à jour** → **Supprimer**

### Phase 4 : Tests de Sécurité
8. **Tests de Sécurité** → Tous les tests

### Phase 5 : Tests de Performance
9. **Tests de Performance** → Tous les tests

### Phase 6 : Tests d'Intégration
10. **Tests d'Intégration** → Tous les tests

## 🔧 Variables d'Environnement Automatiques

La collection gère automatiquement ces variables :

| Variable | Description | Remplie par |
|----------|-------------|-------------|
| `jwt_token` | Token utilisateur normal | Test de vérification SMS |
| `admin_jwt_token` | Token administrateur | Test de connexion admin |
| `user_id` | ID utilisateur connecté | Test de vérification SMS |
| `admin_user_id` | ID administrateur | Test de connexion admin |
| `procedure_id` | ID d'une procédure existante | Test de liste des procédures |
| `categorie_id` | ID d'une catégorie | Test de récupération de procédure |
| `notification_id` | ID d'une notification | Test de liste des notifications |

## ✅ Tests Automatisés

Chaque requête inclut des tests automatisés qui vérifient :

### Tests Généraux
- ✅ Code de statut HTTP correct
- ✅ Temps de réponse acceptable (< 5s)
- ✅ Présence des en-têtes CORS
- ✅ Structure JSON valide

### Tests Spécifiques
- ✅ **Authentification** : Tokens JWT, messages de succès
- ✅ **Procédures** : Structure des données, relations
- ✅ **Notifications** : État lu/non lu, compteurs
- ✅ **Sécurité** : Rejet des accès non autorisés
- ✅ **Performance** : Temps de réponse optimaux

## 🚨 Gestion des Erreurs

### Codes d'Erreur Attendus
- **400** : Données invalides, validation échouée
- **401** : Non authentifié, token manquant/invalide
- **403** : Accès refusé, permissions insuffisantes
- **404** : Ressource non trouvée
- **500** : Erreur serveur interne

### Messages d'Erreur
Tous les messages d'erreur suivent le format :
```json
{
    "success": false,
    "message": "Description de l'erreur",
    "timestamp": "2025-01-XX..."
}
```

## 📈 Métriques de Performance

### Temps de Réponse Acceptables
- **Authentification** : < 1s
- **Liste des procédures** : < 2s
- **Recherche** : < 1.5s
- **Notifications** : < 1s
- **Opérations CRUD** : < 2s

### Tests de Charge
- Exécutez la collection plusieurs fois pour tester la stabilité
- Surveillez les temps de réponse sous charge
- Vérifiez la cohérence des données

## 🔄 Exécution en Lot

### Collection Runner
1. Ouvrez la collection dans Postman
2. Cliquez sur "Run collection"
3. Sélectionnez les dossiers à tester
4. Configurez les itérations (recommandé : 1-3)
5. Lancez l'exécution

### Newman (CLI)
```bash
# Installation
npm install -g newman

# Exécution
newman run FasoDocs_API_Complete_Test.postman_collection.json \
  -e FasoDocs_Environment.postman_environment.json \
  --reporters cli,html \
  --reporter-html-export rapport-tests.html
```

## 🐛 Dépannage

### Problèmes Courants

#### 1. Erreur de connexion
- Vérifiez que le serveur FasoDocs est démarré
- Vérifiez l'URL dans `base_url`
- Vérifiez que le port 8080 est libre

#### 2. Erreurs d'authentification
- Vérifiez que la base de données est initialisée
- Vérifiez les credentials admin par défaut
- Vérifiez la configuration JWT

#### 3. Données manquantes
- Vérifiez que `app.init.chatbot-data=true` dans `application.properties`
- Redémarrez l'application pour charger les données
- Vérifiez les logs d'initialisation

#### 4. Tests qui échouent
- Vérifiez l'ordre d'exécution des tests
- Vérifiez que les variables d'environnement sont remplies
- Consultez les logs de l'application

### Logs Utiles
```bash
# Logs d'application
tail -f logs/application.log

# Logs de base de données
# Vérifiez les requêtes SQL dans les logs Hibernate
```

## 📊 Rapport de Tests

### Exécution Manuelle
1. Exécutez la collection complète
2. Consultez l'onglet "Test Results"
3. Exportez le rapport si nécessaire

### Exécution Automatisée
```bash
# Génération d'un rapport HTML
newman run FasoDocs_API_Complete_Test.postman_collection.json \
  -e FasoDocs_Environment.postman_environment.json \
  --reporters html \
  --reporter-html-export rapport-fasodocs-$(date +%Y%m%d).html
```

## 🎉 Validation du Backend

### Critères de Succès
- ✅ **100% des tests passent**
- ✅ **Temps de réponse < seuils définis**
- ✅ **Aucune erreur de sécurité**
- ✅ **Données cohérentes**
- ✅ **Flux d'intégration fonctionnels**

### Checklist de Validation
- [ ] Authentification complète (inscription → connexion → profil)
- [ ] Gestion des procédures (CRUD complet)
- [ ] Système de notifications fonctionnel
- [ ] Sécurité et autorisations respectées
- [ ] Performance acceptable
- [ ] Intégration des flux métier

## 📞 Support

En cas de problème :
1. Consultez les logs de l'application
2. Vérifiez la configuration de la base de données
3. Vérifiez les variables d'environnement Postman
4. Consultez la documentation API (Swagger UI)

---

**🎯 Objectif** : Valider que le backend FasoDocs est prêt pour la production avec toutes les fonctionnalités opérationnelles et sécurisées.
