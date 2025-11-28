# Guide de résolution - Erreur d'authentification Orange SMS API

## ❌ Erreur identifiée
```
"error": "invalid_client",
"error_description": "Unknown client 'eeQIIfQYVsDYRDHvG5ziEHMpJ18bHlcG'"
```

## 🔍 Causes possibles

### 1. Credentials invalides ou expirés
- Le Client ID ne correspond à aucune application active sur Orange Developer
- Le Client Secret a été régénéré sans mise à jour dans `application.properties`
- L'application a été supprimée ou désactivée sur Orange Developer

### 2. Mauvaise configuration de l'application
- L'application n'est pas activée pour l'API SMS
- Restrictions géographiques (application non activée pour le Mali)
- L'environnement (sandbox vs production) ne correspond pas

### 3. Problème de format
- Le Client ID ou Secret contient des caractères invisibles (espaces, etc.)

## ✅ Solutions à essayer

### Solution 1: Vérifier les credentials sur Orange Developer

1. Connectez-vous à https://developer.orange.com/
2. Allez dans "My Apps" ou "Mes Applications"
3. Recherchez l'application avec l'ID: `iy3KWH9GiNK0evSY`
4. Vérifiez que:
   - L'application est **active**
   - L'API **SMS** est bien activée
   - Le **Client ID** correspond: `eeQIIfQYVsDYRDHvG5ziEHMpJ18bHlcG`
   - L'application est configurée pour le **Mali** (223)

### Solution 2: Régénérer les credentials

Si l'application existe mais les credentials sont corrompus:

1. Dans le portail Orange Developer, allez à votre application
2. **Régénérez le Client Secret** (⚠️ cela invalide l'ancien)
3. **Notez immédiatement** le nouveau Client ID et Secret
4. Mettez à jour `application.properties`:
   ```properties
   orange.sms.client.id=NOUVEAU_CLIENT_ID
   orange.sms.client.secret=NOUVEAU_CLIENT_SECRET
   ```
5. Régénérez aussi l'authorization header:
   ```bash
   # Dans PowerShell
   $credentials = "NOUVEAU_CLIENT_ID:NOUVEAU_CLIENT_SECRET"
   $bytes = [System.Text.Encoding]::UTF8.GetBytes($credentials)
   $encoded = [Convert]::ToBase64String($bytes)
   Write-Host "Authorization Header (Base64): $encoded"
   ```
6. Mettez à jour dans `application.properties`:
   ```properties
   orange.sms.authorization.header=NOUVEAU_HEADER_BASE64
   ```

### Solution 3: Créer une nouvelle application

Si l'application n'existe plus:

1. Créez une nouvelle application sur https://developer.orange.com/
2. Activez l'API **SMS** pour le Mali
3. Notez les credentials
4. Mettez à jour `application.properties` avec les nouveaux credentials

### Solution 4: Vérifier le format des credentials

Dans `application.properties`, vérifiez qu'il n'y a pas d'espaces ou caractères invisibles:

```properties
# ❌ INCORRECT (espaces)
orange.sms.client.id= eeQIIfQYVsDYRDHvG5ziEHMpJ18bHlcG 
orange.sms.client.secret= EJn9NPCK51YtFfq3AE5pKiWGdVmYdVdYLTb68cCtfaXt 

# ✅ CORRECT (pas d'espaces)
orange.sms.client.id=eeQIIfQYVsDYRDHvG5ziEHMpJ18bHlcG
orange.sms.client.secret=EJn9NPCK51YtFfq3AE5pKiWGdVmYdVdYLTb68cCtfaXt
```

## 🧪 Test des credentials

Utilisez ce script PowerShell pour tester l'authentification:

```powershell
# test_orange_auth.ps1
$clientId = "VOTRE_CLIENT_ID"
$clientSecret = "VOTRE_CLIENT_SECRET"

# Encoder en Base64
$credentials = "$clientId:$clientSecret"
$bytes = [System.Text.Encoding]::UTF8.GetBytes($credentials)
$base64 = [Convert]::ToBase64String($bytes)

Write-Host "Testing Orange SMS Authentication..."
Write-Host "Client ID: $clientId"
Write-Host "Authorization: Basic $base64"

# Tester l'authentification
$headers = @{
    "Authorization" = "Basic $base64"
    "Content-Type" = "application/x-www-form-urlencoded"
    "Accept" = "application/json"
}

$body = "grant_type=client_credentials"

try {
    $response = Invoke-RestMethod -Uri "https://api.orange.com/oauth/v3/token" `
        -Method POST `
        -Headers $headers `
        -Body $body `
        -ContentType "application/x-www-form-urlencoded"
    
    Write-Host "✅ SUCCESS - Authentication works!" -ForegroundColor Green
    Write-Host "Access Token: $($response.access_token.Substring(0,50))..."
    Write-Host "Expires in: $($response.expires_in) seconds"
} catch {
    Write-Host "❌ FAILED - Authentication error" -ForegroundColor Red
    Write-Host "Status Code: $($_.Exception.Response.StatusCode.value__)"
    $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
    $errorBody = $reader.ReadToEnd()
    Write-Host "Error: $errorBody"
}
```

## 📞 Contact support Orange

Si aucune solution ne fonctionne, contactez le support Orange Developer avec:

- **Client ID**: `eeQIIfQYVsDYRDHvG5ziEHMpJ18bHlcG`
- **Application ID**: `iy3KWH9GiNK0evSY`
- **Erreur**: `401 UNAUTHORIZED - Unknown client`
- **API concernée**: SMS API (Mali)

## 🔄 Mode fallback (temporaire)

En attendant la résolution, le système utilise un **mode fallback**:
- Le code SMS est généré et stocké en base de données
- Le code apparaît dans les logs du serveur
- ⚠️ **Pas de SMS envoyé réellement**

Pour désactiver l'API Orange et utiliser uniquement le mode fallback:
```properties
orange.sms.enabled=false
```
