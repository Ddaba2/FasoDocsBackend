# Script PowerShell pour redémarrer le serveur Flask Djelia AI

Write-Host "🔄 Redémarrage du serveur Flask Djelia AI..." -ForegroundColor Yellow

# 1. Arrêter tous les processus Python qui pourraient être le serveur Flask
Write-Host "`n📋 Recherche des processus Python en cours..." -ForegroundColor Cyan
$pythonProcesses = Get-Process python -ErrorAction SilentlyContinue

if ($pythonProcesses) {
    Write-Host "   Trouvé $($pythonProcesses.Count) processus Python" -ForegroundColor Yellow
    
    # Vérifier si le port 5000 est utilisé
    $port5000 = netstat -ano | findstr :5000
    if ($port5000) {
        Write-Host "   ⚠️ Le port 5000 est utilisé" -ForegroundColor Yellow
        Write-Host "   Arrêt des processus Python..." -ForegroundColor Yellow
        
        foreach ($proc in $pythonProcesses) {
            try {
                Stop-Process -Id $proc.Id -Force -ErrorAction SilentlyContinue
                Write-Host "   ✅ Processus $($proc.Id) arrêté" -ForegroundColor Green
            } catch {
                Write-Host "   ⚠️ Impossible d'arrêter le processus $($proc.Id)" -ForegroundColor Red
            }
        }
        
        # Attendre un peu
        Start-Sleep -Seconds 2
    } else {
        Write-Host "   ℹ️ Aucun processus n'utilise le port 5000" -ForegroundColor Gray
    }
} else {
    Write-Host "   ℹ️ Aucun processus Python trouvé" -ForegroundColor Gray
}

# 2. Vérifier que le fichier backend_djelia.py existe
$flaskFile = "backend_djelia.py"
if (-not (Test-Path $flaskFile)) {
    Write-Host "`n❌ ERREUR: Le fichier $flaskFile n'existe pas dans le répertoire actuel!" -ForegroundColor Red
    Write-Host "   Répertoire actuel: $(Get-Location)" -ForegroundColor Yellow
    exit 1
}

Write-Host "`n✅ Fichier $flaskFile trouvé" -ForegroundColor Green

# 3. Démarrer le serveur Flask
Write-Host "`n🚀 Démarrage du serveur Flask..." -ForegroundColor Cyan
Write-Host "   Commande: python $flaskFile" -ForegroundColor Gray

# Démarrer en arrière-plan
$job = Start-Job -ScriptBlock {
    Set-Location $using:PWD
    python backend_djelia.py
}

Write-Host "`n✅ Serveur Flask démarré en arrière-plan (Job ID: $($job.Id))" -ForegroundColor Green
Write-Host "`n📋 Pour voir les logs du serveur Flask:" -ForegroundColor Cyan
Write-Host "   Receive-Job -Id $($job.Id) -Keep" -ForegroundColor Gray
Write-Host "`n📋 Pour arrêter le serveur Flask:" -ForegroundColor Cyan
Write-Host "   Stop-Job -Id $($job.Id)" -ForegroundColor Gray
Write-Host "   Remove-Job -Id $($job.Id)" -ForegroundColor Gray

Write-Host "`n⏳ Attente de 3 secondes pour vérifier que le serveur démarre..." -ForegroundColor Yellow
Start-Sleep -Seconds 3

# Vérifier si le port 5000 est maintenant utilisé
$port5000After = netstat -ano | findstr :5000
if ($port5000After) {
    Write-Host "✅ Le serveur Flask semble démarré (port 5000 utilisé)" -ForegroundColor Green
} else {
    Write-Host "⚠️ Le port 5000 n'est pas encore utilisé, le serveur peut être en cours de démarrage..." -ForegroundColor Yellow
    Write-Host "   Vérifiez les logs avec: Receive-Job -Id $($job.Id) -Keep" -ForegroundColor Gray
}

Write-Host "`n✅ Redémarrage terminé!" -ForegroundColor Green


