# 📱 Guide de Configuration Orange SMS API - FasoDocs

## 🎯 Vue d'ensemble

Ce guide explique comment configurer l'API Orange SMS pour l'envoi de SMS dans FasoDocs. Le système utilise maintenant **Orange SMS API** (l'opérateur Orange Mali) pour envoyer des codes de vérification SMS lors de la connexion.

---

## ✅ CONFIGURATION DÉJÀ EFFECTUÉE

Tous les fichiers nécessaires ont été créés :

### 1. Service Orange SMS créé
- ✅ `src/main/java/ml/fasodocs/backend/service/OrangeSmsService.java`
- ✅ Format des numéros Mali (`+223XXXXXXXX`)
- ✅ Intégration conforme à la documentation Swagger Orange
- ✅ Gestion des erreurs et logs

### 2. Configuration application.properties
- ✅ Identifiants Orange configurés
- ✅ Client ID et Secret configurés
- ✅ Authorization header configuré
- ✅ Sender Address configuré pour le Mali (`tel:+2230000`)

### 3. Modification de AuthService
- ✅ Remplacement de `TwilioSmsService` par `OrangeSmsService`
- ✅ Toutes les méthodes d'envoi SMS utilisent maintenant Orange

---

## 🚀 FONCTIONNEMENT

### Format des Numéros Mali

Le service convertit automatiquement le format :
- **Entrée** : `+22370123456`
- **Format Orange** : `tel:+22370123456`

### Endpoint Utilisé

Selon la documentation Swagger Orange :
```
POST https://api.orange.com/smsmessaging/v1/outbound/{senderAddress}/requests
```

### Structure de la Requête

```json
{
  "outboundSMSMessageRequest": {
    "address": "tel:+22370123456",
    "senderAddress": "tel:+2230000",
    "outboundSMSTextMessage": {
      "message": "Votre code de vérification FasoDocs est: 123456..."
    }
  }
}
```

---

## 🧪 TESTS

### Test 1 : Connexion par Téléphone

**Avec Postman** :

```http
POST http://localhost:8080/api/auth/connexion-telephone
Content-Type: application/json

{
  "telephone": "+22370123456"
}
```

**Réponse attendue** :
```json
{
  "success": true,
  "message": "Un code de vérification a été envoyé au +223701***"
}
```

### Mode Développement

Si `orange.sms.enabled=false` dans `application.properties`, le code sera affiché dans les logs :

```
WARN - Orange SMS désactivé. Message: Votre code de vérification...
WARN - Destinataire: +22370123456, Code: 123456
```

### Mode Production

Si `orange.sms.enabled=true`, un SMS sera envoyé via l'API Orange.

---

## 🔒 SÉCURITÉ

### Identifiants Configurés

Dans `application.properties` :
```properties
orange.sms.client.id=eeQIIfQYVsDYRDHvG5ziEHMpJ18bHlcG
orange.sms.client.secret=JjmeLzMZZUEmh7GQCsiqFY5uoNukYdZ75iDXE6EedOKJ
orange.sms.authorization.header=ZWVRSUlmUVlWc0RZUkRIdkc1emlFSE1wSjE4YkhsY0c6SmptZUx6TVpaVUVtaDdHUUNzaXFGWTV1b051a1lkWjc1aURYRTZFZWRPS0o
```

### Variables d'Environnement (Recommandé pour Production)

Pour la production, utilisez des variables d'environnement :

```bash
# Windows
set ORANGE_SMS_CLIENT_ID=eeQIIfQYVsDYRDHvG5ziEHMpJ18bHlcG
set ORANGE_SMS_CLIENT_SECRET=JjmeLzMZZUEmh7GQCsiqFY5uoNukYdZ75iDXE6EedOKJ

# Linux/Mac
export ORANGE_SMS_CLIENT_ID=eeQIIfQYVsDYRDHvG5ziEHMpJ18bHlcG
export ORANGE_SMS_CLIENT_SECRET=JjmeLzMZZUEmh7GQCsiqFY5uoNukYdZ75iDXE6EedOKJ
```

Puis modifiez `application.properties` :
```properties
orange.sms.client.id=${ORANGE_SMS_CLIENT_ID}
orange.sms.client.secret=${ORANGE_SMS_CLIENT_SECRET}
```

---

## 📊 MONITORING

### Logs Orange SMS

Le service log automatiquement :
- ✅ **SMS envoyés** avec succès
- ❌ **Erreurs d'envoi**
- ⚠️ **SMS désactivés** en mode dev

### Exemple de Logs

**Succès** :
```
INFO - SMS Orange envoyé avec succès à +22370123456. Réponse: {...}
```

**Erreur** :
```
ERROR - Erreur lors de l'envoi SMS Orange à +22370123456. Code: 401 Unauthorized
```

---

## 🚨 DÉPANNAGE

### Problème 1 : Erreur 401 Unauthorized

**Cause** : Authorization header incorrect ou expiré

**Solution** :
1. Vérifiez que l'Authorization header est correct dans `application.properties`
2. Si besoin, régénérez les identifiants dans votre dashboard Orange Developer

### Problème 2 : Format de téléphone invalide

**Cause** : Numéro au mauvais format

**Solution** :
- Utilisez le format malien : `+223XXXXXXXX`
- Exemple valide : `+22370123456`
- 8 chiffres après `+223`

### Problème 3 : SMS non reçu

**Vérifications** :
- Vérifiez que `orange.sms.enabled=true`
- Vérifiez vos logs pour les erreurs
- Vérifiez votre crédit Orange Developer
- Vérifiez que le numéro destinataire est valide

### Problème 4 : Code d'erreur de l'API Orange

Selon la documentation Swagger, voici les codes d'erreur :

| Code | Signification |
|------|---------------|
| 400 | Erreur de service ou valeur invalide |
| 403 | Erreur de politique (trop de destinataires, etc.) |
| 404 | Information non disponible |
| 406 | Type de média non supporté |
| 409 | `clientCorrelator` déjà utilisé |
| 503 | Pas de ressources serveur disponibles |

---

## 💰 COÛTS ORANGE

Contactez Orange Mali pour connaître les tarifs exacts de l'API SMS.

---

## 🔄 MIGRATION DEPUIS TWILIO

### Changements Effectués

1. ✅ **Service créé** : `OrangeSmsService.java`
2. ✅ **Service modifié** : `AuthService.java` (utilise maintenant Orange au lieu de Twilio)
3. ✅ **Configuration** : `application.properties` avec identifiants Orange
4. ✅ **Twilio désactivé** : `twilio.sms.enabled=false`

### Compatibilité

- ✅ **Ancien endpoint** : `/api/auth/connexion` toujours disponible
- ✅ **Nouveau endpoint** : `/api/auth/connexion-telephone` toujours disponible
- ✅ **Vérification SMS** : Même endpoint `/api/auth/verifier-sms`
- ✅ **Format téléphone** : Même format `+223XXXXXXXX`

---

## 📝 NOTES IMPORTANTES

### Sender Address

Le `senderAddress` est configuré à `tel:+2230000` (générique pour le Mali). 
Orange remplacera automatiquement ce numéro selon les besoins (onnet/offnet).

### Documentation Orange

Documentation complète : https://developer.orange.com/apis/sms/getting-started

### Format des Messages SMS

Le service envoie des messages avec :
- Code à 6 chiffres
- Instructions claires
- Avertissement de sécurité
- Délai d'expiration (5 minutes)

---

## ✅ CHECKLIST DE VÉRIFICATION

- [x] Service OrangeSmsService créé
- [x] Configuration dans application.properties
- [x] AuthService modifié
- [x] Identifiants Orange configurés
- [x] Format téléphone Mali configuré
- [x] Documentation créée

**Prêt à tester !** 🚀

---

**© 2025 FasoDocs - Simplifiant les procédures administratives au Mali** 🇲🇱
