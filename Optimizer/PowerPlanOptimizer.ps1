# Power Plan Optimizer
# Switches to High Performance power plan for optimal LLM performance

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

Write-Log "`n=== Power Plan Optimizer ==="

# Get current power plan
$currentPlan = powercfg /getactivescheme
Write-Log "Current power plan: $currentPlan"

# Check if high performance plan is active
if ($currentPlan -notlike "*High performance*" -and $currentPlan -notlike "*Ultimate Performance*") {
    try {
        # Get High Performance GUID
        $highPerfGuid = (powercfg /list | Select-String "High performance").ToString().Split()[3]
        
        if ($highPerfGuid) {
            # Switch to High Performance
            powercfg /setactive $highPerfGuid
            Write-Log "Switched to High Performance power plan for optimal LLM performance"
            
            # Disable USB selective suspend
            powercfg /change usb-selective-suspend-setting 0
            Write-Log "Disabled USB selective suspend"
        } else {
            Write-Log "High Performance power plan not found, keeping current plan"
        }
    } catch {
        Write-Log "Failed to change power plan: $_"
    }
} else {
    Write-Log "Already using high performance power plan"
}