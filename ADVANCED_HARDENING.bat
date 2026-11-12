@echo off
:: ============================================================
::  ADVANCED HARDENING - RUN AS ADMINISTRATOR
:: ============================================================

net session >nul 2>&1
if %errorlevel% neq 0 (
    powershell -Command "Start-Process cmd -ArgumentList '/c \"%~f0\"' -Verb RunAs"
    exit /b
)

echo ======================================================
echo   APPLYING ADVANCED SYSTEM PRIVACY HARDENING
echo ======================================================
echo.

:: 1. Disable Windows Error Reporting Service (WER)
echo [1/6] Disabling Windows Error Reporting Service...
sc stop WerSvc >nul 2>&1
sc config WerSvc start= disabled
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" /v Disabled /t REG_DWORD /d 1 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\Windows Error Reporting" /v Disabled /t REG_DWORD /d 1 /f >nul
echo [DONE] Windows Error Reporting fully disabled.

:: 2. Disable Bing Web Search & Cortana in Start Menu
echo [2/6] Disabling Bing Search integration in Start Menu...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v DisableWebSearch /t REG_DWORD /d 1 /f >nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v ConnectedSearchUseWeb /t REG_DWORD /d 0 /f >nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v AllowCortana /t REG_DWORD /d 0 /f >nul
echo [DONE] Start Menu search is now 100%% offline/local only.

:: 3. Disable Cloud Clipboard Sync
echo [3/6] Disabling Cloud Clipboard Synchronization...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v AllowCrossDeviceClipboard /t REG_DWORD /d 0 /f >nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v AllowClipboardHistory /t REG_DWORD /d 0 /f >nul
echo [DONE] Clipboard contents will never sync across Microsoft accounts.

:: 4. Disable Windows Customer Experience Improvement Program (CEIP)
echo [4/6] Disabling System-wide CEIP / App Telemetry...
reg add "HKLM\SOFTWARE\Policies\Microsoft\SQMClient\Windows" /v CEIPEnable /t REG_DWORD /d 0 /f >nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v AITEnable /t REG_DWORD /d 0 /f >nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v DisableInventory /t REG_DWORD /d 1 /f >nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v DisablePCA /t REG_DWORD /d 1 /f >nul
echo [DONE] Application inventory collection & CEIP disabled.

:: 5. Disable Tailored Experiences (Diagnostic data profiling)
echo [5/6] Disabling Tailored Experiences and Advertising...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v DisableTailoredExperiencesWithDiagnosticData /t REG_DWORD /d 1 /f >nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v DisableWindowsConsumerFeatures /t REG_DWORD /d 1 /f >nul
echo [DONE] Personalized recommendations & silent background app installs disabled.

:: 6. Disable Wi-Fi Sense / Hotspot Sharing
echo [6/6] Disabling Wi-Fi Sense Credential Sharing...
reg add "HKLM\SOFTWARE\Microsoft\WcmSvc\wifinetworkmanager\config" /v AutoConnectAllowedOEM /t REG_DWORD /d 0 /f >nul
echo [DONE] Wi-Fi Sense disabled.

echo.
echo ======================================================
echo   ADVANCED HARDENING COMPLETED!
echo ======================================================
echo.
pause
