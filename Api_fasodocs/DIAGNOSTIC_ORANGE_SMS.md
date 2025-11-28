# 🔍 Diagnostic Orange SMS - Problèmes et Solutions

## 📋 Vérifications à Faire

### 1. **Vérifier les Credentials dans le Portail Orange**

Selon la [documentation Orange](https://developer.orange.com/apis/sms/getting-started), les credentials se trouvent dans la section **"MyApps"** du portail.

**Actions** :
1. Connectez-vous à https://developer.orange.com/
2. Allez dans **"MyApps"**
3. Vérifiez que :
   - Le **Client ID** correspond à `orange.sms.client.id` dans `application.properties`
   - Le **Client Secret** correspond à `orange.sms.client.secret` dans `application.properties`
   - L'**Application ID** correspond à `orange.sms.application.id` dans `application.properties`

⚠️ **IMPORTANT** : Si le Client Secret a été régénéré dans le portail, vous devez mettre à jour `application.properties` !

---

### 2. **Vérifier le Format de l'URL d'Authentification**

Selon la documentation Orange, l'URL correcte est :
```
POST https://api.orange.com/oauth/v3/token
```

**Headers requis** :
```
Authorization: Basic {base64(clientId:clientSecret)}
Content-Type: application/x-www-form-urlencoded
Accept: application/json
```

**Body requis** :
```
grant_type=client_credentials
```

⚠️ **IMPORTANT** : Ne PAS ajouter `scope=SMS` dans le body selon la documentation officielle !

---

### 3. **Vérifier le Format de l'URL d'Envoi SMS**

Selon la documentation Orange, l'URL doit être :
```
POST https://api.orange.com/smsmessaging/v1/outbound/{senderAddress}/requests
```

**Format du senderAddress dans l'URL** :
- Doit être **URL-encodé**
- Format : `tel:2230000` (sans le `+` devant le code pays)
- Après encodage : `tel%3A2230000`

**Format du senderAddress dans le Body** :
- Format : `tel:+2230000` (avec le `+` devant le code pays)

---

### 4. **Vérifier le Format du Numéro de Destinataire**

Le numéro de téléphone doit être au format :
```
tel:+223XXXXXXXX
```

Où `223` est le code pays du Mali et `XXXXXXXX` est le numéro à 8 chiffres.

**Exemples valides** :
- `tel:+22370123456`
- `tel:+22390123456`

---

### 5. **Vérifier le Sender Name**

Le sender name doit être **enregistré chez Orange** avant utilisation.

**Actions** :
1. Contactez Orange via le [formulaire de contact](https://developer.orange.com/apis/sms/getting-started) pour enregistrer votre sender name
2. Fournissez une preuve que vous êtes autorisé à utiliser ce sender name
3. Une fois approuvé, utilisez-le dans `orange.sms.sender.name`

⚠️ **IMPORTANT** : Le sender name par défaut "SMS 948223" doit être enregistré chez Orange !

---

### 6. **Vérifier le ClientCorrelator**

Le `clientCorrelator` est **optionnel** selon la documentation Orange. Si vous recevez une erreur 400, essayez de le retirer.

**Dans le code actuel** :
```java
outboundSMSMessageRequest.put("clientCorrelator", applicationId);
```

**Si erreur 400** : Commenter cette ligne et tester à nouveau.

---

### 7. **Vérifier le Contrat et le Solde**

Selon la documentation Orange :
> **Note** : Vous devez avoir un contrat avec une date d'expiration valide et un solde positif.

**Vérifier le solde** :
```bash
curl -X GET \
-H "Authorization: Bearer {access_token}" \
"https://api.orange.com/sms/admin/v1/contracts"
```

**Réponse attendue** :
```json
[
    {
        "id": "...",
        "availableUnits": 120,
        "status": "ACTIVE",
        "expirationDate": "2023-01-07T15:04:20.653Z"
    }
]
```

⚠️ **IMPORTANT** : Si `availableUnits` est 0 ou `status` est "EXPIRED", vous devez acheter un nouveau bundle !

---

### 8. **Vérifier le Rate Limiting**

Selon la documentation Orange :
> **Le TPS est limité à 5 SMS par seconde.**

Le code implémente déjà cette limite, mais vérifiez les logs pour voir si elle est atteinte.

---

## 🔧 Corrections à Appliquer

### Correction 1 : Format de l'Authentification

**Problème** : Le code essaie plusieurs configurations, mais selon la doc Orange, il faut utiliser :
- URL : `https://api.orange.com/oauth/v3/token`
- Body : `grant_type=client_credentials` (sans `scope`)

**Solution** : Simplifier l'authentification pour utiliser uniquement la configuration officielle.

### Correction 2 : Format du SenderAddress dans l'URL

**Problème** : Le senderAddress doit être au format `tel:2230000` (sans `+`) dans l'URL.

**Solution** : Vérifier que `prepareSenderForUrl()` enlève bien le `+`.

### Correction 3 : ClientCorrelator Optionnel

**Problème** : Le `clientCorrelator` peut causer une erreur 400 si le format est incorrect.

**Solution** : Rendre le `clientCorrelator` optionnel ou utiliser un format UUID.

### Correction 4 : Gestion des Erreurs

**Problème** : Les erreurs Orange ne sont pas toujours bien affichées.

**Solution** : Améliorer le logging pour afficher toutes les erreurs Orange.

---

## 🧪 Test Manuel de l'API Orange

### Étape 1 : Obtenir un Token

```bash
curl -X POST \
-H "Authorization: Basic {base64(clientId:clientSecret)}" \
-H "Content-Type: application/x-www-form-urlencoded" \
-H "Accept: application/json" \
-d "grant_type=client_credentials" \
https://api.orange.com/oauth/v3/token
```

**Réponse attendue** :
```json
{
    "token_type": "Bearer",
    "access_token": "...",
    "expires_in": "3600"
}
```

### Étape 2 : Envoyer un SMS

```bash
curl -X POST \
-H "Authorization: Bearer {access_token}" \
-H "Content-Type: application/json" \
-H "Accept: application/json" \
-d '{
    "outboundSMSMessageRequest": {
        "address": "tel:+22370123456",
        "senderAddress": "tel:+2230000",
        "outboundSMSTextMessage": {
            "message": "Test SMS"
        }
    }
}' \
"https://api.orange.com/smsmessaging/v1/outbound/tel%3A2230000/requests"
```

**Réponse attendue** (201 Created) :
```json
{
    "outboundSMSMessageRequest": {
        "resourceURL": "...",
        "deliveryInfoList": {
            "resourceURL": "..."
        }
    }
}
```

---

## 📝 Logs à Vérifier

Lors de la connexion, vérifiez les logs pour :

1. **Authentification** :
   ```
   ✅✅✅ AUTHENTIFICATION RÉUSSIE AVEC L'API ORANGE SMS ✅✅✅
   ```

2. **Envoi SMS** :
   ```
   ✅ SMS envoyé avec succès à +223XXXXXXXX
   ```

3. **Erreurs possibles** :
   - `401 UNAUTHORIZED` : Credentials invalides
   - `400 BAD REQUEST` : Format incorrect (senderAddress, destinataire, etc.)
   - `403 FORBIDDEN` : Contrat expiré ou solde insuffisant
   - `500 INTERNAL SERVER ERROR` : Problème serveur Orange

---

## ✅ Checklist de Diagnostic

- [ ] Credentials vérifiés dans le portail Orange
- [ ] Client Secret non régénéré
- [ ] Contrat actif avec solde positif
- [ ] Sender name enregistré chez Orange
- [ ] Format du numéro de téléphone correct (`tel:+223XXXXXXXX`)
- [ ] Format du senderAddress correct (URL sans `+`, Body avec `+`)
- [ ] Rate limiting respecté (max 5 SMS/seconde)
- [ ] Token obtenu avec succès
- [ ] Test manuel de l'API réussi

---

## 🆘 Support Orange

Si le problème persiste après toutes ces vérifications :

1. Contactez le support Orange via le [formulaire de contact](https://developer.orange.com/apis/sms/getting-started)
2. Fournissez :
   - Client ID
   - Application ID
   - Messages d'erreur complets
   - Logs de l'authentification et de l'envoi
