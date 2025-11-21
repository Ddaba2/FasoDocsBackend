# Git hook PowerShell pour exporter automatiquement la base de données avant chaque commit
# À installer dans .git/hooks/pre-commit (renommer en pre-commit sans extension)

Write-Host "📦 Vérification de l'export de la base de données..." -ForegroundColor Cyan

# Vérifier si mysqldump est disponible
$mysqldumpPath = Get-Command mysqldump -ErrorAction SilentlyContinue
if (-not $mysqldumpPath) {
    Write-Host "⚠️  mysqldump non trouvé. Export automatique ignoré." -ForegroundColor Yellow
    exit 0
}

$dumpFile = "src\main\resources\fasodocs-full-dump.sql"

# Vérifier si le fichier existe et est récent (moins de 1 heure)
if (Test-Path $dumpFile) {
    $fileAge = (Get-Item $dumpFile).LastWriteTime
    $currentTime = Get-Date
    $ageDiff = ($currentTime - $fileAge).TotalHours
    
    if ($ageDiff -lt 1) {
        Write-Host "✅ Dump récent trouvé (moins de 1h). Export ignoré." -ForegroundColor Green
        exit 0
    }
}

# Demander confirmation
Write-Host ""
$confirm = Read-Host "Voulez-vous exporter la base de données avant le commit? (O/N)"
if ($confirm -notmatch "^[Oo]$") {
    Write-Host "Export ignoré. Commit continué." -ForegroundColor Yellow
    exit 0
}

# Exporter la base de données
$dbName = "FasoDocs"
$dbUser = "root"
$dbHost = "localhost"

Write-Host "📊 Export en cours..." -ForegroundColor Cyan

# Créer le répertoire s'il n'existe pas
$dumpDir = Split-Path $dumpFile -Parent
if (-not (Test-Path $dumpDir)) {
    New-Item -ItemType Directory -Path $dumpDir -Force | Out-Null
}

# Exporter
mysqldump -h $dbHost -u $dbUser `
    --single-transaction `
    --routines `
    --triggers `
    --events `
    --add-drop-table `
    --complete-insert `
    $dbName | Out-File -FilePath $dumpFile -Encoding UTF8

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Export réussi ! Ajout du fichier au commit..." -ForegroundColor Green
    git add $dumpFile
} else {
    Write-Host "⚠️  Erreur lors de l'export. Commit continué sans dump." -ForegroundColor Yellow
}

exit 0



