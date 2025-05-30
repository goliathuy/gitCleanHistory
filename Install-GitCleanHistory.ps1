# GitCleanHistory Installer
# Downloads and sets up GitCleanHistory tool

param(
    [string]$InstallPath = "$env:USERPROFILE\GitCleanHistory",
    [switch]$AddToPath,
    [switch]$Force
)

$ErrorActionPreference = "Stop"

function Write-Info($message) {
    Write-Host $message -ForegroundColor Green
}

function Write-Warning($message) {
    Write-Host $message -ForegroundColor Yellow
}

function Write-Error($message) {
    Write-Host $message -ForegroundColor Red
}

Write-Info "🚀 GitCleanHistory Installer v2.0.1"
Write-Info "=================================="

# Check PowerShell version
if ($PSVersionTable.PSVersion.Major -lt 5) {
    Write-Error "PowerShell 5.0 or later is required. Current version: $($PSVersionTable.PSVersion)"
    exit 1
}

# Check Git availability
try {
    git --version | Out-Null
    Write-Info "✅ Git is available"
} catch {
    Write-Error "Git is not installed or not available in PATH"
    exit 1
}

# Create installation directory
if (Test-Path $InstallPath) {
    if (-not $Force) {
        Write-Warning "Installation directory already exists: $InstallPath"
        $confirm = Read-Host "Do you want to overwrite it? (y/N)"
        if ($confirm -ne 'y' -and $confirm -ne 'Y') {
            Write-Info "Installation cancelled"
            exit 0
        }
    }
    Remove-Item $InstallPath -Recurse -Force -ErrorAction SilentlyContinue
}

New-Item -ItemType Directory -Path $InstallPath -Force | Out-Null
Write-Info "📁 Created installation directory: $InstallPath"

# Download files
$baseUrl = "https://raw.githubusercontent.com/goliathuy/gitCleanHistory/master"
$files = @(
    "Clean-GitHistory.ps1",
    "Test-GitHistoryCleaner.ps1", 
    "README.md",
    "CHANGELOG.md",
    "EXAMPLES.md",
    "LICENSE"
)

Write-Info "📥 Downloading files..."
foreach ($file in $files) {
    try {
        $url = "$baseUrl/$file"
        $destination = Join-Path $InstallPath $file
        Invoke-WebRequest -Uri $url -OutFile $destination -UseBasicParsing
        Write-Info "  ✅ Downloaded $file"
    } catch {
        Write-Error "Failed to download $file`: $($_.Exception.Message)"
        exit 1
    }
}

# Set execution policy for the script
$scriptPath = Join-Path $InstallPath "Clean-GitHistory.ps1"
Unblock-File $scriptPath -ErrorAction SilentlyContinue

Write-Info "🧪 Running verification test..."
try {
    Push-Location $InstallPath
    $testResult = & .\Test-GitHistoryCleaner.ps1 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Info "✅ Verification test passed successfully!"
    } else {
        Write-Warning "⚠️  Verification test had issues, but installation completed"
    }
} catch {
    Write-Warning "⚠️  Could not run verification test: $($_.Exception.Message)"
} finally {
    Pop-Location
}

# Add to PATH if requested
if ($AddToPath) {
    $currentPath = [Environment]::GetEnvironmentVariable("PATH", "User")
    if ($currentPath -notlike "*$InstallPath*") {
        $newPath = "$currentPath;$InstallPath"
        [Environment]::SetEnvironmentVariable("PATH", $newPath, "User")
        Write-Info "✅ Added to user PATH: $InstallPath"
        Write-Info "   (Restart PowerShell to use 'Clean-GitHistory.ps1' from anywhere)"
    } else {
        Write-Info "✅ Already in PATH: $InstallPath"
    }
}

Write-Info ""
Write-Info "🎉 Installation completed successfully!"
Write-Info ""
Write-Info "📋 Usage:"
Write-Info "  cd `"$InstallPath`""
Write-Info "  .\Clean-GitHistory.ps1 -TextToRemove `"your-sensitive-text`""
Write-Info ""
Write-Info "📖 Documentation:"
Write-Info "  README: $InstallPath\README.md"
Write-Info "  Examples: $InstallPath\EXAMPLES.md"
Write-Info ""
Write-Info "🧪 Test the installation:"
Write-Info "  .\Test-GitHistoryCleaner.ps1"
