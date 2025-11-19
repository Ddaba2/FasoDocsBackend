# Script pour verifier et calculer le Client Secret Orange
# Usage: .\verifier_client_secret.ps1

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Verification Client Secret Orange" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Configuration actuelle depuis application.properties
$clientId = "eeQIIfQYVsDYRDHvG5ziEHMpJ18bHlcG"
$clientSecretActuel = "jwySPv3Waaljeuj0xFHvPMdFGm482v3FwtNSVtf133Bd"

Write-Host "1. Configuration Actuelle" -ForegroundColor Green
Write-Host "   Client ID: $clientId" -ForegroundColor Gray
Write-Host "   Client Secret: $clientSecretActuel" -ForegroundColor Gray
Write-Host ""

# Calculer l'authorization header actuel
$credentials = "$clientId`:$clientSecretActuel"
$bytes = [System.Text.Encoding]::UTF8.GetBytes($credentials)
$encoded = [Convert]::ToBase64String($bytes)

Write-Host "2. Authorization Header Actuel" -ForegroundColor Green
Write-Host "   Calcule: $encoded" -ForegroundColor Cyan
Write-Host "   Dans application.properties: ZWVRSUlmUVlWc0RZUkRIdkc1emlFSE1wSjE4YkhsY0c6and5U1B2M1dhYWxqZXVqMHhGSHZQTWRGR200ODJ2M0Z3dE5TVnRmMTMzQmQ=" -ForegroundColor Gray
Write-Host ""

# Verifier si les deux correspondent
$headerAttendu = "ZWVRSUlmUVlWc0RZUkRIdkc1emlFSE1wSjE4YkhsY0c6and5U1B2M1dhYWxqZXVqMHhGSHZQTWRGR200ODJ2M0Z3dE5TVnRmMTMzQmQ="
if ($encoded -eq $headerAttendu) {
    Write-Host "   OK: Les headers correspondent" -ForegroundColor Green
} else {
    Write-Host "   ERREUR: Les headers ne correspondent PAS" -ForegroundColor Red
    Write-Host "   Le authorization.header dans application.properties doit etre mis a jour" -ForegroundColor Yellow
}
Write-Host ""

Write-Host "3. Instructions" -ForegroundColor Green
Write-Host ""
Write-Host "   Pour verifier le Client Secret dans le portail Orange:" -ForegroundColor Yellow
Write-Host "   1. Allez sur https://developer.orange.com/" -ForegroundColor White
Write-Host "   2. Connectez-vous avec votre compte" -ForegroundColor White
Write-Host "   3. Allez dans 'My Apps' -> Application SMS (ID: iy3KWH9GiNK0evSY)" -ForegroundColor White
Write-Host "   4. Trouvez le 'Client Secret' et comparez avec celui ci-dessus" -ForegroundColor White
Write-Host ""
Write-Host "   Si le Client Secret est different:" -ForegroundColor Yellow
Write-Host "   1. Copiez le nouveau Client Secret depuis le portail" -ForegroundColor White
Write-Host "   2. Mettez a jour application.properties:" -ForegroundColor White
Write-Host "      orange.sms.client.secret=NOUVEAU_SECRET" -ForegroundColor Cyan
Write-Host "   3. Recalculez le authorization.header (voir section 4 ci-dessous)" -ForegroundColor White
Write-Host "   4. Mettez a jour application.properties:" -ForegroundColor White
Write-Host "      orange.sms.authorization.header=NOUVEAU_HEADER" -ForegroundColor Cyan
Write-Host "   5. Redemarrez le serveur" -ForegroundColor White
Write-Host ""

Write-Host "4. Calculer un Nouveau Header" -ForegroundColor Green
Write-Host ""
Write-Host "   Methode 1: Modifier ce script" -ForegroundColor Yellow
Write-Host "   - Ouvrez ce fichier (verifier_client_secret.ps1)" -ForegroundColor White
Write-Host "   - Modifiez la ligne 11 avec votre nouveau Client Secret" -ForegroundColor White
Write-Host "   - Relancez ce script" -ForegroundColor White
Write-Host ""
Write-Host "   Methode 2: Utiliser PowerShell directement" -ForegroundColor Yellow
Write-Host "   Copiez-collez ces commandes dans PowerShell:" -ForegroundColor White
Write-Host ""
Write-Host '   $clientId = "eeQIIfQYVsDYRDHvG5ziEHMpJ18bHlcG"' -ForegroundColor Cyan
Write-Host '   $clientSecret = "VOTRE_NOUVEAU_SECRET_ICI"' -ForegroundColor Cyan
Write-Host '   $credentials = "$clientId`:$clientSecret"' -ForegroundColor Cyan
Write-Host '   $bytes = [System.Text.Encoding]::UTF8.GetBytes($credentials)' -ForegroundColor Cyan
Write-Host '   [Convert]::ToBase64String($bytes)' -ForegroundColor Cyan
Write-Host ""
Write-Host "   Le resultat affiche sera votre nouveau authorization.header" -ForegroundColor Yellow
Write-Host ""
