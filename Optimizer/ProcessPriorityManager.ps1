# Process Priority Manager
# Boosts LLM processes and lowers resource-heavy app priorities

param(
    [string]$LogFile = ""
)

function Write-Log {
    param([string]$Message)
    if ($LogFile -ne "") {
        Add-Content $LogFile $Message
    }
    Write-Host $Message
}

Write-Log "`n=== Process Priority Manager ==="

# Define LLM-related processes to boost
$llmProcesses = @("ollama", "python", "node", "code", "devenv")
# Define processes to lower priority
$lowPriorityProcesses = @("chrome", "firefox", "msedge", "spotify", "discord", "teams")

# Boost LLM processes
foreach ($processName in $llmProcesses) {
    $processes = Get-Process -Name $processName -ErrorAction SilentlyContinue
    foreach ($proc in $processes) {
        try {
            $proc.PriorityClass = "High"
            Write-Log "Boosted priority: $($proc.Name) (PID: $($proc.Id))"
        } catch {
            Write-Log "Failed to boost $($proc.Name): $_"
        }
    }
}

# Lower priority for resource-heavy apps
foreach ($processName in $lowPriorityProcesses) {
    $processes = Get-Process -Name $processName -ErrorAction SilentlyContinue
    foreach ($proc in $processes) {
        try {
            $proc.PriorityClass = "BelowNormal"
            Write-Log "Lowered priority: $($proc.Name) (PID: $($proc.Id))"
        } catch {
            Write-Log "Failed to lower $($proc.Name): $_"
        }
    }
}