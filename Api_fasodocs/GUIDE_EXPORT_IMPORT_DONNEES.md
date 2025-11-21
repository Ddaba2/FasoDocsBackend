# 📦 Guide d'Export/Import Automatique des Données

Ce guide explique comment utiliser le système d'export/import automatique pour avoir **toutes les données** (y compris les modifications) lors du clonage sur un autre PC.

---

## 🎯 Objectif

Lorsque vous clonez le projet sur un autre PC, vous aurez automatiquement :
- ✅ Toutes les données de référence (procédures, catégories, etc.)
- ✅ **Toutes les données utilisateurs** (citoyens, authentifications, etc.)
- ✅ **Toutes les modifications** apportées à la base de données
- ✅ Configuration complète prête à l'emploi

---

## 🚀 Utilisation Rapide

### Sur le PC Source (où vous faites les modifications)

#### 1. Exporter la base de données complète

**Windows :**
```bash
export-database.bat
```

**Linux/Mac :**
```bash
chmod +x export-database.sh
./export-database.sh
```

Le script crée automatiquement `src/main/resources/fasodocs-full-dump.sql` avec **toutes les données**.

#### 2. Commiter le fichier dans Git

```bash
git add src/main/resources/fasodocs-full-dump.sql
git commit -m "Export complet de la base de données"
git push
```

---

### Sur le PC Destination (après clonage)

#### 1. Cloner le projet

```bash
git clone <votre-repo>
cd Api_fasodocs
```

#### 2. Créer la base de données MySQL

```sql
CREATE DATABASE FasoDocs CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

#### 3. Configurer `application.properties`

Mettre à jour au minimum :
- `spring.datasource.password` (votre mot de passe MySQL)
- Autres credentials si nécessaire

#### 4. Lancer l'application

```bash
./mvnw spring-boot:run
```

**C'est tout !** 🎉

L'application va automatiquement :
- Détecter le fichier `fasodocs-full-dump.sql`
- Importer **toutes les données** (structure + données)
- Vous aurez exactement la même base que sur le PC source

---

## ⚙️ Configuration

### Activer/Désactiver l'import automatique

Dans `application.properties` :

```properties
# true = Importe automatiquement fasodocs-full-dump.sql au démarrage
# false = Utilise seulement fasodocs-data-complete.sql (données de référence)
app.init.full-dump=true
```

### Quand exporter ?

**Exportez la base de données avant chaque commit important** qui inclut des modifications de données :

```bash
# 1. Exporter
export-database.bat

# 2. Commiter
git add src/main/resources/fasodocs-full-dump.sql
git commit -m "Mise à jour des données"
git push
```

---

## 🔄 Workflow Recommandé

### Développement Quotidien

1. **Faire vos modifications** dans l'application
2. **Avant de commiter** : Exporter la base
   ```bash
   export-database.bat
   ```
3. **Commiter** le dump avec vos changements
   ```bash
   git add .
   git commit -m "Ajout fonctionnalité X + export données"
   git push
   ```

### Sur un Nouveau PC

1. **Cloner** le projet
2. **Créer** la base de données MySQL
3. **Configurer** `application.properties`
4. **Lancer** l'application → **Tout est automatique !**

---

## 📁 Fichiers Créés

| Fichier | Description |
|---------|-------------|
| `export-database.bat` | Script Windows pour exporter la base |
| `export-database.sh` | Script Linux/Mac pour exporter la base |
| `src/main/resources/fasodocs-full-dump.sql` | **Dump complet MySQL** (à commiter dans Git) |
| `src/main/resources/fasodocs-data-complete.sql` | Données de référence (fallback) |

---

## 🔍 Comment ça marche ?

### 1. Export (`export-database.bat`)

Le script utilise `mysqldump` pour créer un fichier SQL complet contenant :
- Structure des tables (CREATE TABLE)
- Toutes les données (INSERT)
- Routines, triggers, événements
- Contraintes et clés étrangères

### 2. Import Automatique (`DataLoader.java`)

Au démarrage de l'application :
1. Vérifie si `fasodocs-full-dump.sql` existe
2. Si oui et `app.init.full-dump=true` → Importe le dump complet
3. Si non → Utilise `fasodocs-data-complete.sql` (données de référence)

### 3. Détection Intelligente

L'application détecte automatiquement si la base est vide :
- Si vide → Import automatique
- Si déjà remplie → Ignore l'import (évite les doublons)

---

## ⚠️ Notes Importantes

### Taille du Fichier

Le fichier `fasodocs-full-dump.sql` peut être volumineux (plusieurs MB) s'il contient beaucoup d'utilisateurs. C'est normal !

### Données Sensibles

⚠️ **Attention** : Le dump contient toutes les données, y compris :
- Mots de passe hashés des utilisateurs
- Informations personnelles
- Données de production

**Ne partagez pas ce fichier publiquement** si vous avez des données de production.

### Git LFS (Optionnel)

Pour les gros fichiers, vous pouvez utiliser Git LFS :

```bash
git lfs install
git lfs track "*.sql"
git add .gitattributes
```

---

## 🐛 Dépannage

### Erreur : "mysqldump non trouvé"

**Solution :** Ajoutez MySQL au PATH ou utilisez le chemin complet :
```bash
"C:\Program Files\MySQL\MySQL Server 8.0\bin\mysqldump.exe" ...
```

### Erreur : "Access denied"

**Solution :** Vérifiez le mot de passe MySQL dans le script ou exécutez :
```bash
mysqldump -u root -p FasoDocs > src/main/resources/fasodocs-full-dump.sql
```

### L'import ne fonctionne pas

**Vérifications :**
1. Le fichier `fasodocs-full-dump.sql` existe dans `src/main/resources/`
2. `app.init.full-dump=true` dans `application.properties`
3. La base de données est vide (sinon l'import est ignoré)

**Forcer l'import :** Videz la base et relancez :
```sql
DROP DATABASE FasoDocs;
CREATE DATABASE FasoDocs CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

---

## ✅ Checklist

- [x] Scripts d'export créés (Windows + Linux/Mac)
- [x] Import automatique au démarrage
- [x] Configuration dans `application.properties`
- [x] Détection intelligente (base vide ou non)
- [x] Documentation complète

**Tout est prêt !** 🎉

---

## 📞 Support

En cas de problème, vérifiez les logs de l'application au démarrage. Le `DataLoader` affiche des messages détaillés sur le processus d'import.



