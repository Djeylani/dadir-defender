# ================================
# Dadir Defender - Version Information
# Detects installed version and components
# ================================

Write-Host "🛡️ Dadir Defender - Version Information" -ForegroundColor Cyan
Write-Host "=======================================" -ForegroundColor Cyan

$installPath = "C:\DadirDefender"

function Get-InstalledVersion {
    # Check for v2.0 modular structure
    if (Test-Path "$installPath\Agent\monitor_modular.ps1") {
        return "2.0 (Modular)"
    }
    
    # Check for v1.x structure
    if (Test-Path "$installPath\Agent\monitor_clean.ps1") {
        return "1.x (Legacy)"
    }
    
    if (Test-Path "$installPath\Agent\monitor.ps1") {
        return "1.0 (Original)"
    }
    
    return "Not Installed"
}

function Get-ComponentStatus {
    $components = @()
    
    # Core components
    if (Test-Path "$installPath\Agent\monitor_modular.ps1") {
        $components += "✅ Modular Monitor"
    }
    
    if (Test-Path "$installPath\Optimizer\ProcessPriorityManager.ps1") {
        $components += "✅ Process Priority Manager"
    }
    
    if (Test-Path "$installPath\Optimizer\BackgroundAppGuard.ps1") {
        $components += "✅ Background App Guard"
    }
    
    if (Test-Path "$installPath\Optimizer\PowerPlanOptimizer.ps1") {
        $components += "✅ Power Plan Optimizer"
    }
    
    if (Test-Path "$installPath\UI\dashboard.py") {
        $components += "✅ Python GUI Dashboard"
    }
    
    if (Test-Path "$installPath\uninstall.ps1") {
        $components += "✅ Uninstaller"
    }
    
    # Legacy components
    if (Test-Path "$installPath\Agent\monitor.ps1") {
        $components += "⚠️ Legacy Monitor (v1.x)"
    }
    
    if (Test-Path "$installPath\Agent\monitor_clean.ps1") {
        $components += "⚠️ Legacy Clean Monitor"
    }
    
    return $components
}

function Get-ServiceStatus {
    $services = Get-Service -Name "DadirDefender*" -ErrorAction SilentlyContinue
    if ($services) {
        return $services | ForEach-Object { "$($_.Name): $($_.Status)" }
    }
    return @("No services found")
}

# Display information
Write-Host "`n📍 Installation Path: $installPath" -ForegroundColor White
Write-Host "📦 Installed Version: $(Get-InstalledVersion)" -ForegroundColor Green

Write-Host "`n🔧 Components:" -ForegroundColor Yellow
$components = Get-ComponentStatus
if ($components.Count -gt 0) {
    foreach ($component in $components) {
        Write-Host "  $component" -ForegroundColor White
    }
} else {
    Write-Host "  ❌ No components found" -ForegroundColor Red
}

Write-Host "`n🔄 Services:" -ForegroundColor Yellow
$services = Get-ServiceStatus
foreach ($service in $services) {
    Write-Host "  $service" -ForegroundColor White
}

# Check for mixed versions
$hasLegacy = (Test-Path "$installPath\Agent\monitor.ps1") -or (Test-Path "$installPath\Agent\monitor_clean.ps1")
$hasModular = Test-Path "$installPath\Agent\monitor_modular.ps1"

if ($hasLegacy -and $hasModular) {
    Write-Host "`n⚠️ WARNING: Mixed version installation detected!" -ForegroundColor Red
    Write-Host "   Both legacy and modular components found." -ForegroundColor Yellow
    Write-Host "   Recommend running upgrade installer to clean up." -ForegroundColor Yellow
}

Write-Host "`n💡 Recommendations:" -ForegroundColor Cyan
$version = Get-InstalledVersion
switch ($version) {
    "Not Installed" {
        Write-Host "  • Install Dadir Defender v2.0 for latest features" -ForegroundColor White
    }
    "1.0 (Original)" {
        Write-Host "  • Upgrade to v2.0 for modular architecture and performance improvements" -ForegroundColor White
    }
    "1.x (Legacy)" {
        Write-Host "  • Upgrade to v2.0 for better log management and modular design" -ForegroundColor White
    }
    "2.0 (Modular)" {
        Write-Host "  • You have the latest version! ✅" -ForegroundColor Green
    }
}

if ($hasLegacy -and $hasModular) {
    Write-Host "  • Run install_with_upgrade.ps1 to clean up mixed installation" -ForegroundColor White
}