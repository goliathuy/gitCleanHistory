param(
    [Parameter(Mandatory = $true, HelpMessage = "Text to remove from git history")]
    [string]$TextToRemove,
    
    [Parameter(Mandatory = $false, HelpMessage = "Replacement text (default: [REDACTED])")]
    [string]$ReplacementText = "[REDACTED]",
    
    [Parameter(Mandatory = $false, HelpMessage = "File patterns to search (comma-separated, default: *.py,*.bat,*.md,*.txt,*.json)")]
    [string]$FilePatterns = "*.py,*.bat,*.md,*.txt,*.json",
    
    [Parameter(Mandatory = $false, HelpMessage = "Skip confirmation prompt")]
    [switch]$Force,
    
    [Parameter(Mandatory = $false, HelpMessage = "Skip creating backup branch")]
    [switch]$NoBackup,
    
    [Parameter(Mandatory = $false, HelpMessage = "Backup branch name")]
    [string]$BackupBranchName = "backup-before-cleanup-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
)

function Write-Header {
    param([string]$Title)
    Write-Host "`n$Title" -ForegroundColor Cyan
    Write-Host ("=" * $Title.Length) -ForegroundColor Cyan
}

function Write-Warning {
    param([string]$Message)
    Write-Host "⚠️  $Message" -ForegroundColor Yellow
}

function Write-Error {
    param([string]$Message)
    Write-Host "❌ $Message" -ForegroundColor Red
}

function Write-Success {
    param([string]$Message)
    Write-Host "✅ $Message" -ForegroundColor Green
}

function Write-Info {
    param([string]$Message)
    Write-Host "📋 $Message" -ForegroundColor White
}

# Validate we're in a git repository
if (-not (Test-Path ".git")) {
    Write-Error "Not a git repository. Please run this script from the root of a git repository."
    exit 1
}

Write-Header "🧹 Fixed Git History Cleaner"

Write-Info "Text to remove: '$TextToRemove'"
Write-Info "Replacement text: '$ReplacementText'"
Write-Info "File patterns: $FilePatterns"

# Get current branch
$currentBranch = git branch --show-current
Write-Info "Current branch: $currentBranch"

# Create backup branch if requested
if (-not $NoBackup) {
    Write-Host "`n💾 Creating backup branch '$BackupBranchName'..." -ForegroundColor Yellow
    git branch $BackupBranchName
    if ($LASTEXITCODE -eq 0) {
        Write-Success "Backup branch created successfully"
    }
    else {
        Write-Error "Failed to create backup branch"
        exit 1
    }
}

# Search for affected commits
Write-Host "`n🔍 Searching for commits containing the text..." -ForegroundColor Yellow
$affectedCommits = git log --all -S "$TextToRemove" --oneline 2>$null
if ($affectedCommits) {
    Write-Host "Found affected commits:" -ForegroundColor Yellow
    $affectedCommits | ForEach-Object { Write-Host "  $_" -ForegroundColor Gray }
}
else {
    Write-Info "No commits found containing the specified text."
    exit 0
}

# Confirmation
if (-not $Force) {
    Write-Host "`n⚠️  WARNING: This operation will:" -ForegroundColor Red
    Write-Host "  • Rewrite ALL git history" -ForegroundColor Red
    Write-Host "  • Change ALL commit hashes" -ForegroundColor Red
    Write-Host "  • Cannot be easily undone" -ForegroundColor Red
    Write-Host "  • Requires force push to update remotes" -ForegroundColor Red
    
    if (-not $NoBackup) {
        Write-Host "`nBackup created: $BackupBranchName" -ForegroundColor Yellow
    }
    
    $confirmation = Read-Host "`nAre you absolutely sure you want to proceed? (yes/NO)"
    if ($confirmation -ne 'yes') {
        Write-Info "Operation cancelled"
        exit 0
    }
}

Write-Host "`n🚀 Starting git history cleanup..." -ForegroundColor Green

# Create a more robust script file for the filter
$tempScript = [System.IO.Path]::GetTempFileName() + ".ps1"

# Convert file patterns to array
$patterns = $FilePatterns -split ',' | ForEach-Object { $_.Trim() }

# Build a more robust PowerShell script
$scriptContent = @"
`$ErrorActionPreference = 'SilentlyContinue'
`$textToRemove = '$($TextToRemove -replace "'", "''")'
`$replacementText = '$($ReplacementText -replace "'", "''")'
`$patterns = @('$($patterns -join "', '")')

foreach (`$pattern in `$patterns) {
    Get-ChildItem -Path . -Filter `$pattern -Recurse -File | ForEach-Object {
        try {
            `$file = `$_.FullName
            if (Test-Path `$file -PathType Leaf) {
                `$encoding = 'UTF8'
                `$content = Get-Content `$file -Raw -Encoding `$encoding -ErrorAction SilentlyContinue
                if (`$content -and (`$content -match [regex]::Escape(`$textToRemove))) {
                    `$newContent = `$content -replace [regex]::Escape(`$textToRemove), `$replacementText
                    if (`$newContent -ne `$content) {
                        Set-Content `$file `$newContent -NoNewline -Encoding `$encoding -ErrorAction SilentlyContinue
                        Write-Host "Updated: `$file"
                    }
                }
            }
        } catch {
            # Ignore errors for binary files or encoding issues
        }
    }
}
"@

$scriptContent | Out-File -FilePath $tempScript -Encoding UTF8

# Execute git filter-branch with better settings
Write-Host "🔄 Rewriting git history..." -ForegroundColor Yellow
$env:FILTER_BRANCH_SQUELCH_WARNING = "1"

try {
    # Use index-filter instead of tree-filter for better performance
    git filter-branch --force --index-filter "git rm --cached --ignore-unmatch *; git reset --mixed HEAD" --tree-filter "powershell.exe -ExecutionPolicy Bypass -NoProfile -File `"$tempScript`"" --prune-empty -- --all
    
    if ($LASTEXITCODE -eq 0) {
        Write-Success "Git history rewrite completed successfully!"
    }
    else {
        Write-Error "Git filter-branch failed with exit code $LASTEXITCODE"
        exit 1
    }
}
finally {
    # Clean up the temporary script
    if (Test-Path $tempScript) {
        Remove-Item $tempScript -ErrorAction SilentlyContinue
    }
}

# Clean up git references
Write-Host "`n🧹 Cleaning up git references..." -ForegroundColor Yellow
git for-each-ref --format='delete %(refname)' refs/original | git update-ref --stdin 2>$null
git reflog expire --expire=now --all 2>$null
git gc --prune=now --aggressive 2>$null

# Verify cleanup
Write-Host "`n🔍 Verifying cleanup..." -ForegroundColor Yellow
$remaining = git log --all -S "$TextToRemove" --oneline 2>$null
if ($remaining) {
    Write-Warning "Some references may still exist:"
    $remaining | ForEach-Object { Write-Host "  $_" -ForegroundColor Gray }
}
else {
    Write-Success "All instances of the specified text have been removed from history!"
}

# Summary
Write-Header "📊 Cleanup Summary"
Write-Info "Target text: '$TextToRemove'"
Write-Info "Replaced with: '$ReplacementText'"
Write-Info "File patterns searched: $FilePatterns"
if (-not $NoBackup) {
    Write-Info "Backup branch: $BackupBranchName"
}
Write-Info "Current branch: $currentBranch"

Write-Host "`n🎯 Next Steps:" -ForegroundColor Cyan
Write-Host "  1. Verify your repository contents are correct" -ForegroundColor White
Write-Host "  2. If you have a remote repository:" -ForegroundColor White
Write-Host "     git push --force-with-lease" -ForegroundColor Gray
Write-Host "  3. Notify collaborators that history has been rewritten" -ForegroundColor White
if (-not $NoBackup) {
    Write-Host "  4. Delete backup branch when satisfied: git branch -D $BackupBranchName" -ForegroundColor White
}

Write-Success "Git history cleanup completed successfully! 🎉"
