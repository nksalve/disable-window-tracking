# 🛡️ Privacy Toolkit

Scripts to disable all data-collecting programs and services on Windows.

## 📁 Files

| File | Purpose |
|---|---|
| `DISABLE_ALL_TRACKING.bat` | **Main script** — Stops & disables all telemetry services, sets registry keys, blocks telemetry domains. Auto-requests Admin. |
| `DISABLE_DATA_COLLECTION_ADMIN.ps1` | PowerShell version — Same functionality, must be run as Admin manually. |
| `VERIFY_PRIVACY_STATUS.bat` | **Verification** — Checks if all services, registry keys, and blocks are active. |
| `RESTORE_DEFAULTS.bat` | **Undo** — Restores all settings to Windows defaults if something breaks. |

## 🚀 Usage

### Step 1: Disable all tracking
```
Double-click DISABLE_ALL_TRACKING.bat → Click "Yes" on UAC prompt
```

### Step 2: Verify
```
Double-click VERIFY_PRIVACY_STATUS.bat → Check all items show [OK]
```

### Step 3: Restart PC
Restart your computer for all changes to take effect.

## ⚠️ If something breaks
```
Double-click RESTORE_DEFAULTS.bat → Restart PC
```

## 📋 What Gets Disabled

### Services
- DiagTrack (Windows Telemetry)
- Connected User Experiences
- SQL Server CEIP
- Microsoft Edge Update
- Windows Health Experiences
- Windows Push Notifications
- Microsoft Account Sign-in Assistant

### Registry
- Windows Telemetry level → 0
- Office Connected Experiences → Off
- SmartScreen → Off
- Widgets → Off
- Advertising ID → Off
- Activity History → Off
- Location Tracking → Denied
- Typing/Inking Collection → Off
- App Launch Tracking → Off
- Feedback Requests → Off

### Scheduled Tasks
- Google Chrome Platform Experience Helper (3 tasks)
- Xbox Game Save Task

### Startup Items Removed
- OneDrive
- Microsoft Teams
- Free Download Manager

### Hosts File Blocks
10 Microsoft telemetry domains blocked via `0.0.0.0` entries.
