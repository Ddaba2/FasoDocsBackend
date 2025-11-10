# Script PowerShell pour configurer le Firewall Windows
# Autorise les connexions entrantes sur le port 8080 pour FasoDocs API

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "Configuration du Firewall Windows" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

# Vérifier si le script est exécuté en tant qu'administrateur
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "ERREUR: Ce script doit etre execute en tant qu'Administrateur!" -ForegroundColor Red
    Write-Host "`nPour executer en tant qu'Administrateur:" -ForegroundColor Yellow
    Write-Host "1. Clic droit sur 'Demarrer' > 'Windows PowerShell (Admin)'" -ForegroundColor White
    Write-Host "2. Naviguez vers ce dossier: cd '$PSScriptRoot'" -ForegroundColor White
    Write-Host "3. Executez: .\configurer_firewall.ps1" -ForegroundColor White
    Write-Host "`nAppuyez sur une touche pour quitter..." -ForegroundColor Gray
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit 1
}

Write-Host "Verification en cours..." -ForegroundColor Yellow

# Nom de la règle
$ruleName = "FasoDocs API - Port 8080"

# Vérifier si la règle existe déjà
$existingRule = Get-NetFirewallRule -DisplayName $ruleName -ErrorAction SilentlyContinue

if ($existingRule) {
    Write-Host "`nLa regle de firewall existe deja!" -ForegroundColor Green
    Write-Host "Nom: $ruleName" -ForegroundColor White
    Write-Host "Statut: Activee" -ForegroundColor Green
} else {
    Write-Host "`nCreation de la regle de firewall..." -ForegroundColor Yellow
    
    try {
        # Créer la règle de firewall
        New-NetFirewallRule `
            -DisplayName $ruleName `
            -Description "Autorise les connexions entrantes pour l'API FasoDocs sur le port 8080" `
            -Direction Inbound `
            -Protocol TCP `
            -LocalPort 8080 `
            -Action Allow `
            -Profile Domain,Private,Public `
            -Enabled True | Out-Null
        
        Write-Host "`nSUCCES! Regle de firewall creee avec succes!" -ForegroundColor Green
        Write-Host "Nom: $ruleName" -ForegroundColor White
        Write-Host "Port: 8080 (TCP)" -ForegroundColor White
        Write-Host "Direction: Entrant" -ForegroundColor White
        Write-Host "Action: Autoriser" -ForegroundColor White
        Write-Host "Profils: Domaine, Prive, Public" -ForegroundColor White
    }
    catch {
        Write-Host "`nERREUR lors de la creation de la regle!" -ForegroundColor Red
        Write-Host "Details: $_" -ForegroundColor Red
        Write-Host "`nAppuyez sur une touche pour quitter..." -ForegroundColor Gray
        $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        exit 1
    }
}

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "Configuration terminee!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "`nVotre serveur FasoDocs API peut maintenant recevoir" -ForegroundColor White
Write-Host "des connexions sur le port 8080 depuis votre reseau local." -ForegroundColor White
Write-Host "`nAppuyez sur une touche pour fermer..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

