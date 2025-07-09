# ================================
# Dadir Defender - Upgrade-Aware Installer
# Detects and handles existing installations
# ================================

param(
    [switch]$Force,
    [switch]$KeepConfig
)

Write-Host "🛡️ Dadir Defender v2.0 Installer" -ForegroundColor Cyan
Write-Host "==================================" -ForegroundColor Cyan

$installPath = "C:\DadirDefender"
$backupPath = "C:\DadirDefender_backup_$(Get-Date -Format 'yyyyMMdd_HHmmss')"

# Check if running as administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "❌ Administrator privileges required for installation" -ForegroundColor Red
    Write-Host "Please run as administrator" -ForegroundColor Yellow
    Read-Host "Press Enter to exit"
    exit 1
}

# Function to detect existing installation
function Test-ExistingInstallation {
    $indicators = @(
        "$installPath\Agent\monitor.ps1",
        "$installPath\Agent\monitor_clean.ps1", 
        "$installPath\Agent\monitor_modular.ps1",
        "$installPath\UI\dashboard.py"
    )
    
    foreach ($file in $indicators) {
        if (Test-Path $file) {
            return $true
        }
    }
    
    # Check for running services
    $service = Get-Service -Name "DadirDefender*" -ErrorAction SilentlyContinue
    if ($service) {
        return $true
    }
    
    return $false
}

# Function to backup user configuration
function Backup-UserConfig {
    Write-Host "📦 Backing up user configuration..." -ForegroundColor Yellow
    
    $configFiles = @()
    
    # Check for configured monitor scripts
    if (Test-Path "$installPath\Agent\monitor.ps1") {
        $content = Get-Content "$installPath\Agent\monitor.ps1" -Raw
        if ($content -notlike "*your-email@gmail.com*") {
            $configFiles += "Agent\monitor.ps1"
        }
    }
    
    # Backup logs if requested
    if ($KeepConfig -and (Test-Path "$installPath\Logs")) {
        $configFiles += "Logs"
    }
    
    # Backup rclone config if exists
    if (Test-Path "$installPath\rclone.conf") {
        $configFiles += "rclone.conf"
    }
    
    if ($configFiles.Count -gt 0) {
        New-Item -ItemType Directory -Path $backupPath -Force | Out-Null
        foreach ($file in $configFiles) {
            $source = "$installPath\$file"
            $dest = "$backupPath\$file"
            
            if (Test-Path $source) {
                $destDir = Split-Path $dest -Parent
                if (!(Test-Path $destDir)) {
                    New-Item -ItemType Directory -Path $destDir -Force | Out-Null
                }
                Copy-Item $source $dest -Recurse -Force
                Write-Host "  ✅ Backed up: $file" -ForegroundColor Green
            }
        }
        return $backupPath
    }
    
    return $null
}

# Function to stop existing services
function Stop-ExistingServices {
    Write-Host "🛑 Stopping existing services..." -ForegroundColor Yellow
    
    # Stop and disable the old service
    $services = Get-Service -Name "DadirDefender*" -ErrorAction SilentlyContinue
    foreach ($service in $services) {
        try {
            Stop-Service -Name $service.Name -Force -ErrorAction SilentlyContinue
            Set-Service -Name $service.Name -StartupType Disabled -ErrorAction SilentlyContinue
            Write-Host "  ✅ Stopped: $($service.Name)" -ForegroundColor Green
        } catch {
            Write-Host "  ⚠️ Could not stop: $($service.Name)" -ForegroundColor Yellow
        }
    }
    
    # Disable scheduled tasks
    $tasks = Get-ScheduledTask | Where-Object { $_.TaskName -like "*Dadir*" }
    foreach ($task in $tasks) {
        try {
            Disable-ScheduledTask -TaskName $task.TaskName -ErrorAction SilentlyContinue
            Write-Host "  ✅ Disabled task: $($task.TaskName)" -ForegroundColor Green
        } catch {
            Write-Host "  ⚠️ Could not disable task: $($task.TaskName)" -ForegroundColor Yellow
        }
    }
}

# Main installation logic
Write-Host "`n🔍 Checking for existing installation..." -ForegroundColor Yellow

if (Test-ExistingInstallation) {
    Write-Host "⚠️ Existing Dadir Defender installation detected!" -ForegroundColor Yellow
    
    if (-not $Force) {
        Write-Host "`nOptions:" -ForegroundColor Cyan
        Write-Host "1. Upgrade (recommended) - Backup config, remove old, install new" -ForegroundColor White
        Write-Host "2. Clean install - Remove everything and start fresh" -ForegroundColor White
        Write-Host "3. Cancel - Exit without changes" -ForegroundColor White
        
        do {
            $choice = Read-Host "`nEnter choice (1-3)"
        } while ($choice -notin @("1", "2", "3"))
        
        switch ($choice) {
            "1" { 
                Write-Host "`n🔄 Starting upgrade process..." -ForegroundColor Green
                $KeepConfig = $true
            }
            "2" { 
                Write-Host "`n🧹 Starting clean installation..." -ForegroundColor Green
                $KeepConfig = $false
            }
            "3" { 
                Write-Host "`n❌ Installation cancelled by user" -ForegroundColor Red
                exit 0
            }
        }
    }
    
    # Backup configuration if upgrading
    $backupLocation = $null
    if ($KeepConfig) {
        $backupLocation = Backup-UserConfig
        if ($backupLocation) {
            Write-Host "📦 Configuration backed up to: $backupLocation" -ForegroundColor Green
        }
    }
    
    # Stop existing services
    Stop-ExistingServices
    
    # Remove old installation
    Write-Host "🗑️ Removing old installation..." -ForegroundColor Yellow
    try {
        if (Test-Path $installPath) {
            Remove-Item $installPath -Recurse -Force
            Write-Host "  ✅ Old installation removed" -ForegroundColor Green
        }
    } catch {
        Write-Host "  ❌ Could not remove old installation: $_" -ForegroundColor Red
        Write-Host "Please manually delete $installPath and run installer again" -ForegroundColor Yellow
        Read-Host "Press Enter to exit"
        exit 1
    }
    
} else {
    Write-Host "✅ No existing installation found. Proceeding with fresh install." -ForegroundColor Green
}

# Install new version
Write-Host "`n📦 Installing Dadir Defender v2.0..." -ForegroundColor Green

# Create directory structure
$directories = @(
    "$installPath",
    "$installPath\Agent", 
    "$installPath\Optimizer",
    "$installPath\UI",
    "$installPath\Logs"
)

foreach ($dir in $directories) {
    if (!(Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
        Write-Host "  ✅ Created: $dir" -ForegroundColor Green
    }
}

# Copy files (assuming installer is run from the source directory)
$filesToCopy = @(
    @{Source="Agent\monitor_modular.ps1"; Dest="Agent\monitor_modular.ps1"},
    @{Source="Optimizer\*.ps1"; Dest="Optimizer\"},
    @{Source="UI\dashboard.py"; Dest="UI\dashboard.py"},
    @{Source="uninstall.ps1"; Dest="uninstall.ps1"},
    @{Source="README.md"; Dest="README.md"}
)

foreach ($file in $filesToCopy) {
    try {
        if ($file.Source -like "*\*") {
            # Copy multiple files
            Copy-Item $file.Source "$installPath\$($file.Dest)" -Force
        } else {
            # Copy single file
            Copy-Item $file.Source "$installPath\$($file.Dest)" -Force
        }
        Write-Host "  ✅ Installed: $($file.Source)" -ForegroundColor Green
    } catch {
        Write-Host "  ⚠️ Could not copy: $($file.Source)" -ForegroundColor Yellow
    }
}

# Restore configuration if backed up
if ($backupLocation -and (Test-Path $backupLocation)) {
    Write-Host "`n🔄 Restoring user configuration..." -ForegroundColor Yellow
    try {
        # Restore config files (but not the old scripts)
        if (Test-Path "$backupLocation\Logs" -and $KeepConfig) {
            Copy-Item "$backupLocation\Logs\*" "$installPath\Logs\" -Recurse -Force
            Write-Host "  ✅ Restored logs" -ForegroundColor Green
        }
        
        Write-Host "  📝 Note: Please reconfigure email settings in new modular scripts" -ForegroundColor Cyan
    } catch {
        Write-Host "  ⚠️ Could not restore some configuration: $_" -ForegroundColor Yellow
    }
}

# Create desktop shortcut
Write-Host "`n🔗 Creating shortcuts..." -ForegroundColor Yellow
try {
    $WshShell = New-Object -comObject WScript.Shell
    $Shortcut = $WshShell.CreateShortcut("$env:USERPROFILE\Desktop\Dadir Defender.lnk")
    $Shortcut.TargetPath = "powershell.exe"
    $Shortcut.Arguments = "-File `"$installPath\Agent\monitor_modular.ps1`""
    $Shortcut.WorkingDirectory = $installPath
    $Shortcut.Save()
    Write-Host "  ✅ Desktop shortcut created" -ForegroundColor Green
} catch {
    Write-Host "  ⚠️ Could not create shortcut: $_" -ForegroundColor Yellow
}

Write-Host "`n🎉 Installation completed successfully!" -ForegroundColor Green
Write-Host "📍 Installed to: $installPath" -ForegroundColor Cyan

if ($backupLocation) {
    Write-Host "📦 Configuration backup: $backupLocation" -ForegroundColor Cyan
    Write-Host "💡 You can delete the backup after confirming everything works" -ForegroundColor Blue
}

Write-Host "`n🚀 Next steps:" -ForegroundColor Cyan
Write-Host "1. Run: powershell -File `"$installPath\Agent\monitor_modular.ps1`"" -ForegroundColor White
Write-Host "2. Configure optional features using setup_validator.ps1" -ForegroundColor White
Write-Host "3. Check README.md for detailed setup instructions" -ForegroundColor White

Read-Host "`nPress Enter to exit"