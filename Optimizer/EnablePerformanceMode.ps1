Write-Host "Enabling visual performance mode..."

# Set registry value to disable animations and effects
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "UserPreferencesMask" -Value ([byte[]](0x90,0x12,0x03,0x80,0x10,0x00,0x00,0x00))

# Restart Explorer to apply changes
Stop-Process -Name explorer -Force
Start-Process explorer

Write-Host "Visual performance mode enabled."
