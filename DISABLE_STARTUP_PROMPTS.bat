@echo off
:: ============================================================
::  DISABLE STARTUP PRIVACY & SETUP SCREENS (RUN AS ADMIN)
:: ============================================================

net session >nul 2>&1
if %errorlevel% neq 0 (
    powershell -Command "Start-Process cmd -ArgumentList '/c \"%~f0\"' -Verb RunAs"
    exit /b
)

echo ============================================================
echo   DISABLING STARTUP PRIVACY & DEVICE SETUP SCREENS
echo ============================================================
echo.

:: 1. Disable Privacy Experience on Logon (User & Machine)
echo [1/4] Disabling Privacy Consent Experience dialog...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\OOBE" /v DisablePrivacyExperience /t REG_DWORD /d 1 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OOBE" /v PrivacyConsentStatus /t REG_DWORD /d 1 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OOBE" /v SkipUserOOBE /t REG_DWORD /d 1 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OOBE" /v SkipMachineOOBE /t REG_DWORD /d 1 /f >nul

:: 2. Disable "Let's finish setting up your device" (SCOOBE)
echo [2/4] Disabling Second Chance Out of Box Experience (SCOOBE)...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v EnableActivityFeed /t REG_DWORD /d 0 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\UserProfileEngagement" /v ScoobeSystemSettingEnabled /t REG_DWORD /d 0 /f >nul

:: 3. Disable Windows Welcome Experience
echo [3/4] Disabling Windows Welcome Experience on boot...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-310093Enabled /t REG_DWORD /d 0 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-338389Enabled /t REG_DWORD /d 0 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-353698Enabled /t REG_DWORD /d 0 /f >nul

:: 4. Disable Cloud Consumer Welcome Experiences
echo [4/4] Disabling Cloud Experience Host nag screens...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v DisableWindowsConsumerFeatures /t REG_DWORD /d 1 /f >nul

echo.
echo ============================================================
echo   ALL STARTUP PROMPTS PERMANENTLY DISABLED!
echo ============================================================
echo.
pause
