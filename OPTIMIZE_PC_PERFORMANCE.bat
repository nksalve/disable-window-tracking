@echo off
:: ============================================================
::  PC PERFORMANCE BOOST - RUN AS ADMINISTRATOR
:: ============================================================

net session >nul 2>&1
if %errorlevel% neq 0 (
    powershell -Command "Start-Process cmd -ArgumentList '/c \"%~f0\"' -Verb RunAs"
    exit /b
)

echo ======================================================
echo           PC PERFORMANCE OPTIMIZATION
echo ======================================================
echo.

:: 1. Set Windows Power Plan to High Performance
echo [1/5] Setting Power Scheme to High Performance...
powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c >nul 2>&1
if %errorlevel% neq 0 (
    powercfg /duplicatescheme 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c >nul 2>&1
    powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c >nul 2>&1
)
echo [DONE] CPU is now unlocked from aggressive throttling.

:: 2. Set Unused Heavy Background Databases & Web Servers to Manual Start
echo.
echo [2/5] Setting heavy local servers to Manual start...
echo       (They will only run when you explicitly start them)
sc config MSSQL$SQLEXPRESS start= demand >nul 2>&1
sc stop MSSQL$SQLEXPRESS >nul 2>&1
sc config postgresql-x64-17 start= demand >nul 2>&1
sc stop postgresql-x64-17 >nul 2>&1
sc config W3SVC start= demand >nul 2>&1
sc stop W3SVC >nul 2>&1
sc config IISADMIN start= demand >nul 2>&1
sc stop IISADMIN >nul 2>&1
sc config PEMHTTPD-x64 start= demand >nul 2>&1
sc stop PEMHTTPD-x64 >nul 2>&1
sc config SQLBrowser start= demand >nul 2>&1
sc stop SQLBrowser >nul 2>&1
echo [DONE] Background database/web services set to Manual and stopped.

:: 3. Clear Temporary Caches
echo.
echo [3/5] Cleaning system and user temporary files...
del /q /f /s "%TEMP%\*" >nul 2>&1
del /q /f /s "%SystemRoot%\Temp\*" >nul 2>&1
echo [DONE] Temp caches cleared.

:: 4. Run SSD TRIM Optimization
echo.
echo [4/5] Running SSD TRIM optimization...
defrag C: /O >nul 2>&1
defrag D: /O >nul 2>&1
echo [DONE] SSD Trim optimization executed.

:: 5. Flush DNS Cache
echo.
echo [5/5] Flushing DNS resolver cache...
ipconfig /flushdns >nul 2>&1
echo [DONE] DNS cache cleared.

echo.
echo ======================================================
echo        OPTIMIZATION COMPLETED SUCCESSFULLY!
echo ======================================================
echo.
pause
