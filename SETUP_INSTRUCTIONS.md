# 🔧 Setup Instructions

## ⚠️ IMPORTANT: Security Configuration

Before using Dadir Defender, you MUST configure your credentials securely.

### 1. Email Configuration

**Option A: Direct Configuration (Less Secure)**
1. Copy `Agent/monitor_clean.ps1` to `Agent/monitor.ps1`
2. Edit the email settings in `monitor.ps1`:
```powershell
$emailFrom = "your-actual-email@gmail.com"
$emailTo = "recipient@gmail.com"
$emailPassword = "your-app-password"  # Use Gmail App Password, not regular password
```

**Option B: Configuration File (Recommended)**
1. Copy `config.example.ini` to `config.ini`
2. Fill in your actual credentials
3. Modify the script to read from config file

**Option C: Windows Credential Manager (Most Secure)**
```powershell
# Store email credentials securely
cmdkey /generic:DadirDefenderEmail /user:your-email@gmail.com /pass:your-app-password
```

### 2. VirusTotal API Setup

1. Get free API key from [VirusTotal](https://www.virustotal.com/gui/join-us)
2. **Free tier limits: 4 requests/minute, 500/day**
3. Store securely:
```powershell
cmdkey /generic:VirusTotalAPI /user:api /pass:your-vt-api-key
```

### 3. Google Drive Setup (Optional)

1. Install [rclone](https://rclone.org/downloads/)
2. Configure Google Drive:
```bash
rclone config
# Choose Google Drive and follow prompts
# Name the remote "gdrive"
```

## 🚨 Security Warnings

- **NEVER** commit real credentials to version control
- Use Gmail App Passwords, not your regular password
- Monitor your API usage to avoid exceeding free limits
- The original `monitor.ps1` contains your credentials - keep it local only

## 📝 File Structure After Setup

```
DadirDefender/
├── Agent/
│   ├── monitor_clean.ps1    # Template (safe for GitHub)
│   └── monitor.ps1          # Your configured version (DO NOT COMMIT)
├── config.ini               # Your settings (DO NOT COMMIT)
└── ...
```

## ✅ Verification

Test your setup:
```powershell
# Test email alerts
powershell -File "C:\DadirDefender\Agent\monitor.ps1"

# Check logs
dir "C:\DadirDefender\Logs"
```

## 🔄 Updates

When updating from GitHub:
1. Your `monitor.ps1` and `config.ini` are protected by `.gitignore`
2. Only `monitor_clean.ps1` will be updated
3. Merge any new features manually into your configured version