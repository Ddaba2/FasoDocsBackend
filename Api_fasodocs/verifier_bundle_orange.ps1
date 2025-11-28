# Script pour vérifier le bundle SMS Orange via l'API Admin
# Nécessite un access token valide

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Vérification Bundle SMS Orange" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# ⚠️ REMPLACEZ par votre access token (si vous en avez un)
$accessToken = "VOTRE_ACCESS_TOKEN_ICI"

if ($accessToken -eq "VOTRE_ACCESS_TOKEN_ICI") {
    Write-Host "⚠️  Ce script nécessite un access token valide" -ForegroundColor Yellow
    Write-Host "   Pour obtenir un token, l'authentification doit d'abord fonctionner" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "   Si vous n'avez pas de token, vérifiez le bundle dans le portail Orange:" -ForegroundColor White
    Write-Host "   1. Allez sur https://developer.orange.com/" -ForegroundColor Gray
    Write-Host "   2. MyApps → Votre application" -ForegroundColor Gray
    Write-Host "   3. Section 'Bundles' ou 'Purchase Orders'" -ForegroundColor Gray
    Write-Host ""
    exit 1
}

Write-Host "Récupération des informations du contrat..." -ForegroundColor Green
Write-Host ""

try {
    $response = Invoke-RestMethod -Uri "https://api.orange.com/sms/admin/v1/contracts" -Method Get `
        -Headers @{
            "Authorization" = "Bearer $accessToken"
            "Accept" = "application/json"
        } `
        -ErrorAction Stop
    
    Write-Host "✅ Informations du contrat récupérées!" -ForegroundColor Green
    Write-Host ""
    
    foreach ($contract in $response) {
        Write-Host "Contrat ID: $($contract.id)" -ForegroundColor Cyan
        Write-Host "  Type: $($contract.type)" -ForegroundColor Gray
        Write-Host "  Pays: $($contract.country)" -ForegroundColor Gray
        Write-Host "  Offre: $($contract.offerName)" -ForegroundColor Gray
        Write-Host "  Statut: $($contract.status)" -ForegroundColor $(if ($contract.status -eq "ACTIVE") { "Green" } else { "Red" })
        Write-Host "  Crédits disponibles: $($contract.availableUnits)" -ForegroundColor $(if ($contract.availableUnits -gt 0) { "Green" } else { "Red" })
        Write-Host "  Date d'expiration: $($contract.expirationDate)" -ForegroundColor Gray
        Write-Host ""
        
        if ($contract.status -ne "ACTIVE") {
            Write-Host "  ⚠️  Le contrat n'est PAS ACTIF!" -ForegroundColor Red
        }
        
        if ($contract.availableUnits -eq 0) {
            Write-Host "  ⚠️  Aucun crédit disponible!" -ForegroundColor Red
        }
    }
    
} catch {
    Write-Host "❌ Erreur lors de la récupération: $($_.Exception.Message)" -ForegroundColor Red
    if ($_.ErrorDetails.Message) {
        Write-Host "Détails: $($_.ErrorDetails.Message)" -ForegroundColor Red
    }
    Write-Host ""
    Write-Host "⚠️  Si vous obtenez une erreur 401, cela signifie que:" -ForegroundColor Yellow
    Write-Host "   1. Le token a expiré (durée de vie: 1 heure)" -ForegroundColor White
    Write-Host "   2. L'authentification n'a pas fonctionné" -ForegroundColor White
    Write-Host ""
    Write-Host "   Vérifiez le bundle directement dans le portail Orange" -ForegroundColor Yellow
}

