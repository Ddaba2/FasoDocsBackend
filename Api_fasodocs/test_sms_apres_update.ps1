# Script PowerShell pour tester les endpoints SMS après mise à jour des credentials
# Usage: .\test_sms_apres_update.ps1

Write-Host ""
Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "🧪 TEST SMS APRÈS MISE À JOUR DES CREDENTIALS ORANGE" -ForegroundColor Cyan
Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

# Configuration
$baseUrl = "http://localhost:8080/api"
$adminPhone = "+22383784097"

# Étape 1 : Obtenir un token JWT d'admin
Write-Host "📱 ÉTAPE 1 : Connexion Admin pour obtenir un token JWT..." -ForegroundColor Yellow
Write-Host ""

$loginBody = @{
    telephone = $adminPhone
} | ConvertTo-Json

try {
    $loginResponse = Invoke-RestMethod -Uri "$baseUrl/auth/connexion-admin" `
        -Method POST `
        -ContentType "application/json" `
        -Body $loginBody `
        -ErrorAction Stop
    
    Write-Host "✅ Connexion admin réussie" -ForegroundColor Green
    Write-Host "   Message: $($loginResponse.message)" -ForegroundColor Gray
    Write-Host ""
    Write-Host "⚠️  Vous devez maintenant vérifier le code SMS reçu" -ForegroundColor Yellow
    Write-Host "   Puis utiliser l'endpoint /api/auth/verifier-sms-admin avec le code" -ForegroundColor Yellow
    Write-Host ""
    
    $code = Read-Host "Entrez le code SMS reçu"
    
    $verifyBody = @{
        telephone = $adminPhone
        code = $code
    } | ConvertTo-Json
    
    $verifyResponse = Invoke-RestMethod -Uri "$baseUrl/auth/verifier-sms-admin" `
        -Method POST `
        -ContentType "application/json" `
        -Body $verifyBody `
        -ErrorAction Stop
    
    $token = $verifyResponse.token
    
    if ($token) {
        Write-Host "✅ Token JWT obtenu avec succès" -ForegroundColor Green
        Write-Host "   Token: $($token.Substring(0, 50))..." -ForegroundColor Gray
        Write-Host ""
    } else {
        Write-Host "❌ Erreur: Token JWT non reçu" -ForegroundColor Red
        exit 1
    }
} catch {
    Write-Host "❌ Erreur lors de la connexion admin:" -ForegroundColor Red
    Write-Host "   $($_.Exception.Message)" -ForegroundColor Red
    Write-Host ""
    Write-Host "💡 Astuce: Vérifiez que l'application est démarrée et que le numéro est correct" -ForegroundColor Yellow
    exit 1
}

# Étape 2 : Tester l'authentification Orange
Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "🔐 ÉTAPE 2 : Test de l'authentification Orange SMS" -ForegroundColor Cyan
Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

$headers = @{
    "Authorization" = "Bearer $token"
    "Content-Type" = "application/json"
}

try {
    $authTestResponse = Invoke-RestMethod -Uri "$baseUrl/admin/sms/test-auth" `
        -Method POST `
        -Headers $headers `
        -ErrorAction Stop
    
    if ($authTestResponse.success -eq $true) {
        Write-Host "✅✅✅ AUTHENTIFICATION ORANGE RÉUSSIE ✅✅✅" -ForegroundColor Green
        Write-Host "   Message: $($authTestResponse.message)" -ForegroundColor Gray
        Write-Host "   Status: $($authTestResponse.status)" -ForegroundColor Gray
        Write-Host ""
    } else {
        Write-Host "❌ Authentification Orange échouée" -ForegroundColor Red
        Write-Host "   Message: $($authTestResponse.message)" -ForegroundColor Red
        Write-Host "   Status: $($authTestResponse.status)" -ForegroundColor Red
        Write-Host ""
        Write-Host "📋 Suggestions:" -ForegroundColor Yellow
        foreach ($suggestion in $authTestResponse.suggestions) {
            Write-Host "   - $suggestion" -ForegroundColor Yellow
        }
        Write-Host ""
        exit 1
    }
} catch {
    Write-Host "❌ Erreur lors du test d'authentification:" -ForegroundColor Red
    Write-Host "   $($_.Exception.Message)" -ForegroundColor Red
    Write-Host ""
    exit 1
}

# Étape 3 : Tester l'envoi d'un SMS
Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "📱 ÉTAPE 3 : Test de l'envoi d'un SMS" -ForegroundColor Cyan
Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

$smsTestUrl = "$baseUrl/admin/sms/test?telephone=$([System.Web.HttpUtility]::UrlEncode($adminPhone))"

try {
    $smsTestResponse = Invoke-RestMethod -Uri $smsTestUrl `
        -Method POST `
        -Headers $headers `
        -ErrorAction Stop
    
    if ($smsTestResponse.success -eq $true) {
        Write-Host "✅ SMS de test envoyé avec succès" -ForegroundColor Green
        Write-Host "   Téléphone: $($smsTestResponse.telephone)" -ForegroundColor Gray
        Write-Host "   Code de test: $($smsTestResponse.testCode)" -ForegroundColor Gray
        Write-Host ""
        Write-Host "📱 Vérifiez votre téléphone pour le SMS" -ForegroundColor Yellow
        Write-Host ""
    } else {
        Write-Host "❌ Erreur lors de l'envoi du SMS" -ForegroundColor Red
        Write-Host "   Message: $($smsTestResponse.message)" -ForegroundColor Red
        Write-Host ""
        exit 1
    }
} catch {
    Write-Host "❌ Erreur lors de l'envoi du SMS:" -ForegroundColor Red
    Write-Host "   $($_.Exception.Message)" -ForegroundColor Red
    Write-Host ""
    exit 1
}

# Résumé
Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "✅ TOUS LES TESTS SONT RÉUSSIS !" -ForegroundColor Green
Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""
Write-Host "📋 Résumé:" -ForegroundColor Yellow
Write-Host "   ✅ Authentification Orange: OK" -ForegroundColor Green
Write-Host "   ✅ Envoi SMS: OK" -ForegroundColor Green
Write-Host ""
Write-Host "🎯 Prochaines étapes:" -ForegroundColor Yellow
Write-Host "   1. Vérifiez que vous avez reçu le SMS sur votre téléphone" -ForegroundColor Gray
Write-Host "   2. Testez la connexion normale: POST /api/auth/connexion-telephone" -ForegroundColor Gray
Write-Host "   3. Vérifiez que le SMS est bien reçu lors de la connexion" -ForegroundColor Gray
Write-Host ""

