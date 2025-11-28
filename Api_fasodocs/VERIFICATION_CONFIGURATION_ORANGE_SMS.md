# ✅ Vérification Configuration Orange SMS

## 📋 Comparaison avec la Documentation Orange

Selon la [documentation Orange](https://developer.orange.com/apis/sms/getting-started), voici la vérification de votre configuration :

---

## ✅ Configuration Correcte

### 1. **Base URL SMS** ✅
```properties
orange.sms.base.url=https://api.orange.com/smsmessaging/v1
```
**Statut** : ✅ **CORRECT** selon la documentation
- Documentation Orange : `https://api.orange.com/smsmessaging/v1`

### 2. **Token URL** ✅
**Statut** : ✅ **CORRECT** (hardcodé dans le code)
- Le code utilise : `https://api.orange.com/oauth/v3/token`
- Documentation Orange : `https://api.orange.com/oauth/v3/token`

### 3. **Sender Address** ✅
```properties
orange.sms.sender.address=tel:+2230000
```
**Statut** : ✅ **CORRECT** pour le Mali
- Format avec `+` : ✅ Correct pour le body
- Le code transforme automatiquement pour l'URL (sans `+`)

### 4. **Sender Name** ⚠️
```properties
orange.sms.sender.name=SMS 948223
```
**Statut** : ⚠️ **À VÉRIFIER**
- Doit être **enregistré chez Orange** avant utilisation
- Si non enregistré, contactez Orange via le formulaire

---

## ❌ Problème Identifié : Credentials

### Client ID et Client Secret

```properties
orange.sms.client.id=eeQIIfQYVsDYRDHvG5ziEHMpJ18bHlcG
orange.sms.client.secret=EJn9NPCK51YtFfq3AE5pKiWGdVmYdVdYLTb68cCtfaXt
orange.sms.application.id=iy3KWH9GiNK0evSY
```

**Statut** : ❌ **PROBLÈME** - Erreur "Unknown client"

**Cause** : Le Client ID `eeQIIfQYVsDYRDHvG5ziEHMpJ18bHlcG` n'est **pas reconnu** par Orange.

---

## 🔍 Vérifications à Effectuer

### 1. Vérifier dans le Portail Orange

1. **Connectez-vous** à https://developer.orange.com/
2. **Allez dans "MyApps"**
3. **Vérifiez** :
   - ✅ L'application existe-t-elle ?
   - ✅ Le **Client ID** affiché correspond-il à `eeQIIfQYVsDYRDHvG5ziEHMpJ18bHlcG` ?
   - ✅ Le **Client Secret** correspond-il à `EJn9NPCK51YtFfq3AE5pKiWGdVmYdVdYLTb68cCtfaXt` ?
   - ✅ L'**Application ID** correspond-il à `iy3KWH9GiNK0evSY` ?

### 2. Vérifier la Souscription à l'API SMS

Dans "MyApps" → Votre application → Section "APIs" :

- ✅ L'API **"SMS Middle East and Africa"** ou **"SMS Africa and Middle East 2.0"** est-elle **souscrite** ?
- ✅ Le **pays Mali** est-il sélectionné ?
- ✅ L'API est-elle **active** (pas désactivée) ?

### 3. Vérifier le Contrat et le Solde

Selon la documentation Orange :
> **Note** : Vous devez avoir un contrat avec une date d'expiration valide et un solde positif.

**Vérifier le solde** :
1. Dans le portail Orange, allez dans la section **"Contracts"** ou **"Bundles"**
2. Vérifiez que :
   - ✅ `availableUnits` > 0
   - ✅ `status` = "ACTIVE"
   - ✅ `expirationDate` est dans le futur

---

## 🔧 Actions Correctives

### Si les Credentials sont Différents

Si le Client ID dans le portail est **différent** de celui dans `application.properties` :

1. **Copiez** le Client ID du portail
2. **Copiez** le Client Secret du portail
3. **Copiez** l'Application ID du portail
4. **Mettez à jour** `application.properties` :

```properties
orange.sms.client.id=NOUVEAU_CLIENT_ID_DU_PORTAL
orange.sms.client.secret=NOUVEAU_CLIENT_SECRET_DU_PORTAL
orange.sms.application.id=NOUVEAU_APPLICATION_ID_DU_PORTAL
```

5. **Redémarrez** l'application

### Si l'API SMS n'est pas Souscrite

1. Dans "MyApps" → Votre application
2. Allez dans la section **"APIs"** ou **"Subscriptions"**
3. **Souscrivez** à l'API **"SMS Middle East and Africa"**
4. **Sélectionnez** le pays **Mali**
5. **Copiez** les nouveaux credentials si générés
6. **Mettez à jour** `application.properties`

### Si le Solde est Insuffisant

1. Dans le portail Orange, **achetez un bundle SMS**
2. Vérifiez que le contrat est **actif**
3. Vérifiez que le solde est **positif**

---

## 📊 Résumé de la Configuration

| Paramètre | Valeur Actuelle | Statut | Action |
|-----------|----------------|--------|--------|
| `orange.sms.base.url` | `https://api.orange.com/smsmessaging/v1` | ✅ Correct | Aucune |
| Token URL | `https://api.orange.com/oauth/v3/token` | ✅ Correct | Aucune |
| `orange.sms.sender.address` | `tel:+2230000` | ✅ Correct | Aucune |
| `orange.sms.sender.name` | `SMS 948223` | ⚠️ À vérifier | Vérifier enregistrement Orange |
| `orange.sms.client.id` | `eeQIIfQYVsDYRDHvG5ziEHMpJ18bHlcG` | ❌ Non reconnu | **Vérifier dans le portail** |
| `orange.sms.client.secret` | `EJn9NPCK51YtFfq3AE5pKiWGdVmYdVdYLTb68cCtfaXt` | ❌ Non reconnu | **Vérifier dans le portail** |
| `orange.sms.application.id` | `iy3KWH9GiNK0evSY` | ❓ À vérifier | **Vérifier dans le portail** |

---

## ✅ Checklist de Vérification

- [ ] Connecté au portail Orange (https://developer.orange.com/)
- [ ] Application visible dans "MyApps"
- [ ] Client ID du portail = `eeQIIfQYVsDYRDHvG5ziEHMpJ18bHlcG`
- [ ] Client Secret du portail = `EJn9NPCK51YtFfq3AE5pKiWGdVmYdVdYLTb68cCtfaXt`
- [ ] Application ID du portail = `iy3KWH9GiNK0evSY`
- [ ] API "SMS Middle East and Africa" souscrite
- [ ] Pays Mali sélectionné
- [ ] Contrat actif avec solde positif
- [ ] Sender name "SMS 948223" enregistré chez Orange

---

## 🧪 Test Manuel

Une fois les credentials vérifiés, testez manuellement :

```bash
# 1. Générer le Basic Auth header
echo -n "CLIENT_ID:CLIENT_SECRET" | base64

# 2. Tester l'authentification
curl -X POST \
-H "Authorization: Basic {base64_généré}" \
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

---

## 📝 Conclusion

**Configuration technique** : ✅ **CORRECTE** selon la documentation Orange

**Problème** : ❌ Les **credentials** (Client ID, Client Secret) ne sont **pas reconnus** par Orange.

**Solution** : 
1. Vérifiez les credentials dans le portail Orange
2. Assurez-vous que l'API SMS est souscrite
3. Mettez à jour `application.properties` si nécessaire
4. Vérifiez le solde SMS

Le code est correct, le problème vient des credentials Orange.



