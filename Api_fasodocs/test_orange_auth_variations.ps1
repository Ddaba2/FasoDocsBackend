# Test d'authentification Orange SMS avec différentes configurations
# Pour identifier la bonne configuration pour SMS Mali - Entreprise v3.0

$clientId = "eeQIIfQYVsDYRDHvG5ziEHMpJ18bHlcG"
$clientSecret = "MKAh6Y2TWs3kBdeUlVtVfmnAzckniO2GvJwzgwYSMdt1"

$credentials = "$clientId`:$clientSecret"
$bytes = [System.Text.Encoding]::UTF8.GetBytes($credentials)
$encoded = [Convert]::ToBase64String($bytes)
$authHeader = "Basic $encoded"

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "TEST AUTHENTIFICATION ORANGE SMS" -ForegroundColor Cyan
Write-Host "Variations pour SMS Mali - Entreprise v3.0" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$configurations = @(
    @{
        Name = "URL v3 avec scope=SMS"
        Url = "https://api.orange.com/oauth/v3/token"
        Body = "grant_type=client_credentials&scope=SMS"
    },
    @{
        Name = "URL v3 sans scope"
        Url = "https://api.orange.com/oauth/v3/token"
        Body = "grant_type=client_credentials"
    },
    @{
        Name = "URL v2 avec scope=SMS"
        Url = "https://api.orange.com/oauth/v2/token"
        Body = "grant_type=client_credentials&scope=SMS"
    },
    @{
        Name = "URL v2 sans scope"
        Url = "https://api.orange.com/oauth/v2/token"
        Body = "grant_type=client_credentials"
    },
    @{
        Name = "URL v1 avec scope=SMS"
        Url = "https://api.orange.com/oauth/v1/token"
        Body = "grant_type=client_credentials&scope=SMS"
    },
    @{
        Name = "URL v1 sans scope"
        Url = "https://api.orange.com/oauth/v1/token"
        Body = "grant_type=client_credentials"
    }
)

$success = $false

foreach ($config in $configurations) {
    Write-Host "Test: $($config.Name)" -ForegroundColor Yellow
    Write-Host "   URL: $($config.Url)" -ForegroundColor Gray
    Write-Host "   Body: $($config.Body)" -ForegroundColor Gray
    
    $headers = @{
        "Content-Type" = "application/x-www-form-urlencoded"
        "Authorization" = $authHeader
    }
    
    try {
        $response = Invoke-RestMethod -Uri $config.Url -Method Post `
            -Headers $headers `
            -Body $config.Body `
            -ErrorAction Stop
        
        Write-Host "   ✅✅✅ SUCCÈS ! ✅✅✅" -ForegroundColor Green
        Write-Host "   Access Token: $($response.access_token.Substring(0, 30))..." -ForegroundColor Cyan
        Write-Host "   Expires in: $($response.expires_in) seconds" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "   ⭐ CONFIGURATION GAGNANTE ⭐" -ForegroundColor Green
        Write-Host "   Utilisez cette configuration dans votre code Java:" -ForegroundColor Yellow
        Write-Host "   - URL: $($config.Url)" -ForegroundColor White
        Write-Host "   - Body: $($config.Body)" -ForegroundColor White
        Write-Host ""
        $success = $true
        break
    } catch {
        $statusCode = $_.Exception.Response.StatusCode.value__
        if ($statusCode -eq 401) {
            Write-Host "   ❌ Erreur 401 UNAUTHORIZED" -ForegroundColor Red
        } elseif ($statusCode -eq 404) {
            Write-Host "   ❌ Erreur 404 NOT FOUND" -ForegroundColor Red
        } else {
            Write-Host "   ❌ Erreur $statusCode" -ForegroundColor Red
        }
    }
    Write-Host ""
}

if (-not $success) {
    Write-Host "❌ Toutes les configurations ont échoué" -ForegroundColor Red
    Write-Host ""
    Write-Host "ACTIONS REQUISES:" -ForegroundColor Yellow
    Write-Host "   1. Vérifiez que l'API 'SMS Mali - Entreprise' est bien activée" -ForegroundColor White
    Write-Host "   2. Vérifiez que votre compte a les permissions nécessaires" -ForegroundColor White
    Write-Host "   3. Contactez le support Orange Mali avec:" -ForegroundColor White
    Write-Host "      - Client ID: $clientId" -ForegroundColor Gray
    Write-Host "      - Application ID: iy3KWH9GiNK0evSY" -ForegroundColor Gray
    Write-Host "      - Erreur: 401 UNAUTHORIZED sur toutes les configurations" -ForegroundColor Gray
    Write-Host ""
}

Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""









