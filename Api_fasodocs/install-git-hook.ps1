# Script pour installer le hook Git pre-commit
# Ce hook exportera automatiquement la base de données avant chaque commit

Write-Host "🔧 Installation du hook Git pre-commit..." -ForegroundColor Cyan

$hookDir = ".git\hooks"
$hookFile = "$hookDir\pre-commit"

# Vérifier si .git existe
if (-not (Test-Path ".git")) {
    Write-Host "❌ Erreur: Ce répertoire n'est pas un dépôt Git!" -ForegroundColor Red
    exit 1
}

# Créer le répertoire hooks s'il n'existe pas
if (-not (Test-Path $hookDir)) {
    New-Item -ItemType Directory -Path $hookDir -Force | Out-Null
    Write-Host "✅ Répertoire .git\hooks créé" -ForegroundColor Green
}

# Copier le script pre-commit
if (Test-Path "pre-commit.ps1") {
    Copy-Item "pre-commit.ps1" $hookFile -Force
    Write-Host "✅ Hook pre-commit installé" -ForegroundColor Green
    Write-Host ""
    Write-Host "📝 Note: Pour que le hook fonctionne, vous devez:" -ForegroundColor Yellow
    Write-Host "   1. Renommer le fichier en 'pre-commit' (sans extension)" -ForegroundColor Yellow
    Write-Host "   2. Ou utiliser Git Bash qui exécute les scripts .sh" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "💡 Alternative: Utilisez 'export-database.bat' manuellement avant chaque commit" -ForegroundColor Cyan
} else {
    Write-Host "❌ Erreur: Fichier pre-commit.ps1 non trouvé!" -ForegroundColor Red
    exit 1
}

Write-Host "✅ Installation terminée!" -ForegroundColor Green



