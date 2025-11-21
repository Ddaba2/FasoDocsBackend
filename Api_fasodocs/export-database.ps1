# ========================================
#   EXPORT COMPLET DE LA BASE DE DONNÉES
#   FasoDocs - Toutes les données
# ========================================

Write-Host ""
Write-Host "Export de la base de donnees FasoDocs..." -ForegroundColor Cyan
Write-Host ""

# Chercher mysqldump dans plusieurs emplacements
$mysqldumpPath = $null

# 1. Chercher dans le PATH
$mysqldumpInPath = Get-Command mysqldump -ErrorAction SilentlyContinue
if ($mysqldumpInPath) {
    $mysqldumpPath = $mysqldumpInPath.Source
    Write-Host "mysqldump trouve dans le PATH: $mysqldumpPath" -ForegroundColor Green
} else {
    # 2. Chercher dans les emplacements communs
    $commonPaths = @(
        "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysqldump.exe",
        "C:\Program Files\MySQL\MySQL Server 8.1\bin\mysqldump.exe",
        "C:\Program Files\MySQL\MySQL Server 8.2\bin\mysqldump.exe",
        "C:\Program Files\MySQL\MySQL Server 8.3\bin\mysqldump.exe",
        "C:\Program Files\MySQL\MySQL Server 8.4\bin\mysqldump.exe",
        "C:\xampp\mysql\bin\mysqldump.exe",
        "C:\wamp64\bin\mysql\mysql8.0.37\bin\mysqldump.exe",
        "C:\wamp\bin\mysql\mysql8.0.37\bin\mysqldump.exe"
    )
    
    foreach ($path in $commonPaths) {
        if (Test-Path $path) {
            $mysqldumpPath = $path
            Write-Host "mysqldump trouve: $mysqldumpPath" -ForegroundColor Green
            break
        }
    }
    
    # 3. Si toujours pas trouve, chercher recursivement dans Program Files
    if (-not $mysqldumpPath) {
        Write-Host "Recherche dans Program Files..." -ForegroundColor Yellow
        $found = Get-ChildItem -Path "C:\Program Files" -Recurse -Filter "mysqldump.exe" -ErrorAction SilentlyContinue | Select-Object -First 1
        if ($found) {
            $mysqldumpPath = $found.FullName
            Write-Host "mysqldump trouve: $mysqldumpPath" -ForegroundColor Green
        }
    }
    
    # 4. Si toujours pas trouvé, demander le chemin
    if (-not $mysqldumpPath) {
        Write-Host "mysqldump n'est pas trouve automatiquement" -ForegroundColor Red
        Write-Host ""
        Write-Host "Veuillez entrer le chemin complet vers mysqldump.exe" -ForegroundColor Yellow
        Write-Host "Exemples:" -ForegroundColor Yellow
        Write-Host "  C:\Program Files\MySQL\MySQL Server 8.0\bin\mysqldump.exe" -ForegroundColor Gray
        Write-Host "  C:\xampp\mysql\bin\mysqldump.exe" -ForegroundColor Gray
        Write-Host ""
        $mysqldumpPath = Read-Host "Chemin vers mysqldump.exe"
        
        if ([string]::IsNullOrWhiteSpace($mysqldumpPath)) {
            Write-Host "Export annule." -ForegroundColor Yellow
            exit 1
        }
        
        if (-not (Test-Path $mysqldumpPath)) {
            Write-Host "Fichier non trouve: $mysqldumpPath" -ForegroundColor Red
            exit 1
        }
    }
}

Write-Host ""

# Configuration
$dbName = "FasoDocs"
$dbUser = "root"
$dbPassword = ""
$dbHost = "localhost"

# Demander confirmation
Write-Host ""
$confirm = Read-Host "Voulez-vous exporter la base de donnees $dbName? (O/N)"
if ($confirm -notmatch "^[Oo]$") {
    Write-Host "Export annulé." -ForegroundColor Yellow
    exit 0
}

Write-Host ""
Write-Host "Export en cours..." -ForegroundColor Cyan
Write-Host ""

# Créer le répertoire de destination s'il n'existe pas
$outputDir = "src\main\resources"
if (-not (Test-Path $outputDir)) {
    New-Item -ItemType Directory -Path $outputDir -Force | Out-Null
}

$outputFile = "$outputDir\fasodocs-full-dump.sql"

# Exporter la base de données
try {
    if ([string]::IsNullOrWhiteSpace($dbPassword)) {
        & $mysqldumpPath -h $dbHost -u $dbUser `
            --single-transaction `
            --routines `
            --triggers `
            --events `
            --add-drop-table `
            --complete-insert `
            $dbName | Out-File -FilePath $outputFile -Encoding UTF8
    } else {
        & $mysqldumpPath -h $dbHost -u $dbUser -p$dbPassword `
            --single-transaction `
            --routines `
            --triggers `
            --events `
            --add-drop-table `
            --complete-insert `
            $dbName | Out-File -FilePath $outputFile -Encoding UTF8
    }
    
    if ($LASTEXITCODE -eq 0 -and (Test-Path $outputFile)) {
        $fileSize = (Get-Item $outputFile).Length
        $fileSizeMB = [math]::Round($fileSize / 1MB, 2)
        Write-Host ""
        Write-Host "Export reussi !" -ForegroundColor Green
        Write-Host ""
        Write-Host "Fichier cree: $outputFile" -ForegroundColor Cyan
        Write-Host "Taille: $fileSizeMB MB ($fileSize octets)" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "Vous pouvez maintenant commiter ce fichier dans Git" -ForegroundColor Green
        Write-Host "pour que les autres developpeurs aient toutes les donnees." -ForegroundColor Green
    } else {
        throw "Erreur lors de l export"
    }
} catch {
    Write-Host ""
    Write-Host "Erreur lors de l export: $_" -ForegroundColor Red
    Write-Host ""
    Write-Host "Essayez manuellement avec mot de passe:" -ForegroundColor Yellow
    Write-Host "   & `"$mysqldumpPath`" -u root -p $dbName > $outputFile" -ForegroundColor Gray
    Write-Host ""
    Write-Host "Ou utilisez MySQL Workbench pour exporter la base de données" -ForegroundColor Yellow
    exit 1
}

Write-Host ""

