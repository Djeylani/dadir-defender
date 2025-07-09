# 🛡️ Dadir Defender

**A comprehensive Windows security monitoring agent with GUI dashboard**

![Version](https://img.shields.io/badge/version-2.0-blue.svg)
![Platform](https://img.shields.io/badge/platform-Windows-lightgrey.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)

## 🚀 Features

### PowerShell Monitoring Agent
- **RDP Security**: Monitors and alerts on failed RDP login attempts
- **System Metrics**: Tracks CPU, RAM, and disk usage with threshold alerts
- **Cloud Backup**: Automatically uploads logs to Google Drive via rclone
- **Threat Detection**: Scans running processes with VirusTotal API integration
- **System Cleanup**: Removes junk files and optimizes disk space
- **Email Alerts**: Sends notifications for security events and system issues

### Python GUI Dashboard
- **Real-time Monitoring**: Live system metrics display
- **Log Viewer**: Browse and analyze monitoring logs
- **Manual Controls**: Trigger cleanup and monitoring tasks
- **System Tray**: Minimizes to tray with restore/exit options
- **Modern UI**: Dark theme with intuitive interface

### Service Integration
- Runs as Windows service using NSSM
- Autonomous background monitoring
- Automatic startup with system boot

## 📁 Project Structure

```
DadirDefender/
├── Agent/
│   └── monitor.ps1          # PowerShell monitoring script
├── UI/
│   ├── dashboard.py         # Python GUI application
│   ├── assets/
│   │   └── icon.png        # Application icon
│   └── dashboard.spec       # PyInstaller configuration
├── Installer/
│   └── DadirDefenderSetup.exe  # Inno Setup installer
└── Logs/                    # Generated log files
```

## 🔧 Installation

### Prerequisites
- Windows 10/11
- PowerShell 5.1+
- Python 3.8+ (optional, for GUI)
- Administrator privileges (for full functionality)

### 🆕 **Upgrade-Aware Installation (v2.0)**
```powershell
# Download and run the upgrade-aware installer
powershell -File "install_with_upgrade.ps1"
```

**Features:**
- ✅ **Detects existing installations**
- ✅ **Backs up user configuration**
- ✅ **Clean upgrade process**
- ✅ **Handles service conflicts**

### Quick Install (New Users)
1. Download release package
2. Extract to desired location
3. Run as Administrator: `powershell -File "install_with_upgrade.ps1"`
4. Configure optional features using `setup_validator.ps1`

### Manual Setup
```bash
# Clone repository
git clone https://github.com/yourusername/dadir-defender.git
cd dadir-defender

# Install Python dependencies
pip install -r requirements.txt

# Run dashboard
python UI/dashboard.py
```

## ⚙️ Configuration

### Email Alerts
Edit `Agent/monitor.ps1` and update email settings:
```powershell
$smtpServer = "smtp.gmail.com"
$emailFrom = "your-email@gmail.com"
$emailTo = "alert-recipient@gmail.com"
$emailPassword = "your-app-password"
```

### VirusTotal Integration
Store your API key securely:
```powershell
# Store VirusTotal API key
cmdkey /generic:VirusTotalAPI /user:api /pass:your-vt-api-key
```

### Google Drive Backup
Configure rclone for automatic log uploads:
```bash
rclone config
# Follow prompts to set up Google Drive remote named "gdrive"
```

## 🚀 Usage

### GUI Dashboard
- Launch from Start Menu or Desktop shortcut
- View real-time system metrics
- Browse monitoring logs
- Trigger manual cleanup
- Minimize to system tray

### Service Mode
```powershell
# Install as Windows service
nssm install "DadirDefender" "powershell.exe" "-File C:\DadirDefender\Agent\monitor.ps1"
nssm start "DadirDefender"
```

### Manual Execution
```powershell
# Run monitoring script once
powershell -ExecutionPolicy Bypass -File "C:\DadirDefender\Agent\monitor.ps1"
```

## 📊 Monitoring Features

- **Failed RDP Attempts**: Detects and logs suspicious login attempts
- **System Performance**: CPU, RAM, and disk usage tracking
- **Process Analysis**: Identifies suspicious or hidden processes
- **Automated Cleanup**: Removes temporary files and old logs
- **Threat Intelligence**: VirusTotal integration for malware detection
- **Cloud Logging**: Secure backup of all monitoring data

## 🔒 Security

- Credentials stored using Windows Credential Manager
- Secure email transmission with TLS
- API keys protected with system-level encryption
- Log files uploaded to encrypted cloud storage

## 🛠️ Development

### Building Executable
```bash
# Install PyInstaller
pip install pyinstaller

# Build GUI executable
pyinstaller --onefile --windowed --icon=UI/assets/icon.png UI/dashboard.py
```

### Creating Installer
Use Inno Setup with the provided script to create `DadirDefenderSetup.exe`

## 📌 Roadmap

[![Project Board](https://img.shields.io/badge/Project-Dadir_Defender_v1.1-blue?style=flat-square&logo=github)](https://github.com/users/Djeylani/projects/2/views/1)

Track upcoming features and improvements for the next release.

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📞 Support

- Create an issue for bug reports
- Check existing issues before posting
- Provide system information and logs when reporting problems

## 🔄 Changelog

### v2.0 (Current) - Major Modular Refactor
- 🔧 **Modular Architecture**: Individual optimization components
- 🎨 **LLM Performance**: Process priority optimization for development tools
- 🧹 **Smart Cleanup**: 99.94% log space reduction (157MB → 0.1MB)
- 📶 **Intelligent Uploads**: Daily/event-based only (no flooding)
- 🔒 **Enhanced Safety**: Developer-friendly, no workflow disruption
- 📦 **Upgrade Support**: Detects and handles existing installations

### v1.0 (Legacy)
- Initial release
- PowerShell monitoring agent
- Python GUI dashboard
- Windows service integration
- Installer package

**🔄 Upgrading from v1.x?** Use `install_with_upgrade.ps1` for seamless migration.

---

**⚠️ Disclaimer**: This tool is for legitimate system monitoring purposes only. Users are responsible for compliance with applicable laws and regulations.
