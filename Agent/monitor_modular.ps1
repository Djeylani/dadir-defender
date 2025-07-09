# ================================
# Dadir Defender - Modular Monitor
# Calls individual optimization modules
# ================================

param(
    [switch]$OptimizeOnly,
    [switch]$MonitorOnly
)

# Setup
$timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$logPath = "C:\DadirDefender\Logs"
$logFile = "$logPath\monitor_$timestamp.txt"
$optimizerPath = "C:\DadirDefender\Optimizer"

if (!(Test-Path $logPath)) {
    New-Item -ItemType Directory -Path $logPath | Out-Null
}

Add-Content $logFile "Dadir Defender Monitor started at $(Get-Date)"
Write-Host "🛡️ Dadir Defender Monitor" -ForegroundColor Cyan

if (-not $MonitorOnly) {
    Write-Host "🔧 Running System Optimizations..." -ForegroundColor Yellow
    
    # Core optimizations (run every time)
    & "$optimizerPath\ProcessPriorityManager.ps1" -LogFile $logFile
    & "$optimizerPath\PowerPlanOptimizer.ps1" -LogFile $logFile
    & "$optimizerPath\BackgroundAppGuard.ps1" -LogFile $logFile -SafeMode
    & "$optimizerPath\LogCleanup.ps1" -LogFile $logFile
}

if (-not $OptimizeOnly) {
    Write-Host "📊 System Monitoring..." -ForegroundColor Yellow
    
    # Basic system metrics
    Add-Content $logFile "`n=== System Metrics ==="
    $cpu = Get-CimInstance Win32_Processor | Measure-Object -Property LoadPercentage -Average | Select-Object -ExpandProperty Average
    $ram = Get-CimInstance Win32_OperatingSystem
    
    Add-Content $logFile "CPU Load: $cpu%"
    Add-Content $logFile "RAM Usage: $([math]::Round(($ram.TotalVisibleMemorySize - $ram.FreePhysicalMemory)/1MB, 2)) MB / $([math]::Round($ram.TotalVisibleMemorySize/1MB, 2)) MB"
    
    if ($cpu -gt 80) {
        Add-Content $logFile "⚠️ High CPU usage detected: $cpu%"
        Write-Host "⚠️ High CPU usage: $cpu%" -ForegroundColor Red
    }
}

Add-Content $logFile "Dadir Defender Monitor completed at $(Get-Date)"
Write-Host "✅ Monitor completed successfully." -ForegroundColor Green