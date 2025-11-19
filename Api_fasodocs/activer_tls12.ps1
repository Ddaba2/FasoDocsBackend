# Script PowerShell pour activer TLS 1.2/1.3 dans Windows
# DOIT ETRE EXECUTE EN TANT QU'ADMINISTRATEUR

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Activation TLS 1.2/1.3 dans Windows" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Verifier les privileges administrateur
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "ERREUR : Ce script doit etre execute en tant qu'administrateur!" -ForegroundColor Red
    Write-Host "   Clic droit sur PowerShell puis Executer en tant qu'administrateur" -ForegroundColor Yellow
    exit 1
}

Write-Host "Privileges administrateur confirmes" -ForegroundColor Green
Write-Host ""

# Activer TLS 1.2 Client
Write-Host "Activation TLS 1.2 Client..." -ForegroundColor Yellow
try {
    New-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Client" -Force | Out-Null
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Client" -Name Enabled -Type DWord -Value 1 -ErrorAction Stop
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Client" -Name DisabledByDefault -Type DWord -Value 0 -ErrorAction Stop
    Write-Host "   TLS 1.2 Client active" -ForegroundColor Green
} catch {
    Write-Host "   Erreur lors de l'activation TLS 1.2 Client: $_" -ForegroundColor Yellow
}

# Activer TLS 1.2 Server
Write-Host "Activation TLS 1.2 Server..." -ForegroundColor Yellow
try {
    New-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Server" -Force | Out-Null
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Server" -Name Enabled -Type DWord -Value 1 -ErrorAction Stop
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Server" -Name DisabledByDefault -Type DWord -Value 0 -ErrorAction Stop
    Write-Host "   TLS 1.2 Server active" -ForegroundColor Green
} catch {
    Write-Host "   Erreur lors de l'activation TLS 1.2 Server: $_" -ForegroundColor Yellow
}

# Activer TLS 1.3 Client (Windows 11 uniquement)
$osVersion = [System.Environment]::OSVersion.Version
if ($osVersion.Major -ge 10 -and $osVersion.Build -ge 22000) {
    Write-Host "Activation TLS 1.3 Client (Windows 11)..." -ForegroundColor Yellow
    try {
        New-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.3\Client" -Force | Out-Null
        Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.3\Client" -Name Enabled -Type DWord -Value 1 -ErrorAction Stop
        Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.3\Client" -Name DisabledByDefault -Type DWord -Value 0 -ErrorAction Stop
        Write-Host "   TLS 1.3 Client active" -ForegroundColor Green
    } catch {
        Write-Host "   Erreur lors de l'activation TLS 1.3 Client: $_" -ForegroundColor Yellow
    }
} else {
    Write-Host "TLS 1.3 non disponible sur cette version de Windows" -ForegroundColor Gray
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Configuration terminee!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "IMPORTANT : Redemarrez Windows pour que les changements prennent effet!" -ForegroundColor Yellow
Write-Host ""
Write-Host "Apres le redemarrage :" -ForegroundColor Cyan
Write-Host "1. Redemarrez le serveur Flask : python backend_djelia.py" -ForegroundColor White
Write-Host "2. Testez depuis le frontend" -ForegroundColor White
Write-Host ""

# Verifier la configuration
Write-Host "Verification de la configuration..." -ForegroundColor Cyan
$tls12Client = Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Client" -ErrorAction SilentlyContinue

if ($tls12Client) {
    $enabled = $tls12Client.Enabled
    $disabledByDefault = $tls12Client.DisabledByDefault
    $color = if ($enabled -eq 1 -and $disabledByDefault -eq 0) { "Green" } else { "Yellow" }
    Write-Host "   TLS 1.2 Client - Enabled: $enabled, DisabledByDefault: $disabledByDefault" -ForegroundColor $color
} else {
    Write-Host "   TLS 1.2 Client non configure" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Appuyez sur une touche pour quitter..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
