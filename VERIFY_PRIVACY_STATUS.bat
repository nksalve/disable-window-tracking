@echo off
:: ============================================================
::  VERIFY DATA COLLECTION STATUS - RUN AS ADMINISTRATOR
::  Double-click to auto-elevate and check all settings
:: ============================================================

:: Check for admin
net session >nul 2>&1
if %errorlevel% neq 0 (
    powershell -Command "Start-Process cmd -ArgumentList '/c \"%~f0\"' -Verb RunAs"
    exit /b
)

echo ============================================
echo   PRIVACY STATUS VERIFICATION
echo ============================================
echo.

echo === SERVICES ===
for %%s in (DiagTrack dmwappushservice "SQLTELEMETRY$SQLEXPRESS" edgeupdate edgeupdatem whesvc WpnService wlidsvc MicrosoftEdgeElevationService) do (
    sc query %%s 2>nul | find "STOPPED" >nul
    if !errorlevel! == 0 (
        echo [OK] %%s = STOPPED
    ) else (
        sc query %%s 2>nul | find "RUNNING" >nul
        if !errorlevel! == 0 (
            echo [FAIL] %%s = STILL RUNNING
        ) else (
            echo [SKIP] %%s = NOT FOUND
        )
    )
)

echo.
echo === REGISTRY ===
for /f "tokens=3" %%a in ('reg query "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry 2^>nul ^| find "AllowTelemetry"') do (
    if "%%a"=="0x0" (echo [OK] Telemetry = DISABLED) else (echo [FAIL] Telemetry = %%a)
)

for /f "tokens=3" %%a in ('reg query "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v EnableSmartScreen 2^>nul ^| find "EnableSmartScreen"') do (
    if "%%a"=="0x0" (echo [OK] SmartScreen = DISABLED) else (echo [FAIL] SmartScreen = %%a)
)

for /f "tokens=3" %%a in ('reg query "HKLM\SOFTWARE\Policies\Microsoft\Dsh" /v AllowNewsAndInterests 2^>nul ^| find "AllowNewsAndInterests"') do (
    if "%%a"=="0x0" (echo [OK] Widgets = DISABLED) else (echo [FAIL] Widgets = %%a)
)

echo.
echo === HOSTS FILE BLOCKS ===
find /c "0.0.0.0" %SystemRoot%\System32\drivers\etc\hosts

echo.
echo === SCHEDULED TASKS ===
schtasks /Query /TN "\GoogleUserPEH\RunPlatformExperienceHelper_Daily" 2>nul | find "Disabled"
if %errorlevel%==0 (echo [OK] Chrome Daily Task = Disabled) else (echo [FAIL] Chrome Daily Task)

schtasks /Query /TN "\GoogleUserPEH\RunPlatformExperienceHelper_Metrics" 2>nul | find "Disabled"
if %errorlevel%==0 (echo [OK] Chrome Metrics Task = Disabled) else (echo [FAIL] Chrome Metrics Task)

schtasks /Query /TN "\Microsoft\XblGameSave\XblGameSaveTask" 2>nul | find "Disabled"
if %errorlevel%==0 (echo [OK] Xbox Task = Disabled) else (echo [FAIL] Xbox Task)

echo.
echo ============================================
echo   VERIFICATION COMPLETE
echo ============================================
pause
