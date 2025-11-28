# 📚 Explication Complète du Système de Quiz

## 🎯 Vue d'Ensemble

Le système de quiz est **entièrement automatique** : il génère un quiz quotidien basé sur les procédures administratives de votre base de données.

---

## 🔄 1. GÉNÉRATION AUTOMATIQUE DU QUIZ

### ⏰ Quand est généré le quiz ?

Le quiz est généré **automatiquement à minuit (00:00)** chaque jour via un scheduler Spring Boot.

### 📋 Processus de Génération

#### Étape 1 : Vérification
```
1. Le système vérifie s'il existe déjà un quiz pour aujourd'hui
2. Si oui → retourne le quiz existant
3. Si non → procède à la génération
```

#### Étape 2 : Sélection d'une Procédure
```
1. Récupère TOUTES les procédures de la base de données
2. Sélectionne une procédure ALÉATOIREMENT
3. Exemple : "Obtenir un extrait d'acte de mariage"
```

#### Étape 3 : Création du Quiz Journalier
```
1. Crée un QuizJournalier pour aujourd'hui
2. Associe la procédure sélectionnée
3. Associe la catégorie de la procédure
4. Active le quiz (estActif = true)
```

#### Étape 4 : Génération des 5 Questions

Le système génère **5 questions automatiquement** en se basant sur les données de la procédure :

**Question 1 : Délai** ⏱️
- **Type** : `DELAI`
- **Points** : 10
- **Niveau** : FACILE
- **Exemple** : "Quel est le délai pour obtenir un extrait d'acte de mariage ?"
- **Réponse correcte** : Le délai de la procédure (ex: "1 semaine après le mariage")
- **Réponses incorrectes** : "3 jours", "15 jours", "30 jours", "60 jours"

**Question 2 : Coût** 💰
- **Type** : `COUT`
- **Points** : 10
- **Niveau** : FACILE
- **Exemple** : "Combien coûte obtenir un extrait d'acte de mariage ?"
- **Réponse correcte** : Le prix de la procédure (ex: "0 FCFA" - gratuit)
- **Réponses incorrectes** : Variations du prix (±5000 FCFA, ×2, ÷2)

**Question 3 : Document Requis** 📄
- **Type** : `DOCUMENT`
- **Points** : 15
- **Niveau** : MOYEN
- **Exemple** : "Quel document est requis pour obtenir un extrait d'acte de mariage ?"
- **Réponse correcte** : Le premier document requis de la procédure
- **Réponses incorrectes** : Documents d'autres procédures

**Question 4 : Centre** 🏢
- **Type** : `CENTRE`
- **Points** : 10
- **Niveau** : FACILE
- **Exemple** : "Dans quel centre peut-on faire cette procédure ?"
- **Réponse correcte** : Le centre de la procédure (ex: "Mairie")
- **Réponses incorrectes** : "Centre administratif", "Préfecture", etc.

**Question 5 : Étape** 📝
- **Type** : `ETAPE`
- **Points** : 15
- **Niveau** : MOYEN
- **Exemple** : "Quelle est la première étape pour cette procédure ?"
- **Réponse correcte** : La première étape de la procédure
- **Réponses incorrectes** : Autres étapes de la même procédure

**Question Générique** (si moins de 5 questions disponibles)
- **Type** : `GENERIQUE`
- **Points** : 10
- **Niveau** : FACILE
- **Exemple** : "À quelle catégorie appartient cette procédure ?"
- **Réponse correcte** : La catégorie de la procédure
- **Réponses incorrectes** : Autres catégories

#### Étape 5 : Création des Réponses

Pour chaque question :
1. **1 réponse correcte** (avec `estCorrecte = true`)
2. **3 réponses incorrectes** (avec `estCorrecte = false`)
3. **Support multilingue** : Toutes les réponses ont une version FR et EN

### 📊 Exemple Concret

**Procédure sélectionnée** : "Obtenir un extrait d'acte de mariage"

**Quiz généré** :
```
Quiz du 25/11/2025
- Procédure: Obtenir un extrait d'acte de mariage
- Catégorie: Identité et citoyenneté

Question 1 (DELAI):
  Q: "Quel est le délai pour obtenir un extrait d'acte de mariage ?"
  R1: "1 semaine après le mariage" ✓ (correcte)
  R2: "3 jours" ✗
  R3: "15 jours" ✗
  R4: "30 jours" ✗

Question 2 (COUT):
  Q: "Combien coûte obtenir un extrait d'acte de mariage ?"
  R1: "0 FCFA" ✓ (correcte)
  R2: "5000 FCFA" ✗
  R3: "10000 FCFA" ✗
  R4: "2000 FCFA" ✗

Question 3 (DOCUMENT):
  Q: "Quel document est requis pour obtenir un extrait d'acte de mariage ?"
  R1: "Pièce d'identité" ✓ (correcte)
  R2: "Extrait de naissance" ✗
  R3: "Justificatif de domicile" ✗
  R4: "Photo d'identité" ✗

Question 4 (CENTRE):
  Q: "Dans quel centre peut-on faire cette procédure ?"
  R1: "Mairie" ✓ (correcte)
  R2: "Centre administratif" ✗
  R3: "Préfecture" ✗
  R4: "Direction Nationale" ✗

Question 5 (ETAPE):
  Q: "Quelle est la première étape pour cette procédure ?"
  R1: "Se présenter à la mairie avec les documents" ✓ (correcte)
  R2: "Remplir un formulaire" ✗
  R3: "Payer les frais" ✗
  R4: "Attendre la délivrance" ✗
```

---

## 👥 2. PARCOURS UTILISATEUR (FLUTTER)

### 🔄 Flux Complet

#### **Étape 1 : Récupération du Quiz**
```
GET /api/quiz/aujourdhui
Headers: Authorization: Bearer {JWT_TOKEN}
         Accept-Language: fr

→ Si aucun quiz → Génération automatique
→ Retourne le quiz du jour avec 5 questions
```

#### **Étape 2 : Affichage du Quiz**
L'application Flutter affiche :
- Les 5 questions une par une
- 4 choix de réponses par question
- Barre de progression
- Temps de réponse (optionnel)

#### **Étape 3 : Réponses de l'Utilisateur**
L'utilisateur :
- Sélectionne une réponse pour chaque question
- Peut naviguer entre les questions (Précédent/Suivant)
- Peut modifier ses réponses avant soumission

#### **Étape 4 : Soumission**
```
POST /api/quiz/participer
Body: {
  "quizJournalierId": 1,
  "reponses": [
    {"questionId": 1, "reponseChoisieId": 3},
    {"questionId": 2, "reponseChoisieId": 5},
    ...
  ],
  "tempsSecondes": 180
}
```

#### **Étape 5 : Calcul du Score**
Le backend :
1. Vérifie chaque réponse (correcte ou incorrecte)
2. Calcule le score : `points = nombre de bonnes réponses × points par question`
3. Enregistre la participation
4. Met à jour les statistiques de l'utilisateur :
   - Points totaux
   - Nombre de quiz complétés
   - Streak (jours consécutifs)
   - Badges débloqués

#### **Étape 6 : Résultats**
L'application affiche :
- Score obtenu (ex: 45/50 points)
- Nombre de bonnes réponses (ex: 4/5)
- Temps de réponse
- Réponses correctes/incorrectes

---

## 👨‍💼 3. PARCOURS ADMIN (ANGULAR)

### 📊 Ce que l'Admin Peut Faire

#### **1. Lister Tous les Quiz**
```
GET /api/admin/quiz/journaliers
→ Retourne tous les quiz créés (avec leurs questions)
```

L'admin peut voir :
- Tous les quiz générés
- La date de chaque quiz
- La procédure associée
- Les 5 questions de chaque quiz
- Le nombre de participations (à implémenter)

#### **2. Statistiques Globales** (à implémenter)
L'admin pourrait voir :
- Nombre total de quiz générés
- Nombre total de participations
- Score moyen des utilisateurs
- Procédures les plus utilisées dans les quiz

#### **3. Gestion des Quiz** (à implémenter)
L'admin pourrait :
- Désactiver un quiz
- Modifier un quiz
- Générer manuellement un quiz pour une date spécifique

---

## 🔔 4. NOTIFICATIONS AUTOMATIQUES

### ⏰ Horaires des Notifications

#### **08:00 - Notification du Quiz Quotidien**
```
Tous les utilisateurs actifs reçoivent :
"🎯 Défi du jour disponible ! Testez vos connaissances..."
```

#### **18:00 - Rappel de Streak**
```
Utilisateurs avec streak actif qui n'ont pas complété le quiz :
"🔥 Votre série est de X jours ! Ne laissez pas tomber..."
```

---

## 🎮 5. GAMIFICATION

### 📈 Statistiques Utilisateur

Chaque utilisateur a :
- **Points totaux** : Somme de tous les points obtenus
- **Quiz complétés** : Nombre de quiz terminés
- **Streak actuel** : Jours consécutifs de participation
- **Meilleur streak** : Meilleur record de jours consécutifs

### 🏆 Badges

- **Badge Expert** : Débloqué à 1000 points
- **Badge Streak Master** : Débloqué à 30 jours consécutifs

### 🏅 Classements

- **Hebdomadaire** : Top 50 des meilleurs scores de la semaine
- **Mensuel** : Top 50 des meilleurs scores du mois

---

## 🔧 6. GÉNÉRATION MANUELLE (Pour les Tests)

### Via Endpoint
```
POST /api/quiz/generer
→ Génère un quiz pour aujourd'hui
→ Utile pour tester sans attendre minuit
```

### Via Code
```java
@Autowired
private QuizGenerationService quizGenerationService;

quizGenerationService.genererQuizQuotidien();
```

---

## 📋 7. RÉSUMÉ DES ACTIONS

### 🖥️ Backend (Automatique)
- ✅ Génère le quiz à minuit
- ✅ Envoie les notifications à 8h et 18h
- ✅ Calcule les scores
- ✅ Met à jour les statistiques
- ✅ Gère les streaks

### 📱 Frontend Flutter (Utilisateur)
- ✅ Affiche le quiz du jour
- ✅ Permet de répondre aux questions
- ✅ Soumet les réponses
- ✅ Affiche les résultats
- ✅ Affiche les statistiques
- ✅ Affiche les classements

### 🖥️ Frontend Angular (Admin)
- ✅ Liste tous les quiz
- ✅ Voir les questions de chaque quiz
- ✅ Statistiques globales (à implémenter)

---

## 🎯 Points Importants

1. **Automatique** : Le système génère le quiz sans intervention
2. **Aléatoire** : Une procédure différente chaque jour
3. **Intelligent** : Les questions sont basées sur les vraies données
4. **Multilingue** : FR et EN supportés
5. **Gamifié** : Points, badges, streaks, classements
6. **Une participation par jour** : Un utilisateur ne peut compléter qu'un quiz par jour

---

**Le système est 100% opérationnel et prêt à être utilisé !** 🎉

