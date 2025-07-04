# ================================
# Windows Monitoring Agent Script
# Author: Dadir
# Purpose: Custom Defender-style agent with monitoring, alerting, cleanup, and threat detection
# ================================

# --- Section 0: Email Alert Settings ---
$smtpServer = "smtp.gmail.com"
$smtpPort = 587
$emailFrom = "your-email@gmail.com"
$emailTo = "alert-recipient@gmail.com"
$emailPassword = "your-app-password"

function Send-Alert {
    param (
        [string]$subject,
        [string]$body
    )
    try {
        $securePassword = ConvertTo-SecureString $emailPassword -AsPlainText -Force
        $cred = New-Object System.Management.Automation.PSCredential ($emailFrom, $securePassword)
        Send-MailMessage -From $emailFrom -To $emailTo -Subject $subject -Body $body -SmtpServer $smtpServer -Port $smtpPort -UseSsl -Credential $cred
        Write-Host "Alert sent: $subject"
    } catch {
        Write-Host "❌ Failed to send alert: $_"
    }
}

# --- Section 1: Setup Variables ---
$timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$logPath = "C:\DadirDefender\Logs"
$logFile = "$logPath\monitor_$timestamp.txt"
$rclonePath = "C:\rclone\rclone.exe"
$remoteFolder = "gdrive:/VM-Backups"

if (!(Test-Path $logPath)) {
    New-Item -ItemType Directory -Path $logPath | Out-Null
}

# --- Section 2: Detect Failed RDP Logins ---
Add-Content $logFile "`n=== Failed RDP Login Attempts ==="
$events = Get-WinEvent -FilterHashtable @{LogName = 'Security'; Id = 4625 } -MaxEvents 100
$rdpFailures = $events | Where-Object { $_.Message -like "*Logon Type:\s+10*" }

$rdpFailures | ForEach-Object {
    $ip = ($_ | Select-String -Pattern "Source Network Address:\s+(\d{1,3}\.){3}\d{1,3}").Matches.Value
    Add-Content $logFile "$($_.TimeCreated) - Failed login from $ip"
}

if ($rdpFailures.Count -gt 0) {
    $body = $rdpFailures | ForEach-Object { $_.Message } -join "`n"
    Send-Alert -subject "[RDP Alert] Failed Logins on $env:COMPUTERNAME" -body $body
}

# --- Section 3: Log System Metrics ---
Add-Content $logFile "`n=== System Metrics ==="
$cpu = Get-CimInstance Win32_Processor | Measure-Object -Property LoadPercentage -Average | Select-Object -ExpandProperty Average
$ram = Get-CimInstance Win32_OperatingSystem
$disk = Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3"

Add-Content $logFile "CPU Load: $cpu%"
Add-Content $logFile "RAM Usage: $([math]::Round(($ram.TotalVisibleMemorySize - $ram.FreePhysicalMemory)/1MB, 2)) MB / $([math]::Round($ram.TotalVisibleMemorySize/1MB, 2)) MB"
$disk | ForEach-Object {
    $used = [math]::Round((($_.Size - $_.FreeSpace) / 1GB), 2)
    $total = [math]::Round(($_.Size / 1GB), 2)
    Add-Content $logFile "Drive $($_.DeviceID): $used GB / $total GB used"
}

if ($cpu -gt 80) {
    Send-Alert -subject "[CPU Alert] High Load on $env:COMPUTERNAME" -body "CPU Load is at $cpu%"
}

# --- Section 4: Upload to Google Drive ---
Add-Content $logFile "`n=== Uploading to Google Drive ==="
try {
    & "$rclonePath" copy $logFile "$remoteFolder" --log-file="$logPath\rclone_upload_$timestamp.log"
    Add-Content $logFile "Upload complete at $(Get-Date)"
} catch {
    Add-Content $logFile "❌ Rclone upload failed: $_"
}

# --- Section 5: Cleanup Old Logs and Junk ---
Add-Content $logFile "`n=== Cleaning Old Logs and Junk Files ==="
Get-ChildItem "$logPath\monitor_*.txt" | Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-7) } | Remove-Item -Force

$junkPaths = @(
    "$env:TEMP",
    "$env:USERPROFILE\AppData\Local\Temp",
    "C:\Windows\Temp"
)

foreach ($path in $junkPaths) {
    if (Test-Path $path) {
        Get-ChildItem -Path $path -Recurse -Force -ErrorAction SilentlyContinue |
        Where-Object { !$_.PSIsContainer -or @(Get-ChildItem $_.FullName -Force -ErrorAction SilentlyContinue).Count -eq 0 } |
        Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
    }
}

# --- Section 6: Suspicious Process Scan ---
Add-Content $logFile "`n=== Suspicious Process Scan ==="
$badProcesses = @()
Get-Process | ForEach-Object {
    try {
        $path = $_.Path
        if ($path -and !(Test-Path $path -PathType Leaf)) {
            $badProcesses += "$($_.Name) - Invalid path"
        }
    } catch {
        $badProcesses += "$($_.Name) - Access denied or hidden"
    }
}

if ($badProcesses.Count -gt 0) {
    $badProcesses | ForEach-Object { Add-Content $logFile $_ }
    Send-Alert -subject "[Process Alert] Suspicious Processes on $env:COMPUTERNAME" -body ($badProcesses -join "`n")
}

# --- Section 7: Disk Optimization (Weekly) ---
if ((Get-Date).DayOfWeek -eq 'Sunday') {
    Add-Content $logFile "`n=== Running Disk Optimization ==="
    Start-Process -FilePath "defrag.exe" -ArgumentList "C: /O" -Verb RunAs
}

# --- Section 8: VirusTotal Scan with Rate Limiting ---
$vtApiKey = ""  # Set your API key here or use credential manager
$vtThreshold = 5
$maxVtRequests = 4  # Free tier: 4 requests per minute
$vtRequestCount = 0

if ($vtApiKey -ne "") {
    Add-Content $logFile "`n=== VirusTotal Scan (Rate Limited) ==="
    $exePaths = Get-Process | Where-Object { $_.Path -and (Test-Path $_.Path) } | Select-Object -ExpandProperty Path -Unique | Select-Object -First $maxVtRequests

    foreach ($path in $exePaths) {
        if ($vtRequestCount -ge $maxVtRequests) {
            Add-Content $logFile "VT rate limit reached, stopping scan"
            break
        }
        
        try {
            $hash = (Get-FileHash -Path $path -Algorithm SHA256).Hash
            $vtUrl = "https://www.virustotal.com/api/v3/files/$hash"
            $headers = @{ "x-apikey" = $vtApiKey }

            $response = Invoke-RestMethod -Uri $vtUrl -Headers $headers -Method Get -ErrorAction Stop
            $detections = $response.data.attributes.last_analysis_stats.malicious
            $vtRequestCount++

            if ($detections -ge $vtThreshold) {
                $msg = "$path flagged by VirusTotal ($detections detections)"
                Add-Content $logFile $msg
                Send-Alert -subject "[VirusTotal Alert] $env:COMPUTERNAME" -body $msg
            }
            
            Start-Sleep -Seconds 15  # Rate limiting: 4 requests per minute
        } catch {
            Add-Content $logFile "VT scan failed for ${path}: $_"
            $vtRequestCount++
        }
    }
} else {
    Add-Content $logFile "`n=== VirusTotal Scan Skipped (No API Key) ==="
}