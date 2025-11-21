# Test direct avec HttpWebRequest pour capturer la réponse complète
# Cela nous permettra de voir exactement ce qu'Orange répond

$clientId = "eeQIIfQYVsDYRDHvG5ziEHMpJ18bHlcG"
$clientSecret = "MKAh6Y2TWs3kBdeUlVtVfmnAzckniO2GvJwzgwYSMdt1"

$credentials = "$clientId`:$clientSecret"
$bytes = [System.Text.Encoding]::UTF8.GetBytes($credentials)
$encoded = [Convert]::ToBase64String($bytes)
$authHeader = "Basic $encoded"

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "TEST DIRECT HTTP - CAPTURE RÉPONSE COMPLÈTE" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$url = "https://api.orange.com/oauth/v3/token"
$body = "grant_type=client_credentials&scope=SMS"

try {
    $request = [System.Net.HttpWebRequest]::Create($url)
    $request.Method = "POST"
    $request.ContentType = "application/x-www-form-urlencoded"
    $request.Headers.Add("Authorization", $authHeader)
    
    $bodyBytes = [System.Text.Encoding]::UTF8.GetBytes($body)
    $request.ContentLength = $bodyBytes.Length
    
    $requestStream = $request.GetRequestStream()
    $requestStream.Write($bodyBytes, 0, $bodyBytes.Length)
    $requestStream.Close()
    
    Write-Host "Envoi de la requête..." -ForegroundColor Cyan
    Write-Host "   URL: $url" -ForegroundColor Gray
    Write-Host "   Authorization: Basic $encoded" -ForegroundColor Gray
    Write-Host "   Body: $body" -ForegroundColor Gray
    Write-Host ""
    
    try {
        $response = $request.GetResponse()
        $responseStream = $response.GetResponseStream()
        $reader = New-Object System.IO.StreamReader($responseStream)
        $responseBody = $reader.ReadToEnd()
        
        Write-Host "✅✅✅ SUCCÈS ! ✅✅✅" -ForegroundColor Green
        Write-Host "Status: $($response.StatusCode)" -ForegroundColor Cyan
        Write-Host "Response: $responseBody" -ForegroundColor Cyan
        Write-Host ""
        
    } catch [System.Net.WebException] {
        $errorResponse = $_.Exception.Response
        $statusCode = [int]$errorResponse.StatusCode
        
        Write-Host "❌ Erreur $statusCode" -ForegroundColor Red
        Write-Host ""
        
        # Lire le body d'erreur
        $errorStream = $errorResponse.GetResponseStream()
        $errorReader = New-Object System.IO.StreamReader($errorStream)
        $errorBody = $errorReader.ReadToEnd()
        
        Write-Host "RÉPONSE D'ORANGE (body d'erreur):" -ForegroundColor Yellow
        Write-Host "$errorBody" -ForegroundColor White
        Write-Host ""
        
        Write-Host "Headers de réponse:" -ForegroundColor Yellow
        foreach ($headerKey in $errorResponse.Headers.AllKeys) {
            Write-Host "   $headerKey : $($errorResponse.Headers[$headerKey])" -ForegroundColor Gray
        }
        Write-Host ""
        
        if ($errorBody -match '"message"') {
            Write-Host "⚠️  MESSAGE D'ERREUR D'ORANGE DÉTECTÉ" -ForegroundColor Yellow
            Write-Host "   Analysez ce message pour comprendre le problème" -ForegroundColor White
        }
    }
    
} catch {
    Write-Host "❌ Erreur lors de la requête: $_" -ForegroundColor Red
}

Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""









