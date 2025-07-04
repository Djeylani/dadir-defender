# Contributing to Dadir Defender

Thank you for your interest in contributing to Dadir Defender! This document provides guidelines for contributing to the project.

## Code of Conduct

- Be respectful and inclusive
- Focus on constructive feedback
- Help maintain a welcoming environment for all contributors

## How to Contribute

### Reporting Bugs
1. Check existing issues to avoid duplicates
2. Use the bug report template
3. Include system information and logs
4. Provide clear steps to reproduce

### Suggesting Features
1. Check if the feature already exists or is planned
2. Open an issue with the feature request template
3. Explain the use case and benefits
4. Be open to discussion and feedback

### Code Contributions

#### Setup Development Environment
```bash
# Clone the repository
git clone https://github.com/yourusername/dadir-defender.git
cd dadir-defender

# Create virtual environment
python -m venv venv
venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt
```

#### Making Changes
1. Fork the repository
2. Create a feature branch: `git checkout -b feature/your-feature-name`
3. Make your changes following the coding standards
4. Test your changes thoroughly
5. Commit with clear, descriptive messages
6. Push to your fork and submit a pull request

#### Coding Standards
- Follow PEP 8 for Python code
- Use meaningful variable and function names
- Add comments for complex logic
- Include docstrings for functions and classes
- Keep PowerShell scripts well-documented

#### Testing
- Test on Windows 10 and 11
- Verify both GUI and service modes work
- Test with and without optional dependencies
- Include test cases for new features

### Pull Request Process
1. Update documentation if needed
2. Add your changes to CHANGELOG.md
3. Ensure all tests pass
4. Request review from maintainers
5. Address feedback promptly

## Development Guidelines

### File Structure
- Keep PowerShell scripts in `Agent/`
- Python GUI code goes in `UI/`
- Documentation in root directory
- Assets in appropriate subdirectories

### Security Considerations
- Never commit credentials or API keys
- Use placeholder values in examples
- Follow secure coding practices
- Test security features thoroughly

### Documentation
- Update README.md for new features
- Add inline comments for complex code
- Include setup instructions for new dependencies
- Update help text and tooltips

## Questions?

- Open an issue for general questions
- Check existing documentation first
- Be specific about your environment and use case

Thank you for contributing to Dadir Defender!