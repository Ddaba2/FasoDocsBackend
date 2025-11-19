# 📋 Endpoints Admin - Gestion des Services

**Date**: 2025-01-14  
**Version**: 1.0

---

## 🔐 Authentification

Tous les endpoints nécessitent :
- **Authentification** : Token JWT valide
- **Autorisation** : Rôle `ADMIN` uniquement
- **Header** : `Authorization: Bearer {token}`

---

## 📍 Base URL

```
http://localhost:8080/api/admin
```

---

## 📋 Endpoints Disponibles

### 1. **Lister toutes les demandes de service (global)**

Récupère toutes les demandes de service, triées par date de création (plus récentes en premier).

**Endpoint** : `GET /admin/services/demandes`

**Paramètres de requête** :
- `statut` (optionnel) : Filtrer par statut (`EN_ATTENTE`, `EN_COURS`, `TERMINEE`)

**Exemples** :

```bash
# Récupérer toutes les demandes de service
GET /admin/services/demandes

# Récupérer uniquement les demandes en attente
GET /admin/services/demandes?statut=EN_ATTENTE

# Récupérer uniquement les demandes en cours
GET /admin/services/demandes?statut=EN_COURS

# Récupérer uniquement les demandes terminées
GET /admin/services/demandes?statut=TERMINEE
```

**Réponse (200 OK)** :
```json
[
  {
    "id": 1,
    "procedure": {
      "id": 5,
      "nom": "Carte d'identité nationale",
      "titre": "Demande de carte d'identité nationale"
    },
    "statut": "EN_ATTENTE",
    "tarif": 7000.00,
    "tarifService": 3000.00,
    "coutLegal": 4000.00,
    "commune": "Commune I",
    "quartier": "Hamdallaye",
    "telephoneContact": "+22370123456",
    "dateSouhaitee": "2025-01-20",
    "commentaires": "Besoin urgent",
    "notesAgent": null,
    "agent": null,
    "dateAcceptation": null,
    "dateDebut": null,
    "dateFin": null,
    "dateCreation": "2025-01-14T10:30:00",
    "dateModification": "2025-01-14T10:30:00"
  },
  {
    "id": 2,
    "procedure": {
      "id": 8,
      "nom": "Passeport",
      "titre": "Demande de passeport"
    },
    "statut": "EN_COURS",
    "tarif": 10000.00,
    "tarifService": 3000.00,
    "coutLegal": 7000.00,
    "commune": "Commune II",
    "quartier": "Badalabougou",
    "telephoneContact": "+22370234567",
    "dateSouhaitee": "2025-01-18",
    "commentaires": null,
    "notesAgent": "Démarches en cours",
    "agent": null,
    "dateAcceptation": null,
    "dateDebut": "2025-01-14T11:00:00",
    "dateFin": null,
    "dateCreation": "2025-01-14T09:15:00",
    "dateModification": "2025-01-14T11:00:00"
  }
]
```

**Réponse d'erreur (400 Bad Request)** :
```json
{
  "success": false,
  "message": "Erreur lors de la récupération des demandes: Statut invalide: INVALIDE"
}
```

**Réponse d'erreur (401 Unauthorized)** :
```json
{
  "success": false,
  "message": "Accès refusé. Admin uniquement."
}
```

---

### 2. **Récupérer une demande de service spécifique**

Récupère les détails complets d'une demande de service par son ID.

**Endpoint** : `GET /admin/services/demandes/{id}`

**Paramètres** :
- `id` (path) : ID de la demande de délégation

**Exemple** :
```bash
GET /admin/services/demandes/1
```

**Réponse (200 OK)** :
```json
{
  "id": 1,
  "procedure": {
    "id": 5,
    "nom": "Carte d'identité nationale",
    "titre": "Demande de carte d'identité nationale"
  },
  "statut": "EN_ATTENTE",
  "tarif": 7000.00,
  "tarifDelegation": 3000.00,
  "coutLegal": 4000.00,
  "commune": "Commune I",
  "quartier": "Hamdallaye",
  "telephoneContact": "+22370123456",
  "dateSouhaitee": "2025-01-20",
  "commentaires": "Besoin urgent",
  "notesAgent": null,
  "agent": null,
  "dateAcceptation": null,
  "dateDebut": null,
  "dateFin": null,
  "dateCreation": "2025-01-14T10:30:00",
  "dateModification": "2025-01-14T10:30:00"
}
```

**Réponse d'erreur (404 Not Found)** :
```json
{
  "success": false,
  "message": "Erreur lors de la récupération: Demande non trouvée"
}
```

---

### 3. **Modifier le statut d'une demande de service**

Modifie le statut d'une demande de service. Les transitions valides sont :
- `EN_ATTENTE` → `EN_COURS`
- `EN_ATTENTE` → `TERMINEE` (cas spécial)
- `EN_COURS` → `TERMINEE`

**Endpoint** : `PUT /admin/services/demandes/{id}/statut`

**Paramètres** :
- `id` (path) : ID de la demande de délégation

**Body (JSON)** :
```json
{
  "statut": "EN_COURS",
  "notes": "Démarches administratives en cours"
}
```

**Champs** :
- `statut` (requis) : Nouveau statut (`EN_ATTENTE`, `EN_COURS`, `TERMINEE`)
- `notes` (optionnel) : Notes internes de l'admin

**Exemples** :

```bash
# Passer une demande de EN_ATTENTE à EN_COURS
PUT /admin/services/demandes/1/statut
Content-Type: application/json
Authorization: Bearer {token}

{
  "statut": "EN_COURS",
  "notes": "Démarches administratives en cours"
}

# Passer une demande de EN_COURS à TERMINEE
PUT /admin/services/demandes/2/statut
Content-Type: application/json
Authorization: Bearer {token}

{
  "statut": "TERMINEE",
  "notes": "Procédure terminée avec succès. Documents prêts à être récupérés."
}
```

**Réponse (200 OK)** :
```json
{
  "id": 1,
  "procedure": {
    "id": 5,
    "nom": "Carte d'identité nationale",
    "titre": "Demande de carte d'identité nationale"
  },
  "statut": "EN_COURS",
  "tarif": 7000.00,
  "tarifDelegation": 3000.00,
  "coutLegal": 4000.00,
  "commune": "Commune I",
  "quartier": "Hamdallaye",
  "telephoneContact": "+22370123456",
  "dateSouhaitee": "2025-01-20",
  "commentaires": "Besoin urgent",
  "notesAgent": "Démarches administratives en cours",
  "agent": null,
  "dateAcceptation": null,
  "dateDebut": "2025-01-14T11:30:00",
  "dateFin": null,
  "dateCreation": "2025-01-14T10:30:00",
  "dateModification": "2025-01-14T11:30:00"
}
```

**Réponse d'erreur (400 Bad Request)** - Transition invalide :
```json
{
  "success": false,
  "message": "Erreur lors de la modification: Transition de statut invalide: TERMINEE -> EN_COURS. Transitions possibles: EN_ATTENTE -> EN_COURS -> TERMINEE"
}
```

**Réponse d'erreur (400 Bad Request)** - Statut invalide :
```json
{
  "success": false,
  "message": "Statut invalide: INVALIDE"
}
```

---

## 📊 Statuts Disponibles

| Statut | Description | Transitions possibles |
|--------|-------------|---------------------|
| `EN_ATTENTE` | Demande créée, en attente de traitement | → `EN_COURS` ou `TERMINEE` |
| `EN_COURS` | Demande en cours de traitement | → `TERMINEE` |
| `TERMINEE` | Demande terminée | Aucune (statut final) |

---

## 🔄 Comportement Automatique

### Lors du changement de statut :

1. **Passage à `EN_COURS`** :
   - `dateDebut` est automatiquement définie à la date/heure actuelle
   - Une notification est envoyée au client

2. **Passage à `TERMINEE`** :
   - `dateFin` est automatiquement définie à la date/heure actuelle
   - Une notification est envoyée au client

3. **Notes** :
   - Si des notes existent déjà, les nouvelles notes sont ajoutées après
   - Format : `{notes existantes}\n\n{nouvelles notes}`

---

## 📝 Exemples d'Utilisation (cURL)

### Lister toutes les délégations
```bash
curl -X GET "http://localhost:8080/api/admin/services/demandes" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -H "Content-Type: application/json"
```

### Lister les demandes en attente
```bash
curl -X GET "http://localhost:8080/api/admin/services/demandes?statut=EN_ATTENTE" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -H "Content-Type: application/json"
```

### Récupérer une demande de service spécifique
```bash
curl -X GET "http://localhost:8080/api/admin/services/demandes/1" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -H "Content-Type: application/json"
```

### Modifier le statut à EN_COURS
```bash
curl -X PUT "http://localhost:8080/api/admin/services/demandes/1/statut" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "statut": "EN_COURS",
    "notes": "Démarches administratives en cours"
  }'
```

### Modifier le statut à TERMINEE
```bash
curl -X PUT "http://localhost:8080/api/admin/services/demandes/1/statut" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "statut": "TERMINEE",
    "notes": "Procédure terminée avec succès"
  }'
```

---

## 📱 Exemples d'Utilisation (JavaScript/Fetch)

### Lister toutes les délégations
```javascript
const response = await fetch('http://localhost:8080/api/admin/services/demandes', {
  method: 'GET',
  headers: {
    'Authorization': `Bearer ${token}`,
    'Content-Type': 'application/json'
  }
});

const demandes = await response.json();
console.log(demandes);
```

### Lister les demandes par statut
```javascript
const statut = 'EN_ATTENTE'; // ou 'EN_COURS' ou 'TERMINEE'
const response = await fetch(
  `http://localhost:8080/api/admin/services/demandes?statut=${statut}`,
  {
    method: 'GET',
    headers: {
      'Authorization': `Bearer ${token}`,
      'Content-Type': 'application/json'
    }
  }
);

const demandes = await response.json();
console.log(demandes);
```

### Modifier le statut
```javascript
const demandeId = 1;
const response = await fetch(
  `http://localhost:8080/api/admin/services/demandes/${demandeId}/statut`,
  {
    method: 'PUT',
    headers: {
      'Authorization': `Bearer ${token}`,
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({
      statut: 'EN_COURS',
      notes: 'Démarches administratives en cours'
    })
  }
);

const demandeModifiee = await response.json();
console.log(demandeModifiee);
```

---

## ⚠️ Notes Importantes

1. **Tri automatique** : Les demandes sont toujours triées par date de création (plus récentes en premier)

2. **Notifications** : À chaque changement de statut, une notification est automatiquement envoyée au client

3. **Dates automatiques** : Les dates `dateDebut` et `dateFin` sont définies automatiquement selon le statut

4. **Sécurité** : Tous les endpoints vérifient que l'utilisateur est bien un admin

5. **Validation** : Les transitions de statut sont validées pour éviter les changements invalides

---

**Date de création**: 2025-01-14  
**Version**: 1.0

