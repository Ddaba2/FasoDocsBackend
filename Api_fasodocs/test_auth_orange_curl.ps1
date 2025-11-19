# Test d'authentification Orange SMS avec cURL
# Ce script teste directement l'authentification pour isoler le probleme

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Test Authentification Orange SMS (cURL)" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Configuration
$clientId = "eeQIIfQYVsDYRDHvG5ziEHMpJ18bHlcG"
$clientSecret = "jwySPv3Waaljeuj0xFHvPMdFGm482v3FwtNSVtf133Bd"
$authUrl = "https://api.orange.com/oauth/v3/token"

# Calculer le header Basic Auth
$credentials = "$clientId`:$clientSecret"
$bytes = [System.Text.Encoding]::UTF8.GetBytes($credentials)
$encoded = [Convert]::ToBase64String($bytes)
$authHeader = "Basic $encoded"

Write-Host "1. Configuration" -ForegroundColor Green
Write-Host "   Client ID: $clientId" -ForegroundColor Gray
Write-Host "   URL: $authUrl" -ForegroundColor Gray
Write-Host "   Authorization: Basic $encoded" -ForegroundColor Gray
Write-Host ""

# Test 1: Avec scope=SMS
Write-Host "2. Test 1: Authentification avec scope=SMS" -ForegroundColor Green
Write-Host ""

$body1 = "grant_type=client_credentials&scope=SMS"

try {
    $response1 = Invoke-RestMethod -Uri $authUrl -Method Post `
        -Headers @{
            "Content-Type" = "application/x-www-form-urlencoded"
            "Authorization" = $authHeader
        } `
        -Body $body1 `
        -ErrorAction Stop
    
    Write-Host "   SUCCES - Token obtenu!" -ForegroundColor Green
    Write-Host "   Access Token: $($response1.access_token.Substring(0, 30))..." -ForegroundColor Cyan
    Write-Host "   Expires in: $($response1.expires_in) seconds" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "   SOLUTION: Utilisez cette configuration dans le code Java" -ForegroundColor Yellow
    Write-Host "   - URL: $authUrl" -ForegroundColor White
    Write-Host "   - Scope: SMS (requis)" -ForegroundColor White
    exit 0
} catch {
    $statusCode = $_.Exception.Response.StatusCode.value__
    Write-Host "   ECHEC - Erreur $statusCode" -ForegroundColor Red
    if ($_.ErrorDetails) {
        Write-Host "   Body: $($_.ErrorDetails.Message)" -ForegroundColor Yellow
    }
    Write-Host ""
}

# Test 2: Sans scope
Write-Host "3. Test 2: Authentification SANS scope" -ForegroundColor Green
Write-Host ""

$body2 = "grant_type=client_credentials"

try {
    $response2 = Invoke-RestMethod -Uri $authUrl -Method Post `
        -Headers @{
            "Content-Type" = "application/x-www-form-urlencoded"
            "Authorization" = $authHeader
        } `
        -Body $body2 `
        -ErrorAction Stop
    
    Write-Host "   SUCCES - Token obtenu!" -ForegroundColor Green
    Write-Host "   Access Token: $($response2.access_token.Substring(0, 30))..." -ForegroundColor Cyan
    Write-Host "   Expires in: $($response2.expires_in) seconds" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "   SOLUTION: Utilisez cette configuration dans le code Java" -ForegroundColor Yellow
    Write-Host "   - URL: $authUrl" -ForegroundColor White
    Write-Host "   - Scope: NON requis" -ForegroundColor White
    exit 0
} catch {
    $statusCode = $_.Exception.Response.StatusCode.value__
    Write-Host "   ECHEC - Erreur $statusCode" -ForegroundColor Red
    if ($_.ErrorDetails) {
        Write-Host "   Body: $($_.ErrorDetails.Message)" -ForegroundColor Yellow
    }
    Write-Host ""
}

# Si les deux tests echouent
Write-Host "4. Diagnostic" -ForegroundColor Red
Write-Host ""
Write-Host "   Les deux tests ont echoue avec erreur 401." -ForegroundColor Yellow
Write-Host ""
Write-Host "   CAUSES POSSIBLES:" -ForegroundColor Yellow
Write-Host "   1. Le Client Secret a ete regenere dans le portail Orange" -ForegroundColor White
Write-Host "   2. Les credentials sont pour un environnement different (sandbox vs production)" -ForegroundColor White
Write-Host "   3. L'application SMS n'est pas completement activee malgre le statut 'Approuve'" -ForegroundColor White
Write-Host "   4. Problème de permissions ou de configuration dans le portail Orange" -ForegroundColor White
Write-Host ""
Write-Host "   ACTIONS:" -ForegroundColor Yellow
Write-Host "   1. Verifiez dans le portail Orange que le Client Secret n'a pas ete regenere" -ForegroundColor White
Write-Host "   2. Contactez le support Orange Mali avec:" -ForegroundColor White
Write-Host "      - Client ID: $clientId" -ForegroundColor Cyan
Write-Host "      - Application ID: iy3KWH9GiNK0evSY" -ForegroundColor Cyan
Write-Host "      - Erreur: 401 UNAUTHORIZED sur $authUrl" -ForegroundColor Cyan
Write-Host "      - Message: 'Les credentials sont corrects mais l'authentification echoue'" -ForegroundColor Cyan
Write-Host ""

