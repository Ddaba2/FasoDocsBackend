# 📡 Nouveaux Endpoints - Service (remplacement de Délégation)

**Date**: 2025-01-14  
**Version**: 1.0

---

## 🔄 Changements Effectués

Tous les endpoints et entités liés à **"délégation"** ont été remplacés par **"service"**.

---

## 📍 Base URL

```
http://localhost:8080/api
```

---

## 🔐 Endpoints Utilisateur (Flutter)

### 1. **Obtenir le tarif d'un service**

**GET** `/services/procedures/{procedureId}/tarif?commune={commune}`

**Description** : Récupère le tarif d'un service pour une procédure dans une commune donnée.

**Paramètres** :
- `procedureId` (path) : ID de la procédure
- `commune` (query) : Nom de la commune

**Exemple** :
```
GET /api/services/procedures/1/tarif?commune=Commune I
```

**Réponse (200 OK)** :
```json
{
  "procedureId": 1,
  "procedureNom": "Carte d'identité nationale",
  "tarifService": 3000.00,
  "coutLegal": 5000.00,
  "tarifTotal": 8000.00,
  "commune": "Commune I",
  "description": "Service complet incluant la prise en charge de votre procédure, le suivi des démarches et la récupération des documents.",
  "delaiEstime": "15 jours"
}
```

---

### 2. **Créer une demande de service**

**POST** `/services/demandes`

**Description** : Crée une nouvelle demande de service.

**Body** :
```json
{
  "procedureId": 1,
  "commune": "Commune I",
  "quartier": "Quartier XYZ",
  "telephoneContact": "+22370123456",
  "dateSouhaitee": "2025-02-01",
  "commentaires": "Instructions spéciales",
  "accepteTarif": true
}
```

**Réponse (200 OK)** :
```json
{
  "id": 1,
  "procedure": {
    "id": 1,
    "nom": "Carte d'identité nationale",
    "titre": "Carte d'identité nationale"
  },
  "statut": "EN_ATTENTE",
  "tarif": 8000.00,
  "tarifService": 3000.00,
  "coutLegal": 5000.00,
  "commune": "Commune I",
  "quartier": "Quartier XYZ",
  "telephoneContact": "+22370123456",
  "dateSouhaitee": "2025-02-01",
  "commentaires": "Instructions spéciales",
  "dateCreation": "2025-01-14T10:00:00"
}
```

---

### 3. **Récupérer mes demandes de service**

**GET** `/services/mes-demandes`

**Description** : Récupère toutes les demandes de service de l'utilisateur connecté.

**Réponse (200 OK)** :
```json
[
  {
    "id": 1,
    "procedure": {
      "id": 1,
      "nom": "Carte d'identité nationale",
      "titre": "Carte d'identité nationale"
    },
    "statut": "EN_ATTENTE",
    "tarif": 8000.00,
    "tarifService": 3000.00,
    "coutLegal": 5000.00,
    "commune": "Commune I",
    "dateCreation": "2025-01-14T10:00:00"
  }
]
```

---

### 4. **Récupérer une demande de service par ID**

**GET** `/services/demandes/{id}`

**Description** : Récupère une demande de service spécifique.

**Paramètres** :
- `id` (path) : ID de la demande

**Réponse (200 OK)** :
```json
{
  "id": 1,
  "procedure": {
    "id": 1,
    "nom": "Carte d'identité nationale",
    "titre": "Carte d'identité nationale"
  },
  "statut": "EN_ATTENTE",
  "tarif": 8000.00,
  "tarifService": 3000.00,
  "coutLegal": 5000.00,
  "commune": "Commune I",
  "quartier": "Quartier XYZ",
  "telephoneContact": "+22370123456",
  "dateSouhaitee": "2025-02-01",
  "commentaires": "Instructions spéciales",
  "dateCreation": "2025-01-14T10:00:00"
}
```

---

### 5. **Annuler une demande de service**

**PUT** `/services/demandes/{id}/annuler?raison={raison}`

**Description** : Annule une demande de service (uniquement si statut = EN_ATTENTE).

**Paramètres** :
- `id` (path) : ID de la demande
- `raison` (query, optionnel) : Raison de l'annulation

**Réponse (200 OK)** :
```json
{
  "success": true,
  "message": "Demande annulée avec succès. L'admin sera informé."
}
```

---

## 👨‍💼 Endpoints Admin

### 1. **Liste toutes les demandes de service**

**GET** `/admin/services/demandes?statut={statut}`

**Description** : Liste toutes les demandes de service (Admin uniquement).

**Paramètres** :
- `statut` (query, optionnel) : Filtrer par statut (EN_ATTENTE, EN_COURS, TERMINEE)

**Exemples** :
```
GET /api/admin/services/demandes
GET /api/admin/services/demandes?statut=EN_ATTENTE
GET /api/admin/services/demandes?statut=EN_COURS
GET /api/admin/services/demandes?statut=TERMINEE
```

**Réponse (200 OK)** :
```json
[
  {
    "id": 1,
    "procedure": {
      "id": 1,
      "nom": "Carte d'identité nationale",
      "titre": "Carte d'identité nationale"
    },
    "statut": "EN_ATTENTE",
    "tarif": 8000.00,
    "tarifService": 3000.00,
    "coutLegal": 5000.00,
    "commune": "Commune I",
    "dateCreation": "2025-01-14T10:00:00"
  }
]
```

---

### 2. **Récupérer une demande de service par ID (Admin)**

**GET** `/admin/services/demandes/{id}`

**Description** : Récupère une demande de service spécifique (Admin uniquement).

**Paramètres** :
- `id` (path) : ID de la demande

**Réponse (200 OK)** :
```json
{
  "id": 1,
  "procedure": {
    "id": 1,
    "nom": "Carte d'identité nationale",
    "titre": "Carte d'identité nationale"
  },
  "statut": "EN_ATTENTE",
  "tarif": 8000.00,
  "tarifService": 3000.00,
  "coutLegal": 5000.00,
  "commune": "Commune I",
  "quartier": "Quartier XYZ",
  "telephoneContact": "+22370123456",
  "dateSouhaitee": "2025-02-01",
  "commentaires": "Instructions spéciales",
  "notesAgent": null,
  "agent": null,
  "dateCreation": "2025-01-14T10:00:00"
}
```

---

### 3. **Modifier le statut d'une demande de service**

**PUT** `/admin/services/demandes/{id}/statut`

**Description** : Modifie le statut d'une demande de service (Admin uniquement).

**Paramètres** :
- `id` (path) : ID de la demande

**Body** :
```json
{
  "statut": "EN_COURS",
  "notes": "Traitement en cours par l'agent XYZ"
}
```

**Statuts possibles** :
- `EN_ATTENTE` : En attente de traitement
- `EN_COURS` : Traitement en cours
- `TERMINEE` : Procédure terminée

**Transitions valides** :
- `EN_ATTENTE` → `EN_COURS`
- `EN_ATTENTE` → `TERMINEE`
- `EN_COURS` → `TERMINEE`

**Réponse (200 OK)** :
```json
{
  "id": 1,
  "procedure": {
    "id": 1,
    "nom": "Carte d'identité nationale",
    "titre": "Carte d'identité nationale"
  },
  "statut": "EN_COURS",
  "tarif": 8000.00,
  "tarifService": 3000.00,
  "coutLegal": 5000.00,
  "commune": "Commune I",
  "notesAgent": "Traitement en cours par l'agent XYZ",
  "dateDebut": "2025-01-14T11:00:00",
  "dateCreation": "2025-01-14T10:00:00"
}
```

---

## 📊 Comparaison Ancien / Nouveau

| Ancien Endpoint | Nouveau Endpoint |
|----------------|------------------|
| `/delegations/procedures/{id}/tarif` | `/services/procedures/{id}/tarif` |
| `/delegations/demandes` | `/services/demandes` |
| `/delegations/mes-demandes` | `/services/mes-demandes` |
| `/delegations/demandes/{id}` | `/services/demandes/{id}` |
| `/delegations/demandes/{id}/annuler` | `/services/demandes/{id}/annuler` |
| `/admin/delegations/demandes` | `/admin/services/demandes` |
| `/admin/delegations/demandes/{id}` | `/admin/services/demandes/{id}` |
| `/admin/delegations/demandes/{id}/statut` | `/admin/services/demandes/{id}/statut` |

---

## 🔄 Changements dans les DTOs

| Ancien DTO | Nouveau DTO |
|-----------|-------------|
| `CreerDemandeDelegationRequest` | `CreerDemandeServiceRequest` |
| `DemandeDelegationResponse` | `DemandeServiceResponse` |
| `TarifDelegationResponse` | `TarifServiceResponse` |
| `ModifierStatutDemandeRequest` | `ModifierStatutDemandeRequest` (inchangé) |

---

## 🔄 Changements dans les Entités

| Ancien | Nouveau |
|--------|---------|
| `DemandeDelegation` | `DemandeService` |
| `DemandeDelegationRepository` | `DemandeServiceRepository` |
| `DelegationService` | `ServiceService` |
| `DelegationController` | `ServiceController` |
| Table `demandes_delegation` | Table `demandes_service` |
| Colonne `tarif_delegation` | Colonne `tarif_service` |

---

## 📝 Notes Importantes

1. **Migration de base de données** : Une migration SQL sera nécessaire pour renommer la table et les colonnes.

2. **Notifications** : Les notifications continuent de fonctionner, mais les messages mentionnent maintenant "service" au lieu de "délégation".

3. **Emails** : Les emails envoyés aux admins mentionnent maintenant "demande de service" au lieu de "demande de délégation".

4. **Statuts** : Les statuts restent identiques : `EN_ATTENTE`, `EN_COURS`, `TERMINEE`.

---

## 🧪 Tests

### Test 1 : Obtenir le tarif

```bash
curl -X GET "http://localhost:8080/api/services/procedures/1/tarif?commune=Commune%20I"
```

### Test 2 : Créer une demande

```bash
curl -X POST "http://localhost:8080/api/services/demandes" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -d '{
    "procedureId": 1,
    "commune": "Commune I",
    "quartier": "Quartier XYZ",
    "telephoneContact": "+22370123456",
    "dateSouhaitee": "2025-02-01",
    "commentaires": "Instructions spéciales",
    "accepteTarif": true
  }'
```

### Test 3 : Liste des demandes (Admin)

```bash
curl -X GET "http://localhost:8080/api/admin/services/demandes" \
  -H "Authorization: Bearer ADMIN_TOKEN"
```

---

**Date de création**: 2025-01-14  
**Version**: 1.0

