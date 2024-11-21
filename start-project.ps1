# PowerShell version of the startup script
$env:WORKSPACE_ID = "test3426547-recruiterlan-27j5vjmbsa"
$env:FRONTEND_PORT = 3001
$env:BACKEND_PORT = 8000
$env:OPENHANDS_PORT = 3000
$env:LANGFLOW_PORT = 7860

Write-Host "🚀 Starting RecruitmentLangFlow Development Environment..."

# Load .env if exists
if (Test-Path .env) {
    Get-Content .env | ForEach-Object {
        if ($_ -match '^([^=]+)=(.*)$') {
            [Environment]::SetEnvironmentVariable($matches[1], $matches[2])
        }
    }
}

# Start all services (similar to bash version)
# ... (add Windows-specific commands)
