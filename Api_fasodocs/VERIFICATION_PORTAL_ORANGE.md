# 🔍 Guide de Vérification - Portail Orange Developer

## 📋 Informations de votre Application

D'après votre configuration :

- **Client ID**: `eeQIIfQYVsDYRDHvG5ziEHMpJ18bHlcG`
- **Client Secret**: `MKAh6Y2TWs3kBdeUlVtVfmnAzckniO2GvJwzgwYSMdt1`
- **Application ID**: `iy3KWH9GiNK0evSY`
- **Sender Address**: `tel:+22383784097`

---

## ✅ Étapes de Vérification dans le Portail Orange

### 1. Connectez-vous au Portail Orange Developer

URL : **https://developer.orange.com/**

### 2. Vérifiez que votre Application est ACTIVE

1. Allez dans **"My Apps"** ou **"Mes Applications"**
2. Recherchez votre application (probablement liée au Client ID ci-dessus)
3. **Vérifiez que l'application est dans l'état "Active"** ou "Activated"
   - Si elle est "Pending" ou "Inactive", il faut l'activer
   - Si elle est "Rejected", contactez le support Orange

### 3. Vérifiez que l'API SMS est ACTIVÉE pour votre Application

1. Ouvrez les détails de votre application
2. Allez dans la section **"APIs"** ou **"Services"**
3. **Vérifiez que "SMS API" est activée** pour :
   - ✅ Le pays **Mali** (223)
   - ✅ L'environnement de production (pas seulement sandbox)

### 4. Vérifiez que le Client Secret est CORRECT

1. Dans les détails de l'application, allez dans **"Credentials"** ou **"Identifiants"**
2. **Vérifiez que le Client Secret affiché correspond** à celui dans votre `application.properties`
3. ⚠️ **ATTENTION** : Si vous avez régénéré le Client Secret dans le portail, l'ancien devient invalide immédiatement

### 5. Vérifiez que vous avez un BUNDLE SMS avec CRÉDITS

1. Allez dans **"My Bundles"** ou **"Mes Bundles"**
2. Vérifiez que vous avez un bundle SMS actif pour le Mali
3. **Vérifiez que le bundle a des crédits disponibles** (balance > 0)
4. Vérifiez que le bundle n'est pas expiré

### 6. Vérifiez le PAYS de Configuration

1. Dans les paramètres de l'application, vérifiez que **Mali (223)** est bien configuré
2. Vérifiez que l'API SMS est autorisée pour ce pays spécifiquement

---

## 🔍 Codes d'Erreur Orange à Interpréter

Une fois que vous aurez relancé le backend avec la nouvelle version utilisant HttpClient, vous devriez voir dans les logs un message d'erreur Orange avec un **code**. Voici leur signification :

### Code 61 : Invalid Credentials
- Les credentials (Client ID / Client Secret) sont incorrects
- **Solution** : Vérifiez dans le portail que les credentials correspondent

### Code 42 : Expired Credentials
- Les credentials ont expiré
- **Solution** : Régénérez le Client Secret dans le portail

### Code 62 : Application Not Found
- Le Client ID n'existe pas ou n'est pas associé à votre compte
- **Solution** : Vérifiez que vous êtes connecté au bon compte Orange

### Code 63 : Application Not Authorized
- L'application existe mais n'est pas autorisée à utiliser l'API SMS
- **Solution** : Activez l'API SMS pour votre application dans le portail

### Code 64 : Application Not Activated
- L'application n'est pas activée
- **Solution** : Activez l'application dans le portail Orange

### Code 65 : SMS API Not Enabled for Country
- L'API SMS n'est pas activée pour le Mali
- **Solution** : Activez l'API SMS pour le Mali dans les paramètres de l'application

---

## 📝 Actions à Faire MAINTENANT

### 1. Relancer le Backend avec la Nouvelle Version

La nouvelle version utilise HttpClient et devrait maintenant afficher le message d'erreur exact d'Orange dans les logs.

### 2. Tester l'Envoi SMS

Faites une requête pour déclencher l'authentification.

### 3. Vérifier les Logs

Cherchez dans les logs cette section :

```
📄 MESSAGE D'ERREUR ORANGE (401 UNAUTHORIZED)
═══════════════════════════════════════════════════════════
{
  "code": XX,
  "message": "...",
  "description": "..."
}
═══════════════════════════════════════════════════════════
📋 DÉTAILS DE L'ERREUR (JSON parsé):
   Code: XX
   Message: ...
   Description: ...
```

### 4. Interpréter le Code d'Erreur

Utilisez la section "Codes d'Erreur Orange à Interpréter" ci-dessus pour comprendre ce que signifie le code.

### 5. Corriger le Problème

Selon le code d'erreur :
- **Code 61 ou 62** → Vérifiez/corrigez les credentials dans le portail
- **Code 63 ou 64** → Activez l'application et l'API SMS
- **Code 65** → Activez l'API SMS pour le Mali
- **Code 42** → Régénérez le Client Secret

---

## 🆘 Si vous ne voyez toujours pas le message d'erreur

Utilisez le script PowerShell de test direct :

```powershell
.\test-orange-credentials.ps1
```

Ce script contourne complètement Spring Boot et appelle directement l'API Orange, vous donnant le message d'erreur exact.

---

## 📞 Contact Support Orange

Si après toutes ces vérifications le problème persiste, contactez le support Orange Developer avec :

- Client ID: `eeQIIfQYVsDYRDHvG5ziEHMpJ18bHlcG`
- Application ID: `iy3KWH9GiNK0evSY`
- Code d'erreur (si visible dans les logs)
- Message d'erreur complet

---

## ✅ Checklist Rapide

- [ ] Application est "Active" dans le portail
- [ ] API SMS est activée pour l'application
- [ ] API SMS est activée pour le Mali (pays 223)
- [ ] Client Secret dans le portail = Client Secret dans application.properties
- [ ] Bundle SMS actif avec crédits disponibles
- [ ] Backend relancé avec la nouvelle version (HttpClient)
- [ ] Logs vérifiés pour le message d'erreur Orange

