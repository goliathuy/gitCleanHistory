# GitCleanHistory v2.0.1 - First Public Release

## 🎉 Welcome to GitCleanHistory!

A reliable PowerShell tool for removing sensitive content from git repository history while preserving project structure and functionality.

## ✨ Key Features

### 🔧 Comprehensive Git History Cleaning
- **Content Removal**: Safely removes sensitive text from all commits in git history
- **Smart Replacement**: Replaces sensitive content with configurable replacement text
- **File Processing**: Cleans both git history and current working files
- **Backup Protection**: Automatically creates timestamped backup branches before operations

### 🧪 Automated Testing & Validation
- **Built-in Testing**: Comprehensive `Test-GitHistoryCleaner.ps1` validation script
- **4-Test Coverage**: Validates git history cleaning, content replacement, and file processing
- **Reliability Assurance**: Ensures the tool works correctly before you rely on it
- **Production Ready**: Tested on real-world repositories with verified results

### 🛡️ Safety & Reliability
- **Safe Operations**: Non-destructive approach with automatic backups
- **Error Handling**: Robust error detection and user-friendly messages
- **Confirmation Prompts**: Interactive confirmations with force override option
- **UTF-8 Support**: Properly handles international characters and special content

## 📋 Installation & Usage

### Quick Start (Recommended)
```powershell
# Download and run installer
iex (irm "https://raw.githubusercontent.com/goliathuy/gitCleanHistory/master/Install-GitCleanHistory.ps1")
```

### Manual Installation
```powershell
# Download main script
Invoke-WebRequest -Uri "https://github.com/goliathuy/gitCleanHistory/releases/download/v2.0.1/Clean-GitHistory.ps1" -OutFile "Clean-GitHistory.ps1"
```

### Basic Usage Examples
```powershell
# Remove sensitive API key
.\Clean-GitHistory.ps1 -TextToRemove "sk-1234567890abcdef"

# Remove with custom replacement text
.\Clean-GitHistory.ps1 -TextToRemove "internal-server.company.com" -ReplacementText "example-server.com"

# Skip confirmation for automation
.\Clean-GitHistory.ps1 -TextToRemove "sensitive-data" -Force
```

## 🧪 Verification & Testing

Verify the installation works correctly:
```powershell
.\Test-GitHistoryCleaner.ps1
```

**Expected output:**
```
🎯 Test Results Summary:
======================
✅ Test 1: Sensitive content removed from git history
✅ Test 2: Replacement text added to git history  
✅ Test 3: Current files cleaned successfully
✅ Test 4: Replacement text in current files
Tests Passed: 4/4
🎉 All tests passed! Git History Cleaner is working correctly.
```

## 🎯 Use Cases

Perfect for:
- **API Key Removal**: Remove accidentally committed API keys, tokens, or secrets
- **Server Information**: Clean internal server names, IPs, or domain references  
- **Business Information**: Remove company names, client details, or proprietary data
- **Development Cleanup**: Prepare repositories for open-source publication
- **Compliance**: Meet data protection requirements by removing sensitive content

## ⚠️ Important Safety Notes

- **Backup Creation**: Tool automatically creates timestamped backup branches
- **History Rewrite**: All commit hashes will change after cleanup (this is normal)
- **Team Coordination**: Notify collaborators before using on shared repositories
- **Test First**: Always test on a repository copy before production use

## 🔗 Resources

- **Documentation**: [README.md](https://github.com/goliathuy/gitCleanHistory/blob/master/README.md)
- **Examples**: [EXAMPLES.md](https://github.com/goliathuy/gitCleanHistory/blob/master/EXAMPLES.md)
- **Changelog**: [CHANGELOG.md](https://github.com/goliathuy/gitCleanHistory/blob/master/CHANGELOG.md)
- **Issues**: Report bugs or request features in [Issues](https://github.com/goliathuy/gitCleanHistory/issues)

## 🤝 Contributing

Help us improve GitCleanHistory:
- ⭐ **Star** this repository if you find it useful
- 🐛 **Report bugs** via GitHub Issues  
- 💡 **Suggest features** for future releases
- 🤝 **Contribute** via Pull Requests

---

**Download the assets below** to get started with GitCleanHistory!

> **Note**: This tool has been tested and verified working with automated test suite. Ready for production use with proper backup procedures.
