# 🛡️ Dadir Defender v2.0 - Release Notes

## 🚀 Major Features

### ✨ **Modular Architecture**
- **Individual optimization components** in `Optimizer/` folder
- **Clean separation** of monitoring, optimization, and maintenance
- **Parameterized scripts** with logging support
- **Easy customization** - modify individual components without affecting others

### 🎯 **LLM Performance Optimization**
- **Process Priority Manager**: Boosts Python, Node.js, VS Code, Ollama to High priority
- **Background App Guard**: Monitors resource-heavy apps (Safe scan mode by default)
- **Power Plan Optimizer**: Automatically switches to High Performance mode
- **Visual Performance Mode**: Disables Windows animations for better responsiveness

### 🧹 **Intelligent System Maintenance**
- **Smart Log Cleanup**: Keeps only newest 10 monitor logs + 5 rclone logs
- **Space Efficiency**: 99.94% log folder size reduction (157MB → 0.1MB)
- **Smart Upload System**: Daily uploads or event-based only (no more flooding)
- **Developer-Safe Services**: Only disables truly non-essential services

## 📁 **New File Structure**

```
DadirDefender/
├── Agent/
│   └── monitor_modular.ps1          # Main orchestrator
├── Optimizer/
│   ├── ProcessPriorityManager.ps1   # LLM process boosting
│   ├── BackgroundAppGuard.ps1       # RAM usage monitoring
│   ├── PowerPlanOptimizer.ps1       # High Performance mode
│   ├── ServicesOptimizer.ps1        # Safe service management
│   ├── LogCleanup.ps1               # Intelligent cleanup
│   ├── EnablePerformanceMode.ps1    # Visual effects optimization
│   └── Optimizer.ps1                # Master orchestrator
├── UI/
│   └── dashboard.py                 # Python GUI (requires Python)
└── uninstall.ps1                   # Clean removal script
```

## 🔧 **Usage Options**

### **Quick Start (Core Features)**
```powershell
# Run all optimizations
powershell -File "Agent\monitor_modular.ps1"

# Optimization only (no monitoring)
powershell -File "Agent\monitor_modular.ps1" -OptimizeOnly

# Individual components
powershell -File "Optimizer\ProcessPriorityManager.ps1"
```

### **Full System Optimization**
```powershell
# Complete optimization suite
powershell -File "Optimizer\Optimizer.ps1"
```

## ⚙️ **Configuration (Optional)**

### **Email Alerts** (Optional)
Edit scripts to replace placeholder emails:
- `$emailFrom = "your-email@gmail.com"`
- `$emailTo = "alert-recipient@gmail.com"`
- Use Gmail app passwords for authentication

### **Google Drive Backup** (Optional)
1. Download rclone from https://rclone.org/downloads/
2. Extract to `C:\rclone\`
3. Run `rclone config` and create 'gdrive' remote

### **VirusTotal Integration** (Optional)
1. Get free API key from https://www.virustotal.com/gui/join
2. Install: `Install-Module CredentialManager`
3. Store: `cmdkey /generic:VirusTotalAPI /user:api /pass:YOUR_API_KEY`

### **Python GUI** (Optional)
1. Install Python from https://python.org
2. Run: `python UI\dashboard.py`

## 🛠️ **Installation**

### **Method 1: Download & Run**
1. Download and extract to `C:\DadirDefender\`
2. Run as Administrator: `powershell -File "Agent\monitor_modular.ps1"`

### **Method 2: Git Clone**
```bash
git clone https://github.com/Djeylani/dadir-defender.git
cd dadir-defender
powershell -File "Agent\monitor_modular.ps1"
```

## 🔒 **Security & Safety**

- ✅ **Developer-Safe**: Won't interfere with development tools or networking
- ✅ **Credential Protection**: No hardcoded credentials in repository
- ✅ **Safe Mode Default**: Background App Guard only scans by default
- ✅ **Admin Awareness**: Gracefully handles non-admin scenarios
- ✅ **Clean Uninstall**: Complete removal script included

## 📊 **Performance Impact**

### **Verified Results:**
- **VS Code processes**: High Priority ✅
- **Browser processes**: BelowNormal Priority ✅
- **Log folder size**: 99.94% reduction ✅
- **Upload frequency**: 95% reduction ✅
- **System responsiveness**: Significantly improved ✅

## 🆕 **What's New in v2.0**

- 🔧 **Complete modular refactor** - no more monolithic scripts
- 🧹 **Fixed log flooding issue** - intelligent cleanup and uploads
- 🎯 **Enhanced LLM optimization** - better process priority management
- 🛡️ **Improved safety** - developer-friendly service optimization
- 📦 **Better organization** - clean file structure and separation of concerns
- 🔄 **Smart automation** - event-based uploads and maintenance

## 🐛 **Bug Fixes**

- Fixed log folder bloating (157MB → 0.1MB)
- Eliminated constant rclone uploads
- Resolved service flooding issues
- Improved error handling and graceful fallbacks
- Fixed PowerShell syntax errors in various components

## 🔄 **Migration from v1.x**

If upgrading from v1.x:
1. Run the included `uninstall.ps1` as Administrator
2. Remove old installation directory
3. Install v2.0 fresh
4. Reconfigure optional components (email, rclone, etc.)

## ⚠️ **Known Limitations**

- **Python GUI**: Requires Python installation
- **Some features**: Require Administrator privileges
- **Email/Cloud**: Need user configuration for full functionality
- **Windows only**: Designed specifically for Windows 10/11

## 🤝 **Support**

- **Issues**: https://github.com/Djeylani/dadir-defender/issues
- **Documentation**: See README.md for detailed setup
- **Configuration Help**: Run `setup_validator.ps1` for guidance

---

**⚠️ Disclaimer**: This tool is for legitimate system monitoring and optimization purposes only. Users are responsible for compliance with applicable laws and regulations.