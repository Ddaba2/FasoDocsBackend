@echo off
REM ============================================
REM Script pour lancer le serveur Flask Djelia AI
REM ============================================

echo ========================================
echo 🚀 Lancement du serveur Flask Djelia AI
echo ========================================
echo.

REM Vérifier si Python est installé
python --version >nul 2>&1
if errorlevel 1 (
    echo ❌ ERREUR: Python n'est pas installé ou pas dans le PATH
    echo    Installez Python depuis https://www.python.org/
    pause
    exit /b 1
)

echo ✅ Python détecté
python --version
echo.

REM Vérifier si le fichier backend_djelia.py existe
if not exist "backend_djelia.py" (
    echo ❌ ERREUR: Le fichier backend_djelia.py n'existe pas dans ce répertoire
    echo    Répertoire actuel: %CD%
    pause
    exit /b 1
)

echo ✅ Fichier backend_djelia.py trouvé
echo.

REM Vérifier si le port 5000 est utilisé
netstat -ano | findstr :5000 >nul 2>&1
if not errorlevel 1 (
    echo ⚠️  Le port 5000 est déjà utilisé
    echo    Arrêt des processus Python existants...
    taskkill /F /IM python.exe >nul 2>&1
    timeout /t 2 /nobreak >nul
    echo    ✅ Processus Python arrêtés
    echo.
)

REM Vérifier les dépendances Python
echo 🔍 Vérification des dépendances Python...
python -c "import flask" >nul 2>&1
if errorlevel 1 (
    echo ⚠️  Flask n'est pas installé
    echo    Installation de Flask...
    pip install flask flask-cors
    echo.
)

python -c "import djelia" >nul 2>&1
if errorlevel 1 (
    echo ⚠️  Djelia n'est pas installé
    echo    Installation de Djelia...
    pip install djelia
    echo.
)

python -c "import requests" >nul 2>&1
if errorlevel 1 (
    echo ⚠️  Requests n'est pas installé
    echo    Installation de Requests...
    pip install requests urllib3 certifi
    echo.
)

echo ✅ Dépendances vérifiées
echo.

REM Afficher le répertoire de travail
echo 📁 Répertoire de travail: %CD%
echo.

REM Lancer le serveur Flask
echo ========================================
echo 🚀 Démarrage du serveur Flask Djelia AI
echo ========================================
echo.
echo Le serveur va démarrer sur http://localhost:5000
echo Appuyez sur Ctrl+C pour arrêter le serveur
echo.
echo ========================================
echo.

python backend_djelia.py

REM Si le serveur s'arrête, afficher un message
echo.
echo ========================================
echo ⚠️  Le serveur Flask s'est arrêté
echo ========================================
pause


