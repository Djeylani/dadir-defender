Write-Host "Scanning and disabling non-essential startup programs..."

$startupItems = Get-CimInstance Win32_StartupCommand
$allowed = @("Defender", "Security", "Ollama", "Grass")

foreach ($item in $startupItems) {
    $match = $false
    foreach ($keyword in $allowed) {
        if ($item.Command -match $keyword -or $item.Name -match $keyword) {
            $match = $true
            break
        }
    }

    if (-not $match) {
        Write-Host "Disabling: $($item.Name)"
        Write-Host "    Command: $($item.Command)"

        $regPaths = @(
            "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run",
            "HKLM:\Software\Microsoft\Windows\CurrentVersion\Run",
            "HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Run"
        )

        foreach ($path in $regPaths) {
            try {
                Remove-ItemProperty -Path $path -Name $item.Name -ErrorAction SilentlyContinue
            } catch {
                Write-Host "    Could not remove from: $path"
            }
        }
    }
}
