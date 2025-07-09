# Developer-Safe Services Optimizer
# Disables only non-essential services that won't affect development

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

Write-Log "`n=== Developer-Safe Services Optimizer ==="

# Check if running as administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Log "Services optimization requires administrator privileges"
    Write-Log "Run as administrator to optimize Windows services"
    return
}

# Only disable services that are 100% safe for developers
$safesToDisable = @(
    "Fax",                    # Fax service
    "TabletInputService"      # Tablet PC Input Service (safe to disable)
)

$disabledCount = 0
foreach ($serviceName in $safesToDisable) {
    try {
        $service = Get-Service -Name $serviceName -ErrorAction SilentlyContinue
        if ($service -and $service.StartType -ne "Disabled" -and $service.Status -eq "Running") {
            Stop-Service -Name $serviceName -Force -ErrorAction SilentlyContinue
            Set-Service -Name $serviceName -StartupType Disabled -ErrorAction Stop
            Write-Log "Disabled non-essential service: $serviceName"
            $disabledCount++
        } elseif ($service -and $service.StartType -eq "Disabled") {
            Write-Log "Service already disabled: $serviceName"
        } elseif (-not $service) {
            Write-Log "Service not found (may not be installed): $serviceName"
        }
    } catch {
        Write-Log "Could not modify service ${serviceName}: Access denied or protected"
    }
}

Write-Log "Developer-safe optimization: $disabledCount services disabled"
Write-Log "Note: All networking and development services preserved"