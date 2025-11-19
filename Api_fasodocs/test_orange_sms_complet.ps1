# Script de Test Complet - Orange SMS API
# Usage: .\test_orange_sms_complet.ps1

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "🧪 Test Complet Orange SMS API" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Configuration
$clientId = "eeQIIfQYVsDYRDHvG5ziEHMpJ18bHlcG"
$clientSecret = "5LywHmVzKBh2xiUWsqY17wiLfjqcPluDMrAojfcRFhEX"
$applicationId = "iy3KWH9GiNK0evSY"
$senderAddress = "tel:+22383784097"
$testPhone = "+22312345678"  # Remplacez par un numéro de test valide

# Encoder les credentials en Base64
$credentials = "$clientId`:$clientSecret"
$bytes = [System.Text.Encoding]::UTF8.GetBytes($credentials)
$encodedCredentials = [Convert]::ToBase64String($bytes)
$authHeader = "Basic $encodedCredentials"

Write-Host "1️⃣  Vérification de l'encodage Base64" -ForegroundColor Green
Write-Host "   Client ID: $clientId" -ForegroundColor Gray
Write-Host "   Client Secret: $clientSecret" -ForegroundColor Gray
Write-Host "   Encoded: $encodedCredentials" -ForegroundColor Cyan
Write-Host ""

# Test 1: Authentification avec URL v3 (standard)
Write-Host "2️⃣  Test Authentification - URL v3 (standard)" -ForegroundColor Green
$authUrl1 = "https://api.orange.com/oauth/v3/token"
Write-Host "   URL: $authUrl1" -ForegroundColor Gray

try {
    $response1 = Invoke-RestMethod -Uri $authUrl1 -Method Post `
        -Headers @{
            "Content-Type" = "application/x-www-form-urlencoded"
            "Authorization" = $authHeader
        } `
        -Body "grant_type=client_credentials" `
        -ErrorAction Stop
    
    Write-Host "   ✅ SUCCÈS - Token obtenu" -ForegroundColor Green
    Write-Host "   Access Token: $($response1.access_token.Substring(0, 20))..." -ForegroundColor Cyan
    Write-Host "   Expires in: $($response1.expires_in) seconds" -ForegroundColor Cyan
    $accessToken = $response1.access_token
    $test1Success = $true
} catch {
    Write-Host "   ❌ ÉCHEC - Erreur 401" -ForegroundColor Red
    Write-Host "   Status: $($_.Exception.Response.StatusCode.value__)" -ForegroundColor Red
    Write-Host "   Message: $($_.Exception.Message)" -ForegroundColor Red
    if ($_.ErrorDetails) {
        Write-Host "   Body: $($_.ErrorDetails.Message)" -ForegroundColor Yellow
    }
    $test1Success = $false
}
Write-Host ""

# Test 2: Authentification avec URL v3 + scope
if (-not $test1Success) {
    Write-Host "3️⃣  Test Authentification - URL v3 + scope=SMS" -ForegroundColor Green
    Write-Host "   URL: $authUrl1" -ForegroundColor Gray
    Write-Host "   Body: grant_type=client_credentials&scope=SMS" -ForegroundColor Gray
    
    try {
        $response2 = Invoke-RestMethod -Uri $authUrl1 -Method Post `
            -Headers @{
                "Content-Type" = "application/x-www-form-urlencoded"
                "Authorization" = $authHeader
            } `
            -Body "grant_type=client_credentials&scope=SMS" `
            -ErrorAction Stop
        
        Write-Host "   ✅ SUCCÈS - Token obtenu avec scope" -ForegroundColor Green
        Write-Host "   Access Token: $($response2.access_token.Substring(0, 20))..." -ForegroundColor Cyan
        $accessToken = $response2.access_token
        $test2Success = $true
    } catch {
        Write-Host "   ❌ ÉCHEC - Erreur 401" -ForegroundColor Red
        Write-Host "   Status: $($_.Exception.Response.StatusCode.value__)" -ForegroundColor Red
        Write-Host "   Message: $($_.Exception.Message)" -ForegroundColor Red
        if ($_.ErrorDetails) {
            Write-Host "   Body: $($_.ErrorDetails.Message)" -ForegroundColor Yellow
        }
        $test2Success = $false
    }
    Write-Host ""
}

# Test 3: Authentification avec URL v2
if (-not $test1Success -and -not $test2Success) {
    Write-Host "4️⃣  Test Authentification - URL v2 (alternative)" -ForegroundColor Green
    $authUrl2 = "https://api.orange.com/oauth/v2/token"
    Write-Host "   URL: $authUrl2" -ForegroundColor Gray
    
    try {
        $response3 = Invoke-RestMethod -Uri $authUrl2 -Method Post `
            -Headers @{
                "Content-Type" = "application/x-www-form-urlencoded"
                "Authorization" = $authHeader
            } `
            -Body "grant_type=client_credentials" `
            -ErrorAction Stop
        
        Write-Host "   ✅ SUCCÈS - Token obtenu avec v2" -ForegroundColor Green
        Write-Host "   Access Token: $($response3.access_token.Substring(0, 20))..." -ForegroundColor Cyan
        $accessToken = $response3.access_token
        $test3Success = $true
    } catch {
        Write-Host "   ❌ ÉCHEC - Erreur 401" -ForegroundColor Red
        Write-Host "   Status: $($_.Exception.Response.StatusCode.value__)" -ForegroundColor Red
        Write-Host "   Message: $($_.Exception.Message)" -ForegroundColor Red
        if ($_.ErrorDetails) {
            Write-Host "   Body: $($_.ErrorDetails.Message)" -ForegroundColor Yellow
        }
        $test3Success = $false
    }
    Write-Host ""
}

# Si authentification réussie, tester l'envoi SMS
if ($accessToken) {
    Write-Host "5️⃣  Test Envoi SMS" -ForegroundColor Green
    
    # Construire l'URL SMS
    $senderAddressEncoded = [System.Web.HttpUtility]::UrlEncode($senderAddress)
    $smsUrl = "https://api.orange.com/smsmessaging/v1/outbound/$senderAddressEncoded/requests"
    Write-Host "   URL: $smsUrl" -ForegroundColor Gray
    
    # Construire le body
    $smsBody = @{
        outboundSMSMessageRequest = @{
            address = "tel:$testPhone"
            outboundSMSTextMessage = @{
                message = "Test FasoDocs - Code: 1234"
            }
            senderAddress = $senderAddress
        }
    } | ConvertTo-Json -Depth 10
    
    Write-Host "   Body: $smsBody" -ForegroundColor Gray
    Write-Host "   Destinataire: $testPhone" -ForegroundColor Gray
    
    try {
        $smsResponse = Invoke-RestMethod -Uri $smsUrl -Method Post `
            -Headers @{
                "Content-Type" = "application/json"
                "Authorization" = "Bearer $accessToken"
                "Accept" = "application/json"
            } `
            -Body $smsBody `
            -ErrorAction Stop
        
        Write-Host "   ✅ SUCCÈS - SMS envoyé" -ForegroundColor Green
        Write-Host "   Response: $($smsResponse | ConvertTo-Json)" -ForegroundColor Cyan
    } catch {
        Write-Host "   ❌ ÉCHEC - Erreur lors de l'envoi" -ForegroundColor Red
        Write-Host "   Status: $($_.Exception.Response.StatusCode.value__)" -ForegroundColor Red
        Write-Host "   Message: $($_.Exception.Message)" -ForegroundColor Red
        if ($_.ErrorDetails) {
            Write-Host "   Body: $($_.ErrorDetails.Message)" -ForegroundColor Yellow
        }
        
        # Analyser l'erreur
        $statusCode = $_.Exception.Response.StatusCode.value__
        if ($statusCode -eq 400) {
            Write-Host "   💡 Erreur 400 - Vérifier:" -ForegroundColor Yellow
            Write-Host "      - Format du senderAddress dans l'URL" -ForegroundColor Yellow
            Write-Host "      - Format du body de la requête" -ForegroundColor Yellow
            Write-Host "      - Format du numéro de téléphone" -ForegroundColor Yellow
        } elseif ($statusCode -eq 401) {
            Write-Host "   💡 Erreur 401 - Token invalide ou expiré" -ForegroundColor Yellow
        }
    }
    Write-Host ""
}

# Résumé
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "📋 Résumé des Tests" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

if ($accessToken) {
    Write-Host "✅ Authentification: RÉUSSIE" -ForegroundColor Green
    Write-Host "   Token obtenu avec succès" -ForegroundColor Gray
    Write-Host ""
    Write-Host "📝 Actions Recommandées:" -ForegroundColor Yellow
    Write-Host "   1. Vérifier que l'URL d'authentification fonctionne" -ForegroundColor White
    Write-Host "   2. Si scope=SMS était nécessaire, l'ajouter dans le code" -ForegroundColor White
    Write-Host "   3. Vérifier les logs du serveur pour les détails" -ForegroundColor White
} else {
    Write-Host "❌ Authentification: ÉCHOUÉE" -ForegroundColor Red
    Write-Host ""
    Write-Host "📝 Actions Recommandées:" -ForegroundColor Yellow
    Write-Host "   1. Vérifier les credentials dans le portail Orange" -ForegroundColor White
    Write-Host "   2. Vérifier que le Client Secret n'a pas été régénéré" -ForegroundColor White
    Write-Host "   3. Contacter le support Orange avec:" -ForegroundColor White
    Write-Host "      - Client ID: $clientId" -ForegroundColor Gray
    Write-Host "      - Erreur: 401 UNAUTHORIZED" -ForegroundColor Gray
    Write-Host "      - URL testée: $authUrl1" -ForegroundColor Gray
}

Write-Host ""
Write-Host "📚 Pour plus d'informations:" -ForegroundColor Cyan
Write-Host "   ANALYSE_PROFONDE_ORANGE_SMS_400_401.md" -ForegroundColor Yellow
Write-Host ""

