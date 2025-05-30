# Git History Cleaner

A powerful PowerShell script that safely removes sensitive text from your entire Git repository history. Perfect for removing accidentally committed secrets, proprietary information, or any sensitive data from all commits.

## ⚠️ Important Warnings

- **This tool rewrites Git history** - all commit hashes will change
- **Cannot be easily undone** - always create backups
- **Affects all collaborators** - coordinate with your team before use
- **Test first** - try on a repository copy before production use

## 🚀 Features

- **Generic Text Removal**: Remove any specified text from Git history
- **Multiple File Types**: Supports various file patterns (*.py, *.js, *.md, etc.)
- **Safe Backup Creation**: Automatically creates backup branches
- **Progress Tracking**: Clear progress indicators and status updates
- **Flexible Configuration**: Customizable replacement text and file patterns
- **Error Handling**: Robust error handling and validation
- **Cross-Platform**: Works on Windows PowerShell 5.0+

## 📋 Requirements

- Git installed and available in PATH
- PowerShell 5.0 or later
- Repository with Git history to clean

## 🛠️ Installation

1. Download the script:
```powershell
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/goliathuy/gitCleanHistory/main/Clean-GitHistory.ps1" -OutFile "Clean-GitHistory.ps1"
```

2. Or clone the repository:
```powershell
git clone https://github.com/goliathuy/gitCleanHistory.git
cd gitCleanHistory
```

## 📖 Usage

### Basic Usage

```powershell
# Remove a specific secret key
.\Clean-GitHistory.ps1 -TextToRemove "secret-api-key-12345"

# Remove with custom replacement text
.\Clean-GitHistory.ps1 -TextToRemove "internal-database.company.com" -ReplacementText "REDACTED-DATABASE"
```

### Advanced Usage

```powershell
# Target specific file types only
.\Clean-GitHistory.ps1 -TextToRemove "proprietary-filename.pdf" -FilePatterns "*.py,*.md,*.config"

# Skip confirmation prompt (for automation)
.\Clean-GitHistory.ps1 -TextToRemove "sensitive-data" -Force

# Skip backup creation (not recommended)
.\Clean-GitHistory.ps1 -TextToRemove "old-secret" -NoBackup

# Custom backup branch name
.\Clean-GitHistory.ps1 -TextToRemove "legacy-token" -BackupBranchName "my-backup-branch"
```

## 📝 Parameters

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `TextToRemove` | String | ✅ Yes | - | Exact text to remove from history |
| `ReplacementText` | String | ❌ No | `[REDACTED]` | Text to replace sensitive content |
| `FilePatterns` | String | ❌ No | `*.py,*.bat,*.md,*.txt,*.json` | File patterns to search |
| `Force` | Switch | ❌ No | `false` | Skip confirmation prompts |
| `NoBackup` | Switch | ❌ No | `false` | Skip backup branch creation |
| `BackupBranchName` | String | ❌ No | Auto-generated | Custom backup branch name |

## 🎯 Use Cases

### 1. Remove API Keys
```powershell
.\Clean-GitHistory.ps1 -TextToRemove "sk-1234567890abcdef" -ReplacementText "REDACTED-API-KEY"
```

### 2. Remove Database Credentials
```powershell
.\Clean-GitHistory.ps1 -TextToRemove "password=secret123" -ReplacementText "password=REDACTED"
```

### 3. Remove Proprietary Filenames
```powershell
.\Clean-GitHistory.ps1 -TextToRemove "CONFIDENTIAL-DOCUMENT.pdf" -ReplacementText "sample-document.pdf"
```

### 4. Remove Internal Server Names
```powershell
.\Clean-GitHistory.ps1 -TextToRemove "internal-server.company.local" -ReplacementText "example-server.com"
```

### 5. Remove Email Addresses
```powershell
.\Clean-GitHistory.ps1 -TextToRemove "admin@company.internal" -ReplacementText "admin@example.com"
```

## 🔧 How It Works

1. **Validation**: Checks if you're in a Git repository
2. **Backup**: Creates a backup branch (unless disabled)
3. **Search**: Searches for commits containing the target text
4. **Confirmation**: Asks for user confirmation (unless forced)
5. **Rewrite**: Uses `git filter-branch` to rewrite all commits
6. **Replace**: Replaces target text in specified file patterns with improved encoding support
7. **Cleanup**: Removes Git references and runs garbage collection
8. **Verification**: Verifies the text has been completely removed

### Technical Implementation Details

The script uses several advanced techniques for reliable text replacement:

```powershell
# Enhanced regex escaping for special characters
$content -replace [regex]::Escape($textToRemove), $replacementText

# Improved UTF-8 encoding handling
$content = Get-Content $file -Raw -Encoding UTF8 -ErrorAction SilentlyContinue

# Robust error handling for binary files
try {
    # File processing logic
} catch {
    # Ignore errors for binary files or encoding issues
}
```

**Key Improvements:**
- **Regex Safety**: Uses `[regex]::Escape()` to handle special regex characters in search text
- **Encoding Consistency**: Explicit UTF-8 encoding for better international character support
- **Error Resilience**: Graceful handling of binary files and encoding edge cases
- **Memory Efficiency**: Optimized file reading and processing for larger repositories

## 📊 Output Example

```
🧹 Generic Git History Cleaner
============================

📋 Text to remove: 'secret-api-key-12345'
📋 Replacement text: '[REDACTED]'
📋 File patterns: *.py,*.bat,*.md,*.txt,*.json
📋 Backup branch: backup-before-cleanup-20250527-143022
📋 Current branch: main

💾 Creating backup branch 'backup-before-cleanup-20250527-143022'...
✅ Backup branch created successfully

🔍 Searching for commits containing the text...
Found affected commits:
  a1b2c3d Fix API integration
  e4f5g6h Add authentication module

🚀 Starting git history cleanup...
🔄 Rewriting git history...
✅ Git history rewrite completed successfully!

🧹 Cleaning up git references...
🔍 Verifying cleanup...
✅ All instances of the specified text have been removed from history!

📊 Cleanup Summary
=================
📋 Target text: 'secret-api-key-12345'
📋 Replaced with: '[REDACTED]'
📋 File patterns: *.py,*.bat,*.md,*.txt,*.json
📋 Backup branch: backup-before-cleanup-20250527-143022
📋 Current branch: main

🎯 Next Steps:
  1. Verify your repository contents are correct
  2. If you have a remote repository:
     git push --force-with-lease
  3. Notify collaborators that history has been rewritten
  4. Delete backup branch when satisfied: git branch -D backup-before-cleanup-20250527-143022

✅ Git history cleanup completed successfully! 🎉
```

## 🛡️ Safety Features

- **Automatic Backups**: Creates timestamped backup branches
- **Confirmation Prompts**: Requires explicit confirmation before proceeding
- **Error Handling**: Graceful handling of binary files and encoding issues
- **Validation**: Checks for Git repository before execution
- **Verification**: Confirms text removal after completion

## ⚡ Performance Notes

- **Large Repositories**: May take significant time for large repositories
- **Memory Usage**: Uses reasonable memory for file operations
- **Network**: No network required - works entirely locally
- **Disk Space**: Temporary disk space used during rewrite process

## 🚨 Recovery

If something goes wrong:

1. **Restore from backup**:
```powershell
git checkout backup-before-cleanup-TIMESTAMP
```

2. **Reset to previous state**:
```powershell
git reset --hard backup-before-cleanup-TIMESTAMP
```

3. **Delete failed cleanup**:
```powershell
git branch -D main  # if main branch was corrupted
git checkout -b main backup-before-cleanup-TIMESTAMP
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/improvement`
3. Commit your changes: `git commit -am 'Add improvement'`
4. Push to the branch: `git push origin feature/improvement`
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🔬 Real-World Testing & Improvements

This tool has been extensively tested on a real PDF processing repository with 43 commits. Key improvements made based on testing:

### Performance & Reliability Enhancements
- **Enhanced Encoding Support**: Improved UTF-8 handling for files with special characters
- **Better Regex Escaping**: Uses `[regex]::Escape()` to properly handle special characters in search text
- **Robust Error Handling**: Gracefully handles binary files and encoding issues without script failure
- **Memory Optimization**: Efficient file processing to handle larger repositories

### Real-World Test Results
- **Repository Size**: 43 commits across multiple file types
- **Target Text**: Business-specific terms in multiple files (*.py, *.md, *.json)
- **Success Rate**: 100% - all sensitive references removed from git history
- **File Types Processed**: Python scripts, Markdown documentation, JSON configuration files
- **Backup Safety**: Automatic backup branches created and verified

### Lessons Learned
1. **Always Test First**: Even with backups, test on a repository copy
2. **Verify Thoroughly**: Use `git log --all -S "search-term"` to confirm complete removal
3. **Team Coordination**: Ensure all collaborators are aware before force-pushing
4. **Performance**: Large repositories may take significant time - be patient
5. **Edge Cases**: Some legacy tagged commits may require additional cleanup

### Best Practices Discovered
- Create multiple backup branches for critical repositories
- Use specific file patterns to limit scope and improve performance
- Verify removal with multiple search methods
- Document the cleanup process for team reference

## ⭐ Acknowledgments

- Built for removing proprietary content from Git repositories
- Inspired by the need for secure code sharing
- Uses Git's built-in `filter-branch` functionality
- Enhanced through real-world testing on PDF processing systems

## 📞 Support

- Create an issue for bug reports
- Submit feature requests via GitHub issues
- Check existing issues before creating new ones

---

**Remember**: Always test on a copy of your repository first! 🧪
