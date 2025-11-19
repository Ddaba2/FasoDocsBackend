# Script pour verifier que le header d'autorisation est correct
# Usage: .\verifier_header_authorization.ps1

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "VERIFICATION DU HEADER D'AUTORISATION ORANGE SMS" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Configuration depuis application.properties
$clientId = "eeQIIfQYVsDYRDHvG5ziEHMpJ18bHlcG"
$clientSecret = "TlzX6Cgw2ngy78tTPVqDoOa2Aq6MKCrsg7BMgKPvqtvT"
$headerFromConfig = "ZWVRSUlmUVlWc0RZUkRIdkc1emlFSE1wSjE4YkhsY0c6VGx6WDZDZ3cybmd5Nzh0VFBWcURvT2EyQXE2TUtDcnNnN0JNZ0tQdnF0dlQ="

# Calculer le header
$credentials = "$clientId`:$clientSecret"
$bytes = [System.Text.Encoding]::UTF8.GetBytes($credentials)
$calculatedHeader = [Convert]::ToBase64String($bytes)

Write-Host "Configuration:" -ForegroundColor Yellow
Write-Host "   Client ID: $clientId" -ForegroundColor Gray
Write-Host "   Client Secret: $clientSecret" -ForegroundColor Gray
Write-Host ""

Write-Host "Headers d'autorisation:" -ForegroundColor Yellow
Write-Host "   Header dans config: $headerFromConfig" -ForegroundColor Gray
Write-Host "   Header calcule:     $calculatedHeader" -ForegroundColor Gray
Write-Host ""

if ($headerFromConfig -eq $calculatedHeader) {
    Write-Host "OK: Les headers correspondent !" -ForegroundColor Green
    Write-Host ""
} else {
    Write-Host "ERREUR: Les headers NE correspondent PAS !" -ForegroundColor Red
    Write-Host ""
    Write-Host "ACTION REQUISE:" -ForegroundColor Yellow
    Write-Host "   Mettez a jour application.properties avec:" -ForegroundColor Yellow
    Write-Host "   orange.sms.authorization.header=$calculatedHeader" -ForegroundColor Cyan
    Write-Host ""
}

# Test avec cURL
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "TEST D'AUTHENTIFICATION AVEC cURL" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$authUrl = "https://api.orange.com/oauth/v3/token"
$authHeader = "Basic $calculatedHeader"

Write-Host "Test 1: Avec scope=SMS" -ForegroundColor Yellow
Write-Host ""

try {
    $body = "grant_type=client_credentials&scope=SMS"
    $response = Invoke-RestMethod -Uri $authUrl -Method Post `
        -Headers @{
            "Content-Type" = "application/x-www-form-urlencoded"
            "Authorization" = $authHeader
        } `
        -Body $body `
        -ErrorAction Stop
    
    Write-Host "SUCCES ! Authentification reussie !" -ForegroundColor Green
    $tokenPreview = $response.access_token.Substring(0, 30)
    Write-Host "   Access Token: ${tokenPreview}..." -ForegroundColor Cyan
    Write-Host "   Expires in: $($response.expires_in) seconds" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "SOLUTION: Les credentials sont valides !" -ForegroundColor Green
    Write-Host "   Le probleme vient peut-etre du code Java ou de la configuration." -ForegroundColor Yellow
    Write-Host ""
    exit 0
} catch {
    $statusCode = $_.Exception.Response.StatusCode.value__
    $errorMessage = $_.Exception.Message
    
    Write-Host "Echec - Status Code: $statusCode" -ForegroundColor Red
    Write-Host "   Message: $errorMessage" -ForegroundColor Red
    Write-Host ""
    
    if ($statusCode -eq 401) {
        Write-Host "ERREUR 401 - Credentials invalides" -ForegroundColor Red
        Write-Host ""
        Write-Host "CAUSES POSSIBLES:" -ForegroundColor Yellow
        Write-Host "   1. Le Client Secret est incorrect" -ForegroundColor Yellow
        Write-Host "   2. Le Client ID ne correspond pas au Client Secret" -ForegroundColor Yellow
        Write-Host "   3. L'application SMS n'est pas activee dans le portail Orange" -ForegroundColor Yellow
        Write-Host "   4. Les permissions SMS ne sont pas accordees" -ForegroundColor Yellow
        Write-Host "   5. L'URL d'authentification n'est pas la bonne pour Orange Mali" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "ACTIONS:" -ForegroundColor Yellow
        Write-Host "   1. Verifiez les credentials sur https://developer.orange.com/" -ForegroundColor Cyan
        Write-Host "   2. Verifiez que l'application SMS est activee" -ForegroundColor Cyan
        Write-Host "   3. Verifiez que les permissions SMS sont accordees" -ForegroundColor Cyan
        Write-Host "   4. Contactez le support Orange Mali" -ForegroundColor Cyan
        Write-Host ""
    } elseif ($statusCode -eq 404) {
        Write-Host "ERREUR 404 - URL non trouvee" -ForegroundColor Red
        Write-Host "   L'URL d'authentification n'existe pas" -ForegroundColor Yellow
        Write-Host "   Essayez une autre URL comme v1 ou sans version" -ForegroundColor Yellow
        Write-Host ""
    }
}

Write-Host "Test 2: Sans scope" -ForegroundColor Yellow
Write-Host ""

try {
    $body = "grant_type=client_credentials"
    $response = Invoke-RestMethod -Uri $authUrl -Method Post `
        -Headers @{
            "Content-Type" = "application/x-www-form-urlencoded"
            "Authorization" = $authHeader
        } `
        -Body $body `
        -ErrorAction Stop
    
    Write-Host "SUCCES ! Authentification reussie sans scope !" -ForegroundColor Green
    $tokenPreview = $response.access_token.Substring(0, 30)
    Write-Host "   Access Token: ${tokenPreview}..." -ForegroundColor Cyan
    Write-Host "   Expires in: $($response.expires_in) seconds" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "SOLUTION: Utilisez cette configuration sans scope" -ForegroundColor Green
    Write-Host ""
    exit 0
} catch {
    $statusCode = $_.Exception.Response.StatusCode.value__
    Write-Host "Echec - Status Code: $statusCode" -ForegroundColor Red
    Write-Host ""
}

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "TOUS LES TESTS ONT ECHOUE" -ForegroundColor Red
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "PROCHAINES ETAPES:" -ForegroundColor Yellow
Write-Host "   1. Verifiez les credentials sur https://developer.orange.com/" -ForegroundColor Cyan
Write-Host "   2. Verifiez que l'application SMS est activee" -ForegroundColor Cyan
Write-Host "   3. Verifiez que les permissions SMS sont accordees" -ForegroundColor Cyan
Write-Host "   4. Contactez le support Orange Mali avec:" -ForegroundColor Cyan
Write-Host "      - Client ID: $clientId" -ForegroundColor Gray
Write-Host "      - Application ID: iy3KWH9GiNK0evSY" -ForegroundColor Gray
Write-Host "      - Erreur: 401 UNAUTHORIZED" -ForegroundColor Gray
Write-Host ""
