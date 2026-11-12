@echo off
:: ============================================================
::  RESTORE DATA COLLECTION - RUN AS ADMINISTRATOR
:: ============================================================

net session >nul 2>&1
if %errorlevel% neq 0 (
    powershell -Command "Start-Process cmd -ArgumentList '/c \"%~f0\"' -Verb RunAs"
    exit /b
)

echo ============================================
echo   RESTORING DEFAULT SETTINGS
echo ============================================
echo.

:: Re-enable services
sc config DiagTrack start= auto
sc start DiagTrack >nul 2>&1
sc config dmwappushservice start= auto
sc config "SQLTELEMETRY$SQLEXPRESS" start= auto
sc start "SQLTELEMETRY$SQLEXPRESS" >nul 2>&1
sc config edgeupdate start= auto
sc config whesvc start= auto
sc config WpnService start= auto
sc start WpnService >nul 2>&1
sc config wlidsvc start= auto
sc config WerSvc start= demand

:: Remove registry policy overrides
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /f 2>nul
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Office\16.0\Common\Privacy" /f 2>nul
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /f 2>nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v SmartScreenEnabled /t REG_SZ /d Warn /f >nul
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Dsh" /f 2>nul
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /f 2>nul
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" /f 2>nul
reg delete "HKLM\SOFTWARE\Policies\Microsoft\SQMClient\Windows" /f 2>nul
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /f 2>nul
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /f 2>nul

:: Re-enable user settings
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v Enabled /t REG_DWORD /d 1 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ActivityHistory" /v PublishUserActivities /t REG_DWORD /d 1 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v BingSearchEnabled /t REG_DWORD /d 1 /f >nul
reg delete "HKCU\Software\Microsoft\Windows\Windows Error Reporting" /f 2>nul
reg delete "HKCU\Software\Microsoft\Clipboard" /f 2>nul

:: Re-enable tasks
schtasks /Change /TN "\GoogleUserPEH\RunPlatformExperienceHelper_Daily" /Enable 2>nul
schtasks /Change /TN "\GoogleUserPEH\RunPlatformExperienceHelper_Metrics" /Enable 2>nul
schtasks /Change /TN "\GoogleUserPEH\RunPlatformExperienceHelperOnUnlock" /Enable 2>nul
schtasks /Change /TN "\Microsoft\XblGameSave\XblGameSaveTask" /Enable 2>nul

echo.
echo ============================================
echo   ALL DEFAULTS RESTORED
echo ============================================
pause
