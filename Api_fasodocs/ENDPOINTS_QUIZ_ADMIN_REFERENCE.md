# 📋 Référence Rapide - Endpoints Quiz Admin

## 🎯 Endpoints Disponibles

### 1. **Créer un quiz** ✅
```
POST /api/admin/quiz/journaliers
```
- Génère automatiquement un quiz avec 5 questions
- Peut générer pour une date spécifique ou pour aujourd'hui
- Sélectionne une procédure aléatoire

**Body (optionnel) :**
```json
{
  "dateQuiz": "2025-11-26"
}
```

---

### 2. **Lister tous les quiz** ✅
```
GET /api/admin/quiz/journaliers
```
- Retourne tous les quiz avec leurs questions
- Headers : `Accept-Language: fr` (ou `en`)

---

### 3. **Récupérer un quiz** ✅
```
GET /api/admin/quiz/journaliers/{id}
```
- Récupère un quiz spécifique par son ID
- Headers : `Accept-Language: fr` (ou `en`)

---

### 4. **Modifier un quiz** ✅
```
PUT /api/admin/quiz/journaliers/{id}
```
- Mise à jour partielle (date, statut, procédure, catégorie)

**Body :**
```json
{
  "dateQuiz": "2025-11-26",
  "estActif": true,
  "procedureId": 123,
  "categorieId": 5
}
```

---

### 5. **Activer/Désactiver** ✅
```
PUT /api/admin/quiz/journaliers/{id}/actif?actif=true
```
- Active ou désactive rapidement un quiz
- Paramètre `actif` : `true` pour activer, `false` pour désactiver

---

### 6. **Supprimer un quiz** ✅
```
DELETE /api/admin/quiz/journaliers/{id}
```
- Supprime un quiz et toutes ses questions/réponses (cascade)

---

## 🔐 Authentification

Tous les endpoints nécessitent :
- Header : `Authorization: Bearer {JWT_TOKEN}`
- Rôle : `ADMIN` (vérifié par `@PreAuthorize("hasRole('ADMIN')")`)

---

## 📚 Documentation Complète

Pour plus de détails, consultez :
- `TOUS_LES_ENDPOINTS_FASODOCS.md` (endpoints 48-53)
- `RESUME_ENDPOINTS_QUIZ_ADMIN.md`
- `GUIDE_INTEGRATION_FRONTEND_QUIZ.md`



