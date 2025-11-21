@echo off
REM ========================================
REM   EXPORT COMPLET DE LA BASE DE DONNÉES
REM   FasoDocs - Toutes les données
REM ========================================
echo.
echo 📦 Export de la base de données FasoDocs...
echo.

REM Chercher mysqldump dans plusieurs emplacements
set MYSQLDUMP_PATH=
where mysqldump >nul 2>nul
if %ERRORLEVEL% EQU 0 (
    set MYSQLDUMP_PATH=mysqldump
    goto :found_mysqldump
)

REM Chercher dans les emplacements communs
for %%P in (
    "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysqldump.exe"
    "C:\Program Files\MySQL\MySQL Server 8.1\bin\mysqldump.exe"
    "C:\Program Files\MySQL\MySQL Server 8.2\bin\mysqldump.exe"
    "C:\Program Files\MySQL\MySQL Server 8.3\bin\mysqldump.exe"
    "C:\Program Files\MySQL\MySQL Server 8.4\bin\mysqldump.exe"
    "C:\xampp\mysql\bin\mysqldump.exe"
    "C:\wamp64\bin\mysql\mysql8.0.xx\bin\mysqldump.exe"
    "C:\wamp\bin\mysql\mysql8.0.xx\bin\mysqldump.exe"
) do (
    if exist %%P (
        set MYSQLDUMP_PATH=%%P
        goto :found_mysqldump
    )
)

REM Si toujours pas trouvé, demander le chemin
echo ❌ mysqldump n'est pas trouvé automatiquement
echo.
echo Veuillez entrer le chemin complet vers mysqldump.exe
echo Exemples:
echo   C:\Program Files\MySQL\MySQL Server 8.0\bin\mysqldump.exe
echo   C:\xampp\mysql\bin\mysqldump.exe
echo.
set /p MYSQLDUMP_PATH="Chemin vers mysqldump.exe: "
if "%MYSQLDUMP_PATH%"=="" (
    echo Export annulé.
    pause
    exit /b 1
)

if not exist "%MYSQLDUMP_PATH%" (
    echo ❌ Fichier non trouvé: %MYSQLDUMP_PATH%
    pause
    exit /b 1
)

:found_mysqldump
echo ✅ mysqldump trouvé: %MYSQLDUMP_PATH%
echo.

REM Lire les informations depuis application.properties
set DB_NAME=FasoDocs
set DB_USER=root
set DB_PASSWORD=
set DB_HOST=localhost

REM Demander confirmation
set /p CONFIRM="Voulez-vous exporter la base de données %DB_NAME%? (O/N): "
if /i not "%CONFIRM%"=="O" (
    echo Export annulé.
    pause
    exit /b 0
)

echo.
echo 📊 Export en cours...
echo.

REM Créer le répertoire de destination s'il n'existe pas
if not exist "src\main\resources" mkdir "src\main\resources"

REM Exporter la base de données complète
if "%DB_PASSWORD%"=="" (
    "%MYSQLDUMP_PATH%" -h %DB_HOST% -u %DB_USER% --single-transaction --routines --triggers --events --add-drop-table --complete-insert %DB_NAME% > "src\main\resources\fasodocs-full-dump.sql" 2>nul
) else (
    "%MYSQLDUMP_PATH%" -h %DB_HOST% -u %DB_USER% -p%DB_PASSWORD% --single-transaction --routines --triggers --events --add-drop-table --complete-insert %DB_NAME% > "src\main\resources\fasodocs-full-dump.sql" 2>nul
)

if %ERRORLEVEL% EQU 0 (
    echo.
    echo 🎉 Export réussi !
    echo.
    echo 📁 Fichier créé: src\main\resources\fasodocs-full-dump.sql
    echo.
    
    REM Afficher la taille du fichier
    for %%A in ("src\main\resources\fasodocs-full-dump.sql") do (
        echo 📊 Taille: %%~zA octets
    )
    echo.
    echo ✅ Vous pouvez maintenant commiter ce fichier dans Git
    echo    pour que les autres développeurs aient toutes les données.
) else (
    echo.
    echo ❌ Erreur lors de l'export
    echo.
    echo 💡 Essayez manuellement avec mot de passe:
    echo    "%MYSQLDUMP_PATH%" -u root -p FasoDocs ^> src\main\resources\fasodocs-full-dump.sql
    echo.
    echo Ou utilisez MySQL Workbench pour exporter la base de données
)

echo.
pause



