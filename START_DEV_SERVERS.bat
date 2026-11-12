@echo off
:: ============================================================
::  RESTORE BACKGROUND DEV SERVERS (SQL & PostgreSQL)
:: ============================================================

net session >nul 2>&1
if %errorlevel% neq 0 (
    powershell -Command "Start-Process cmd -ArgumentList '/c \"%~f0\"' -Verb RunAs"
    exit /b
)

echo Starting PostgreSQL & SQL Server...
sc config MSSQL$SQLEXPRESS start= auto
sc start MSSQL$SQLEXPRESS >nul 2>&1
sc config postgresql-x64-17 start= auto
sc start postgresql-x64-17 >nul 2>&1
sc config W3SVC start= auto
sc start W3SVC >nul 2>&1
echo Done! Services are now running.
pause
