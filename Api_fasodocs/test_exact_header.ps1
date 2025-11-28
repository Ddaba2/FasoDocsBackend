# Test ultra-simple de l'authentification Orange
# Verifie l'encodage exact du header Authorization

$clientId = "eeQIIfQYVsDYRDHvG5ziEHMpJ18bHlcG"
$clientSecret = "EJn9NPCK51YtFfq3AE5pKiWGdVmYdVdYLTb68cCtfaXt"

Write-Host "=== TEST ENCODAGE AUTHORIZATION HEADER ===" -ForegroundColor Cyan
Write-Host ""

# Method 1: Encodage manuel
$pair = "${clientId}:${clientSecret}"
$bytes = [System.Text.Encoding]::UTF8.GetBytes($pair)
$base64 = [Convert]::ToBase64String($bytes)

Write-Host "Client ID: $clientId" -ForegroundColor White
Write-Host "Client Secret: $clientSecret" -ForegroundColor White
Write-Host ""
Write-Host "Concatenation: ${clientId}:${clientSecret}" -ForegroundColor Gray
Write-Host ""
Write-Host "Base64 encode (calculate): $base64" -ForegroundColor Yellow
Write-Host "Base64 from portal:        ZWVRSUlmUVlWc0RZUkRIdkc1emlFSE1wSjE4YkhsY0c6RUpuOU5QQ0s1MVl0RmZxM0FFNXBLaVdHZFZtWWRWZFlMVGI2OGNDdGZhWHQ=" -ForegroundColor Yellow
Write-Host ""

if ($base64 -eq "ZWVRSUlmUVlWc0RZUkRIdkc1emlFSE1wSjE4YkhsY0c6RUpuOU5QQ0s1MVl0RmZxM0FFNXBLaVdHZFZtWWRWZFlMVGI2OGNDdGZhWHQ=") {
    Write-Host "OK - Authorization header matches!" -ForegroundColor Green
} else {
    Write-Host "ERROR - Authorization header MISMATCH!" -ForegroundColor Red
    Write-Host "This could be the problem!" -ForegroundColor Red
}

Write-Host ""
Write-Host "=== TESTING OAUTH ===" -ForegroundColor Cyan
Write-Host ""

# Test OAuth with exact header from portal
$headers = @{
    "Authorization" = "Basic ZWVRSUlmUVlWc0RZUkRIdkc1emlFSE1wSjE4YkhsY0c6RUpuOU5QQ0s1MVl0RmZxM0FFNXBLaVdHZFZtWWRWZFlMVGI2OGNDdGZhWHQ="
    "Content-Type" = "application/x-www-form-urlencoded"
    "Accept" = "application/json"
}

$body = "grant_type=client_credentials"

Write-Host "Using Authorization header EXACTLY from Orange portal..." -ForegroundColor Yellow

try {
    $response = Invoke-RestMethod -Uri "https://api.orange.com/oauth/v3/token" `
        -Method POST `
        -Headers $headers `
        -Body $body `
        -ContentType "application/x-www-form-urlencoded" `
        -ErrorAction Stop
    
    Write-Host ""
    Write-Host "SUCCESS!!!" -ForegroundColor Green
    Write-Host "Access Token: $($response.access_token.Substring(0, 50))..." -ForegroundColor Green
    Write-Host "Expires in: $($response.expires_in) seconds" -ForegroundColor Green
    Write-Host ""
    
    exit 0
} catch {
    $statusCode = $_.Exception.Response.StatusCode.value__
    Write-Host "FAILED - Status: $statusCode" -ForegroundColor Red
    
    try {
        $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
        $errorBody = $reader.ReadToEnd()
        $reader.Close()
        Write-Host "Error: $errorBody" -ForegroundColor Red
    } catch {
        Write-Host "Could not read error body" -ForegroundColor Red
    }
    
    Write-Host ""
    Write-Host "If this still fails with 'Unknown client'," -ForegroundColor Yellow
    Write-Host "the problem is NOT with encoding but with Orange's system." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "NEXT STEPS:" -ForegroundColor Yellow
    Write-Host "1. Ask Orange support for the EXACT OAuth endpoint to use" -ForegroundColor White
    Write-Host "2. Ask if there's a waiting period after bundle purchase" -ForegroundColor White
    Write-Host "3. Ask if credentials need manual activation" -ForegroundColor White
    
    exit 1
}
