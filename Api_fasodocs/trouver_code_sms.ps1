# ========================================
# Script pour trouver le code SMS dans les logs
# ========================================

Write-Host ""
Write-Host "========================================"
Write-Host "  Recherche du Code SMS dans les Logs"
Write-Host "========================================"
Write-Host ""

# Chercher dans les logs récents
$logFiles = Get-ChildItem -Path "." -Filter "*.log" -Recurse -ErrorAction SilentlyContinue | 
    Sort-Object LastWriteTime -Descending | 
    Select-Object -First 10

if ($logFiles.Count -eq 0) {
    Write-Host "⚠️  Aucun fichier .log trouvé dans le répertoire actuel"
    Write-Host ""
    Write-Host "📋 Le code SMS devrait apparaître dans :"
    Write-Host "   1. La console IntelliJ (logs du serveur)"
    Write-Host "   2. Les fichiers de logs Spring Boot (si configurés)"
    Write-Host ""
    Write-Host "🔍 Cherchez le message suivant dans vos logs :"
    Write-Host "   'MODE FALLBACK ACTIVÉ - CODE SMS DISPONIBLE DANS LES LOGS'"
    Write-Host ""
    Write-Host "📞 Le code SMS sera affiché juste après ce message"
    Write-Host ""
} else {
    Write-Host "📁 Fichiers de logs trouvés :"
    foreach ($file in $logFiles) {
        Write-Host "   - $($file.FullName) (Modifié: $($file.LastWriteTime))"
    }
    Write-Host ""
    
    # Chercher le code SMS dans les fichiers de logs
    Write-Host "🔍 Recherche du code SMS dans les logs..."
    Write-Host ""
    
    $found = $false
    foreach ($file in $logFiles) {
        $content = Get-Content -Path $file.FullName -ErrorAction SilentlyContinue | 
            Select-String -Pattern "MODE FALLBACK|Code SMS|🔑" -Context 0,5
        
        if ($content) {
            $found = $true
            Write-Host "✅ Code SMS trouvé dans : $($file.Name)"
            Write-Host ""
            Write-Host "═══════════════════════════════════════════════════════════"
            $content | ForEach-Object {
                Write-Host $_.Line
            }
            Write-Host "═══════════════════════════════════════════════════════════"
            Write-Host ""
        }
    }
    
    if (-not $found) {
        Write-Host "⚠️  Code SMS non trouvé dans les fichiers de logs"
        Write-Host ""
        Write-Host "📋 Le code SMS devrait apparaître dans :"
        Write-Host "   1. La console IntelliJ (logs du serveur en temps réel)"
        Write-Host "   2. Cherchez le message 'MODE FALLBACK ACTIVÉ'"
        Write-Host ""
    }
}

Write-Host "========================================"
Write-Host "  Instructions pour trouver le code SMS"
Write-Host "========================================"
Write-Host ""
Write-Host "1. Ouvrez la console IntelliJ où le serveur Spring Boot tourne"
Write-Host "2. Faites une tentative de connexion depuis Flutter"
Write-Host "3. Regardez les logs du serveur immédiatement après"
Write-Host "4. Cherchez le message :"
Write-Host "   '═══════════════════════════════════════════════════════════'"
Write-Host "   '📱 MODE FALLBACK ACTIVÉ - CODE SMS DISPONIBLE DANS LES LOGS'"
Write-Host "   '═══════════════════════════════════════════════════════════'"
Write-Host "   '📞 Téléphone : +22383784097'"
Write-Host "   '🔑 Code SMS  : XXXX'  ← VOICI LE CODE"
Write-Host "   '⏰ Expiration: ...'"
Write-Host ""
Write-Host "5. Utilisez ce code pour vous connecter"
Write-Host ""
Write-Host "💡 Astuce : Le code apparaît juste après l'erreur d'authentification Orange"
Write-Host ""

