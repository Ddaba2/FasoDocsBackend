# 🔍 Diagnostic Erreur 401 Orange SMS - Analyse des Logs

## 📊 Analyse des logs fournis

### **Problème principal : Erreur 401 UNAUTHORIZED**

```
❌ ERREUR 401 - Credentials Orange invalides ou expirés
Status: 401 UNAUTHORIZED
Response body (String): [vide ou null]
Response body (Bytes length): 0
```

**Mais Content-Length indique 98 bytes** → Le body existe mais n'est pas lisible à cause du problème de streaming.

---

## 🔍 Problèmes identifiés

### **1. Erreur 401 sur OAuth v3/token** ⚠️ **CRITIQUE**

**Tentatives :**
- ✅ `https://api.orange.com/oauth/v3/token` avec scope=SMS → **401 UNAUTHORIZED**
- ✅ `https://api.orange.com/oauth/v3/token` sans scope → **401 UNAUTHORIZED**

**Causes possibles :**
1. ❌ **Client ID invalide** : `eeQIIfQYVsDYRDHvG5ziEHMpJ18bHlcG`
2. ❌ **Client Secret invalide ou régénéré** : `MKAh6Y2TWs3kBdeUlVtVfmnAzckniO2GvJwzgwYSMdt1`
3. ❌ **Credentials expirés** dans le portail Orange
4. ❌ **Application non activée** pour le SMS au Mali

---

### **2. Erreur 404 sur les autres URLs** ✅ **NORMAL**

**Tentatives :**
- ❌ `https://api.orange.com/oauth/v1/token` → **404 NOT_FOUND** (n'existe plus)
- ❌ `https://api.orange.com/oauth/token` → **404 NOT_FOUND** (n'existe plus)

**Conclusion :** Seule l'URL `v3/token` est valide, ce qui est correct selon la documentation Orange.

---

### **3. Problème technique : Body d'erreur non lisible** ⚠️

```
❌ Erreur lors de la capture du body (IOException): 
cannot retry due to server authentication, in streaming mode
⚠️ Body non lisible mais Content-Length indique 98 bytes
```

**Cause :** Le body d'erreur existe (98 bytes) mais n'est pas lisible à cause du mode streaming de Java HTTP.

**Impact :** On ne peut pas voir le message d'erreur détaillé d'Orange pour comprendre pourquoi les credentials sont rejetés.

---

## 🔧 Solutions

### **Solution 1 : Vérifier les credentials dans le portail Orange** ⭐ **PRIORITAIRE**

1. **Connectez-vous au portail Orange Developer :**
   - URL : https://developer.orange.com/
   - Identifiez-vous avec votre compte

2. **Vérifiez votre application :**
   - Allez dans **"My Apps"**
   - Trouvez votre application : `iy3KWH9GiNK0evSY`
   - Vérifiez que l'API **SMS Middle East and Africa** est bien activée

3. **Vérifiez les credentials :**
   - **Client ID** : `eeQIIfQYVsDYRDHvG5ziEHMpJ18bHlcG`
   - **Client Secret** : Vérifiez s'il a été régénéré
   - ⚠️ **Si le Client Secret a été régénéré**, vous devez mettre à jour `application.properties`

4. **Vérifiez le statut de l'application :**
   - L'application doit être **ACTIVE**
   - Le contrat SMS doit être **valide** et non expiré
   - Vous devez avoir un **bundle SMS acheté** avec un solde positif

---

### **Solution 2 : Tester les credentials directement** 🧪

Créez un script de test pour vérifier les credentials :

**Test avec curl :**

```bash
# Encoder les credentials en Base64
# Format: client_id:client_secret
echo -n "eeQIIfQYVsDYRDHvG5ziEHMpJ18bHlcG:MKAh6Y2TWs3kBdeUlVtVfmnAzckniO2GvJwzgwYSMdt1" | base64

# Tester l'authentification
curl -X POST https://api.orange.com/oauth/v3/token \
  -H "Authorization: Basic ZWVRSUlmUVlWc0RZUkRIdkc1emlFSE1wSjE4YkhsY0c6TUtBaDZZMlRXczNrQmRlVWxWdFZmbW5BemNrbmlPMkd2Snd6Z3dZU01kdDE=" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "grant_type=client_credentials" \
  -v
```

**Si ça fonctionne :** Vous devriez recevoir un `access_token`

**Si ça échoue :** Vous verrez le message d'erreur détaillé d'Orange

---

### **Solution 3 : Améliorer la capture du body d'erreur** 🔧

Le problème de streaming empêche de voir le message d'erreur d'Orange. Je vais améliorer le code pour mieux capturer le body.

---

### **Solution 4 : Vérifier le bundle SMS** 💰

1. **Connectez-vous au portail Orange :**
   - https://developer.orange.com/

2. **Vérifiez votre solde SMS :**
   - Allez dans **"My Apps"** → Votre application
   - Vérifiez le **solde SMS disponible**
   - Vérifiez la **date d'expiration** du bundle

3. **Si le bundle est expiré ou le solde est à 0 :**
   - Achetez un nouveau bundle
   - Attendez la confirmation

---

## 📋 Checklist de diagnostic

### **Étape 1 : Vérifier les credentials**

- [ ] Client ID correct dans le portail Orange
- [ ] Client Secret à jour (non régénéré)
- [ ] Credentials copiés correctement dans `application.properties`

### **Étape 2 : Vérifier l'application**

- [ ] Application active dans le portail Orange
- [ ] API SMS Middle East and Africa activée
- [ ] Application ID correct : `iy3KWH9GiNK0evSY`

### **Étape 3 : Vérifier le bundle SMS**

- [ ] Bundle SMS acheté
- [ ] Solde SMS > 0
- [ ] Date d'expiration du bundle non dépassée

### **Étape 4 : Tester avec curl**

- [ ] Test d'authentification avec curl réussi
- [ ] Access token reçu
- [ ] Message d'erreur clair si échec

---

## 🧪 Test direct des credentials

### **Test 1 : Authentification OAuth**

```bash
# Windows PowerShell
$clientId = "eeQIIfQYVsDYRDHvG5ziEHMpJ18bHlcG"
$clientSecret = "MKAh6Y2TWs3kBdeUlVtVfmnAzckniO2GvJwzgwYSMdt1"
$credentials = "$clientId`:$clientSecret"
$encoded = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($credentials))

Invoke-RestMethod -Uri "https://api.orange.com/oauth/v3/token" `
  -Method Post `
  -Headers @{
    "Authorization" = "Basic $encoded"
    "Content-Type" = "application/x-www-form-urlencoded"
  } `
  -Body "grant_type=client_credentials"
```

### **Test 2 : Vérifier le solde SMS**

Si l'authentification fonctionne, testez le solde :

```bash
# Après avoir obtenu l'access_token
$token = "VOTRE_ACCESS_TOKEN"

Invoke-RestMethod -Uri "https://api.orange.com/sms/admin/v1/contracts" `
  -Method Get `
  -Headers @{
    "Authorization" = "Bearer $token"
  }
```

---

## 🔍 Messages d'erreur Orange possibles

Si vous arrivez à lire le body d'erreur, voici les messages possibles :

| Code | Message | Solution |
|------|---------|----------|
| 42 | Expired credentials | Credentials expirés, régénérez dans le portail |
| 60 | Resource not found | URL incorrecte (déjà géré dans le code) |
| 61 | Invalid credentials | Client ID ou Secret incorrect |
| 62 | Application not found | Application ID incorrect |
| 63 | Application not authorized | Application non autorisée pour SMS |

---

## ✅ Actions immédiates recommandées

### **1. Vérifier dans le portail Orange (5 minutes)**

1. Connectez-vous : https://developer.orange.com/
2. Allez dans **"My Apps"**
3. Vérifiez :
   - ✅ Application active
   - ✅ API SMS activée
   - ✅ Client ID et Secret à jour
   - ✅ Bundle SMS avec solde > 0

### **2. Tester avec curl (2 minutes)**

Testez directement les credentials pour voir le message d'erreur exact.

### **3. Mettre à jour les credentials si nécessaire**

Si le Client Secret a été régénéré, mettez à jour `application.properties`.

---

## 🎯 Prochaines étapes

Une fois que vous avez :
1. ✅ Vérifié les credentials dans le portail
2. ✅ Testé avec curl
3. ✅ Vérifié le solde SMS

**Si les credentials sont valides mais ça ne fonctionne toujours pas :**

Contactez le support Orange Mali avec :
- Client ID : `eeQIIfQYVsDYRDHvG5ziEHMpJ18bHlcG`
- Application ID : `iy3KWH9GiNK0evSY`
- Erreur : 401 UNAUTHORIZED sur `https://api.orange.com/oauth/v3/token`
- Date du test : 2025-11-21

---

## 📞 Support Orange

**Portail :** https://developer.orange.com/  
**Documentation :** https://developer.orange.com/apis/sms/getting-started  
**Contact :** Via le formulaire dans le portail Orange Developer

---

**Note importante :** La correction du format de l'URL (senderAddress sans +) que nous avons faite est correcte, mais elle ne peut pas être testée tant que l'authentification ne fonctionne pas. Une fois l'authentification résolue, vous pourrez tester l'envoi SMS et vérifier que l'URL générée est conforme.

