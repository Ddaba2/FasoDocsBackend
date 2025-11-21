# Script de test pour vérifier l'authentification Orange SMS avec le nouveau Client Secret
# Usage: .\test_orange_auth_new_secret.ps1

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "TEST AUTHENTIFICATION ORANGE SMS" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Configuration depuis application.properties
$clientId = "eeQIIfQYVsDYRDHvG5ziEHMpJ18bHlcG"
$clientSecret = "MKAh6Y2TWs3kBdeUlVtVfmnAzckniO2GvJwzgwYSMdt1"

# Calculer le header Base64
$credentials = "$clientId`:$clientSecret"
$bytes = [System.Text.Encoding]::UTF8.GetBytes($credentials)
$encoded = [Convert]::ToBase64String($bytes)

Write-Host "Configuration:" -ForegroundColor Yellow
Write-Host "   Client ID: $clientId" -ForegroundColor Gray
Write-Host "   Client Secret: $clientSecret" -ForegroundColor Gray
Write-Host "   Header Base64: $encoded" -ForegroundColor Gray
Write-Host ""

# Test d'authentification
$authUrl = "https://api.orange.com/oauth/v3/token"
$headers = @{
    "Content-Type" = "application/x-www-form-urlencoded"
    "Authorization" = "Basic $encoded"
}
$body = "grant_type=client_credentials&scope=SMS"

Write-Host "Test d'authentification:" -ForegroundColor Yellow
Write-Host "   URL: $authUrl" -ForegroundColor Gray
Write-Host "   Method: POST" -ForegroundColor Gray
Write-Host "   Body: grant_type=client_credentials&scope=SMS" -ForegroundColor Gray
Write-Host ""

try {
    Write-Host "Envoi de la requête..." -ForegroundColor Cyan
    $response = Invoke-RestMethod -Uri $authUrl -Method Post `
        -Headers $headers `
        -Body $body `
        -ErrorAction Stop
    
    Write-Host ""
    Write-Host "✅✅✅ SUCCÈS - AUTHENTIFICATION RÉUSSIE ✅✅✅" -ForegroundColor Green
    Write-Host ""
    Write-Host "Access Token: $($response.access_token.Substring(0, 30))..." -ForegroundColor Cyan
    Write-Host "Expires in: $($response.expires_in) seconds" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "✅ Les credentials sont VALIDES !" -ForegroundColor Green
    Write-Host "✅ Le problème vient peut-être du code Java ou de la configuration" -ForegroundColor Green
    Write-Host ""
    
} catch {
    $statusCode = $_.Exception.Response.StatusCode.value__
    $errorBody = $_.ErrorDetails.Message
    
    Write-Host ""
    Write-Host "❌ ÉCHEC - Erreur $statusCode" -ForegroundColor Red
    Write-Host ""
    
    if ($statusCode -eq 401) {
        Write-Host "⚠️  Erreur 401 UNAUTHORIZED" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "CAUSES POSSIBLES:" -ForegroundColor Yellow
        Write-Host "   1. Le Client Secret n'est PAS le bon dans le portail Orange" -ForegroundColor White
        Write-Host "   2. Le Client Secret a été régénéré APRÈS votre mise à jour" -ForegroundColor White
        Write-Host "   3. Les credentials ne sont pas activés dans le portail Orange" -ForegroundColor White
        Write-Host ""
        Write-Host "ACTIONS REQUISES:" -ForegroundColor Yellow
        Write-Host "   1. Connectez-vous à https://developer.orange.com/" -ForegroundColor White
        Write-Host "   2. Vérifiez le Client Secret ACTUEL dans votre application" -ForegroundColor White
        Write-Host "   3. Copiez le Client Secret EXACT (sans espaces)" -ForegroundColor White
        Write-Host "   4. Mettez à jour application.properties avec le bon secret" -ForegroundColor White
        Write-Host "   5. Redémarrez le serveur" -ForegroundColor White
        Write-Host ""
    } else {
        Write-Host "Erreur: $errorBody" -ForegroundColor Red
    }
}

Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""









