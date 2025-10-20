@echo off
echo ========================================
echo    CHARGEMENT DES DONNEES FASODOCS
echo ========================================
echo.

REM Vérifier si MySQL est installé
where mysql >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo ❌ MySQL n'est pas trouvé dans le PATH
    echo Veuillez installer MySQL ou ajouter MySQL au PATH
    echo.
    echo Alternatives:
    echo 1. Utilisez un client MySQL (Workbench, phpMyAdmin)
    echo 2. Lancez l'application Spring Boot (chargement automatique)
    pause
    exit /b 1
)

echo ✅ MySQL trouvé
echo.

REM Demander les informations de connexion
set /p DB_HOST="Host MySQL (localhost): "
if "%DB_HOST%"=="" set DB_HOST=localhost

set /p DB_USER="Utilisateur MySQL (root): "
if "%DB_USER%"=="" set DB_USER=root

set /p DB_NAME="Nom de la base (FasoDocs): "
if "%DB_NAME%"=="" set DB_NAME=FasoDocs

echo.
echo 📊 Chargement des données...
echo.

REM Exécuter le script SQL
mysql -h %DB_HOST% -u %DB_USER% -p %DB_NAME% < src\main\resources\fasodocs-data-complete.sql

if %ERRORLEVEL% EQU 0 (
    echo.
    echo 🎉 Données chargées avec succès !
    echo.
    echo Vous pouvez maintenant lancer l'application Spring Boot
) else (
    echo.
    echo ❌ Erreur lors du chargement des données
    echo Vérifiez vos informations de connexion
)

echo.
pause
