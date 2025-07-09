# Background App Guard
# Scans for non-essential apps consuming high RAM (Safe Mode)

param(
    [string]$LogFile = "",
    [switch]$SafeMode = $true
)

function Write-Log {
    param([string]$Message)
    if ($LogFile -ne "") {
        Add-Content $LogFile $Message
    }
    Write-Host $Message
}

Write-Log "`n=== Background App Guard $(if($SafeMode){'(Safe Mode)'}else{'(Active Mode)'}) ==="

# Define non-essential apps that can be terminated
$targetProcesses = @("spotify", "discord", "slack", "teams", "zoom", "skype", "steam", "epicgameslauncher", "origin", "uplay")
$ramThresholdMB = 100
$candidatesFound = @()

# Scan all running processes
Get-Process | Where-Object { $_.WorkingSet -gt ($ramThresholdMB * 1MB) } | ForEach-Object {
    $processName = $_.Name.ToLower()
    $ramUsageMB = [math]::Round($_.WorkingSet / 1MB, 2)
    
    # Check if this would be a termination candidate
    if ($targetProcesses -contains $processName) {
        if ($SafeMode) {
            Write-Log "CANDIDATE for termination: $($_.Name) (PID: $($_.Id)) - RAM: $ramUsageMB MB"
            $candidatesFound += "$($_.Name) ($ramUsageMB MB)"
        } else {
            try {
                Stop-Process -Id $_.Id -Force
                Write-Log "TERMINATED: $($_.Name) (PID: $($_.Id)) - RAM: $ramUsageMB MB"
                $candidatesFound += "$($_.Name) ($ramUsageMB MB)"
            } catch {
                Write-Log "Failed to terminate $($_.Name): $_"
            }
        }
    } elseif ($_.WorkingSet -gt (200 * 1MB)) {
        Write-Log "High RAM usage: $($_.Name) - $ramUsageMB MB (protected/not targeted)"
    }
}

if ($candidatesFound.Count -gt 0) {
    if ($SafeMode) {
        Write-Log "Found $($candidatesFound.Count) processes that could be terminated: $($candidatesFound -join ', ')"
        Write-Log "SAFE MODE: No processes were actually terminated"
    } else {
        Write-Log "Background App Guard terminated $($candidatesFound.Count) processes: $($candidatesFound -join ', ')"
    }
} else {
    Write-Log "No target processes found consuming >$ramThresholdMB MB RAM"
}