# ================================
# Setup Configuration Validator
# Helps users configure optional components
# ================================

Write-Host "🔧 Dadir Defender Setup Validator" -ForegroundColor Cyan
Write-Host "==================================" -ForegroundColor Cyan

$configResults = @()

function Test-OptionalComponent {
    param(
        [string]$Name,
        [string]$Description,
        [scriptblock]$TestScript,
        [scriptblock]$SetupInstructions = $null
    )
    
    Write-Host "`n🔍 Checking: $Name" -ForegroundColor Yellow
    Write-Host "   $Description" -ForegroundColor Gray
    
    try {
        $result = & $TestScript
        Write-Host "   ✅ $result" -ForegroundColor Green
        $script:configResults += @{Component=$Name; Status="OK"; Details=$result}
    } catch {
        Write-Host "   ⚠️ Not configured: $_" -ForegroundColor Yellow
        $script:configResults += @{Component=$Name; Status="MISSING"; Details=$_.Exception.Message}
        
        if ($SetupInstructions) {
            Write-Host "   📝 Setup Instructions:" -ForegroundColor Cyan
            & $SetupInstructions
        }
    }
}

# Check VirusTotal API
Test-OptionalComponent "VirusTotal API" "Malware scanning integration" {
    try {
        Import-Module CredentialManager -ErrorAction Stop
        $vtCred = Get-StoredCredential -Target "VirusTotalAPI" -ErrorAction Stop
        if ($vtCred) {
            return "API key configured and accessible"
        } else {
            throw "No API key found"
        }
    } catch {
        throw "CredentialManager module or API key not found"
    }
} {
    Write-Host "      1. Get free API key from https://www.virustotal.com/gui/join" -ForegroundColor White
    Write-Host "      2. Install CredentialManager: Install-Module CredentialManager" -ForegroundColor White
    Write-Host "      3. Store key: cmdkey /generic:VirusTotalAPI /user:api /pass:YOUR_API_KEY" -ForegroundColor White
}

# Check rclone
Test-OptionalComponent "rclone (Google Drive)" "Automatic log backup to cloud" {
    $rclonePath = "C:\rclone\rclone.exe"
    if (!(Test-Path $rclonePath)) {
        throw "rclone not installed"
    }
    
    $configTest = & $rclonePath config show 2>$null
    if ($configTest -like "*gdrive*") {
        return "Configured with Google Drive remote"
    } else {
        throw "Installed but not configured"
    }
} {
    Write-Host "      1. Download from https://rclone.org/downloads/" -ForegroundColor White
    Write-Host "      2. Extract to C:\rclone\" -ForegroundColor White
    Write-Host "      3. Run: rclone config" -ForegroundColor White
    Write-Host "      4. Create 'gdrive' remote for Google Drive" -ForegroundColor White
}

# Check Python GUI
Test-OptionalComponent "Python GUI" "Desktop dashboard interface" {
    $pythonTest = python --version 2>$null
    if (!$pythonTest) {
        throw "Python not installed"
    }
    
    $importTest = python -c "import tkinter, threading, subprocess; print('OK')" 2>$null
    if ($importTest -like "*OK*") {
        return "Python and GUI dependencies available"
    } else {
        throw "Python found but GUI packages missing"
    }
} {
    Write-Host "      1. Install Python from https://python.org" -ForegroundColor White
    Write-Host "      2. Ensure tkinter is included (usually default)" -ForegroundColor White
    Write-Host "      3. Test: python -c 'import tkinter'" -ForegroundColor White
}

# Check Email Configuration
Test-OptionalComponent "Email Alerts" "Security notifications via email" {
    # Check if user has configured email in any script
    $emailConfigured = $false
    $configFiles = @("Agent\monitor_modular.ps1")
    
    foreach ($file in $configFiles) {
        if (Test-Path "C:\DadirDefender\$file") {
            $content = Get-Content "C:\DadirDefender\$file" -Raw
            if ($content -notlike "*your-email@gmail.com*" -and $content -like "*@*") {
                $emailConfigured = $true
                break
            }
        }
    }
    
    if ($emailConfigured) {
        return "Email configuration detected in scripts"
    } else {
        throw "Default placeholder email addresses found"
    }
} {
    Write-Host "      1. Edit monitor scripts to replace placeholder emails" -ForegroundColor White
    Write-Host "      2. Use Gmail app passwords for authentication" -ForegroundColor White
    Write-Host "      3. Test SMTP connectivity before deployment" -ForegroundColor White
}

# Summary
Write-Host "`n📊 Configuration Summary:" -ForegroundColor Cyan
Write-Host "=========================" -ForegroundColor Cyan

$okCount = ($configResults | Where-Object {$_.Status -eq "OK"}).Count
$missingCount = ($configResults | Where-Object {$_.Status -eq "MISSING"}).Count

foreach ($result in $configResults) {
    $color = if ($result.Status -eq "OK") { "Green" } else { "Yellow" }
    Write-Host "$($result.Status): $($result.Component)" -ForegroundColor $color
}

Write-Host "`n📈 Status: $okCount configured, $missingCount optional" -ForegroundColor Cyan

if ($missingCount -gt 0) {
    Write-Host "`n💡 Note: Missing components are optional. Core functionality works without them." -ForegroundColor Blue
}

Write-Host "`n🚀 Ready to proceed with release!" -ForegroundColor Green