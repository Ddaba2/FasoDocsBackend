# Script PowerShell de test pour l'authentification Orange SMS
# Utilisez ce script pour tester l'authentification directement

Write-Host "🧪 Test d'authentification Orange SMS API" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

# Credentials
$CLIENT_ID = "eeQIIfQYVsDYRDHvG5ziEHMpJ18bHlcG"
$CLIENT_SECRET = "5LywHmVzKBh2xiUWsqY17wiLfjqcPluDMrAojfcRFhEX"

# Encoder en Base64
$credentials = "${CLIENT_ID}:${CLIENT_SECRET}"
$bytes = [System.Text.Encoding]::UTF8.GetBytes($credentials)
$CREDENTIALS_BASE64 = [Convert]::ToBase64String($bytes)

Write-Host "Client ID: $CLIENT_ID" -ForegroundColor Yellow
Write-Host "Client Secret: $CLIENT_SECRET" -ForegroundColor Yellow
Write-Host "Authorization Header: Basic $CREDENTIALS_BASE64" -ForegroundColor Yellow
Write-Host ""

Write-Host "Test 1: URL standard (v3)" -ForegroundColor Green
Write-Host "-------------------------" -ForegroundColor Green
$headers = @{
    "Content-Type" = "application/x-www-form-urlencoded"
    "Authorization" = "Basic $CREDENTIALS_BASE64"
}
$body = "grant_type=client_credentials"

try {
    $response = Invoke-WebRequest -Uri "https://api.orange.com/oauth/v3/token" `
        -Method POST `
        -Headers $headers `
        -Body $body `
        -UseBasicParsing
    Write-Host "✅ Succès!" -ForegroundColor Green
    Write-Host $response.Content
} catch {
    Write-Host "❌ Erreur: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "Status Code: $($_.Exception.Response.StatusCode.value__)" -ForegroundColor Yellow
    
    # Capturer le body d'erreur
    if ($_.Exception.Response) {
        $errorStream = $_.Exception.Response.GetResponseStream()
        $reader = New-Object System.IO.StreamReader($errorStream)
        $responseBody = $reader.ReadToEnd()
        $reader.Close()
        $errorStream.Close()
        
        Write-Host "Response Body:" -ForegroundColor Yellow
        Write-Host $responseBody -ForegroundColor White
        
        # Essayer de parser le JSON
        try {
            $json = $responseBody | ConvertFrom-Json
            Write-Host "Error Code: $($json.error)" -ForegroundColor Red
            Write-Host "Error Description: $($json.error_description)" -ForegroundColor Red
        } catch {
            Write-Host "Body brut: $responseBody" -ForegroundColor White
        }
    }
}

Write-Host ""
Write-Host "Test 2: URL standard (v3) avec scope" -ForegroundColor Green
Write-Host "------------------------------------" -ForegroundColor Green
$body2 = "grant_type=client_credentials&scope=SMS"

try {
    $response2 = Invoke-WebRequest -Uri "https://api.orange.com/oauth/v3/token" `
        -Method POST `
        -Headers $headers `
        -Body $body2 `
        -UseBasicParsing
    Write-Host "✅ Succès!" -ForegroundColor Green
    Write-Host $response2.Content
} catch {
    Write-Host "❌ Erreur: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "Status Code: $($_.Exception.Response.StatusCode.value__)" -ForegroundColor Yellow
    
    # Capturer le body d'erreur
    if ($_.Exception.Response) {
        $errorStream = $_.Exception.Response.GetResponseStream()
        $reader = New-Object System.IO.StreamReader($errorStream)
        $responseBody = $reader.ReadToEnd()
        $reader.Close()
        $errorStream.Close()
        
        Write-Host "Response Body:" -ForegroundColor Yellow
        Write-Host $responseBody -ForegroundColor White
        
        # Essayer de parser le JSON
        try {
            $json = $responseBody | ConvertFrom-Json
            Write-Host "Error Code: $($json.error)" -ForegroundColor Red
            Write-Host "Error Description: $($json.error_description)" -ForegroundColor Red
        } catch {
            Write-Host "Body brut: $responseBody" -ForegroundColor White
        }
    }
}

