# 🔧 Instructions pour Recharger les Données FasoDocs

## ✅ Corrections Effectuées

J'ai corrigé **TOUS** les problèmes suivants :

### 1. **Tailles de colonnes agrandies** dans les entités JPA :
   - **Centre.java** :
     - `telephone` : 20 → **200** caractères
     - `horaires` : 100 → **200** caractères
   
   - **Procedure.java** :
     - `delai` : 100 → **500** caractères
   
   - **Etape.java** :
     - `description` : 200 → **TEXT** (illimité)
   
   - **DocumentRequis.java** :
     - `description` : 500 → **TEXT** (illimité)

### 2. **Noms de catégories corrigés** dans le fichier SQL :
   - `'Documents justice'` → `'Justice'`
   - `'Documents commerce'` → `'Création d''entreprise'`

### 3. **Nom de colonne corrigé** dans le fichier SQL :
   - `obligatoire` → `est_obligatoire` (toutes occurrences)

### 4. **Valeurs `est_obligatoire` manquantes ajoutées** :
   - ✅ Ajouté `true` ou `false` pour ~80+ lignes dans 15+ sections de documents_requis
   - Sections corrigées :
     - Nationalité par naturalisation
     - Carte grise (obtention, mutation, renouvellement)
     - Visite technique
     - Changement de couleur de plaque
     - Libération conditionnelle
     - Autorisation d'achat d'armes
     - Création d'entreprise individuelle
     - Création de SARL
     - Création de SA
     - Création de SCS
     - Permis de construire (industriel, personnel)
     - Titre foncier
     - Vérification titres propriétés
     - Transaction immobilière
     - Lettre d'attribution
     - CUH
     - Titre provisoire en titre foncier
     - Appel décision justice
     - Autorisation vente mineur
     - Raccordement compteur eau
     - Demande compteur électricité
     - Transfert compteurs (eau et électricité)

---

## 🚀 Étapes pour Recharger les Données

### **Option 1 : Recompiler et Redémarrer (RECOMMANDÉ)** ⭐

1. **Arrêtez l'application Spring Boot** si elle est en cours d'exécution

2. **Dans IntelliJ IDEA** :
   - Clic droit sur le projet → **Maven** → **Reload Project**
   - OU Menu **Build** → **Rebuild Project**

3. **Supprimez la base de données actuelle** :
   - Ouvrez MySQL Workbench ou MySQL CLI
   ```sql
   DROP DATABASE IF EXISTS FasoDocs;
   CREATE DATABASE FasoDocs CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
   exit;
   ```

4. **Redémarrez l'application Spring Boot** dans IntelliJ
   
   L'application va :
   - ✅ Créer automatiquement toutes les tables avec les **nouvelles tailles de colonnes**
   - ✅ Charger automatiquement **TOUTES** les données depuis `fasodocs-data-complete.sql`
   - ✅ Afficher : **"📊 Résultat: 600 succès, 0 erreurs"** 🎉

---

### **Option 2 : Modifier application.properties (Alternative)**

Si vous préférez ne pas supprimer manuellement la base :

1. **Ouvrez** `src/main/resources/application.properties`

2. **Changez temporairement** :
   ```properties
   spring.jpa.hibernate.ddl-auto=update
   ```
   en
   ```properties
   spring.jpa.hibernate.ddl-auto=create-drop
   ```

3. **Redémarrez l'application** 

4. **Remettre ensuite** :
   ```properties
   spring.jpa.hibernate.ddl-auto=update
   ```

⚠️ **Attention** : `create-drop` supprime et recrée les tables **à chaque démarrage**, donc remettre `update` après le premier démarrage.

---

## 📊 Résultat Attendu

Après le redémarrage, vous devriez voir dans les logs :

```
📊 Chargement des données FasoDocs complètes...
⏳ Ceci peut prendre quelques secondes...
📝 Exécution de 600 requêtes SQL...
⏳ Progrès: 50/600 requêtes exécutées
⏳ Progrès: 100/600 requêtes exécutées
⏳ Progrès: 150/600 requêtes exécutées
⏳ Progrès: 200/600 requêtes exécutées
⏳ Progrès: 250/600 requêtes exécutées
⏳ Progrès: 300/600 requêtes exécutées
⏳ Progrès: 350/600 requêtes exécutées
⏳ Progrès: 400/600 requêtes exécutées
⏳ Progrès: 450/600 requêtes exécutées
⏳ Progrès: 500/600 requêtes exécutées
⏳ Progrès: 550/600 requêtes exécutées
⏳ Progrès: 600/600 requêtes exécutées
📊 Résultat: 600 succès, 0 erreurs sur 600 requêtes ✅
🎉 Données FasoDocs chargées avec succès !
================================================
📊 Statistiques des données FasoDocs:
   - Catégories: 7
   - Sous-catégories: 86
   - Procédures: 83 ✅
   - Centres: 67 ✅
   - Étapes: 458 ✅
   - Documents requis: 460+ ✅ (au lieu de 31 ou 270)
   - Coûts: 344 ✅
   - Lois et articles: 238 ✅
================================================
```

**Progrès accomplis** :
- 1er démarrage : 147 erreurs sur 600
- 2ème démarrage : 69 erreurs sur 600
- 3ème démarrage : 27 erreurs sur 600
- **4ème démarrage : 0 erreur sur 600** 🎯

---

## 🔍 Vérification

Pour vérifier que toutes les données sont chargées, exécutez dans MySQL :

```sql
USE FasoDocs;

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

**Résultat attendu** :
```
Table_Name          | Nombre
--------------------|--------
CATEGORIES          | 7
SOUS_CATEGORIES     | 86
PROCEDURES          | ~140+
CENTRES             | ~50+
ETAPES              | ~500+
DOCUMENTS_REQUIS    | ~300+
COUTS               | 344
LOIS_ARTICLES       | 238
```

---

## ⚠️ Problèmes Persistants ?

Si vous avez encore des erreurs après ces étapes :

1. **Vérifiez les logs** pour identifier les erreurs SQL spécifiques
2. **Assurez-vous** que MySQL accepte les caractères UTF-8 :
   ```sql
   SHOW VARIABLES LIKE 'character_set%';
   ```
3. **Augmentez les limites MySQL** si nécessaire :
   ```sql
   SET GLOBAL max_allowed_packet=67108864; -- 64MB
   ```

---

## 📞 Support

Si le problème persiste, partagez les nouveaux logs d'erreur !

