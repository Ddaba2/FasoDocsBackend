# Test Orange SMS Authentication
# Simple script to test credentials

param(
    [string]$ClientId = "",
    [string]$ClientSecret = ""
)

Write-Host "Testing Orange SMS Authentication..." -ForegroundColor Cyan

# Read credentials from application.properties if not provided
if ([string]::IsNullOrEmpty($ClientId) -or [string]::IsNullOrEmpty($ClientSecret)) {
    $propertiesPath = Join-Path $PSScriptRoot "src\main\resources\application.properties"
    
    if (Test-Path $propertiesPath) {
        $properties = Get-Content $propertiesPath
        
        foreach ($line in $properties) {
            if ($line -match "^orange\.sms\.client\.id=(.+)$") {
                $ClientId = $Matches[1].Trim()
            }
            if ($line -match "^orange\.sms\.client\.secret=(.+)$") {
                $ClientSecret = $Matches[1].Trim()
            }
        }
    }
}

if ([string]::IsNullOrEmpty($ClientId) -or [string]::IsNullOrEmpty($ClientSecret)) {
    Write-Host "ERROR: Could not read credentials" -ForegroundColor Red
    exit 1
}

Write-Host "Client ID: $ClientId"
Write-Host ""

# Encode credentials in Base64
$pair = "${ClientId}:${ClientSecret}"
$bytes = [System.Text.Encoding]::UTF8.GetBytes($pair)
$base64 = [Convert]::ToBase64String($bytes)

Write-Host "Testing authentication with Orange API..." -ForegroundColor Yellow

# Test v3 with scope
$url = "https://api.orange.com/oauth/v3/token"
$headers = @{
    "Authorization" = "Basic $base64"
    "Content-Type" = "application/x-www-form-urlencoded"
    "Accept" = "application/json"
}
$body = "grant_type=client_credentials&scope=SMS"

try {
    Write-Host "Testing URL: $url" -ForegroundColor Gray
    $response = Invoke-RestMethod -Uri $url -Method POST -Headers $headers -Body $body -ContentType "application/x-www-form-urlencoded" -ErrorAction Stop
    
    Write-Host ""
    Write-Host "SUCCESS! Authentication works!" -ForegroundColor Green
    Write-Host "Access Token received (expires in $($response.expires_in) seconds)" -ForegroundColor Green
    Write-Host ""
    exit 0
} catch {
    $statusCode = $_.Exception.Response.StatusCode.value__
    Write-Host "FAILED - Status Code: $statusCode" -ForegroundColor Red
    
    try {
        $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
        $errorBody = $reader.ReadToEnd()
        $reader.Close()
        Write-Host "Error: $errorBody" -ForegroundColor Red
    } catch {
        Write-Host "Could not read error body" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "ACTIONS REQUIRED:" -ForegroundColor Yellow
Write-Host "1. Verify credentials at https://developer.orange.com/" -ForegroundColor White
Write-Host "2. Check that:" -ForegroundColor White
Write-Host "   - Application is active" -ForegroundColor White
Write-Host "   - SMS API is enabled" -ForegroundColor White
Write-Host "   - Application is configured for Mali" -ForegroundColor White
Write-Host "3. If needed, regenerate credentials and update application.properties" -ForegroundColor White
Write-Host ""

exit 1
