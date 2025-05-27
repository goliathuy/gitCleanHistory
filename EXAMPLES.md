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

### Complete Testing Procedure

Want to test the Git History Cleaner safely? This repository includes pre-made test files to demonstrate the script's functionality.

#### Quick Test with Included Files

This repository already contains test files (`test-config.json` and `test-docs.md`) that show the results of the cleanup process:

```powershell
# View the current test files (already contain redacted content)
Get-Content test-config.json
Get-Content test-docs.md

# Check git history to see the cleanup was successful
git log --oneline
git log -S "SECRET-API-KEY-12345" --all  # Should return no results
git log -S "[REDACTED-API-KEY]" --all    # Should find the commits
```

#### Creating Your Own Test

To test the script yourself with fresh content, follow this step-by-step procedure:

#### Step 1: Create Test Environment

```powershell
# Create a test branch
git checkout -b my-test-cleanup

# Create NEW test files with sensitive content (different from included ones)
```

Create `my-test-config.json`:
```json
{
  "database_connection": "mongodb://user:password123@localhost:27017/testdb",
  "api_key": "MY-NEW-SECRET-KEY-789",
  "secret_token": "super-secret-token-xyz789",
  "admin_token": "MY-NEW-SECRET-KEY-789",
  "backup_key": "MY-NEW-SECRET-KEY-789"
}
```

Create `my-test-docs.md`:
```markdown
# My Test Documentation

This is a test document for demonstrating git history cleanup.

## Configuration  
- Database: MY-NEW-SECRET-KEY-789 should not be exposed
- Token: MY-NEW-SECRET-KEY-789 is used for authentication
- Key: MY-NEW-SECRET-KEY-789 provides access to the system

## Usage Examples
\```bash
export API_KEY="MY-NEW-SECRET-KEY-789"
curl -H "Authorization: Bearer MY-NEW-SECRET-KEY-789" https://api.example.com
\```

## Additional Security Notes
Never commit MY-NEW-SECRET-KEY-789 to version control!
The MY-NEW-SECRET-KEY-789 should be stored in environment variables.
#### Step 2: Create Git History

```powershell
# Add and commit the NEW test files
git add my-test-*.json my-test-*.md
git commit -m "Add my test files with sensitive API keys

- my-test-config.json contains multiple MY-NEW-SECRET-KEY-789 references
- my-test-docs.md contains documentation with MY-NEW-SECRET-KEY-789 
- This commit creates history that needs to be cleaned"
```

#### Step 3: Verify Sensitive Content Exists

```powershell
# Search for the sensitive content in git history
git log --all -S "MY-NEW-SECRET-KEY-789" --oneline
# Should show the new commit with your test files

# Verify content in files
Get-Content my-test-config.json | Select-String "MY-NEW-SECRET-KEY-789"
Get-Content my-test-docs.md | Select-String "MY-NEW-SECRET-KEY-789"
```

#### Step 4: Run the Git History Cleaner

```powershell
# Run the cleaner (use -Force to skip confirmation in testing)
.\Clean-GitHistory.ps1 -TextToRemove "MY-NEW-SECRET-KEY-789" -ReplacementText "[MY-REDACTED-KEY]" -Force
```

Expected output:
```
🧹 Generic Git History Cleaner
==============================
📋 Text to remove: 'MY-NEW-SECRET-KEY-789'
📋 Replacement text: '[MY-REDACTED-KEY]'
📋 File patterns: *.py,*.bat,*.md,*.txt,*.json
📋 Backup branch: backup-before-cleanup-TIMESTAMP
💾 Creating backup branch...
✅ Backup branch created successfully
🔍 Searching for commits containing the text...
Found affected commits:
  a1b2c3d Add my test files with sensitive API keys
🚀 Starting git history cleanup...
...
✅ Git history cleanup completed successfully! 🎉
```

#### Step 5: Verify Complete Removal

```powershell
# Search for any remaining instances (should return nothing)
git log --all -S "MY-NEW-SECRET-KEY-789" --oneline

# Verify replacement text exists (should find the commit)
git log --all -S "[MY-REDACTED-KEY]" --oneline

# Check file contents after cleanup
Get-Content my-test-config.json | Select-String "MY-REDACTED-KEY"
Get-Content my-test-docs.md | Select-String "MY-REDACTED-KEY"
```

#### Step 6: Cleanup Test Environment

```powershell
# Switch back to main branch
git checkout main  # or 'master'

# Delete test branch
git branch -D my-test-cleanup

# Delete backup branch (when satisfied with results)
git branch -D backup-before-cleanup-*

# Remove test files from working directory
Remove-Item my-test-config.json, my-test-docs.md -Force
```

### Expected Results

✅ **Before Cleanup:**
- `git log -S "MY-NEW-SECRET-KEY-789"` finds 1 commit
- Files contain multiple instances of sensitive text

✅ **After Cleanup:**
- `git log -S "MY-NEW-SECRET-KEY-789"` returns no results
- All instances replaced with `[MY-REDACTED-KEY]`
- Original content completely removed from git history
- Backup branch preserves original state for safety

### Troubleshooting

If the test doesn't work as expected:

1. **Check PowerShell execution policy:**
   ```powershell
   Get-ExecutionPolicy
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```

2. **Verify Git is available:**
   ```powershell
   git --version
   ```

3. **Check for Git Bash (required for filter-branch):**
   ```powershell
   bash --version
   ```

4. **Review error messages in the script output**

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
git branch -D backup-before-cleanup-*
```

## 📁 Included Test Files

This repository includes demonstration files that show the script's functionality:

### `test-config.json`
Contains configuration with redacted API keys showing successful cleanup of:
- Multiple instances of `SECRET-API-KEY-12345` → `[REDACTED-API-KEY]`
- Database connections and authentication tokens

### `test-docs.md`  
Contains documentation with redacted sensitive information showing:
- Code examples with cleaned API keys
- Security notes with redacted tokens
- Multiple reference patterns successfully cleaned

### Viewing Test Results
```powershell
# See the cleaned content
Get-Content test-config.json
Get-Content test-docs.md

# Verify no sensitive content remains in git history  
git log -S "SECRET-API-KEY-12345" --all  # Should return no results
git log -S "[REDACTED-API-KEY]" --all    # Should show the cleanup commits
```

These files demonstrate that the Git History Cleaner successfully:
- ✅ Removed all instances of sensitive content from git history
- ✅ Replaced sensitive text with safe placeholder text
- ✅ Maintained file structure and formatting
- ✅ Preserved commit history while cleaning content

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
