# 📊 Charger TOUTES les Données FasoDocs

## 🔍 Diagnostic

D'après les logs, vous avez :
- ✅ **7 catégories** chargées
- ✅ **78 sous-catégories** chargées
- ❌ **Beaucoup d'erreurs SQL** pour le reste

**Problème** : Le script SQL a des dépendances complexes (procédures → centres → étapes → documents), et certaines insertions échouent car les données parentes n'existent pas encore.

---

## ✅ SOLUTION : Charger les Données Manuellement

Il y a **2 méthodes** pour charger toutes les données :

---

## 🎯 MÉTHODE 1 : Via MySQL Directement (RECOMMANDÉ)

### Étape 1 : Ouvrir MySQL Workbench ou MySQL CLI

**MySQL Workbench** :
1. Ouvrez MySQL Workbench
2. Connectez-vous à votre serveur local
3. Sélectionnez la base `FasoDocs`

**OU MySQL CLI** :
```bash
mysql -u root -p
USE FasoDocs;
```

---

### Étape 2 : Exécuter le Script SQL Complet

**Dans MySQL Workbench** :
1. Menu : **File** → **Open SQL Script**
2. Sélectionnez : `src/main/resources/fasodocs-data-complete.sql`
3. Cliquez sur l'icône **⚡ Execute** (ou Ctrl+Shift+Enter)
4. Attendez que toutes les requêtes s'exécutent

**OU dans MySQL CLI** :
```bash
source C:/Users/dabad/Desktop/Backend FasoDocs/Api_fasodocs/src/main/resources/fasodocs-data-complete.sql
```

---

### Étape 3 : Vérifier les Données

Exécutez ce script :

```sql
-- Compter toutes les données
SELECT 'CATEGORIES' as Table_Name, COUNT(*) as Nombre FROM categories
UNION ALL
SELECT 'SOUS_CATEGORIES', COUNT(*) FROM sous_categories
UNION ALL
SELECT 'PROCEDURES', COUNT(*) FROM procedures
UNION ALL
SELECT 'CENTRES', COUNT(*) FROM centres
UNION ALL
SELECT 'ETAPES', COUNT(*) FROM etapes
UNION ALL
SELECT 'DOCUMENTS_REQUIS', COUNT(*) FROM documents_requis
UNION ALL
SELECT 'COUTS', COUNT(*) FROM couts
UNION ALL
SELECT 'LOIS_ARTICLES', COUNT(*) FROM lois_articles;
```

**Résultat attendu** (approximatif) :
```
Table_Name          | Nombre
--------------------|--------
CATEGORIES          | 7
SOUS_CATEGORIES     | 78
PROCEDURES          | 100+
CENTRES             | 50+
ETAPES              | 200+
DOCUMENTS_REQUIS    | 300+
COUTS               | 50+
LOIS_ARTICLES       | 50+
```

---

## 🔧 MÉTHODE 2 : Désactiver le Chargement Auto et Charger Manuellement

Si vous voulez que l'application ne charge PAS automatiquement les données au démarrage :

### Étape 1 : Désactiver le Chargement Auto

Dans `src/main/resources/application.properties` :

```properties
# Initialisation automatique des données du chatbot
# true = Insère automatiquement les catégories et procédures au démarrage
# false = Vous devez exécuter le script SQL manuellement
app.init.chatbot-data=false
```

### Étape 2 : Redémarrer l'Application

L'application démarrera **sans** essayer de charger les données.

### Étape 3 : Charger les Données via MySQL (Méthode 1)

Suivez la **Méthode 1** ci-dessus.

---

## 🧪 MÉTHODE 3 : Script Batch Windows (RAPIDE)

J'ai créé un script pour vous ! Créons-le :

```batch
@echo off
echo ============================================
echo Chargement des donnees FasoDocs completes
echo ============================================
echo.

REM Chemin vers MySQL (ajustez si nécessaire)
set MYSQL_PATH="C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe"

REM Configuration
set DB_NAME=FasoDocs
set DB_USER=root
set DB_PASS=

REM Chemin du script SQL
set SQL_FILE=src\main\resources\fasodocs-data-complete.sql

echo 📊 Chargement des donnees dans la base %DB_NAME%...
echo.

%MYSQL_PATH% -u %DB_USER% %DB_NAME% < %SQL_FILE%

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ✅ Donnees chargees avec succes !
    echo.
    echo 🔍 Verification...
    %MYSQL_PATH% -u %DB_USER% %DB_NAME% -e "SELECT 'PROCEDURES' as Table_Name, COUNT(*) as Nombre FROM procedures UNION ALL SELECT 'CENTRES', COUNT(*) FROM centres UNION ALL SELECT 'ETAPES', COUNT(*) FROM etapes;"
) else (
    echo.
    echo ❌ Erreur lors du chargement des donnees
)

echo.
echo ============================================
pause
```

**Sauvegardez ce fichier** : `charger-donnees.bat`

**Puis exécutez** : Double-cliquez sur `charger-donnees.bat`

---

## 📋 VÉRIFICATION COMPLÈTE

Une fois les données chargées, vérifiez avec ce script SQL :

```sql
-- Vérification détaillée
SELECT '📊 STATISTIQUES DES DONNÉES' as Info;

SELECT 'Catégories' as Type, COUNT(*) as Total FROM categories;
SELECT 'Sous-catégories' as Type, COUNT(*) as Total FROM sous_categories;
SELECT 'Procédures' as Type, COUNT(*) as Total FROM procedures;
SELECT 'Centres' as Type, COUNT(*) as Total FROM centres;
SELECT 'Étapes' as Type, COUNT(*) as Total FROM etapes;
SELECT 'Documents requis' as Type, COUNT(*) as Total FROM documents_requis;
SELECT 'Coûts' as Type, COUNT(*) as Total FROM couts;
SELECT 'Lois et articles' as Type, COUNT(*) as Total FROM lois_articles;

-- Voir quelques exemples
SELECT '📋 EXEMPLES DE PROCÉDURES' as Info;
SELECT id, titre, delai FROM procedures LIMIT 5;

SELECT '🏢 EXEMPLES DE CENTRES' as Info;
SELECT id, nom, adresse FROM centres LIMIT 5;
```

---

## 🔍 Test API Après Chargement

Une fois les données chargées, testez dans Postman :

### 1. Obtenir toutes les procédures
```http
GET http://localhost:8080/api/procedures
```

**Vous devriez voir beaucoup de procédures !**

### 2. Obtenir les catégories
```http
GET http://localhost:8080/api/categories
```

### 3. Rechercher une procédure
```http
GET http://localhost:8080/api/procedures/rechercher?q=passeport
```

---

## ⚠️ PROBLÈMES COURANTS

### Problème 1 : "Table doesn't exist"

**Solution** : L'application a créé les tables, c'est bon. Chargez juste les données.

### Problème 2 : "Duplicate entry"

**Solution** : Les données ont déjà été partiellement chargées. Options :
1. **Nettoyer la base** :
   ```sql
   -- Attention : Ceci supprime TOUTES les données !
   DELETE FROM lois_articles;
   DELETE FROM documents_requis;
   DELETE FROM etapes;
   DELETE FROM procedures;
   DELETE FROM couts;
   DELETE FROM centres;
   DELETE FROM sous_categories;
   DELETE FROM categories WHERE id > 7; -- Garder les 7 déjà insérées
   ```

2. **Ou recréer la base complètement** :
   ```sql
   DROP DATABASE FasoDocs;
   CREATE DATABASE FasoDocs CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
   ```
   Puis redémarrez l'application et chargez les données.

### Problème 3 : "Foreign key constraint fails"

**Solution** : Le script SQL doit être exécuté **dans l'ordre**. Utilisez la **Méthode 1** (MySQL Workbench) qui exécute tout dans le bon ordre.

---

## 🎯 RECOMMANDATION

**Pour MAINTENANT** :
1. ✅ Utilisez la **Méthode 1** (MySQL Workbench)
2. ✅ Exécutez `fasodocs-data-complete.sql`
3. ✅ Vérifiez les données avec le script de vérification
4. ✅ Testez l'API

**Pour PLUS TARD (Production)** :
- Désactivez `app.init.chatbot-data=false`
- Les données seront déjà en base
- L'application démarrera plus vite

---

## 📊 Résultat Attendu

Après avoir chargé les données complètes, vous devriez avoir :

```
✅ Catégories : 7
✅ Sous-catégories : 78
✅ Procédures : 100+ (toutes les procédures administratives du Mali)
✅ Centres : 50+ (tous les centres de services)
✅ Étapes : 200+ (toutes les étapes de chaque procédure)
✅ Documents requis : 300+ (tous les documents nécessaires)
✅ Coûts : 50+ (tous les coûts associés)
✅ Lois et articles : 50+ (tous les textes juridiques)
```

---

**🚀 Chargez les données maintenant et votre système sera complet !**




