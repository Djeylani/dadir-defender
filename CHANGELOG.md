# Changelog

All notable changes to Dadir Defender will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.0] - 2025-01-09

### 🔧 **MAJOR REFACTOR - Modular Architecture**

#### Added
- **Modular System Architecture**: Individual optimization components in `Optimizer/` folder
- **ProcessPriorityManager.ps1**: Dedicated LLM process boosting (Python, Node.js, VS Code)
- **BackgroundAppGuard.ps1**: RAM usage monitoring with Safe/Active modes
- **PowerPlanOptimizer.ps1**: Automatic High Performance power plan switching
- **ServicesOptimizer.ps1**: Developer-safe Windows service optimization
- **LogCleanup.ps1**: Intelligent log management (keeps newest 10+5 files)
- **Smart Upload System**: Daily/event-based uploads only (no more flooding)
- **Enhanced Documentation**: Comprehensive setup guides and release notes
- **Pre-Release Testing**: Automated validation scripts
- **Setup Validator**: User configuration helper tool
- **Clean Uninstaller**: Complete system removal capability

#### Changed
- **Log Management**: 99.94% space reduction (157MB → 0.1MB)
- **Upload Frequency**: Reduced by 95% (smart daily/event-based)
- **File Structure**: Clean modular organization
- **Process Priorities**: Enhanced LLM optimization (VS Code=High, Browsers=BelowNormal)
- **Safety Measures**: Developer-friendly service optimization only
- **Error Handling**: Graceful fallbacks for all optional components

#### Fixed
- **Log Flooding**: Eliminated constant log creation
- **Service Conflicts**: Disabled problematic background service
- **Credential Exposure**: Removed all hardcoded secrets from repository
- **PowerShell Syntax**: Fixed parsing errors in multiple components
- **Resource Usage**: Intelligent cleanup prevents disk bloating
- **Upload Redundancy**: Smart logic prevents unnecessary cloud uploads

#### Security
- **Credential Protection**: No sensitive data in version control
- **Safe Mode Default**: Background App Guard scans only by default
- **Admin Awareness**: Graceful handling of privilege requirements
- **Developer Safety**: No interference with development tools or networking

#### Performance
- **Process Optimization**: Verified priority management working
- **Space Efficiency**: Massive log folder size reduction
- **System Responsiveness**: Improved through visual effects optimization
- **Resource Management**: Intelligent background app monitoring

## [1.0.0] - 2025-01-XX

### Added
- PowerShell monitoring agent with comprehensive system monitoring
- Python GUI dashboard with real-time metrics display
- Failed RDP login detection and alerting
- System performance monitoring (CPU, RAM, Disk)
- VirusTotal integration for process scanning
- Email alert system for security events
- Google Drive log backup via rclone
- Automatic junk file cleanup
- System tray integration with minimize/restore
- Windows service support via NSSM
- Professional installer with Inno Setup
- Dark theme UI with modern design
- Manual trigger controls for cleanup operations

### Security
- Secure credential storage using Windows Credential Manager
- Encrypted email transmission with TLS
- Protected API key storage
- Secure cloud log uploads

### Documentation
- Comprehensive README with setup instructions
- Security policy for vulnerability reporting
- MIT license for open source distribution
- Installation and configuration guides

## [Unreleased]

### Planned Features
- Web-based dashboard interface
- Real-time alert popups in GUI
- Windows Event Viewer integration
- File submission to VirusTotal
- Enhanced threat detection algorithms
- Multi-language support
- Configuration GUI for easy setup