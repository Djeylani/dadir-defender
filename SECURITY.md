# Security Policy

## Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| 1.0.x   | :white_check_mark: |

## Reporting a Vulnerability

If you discover a security vulnerability in Dadir Defender, please report it responsibly:

### How to Report
- **Email**: Create an issue on GitHub with the "security" label
- **Response Time**: We aim to respond within 48 hours
- **Updates**: You'll receive updates on the status every 7 days

### What to Include
- Description of the vulnerability
- Steps to reproduce the issue
- Potential impact assessment
- Suggested fix (if available)

### Security Considerations

**Credentials**: This application handles sensitive information including:
- Email credentials for alerts
- VirusTotal API keys
- System access tokens

**Best Practices**:
- Store credentials using Windows Credential Manager
- Use app-specific passwords for email accounts
- Regularly rotate API keys
- Run with minimal required privileges

**Data Protection**:
- Logs may contain sensitive system information
- Cloud uploads are encrypted in transit
- Local logs should be protected with appropriate file permissions

### Responsible Disclosure
We follow responsible disclosure practices:
1. Report received and acknowledged
2. Vulnerability investigated and confirmed
3. Fix developed and tested
4. Security advisory published
5. Fix released to users

Thank you for helping keep Dadir Defender secure!