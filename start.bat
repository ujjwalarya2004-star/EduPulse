@echo off
echo ===============================================================
echo     Smart College Student Management System - Quick Start
echo ===============================================================
echo.

REM Check if node_modules exists
if not exist "node_modules\" (
    echo [1/3] Installing dependencies...
    call npm install
) else (
    echo [1/3] Dependencies verified.
)

REM Check if dist exists
if not exist "dist\" (
    echo [2/3] Building production bundle...
    call npm run build
) else (
    echo [2/3] Build bundle found.
)

echo [3/3] Starting Application Server...
echo ---------------------------------------------------------------
echo App URL: http://localhost:3000
echo ---------------------------------------------------------------
call npm start
pause
