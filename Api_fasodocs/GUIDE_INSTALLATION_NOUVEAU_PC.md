# 📦 Guide d'Installation sur un Nouveau PC

Ce guide explique comment installer et configurer FasoDocs Backend sur un nouveau PC pour obtenir les **mêmes données et configurations**.

---

## ✅ Ce qui sera IDENTIQUE (automatique)

### 1. **Données de la Base de Données**
- ✅ **Toutes les procédures** (83 procédures complètes)
- ✅ **Toutes les catégories et sous-catégories**
- ✅ **Tous les documents requis**
- ✅ **Toutes les étapes**
- ✅ **Tous les coûts**
- ✅ **Tous les centres**
- ✅ **Toutes les lois/articles**
- ✅ **Structure des quiz** (tables, migrations Flyway)
- ✅ **30 quiz FACILE, 30 quiz MOYEN, 30 quiz DIFFICILE** (générés automatiquement au démarrage)

**Pourquoi ?** 
- Le fichier `fasodocs-data-complete.sql` est inclus dans le projet et sera chargé automatiquement au premier démarrage via `DataLoader`.
- Les migrations Flyway dans `src/main/resources/db/migration/` créent automatiquement la structure des quiz.
- Le `QuizInitializer` génère automatiquement les 30 quiz par niveau au démarrage.

### 2. **Fichiers Audio**
- ✅ Tous les fichiers audio des procédures (37 fichiers .aac)
- ✅ Stockés dans `src/main/resources/static/audio/procedures/`

### 3. **Structure de la Base de Données**
- ✅ Migrations Flyway dans `src/main/resources/db/migration/`
  - V11 : Création des tables de quiz
  - V12 : Ajout du système de niveaux (FACILE, MOYEN, DIFFICILE)
- ✅ Schéma de base de données créé automatiquement
- ✅ Tables de quiz créées automatiquement
- ✅ Table `quiz_progression` pour suivre la progression des utilisateurs

### 4. **Code Source**
- ✅ Toute la logique métier
- ✅ Tous les endpoints API
- ✅ Toutes les fonctionnalités

---

## ⚙️ Ce qui nécessite une CONFIGURATION

### 1. **Base de Données MySQL** ⚠️ OBLIGATOIRE

#### Étape 1 : Installer MySQL
```bash
# Télécharger MySQL depuis https://dev.mysql.com/downloads/
# Ou utiliser un gestionnaire de paquets
```

#### Étape 2 : Créer la base de données
```sql
CREATE DATABASE FasoDocs CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

#### Étape 3 : Configurer dans `application.properties`
```properties
# Modifier selon votre installation MySQL
spring.datasource.url=jdbc:mysql://localhost:3306/FasoDocs?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true
spring.datasource.username=root          # ⚠️ Votre utilisateur MySQL
spring.datasource.password=votre_mot_de_passe  # ⚠️ Votre mot de passe MySQL
```

**⚠️ IMPORTANT** : 
- Les données seront chargées automatiquement au premier démarrage si la base est vide.
- Les migrations Flyway s'exécutent automatiquement au démarrage.
- Les 30 quiz par niveau seront générés automatiquement au démarrage via `QuizInitializer`.

---

### 2. **Configurations Sensibles** ⚠️ À MODIFIER

#### A. Email (Gmail)
```properties
# Dans application.properties
spring.mail.username=votre_email@gmail.com        # ⚠️ Votre email
spring.mail.password=votre_app_password           # ⚠️ Mot de passe d'application Gmail
```

**Note** : Pour Gmail, vous devez créer un "Mot de passe d'application" dans les paramètres de sécurité.

#### B. Orange SMS API (Optionnel)
```properties
# Si vous avez vos propres credentials Orange
orange.sms.enabled=true
orange.sms.client.id=votre_client_id
orange.sms.client.secret=votre_client_secret
orange.sms.sender.address=tel:+223XXXXXXXX
```

**Note** : Si vous n'avez pas de credentials Orange, mettez `orange.sms.enabled=false` et les codes SMS apparaîtront dans les logs.

#### C. JWT Secret (Recommandé pour la production)
```properties
# Générer une nouvelle clé secrète pour la production
jwt.secret=VotreCleSecreteTresLongueEtSecuriseePourHS512Algorithm2025
```

---

### 3. **Variables d'Environnement (Recommandé)**

Pour éviter de hardcoder les configurations sensibles, créez un fichier `.env` ou utilisez des variables d'environnement :

#### Option 1 : Fichier `.env` (nécessite `spring-boot-dotenv`)
```env
DB_URL=jdbc:mysql://localhost:3306/FasoDocs
DB_USERNAME=root
DB_PASSWORD=votre_mot_de_passe
EMAIL_USERNAME=votre_email@gmail.com
EMAIL_PASSWORD=votre_app_password
JWT_SECRET=VotreCleSecrete
```

#### Option 2 : Variables d'environnement système
```bash
# Windows PowerShell
$env:SPRING_DATASOURCE_PASSWORD="votre_mot_de_passe"
$env:SPRING_MAIL_PASSWORD="votre_app_password"

# Linux/Mac
export SPRING_DATASOURCE_PASSWORD="votre_mot_de_passe"
export SPRING_MAIL_PASSWORD="votre_app_password"
```

Puis dans `application.properties` :
```properties
spring.datasource.password=${SPRING_DATASOURCE_PASSWORD:}
spring.mail.password=${SPRING_MAIL_PASSWORD:}
```

---

## 📋 Checklist d'Installation

### Avant de cloner
- [ ] Java 17 installé
- [ ] Maven installé (ou utiliser `mvnw.cmd`)
- [ ] MySQL installé et démarré

### Après le clonage
- [ ] Cloner le repository
- [ ] Créer la base de données `FasoDocs`
- [ ] Modifier `application.properties` avec vos credentials
- [ ] Lancer l'application : `mvnw.cmd spring-boot:run` ou via IDE
- [ ] Vérifier que les données sont chargées (logs : "✅ Données FasoDocs chargées avec succès !")

---

## 🔍 Vérification

### 1. Vérifier que les données sont chargées
```sql
-- Se connecter à MySQL
USE FasoDocs;

-- Vérifier les catégories
SELECT COUNT(*) FROM categories;  -- Devrait être ~7

-- Vérifier les procédures
SELECT COUNT(*) FROM procedures;  -- Devrait être ~83

-- Vérifier les étapes
SELECT COUNT(*) FROM etapes;  -- Devrait être ~458
```

### 2. Vérifier les logs au démarrage
Cherchez dans les logs :
```
✅ Données FasoDocs chargées avec succès !
📊 Statistiques:
   - Catégories: 7
   - Procédures: 83
   - Étapes: 458
   ...

🎯 Initialisation des quiz...
📝 Génération de 30 quiz par niveau (FACILE, MOYEN, DIFFICILE)...
✅ Tous les quiz ont été générés avec succès (30 par niveau)
```

### 3. Vérifier que les quiz sont générés
```sql
-- Vérifier les quiz générés
SELECT niveau, COUNT(*) as nombre_quiz 
FROM quiz_journaliers 
GROUP BY niveau;
-- Devrait retourner: FACILE: 30, MOYEN: 30, DIFFICILE: 30

-- Vérifier la progression des utilisateurs
SELECT COUNT(*) FROM quiz_progression WHERE niveau = 'FACILE';
-- Devrait retourner le nombre d'utilisateurs (FACILE débloqué par défaut)
```

---

## 🚨 Problèmes Courants

### Problème 1 : Base de données non trouvée
```
Error: Unknown database 'FasoDocs'
```
**Solution** : Créer la base de données manuellement :
```sql
CREATE DATABASE FasoDocs CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

### Problème 2 : Erreur de connexion MySQL
```
Access denied for user 'root'@'localhost'
```
**Solution** : Vérifier le nom d'utilisateur et le mot de passe dans `application.properties`.

### Problème 3 : Données non chargées
```
⚠️ Données FasoDocs déjà présentes. Chargement ignoré.
```
**Solution** : C'est normal si la base contient déjà des données. Pour forcer le rechargement, vider les tables ou supprimer la base.

### Problème 4 : Fichiers audio non trouvés
**Solution** : Les fichiers audio sont dans le projet, pas besoin de configuration supplémentaire.

### Problème 5 : Quiz non générés
```
⚠️ Aucun quiz disponible
```
**Solution** : 
- Vérifier que les migrations Flyway V11 et V12 ont été exécutées
- Vérifier dans les logs : "✅ Tous les quiz ont été générés avec succès (30 par niveau)"
- Si les quiz ne sont pas générés, redémarrer l'application (le `QuizInitializer` les génère au démarrage)

### Problème 6 : Migration V12 échoue (colonne niveau existe déjà)
```
#1060 - Duplicate column name 'niveau'
```
**Solution** : La migration V12 a été mise à jour pour vérifier l'existence de la colonne avant de l'ajouter. Si l'erreur persiste, la colonne existe déjà et vous pouvez ignorer cette erreur.

---

## 📝 Résumé

| Élément | Identique ? | Action Requise |
|---------|------------|----------------|
| **Données SQL** | ✅ OUI | Aucune (chargement automatique) |
| **Fichiers audio** | ✅ OUI | Aucune (inclus dans le projet) |
| **Structure DB** | ✅ OUI | Aucune (migrations automatiques) |
| **Quiz (30 par niveau)** | ✅ OUI | Aucune (génération automatique au démarrage) |
| **Progression utilisateurs** | ✅ OUI | Aucune (FACILE débloqué automatiquement) |
| **Code source** | ✅ OUI | Aucune |
| **Base MySQL** | ❌ NON | Installer et créer la base |
| **Credentials DB** | ❌ NON | Configurer dans `application.properties` |
| **Email** | ❌ NON | Configurer Gmail app password |
| **Orange SMS** | ❌ NON | Optionnel (peut être désactivé) |
| **JWT Secret** | ❌ NON | Recommandé de changer en production |
| **Config quiz** | ✅ OUI | Déjà dans `application.properties` (30 quiz, 30 requis) |

---

## 🎯 Conclusion

**OUI**, vous aurez les **mêmes données** automatiquement grâce au chargement automatique des scripts SQL.

**OUI**, vous aurez les **mêmes quiz** (30 FACILE, 30 MOYEN, 30 DIFFICILE) générés automatiquement au démarrage.

**OUI**, vous aurez la **même structure de base de données** grâce aux migrations Flyway.

**NON**, vous n'aurez pas les **mêmes configurations** (base de données, credentials) - vous devez les configurer selon votre environnement.

**Recommandation** : Créez un fichier `application-local.properties` pour vos configurations locales et gardez `application.properties` pour les valeurs par défaut.

---

## 📦 Résumé des Fichiers Inclus dans le Projet

### Fichiers de données SQL
- ✅ `src/main/resources/fasodocs-data-complete.sql` - Données de référence (procédures, catégories, etc.)
- ✅ `src/main/resources/fasodocs-full-dump.sql` - Dump complet (optionnel, si activé)

### Migrations Flyway
- ✅ `src/main/resources/db/migration/V11__create_quiz_tables.sql` - Création des tables de quiz
- ✅ `src/main/resources/db/migration/V12__add_quiz_niveaux_system.sql` - Système de niveaux (FACILE, MOYEN, DIFFICILE)

### Fichiers audio
- ✅ `src/main/resources/static/audio/procedures/*.aac` - Fichiers audio des procédures

### Configuration
- ✅ `src/main/resources/application.properties` - Toutes les configurations (quiz, email, SMS, etc.)

### Code d'initialisation
- ✅ `DataLoader.java` - Charge les données SQL au démarrage
- ✅ `QuizInitializer.java` - Génère les 30 quiz par niveau au démarrage
- ✅ `DataInitializer.java` - Initialise le compte admin par défaut

**Tous ces fichiers sont inclus dans le repository Git, donc ils seront présents lors du clonage !**

