# 🔍 Diagnostic Orange SMS API - Erreur 401 UNAUTHORIZED

## ❌ Problème identifié

L'authentification avec l'API Orange SMS échoue avec une erreur **401 UNAUTHORIZED**, ce qui signifie que les credentials sont rejetés par Orange.

## 📋 Causes possibles

1. **Client Secret incorrect ou régénéré** : Le `client_secret` dans `application.properties` ne correspond plus à celui du portail Orange
2. **Client ID incorrect** : Le `client_id` ne correspond pas à celui du portail
3. **Application ID incorrect** : L'`application_id` ne correspond pas
4. **Credentials expirés** : Les credentials ont été désactivés dans le portail Orange

## ✅ Actions à effectuer

### 1. Vérifier les credentials dans le portail Orange

1. Connectez-vous à https://developer.orange.com/
2. Allez dans votre application SMS
3. Vérifiez les valeurs suivantes :
   - **Client ID** : `eeQIIfQYVsDYRDHvG5ziEHMpJ18bHlcG`
   - **Client Secret** : (vérifiez dans le portail)
   - **Application ID** : `iy3KWH9GiNK0evSY`

### 2. Vérifier si le Client Secret a été régénéré

⚠️ **IMPORTANT** : Si vous avez régénéré le Client Secret dans le portail Orange, vous devez mettre à jour `application.properties` avec le nouveau secret.

### 3. Tester l'authentification avec cURL

Exécutez cette commande pour tester l'authentification directement :

```bash
curl -X POST "https://api.orange.com/oauth/v3/token" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -H "Authorization: Basic ZWVRSUlmUVlWc0RZUkRIdkc1emlFSE1wSjE4YkhsY0c6VGx6WDZDZ3cybmd5Nzh0VFBWcURvT2EyQXE2TUtDcnNnN0JNZ0tQdnF0dlQ=" \
  -d "grant_type=client_credentials" \
  -d "scope=SMS"
```

**Si cette commande échoue avec 401**, le problème vient des credentials eux-mêmes.

### 4. Recalculer le header Authorization

Si vous avez un nouveau Client Secret, recalculez le header Base64 :

```bash
# Sur Linux/Mac
echo -n "CLIENT_ID:CLIENT_SECRET" | base64

# Sur Windows PowerShell
$credentials = "CLIENT_ID:CLIENT_SECRET"
$bytes = [System.Text.Encoding]::UTF8.GetBytes($credentials)
[Convert]::ToBase64String($bytes)
```

### 5. Mettre à jour application.properties

Une fois que vous avez vérifié les credentials dans le portail Orange, mettez à jour `application.properties` :

```properties
orange.sms.client.id=VOTRE_CLIENT_ID
orange.sms.client.secret=VOTRE_CLIENT_SECRET
orange.sms.application.id=VOTRE_APPLICATION_ID
orange.sms.authorization.header=HEADER_BASE64_CALCULE
```

## 🔧 Solution temporaire

En attendant de résoudre le problème d'authentification, le code SMS est disponible dans les logs du serveur (mode fallback). Le code est affiché dans les logs avec le format :

```
📱 MODE FALLBACK ACTIVÉ - CODE SMS DISPONIBLE DANS LES LOGS
📞 Téléphone : +22383784097
🔑 Code SMS  : 8430
```

## 📞 Contact Orange Support

Si le problème persiste après avoir vérifié les credentials, contactez le support Orange Mali avec :
- Client ID : `eeQIIfQYVsDYRDHvG5ziEHMpJ18bHlcG`
- Application ID : `iy3KWH9GiNK0evSY`
- Erreur : 401 UNAUTHORIZED sur toutes les configurations d'authentification

## 🧪 Test avec PowerShell

Créez un fichier `test_orange_auth.ps1` :

```powershell
$clientId = "eeQIIfQYVsDYRDHvG5ziEHMpJ18bHlcG"
$clientSecret = "TlzX6Cgw2ngy78tTPVqDoOa2Aq6MKCrsg7BMgKPvqtvT"

$credentials = "$clientId`:$clientSecret"
$bytes = [System.Text.Encoding]::UTF8.GetBytes($credentials)
$encoded = [Convert]::ToBase64String($bytes)

$headers = @{
    "Content-Type" = "application/x-www-form-urlencoded"
    "Authorization" = "Basic $encoded"
}

$body = "grant_type=client_credentials&scope=SMS"

try {
    $response = Invoke-RestMethod -Uri "https://api.orange.com/oauth/v3/token" `
        -Method Post `
        -Headers $headers `
        -Body $body
    
    Write-Host "✅ SUCCÈS - Token obtenu!" -ForegroundColor Green
    Write-Host "Access Token: $($response.access_token.Substring(0, 30))..." -ForegroundColor Cyan
    Write-Host "Expires in: $($response.expires_in) seconds" -ForegroundColor Cyan
} catch {
    Write-Host "❌ ÉCHEC - Erreur 401" -ForegroundColor Red
    Write-Host "Vérifiez que le Client Secret correspond à celui du portail Orange" -ForegroundColor Yellow
}
```

Exécutez-le pour tester l'authentification.





