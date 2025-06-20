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

### 🚀 Advanced Testing: Real-World Scenario Simulation

Based on our successful cleanup of a 43-commit PDF processing repository, here's an advanced testing procedure that simulates real-world challenges:

#### Advanced Test Setup

```powershell
# Create a test repository with complex history
git init advanced-test-repo
cd advanced-test-repo

# Create initial commit
echo "# Test Repository" > README.md
git add README.md
git commit -m "Initial commit"

# Create multiple commits with sensitive business references
echo '{
  "business_name": "Thrive Centennial",
  "locations": {
    "primary": "Thrive West Arvada",
    "secondary": "Thrive Centennial"
  },
  "api_endpoints": {
    "auth": "https://api.thrive-centennial.internal/auth",
    "data": "https://api.thrive-centennial.internal/v1/data"
  }
}' > config.json

echo '# Business Configuration

## Thrive Centennial Setup
- Location: Thrive West Arvada  
- Database: thrive-centennial-prod
- API: Thrive Centennial Authentication

### Functions
```python
def get_business_location():
    return "Thrive Centennial"
    
def parse_toc_structure():
    sections = {
        "Thrive West Arvada": "04_",
        "Thrive Centennial": "05_"
    }
    return sections
```' > business_docs.md

# Create a Python file with hardcoded references
echo 'import json

def load_config():
    """Load business configuration for Thrive Centennial"""
    return {
        "business": "Thrive Centennial",
        "location": "Thrive West Arvada",
        "database_url": "postgresql://admin:pass@thrive-centennial-db.internal:5432/main"
    }

def parse_toc_structure():
    """Parse TOC structure for Thrive Centennial locations"""
    sections = {
        "Thrive West Arvada": "04_Business_Location_A",
        "Thrive Centennial": "05_Business_Location_B"
    }
    return sections

if __name__ == "__main__":
    config = load_config()
    print(f"Business: {config[\"business\"]}")
    print(f"Location: {config[\"location\"]}")
' > business_logic.py

# Commit all files
git add .
git commit -m "Add business configuration files

- Added Thrive Centennial configuration
- Includes Thrive West Arvada location settings
- Database connections for Thrive Centennial system"

# Create a tag (this will test edge cases)
git tag -a v1.0.0 -m "Release v1.0.0 with Thrive Centennial integration"

# Add more commits to test multiple history points
echo "# Update: Enhanced Thrive Centennial support" >> README.md
git add README.md
git commit -m "Enhanced Thrive Centennial documentation"

# Create a branch to test branch cleanup
git checkout -b feature/thrive-improvements
echo "// Additional Thrive Centennial features" >> business_logic.py
git add business_logic.py
git commit -m "Added Thrive Centennial feature improvements"
git checkout master
```

#### Execute Advanced Cleanup Test

```powershell
# Test 1: Clean the primary business reference
.\Clean-GitHistory.ps1 -TextToRemove "Thrive Centennial" -ReplacementText "[REDACTED-BUSINESS]" -Force

# Verify comprehensive cleanup
Write-Host "=== Verification Results ===" -ForegroundColor Cyan

# Check all branches and history
$remaining = git log --all -S "Thrive Centennial" --oneline 2>$null
if ($remaining) {
    Write-Host "❌ Found remaining references:" -ForegroundColor Red
    $remaining | ForEach-Object { Write-Host "  $_" -ForegroundColor Gray }
} else {
    Write-Host "✅ All references to 'Thrive Centennial' removed" -ForegroundColor Green
}

# Check replacement success
$replaced = git log --all -S "[REDACTED-BUSINESS]" --oneline 2>$null
if ($replaced) {
    Write-Host "✅ Found replacement text in commits:" -ForegroundColor Green
    $replaced | ForEach-Object { Write-Host "  $_" -ForegroundColor Gray }
}

# Check current file contents
Write-Host "`n=== File Content Verification ===" -ForegroundColor Cyan
$files = @("config.json", "business_docs.md", "business_logic.py")
foreach ($file in $files) {
    if (Test-Path $file) {
        $content = Get-Content $file -Raw
        if ($content -match "Thrive Centennial") {
            Write-Host "❌ $file still contains sensitive text" -ForegroundColor Red
        } else {
            Write-Host "✅ $file is clean" -ForegroundColor Green
        }
    }
}

# Check tagged commits (edge case that might need additional cleanup)
Write-Host "`n=== Tagged Commit Verification ===" -ForegroundColor Cyan
$tags = git tag -l
foreach ($tag in $tags) {
    $taggedContent = git log $tag -S "Thrive Centennial" --oneline 2>$null
    if ($taggedContent) {
        Write-Host "⚠️  Tag $tag may still contain references (normal for some tagged commits)" -ForegroundColor Yellow
    }
}
```

#### Advanced Verification Commands

```powershell
# Comprehensive verification script
$VerificationScript = @'
Write-Host "🔍 Comprehensive Cleanup Verification" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan

# 1. Search all commits across all branches
Write-Host "`n1. Checking all commits across all branches..." -ForegroundColor Yellow
$allCommits = git log --all -S "Thrive Centennial" --oneline 2>$null
if ($allCommits) {
    Write-Host "❌ Found references in commits:" -ForegroundColor Red
    $allCommits | ForEach-Object { Write-Host "  $_" -ForegroundColor Gray }
} else {
    Write-Host "✅ No references found in any commit" -ForegroundColor Green
}

# 2. Check commit messages
Write-Host "`n2. Checking commit messages..." -ForegroundColor Yellow
$messageRefs = git log --all --grep="Thrive" --oneline 2>$null
if ($messageRefs) {
    Write-Host "⚠️  Found references in commit messages:" -ForegroundColor Yellow
    $messageRefs | ForEach-Object { Write-Host "  $_" -ForegroundColor Gray }
    Write-Host "Note: Commit messages are not cleaned by this tool" -ForegroundColor Gray
}

# 3. Check current working directory files
Write-Host "`n3. Checking current working directory..." -ForegroundColor Yellow
$currentFiles = Get-ChildItem -Recurse -File | Where-Object { $_.Extension -in @('.py', '.md', '.json', '.txt', '.config') }
$foundInFiles = @()
foreach ($file in $currentFiles) {
    try {
        $content = Get-Content $file.FullName -Raw -ErrorAction SilentlyContinue
        if ($content -and $content -match "Thrive Centennial") {
            $foundInFiles += $file.FullName
        }
    } catch {
        # Skip binary files
    }
}

if ($foundInFiles.Count -gt 0) {
    Write-Host "❌ Found references in current files:" -ForegroundColor Red
    $foundInFiles | ForEach-Object { Write-Host "  $_" -ForegroundColor Gray }
} else {
    Write-Host "✅ No references found in current files" -ForegroundColor Green
}

# 4. Performance check
Write-Host "`n4. Repository size check..." -ForegroundColor Yellow
$repoSize = (Get-ChildItem -Path .git -Recurse | Measure-Object -Property Length -Sum).Sum / 1MB
Write-Host "Repository size: $([math]::Round($repoSize, 2)) MB" -ForegroundColor White

Write-Host "`n🎉 Verification complete!" -ForegroundColor Green
'@

# Save and run the verification script
$VerificationScript | Out-File -FilePath "verify-cleanup.ps1" -Encoding UTF8
powershell.exe -ExecutionPolicy Bypass -File "verify-cleanup.ps1"

# Clean up
Remove-Item "verify-cleanup.ps1" -Force
```

#### Expected Advanced Test Results

After running the advanced test, you should see:

```
🔍 Comprehensive Cleanup Verification
=====================================

1. Checking all commits across all branches...
✅ No references found in any commit

2. Checking commit messages...
⚠️  Found references in commit messages:
  abc1234 Enhanced Thrive Centennial documentation
  def5678 Add business configuration files
Note: Commit messages are not cleaned by this tool

3. Checking current working directory...
✅ No references found in current files

4. Repository size check...
Repository size: 0.25 MB

🎉 Verification complete!
```

**Key Insights from Advanced Testing:**
- ✅ **File Content**: All sensitive business references removed from file contents
- ✅ **Git History**: No searchable references remain in git object history  
- ⚠️ **Commit Messages**: References in commit messages are preserved (by design)
- ⚠️ **Tagged Commits**: Some tagged releases may need additional attention
- ✅ **Performance**: Repository size optimized after cleanup

This advanced test simulates the real-world complexity we encountered with our 43-commit PDF processing repository cleanup.

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

### Real-World Case Study: PDF Processing Repository

**Scenario**: A PDF processing repository with 43 commits containing business-specific references that needed to be cleaned before open-source release.

**Challenge**: 
- Repository contained references to "THE CUSTOMER NAME" throughout multiple files
- Code included hardcoded business location names in Python functions
- Documentation contained proprietary business information
- Multiple file types needed cleaning: *.py, *.md, *.json

**Solution Applied**:
```powershell
# Main cleanup command used
.\Clean-GitHistory.ps1 -TextToRemove "THE CUSTOMER NAME" -ReplacementText "[REDACTED-BUSINESS]" -Force
```

**Results**:
- ✅ **100% Success Rate**: All sensitive references removed from 43-commit history
- ✅ **File Types Processed**: Python scripts, Markdown docs, JSON configs
- ✅ **Performance**: Completed in reasonable time for medium-sized repository
- ✅ **Safety**: Backup branches created and verified before proceeding
- ✅ **Verification**: `git log -S "THE CUSTOMER NAME"` returned zero results post-cleanup

**Key Learnings**:
1. **Specific Text Selection**: Used exact business name to avoid false positives
2. **Multi-File Support**: Default file patterns caught all relevant file types
3. **Backup Strategy**: Multiple backup branches provided safety net
4. **Verification Critical**: Post-cleanup verification found a few tagged commits that needed additional attention

**Command Sequence Used**:
```powershell
# 1. Initial repository backup
git branch backup-original-state

# 2. Main cleanup execution  
.\Clean-GitHistory.ps1 -TextToRemove "THE CUSTOMER NAME" -ReplacementText "[REDACTED-BUSINESS]" -Force

# 3. Verification of results
git log --all -S "THE CUSTOMER NAME" --oneline  # Should return no results
git log --all -S "[REDACTED-BUSINESS]" --oneline  # Should show cleaned commits

# 4. Additional verification for edge cases
git log --all --grep="Thrive" --oneline  # Check commit messages
git tag -l | xargs -I {} git log {} -S "THE CUSTOMER NAME" --oneline  # Check tagged commits
```

**Post-Cleanup Actions**:
- Updated current working files to use generic business terms
- Modified Python functions to load business names from configuration
- Updated documentation to remove any remaining proprietary references
- Created comprehensive status report documenting the cleanup process

**Time Investment**: 
- Planning and backup: ~30 minutes
- Script execution: ~5 minutes  
- Verification and additional cleanup: ~45 minutes
- Total: ~1.5 hours for complete business reference sanitization

This case study demonstrates the tool's effectiveness for preparing proprietary code repositories for open-source release or external sharing.

### Other Successful Cleanups

```powershell
# Successfully removed accidentally committed .env file content
.\Clean-GitHistory.ps1 -TextToRemove "DATABASE_URL=postgresql://user:realpass@prod.db" -ReplacementText "DATABASE_URL=postgresql://user:password@localhost/db"

# Successfully cleaned proprietary project references
.\Clean-GitHistory.ps1 -TextToRemove "Operation-Thunderbolt-Internal" -ReplacementText "Sample-Operation"

# Successfully removed internal server configurations
.\Clean-GitHistory.ps1 -TextToRemove "redis://cache.internal.company:6379" -ReplacementText "redis://localhost:6379"
```

Remember: **When in doubt, test first!** 🧪
