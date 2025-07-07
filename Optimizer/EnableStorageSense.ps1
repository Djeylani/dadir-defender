Write-Host "Enabling Storage Sense..."

$regPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy"

if (Test-Path $regPath) {
    try {
        $settings = Get-ItemProperty -Path $regPath
        if ($settings.DisableStorageSense -eq 1) {
            Set-ItemProperty -Path $regPath -Name "DisableStorageSense" -Value 0
            Write-Host "Storage Sense has been enabled."
        } else {
            Write-Host "Storage Sense is already enabled."
        }
    } catch {
        Write-Host "Could not modify Storage Sense settings. Try running as Administrator."
    }
} else {
    Write-Host "Storage Sense appears to be enabled (registry key not found)."
}
