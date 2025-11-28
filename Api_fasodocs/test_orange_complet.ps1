# Test complet de l'authentification Orange SMS
# Test avec différentes configurations selon la documentation Orange

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Test Complet Orange SMS" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$clientId = "eeQIIfQYVsDYRDHvG5ziEHMpJ18bHlcG"
$clientSecret = "EJn9NPCK51YtFfq3AE5pKiWGdVmYdVdYLTb68cCtfaXt"

# Calculer le header Basic Auth
$credentials = "$clientId`:$clientSecret"
$bytes = [System.Text.Encoding]::UTF8.GetBytes($credentials)
$encoded = [Convert]::ToBase64String($bytes)
$authHeader = "Basic $encoded"

Write-Host "Configuration:" -ForegroundColor Green
Write-Host "  Client ID: $clientId" -ForegroundColor Gray
Write-Host "  Client Secret: $($clientSecret.Substring(0, 10))..." -ForegroundColor Gray
Write-Host "  Authorization Header: Basic $($encoded.Substring(0, 30))..." -ForegroundColor Gray
Write-Host ""

# Test 1: URL v3 sans scope (selon documentation Orange)
Write-Host "Test 1: https://api.orange.com/oauth/v3/token (sans scope)" -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "https://api.orange.com/oauth/v3/token" -Method Post `
        -Headers @{
            "Content-Type" = "application/x-www-form-urlencoded"
            "Authorization" = $authHeader
            "Accept" = "application/json"
        } `
        -Body "grant_type=client_credentials" `
        -ErrorAction Stop
    
    Write-Host "  ✅ SUCCÈS!" -ForegroundColor Green
    Write-Host "  Token: $($response.access_token.Substring(0, 30))..." -ForegroundColor Cyan
    Write-Host "  Expires: $($response.expires_in) seconds" -ForegroundColor Cyan
    exit 0
} catch {
    Write-Host "  ❌ ÉCHEC: $($_.Exception.Message)" -ForegroundColor Red
    if ($_.ErrorDetails.Message) {
        Write-Host "  Détails: $($_.ErrorDetails.Message)" -ForegroundColor Red
    }
}
Write-Host ""

# Test 2: URL v3 avec scope SMS
Write-Host "Test 2: https://api.orange.com/oauth/v3/token (avec scope=SMS)" -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "https://api.orange.com/oauth/v3/token" -Method Post `
        -Headers @{
            "Content-Type" = "application/x-www-form-urlencoded"
            "Authorization" = $authHeader
            "Accept" = "application/json"
        } `
        -Body "grant_type=client_credentials&scope=SMS" `
        -ErrorAction Stop
    
    Write-Host "  ✅ SUCCÈS!" -ForegroundColor Green
    Write-Host "  Token: $($response.access_token.Substring(0, 30))..." -ForegroundColor Cyan
    Write-Host "  Expires: $($response.expires_in) seconds" -ForegroundColor Cyan
    exit 0
} catch {
    Write-Host "  ❌ ÉCHEC: $($_.Exception.Message)" -ForegroundColor Red
    if ($_.ErrorDetails.Message) {
        Write-Host "  Détails: $($_.ErrorDetails.Message)" -ForegroundColor Red
    }
}
Write-Host ""

# Vérifier le header d'autorisation fourni par Orange
Write-Host "Vérification du header d'autorisation du portail:" -ForegroundColor Yellow
$portalHeader = "Basic ZWVRSUlmUVlWc0RZUkRIdkc1emlFSE1wSjE4YkhsY0c6RUpuOU5QQ0s1MVl0RmZxM0FFNXBLaVdHZFZtWWRWZFlMVGI2OGNDdGZhWHQ="
Write-Host "  Header du portail: $($portalHeader.Substring(0, 30))..." -ForegroundColor Gray
Write-Host "  Header calculé:    Basic $($encoded.Substring(0, 30))..." -ForegroundColor Gray

if ($portalHeader -eq "Basic $encoded") {
    Write-Host "  ✅ Les headers correspondent!" -ForegroundColor Green
} else {
    Write-Host "  ⚠️  Les headers NE correspondent PAS!" -ForegroundColor Yellow
    Write-Host "  Cela signifie que le Client Secret dans application.properties ne correspond pas" -ForegroundColor Yellow
}
Write-Host ""

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Diagnostic" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Si tous les tests échouent avec 'Unknown client':" -ForegroundColor Yellow
Write-Host "  1. Vérifiez que l'API 'SMS Mali - Entreprise' est bien ACTIVÉE" -ForegroundColor White
Write-Host "  2. Vérifiez que vous avez un BUNDLE SMS ACTIF avec des crédits" -ForegroundColor White
Write-Host "  3. Vérifiez que l'Application ID est correct: iy3KWH9GiNK0evSY" -ForegroundColor White
Write-Host "  4. Contactez le support Orange Mali pour vérifier l'activation" -ForegroundColor White
Write-Host ""

