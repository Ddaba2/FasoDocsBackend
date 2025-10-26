@echo off
REM ========================================
REM Script de démarrage FasoDocs Backend
REM Démarrera FasoDocs Backend ET Djelia AI
REM ========================================

echo.
echo ========================================
echo   Demarrage FasoDocs Backend
echo   avec Djelia AI Integration
echo ========================================
echo.

REM Vérifier si Python est installé
where python >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERREUR] Python n'est pas installe ou pas dans le PATH
    echo Installez Python depuis https://www.python.org/downloads/
    pause
    exit /b 1
)

REM Vérifier si le backend Djelia AI existe
if not exist "../Djelia-AI-Backend" (
    echo [ERREUR] Le dossier Djelia-AI-Backend n'existe pas
    echo Creez le dossier ../Djelia-AI-Backend ou ajustez le chemin
    pause
    exit /b 1
)

echo [1/3] Demarrage de Djelia AI Backend...
echo.

REM Démarrer Djelia AI en arrière-plan
start "Djelia AI Backend" /D "..\Djelia-AI-Backend" cmd /k "python app.py"

REM Attendre que Djelia AI soit prêt
echo [2/3] Attente du demarrage de Djelia AI...
timeout /t 5 /nobreak >nul

REM Vérifier si Djelia AI est accessible
echo.
echo [INFO] Verification de la connexion a Djelia AI...
curl -s http://localhost:5000/health >nul 2>&1
if %errorlevel% neq 0 (
    echo [WARNING] Djelia AI ne repond pas encore. Il demarrera en arriere-plan.
    echo Si Djelia AI n'est pas accessible apres 30 secondes, verifiez qu'il est bien demarre.
    echo.
) else (
    echo [OK] Djelia AI est accessible sur http://localhost:5000
    echo.
)

echo [3/3] Demarrage de FasoDocs Backend...
echo.
echo ========================================
echo   Backend FasoDocs demarrage...
echo ========================================
echo.

REM Démarrer le backend FasoDocs
call mvnw.cmd spring-boot:run

REM Si le script se termine, arrêter Djelia AI aussi
echo.
echo [INFO] Arret des services...
taskkill /FI "WindowTitle eq Djelia AI Backend*" /F >nul 2>&1

pause

