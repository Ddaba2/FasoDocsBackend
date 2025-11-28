# Script de vérification des credentials actuels de application.properties
$clientId = "eeQIIfQYVsDYRDHvG5ziEHMpJ18bHlcG"
$clientSecret = "EJn9NPCK51YtFfq3AE5pKiWGdVmYdVdYLTb68cCtfaXt"
$authHeader = "Basic " + [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes("${clientId}:${clientSecret}"))

Write-Host "Testing credentials from application.properties..."
Write-Host "Client ID: $clientId"
Write-Host "Client Secret: $clientSecret"
Write-Host "Auth Header: $authHeader"

try {
    $response = Invoke-RestMethod -Uri "https://api.orange.com/oauth/v3/token" -Method Post -Headers @{ "Authorization" = $authHeader; "Content-Type" = "application/x-www-form-urlencoded" } -Body "grant_type=client_credentials"
    Write-Host "SUCCESS! Access Token received." -ForegroundColor Green
    Write-Host $response
} catch {
    Write-Host "FAILED with 401 Unauthorized." -ForegroundColor Red
    Write-Host $_.Exception.Message
    if ($_.Exception.Response) {
        $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
        $body = $reader.ReadToEnd()
        Write-Host "Error Body: $body"
    }
}
