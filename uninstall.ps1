# ================================
# Dadir Defender Uninstaller
# Purpose: Clean removal of all components
# ================================

Write-Host "🛡️ Dadir Defender Uninstaller" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan

# Check if running as administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "❌ Administrator privileges required for complete uninstall" -ForegroundColor Red
    Write-Host "Please run as administrator to remove all components" -ForegroundColor Yellow
    Read-Host "Press Enter to exit"
    exit 1
}

$uninstallLog = "C:\DadirDefender\Logs\uninstall_$(Get-Date -Format 'yyyy-MM-dd_HH-mm-ss').txt"

# Function to log and display
function Write-UninstallLog {
    param([string]$message)
    Write-Host $message
    Add-Content $uninstallLog $message -ErrorAction SilentlyContinue
}

Write-UninstallLog "Starting Dadir Defender uninstall at $(Get-Date)"

# 1. Stop and remove Windows service
Write-UninstallLog "`n=== Removing Windows Service ==="
try {
    $service = Get-Service -Name "DadirDefender" -ErrorAction SilentlyContinue
    if ($service) {
        Stop-Service -Name "DadirDefender" -Force -ErrorAction SilentlyContinue
        & sc.exe delete "DadirDefender"
        Write-UninstallLog "✅ Windows service removed"
    } else {
        Write-UninstallLog "ℹ️ No Windows service found"
    }
} catch {
    Write-UninstallLog "⚠️ Could not remove service: $_"
}

# 2. Restore visual effects
Write-UninstallLog "`n=== Restoring Visual Effects ==="
try {
    $currentSetting = Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" -Name "VisualFXSetting" -ErrorAction SilentlyContinue
    if ($currentSetting -and $currentSetting.VisualFXSetting -eq 2) {
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" -Name "VisualFXSetting" -Value 0
        Write-UninstallLog "✅ Visual effects restored to default"
    } else {
        Write-UninstallLog "ℹ️ Visual effects already at default"
    }
} catch {
    Write-UninstallLog "⚠️ Could not restore visual effects: $_"
}

# 3. Reset process priorities
Write-UninstallLog "`n=== Resetting Process Priorities ==="
$processesToReset = @("code", "msedge", "chrome", "firefox")
foreach ($processName in $processesToReset) {
    try {
        $processes = Get-Process -Name $processName -ErrorAction SilentlyContinue
        foreach ($proc in $processes) {
            $proc.PriorityClass = "Normal"
        }
        if ($processes.Count -gt 0) {
            Write-UninstallLog "✅ Reset priority for $($processes.Count) $processName processes"
        }
    } catch {
        Write-UninstallLog "⚠️ Could not reset $processName priority: $_"
    }
}

# 4. Upload final log to Google Drive
Write-UninstallLog "`n=== Final Log Upload ==="
$rclonePath = "C:\rclone\rclone.exe"
if (Test-Path $rclonePath) {
    try {
        & "$rclonePath" copy $uninstallLog "gdrive:/VM-Backups" --log-file="C:\DadirDefender\Logs\final_upload.log"
        Write-UninstallLog "✅ Uninstall log uploaded to Google Drive"
    } catch {
        Write-UninstallLog "⚠️ Could not upload final log: $_"
    }
} else {
    Write-UninstallLog "ℹ️ rclone not found, skipping log upload"
}

# 5. Remove application files
Write-UninstallLog "`n=== Removing Application Files ==="
$filesToRemove = @(
    "C:\DadirDefender\Agent\monitor.ps1",
    "C:\DadirDefender\Agent\monitor_clean.ps1",
    "C:\DadirDefender\UI\dashboard.py",
    "C:\DadirDefender\UI\dashboard.exe",
    "C:\DadirDefender\config.ini"
)

foreach ($file in $filesToRemove) {
    if (Test-Path $file) {
        Remove-Item $file -Force -ErrorAction SilentlyContinue
        Write-UninstallLog "✅ Removed: $file"
    }
}

# 6. Clean up log files
Write-UninstallLog "`n=== Cleaning Log Files ==="
try {
    $logFiles = Get-ChildItem "C:\DadirDefender\Logs" -Filter "*.txt" | Where-Object { $_.Name -notlike "uninstall_*" }
    $logCount = $logFiles.Count
    $logFiles | Remove-Item -Force
    
    $rcloneFiles = Get-ChildItem "C:\DadirDefender\Logs" -Filter "*.log"
    $rcloneCount = $rcloneFiles.Count
    $rcloneFiles | Remove-Item -Force
    
    Write-UninstallLog "✅ Removed $logCount log files and $rcloneCount rclone logs"
} catch {
    Write-UninstallLog "⚠️ Could not clean all log files: $_"
}

Write-UninstallLog "`n=== Uninstall Complete ==="
Write-UninstallLog "Dadir Defender has been uninstalled at $(Get-Date)"
Write-UninstallLog "Uninstall log saved at: $uninstallLog"

Write-Host "`n✅ Uninstall completed successfully!" -ForegroundColor Green
Write-Host "Uninstall log saved at: $uninstallLog" -ForegroundColor Yellow
Write-Host "`nTo completely remove all traces:" -ForegroundColor Cyan
Write-Host "1. Delete C:\DadirDefender folder manually" -ForegroundColor White
Write-Host "2. Restart your computer" -ForegroundColor White
Write-Host "`nPress Enter to exit..." -ForegroundColor Cyan
Read-Host