# ⚡ Optimisations de Performance - Chargement des Quiz

## 🐌 Problèmes Identifiés

### 1. **Problème N+1**
- **Avant** : `findAll()` puis `findByIdWithQuestions()` pour chaque quiz
- **Impact** : 1 requête pour la liste + N requêtes pour charger les questions (30 quiz = 31 requêtes)

### 2. **Chargement Inefficace**
- **Avant** : Chargement des questions débloquées une par une pour chaque quiz
- **Impact** : 30 requêtes supplémentaires pour vérifier les déblocages

### 3. **Vérification de Déblocage Répétée**
- **Avant** : `verifierEtDebloquerOrdreGlobal()` appelée pour chaque quiz
- **Impact** : Vérification coûteuse répétée 30 fois

### 4. **Pas de Requête Optimisée**
- **Avant** : Filtrage en mémoire après `findAll()`
- **Impact** : Chargement de tous les quiz même ceux non nécessaires

---

## ✅ Optimisations Appliquées

### 1. **Requête Unique pour Tous les Quiz d'un Niveau**

**Avant** :
```java
List<QuizJournalier> tousLesQuiz = quizJournalierRepository.findAll()
    .stream()
    .filter(q -> niveauFinal.equals(q.getNiveau()) && q.getEstActif())
    .sorted(Comparator.comparing(QuizJournalier::getId))
    .collect(Collectors.toList());

for (QuizJournalier quiz : tousLesQuiz) {
    QuizJournalier quizComplet = quizJournalierRepository
        .findByIdWithQuestions(quiz.getId())  // ← N requêtes !
        .orElse(quiz);
    responses.add(convertirQuizEnResponse(quizComplet, langue));
}
```

**Après** :
```java
// Une seule requête avec toutes les relations chargées
List<QuizJournalier> tousLesQuiz = quizJournalierRepository
    .findByNiveauWithQuestions(niveauFinal);  // ← 1 requête !
```

**Nouvelle Requête Repository** :
```java
@Query("SELECT DISTINCT q FROM QuizJournalier q " +
       "LEFT JOIN FETCH q.procedure " +
       "LEFT JOIN FETCH q.categorie " +
       "LEFT JOIN FETCH q.questions qu " +
       "LEFT JOIN FETCH qu.reponses " +
       "WHERE q.niveau = :niveau AND q.estActif = true " +
       "ORDER BY q.id")
List<QuizJournalier> findByNiveauWithQuestions(@Param("niveau") String niveau);
```

**Gain** : 30 requêtes → 1 requête

---

### 2. **Chargement Batch des Questions Débloquées**

**Avant** :
```java
for (QuizJournalier quiz : tousLesQuiz) {
    List<Long> questionsDebloquees = quizQuestionDebloqueeRepository
        .findQuestionIdsDebloquees(citoyenId, quiz.getId());  // ← N requêtes !
    // ...
}
```

**Après** :
```java
// Charger toutes les questions débloquées en une seule requête
List<Long> quizIds = tousLesQuiz.stream()
    .map(QuizJournalier::getId)
    .collect(Collectors.toList());

List<Object[]> questionsDebloqueesBatch = quizQuestionDebloqueeRepository
    .findQuestionIdsDebloqueesByQuizIds(citoyenId, quizIds);  // ← 1 requête !

// Créer un Map pour accès rapide O(1)
Map<Long, Set<Long>> questionsDebloqueesParQuiz = new HashMap<>();
for (Object[] row : questionsDebloqueesBatch) {
    Long quizId = (Long) row[0];
    Long questionId = (Long) row[1];
    questionsDebloqueesParQuiz.computeIfAbsent(quizId, k -> new HashSet<>())
        .add(questionId);
}
```

**Nouvelle Requête Repository** :
```java
@Query("SELECT qqd.quizJournalier.id, qqd.question.id FROM QuizQuestionDebloquee qqd " +
       "WHERE qqd.citoyen.id = :citoyenId " +
       "AND qqd.quizJournalier.id IN :quizIds")
List<Object[]> findQuestionIdsDebloqueesByQuizIds(@Param("citoyenId") Long citoyenId,
                                                    @Param("quizIds") List<Long> quizIds);
```

**Gain** : 30 requêtes → 1 requête

---

### 3. **Vérification de Déblocage Unique**

**Avant** :
```java
for (QuizJournalier quiz : tousLesQuiz) {
    verifierEtDebloquerOrdreGlobal(citoyenId, quiz.getNiveau());  // ← N fois !
    // ...
}
```

**Après** :
```java
// Vérifier et débloquer une seule fois avant de charger les quiz
verifierEtDebloquerOrdreGlobal(citoyenId, niveauFinal);  // ← 1 fois !

// Ensuite charger tous les quiz
List<QuizJournalier> tousLesQuiz = quizJournalierRepository
    .findByNiveauWithQuestions(niveauFinal);
```

**Gain** : 30 vérifications → 1 vérification

---

### 4. **Méthode Optimisée de Conversion**

**Nouvelle Méthode** :
```java
private QuizJournalierResponse convertirQuizEnResponseOptimise(
    QuizJournalier quiz, 
    String langue, 
    Long citoyenId, 
    Set<Long> questionsDebloquees) {
    
    // Utilise le Set pré-chargé (accès O(1) au lieu de O(n))
    // Pas de requête supplémentaire
    // ...
}
```

**Avantages** :
- Utilise un `Set` pré-chargé (accès O(1))
- Pas de requête supplémentaire
- Réutilisable pour tous les quiz

---

## 📊 Résultats Attendus

### Avant Optimisation
```
Requêtes SQL pour charger 30 quiz :
- 1 requête : findAll()
- 30 requêtes : findByIdWithQuestions() pour chaque quiz
- 30 requêtes : findQuestionIdsDebloquees() pour chaque quiz
- 30 vérifications : verifierEtDebloquerOrdreGlobal()
Total : ~91 requêtes + vérifications
```

### Après Optimisation
```
Requêtes SQL pour charger 30 quiz :
- 1 requête : findByNiveauWithQuestions() (charge tout)
- 1 requête : findQuestionIdsDebloqueesByQuizIds() (batch)
- 1 vérification : verifierEtDebloquerOrdreGlobal()
Total : 3 requêtes + 1 vérification
```

**Gain de Performance** : **~97% de réduction** (91 → 3 requêtes)

---

## 🎯 Temps de Réponse Estimé

### Avant
- **30 quiz** : ~2-5 secondes
- **90 quiz** (3 niveaux) : ~6-15 secondes

### Après
- **30 quiz** : ~200-500ms
- **90 quiz** (3 niveaux) : ~600ms-1.5s

**Amélioration** : **10x plus rapide** ⚡

---

## 🔧 Fichiers Modifiés

1. **`QuizJournalierRepository.java`**
   - Ajout de `findByNiveauWithQuestions()` : Requête optimisée

2. **`QuizQuestionDebloqueeRepository.java`**
   - Ajout de `findQuestionIdsDebloqueesByQuizIds()` : Chargement batch

3. **`QuizService.java`**
   - Modification de `obtenirQuizAujourdhui()` : Utilise les nouvelles requêtes
   - Modification de `obtenirTousQuizAujourdhui()` : Utilise les nouvelles requêtes
   - Ajout de `convertirQuizEnResponseOptimise()` : Méthode optimisée

---

## ✅ Points Importants

1. **Une seule requête** pour charger tous les quiz avec leurs relations
2. **Chargement batch** des questions débloquées
3. **Vérification unique** du déblocage global
4. **Utilisation de Set** pour accès O(1) aux questions débloquées
5. **Pas de requêtes N+1** : Toutes les données chargées en batch

---

## 🚀 Prochaines Optimisations Possibles

1. **Cache** : Mettre en cache les quiz par niveau (Redis)
2. **Pagination** : Charger les quiz par pages (si > 100 quiz)
3. **Endpoint Léger** : Endpoint qui retourne seulement les métadonnées (sans questions)
4. **Lazy Loading Frontend** : Charger les questions seulement quand l'utilisateur ouvre un quiz

---

## 📝 Notes

- Les optimisations sont **rétrocompatibles** : Les anciennes méthodes existent toujours
- Le code est **plus maintenable** : Moins de requêtes = moins de bugs potentiels
- Les performances sont **scalables** : Fonctionne bien même avec 100+ quiz

