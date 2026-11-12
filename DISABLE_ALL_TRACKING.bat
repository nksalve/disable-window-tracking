@echo off
:: Check for admin
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Requesting Administrator privileges...
    powershell -Command "Start-Process cmd -ArgumentList '/c \"%~f0\"' -Verb RunAs"
    exit /b
)

echo Running with Administrator privileges...
echo.

:: Stop and disable services
echo === Stopping and Disabling Services ===
sc stop DiagTrack >nul 2>&1
sc config DiagTrack start= disabled
echo [DONE] DiagTrack (Windows Telemetry)

sc stop dmwappushservice >nul 2>&1
sc config dmwappushservice start= disabled
echo [DONE] dmwappushservice (Connected User Experiences)

sc stop "SQLTELEMETRY$SQLEXPRESS" >nul 2>&1
sc config "SQLTELEMETRY$SQLEXPRESS" start= disabled
echo [DONE] SQL Server CEIP

sc stop edgeupdate >nul 2>&1
sc config edgeupdate start= disabled
echo [DONE] Edge Update

sc stop edgeupdatem >nul 2>&1
sc config edgeupdatem start= disabled
echo [DONE] Edge Update Manual

sc stop whesvc >nul 2>&1
sc config whesvc start= disabled
echo [DONE] Windows Health Experiences

sc stop WpnService >nul 2>&1
sc config WpnService start= disabled
echo [DONE] Windows Push Notifications

sc stop wlidsvc >nul 2>&1
sc config wlidsvc start= disabled
echo [DONE] MS Account Sign-in Assistant

sc stop MicrosoftEdgeElevationService >nul 2>&1
sc config MicrosoftEdgeElevationService start= disabled
echo [DONE] Edge Elevation Service

echo.
echo === Setting Registry Keys ===

:: Telemetry level 0
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v MaxTelemetryAllowed /t REG_DWORD /d 0 /f
echo [DONE] Windows Telemetry = 0

:: Office Connected Experiences
reg add "HKLM\SOFTWARE\Policies\Microsoft\Office\16.0\Common\Privacy" /v DisconnectedState /t REG_DWORD /d 2 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Office\16.0\Common\Privacy" /v UserContentDisabled /t REG_DWORD /d 2 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Office\16.0\Common\Privacy" /v DownloadContentDisabled /t REG_DWORD /d 2 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Office\16.0\Common\Privacy" /v ControllerConnectedServicesEnabled /t REG_DWORD /d 2 /f
echo [DONE] Office Connected Experiences Disabled

:: SmartScreen
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v EnableSmartScreen /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v SmartScreenEnabled /t REG_SZ /d Off /f
echo [DONE] SmartScreen Disabled

:: Widgets
reg add "HKLM\SOFTWARE\Policies\Microsoft\Dsh" /v AllowNewsAndInterests /t REG_DWORD /d 0 /f
echo [DONE] Widgets Disabled

:: Activity History
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ActivityHistory" /v PublishUserActivities /t REG_DWORD /d 0 /f
echo [DONE] Activity History Disabled

echo.
echo === Blocking Telemetry Domains ===
echo 0.0.0.0 vortex.data.microsoft.com >> %SystemRoot%\System32\drivers\etc\hosts
echo 0.0.0.0 vortex-win.data.microsoft.com >> %SystemRoot%\System32\drivers\etc\hosts
echo 0.0.0.0 telecommand.telemetry.microsoft.com >> %SystemRoot%\System32\drivers\etc\hosts
echo 0.0.0.0 oca.telemetry.microsoft.com >> %SystemRoot%\System32\drivers\etc\hosts
echo 0.0.0.0 sqm.telemetry.microsoft.com >> %SystemRoot%\System32\drivers\etc\hosts
echo 0.0.0.0 watson.telemetry.microsoft.com >> %SystemRoot%\System32\drivers\etc\hosts
echo 0.0.0.0 watson.microsoft.com >> %SystemRoot%\System32\drivers\etc\hosts
echo 0.0.0.0 settings-sandbox.data.microsoft.com >> %SystemRoot%\System32\drivers\etc\hosts
echo 0.0.0.0 telemetry.appex.bing.net >> %SystemRoot%\System32\drivers\etc\hosts
echo 0.0.0.0 telemetry.urs.microsoft.com >> %SystemRoot%\System32\drivers\etc\hosts
echo [DONE] 10 telemetry domains blocked

echo.
echo === Disabling Xbox Task ===
schtasks /Change /TN "\Microsoft\XblGameSave\XblGameSaveTask" /Disable >nul 2>&1
echo [DONE] Xbox Game Save Task

echo.
echo ============================================
echo    ALL DATA COLLECTION DISABLED!
echo    Please RESTART your PC for full effect.
echo ============================================
echo.
pause
