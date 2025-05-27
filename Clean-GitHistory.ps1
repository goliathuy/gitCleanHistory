param(
    [Parameter(Mandatory=$true, HelpMessage="Text to remove from git history")]
    [string]$TextToRemove,
    
    [Parameter(Mandatory=$false, HelpMessage="Replacement text (default: [REDACTED])")]
    [string]$ReplacementText = "[REDACTED]",
    
    [Parameter(Mandatory=$false, HelpMessage="File patterns to search (comma-separated, default: *.py,*.bat,*.md,*.txt,*.json)")]
    [string]$FilePatterns = "*.py,*.bat,*.md,*.txt,*.json",
    
    [Parameter(Mandatory=$false, HelpMessage="Skip confirmation prompt")]
    [switch]$Force,
    
    [Parameter(Mandatory=$false, HelpMessage="Skip creating backup branch")]
    [switch]$NoBackup,
    
    [Parameter(Mandatory=$false, HelpMessage="Backup branch name")]
    [string]$BackupBranchName = "backup-before-cleanup-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
)

<#
.SYNOPSIS
    Generic Git History Cleaner - Remove sensitive text from entire git history

.DESCRIPTION
    This PowerShell script safely removes sensitive text from your entire git repository history.
    It uses git filter-branch to rewrite all commits, replacing specified text with a safe alternative.
    
    ⚠️  WARNING: This script rewrites git history! All commit hashes will change.
    
.PARAMETER TextToRemove
    The exact text to search for and remove from git history (required)

.PARAMETER ReplacementText
    Text to replace the sensitive content with (default: "[REDACTED]")

.PARAMETER FilePatterns
    Comma-separated list of file patterns to search (default: "*.py,*.bat,*.md,*.txt,*.json")

.PARAMETER Force
    Skip confirmation prompt and proceed automatically

.PARAMETER NoBackup
    Skip creating a backup branch (not recommended)

.PARAMETER BackupBranchName
    Name for the backup branch (default: backup-before-cleanup-TIMESTAMP)

.EXAMPLE
    .\Clean-GitHistory.ps1 -TextToRemove "secret-api-key-12345" -ReplacementText "REDACTED-API-KEY"
    
.EXAMPLE
    .\Clean-GitHistory.ps1 -TextToRemove "internal-server-name.company.com" -FilePatterns "*.config,*.yml,*.json" -Force

.NOTES
    Author: Git History Cleaner
    Version: 2.0
    Requires: Git, PowerShell 5.0+
    
    IMPORTANT WARNINGS:
    - This rewrites git history - all commit hashes will change
    - Notify collaborators before running on shared repositories
    - Test on a repository copy first
    - Use git push --force-with-lease to update remote repositories
#>

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

Write-Header "🧹 Generic Git History Cleaner"

Write-Info "Text to remove: '$TextToRemove'"
Write-Info "Replacement text: '$ReplacementText'"
Write-Info "File patterns: $FilePatterns"
Write-Info "Backup branch: $BackupBranchName"

# Get current branch
try {
    $currentBranch = git rev-parse --abbrev-ref HEAD 2>$null
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Failed to get current branch information"
        exit 1
    }
    Write-Info "Current branch: $currentBranch"
} catch {
    Write-Error "Error getting git branch information: $_"
    exit 1
}

# Create backup branch unless skipped
if (-not $NoBackup) {
    Write-Host "`n💾 Creating backup branch '$BackupBranchName'..." -ForegroundColor Yellow
    git branch $BackupBranchName
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Failed to create backup branch"
        exit 1
    }
    Write-Success "Backup branch created successfully"
}

# Search for affected commits
Write-Host "`n🔍 Searching for commits containing the text..." -ForegroundColor Yellow
$affectedCommits = git log --all --oneline -S "$TextToRemove" 2>$null
if ($affectedCommits) {
    Write-Host "Found affected commits:" -ForegroundColor Green
    $affectedCommits | ForEach-Object { Write-Host "  $_" -ForegroundColor Gray }
} else {
    Write-Warning "No commits found containing the specified text"
    $continueAnyway = Read-Host "Continue anyway? (y/N)"
    if ($continueAnyway -ne 'y' -and $continueAnyway -ne 'Y') {
        Write-Info "Operation cancelled"
        exit 0
    }
}

# Confirm operation unless forced
if (-not $Force) {
    Write-Host "`n⚠️  CRITICAL WARNING:" -ForegroundColor Red
    Write-Host "This operation will:" -ForegroundColor Red
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

# Escape the text for regex use
$escapedText = [regex]::Escape($TextToRemove)
$escapedReplacement = $ReplacementText -replace '\$', '$$'

# Convert file patterns to array
$patterns = $FilePatterns -split ','

# Build the filter command
$filterCommands = @()
foreach ($pattern in $patterns) {
    $pattern = $pattern.Trim()
    $filterCommands += @"
    if (Test-Path "$pattern") {
        Get-ChildItem -Filter "$pattern" -Recurse | ForEach-Object {
            if (Test-Path `$_.FullName -PathType Leaf) {
                try {
                    `$content = Get-Content `$_.FullName -Raw -ErrorAction SilentlyContinue
                    if (`$content -and `$content.Contains('$TextToRemove')) {
                        `$newContent = `$content -replace '$escapedText', '$escapedReplacement'
                        Set-Content `$_.FullName `$newContent -NoNewline -ErrorAction SilentlyContinue
                    }
                } catch {
                    # Ignore errors for binary files or encoding issues
                }
            }
        }
    }
"@
}

$fullFilterCommand = $filterCommands -join "`n"

# Execute git filter-branch
Write-Host "🔄 Rewriting git history..." -ForegroundColor Yellow
$env:FILTER_BRANCH_SQUELCH_WARNING = "1"

try {
    # Create a temporary script file for the filter
    $tempScript = [System.IO.Path]::GetTempFileName() + ".ps1"
    $fullFilterCommand | Out-File -FilePath $tempScript -Encoding UTF8
    
    # Run git filter-branch with PowerShell script
    git filter-branch --force --tree-filter "powershell.exe -ExecutionPolicy Bypass -File `"$tempScript`"" --prune-empty -- --all
    
    if ($LASTEXITCODE -eq 0) {
        Write-Success "Git history rewrite completed successfully!"
        
        # Clean up the temporary script
        Remove-Item $tempScript -ErrorAction SilentlyContinue
        
        # Clean up git references
        Write-Host "`n🧹 Cleaning up git references..." -ForegroundColor Yellow
        git for-each-ref --format='delete %(refname)' refs/original | git update-ref --stdin
        git reflog expire --expire=now --all
        git gc --prune=now --aggressive
        
        # Verify cleanup
        Write-Host "`n🔍 Verifying cleanup..." -ForegroundColor Yellow
        $remaining = git log --all -S "$TextToRemove" --oneline 2>$null
        if ($remaining) {
            Write-Warning "Some references may still exist:"
            $remaining | ForEach-Object { Write-Host "  $_" -ForegroundColor Gray }
        } else {
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
        
    } else {
        Write-Error "Git history rewrite failed!"
        if (-not $NoBackup) {
            Write-Host "You can restore from backup: git checkout $BackupBranchName" -ForegroundColor Yellow
        }
        exit 1
    }
    
} catch {
    Write-Error "Error during git history rewrite: $_"
    if (Test-Path $tempScript) {
        Remove-Item $tempScript -ErrorAction SilentlyContinue
    }
    exit 1
} finally {
    Remove-Item $env:FILTER_BRANCH_SQUELCH_WARNING -ErrorAction SilentlyContinue
}

Write-Success "Git history cleanup completed successfully! 🎉"
