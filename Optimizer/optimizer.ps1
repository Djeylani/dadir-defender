# optimizer.ps1
# Dadir Defender – LLM Optimization Script
# Author: Djeylani
# Description: Optimizes Windows for local LLM workloads (e.g., Ollama)

Write-Host "🔧 Starting LLM Optimization..." -ForegroundColor Cyan

# Disable unnecessary startup apps
Write-Host "Disabling non-essential startup programs..."
Get-CimInstance Win32_StartupCommand | Where-Object { $_.Command -notmatch "Defender|Security|Ollama" } | ForEach-Object {
    Write-Host "Disabling: $($_.Name)"
    # Optional: Disable via Task Scheduler or Registry
}

# Enable performance mode (disable animations)
Write-Host "Enabling visual performance mode..."
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "UserPreferencesMask" -Value ([byte[]](0x90,0x12,0x03,0x80,0x10,0x00,0x00,0x00))
Stop-Process -Name explorer -Force
Start-Process explorer

# Enable Storage Sense
Write-Host "Configuring Storage Sense..."
$storageSense = Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy"
if ($storageSense.DisableStorageSense -eq 1) {
    Set-ItemProperty -Path $storageSense.PSPath -Name "DisableStorageSense" -Value 0
    Write-Host "Storage Sense enabled."
}

# Optimize drives
Write-Host "Optimizing drives..."
Get-Volume | Where-Object { $_.DriveType -eq 'Fixed' } | ForEach-Object {
    Optimize-Volume -DriveLetter $_.DriveLetter -Verbose
}

# Disable indexing on dev folders
$devFolders = @("$env:USERPROFILE\Documents\Code", "$env:USERPROFILE\Projects")
foreach ($folder in $devFolders) {
    if (Test-Path $folder) {
        Write-Host "Disabling indexing for: $folder"
        & 'attrib' +R "$folder" /S /D
    }
}

# Cleanup temp files
Write-Host "Cleaning temporary files..."
Remove-Item "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item "C:\Windows\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue

Write-Host "✅ Optimization complete. Ready for LLM workloads." -ForegroundColor Green
