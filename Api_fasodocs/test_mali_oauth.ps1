# Test Orange SMS Mali - Endpoints specifiques
# Ce script teste differents endpoints OAuth pour l'API SMS Mali

param(
    [string]$ClientId = "",
    [string]$ClientSecret = ""
)

Write-Host "Testing Orange SMS Mali Authentication Endpoints..." -ForegroundColor Cyan
Write-Host ""

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

# Test multiple Mali-specific configurations
$urlsToTest = @(
    # Standard international endpoints
    @{Url = "https://api.orange.com/oauth/v3/token"; Scope = ""; Name = "International v3 (no scope)"},
    @{Url = "https://api.orange.com/oauth/v3/token"; Scope = "SMS"; Name = "International v3 (scope=SMS)"},
    
    # Try with Mali country code
    @{Url = "https://api.orange.com/oauth/v3/token"; Scope = "sms mali"; Name = "v3 (scope=sms mali)"},
    @{Url = "https://api.orange.com/oauth/v3/token"; Scope = "SMS_MALI"; Name = "v3 (scope=SMS_MALI)"},
    
    # Try v2 (might be for Enterprise APIs)
    @{Url = "https://api.orange.com/oauth/v2/token"; Scope = ""; Name = "v2 (no scope)"},
    @{Url = "https://api.orange.com/oauth/v2/token"; Scope = "SMS"; Name = "v2 (scope=SMS)"},
    
    # Try Mali-specific base URLs (if they exist)
    @{Url = "https://api.orange.com/mali/oauth/v3/token"; Scope = ""; Name = "Mali endpoint v3 (no scope)"},
    @{Url = "https://api.orange.com/mali/oauth/v3/token"; Scope = "SMS"; Name = "Mali endpoint v3 (scope=SMS)"},
    
    # Try Enterprise-specific
    @{Url = "https://api.orange.com/oauth/v3/token"; Scope = "enterprise"; Name = "v3 (scope=enterprise)"},
    @{Url = "https://api.orange.com/oauth/v3/token"; Scope = "SMS_ENTERPRISE"; Name = "v3 (scope=SMS_ENTERPRISE)"}
)

$successfulConfig = $null
$attemptNumber = 0

foreach ($config in $urlsToTest) {
    $attemptNumber++
    Write-Host "[$attemptNumber/$($urlsToTest.Count)] Testing: $($config.Name)" -ForegroundColor Yellow
    Write-Host "    URL: $($config.Url)" -ForegroundColor Gray
    if ($config.Scope) {
        Write-Host "    Scope: $($config.Scope)" -ForegroundColor Gray
    }
    
    $headers = @{
        "Authorization" = "Basic $base64"
        "Content-Type" = "application/x-www-form-urlencoded"
        "Accept" = "application/json"
    }
    
    if ($config.Scope) {
        $body = "grant_type=client_credentials&scope=$($config.Scope)"
    } else {
        $body = "grant_type=client_credentials"
    }
    
    try {
        $response = Invoke-RestMethod -Uri $config.Url `
            -Method POST `
            -Headers $headers `
            -Body $body `
            -ContentType "application/x-www-form-urlencoded" `
            -ErrorAction Stop
        
        Write-Host ""
        Write-Host "    SUCCESS! This configuration works!" -ForegroundColor Green
        Write-Host "    Access Token received (expires in $($response.expires_in) seconds)" -ForegroundColor Green
        Write-Host ""
        
        $successfulConfig = $config
        break
    } catch {
        $statusCode = $_.Exception.Response.StatusCode.value__
        Write-Host "    FAILED - Status Code: $statusCode" -ForegroundColor Red
        
        try {
            $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
            $errorBody = $reader.ReadToEnd()
            $reader.Close()
            
            # Only show first 100 chars of error
            if ($errorBody.Length -gt 100) {
                Write-Host "    Error: $($errorBody.Substring(0, 100))..." -ForegroundColor DarkRed
            } else {
                Write-Host "    Error: $errorBody" -ForegroundColor DarkRed
            }
        } catch {
            # Ignore error reading body
        }
    }
    
    Write-Host ""
}

Write-Host "========================================" -ForegroundColor Cyan

if ($null -eq $successfulConfig) {
    Write-Host ""
    Write-Host "ALL CONFIGURATIONS FAILED" -ForegroundColor Red
    Write-Host ""
    Write-Host "RECOMMENDATION:" -ForegroundColor Yellow
    Write-Host "1. Check the Orange Developer Portal for API-specific documentation" -ForegroundColor White
    Write-Host "2. Look for 'SMS Mali - Entreprise' v3.0 documentation" -ForegroundColor White
    Write-Host "3. Contact Orange Mali support with your Client ID" -ForegroundColor White
    Write-Host ""
    
    exit 1
} else {
    Write-Host ""
    Write-Host "SUCCESS - Working configuration found!" -ForegroundColor Green
    Write-Host ""
    Write-Host "UPDATE YOUR CODE WITH:" -ForegroundColor Yellow
    Write-Host "  OAuth URL: $($successfulConfig.Url)" -ForegroundColor White
    if ($successfulConfig.Scope) {
        Write-Host "  Scope: $($successfulConfig.Scope)" -ForegroundColor White
    } else {
        Write-Host "  Scope: (none)" -ForegroundColor White
    }
    Write-Host ""
    
    exit 0
}
