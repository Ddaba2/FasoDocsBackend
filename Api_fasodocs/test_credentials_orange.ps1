# Script de test pour vérifier les credentials Orange SMS
# Utilisez ce script pour tester vos credentials avant de les mettre dans application.properties

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Test Credentials Orange SMS" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Credentials depuis le portail Orange
$clientId = "eeQIIfQYVsDYRDHvG5ziEHMpJ18bHlcG"
$clientSecret = "EJn9NPCK51YtFfq3AE5pKiWGdVmYdVdYLTb68cCtfaXt"
$authUrl = "https://api.orange.com/oauth/v3/token"

Write-Host "1. Configuration" -ForegroundColor Green
Write-Host "   Client ID: $clientId" -ForegroundColor Gray
Write-Host "   Client Secret: $($clientSecret.Substring(0, [Math]::Min(10, $clientSecret.Length)))..." -ForegroundColor Gray
Write-Host "   URL: $authUrl" -ForegroundColor Gray
Write-Host ""

# Calculer le header Basic Auth
$credentials = "$clientId`:$clientSecret"
$bytes = [System.Text.Encoding]::UTF8.GetBytes($credentials)
$encoded = [Convert]::ToBase64String($bytes)
$authHeader = "Basic $encoded"

Write-Host "2. Test d'authentification (sans scope)" -ForegroundColor Green
Write-Host ""

$body = "grant_type=client_credentials"

try {
    $response = Invoke-RestMethod -Uri $authUrl -Method Post `
        -Headers @{
            "Content-Type" = "application/x-www-form-urlencoded"
            "Authorization" = $authHeader
            "Accept" = "application/json"
        } `
        -Body $body `
        -ErrorAction Stop
    
    Write-Host "   ✅ SUCCÈS - Authentification réussie!" -ForegroundColor Green
    Write-Host "   Access Token: $($response.access_token.Substring(0, [Math]::Min(30, $response.access_token.Length)))..." -ForegroundColor Cyan
    Write-Host "   Expires in: $($response.expires_in) seconds" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "   ✅ Ces credentials sont VALIDES!" -ForegroundColor Green
    Write-Host "   Vous pouvez les utiliser dans application.properties" -ForegroundColor Yellow
    exit 0
} catch {
    $statusCode = $_.Exception.Response.StatusCode.value__
    $errorBody = $_.ErrorDetails.Message
    
    Write-Host "   ❌ ÉCHEC - Erreur $statusCode" -ForegroundColor Red
    Write-Host "   Message: $errorBody" -ForegroundColor Red
    Write-Host ""
    
    if ($statusCode -eq 401) {
        Write-Host "   ⚠️  Erreur 401 = Credentials invalides" -ForegroundColor Yellow
        Write-Host "   Vérifiez que le Client Secret correspond à celui du portail Orange" -ForegroundColor Yellow
    }
    
    exit 1
}

