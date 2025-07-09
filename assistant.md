# 🤖 assistant.md – Guidance for AI Assistants and Contributors

## 🧠 Project Philosophy
Dadir Defender is a modular, cross-platform security agent focused on:
- Real-time system monitoring
- Threat detection via VirusTotal
- User-friendly GUI configuration
- Lightweight, secure automation

## 🗂️ File Structure Overview
- `Agent/monitor.ps1`: PowerShell monitoring logic
- `UI/dashboard.py`: Python GUI interface
- `Installer/`: Inno Setup installer
- `Logs/`: Output logs and reports
- `dashboard.spec`: PyInstaller build config

## 🧩 Design Principles
- Keep GUI and agent logic decoupled
- Use secure credential storage (Credential Manager or keyring)
- Avoid hardcoding sensitive data—use GUI inputs or config files
- Maintain cross-platform compatibility (Windows, Linux, macOS)

## 🧪 Future Enhancements
- GUI-based API key and email input
- Linux/macOS support using Bash/systemd/launchd
- Encrypted config storage
- Modular plugin system for new monitoring features

## 🛠️ AI Prompt Suggestions
> “Add a tkinter input field to capture and store a VirusTotal API key securely.”  
> “Refactor monitor.ps1 to support Linux using Bash equivalents.”  
> “Create a PyInstaller spec file for dashboard.py with custom icon and tray support.”  
> “Add a settings tab to the GUI for user-configurable fields.”  
> “Implement a cross-platform credential storage abstraction.”

---

This file is intended to help AI tools and human contributors understand the project’s structure, goals, and development style.
