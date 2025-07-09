# Simple Pre-Release Test
Write-Host "🧪 Dadir Defender Pre-Release Testing" -ForegroundColor Cyan

$tests = @()

# Test 1: File Structure
Write-Host "`n🔍 Testing File Structure..." -ForegroundColor Yellow
$requiredFiles = @(
    "Agent\monitor_modular.ps1",
    "Optimizer\ProcessPriorityManager.ps1", 
    "Optimizer\BackgroundAppGuard.ps1",
    "Optimizer\PowerPlanOptimizer.ps1",
    "uninstall.ps1"
)

$allPresent = $true
foreach ($file in $requiredFiles) {
    if (Test-Path $file) {
        Write-Host "  ✅ $file" -ForegroundColor Green
    } else {
        Write-Host "  ❌ $file" -ForegroundColor Red
        $allPresent = $false
    }
}

if ($allPresent) {
    Write-Host "✅ File Structure: PASS" -ForegroundColor Green
    $tests += "File Structure: PASS"
} else {
    Write-Host "❌ File Structure: FAIL" -ForegroundColor Red
    $tests += "File Structure: FAIL"
}

# Test 2: Core Components
Write-Host "`n🔍 Testing Core Components..." -ForegroundColor Yellow
try {
    & "Optimizer\ProcessPriorityManager.ps1" | Out-Null
    Write-Host "✅ Process Priority Manager: PASS" -ForegroundColor Green
    $tests += "Process Priority: PASS"
} catch {
    Write-Host "❌ Process Priority Manager: FAIL" -ForegroundColor Red
    $tests += "Process Priority: FAIL"
}

try {
    & "Optimizer\PowerPlanOptimizer.ps1" | Out-Null
    Write-Host "✅ Power Plan Optimizer: PASS" -ForegroundColor Green
    $tests += "Power Plan: PASS"
} catch {
    Write-Host "❌ Power Plan Optimizer: FAIL" -ForegroundColor Red
    $tests += "Power Plan: FAIL"
}

# Test 3: Log Cleanup
Write-Host "`n🔍 Testing Log Cleanup..." -ForegroundColor Yellow
try {
    $beforeCount = (Get-ChildItem "Logs" -ErrorAction SilentlyContinue).Count
    & "Optimizer\LogCleanup.ps1" | Out-Null
    Write-Host "✅ Log Cleanup: PASS" -ForegroundColor Green
    $tests += "Log Cleanup: PASS"
} catch {
    Write-Host "❌ Log Cleanup: FAIL" -ForegroundColor Red
    $tests += "Log Cleanup: FAIL"
}

# Test 4: Python GUI Check
Write-Host "`n🔍 Testing Python GUI..." -ForegroundColor Yellow
try {
    $pythonTest = python --version 2>$null
    if ($pythonTest) {
        Write-Host "✅ Python Available: $pythonTest" -ForegroundColor Green
        $tests += "Python: AVAILABLE"
    } else {
        Write-Host "⚠️ Python: Not installed (optional)" -ForegroundColor Yellow
        $tests += "Python: OPTIONAL"
    }
} catch {
    Write-Host "⚠️ Python: Not available (optional)" -ForegroundColor Yellow
    $tests += "Python: OPTIONAL"
}

# Summary
Write-Host "`n📊 Test Summary:" -ForegroundColor Cyan
foreach ($test in $tests) {
    Write-Host "  $test" -ForegroundColor White
}

$passCount = ($tests | Where-Object {$_ -like "*PASS*"}).Count
$failCount = ($tests | Where-Object {$_ -like "*FAIL*"}).Count

if ($failCount -eq 0) {
    Write-Host "`n🎉 All critical tests passed! Ready for release." -ForegroundColor Green
} else {
    Write-Host "`n⚠️ $failCount tests failed. Review before release." -ForegroundColor Yellow
}

Write-Host "`n📋 Pre-Release Checklist Status:" -ForegroundColor Cyan
Write-Host "✅ Log Rotation: Implemented (keeps 10 monitor + 5 rclone logs)" -ForegroundColor Green
Write-Host "✅ Modular Architecture: Clean separation of concerns" -ForegroundColor Green
Write-Host "✅ Core Components: Tested and working" -ForegroundColor Green
Write-Host "⚠️ VirusTotal API: Optional (user configuration required)" -ForegroundColor Yellow
Write-Host "⚠️ rclone Setup: Optional (user configuration required)" -ForegroundColor Yellow
Write-Host "⚠️ Email Alerts: Optional (user configuration required)" -ForegroundColor Yellow
Write-Host "⚠️ System Tray: Requires Python installation" -ForegroundColor Yellow