# Enhanced Log and Junk Cleanup
# Aggressive cleanup of old logs and temporary files

param(
    [string]$LogPath = "C:\DadirDefender\Logs",
    [string]$LogFile = ""
)

function Write-Log {
    param([string]$Message)
    if ($LogFile -ne "") {
        Add-Content $LogFile $Message
    }
    Write-Host $Message
}

Write-Log "`n=== Enhanced Log and Junk Cleanup ==="

# Clean old monitor logs (keep only last 10 files)
$allLogs = Get-ChildItem "$LogPath\monitor_*.txt" | Sort-Object LastWriteTime -Descending
$logsToKeep = $allLogs | Select-Object -First 10
$logsToRemove = $allLogs | Where-Object { $logsToKeep -notcontains $_ }
$oldLogCount = $logsToRemove.Count
$logsToRemove | Remove-Item -Force
Write-Log "Removed $oldLogCount old monitor logs (keeping newest 10)"

# Clean old rclone upload logs (keep only last 5 files)
$allRcloneLogs = Get-ChildItem "$LogPath\rclone_upload_*.log" | Sort-Object LastWriteTime -Descending
$rcloneToKeep = $allRcloneLogs | Select-Object -First 5
$rcloneToRemove = $allRcloneLogs | Where-Object { $rcloneToKeep -notcontains $_ }
$oldRcloneCount = $rcloneToRemove.Count
$rcloneToRemove | Remove-Item -Force
Write-Log "Removed $oldRcloneCount old rclone logs (keeping newest 5)"

# Calculate total log folder size
$logFolderSize = [math]::Round((Get-ChildItem $LogPath -Recurse | Measure-Object -Property Length -Sum).Sum / 1MB, 2)
Write-Log "Current log folder size: $logFolderSize MB"

# Clean system junk paths
$junkPaths = @(
    "$env:TEMP",
    "$env:USERPROFILE\AppData\Local\Temp",
    "C:\Windows\Temp"
)

foreach ($path in $junkPaths) {
    if (Test-Path $path) {
        $beforeCount = (Get-ChildItem -Path $path -Recurse -Force -ErrorAction SilentlyContinue).Count
        Get-ChildItem -Path $path -Recurse -Force -ErrorAction SilentlyContinue |
        Where-Object { !$_.PSIsContainer -or @(Get-ChildItem $_.FullName -Force -ErrorAction SilentlyContinue).Count -eq 0 } |
        Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
        $afterCount = (Get-ChildItem -Path $path -Recurse -Force -ErrorAction SilentlyContinue).Count
        Write-Log "Cleaned $path: $($beforeCount - $afterCount) items removed"
    }
}