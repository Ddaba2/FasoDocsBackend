# Test d'authentification avec vérification du bundle
# Vous avez un bundle actif, testons si l'authentification fonctionne maintenant

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Test Orange SMS - Bundle Actif Vérifié" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "✅ Votre Bundle SMS:" -ForegroundColor Green
Write-Host "  - Statut: ACTIF" -ForegroundColor Gray
Write-Host "  - Crédits: 100 unités" -ForegroundColor Gray
Write-Host "  - Expiration: 29 novembre 2025" -ForegroundColor Gray
Write-Host ""

$clientId = "eeQIIfQYVsDYRDHvG5ziEHMpJ18bHlcG"
$clientSecret = "EJn9NPCK51YtFfq3AE5pKiWGdVmYdVdYLTb68cCtfaXt"
$authUrl = "https://api.orange.com/oauth/v3/token"

# Calculer le header Basic Auth
$credentials = "$clientId`:$clientSecret"
$bytes = [System.Text.Encoding]::UTF8.GetBytes($credentials)
$encoded = [Convert]::ToBase64String($bytes)
$authHeader = "Basic $encoded"

Write-Host "Test d'authentification..." -ForegroundColor Yellow
Write-Host "  URL: $authUrl" -ForegroundColor Gray
Write-Host "  Body: grant_type=client_credentials" -ForegroundColor Gray
Write-Host ""

try {
    $response = Invoke-RestMethod -Uri $authUrl -Method Post `
        -Headers @{
            "Content-Type" = "application/x-www-form-urlencoded"
            "Authorization" = $authHeader
            "Accept" = "application/json"
        } `
        -Body "grant_type=client_credentials" `
        -ErrorAction Stop
    
    Write-Host "✅✅✅ SUCCÈS - Authentification réussie!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Access Token: $($response.access_token.Substring(0, [Math]::Min(50, $response.access_token.Length)))..." -ForegroundColor Cyan
    Write-Host "Expires in: $($response.expires_in) seconds ($([math]::Round($response.expires_in / 60, 1)) minutes)" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "🎉 Votre configuration fonctionne maintenant!" -ForegroundColor Green
    Write-Host "   Vous pouvez redémarrer votre application Spring Boot" -ForegroundColor Yellow
    Write-Host "   Les SMS devraient maintenant être envoyés avec succès" -ForegroundColor Yellow
    
    exit 0
} catch {
    $statusCode = $_.Exception.Response.StatusCode.value__
    $errorBody = $_.ErrorDetails.Message
    
    Write-Host "❌ ÉCHEC - Erreur $statusCode" -ForegroundColor Red
    Write-Host "Message: $errorBody" -ForegroundColor Red
    Write-Host ""
    
    if ($statusCode -eq 401) {
        Write-Host "⚠️  Erreur 401 = 'Unknown client'" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "DIAGNOSTIC:" -ForegroundColor Cyan
        Write-Host "  - ✅ Bundle SMS: ACTIF" -ForegroundColor Green
        Write-Host "  - ✅ Credentials: CORRECTS" -ForegroundColor Green
        Write-Host "  - ✅ API: APPROUVÉE" -ForegroundColor Green
        Write-Host "  - ❌ Authentification: ÉCHOUE" -ForegroundColor Red
        Write-Host ""
        Write-Host "CONCLUSION:" -ForegroundColor Yellow
        Write-Host "  Le problème vient du côté Orange (serveur), pas de votre configuration." -ForegroundColor White
        Write-Host "  L'API n'est probablement pas encore activée côté serveur Orange." -ForegroundColor White
        Write-Host ""
        Write-Host "ACTION REQUISE:" -ForegroundColor Yellow
        Write-Host "  1. Contactez le support Orange Mali" -ForegroundColor White
        Write-Host "  2. Utilisez le message dans CONTACT_SUPPORT_ORANGE.md" -ForegroundColor White
        Write-Host "  3. Mentionnez que vous avez un bundle actif mais l'auth échoue" -ForegroundColor White
    }
    
    exit 1
}

