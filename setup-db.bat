@echo off
echo ===============================================================
echo   Smart College Student Management System - MySQL Database Setup
echo ===============================================================
echo.
echo Running automated MySQL schema and seed migration...
call npm run setup:db
pause
