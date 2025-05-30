# Test Script for Git History Cleaner
# This script creates a test repository and validates the cleanup functionality

param(
    [Parameter(Mandatory = $false, HelpMessage = "Skip cleanup of test directory")]
    [switch]$KeepTestDir
)

Write-Host "🧪 Git History Cleaner Test Script" -ForegroundColor Cyan
Write-Host "=================================" -ForegroundColor Cyan

# Create test directory
$testDir = "git-cleaner-test-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
$originalDir = Get-Location

try {
    Write-Host "`n📁 Creating test repository: $testDir" -ForegroundColor Yellow
    
    # Create and setup test repository
    New-Item -ItemType Directory -Path $testDir -Force | Out-Null
    Set-Location $testDir
    
    git init --quiet
    git config user.email "test@example.com"
    git config user.name "Test User"
      # Create test files with sensitive content
    Write-Host "📝 Creating test files with sensitive content..." -ForegroundColor Yellow
    
    $testConfig = @{
        "api_key" = "RANDOM-TEST-TOKEN-999"
        "database_url" = "postgresql://user:RANDOM-TEST-TOKEN-999@localhost/db"
        "auth_token" = "RANDOM-TEST-TOKEN-999"
    }
    $testConfig | ConvertTo-Json | Out-File -FilePath "test-config.json" -Encoding UTF8
    
    $testDocs = @"
# Test Documentation

This document contains RANDOM-TEST-TOKEN-999 for testing purposes.

## Configuration
- API Key: RANDOM-TEST-TOKEN-999
- Auth: RANDOM-TEST-TOKEN-999

Never expose RANDOM-TEST-TOKEN-999 in production!
"@
    $testDocs | Out-File -FilePath "test-docs.md" -Encoding UTF8
    
    # Create initial commit
    git add .
    git commit -m "Add test files with RANDOM-TEST-TOKEN-999 references" --quiet
    
    # Create additional commit to test multiple history points
    "Additional RANDOM-TEST-TOKEN-999 configuration" | Add-Content -Path "test-config.json"
    git add test-config.json
    git commit -m "Update configuration with RANDOM-TEST-TOKEN-999" --quiet
    
    Write-Host "✅ Test repository created with 2 commits containing sensitive data" -ForegroundColor Green
      # Verify sensitive content exists
    Write-Host "`n🔍 Verifying sensitive content exists in history..." -ForegroundColor Yellow
    $beforeCleanup = git log --all -S "RANDOM-TEST-TOKEN-999" --oneline
    if ($beforeCleanup) {
        Write-Host "✅ Found sensitive content in $($beforeCleanup.Count) commits" -ForegroundColor Green
        $beforeCleanup | ForEach-Object { Write-Host "  $_" -ForegroundColor Gray }
    } else {
        Write-Host "❌ No sensitive content found - test setup failed" -ForegroundColor Red
        return
    }
    
    # Run the Git History Cleaner
    Write-Host "`n🧹 Running Git History Cleaner..." -ForegroundColor Yellow
    $cleanerScript = Join-Path $originalDir "Clean-GitHistory.ps1"
    
    if (-not (Test-Path $cleanerScript)) {
        Write-Host "❌ Clean-GitHistory.ps1 not found in $originalDir" -ForegroundColor Red
        Write-Host "Please run this test script from the gitCleanHistory directory" -ForegroundColor Yellow
        return
    }
    
    # Execute the cleaner with test parameters
    & $cleanerScript -TextToRemove "RANDOM-TEST-TOKEN-999" -ReplacementText "[RANDOM-REDACTED]" -Force
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Git History Cleaner completed successfully!" -ForegroundColor Green
    } else {
        Write-Host "❌ Git History Cleaner failed with exit code $LASTEXITCODE" -ForegroundColor Red
        return
    }
      # Verify cleanup success
    Write-Host "`n🔍 Verifying cleanup results..." -ForegroundColor Yellow
    
    # Check for remaining sensitive content
    $afterCleanup = git log --all -S "RANDOM-TEST-TOKEN-999" --oneline 2>$null
    if ($afterCleanup) {
        Write-Host "❌ Cleanup failed - found remaining references:" -ForegroundColor Red
        $afterCleanup | ForEach-Object { Write-Host "  $_" -ForegroundColor Gray }
    } else {
        Write-Host "✅ No sensitive content found in git history" -ForegroundColor Green
    }
    
    # Check for replacement text
    $replacementFound = git log --all -S "[RANDOM-REDACTED]" --oneline 2>$null
    if ($replacementFound) {
        Write-Host "✅ Found replacement text in $($replacementFound.Count) commits" -ForegroundColor Green
        $replacementFound | ForEach-Object { Write-Host "  $_" -ForegroundColor Gray }
    } else {
        Write-Host "⚠️  No replacement text found in history" -ForegroundColor Yellow
    }
    
    # Check current file contents
    Write-Host "`n📄 Checking current file contents..." -ForegroundColor Yellow
    $configContent = Get-Content "test-config.json" -Raw
    $docsContent = Get-Content "test-docs.md" -Raw
    
    if ($configContent -match "RANDOM-TEST-TOKEN-999" -or $docsContent -match "RANDOM-TEST-TOKEN-999") {
        Write-Host "❌ Sensitive content still found in current files" -ForegroundColor Red
    } else {
        Write-Host "✅ Current files are clean" -ForegroundColor Green
    }
    
    if ($configContent -match "\[RANDOM-REDACTED\]" -and $docsContent -match "\[RANDOM-REDACTED\]") {
        Write-Host "✅ Replacement text found in current files" -ForegroundColor Green
    } else {
        Write-Host "⚠️  Replacement text not found in some files" -ForegroundColor Yellow
    }
    
    # Final results
    Write-Host "`n🎯 Test Results Summary:" -ForegroundColor Cyan
    Write-Host "======================" -ForegroundColor Cyan
    
    $testsPassed = 0
    $totalTests = 4
    
    if (-not $afterCleanup) {
        Write-Host "✅ Test 1: Sensitive content removed from git history" -ForegroundColor Green
        $testsPassed++
    } else {
        Write-Host "❌ Test 1: Sensitive content still in git history" -ForegroundColor Red
    }
    
    if ($replacementFound) {
        Write-Host "✅ Test 2: Replacement text added to git history" -ForegroundColor Green
        $testsPassed++
    } else {
        Write-Host "❌ Test 2: Replacement text not found in git history" -ForegroundColor Red
    }
      if (-not ($configContent -match "RANDOM-TEST-TOKEN-999" -or $docsContent -match "RANDOM-TEST-TOKEN-999")) {
        Write-Host "✅ Test 3: Current files cleaned successfully" -ForegroundColor Green
        $testsPassed++
    } else {
        Write-Host "❌ Test 3: Current files still contain sensitive content" -ForegroundColor Red
    }
    
    if ($configContent -match "\[RANDOM-REDACTED\]" -and $docsContent -match "\[RANDOM-REDACTED\]") {
        Write-Host "✅ Test 4: Replacement text in current files" -ForegroundColor Green
        $testsPassed++
    } else {
        Write-Host "❌ Test 4: Replacement text not properly applied" -ForegroundColor Red
    }
    
    Write-Host "`nTests Passed: $testsPassed/$totalTests" -ForegroundColor $(if ($testsPassed -eq $totalTests) { "Green" } else { "Yellow" })
    
    if ($testsPassed -eq $totalTests) {
        Write-Host "🎉 All tests passed! Git History Cleaner is working correctly." -ForegroundColor Green
    } else {
        Write-Host "⚠️  Some tests failed. Please review the output above." -ForegroundColor Yellow
    }
    
} finally {
    # Cleanup
    Set-Location $originalDir
    
    if (-not $KeepTestDir) {
        Write-Host "`n🧹 Cleaning up test directory..." -ForegroundColor Yellow
        if (Test-Path $testDir) {
            Remove-Item $testDir -Recurse -Force
            Write-Host "✅ Test directory removed" -ForegroundColor Green
        }
    } else {
        Write-Host "`n📁 Test directory preserved at: $testDir" -ForegroundColor Yellow
        Write-Host "You can manually inspect the results or run additional tests" -ForegroundColor Gray
    }
}

Write-Host "`n🏁 Test script completed!" -ForegroundColor Cyan
