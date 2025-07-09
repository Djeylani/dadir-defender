# Dadir Defender - Complete System Optimizer
# Modular approach with individual optimization scripts

param(
    [string]$LogFile = "C:\DadirDefender\Logs\optimizer_$(Get-Date -Format 'yyyy-MM-dd_HH-mm-ss').txt"
)

$base = "C:\DadirDefender\Optimizer"

Write-Host "🛡️ Running Dadir Defender Optimizer..." -ForegroundColor Cyan
Add-Content $LogFile "Dadir Defender Optimizer started at $(Get-Date)"

# Core System Optimizations
Write-Host "📊 Process Priority Management..." -ForegroundColor Yellow
& "$base\ProcessPriorityManager.ps1" -LogFile $LogFile

Write-Host "⚡ Power Plan Optimization..." -ForegroundColor Yellow
& "$base\PowerPlanOptimizer.ps1" -LogFile $LogFile

Write-Host "🎨 Visual Performance Mode..." -ForegroundColor Yellow
& "$base\EnablePerformanceMode.ps1"

Write-Host "🔧 Services Optimization..." -ForegroundColor Yellow
& "$base\ServicesOptimizer.ps1" -LogFile $LogFile

# Background Monitoring
Write-Host "🛡️ Background App Guard (Safe Scan)..." -ForegroundColor Yellow
& "$base\BackgroundAppGuard.ps1" -LogFile $LogFile -SafeMode

# System Maintenance
Write-Host "🧹 Log and Junk Cleanup..." -ForegroundColor Yellow
& "$base\LogCleanup.ps1" -LogFile $LogFile

Write-Host "💾 Storage Optimization..." -ForegroundColor Yellow
& "$base\EnableStorageSense.ps1"
& "$base\OptimizeDrives.ps1"

# Startup and Indexing
Write-Host "🚀 Startup Optimization..." -ForegroundColor Yellow
& "$base\DisableStartupApps.ps1"
& "$base\DisableIndexing.ps1"

Add-Content $LogFile "Dadir Defender Optimizer completed at $(Get-Date)"
Write-Host "✅ Optimization complete. System ready for LLM workloads!" -ForegroundColor Green
