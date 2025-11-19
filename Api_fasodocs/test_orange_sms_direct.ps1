# Script de Test Direct Orange SMS - Vérification des Credentials
# Usage: .\test_orange_sms_direct.ps1

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "🧪 Test Direct Orange SMS - Credentials" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Configuration depuis application.properties
$clientId = "eeQIIfQYVsDYRDHvG5ziEHMpJ18bHlcG"
$clientSecret = "5LywHmVzKBh2xiUWsqY17wiLfjqcPluDMrAojfcRFhEX"
$applicationId = "iy3KWH9GiNK0evSY"
$senderAddress = "tel:+22383784097"
$testPhone = "+22383784097"  # Votre numéro de test

# Encoder les credentials
$credentials = "$clientId`:$clientSecret"
$bytes = [System.Text.Encoding]::UTF8.GetBytes($credentials)
$encodedCredentials = [Convert]::ToBase64String($bytes)
$authHeader = "Basic $encodedCredentials"

Write-Host "1️⃣  Configuration" -ForegroundColor Green
Write-Host "   Client ID: $clientId" -ForegroundColor Gray
Write-Host "   Application ID: $applicationId" -ForegroundColor Gray
Write-Host "   Sender: $senderAddress" -ForegroundColor Gray
Write-Host "   Encoded Auth: $encodedCredentials" -ForegroundColor Gray
Write-Host ""

# Test 1: Authentification v3 avec scope
Write-Host "2️⃣  Test Authentification - v3/token avec scope=SMS" -ForegroundColor Green
$authUrl1 = "https://api.orange.com/oauth/v3/token"
$body1 = "grant_type=client_credentials&scope=SMS"

try {
    $response1 = Invoke-RestMethod -Uri $authUrl1 -Method Post `
        -Headers @{
            "Content-Type" = "application/x-www-form-urlencoded"
            "Authorization" = $authHeader
        } `
        -Body $body1 `
        -ErrorAction Stop
    
    Write-Host "   ✅ SUCCÈS - Token obtenu!" -ForegroundColor Green
    Write-Host "   Access Token: $($response1.access_token.Substring(0, 30))..." -ForegroundColor Cyan
    Write-Host "   Expires in: $($response1.expires_in) seconds" -ForegroundColor Cyan
    $accessToken = $response1.access_token
    $test1Success = $true
} catch {
    Write-Host "   ❌ ÉCHEC - Erreur 401" -ForegroundColor Red
    Write-Host "   Status: $($_.Exception.Response.StatusCode.value__)" -ForegroundColor Red
    if ($_.ErrorDetails) {
        Write-Host "   Body: $($_.ErrorDetails.Message)" -ForegroundColor Yellow
    }
    $test1Success = $false
    $accessToken = $null
}
Write-Host ""

# Test 2: Authentification v3 sans scope
if (-not $test1Success) {
    Write-Host "3️⃣  Test Authentification - v3/token SANS scope" -ForegroundColor Green
    $body2 = "grant_type=client_credentials"
    
    try {
        $response2 = Invoke-RestMethod -Uri $authUrl1 -Method Post `
            -Headers @{
                "Content-Type" = "application/x-www-form-urlencoded"
                "Authorization" = $authHeader
            } `
            -Body $body2 `
            -ErrorAction Stop
        
        Write-Host "   ✅ SUCCÈS - Token obtenu!" -ForegroundColor Green
        Write-Host "   Access Token: $($response2.access_token.Substring(0, 30))..." -ForegroundColor Cyan
        $accessToken = $response2.access_token
        $test2Success = $true
    } catch {
        Write-Host "   ❌ ÉCHEC - Erreur 401" -ForegroundColor Red
        if ($_.ErrorDetails) {
            Write-Host "   Body: $($_.ErrorDetails.Message)" -ForegroundColor Yellow
        }
        $test2Success = $false
    }
    Write-Host ""
}

# Test 3: Authentification v2 avec scope
if (-not $test1Success -and -not $test2Success) {
    Write-Host "4️⃣  Test Authentification - v2/token avec scope=SMS" -ForegroundColor Green
    $authUrl2 = "https://api.orange.com/oauth/v2/token"
    $body3 = "grant_type=client_credentials&scope=SMS"
    
    try {
        $response3 = Invoke-RestMethod -Uri $authUrl2 -Method Post `
            -Headers @{
                "Content-Type" = "application/x-www-form-urlencoded"
                "Authorization" = $authHeader
            } `
            -Body $body3 `
            -ErrorAction Stop
        
        Write-Host "   ✅ SUCCÈS - Token obtenu!" -ForegroundColor Green
        $accessToken = $response3.access_token
        $test3Success = $true
    } catch {
        Write-Host "   ❌ ÉCHEC - Erreur 401" -ForegroundColor Red
        $test3Success = $false
    }
    Write-Host ""
}

# Test 4: Authentification v2 sans scope
if (-not $test1Success -and -not $test2Success -and -not $test3Success) {
    Write-Host "5️⃣  Test Authentification - v2/token SANS scope" -ForegroundColor Green
    $authUrl2 = "https://api.orange.com/oauth/v2/token"
    $body4 = "grant_type=client_credentials"
    
    try {
        $response4 = Invoke-RestMethod -Uri $authUrl2 -Method Post `
            -Headers @{
                "Content-Type" = "application/x-www-form-urlencoded"
                "Authorization" = $authHeader
            } `
            -Body $body4 `
            -ErrorAction Stop
        
        Write-Host "   ✅ SUCCÈS - Token obtenu!" -ForegroundColor Green
        $accessToken = $response4.access_token
        $test4Success = $true
    } catch {
        Write-Host "   ❌ ÉCHEC - Erreur 401" -ForegroundColor Red
        $test4Success = $false
    }
    Write-Host ""
}

# Si authentification réussie, tester l'envoi SMS
if ($accessToken) {
    Write-Host "6️⃣  Test Envoi SMS" -ForegroundColor Green
    
    # Encoder le senderAddress pour l'URL
    $senderEncoded = [System.Web.HttpUtility]::UrlEncode($senderAddress)
    $smsUrl = "https://api.orange.com/smsmessaging/v1/outbound/$senderEncoded/requests"
    
    Write-Host "   URL: $smsUrl" -ForegroundColor Gray
    Write-Host "   Destinataire: $testPhone" -ForegroundColor Gray
    
    $smsBody = @{
        outboundSMSMessageRequest = @{
            address = "tel:$testPhone"
            outboundSMSTextMessage = @{
                message = "Test FasoDocs - Code: 1234"
            }
            senderAddress = $senderAddress
        }
    } | ConvertTo-Json -Depth 10
    
    try {
        $smsResponse = Invoke-RestMethod -Uri $smsUrl -Method Post `
            -Headers @{
                "Content-Type" = "application/json"
                "Authorization" = "Bearer $accessToken"
                "Accept" = "application/json"
            } `
            -Body $smsBody `
            -ErrorAction Stop
        
        Write-Host "   ✅ SUCCÈS - SMS envoyé!" -ForegroundColor Green
        Write-Host "   Response: $($smsResponse | ConvertTo-Json)" -ForegroundColor Cyan
    } catch {
        Write-Host "   ❌ ÉCHEC - Erreur lors de l'envoi" -ForegroundColor Red
        Write-Host "   Status: $($_.Exception.Response.StatusCode.value__)" -ForegroundColor Red
        if ($_.ErrorDetails) {
            Write-Host "   Body: $($_.ErrorDetails.Message)" -ForegroundColor Yellow
        }
    }
    Write-Host ""
}

# Résumé
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "📋 Résumé" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

if ($accessToken) {
    Write-Host "✅ AUTHENTIFICATION: RÉUSSIE" -ForegroundColor Green
    Write-Host ""
    Write-Host "📝 Configuration qui fonctionne:" -ForegroundColor Yellow
    if ($test1Success) {
        Write-Host "   → URL: https://api.orange.com/oauth/v3/token" -ForegroundColor White
        Write-Host "   → Scope: SMS (requis)" -ForegroundColor White
    } elseif ($test2Success) {
        Write-Host "   → URL: https://api.orange.com/oauth/v3/token" -ForegroundColor White
        Write-Host "   → Scope: NON requis" -ForegroundColor White
    } elseif ($test3Success) {
        Write-Host "   → URL: https://api.orange.com/oauth/v2/token" -ForegroundColor White
        Write-Host "   → Scope: SMS (requis)" -ForegroundColor White
    } elseif ($test4Success) {
        Write-Host "   → URL: https://api.orange.com/oauth/v2/token" -ForegroundColor White
        Write-Host "   → Scope: NON requis" -ForegroundColor White
    }
} else {
    Write-Host "❌ AUTHENTIFICATION: ÉCHOUÉE" -ForegroundColor Red
    Write-Host ""
    Write-Host "📋 Toutes les configurations ont échoué avec erreur 401" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "🔍 CAUSES POSSIBLES:" -ForegroundColor Yellow
    Write-Host "   1. Les credentials sont invalides ou expirés" -ForegroundColor White
    Write-Host "   2. Le Client Secret a été régénéré dans le portail Orange" -ForegroundColor White
    Write-Host "   3. Les credentials sont pour un environnement sandbox (pas production)" -ForegroundColor White
    Write-Host "   4. L'application SMS n'est pas activée dans le portail Orange" -ForegroundColor White
    Write-Host ""
    Write-Host "✅ ACTIONS REQUISES:" -ForegroundColor Yellow
    Write-Host "   1. Connectez-vous à https://developer.orange.com/" -ForegroundColor White
    Write-Host "   2. Vérifiez vos credentials dans 'My Apps'" -ForegroundColor White
    Write-Host "   3. Vérifiez que l'application SMS est activée" -ForegroundColor White
    Write-Host "   4. Si le Client Secret a été régénéré, mettez à jour application.properties" -ForegroundColor White
    Write-Host "   5. Contactez le support Orange Mali si le problème persiste" -ForegroundColor White
}

Write-Host ""

