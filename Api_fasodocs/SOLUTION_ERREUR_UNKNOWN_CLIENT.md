# 🔧 Solution : Erreur "Unknown client" Orange SMS

## ❌ Erreur Identifiée

```
"error":"invalid_client"
"error_description":"Unknown client 'eeQIIfQYVsDYRDHvG5ziEHMpJ18bHlcG'"
```

**Signification** : Le Client ID `eeQIIfQYVsDYRDHvG5ziEHMpJ18bHlcG` n'est **pas reconnu** par l'API Orange.

---

## 🔍 Causes Possibles

### 1. **Client ID Incorrect ou Supprimé**
Le Client ID dans `application.properties` ne correspond pas à celui du portail Orange.

### 2. **API SMS Non Souscrite**
L'application dans le portail Orange n'a pas souscrit à l'API SMS Middle East and Africa.

### 3. **Mauvais Environnement**
Les credentials sont peut-être pour un autre pays ou environnement (sandbox vs production).

### 4. **Application Supprimée ou Désactivée**
L'application a été supprimée ou désactivée dans le portail Orange.

---

## ✅ Actions à Effectuer

### Étape 1 : Vérifier dans le Portail Orange

1. **Connectez-vous** à https://developer.orange.com/
2. **Allez dans "MyApps"** (section Applications)
3. **Vérifiez** :
   - ✅ L'application existe-t-elle ?
   - ✅ Le Client ID affiché correspond-il à `eeQIIfQYVsDYRDHvG5ziEHMpJ18bHlcG` ?
   - ✅ Le Client Secret correspond-il à `EJn9NPCK51YtFfq3AE5pKiWGdVmYdVdYLTb68cCtfaXt` ?

### Étape 2 : Vérifier la Souscription à l'API SMS

1. Dans votre application, **vérifiez les APIs souscrites**
2. **Assurez-vous** que l'API **"SMS Middle East and Africa"** ou **"SMS Africa and Middle East 2.0"** est :
   - ✅ **Souscrite** (subscribed)
   - ✅ **Active** (active)
   - ✅ **Associée au pays Mali** (CIV ou MLI selon le portail)

### Étape 3 : Vérifier le Pays/Environnement

1. **Vérifiez** que l'application est configurée pour le **Mali**
2. **Vérifiez** que vous utilisez le bon **environnement** :
   - Production : `https://api.orange.com/oauth/v3/token`
   - Sandbox : (si différent, vérifiez la documentation)

### Étape 4 : Recréer les Credentials (si nécessaire)

Si le Client ID n'existe pas ou est incorrect :

1. **Option A : Utiliser une Application Existante**
   - Trouvez une application existante dans "MyApps"
   - Copiez le **Client ID** et **Client Secret**
   - Mettez à jour `application.properties`

2. **Option B : Créer une Nouvelle Application**
   - Créez une nouvelle application dans "MyApps"
   - Souscrivez à l'API **"SMS Middle East and Africa"**
   - Sélectionnez le **pays Mali**
   - Copiez le **Client ID** et **Client Secret**
   - Mettez à jour `application.properties`

---

## 🔄 Mise à Jour de application.properties

Une fois que vous avez les **bons credentials** du portail Orange :

```properties
# Configuration Orange SMS API pour le Mali
orange.sms.enabled=true
orange.sms.base.url=https://api.orange.com/smsmessaging/v1
orange.sms.client.id=NOUVEAU_CLIENT_ID_ICI
orange.sms.client.secret=NOUVEAU_CLIENT_SECRET_ICI
orange.sms.application.id=NOUVEAU_APPLICATION_ID_ICI
orange.sms.sender.address=tel:+2230000
orange.sms.sender.name=SMS 948223
```

**⚠️ IMPORTANT** : 
- Remplacez `NOUVEAU_CLIENT_ID_ICI` par le Client ID du portail
- Remplacez `NOUVEAU_CLIENT_SECRET_ICI` par le Client Secret du portail
- Remplacez `NOUVEAU_APPLICATION_ID_ICI` par l'Application ID du portail

---

## 🧪 Test Manuel avec les Nouveaux Credentials

Une fois les credentials mis à jour, testez manuellement :

### 1. Générer le Basic Auth Header

```bash
# Windows PowerShell
$clientId = "VOTRE_CLIENT_ID"
$clientSecret = "VOTRE_CLIENT_SECRET"
$credentials = "$clientId`:$clientSecret"
$bytes = [System.Text.Encoding]::UTF8.GetBytes($credentials)
$base64 = [System.Convert]::ToBase64String($bytes)
Write-Host "Authorization: Basic $base64"
```

### 2. Tester l'Authentification

```bash
curl -X POST \
-H "Authorization: Basic {base64_credentials}" \
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

Si vous obtenez cette réponse, les credentials sont **corrects** ✅

---

## 📋 Checklist de Vérification

- [ ] Connecté au portail Orange (https://developer.orange.com/)
- [ ] Application visible dans "MyApps"
- [ ] Client ID correspond à celui dans `application.properties`
- [ ] Client Secret correspond à celui dans `application.properties`
- [ ] API "SMS Middle East and Africa" est souscrite
- [ ] Pays Mali sélectionné pour l'API
- [ ] Application est active (pas désactivée)
- [ ] Test manuel d'authentification réussi

---

## 🆘 Si le Problème Persiste

### Contactez le Support Orange

1. **Formulaire de contact** : https://developer.orange.com/apis/sms/getting-started (section "Contact us")
2. **Informations à fournir** :
   - Email du compte Orange Developer
   - Nom de l'application
   - Client ID (si disponible)
   - Message d'erreur : `"Unknown client 'eeQIIfQYVsDYRDHvG5ziEHMpJ18bHlcG'"`
   - Pays : Mali
   - API : SMS Middle East and Africa

### Vérifications Supplémentaires

1. **Vérifiez** que vous êtes connecté avec le **bon compte** Orange Developer
2. **Vérifiez** que l'application n'a pas été **supprimée** ou **désactivée**
3. **Vérifiez** que vous avez les **permissions** nécessaires sur le compte

---

## 💡 Solution Temporaire

En attendant de résoudre le problème avec Orange :

Le code SMS est **toujours généré** et **disponible dans les logs** :

```
📱 MODE FALLBACK ACTIVÉ - CODE SMS DISPONIBLE DANS LES LOGS
📞 Téléphone : +22383784097
🔑 Code SMS  : 8732
```

Vous pouvez utiliser ce code pour vous connecter pendant que vous résolvez le problème avec Orange.

---

## ✅ Résumé

**Le problème** : Le Client ID `eeQIIfQYVsDYRDHvG5ziEHMpJ18bHlcG` n'est pas reconnu par Orange.

**La solution** : 
1. Vérifiez les credentials dans le portail Orange
2. Assurez-vous que l'API SMS est souscrite
3. Mettez à jour `application.properties` avec les bons credentials
4. Testez manuellement l'authentification

**En attendant** : Utilisez le code SMS affiché dans les logs pour vous connecter.



