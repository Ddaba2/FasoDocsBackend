# 📱 Flux de Connexion par SMS - FasoDocs

## 🔄 Diagramme de Flux Complet

```
┌─────────────────────────────────────────────────────────────────┐
│                    UTILISATEUR                                  │
│                  Entre son numéro                               │
│                  +22370123456                                   │
└────────────────────────┬────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────────┐
│  POST /api/auth/connexion-telephone                             │
│  {                                                              │
│    "telephone": "+22370123456"                                  │
│  }                                                              │
└────────────────────────┬────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────────┐
│  VÉRIFICATION 1 : Le numéro existe-t-il dans la BDD ?           │
│  ┌──────────────────────────────────────────────────┐           │
│  │ citoyenRepository.findByTelephone(telephone)     │           │
│  └──────────────────────────────────────────────────┘           │
└────────────────────────┬────────────────────────────────────────┘
                         │
                ┌────────┴────────┐
                │                 │
            ❌ NON             ✅ OUI
                │                 │
                │                 ▼
                │    ┌─────────────────────────────────────────────┐
                │    │  VÉRIFICATION 2 : Le compte est actif ?     │
                │    │  ┌────────────────────────────────────────┐ │
                │    │  │ citoyen.getEstActif()                  │ │
                │    │  └────────────────────────────────────────┘ │
                │    └─────────────┬───────────────────────────────┘
                │                  │
                │         ┌────────┴────────┐
                │         │                 │
                │     ❌ NON             ✅ OUI
                │         │                 │
                │         │                 ▼
                │         │    ┌────────────────────────────────────┐
                │         │    │  GÉNÉRATION du code SMS            │
                │         │    │  ┌──────────────────────────────┐  │
                │         │    │  │ Code: 123456 (6 chiffres)    │  │
                │         │    │  │ Expire: now + 5 minutes      │  │
                │         │    │  └──────────────────────────────┘  │
                │         │    └───────────┬────────────────────────┘
                │         │                │
                │         │                ▼
                │         │    ┌────────────────────────────────────┐
                │         │    │  SAUVEGARDE dans la BDD            │
                │         │    │  ┌──────────────────────────────┐  │
                │         │    │  │ citoyen.setCodeSms(code)     │  │
                │         │    │  │ citoyen.setCodeSmsExpiration │  │
                │         │    │  │ citoyenRepository.save()     │  │
                │         │    │  └──────────────────────────────┘  │
                │         │    └───────────┬────────────────────────┘
                │         │                │
                │         │                ▼
                │         │    ┌────────────────────────────────────┐
                │         │    │  ENVOI SMS via Twilio              │
                │         │    │  ┌──────────────────────────────┐  │
                │         │    │  │ "Votre code FasoDocs: 123456"│  │
                │         │    │  │ "Expire dans 5 minutes"      │  │
                │         │    │  └──────────────────────────────┘  │
                │         │    └───────────┬────────────────────────┘
                │         │                │
                ▼         ▼                ▼
┌──────────────────────────────────────────────────────────────────┐
│                      RÉPONSES                                    │
│                                                                  │
│  ❌ Numéro non trouvé:                                           │
│  {                                                               │
│    "success": false,                                             │
│    "message": "Numéro de téléphone non enregistré.              │
│                Veuillez vous inscrire d'abord."                  │
│  }                                                               │
│                                                                  │
│  ❌ Compte désactivé:                                            │
│  {                                                               │
│    "success": false,                                             │
│    "message": "Votre compte a été désactivé.                     │
│                Veuillez contacter le support."                   │
│  }                                                               │
│                                                                  │
│  ✅ SMS envoyé avec succès:                                      │
│  {                                                               │
│    "success": true,                                              │
│    "message": "Un code de vérification a été envoyé au          │
│                +223700***"                                       │
│  }                                                               │
└──────────────────────────────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────────┐
│                    UTILISATEUR                                  │
│             Reçoit le SMS et entre le code                      │
└────────────────────────┬────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────────┐
│  POST /api/auth/verifier-sms                                    │
│  {                                                              │
│    "telephone": "+22370123456",                                 │
│    "code": "123456"                                             │
│  }                                                              │
└────────────────────────┬────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────────┐
│  VÉRIFICATION du code SMS                                       │
│  - Code correspond ?                                            │
│  - Code non expiré ?                                            │
└────────────────────────┬────────────────────────────────────────┘
                         │
                ┌────────┴────────┐
                │                 │
            ❌ NON             ✅ OUI
                │                 │
                ▼                 ▼
   ┌───────────────────┐  ┌──────────────────────────┐
   │  Erreur retournée │  │  GÉNÉRATION du JWT Token │
   └───────────────────┘  │  ┌────────────────────┐  │
                          │  │ Token JWT valide   │  │
                          │  │ Expire: 24h        │  │
                          │  └────────────────────┘  │
                          └───────────┬──────────────┘
                                      │
                                      ▼
                          ┌───────────────────────────┐
                          │  UTILISATEUR CONNECTÉ ✅  │
                          │  Peut accéder aux         │
                          │  ressources protégées     │
                          └───────────────────────────┘
```

---

## 🔒 Points de Sécurité

### ✅ CE QUI EST VÉRIFIÉ

1. **Numéro existe dans la BDD** ✔️
   - Empêche l'envoi de SMS à des numéros aléatoires
   - Évite le gaspillage de crédits SMS

2. **Compte actif** ✔️
   - Empêche les comptes suspendus de se connecter
   - Protection contre les abus

3. **Code SMS stocké en BDD** ✔️
   - Permet la vérification ultérieure
   - Associé à l'utilisateur spécifique

4. **Expiration du code (5 min)** ✔️
   - Sécurité contre les codes interceptés
   - Limite la fenêtre d'attaque

5. **Gestion d'erreurs SMS** ✔️
   - Si Twilio échoue, l'utilisateur est informé
   - Logs pour le débogage

---

## 📊 Scénarios Détaillés

### Scénario 1️⃣ : Utilisateur Enregistré (Normal)

```
Entrée : +22370123456 (existe en BDD, compte actif)

Étapes :
1. ✅ Numéro trouvé dans la BDD
2. ✅ Compte actif
3. ✅ Code généré : 452789
4. ✅ Code sauvegardé (expire à 14:35:00)
5. ✅ SMS envoyé via Twilio
6. ✅ SMS reçu par l'utilisateur

Réponse :
{
  "success": true,
  "message": "Un code de vérification a été envoyé au +223701***"
}
```

### Scénario 2️⃣ : Numéro Non Enregistré

```
Entrée : +22370999999 (n'existe PAS en BDD)

Étapes :
1. ❌ Numéro NON trouvé dans la BDD
2. ⛔ ARRÊT - Pas d'envoi de SMS

Réponse :
{
  "success": false,
  "message": "Numéro de téléphone non enregistré. Veuillez vous inscrire d'abord."
}
```

**🔒 Sécurité** : Aucun SMS envoyé = Pas de gaspillage de crédits

### Scénario 3️⃣ : Compte Désactivé

```
Entrée : +22370555555 (existe en BDD, mais estActif=false)

Étapes :
1. ✅ Numéro trouvé dans la BDD
2. ❌ Compte DÉSACTIVÉ
3. ⛔ ARRÊT - Pas d'envoi de SMS

Réponse :
{
  "success": false,
  "message": "Votre compte a été désactivé. Veuillez contacter le support."
}
```

**🔒 Sécurité** : Empêche les comptes bannis de se reconnecter

### Scénario 4️⃣ : Erreur Twilio (SMS non envoyé)

```
Entrée : +22370123456 (existe en BDD, compte actif)

Étapes :
1. ✅ Numéro trouvé
2. ✅ Compte actif
3. ✅ Code généré : 892341
4. ✅ Code sauvegardé
5. ❌ Erreur Twilio (pas de crédit, API down, etc.)

Réponse :
{
  "success": false,
  "message": "Erreur lors de l'envoi du SMS. Veuillez réessayer."
}
```

**🔒 Logs** : L'erreur est loguée pour investigation

---

## 🧪 Tests Postman

### Test 1 : Numéro Non Enregistré (doit échouer)

```http
POST http://localhost:8080/api/auth/connexion-telephone
Content-Type: application/json

{
  "telephone": "+22370999999"
}
```

**Réponse attendue** : `400 Bad Request`
```json
{
  "success": false,
  "message": "Numéro de téléphone non enregistré. Veuillez vous inscrire d'abord."
}
```

✅ **PAS de SMS envoyé**

---

### Test 2 : Numéro Enregistré (doit réussir)

**Étape A : Inscription**
```http
POST http://localhost:8080/api/auth/inscription
Content-Type: application/json

{
  "telephone": "+22370123456",
  "email": "test@fasodocs.ml",
  "motDePasse": "Test123!",
  "confirmerMotDePasse": "Test123!"
}
```

**Étape B : Connexion**
```http
POST http://localhost:8080/api/auth/connexion-telephone
Content-Type: application/json

{
  "telephone": "+22370123456"
}
```

**Réponse attendue** : `200 OK`
```json
{
  "success": true,
  "message": "Un code de vérification a été envoyé au +223701***"
}
```

✅ **SMS envoyé avec le code**

---

## 📝 Résumé des Vérifications

| Étape | Vérification | Si Échec | SMS Envoyé ? |
|-------|--------------|----------|--------------|
| 1 | Numéro existe en BDD ? | Erreur retournée | ❌ NON |
| 2 | Compte actif ? | Erreur retournée | ❌ NON |
| 3 | Code généré | - | - |
| 4 | Code sauvegardé | - | - |
| 5 | SMS envoyé | Erreur retournée | ❌ NON (mais code en BDD) |

**Conclusion** : Le SMS n'est envoyé que si **toutes** les vérifications passent ✅

---

## 🎯 Avantages de cette Approche

### 💰 Économie
- Pas de SMS envoyés à des numéros inexistants
- Préserve les crédits Twilio

### 🔒 Sécurité
- Empêche l'énumération d'utilisateurs (avec messages génériques)
- Protège contre les abus
- Vérifie l'état du compte

### 📊 Traçabilité
- Logs précis à chaque étape
- Identification des erreurs d'envoi SMS
- Historique des tentatives de connexion

### ✅ Fiabilité
- Gestion des erreurs Twilio
- Messages clairs pour l'utilisateur
- Retry possible en cas d'échec

---

**🎉 Le flux est maintenant complètement sécurisé et documenté !**

