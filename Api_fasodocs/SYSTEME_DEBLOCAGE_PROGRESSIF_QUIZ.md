# 🎮 Système de Déblocage Progressif des Quiz

## 📋 Vue d'ensemble

Le système de quiz a été amélioré avec un **déblocage progressif** à deux niveaux :

1. **Déblocage des questions** : Les questions d'un quiz se débloquent progressivement (50% des points requis)
2. **Déblocage des niveaux** : Les niveaux supérieurs se débloquent après avoir complété 25 quiz du niveau précédent

---

## 🔓 Déblocage Progressif des Questions (Global par Ordre)

### Règle
- **Toutes les questions d'ordre 1** : Toujours débloquées pour tous les quiz d'un niveau
- **Toutes les questions d'ordre N+1** : Se débloquent automatiquement si l'utilisateur a répondu à **TOUTES les questions d'ordre N** de **TOUS les quiz** du même niveau avec **au moins 50% des points**

### Exemple
```
Niveau FACILE avec 30 quiz, chaque quiz a 5 questions :

Étape 1 : Toutes les questions d'ordre 1 sont débloquées
  ✅ Quiz 1 - Question 1 (10 pts)
  ✅ Quiz 2 - Question 1 (10 pts)
  ✅ Quiz 3 - Question 1 (10 pts)
  ...
  ✅ Quiz 30 - Question 1 (10 pts)

Étape 2 : L'utilisateur répond à toutes les questions 1 avec ≥50% des points
  ✅ Quiz 1 - Question 1 : 6/10 pts (60%) ✅
  ✅ Quiz 2 - Question 1 : 5/10 pts (50%) ✅
  ✅ Quiz 3 - Question 1 : 7/10 pts (70%) ✅
  ...
  ✅ Quiz 30 - Question 1 : 5/10 pts (50%) ✅

Étape 3 : Toutes les questions d'ordre 2 se débloquent automatiquement
  ✅ Quiz 1 - Question 2 (10 pts) → Débloquée
  ✅ Quiz 2 - Question 2 (10 pts) → Débloquée
  ✅ Quiz 3 - Question 2 (10 pts) → Débloquée
  ...
  ✅ Quiz 30 - Question 2 (10 pts) → Débloquée

Étape 4 : L'utilisateur répond à toutes les questions 2 avec ≥50% des points
  → Toutes les questions d'ordre 3 se débloquent
  → Et ainsi de suite jusqu'à l'ordre 5
```

### Configuration
```properties
# Pourcentage de points requis pour débloquer la question suivante (50% = 0.5)
quiz.pourcentage-deblocage-question=0.5
```

---

## 🎯 Déblocage Progressif des Niveaux

### Règle
- **Niveau FACILE** : Toujours débloqué par défaut
- **Niveau MOYEN** : Se débloque après avoir complété **25 quiz FACILE**
- **Niveau DIFFICILE** : Se débloque après avoir complété **25 quiz MOYEN**

### Configuration
```properties
# Nombre de quiz requis pour débloquer le niveau suivant
quiz.requis-pour-debloquer.moyen=25
quiz.requis-pour-debloquer.difficile=25
```

---

## 🗄️ Structure de la Base de Données

### Nouvelle Table : `quiz_questions_debloquees`

```sql
CREATE TABLE quiz_questions_debloquees (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    citoyen_id BIGINT NOT NULL,
    quiz_journalier_id BIGINT NOT NULL,
    question_id BIGINT NOT NULL,
    date_deblocage DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (citoyen_id) REFERENCES citoyens(id) ON DELETE CASCADE,
    FOREIGN KEY (quiz_journalier_id) REFERENCES quiz_journaliers(id) ON DELETE CASCADE,
    FOREIGN KEY (question_id) REFERENCES quiz_questions(id) ON DELETE CASCADE,
    UNIQUE KEY unique_question_debloquee (citoyen_id, quiz_journalier_id, question_id)
);
```

### Modification : Colonne `ordre` dans `quiz_questions`

```sql
ALTER TABLE quiz_questions 
ADD COLUMN ordre INTEGER DEFAULT 0 
COMMENT 'Ordre de la question dans le quiz (1, 2, 3, 4, 5)';
```

---

## 📝 Modifications du Code

### 1. Entités

#### `QuizQuestion.java`
- Ajout du champ `ordre` pour ordonner les questions

#### `QuizQuestionDebloquee.java` (Nouveau)
- Entité pour suivre les questions débloquées par utilisateur

### 2. Repository

#### `QuizQuestionDebloqueeRepository.java` (Nouveau)
- `findQuestionIdsDebloquees()` : Récupère les IDs des questions débloquées
- `existsByCitoyenIdAndQuizJournalierIdAndQuestionId()` : Vérifie si une question est débloquée

### 3. Service

#### `QuizGenerationService.java`
- Les questions sont créées avec un `ordre` (1, 2, 3, 4, 5)

#### `QuizService.java`
- **`debloquerQuestion()`** : Débloque une question pour un utilisateur
- **`debloquerQuestionsSuivantes()`** : Débloque la question suivante si 50% des points sont obtenus
- **`convertirQuizEnResponse()`** : Retourne seulement les questions débloquées
- **`mettreAJourProgressionNiveau()`** : Met à jour la progression (25 quiz requis au lieu de 30)

### 4. DTO

#### `QuizQuestionResponse.java`
- Ajout de `ordre` : Ordre de la question dans le quiz
- Ajout de `estDebloquee` : Si la question est débloquée pour l'utilisateur

---

## 🔄 Flux de Déblocage

### Déblocage Global par Ordre

```
1. Toutes les questions d'ordre 1 sont débloquées pour tous les quiz
   ↓
2. Utilisateur répond à toutes les questions d'ordre 1 de tous les quiz
   ↓
3. Système vérifie si TOUTES les questions d'ordre 1 ont ≥50% des points
   ↓
4. Si oui, TOUTES les questions d'ordre 2 sont automatiquement débloquées pour tous les quiz
   ↓
5. Utilisateur peut maintenant répondre à toutes les questions d'ordre 2
   ↓
6. Processus se répète pour les ordres suivants (3, 4, 5)
```

### Déblocage d'un Niveau

```
1. Utilisateur complète un quiz FACILE
   ↓
2. Système incrémente quiz_completes dans quiz_progression
   ↓
3. Si quiz_completes ≥ 25
   ↓
4. Niveau MOYEN est automatiquement débloqué
   ↓
5. Utilisateur peut maintenant accéder aux quiz MOYEN
```

---

## 📡 Endpoints API

### Récupérer un Quiz (avec questions débloquées uniquement)

```http
GET /api/quiz/aujourdhui/{niveau}
Authorization: Bearer {token}
```

**Réponse** :
```json
{
  "id": 1,
  "dateQuiz": "2025-01-26",
  "niveau": "FACILE",
  "questions": [
    {
      "id": 10,
      "question": "Quel est le délai pour...",
      "ordre": 1,
      "estDebloquee": true,
      "points": 10,
      "reponses": [...]
    },
    {
      "id": 11,
      "question": "Quel est le coût...",
      "ordre": 2,
      "estDebloquee": true,  // Débloquée si Question 1 ≥ 50%
      "points": 10,
      "reponses": [...]
    }
    // Seulement les questions débloquées sont retournées
  ]
}
```

### Participer à un Quiz

```http
POST /api/quiz/participer
Authorization: Bearer {token}
Content-Type: application/json

{
  "quizJournalierId": 1,
  "reponses": [
    {
      "questionId": 10,
      "reponseChoisieId": 50
    },
    {
      "questionId": 11,
      "reponseChoisieId": 55
    }
  ],
  "tempsSecondes": 120
}
```

**Comportement** :
1. Les réponses sont enregistrées
2. Pour chaque question avec ≥ 50% des points, la question suivante est débloquée
3. La progression du niveau est mise à jour
4. Si 25 quiz sont complétés, le niveau suivant est débloqué

---

## 🎮 Expérience Utilisateur

### Scénario 1 : Déblocage Global par Ordre

1. ✅ **Toutes les questions d'ordre 1** : Débloquées automatiquement pour tous les 30 quiz FACILE
2. Utilisateur répond à toutes les questions 1 des 30 quiz → Obtient ≥50% pour chacune
3. ✅ **Toutes les questions d'ordre 2** : Se débloquent automatiquement pour tous les 30 quiz
4. Utilisateur répond à toutes les questions 2 des 30 quiz → Obtient ≥50% pour chacune
5. ✅ **Toutes les questions d'ordre 3** : Se débloquent automatiquement pour tous les 30 quiz
6. Processus continue jusqu'à l'ordre 5

### Scénario 2 : Déblocage du Niveau MOYEN

1. Utilisateur complète 24 quiz FACILE
2. ✅ **Niveau MOYEN** : Toujours verrouillé
3. Utilisateur complète le 25e quiz FACILE
4. ✅ **Niveau MOYEN** : Se débloque automatiquement
5. Utilisateur peut maintenant accéder aux quiz MOYEN

---

## 🔧 Migration SQL

### V14 : Système de Déblocage Progressif

```sql
-- Migration V14: Système de déblocage progressif des questions
-- Date: 2025-01-26

-- 1. Ajouter la colonne ordre à quiz_questions
ALTER TABLE quiz_questions 
ADD COLUMN ordre INTEGER DEFAULT 0 
COMMENT 'Ordre de la question dans le quiz (1, 2, 3, 4, 5)';

-- 2. Mettre à jour l'ordre des questions existantes
UPDATE quiz_questions q1
INNER JOIN (
    SELECT id, 
           ROW_NUMBER() OVER (PARTITION BY quiz_journalier_id ORDER BY id) as ordre
    FROM quiz_questions
) q2 ON q1.id = q2.id
SET q1.ordre = q2.ordre
WHERE q1.ordre = 0 OR q1.ordre IS NULL;

-- 3. Créer la table quiz_questions_debloquees
CREATE TABLE IF NOT EXISTS quiz_questions_debloquees (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    citoyen_id BIGINT NOT NULL,
    quiz_journalier_id BIGINT NOT NULL,
    question_id BIGINT NOT NULL,
    date_deblocage DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (citoyen_id) REFERENCES citoyens(id) ON DELETE CASCADE,
    FOREIGN KEY (quiz_journalier_id) REFERENCES quiz_journaliers(id) ON DELETE CASCADE,
    FOREIGN KEY (question_id) REFERENCES quiz_questions(id) ON DELETE CASCADE,
    UNIQUE KEY unique_question_debloquee (citoyen_id, quiz_journalier_id, question_id)
);

-- 4. Débloquer automatiquement la première question de chaque quiz
INSERT INTO quiz_questions_debloquees (citoyen_id, quiz_journalier_id, question_id)
SELECT DISTINCT 
    c.id as citoyen_id,
    qj.id as quiz_journalier_id,
    qq.id as question_id
FROM citoyens c
CROSS JOIN quiz_journaliers qj
INNER JOIN quiz_questions qq ON qq.quiz_journalier_id = qj.id
WHERE qq.ordre = 1
ON DUPLICATE KEY UPDATE question_id = question_id;
```

---

## ✅ Points Importants

1. **Première question toujours débloquée** : La question avec `ordre = 1` est automatiquement débloquée pour tous les utilisateurs
2. **50% des points requis** : Configurable via `quiz.pourcentage-deblocage-question`
3. **25 quiz requis** : Configurable via `quiz.requis-pour-debloquer.moyen` et `quiz.requis-pour-debloquer.difficile`
4. **Questions non débloquées cachées** : L'API retourne seulement les questions débloquées
5. **Déblocage automatique** : Aucune action manuelle requise, tout est automatique

---

## 🚀 Prochaines Étapes

1. ✅ Migration V14 appliquée
2. ✅ Code backend implémenté
3. ⏳ Mise à jour du frontend Flutter pour gérer le déblocage progressif
4. ⏳ Tests end-to-end

---

## 📚 Références

- Migration SQL : `V14__add_question_unlock_system.sql`
- Entité : `QuizQuestionDebloquee.java`
- Repository : `QuizQuestionDebloqueeRepository.java`
- Service : `QuizService.java` (méthodes `debloquerQuestion()` et `debloquerQuestionsSuivantes()`)

