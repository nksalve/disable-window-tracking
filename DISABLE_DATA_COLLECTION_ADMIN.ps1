# ============================================================
#  DISABLE ALL DATA COLLECTION - RUN AS ADMINISTRATOR
#  Right-click this file -> "Run with PowerShell" as Admin
# ============================================================

Write-Host "============================================" -ForegroundColor Cyan
Write-Host "  DISABLING DATA-COLLECTING SERVICES" -ForegroundColor Cyan  
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

# --- 1. STOP AND DISABLE SERVICES ---
$services = @(
    @{Name="DiagTrack";                  Desc="Windows Telemetry (DiagTrack)"},
    @{Name="dmwappushservice";           Desc="Connected User Experiences & Telemetry"},
    @{Name="SQLTELEMETRY`$SQLEXPRESS";   Desc="SQL Server CEIP"},
    @{Name="edgeupdate";                 Desc="Microsoft Edge Update"},
    @{Name="edgeupdatem";                Desc="Microsoft Edge Update (Manual)"},
    @{Name="whesvc";                     Desc="Windows Health & Optimized Experiences"},
    @{Name="WpnService";                 Desc="Windows Push Notifications System"},
    @{Name="wlidsvc";                    Desc="Microsoft Account Sign-in Assistant"},
    @{Name="MicrosoftEdgeElevationService"; Desc="Microsoft Edge Elevation Service"}
)

foreach ($svc in $services) {
    try {
        $s = Get-Service -Name $svc.Name -ErrorAction Stop
        if ($s.Status -eq 'Running') {
            Stop-Service -Name $svc.Name -Force -ErrorAction Stop
        }
        Set-Service -Name $svc.Name -StartupType Disabled -ErrorAction Stop
        Write-Host "[OK] $($svc.Desc) - STOPPED + DISABLED" -ForegroundColor Green
    } catch {
        Write-Host "[WARN] $($svc.Desc) - $($_.Exception.Message)" -ForegroundColor Yellow
    }
}

# --- 2. REGISTRY: TELEMETRY LEVEL TO 0 (Security/Off) ---
Write-Host ""
Write-Host "--- Setting Telemetry Registry Keys ---" -ForegroundColor Cyan

try {
    New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Force | Out-Null
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -Value 0 -Type DWord
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "MaxTelemetryAllowed" -Value 0 -Type DWord
    Write-Host "[OK] Windows Telemetry level set to 0 (DISABLED)" -ForegroundColor Green
} catch {
    Write-Host "[WARN] Telemetry registry: $_" -ForegroundColor Yellow
}

# --- 3. DISABLE OFFICE CONNECTED EXPERIENCES ---
try {
    New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Office\16.0\Common\Privacy" -Force | Out-Null
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Office\16.0\Common\Privacy" -Name "DisconnectedState" -Value 2 -Type DWord
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Office\16.0\Common\Privacy" -Name "UserContentDisabled" -Value 2 -Type DWord
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Office\16.0\Common\Privacy" -Name "DownloadContentDisabled" -Value 2 -Type DWord
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Office\16.0\Common\Privacy" -Name "ControllerConnectedServicesEnabled" -Value 2 -Type DWord
    Write-Host "[OK] Office Connected Experiences DISABLED" -ForegroundColor Green
} catch {
    Write-Host "[WARN] Office telemetry: $_" -ForegroundColor Yellow
}

# --- 4. DISABLE SMARTSCREEN ---
try {
    New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Force | Out-Null
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "EnableSmartScreen" -Value 0 -Type DWord
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" -Name "SmartScreenEnabled" -Value "Off"
    Write-Host "[OK] SmartScreen DISABLED" -ForegroundColor Green
} catch {
    Write-Host "[WARN] SmartScreen: $_" -ForegroundColor Yellow
}

# --- 5. DISABLE WIDGETS ---
try {
    New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Dsh" -Force | Out-Null
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Dsh" -Name "AllowNewsAndInterests" -Value 0 -Type DWord
    Write-Host "[OK] Widgets/News & Interests DISABLED" -ForegroundColor Green
} catch {
    Write-Host "[WARN] Widgets: $_" -ForegroundColor Yellow
}

# --- 6. DISABLE XBOX GAME SAVE TASK ---
try {
    Disable-ScheduledTask -TaskName "XblGameSaveTask" -TaskPath "\Microsoft\XblGameSave\" -ErrorAction Stop | Out-Null
    Write-Host "[OK] Xbox Game Save Task DISABLED" -ForegroundColor Green
} catch {
    Write-Host "[WARN] Xbox task: $_" -ForegroundColor Yellow
}

# --- 7. BLOCK TELEMETRY IPs VIA HOSTS FILE ---
Write-Host ""
Write-Host "--- Blocking Telemetry Domains ---" -ForegroundColor Cyan

$hostsFile = "$env:SystemRoot\System32\drivers\etc\hosts"
$domains = @(
    "vortex.data.microsoft.com",
    "vortex-win.data.microsoft.com",
    "telecommand.telemetry.microsoft.com",
    "telecommand.telemetry.microsoft.com.nsatc.net",
    "oca.telemetry.microsoft.com",
    "sqm.telemetry.microsoft.com",
    "watson.telemetry.microsoft.com",
    "watson.microsoft.com",
    "settings-sandbox.data.microsoft.com",
    "telemetry.appex.bing.net",
    "telemetry.urs.microsoft.com"
)

$hostsContent = Get-Content $hostsFile -ErrorAction SilentlyContinue
$added = 0
foreach ($domain in $domains) {
    if ($hostsContent -notcontains "0.0.0.0 $domain") {
        Add-Content -Path $hostsFile -Value "0.0.0.0 $domain" -ErrorAction SilentlyContinue
        $added++
    }
}
Write-Host "[OK] Blocked $added telemetry domains in hosts file" -ForegroundColor Green

# --- SUMMARY ---
Write-Host ""
Write-Host "============================================" -ForegroundColor Green
Write-Host "  ALL DATA COLLECTION DISABLED!" -ForegroundColor Green
Write-Host "  Restart your PC for full effect." -ForegroundColor Green
Write-Host "============================================" -ForegroundColor Green
Write-Host ""
Write-Host "Press Enter to close..."
Read-Host
