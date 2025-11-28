# Script de test des credentials Orange SMS
# Ce script teste directement l'authentification avec l'API Orange
# pour voir le message d'erreur exact si les credentials sont invalides

Write-Host ""
Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "   🧪 TEST DES CREDENTIALS ORANGE SMS 🧪" -ForegroundColor Yellow
Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

# Credentials depuis application.properties
$clientId = "eeQIIfQYVsDYRDHvG5ziEHMpJ18bHlcG"
$clientSecret = "MKAh6Y2TWs3kBdeUlVtVfmnAzckniO2GvJwzgwYSMdt1"
$applicationId = "iy3KWH9GiNK0evSY"

Write-Host "📋 Informations de test:" -ForegroundColor Green
Write-Host "   Client ID: $clientId"
Write-Host "   Application ID: $applicationId"
Write-Host ""

# Encoder les credentials en Base64
$credentials = "$clientId`:$clientSecret"
$bytes = [System.Text.Encoding]::UTF8.GetBytes($credentials)
$encoded = [Convert]::ToBase64String($bytes)

Write-Host "🔐 Test d'authentification OAuth v3..." -ForegroundColor Yellow
Write-Host ""

# Test 1 : Avec scope SMS
Write-Host "Test 1: OAuth v3/token avec scope=SMS" -ForegroundColor Cyan
try {
    $body = @{
        grant_type = "client_credentials"
        scope = "SMS"
    } | ConvertTo-Json
    
    $headers = @{
        "Authorization" = "Basic $encoded"
        "Content-Type" = "application/x-www-form-urlencoded"
        "Accept" = "application/json"
    }
    
    # Convertir le body en format form-urlencoded
    $formBody = "grant_type=client_credentials&scope=SMS"
    
    $response = Invoke-WebRequest -Uri "https://api.orange.com/oauth/v3/token" `
        -Method Post `
        -Headers @{
            "Authorization" = "Basic $encoded"
            "Content-Type" = "application/x-www-form-urlencoded"
        } `
        -Body $formBody `
        -ErrorAction Stop
    
    Write-Host "✅ SUCCÈS !" -ForegroundColor Green
    Write-Host "Status: $($response.StatusCode)"
    $json = $response.Content | ConvertFrom-Json
    Write-Host "Access Token: $($json.access_token.Substring(0, 20))..." -ForegroundColor Green
    Write-Host "Expires in: $($json.expires_in) secondes"
    Write-Host ""
    Write-Host "✅ Les credentials sont VALIDES !" -ForegroundColor Green
    
} catch {
    Write-Host "❌ ÉCHEC" -ForegroundColor Red
    Write-Host "Status: $($_.Exception.Response.StatusCode.value__)"
    Write-Host ""
    
    # Essayer de lire le body d'erreur
    try {
        $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
        $responseBody = $reader.ReadToEnd()
        $reader.Close()
        
        Write-Host "📄 Message d'erreur Orange:" -ForegroundColor Yellow
        Write-Host $responseBody
        Write-Host ""
        
        # Parser le JSON si possible
        try {
            $errorJson = $responseBody | ConvertFrom-Json
            Write-Host "Code erreur: $($errorJson.code)" -ForegroundColor Red
            Write-Host "Message: $($errorJson.message)" -ForegroundColor Red
            if ($errorJson.description) {
                Write-Host "Description: $($errorJson.description)" -ForegroundColor Red
            }
        } catch {
            Write-Host "Impossible de parser le JSON d'erreur"
        }
    } catch {
        Write-Host "⚠️ Impossible de lire le body d'erreur: $($_.Exception.Message)"
    }
}

Write-Host ""
Write-Host "───────────────────────────────────────────────────────────" -ForegroundColor Gray
Write-Host ""

# Test 2 : Sans scope
Write-Host "Test 2: OAuth v3/token sans scope" -ForegroundColor Cyan
try {
    $formBody = "grant_type=client_credentials"
    
    $response = Invoke-WebRequest -Uri "https://api.orange.com/oauth/v3/token" `
        -Method Post `
        -Headers @{
            "Authorization" = "Basic $encoded"
            "Content-Type" = "application/x-www-form-urlencoded"
        } `
        -Body $formBody `
        -ErrorAction Stop
    
    Write-Host "✅ SUCCÈS !" -ForegroundColor Green
    Write-Host "Status: $($response.StatusCode)"
    $json = $response.Content | ConvertFrom-Json
    Write-Host "Access Token: $($json.access_token.Substring(0, 20))..." -ForegroundColor Green
    Write-Host "Expires in: $($json.expires_in) secondes"
    Write-Host ""
    Write-Host "✅ Les credentials sont VALIDES (sans scope) !" -ForegroundColor Green
    
} catch {
    Write-Host "❌ ÉCHEC" -ForegroundColor Red
    Write-Host "Status: $($_.Exception.Response.StatusCode.value__)"
    Write-Host ""
    
    # Essayer de lire le body d'erreur
    try {
        $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
        $responseBody = $reader.ReadToEnd()
        $reader.Close()
        
        Write-Host "📄 Message d'erreur Orange:" -ForegroundColor Yellow
        Write-Host $responseBody
        Write-Host ""
        
        # Parser le JSON si possible
        try {
            $errorJson = $responseBody | ConvertFrom-Json
            Write-Host "Code erreur: $($errorJson.code)" -ForegroundColor Red
            Write-Host "Message: $($errorJson.message)" -ForegroundColor Red
            if ($errorJson.description) {
                Write-Host "Description: $($errorJson.description)" -ForegroundColor Red
            }
        } catch {
            Write-Host "Impossible de parser le JSON d'erreur"
        }
    } catch {
        Write-Host "⚠️ Impossible de lire le body d'erreur: $($_.Exception.Message)"
    }
}

Write-Host ""
Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "   📋 RÉSUMÉ" -ForegroundColor Yellow
Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""
Write-Host "Si les deux tests échouent avec 401:" -ForegroundColor Yellow
Write-Host "  1. Vérifiez les credentials dans https://developer.orange.com/" -ForegroundColor White
Write-Host "  2. Vérifiez que le Client Secret n'a pas été régénéré" -ForegroundColor White
Write-Host "  3. Vérifiez que l'application est active" -ForegroundColor White
Write-Host "  4. Vérifiez que vous avez un bundle SMS avec solde > 0" -ForegroundColor White
Write-Host ""
Write-Host "Si un test réussit:" -ForegroundColor Green
Write-Host "  ✅ Les credentials sont valides" -ForegroundColor Green
Write-Host "  ✅ Le problème vient peut-être de la configuration dans Spring Boot" -ForegroundColor Green
Write-Host ""
Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

