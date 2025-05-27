function Write-Info {
    param([string]$Message)
    Write-Host $Message
}

$ReplacementText = "test"
Write-Info "Replaced with: '$ReplacementText'"
Write-Host "Test completed"
