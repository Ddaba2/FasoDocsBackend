@echo off
REM ========================================
REM Script de démarrage FasoDocs Backend
REM ========================================

echo.
echo ========================================
echo   Demarrage FasoDocs Backend
echo ========================================
echo.

echo Demarrage de FasoDocs Backend...
echo.

REM Démarrer le backend FasoDocs
call mvnw.cmd spring-boot:run

pause

