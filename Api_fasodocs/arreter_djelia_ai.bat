@echo off
REM ============================================
REM Script pour arrêter le serveur Flask Djelia AI
REM ============================================

echo ========================================
echo 🛑 Arrêt du serveur Flask Djelia AI
echo ========================================
echo.

REM Vérifier si des processus Python utilisent le port 5000
netstat -ano | findstr :5000 >nul 2>&1
if errorlevel 1 (
    echo ℹ️  Aucun processus n'utilise le port 5000
    echo    Le serveur Flask n'est probablement pas démarré
    pause
    exit /b 0
)

echo 🔍 Recherche des processus Python...
echo.

REM Trouver les processus Python qui utilisent le port 5000
for /f "tokens=5" %%a in ('netstat -ano ^| findstr :5000') do (
    echo ⚠️  Processus trouvé avec PID: %%a
    echo    Arrêt du processus...
    taskkill /F /PID %%a >nul 2>&1
    if errorlevel 1 (
        echo    ❌ Impossible d'arrêter le processus %%a
    ) else (
        echo    ✅ Processus %%a arrêté
    )
)

echo.
echo ✅ Arrêt terminé
echo.

REM Vérifier si le port 5000 est maintenant libre
timeout /t 2 /nobreak >nul
netstat -ano | findstr :5000 >nul 2>&1
if errorlevel 1 (
    echo ✅ Le port 5000 est maintenant libre
) else (
    echo ⚠️  Le port 5000 est toujours utilisé
    echo    Essayez de redémarrer votre ordinateur si le problème persiste
)

echo.
pause


