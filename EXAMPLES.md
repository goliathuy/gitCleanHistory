# Git History Cleaner Examples

This file contains practical examples of using the Clean-GitHistory.ps1 script for various scenarios.

## 📚 Common Use Cases

### 1. API Keys and Secrets

```powershell
# Remove OpenAI API key
.\Clean-GitHistory.ps1 -TextToRemove "sk-proj-abcdef123456789" -ReplacementText "OPENAI-API-KEY-REDACTED"

# Remove GitHub token
.\Clean-GitHistory.ps1 -TextToRemove "ghp_1234567890abcdef" -ReplacementText "GITHUB-TOKEN-REDACTED"

# Remove database password
.\Clean-GitHistory.ps1 -TextToRemove "DB_PASSWORD=secretpass123" -ReplacementText "DB_PASSWORD=REDACTED"
```

### 2. Proprietary File Names

```powershell
# Remove proprietary document reference
.\Clean-GitHistory.ps1 -TextToRemove "CONFIDENTIAL-OPERATIONS-MANUAL.pdf" -ReplacementText "operations-manual-sample.pdf"

# Remove internal project codename
.\Clean-GitHistory.ps1 -TextToRemove "Project-Phoenix-Internal" -ReplacementText "Sample-Project"
```

### 3. Internal Infrastructure

```powershell
# Remove internal server names
.\Clean-GitHistory.ps1 -TextToRemove "prod-server-01.internal.company.com" -ReplacementText "example-server.com"

# Remove IP addresses
.\Clean-GitHistory.ps1 -TextToRemove "192.168.1.100" -ReplacementText "10.0.0.1"

# Remove internal domains
.\Clean-GitHistory.ps1 -TextToRemove "company.internal" -ReplacementText "example.com"
```

### 4. Email Addresses and Contact Info

```powershell
# Remove internal email addresses
.\Clean-GitHistory.ps1 -TextToRemove "admin@company.internal" -ReplacementText "admin@example.com"

# Remove phone numbers
.\Clean-GitHistory.ps1 -TextToRemove "+1-555-123-4567" -ReplacementText "+1-555-000-0000"
```

### 5. Configuration-Specific Cleaning

```powershell
# Clean only configuration files
.\Clean-GitHistory.ps1 -TextToRemove "production-database-url" -FilePatterns "*.config,*.yml,*.json,*.env"

# Clean only code files
.\Clean-GitHistory.ps1 -TextToRemove "hardcoded-secret" -FilePatterns "*.py,*.js,*.ts,*.java,*.cs"

# Clean only documentation
.\Clean-GitHistory.ps1 -TextToRemove "internal-process-details" -FilePatterns "*.md,*.txt,*.rst"
```

## 🚀 Advanced Examples

### Automation Scripts

```powershell
# Silent operation for automation
.\Clean-GitHistory.ps1 -TextToRemove "automated-secret" -Force -NoBackup

# With custom backup naming
.\Clean-GitHistory.ps1 -TextToRemove "legacy-token" -BackupBranchName "pre-security-cleanup"
```

### Multi-step Cleaning

```powershell
# Step 1: Clean API keys
.\Clean-GitHistory.ps1 -TextToRemove "api-key-12345" -ReplacementText "API-KEY-REDACTED"

# Step 2: Clean database URLs
.\Clean-GitHistory.ps1 -TextToRemove "mysql://user:pass@db.internal" -ReplacementText "mysql://user:pass@localhost"

# Step 3: Clean file paths
.\Clean-GitHistory.ps1 -TextToRemove "C:\Internal\Sensitive\Data" -ReplacementText "/path/to/sample/data"
```

## 🧪 Testing Examples

### Verify Before Cleaning

```powershell
# Search for text in current repository
git log --all -S "your-sensitive-text" --oneline

# Check current files
grep -r "your-sensitive-text" . --include="*.py" --include="*.md"
```

### Test on Repository Copy

```powershell
# Create a test copy
git clone /path/to/original /path/to/test-copy
cd /path/to/test-copy

# Run cleaner on test copy
.\Clean-GitHistory.ps1 -TextToRemove "sensitive-text" -Force

# Verify results
git log --all -S "sensitive-text" --oneline  # Should return no results
```

## 📋 Pre-Cleanup Checklist

Before running the script:

- [ ] Create a full backup of your repository
- [ ] Notify all collaborators
- [ ] Test on a repository copy first
- [ ] Document what you're removing
- [ ] Plan the replacement text carefully
- [ ] Choose appropriate file patterns
- [ ] Ensure you have the exact text to remove

## 🔄 Post-Cleanup Steps

After running the script:

```powershell
# 1. Verify the cleanup worked
git log --all -S "original-sensitive-text" --oneline

# 2. Check that replacements are correct
grep -r "REDACTED" . --include="*.py"

# 3. Update remote repository (CAREFUL!)
git push --force-with-lease

# 4. Clean up backup branch (when satisfied)
git branch -D backup-before-cleanup-TIMESTAMP
```

## ⚠️ Common Pitfalls

### Things to Watch Out For

1. **Partial Matches**: Ensure your text is specific enough
2. **Case Sensitivity**: The search is case-sensitive
3. **Special Characters**: Some characters need escaping
4. **Binary Files**: Script safely ignores binary files
5. **Large Repositories**: Can take a long time

### Example of Careful Text Selection

```powershell
# ❌ Too broad - might match unintended content
.\Clean-GitHistory.ps1 -TextToRemove "secret"

# ✅ Specific and safe
.\Clean-GitHistory.ps1 -TextToRemove "SECRET_API_KEY=abc123xyz"
```

## 🎯 Success Stories

These examples show successful cleanups:

```powershell
# Successfully removed accidentally committed .env file content
.\Clean-GitHistory.ps1 -TextToRemove "DATABASE_URL=postgresql://user:realpass@prod.db" -ReplacementText "DATABASE_URL=postgresql://user:password@localhost/db"

# Successfully cleaned proprietary project references
.\Clean-GitHistory.ps1 -TextToRemove "Operation-Thunderbolt-Internal" -ReplacementText "Sample-Operation"

# Successfully removed internal server configurations
.\Clean-GitHistory.ps1 -TextToRemove "redis://cache.internal.company:6379" -ReplacementText "redis://localhost:6379"
```

Remember: **When in doubt, test first!** 🧪
