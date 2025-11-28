# 📋 Endpoints Quiz - Système avec Niveaux (FACILE, MOYEN, DIFFICILE)

## 🎯 Endpoints Utilisateur (`/api/quiz`)

### 1. Récupérer tous les quiz du jour avec leurs niveaux
```
GET /api/quiz/aujourdhui
```

**Description** : Récupère tous les quiz du jour (FACILE, MOYEN, DIFFICILE) avec leurs statuts de déblocage

**Authentification** : Requise (JWT Token)

**Headers** :
- `Accept-Language: fr` (ou `en`) - Langue de la réponse
- `Authorization: Bearer {JWT_TOKEN}`

**Réponse** :
```json
{
  "facile_debloque": true,
  "moyen_debloque": false,
  "difficile_debloque": false,
  "quiz": {
    "facile": {
      "id": 1,
      "dateQuiz": "2025-01-26",
      "niveau": "FACILE",
      "procedureId": 5,
      "procedureNom": "Obtenir un extrait d'acte de naissance",
      "categorieId": 1,
      "categorieTitre": "Identité et citoyenneté",
      "estActif": true,
      "questions": [...]
    }
  },
  "niveaux_debloques": ["FACILE"]
}
```

**Notes** :
- `facile_debloque` : toujours `true` (débloqué par défaut)
- `moyen_debloque` : `true` si l'utilisateur a complété le niveau FACILE
- `difficile_debloque` : `true` si l'utilisateur a complété le niveau MOYEN
- Les quiz non débloqués ne sont pas retournés dans l'objet `quiz`

---

### 2. Récupérer le quiz du jour pour un niveau spécifique
```
GET /api/quiz/aujourdhui/{niveau}
```

**Description** : Récupère le quiz du jour pour un niveau spécifique (FACILE, MOYEN, ou DIFFICILE)

**Authentification** : Requise (JWT Token)

**Paramètres** :
- `niveau` : `facile`, `moyen`, ou `difficile` (insensible à la casse)

**Headers** :
- `Accept-Language: fr` (ou `en`)
- `Authorization: Bearer {JWT_TOKEN}`

**Réponse** : `QuizJournalierResponse`
```json
{
  "id": 1,
  "dateQuiz": "2025-01-26",
  "niveau": "FACILE",
  "procedureId": 5,
  "procedureNom": "Obtenir un extrait d'acte de naissance",
  "categorieId": 1,
  "categorieTitre": "Identité et citoyenneté",
  "estActif": true,
  "questions": [
    {
      "id": 1,
      "question": "Quel est le délai pour obtenir un extrait d'acte de naissance ?",
      "typeQuestion": "DELAI",
      "points": 10,
      "niveau": "FACILE",
      "reponses": [...]
    }
  ]
}
```

**Erreurs possibles** :
- `400` : "Le niveau {niveau} n'est pas encore débloqué. Complétez d'abord le niveau précédent."
- `400` : "Aucun quiz {niveau} disponible pour aujourd'hui"

**Comportement** :
- Si le quiz n'existe pas, il est généré automatiquement (les 3 niveaux)
- Vérifie que le niveau est débloqué avant de retourner le quiz

---

### 3. Participer à un quiz
```
POST /api/quiz/participer
```

**Description** : Soumet les réponses d'un utilisateur à un quiz. Débloque automatiquement le niveau suivant si le quiz est complété avec succès.

**Authentification** : Requise (JWT Token)

**Headers** :
- `Authorization: Bearer {JWT_TOKEN}`
- `Content-Type: application/json`

**Body** : `QuizParticipationRequest`
```json
{
  "quizJournalierId": 1,
  "reponses": [
    {
      "questionId": 1,
      "reponseChoisieId": 3
    },
    {
      "questionId": 2,
      "reponseChoisieId": 5
    }
  ],
  "tempsSecondes": 120
}
```

**Réponse** : `QuizParticipationResponse`
```json
{
  "id": 1,
  "quizJournalierId": 1,
  "dateQuiz": "2025-01-26",
  "score": 45,
  "nombreBonnesReponses": 4,
  "nombreQuestions": 5,
  "tempsSecondes": 120,
  "estComplete": true,
  "dateParticipation": "2025-01-26T10:30:00",
  "reponses": [
    {
      "questionId": 1,
      "reponseChoisieId": 3,
      "estCorrecte": true,
      "pointsObtenus": 10
    }
  ]
}
```

**Comportement** :
- Permet de refaire un quiz (remplace l'ancienne participation)
- Débloque automatiquement le niveau suivant après complétion
- Met à jour les statistiques et la progression

---

### 4. Progression par niveau
```
GET /api/quiz/progression
```

**Description** : Récupère la progression complète de l'utilisateur dans tous les niveaux (FACILE, MOYEN, DIFFICILE)

**Authentification** : Requise (JWT Token)

**Headers** :
- `Authorization: Bearer {JWT_TOKEN}`

**Réponse** : `QuizProgressionUtilisateurResponse`
```json
{
  "citoyenId": 1,
  "citoyenNom": "Diallo",
  "citoyenPrenom": "Amadou",
  "niveauActuel": "MOYEN",
  "totalQuizCompletes": 15,
  "totalPoints": 450,
  "progressions": [
    {
      "niveau": "FACILE",
      "estDebloque": true,
      "dateDeblocage": null,
      "quizCompletes": 10,
      "meilleurScore": 50,
      "estNiveauActuel": false
    },
    {
      "niveau": "MOYEN",
      "estDebloque": true,
      "dateDeblocage": "2025-01-20T10:30:00",
      "quizCompletes": 5,
      "meilleurScore": 75,
      "estNiveauActuel": true
    },
    {
      "niveau": "DIFFICILE",
      "estDebloque": false,
      "dateDeblocage": null,
      "quizCompletes": 0,
      "meilleurScore": 0,
      "estNiveauActuel": false
    }
  ]
}
```

**Informations retournées** :
- `niveauActuel` : Le niveau actuel de l'utilisateur (dernier niveau avec des quiz complétés)
- `progressions` : Détails pour chaque niveau (FACILE, MOYEN, DIFFICILE)
  - `estDebloque` : Si le niveau est débloqué
  - `dateDeblocage` : Date de déblocage du niveau (null pour FACILE)
  - `quizCompletes` : Nombre de quiz complétés à ce niveau
  - `meilleurScore` : Meilleur score obtenu à ce niveau
  - `estNiveauActuel` : Si c'est le niveau actuel de l'utilisateur

---

### 5. Statistiques utilisateur
```
GET /api/quiz/statistiques
```

**Description** : Récupère les statistiques de quiz de l'utilisateur connecté

**Authentification** : Requise (JWT Token)

**Headers** :
- `Authorization: Bearer {JWT_TOKEN}`

**Réponse** : `QuizStatistiqueResponse`
```json
{
  "citoyenId": 1,
  "citoyenNom": "Diallo",
  "citoyenPrenom": "Amadou",
  "totalPoints": 450,
  "totalQuizCompletes": 15,
  "streakJours": 5,
  "meilleurStreak": 10,
  "derniereParticipation": "2025-01-26",
  "badgeExpert": false,
  "badgeStreakMaster": false
}
```

---

### 6. Classement hebdomadaire
```
GET /api/quiz/classement/hebdomadaire
```

**Description** : Récupère le classement hebdomadaire des utilisateurs

**Authentification** : Requise (JWT Token)

**Headers** :
- `Authorization: Bearer {JWT_TOKEN}`

**Réponse** : `ClassementResponse`
```json
{
  "periode": "HEBDOMADAIRE",
  "classement": [
    {
      "citoyenId": 5,
      "citoyenNom": "Traoré",
      "citoyenPrenom": "Fatou",
      "totalPoints": 500,
      "totalQuizCompletes": 20,
      "streakJours": 7
    }
  ],
  "positionUtilisateur": 3
}
```

---

### 7. Classement mensuel
```
GET /api/quiz/classement/mensuel
```

**Description** : Récupère le classement mensuel des utilisateurs

**Authentification** : Requise (JWT Token)

**Headers** :
- `Authorization: Bearer {JWT_TOKEN}`

**Réponse** : `ClassementResponse` (même format que hebdomadaire)

---

### 8. Générer manuellement les quiz (Test)
```
POST /api/quiz/generer
```

**Description** : Génère manuellement les 3 quiz (FACILE, MOYEN, DIFFICILE) pour aujourd'hui. Utile pour les tests.

**Authentification** : Non requise (public)

**Réponse** :
```json
{
  "success": true,
  "message": "Quiz généré avec succès pour aujourd'hui"
}
```

**Note** : Génère automatiquement les 3 quiz (FACILE, MOYEN, DIFFICILE)

---

## 🔐 Endpoints Admin (`/api/admin/quiz`)

### 9. Créer les quiz pour une date
```
POST /api/admin/quiz/journaliers
```

**Description** : Crée les 3 quiz (FACILE, MOYEN, DIFFICILE) pour une date spécifiée ou pour aujourd'hui

**Autorisation** : `ADMIN` uniquement

**Headers** :
- `Authorization: Bearer {JWT_TOKEN}`
- `Accept-Language: fr` (ou `en`)

**Body** (optionnel) :
```json
{
  "dateQuiz": "2025-01-26"
}
```

**Réponse** : `QuizJournalierResponse` (quiz FACILE par défaut)

**Comportement** :
- Génère automatiquement les 3 quiz (FACILE, MOYEN, DIFFICILE)
- Retourne le quiz FACILE par défaut
- Si une date est fournie, génère pour cette date
- Si aucune date n'est fournie, génère pour aujourd'hui

---

### 10. Lister tous les quiz
```
GET /api/admin/quiz/journaliers
```

**Description** : Liste tous les quiz journaliers avec leurs questions et réponses

**Autorisation** : `ADMIN` uniquement

**Headers** :
- `Authorization: Bearer {JWT_TOKEN}`
- `Accept-Language: fr` (ou `en`)

**Réponse** : `List<QuizJournalierResponse>`

**Note** : Retourne tous les quiz (FACILE, MOYEN, DIFFICILE) de toutes les dates

---

### 11. Récupérer un quiz par ID
```
GET /api/admin/quiz/journaliers/{id}
```

**Description** : Récupère un quiz spécifique par son ID

**Autorisation** : `ADMIN` uniquement

**Headers** :
- `Authorization: Bearer {JWT_TOKEN}`
- `Accept-Language: fr` (ou `en`)

**Réponse** : `QuizJournalierResponse`

---

### 12. Modifier un quiz
```
PUT /api/admin/quiz/journaliers/{id}
```

**Description** : Met à jour un quiz existant (mise à jour partielle)

**Autorisation** : `ADMIN` uniquement

**Headers** :
- `Authorization: Bearer {JWT_TOKEN}`
- `Content-Type: application/json`

**Body** :
```json
{
  "dateQuiz": "2025-01-26",
  "niveau": "FACILE",
  "estActif": true,
  "procedureId": 123,
  "categorieId": 5
}
```

**Réponse** : `QuizJournalierResponse` mis à jour

---

### 13. Activer/Désactiver un quiz
```
PUT /api/admin/quiz/journaliers/{id}/actif?actif=true
```

**Description** : Active ou désactive rapidement un quiz

**Autorisation** : `ADMIN` uniquement

**Headers** :
- `Authorization: Bearer {JWT_TOKEN}`

**Paramètres** :
- `actif` : `true` pour activer, `false` pour désactiver (défaut: `true`)

**Réponse** : Message de succès

---

### 14. Supprimer un quiz
```
DELETE /api/admin/quiz/journaliers/{id}
```

**Description** : Supprime un quiz et toutes ses questions/réponses (en cascade)

**Autorisation** : `ADMIN` uniquement

**Headers** :
- `Authorization: Bearer {JWT_TOKEN}`

**Réponse** : Message de succès

---

## 📊 Système de Niveaux

### Progression des Niveaux

1. **FACILE** (Débloqué par défaut)
   - Questions simples : délai, coût, centre
   - Points : 10 par question
   - Total : ~50 points maximum

2. **MOYEN** (Débloqué après complétion de FACILE)
   - Questions moyennes : documents, étapes
   - Points : 15 par question
   - Total : ~75 points maximum

3. **DIFFICILE** (Débloqué après complétion de MOYEN)
   - Questions complexes : lois, détails, combinaisons
   - Points : 20-30 par question
   - Total : ~100-150 points maximum

### Déblocage Automatique

- Compléter un quiz FACILE → Débloque MOYEN
- Compléter un quiz MOYEN → Débloque DIFFICILE
- Le déblocage se fait automatiquement lors de la soumission des réponses

---

## 🔄 Génération Automatique

Les quiz sont générés automatiquement chaque jour à **00:00** (minuit) :
- 3 quiz sont créés : un pour chaque niveau (FACILE, MOYEN, DIFFICILE)
- Chaque quiz contient 5 questions adaptées à son niveau
- Basés sur une procédure aléatoire sélectionnée dans la base de données

---

## 📝 Notes Importantes

1. **Authentification** : Tous les endpoints utilisateur nécessitent un JWT token valide
2. **Multilingue** : Utilisez le header `Accept-Language: fr` ou `en` pour la langue
3. **Progression** : La progression est sauvegardée dans la table `quiz_progression`
4. **Refaire un quiz** : Un utilisateur peut refaire un quiz autant de fois qu'il le souhaite (remplace l'ancienne participation)
5. **Statistiques** : Les statistiques sont ajustées automatiquement lors d'une nouvelle participation

---

## 🚀 Exemples d'Utilisation

### Exemple 1 : Récupérer tous les quiz du jour
```bash
curl -X GET "http://localhost:8080/api/quiz/aujourdhui" \
  -H "Authorization: Bearer {JWT_TOKEN}" \
  -H "Accept-Language: fr"
```

### Exemple 2 : Récupérer le quiz FACILE
```bash
curl -X GET "http://localhost:8080/api/quiz/aujourdhui/facile" \
  -H "Authorization: Bearer {JWT_TOKEN}" \
  -H "Accept-Language: fr"
```

### Exemple 3 : Voir sa progression
```bash
curl -X GET "http://localhost:8080/api/quiz/progression" \
  -H "Authorization: Bearer {JWT_TOKEN}"
```

### Exemple 4 : Participer à un quiz
```bash
curl -X POST "http://localhost:8080/api/quiz/participer" \
  -H "Authorization: Bearer {JWT_TOKEN}" \
  -H "Content-Type: application/json" \
  -d '{
    "quizJournalierId": 1,
    "reponses": [
      {"questionId": 1, "reponseChoisieId": 3},
      {"questionId": 2, "reponseChoisieId": 5}
    ],
    "tempsSecondes": 120
  }'
```

