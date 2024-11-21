#!/bin/bash

# Configuration
WORKSPACE_ID="test3426547-recruiterlan-27j5vjmbsa"
FRONTEND_PORT=3001
BACKEND_PORT=8000
OPENHANDS_PORT=3000
LANGFLOW_PORT=7860
ENV_FILE=".env"

echo "🚀 Starting RecruitmentLangFlow Development Environment..."

# Load environment variables
if [ -f "$ENV_FILE" ]; then
    echo "📝 Loading environment variables..."
    set -a
    source "$ENV_FILE"
    set +a
else
    echo "⚠️ No .env file found, using defaults"
fi

# 1. Start OpenHands Docker
echo "📦 Starting OpenHands..."
docker pull docker.all-hands.dev/all-hands-ai/runtime:0.14-nikolaik
docker run -d --rm --pull=always \
    -e SANDBOX_RUNTIME_CONTAINER_IMAGE=docker.all-hands.dev/all-hands-ai/runtime:0.14-nikolaik \
    -e LOG_ALL_EVENTS=true \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -p ${OPENHANDS_PORT}:3000 \
    --add-host host.docker.internal:host-gateway \
    --name openhands-app \
    docker.all-hands.dev/all-hands-ai/openhands:0.14

# 2. Start LangFlow with custom components
echo "🔄 Starting LangFlow on port ${LANGFLOW_PORT}..."
langflow run --port ${LANGFLOW_PORT} --components-path ./components &

# 3. Start Next.js Frontend
echo "🌐 Starting Frontend on port ${FRONTEND_PORT}..."
cd frontend && npm run dev -- -p ${FRONTEND_PORT} &

# 4. Start FastAPI Backend
echo "🔧 Starting Backend on port ${BACKEND_PORT}..."
cd backend && uvicorn main:app --reload --port ${BACKEND_PORT} &

# 5. Launch IDEs based on environment
if [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "win32" ]]; then
    # Windows/PowerShell
    echo "🖥️ Launching IDEs in Windows..."
    # Launch Cursor
    powershell.exe Start-Process cursor --folder-uri "vscode-remote://ssh-remote+${WORKSPACE_ID}@${WORKSPACE_ID}.ssh.app.codeanywhere.com:30000/workspaces/recruiterlangflow"
    # Launch PyCharm (adjust path as needed)
    powershell.exe Start-Process "C:\Program Files\JetBrains\PyCharm\bin\pycharm64.exe" -ArgumentList "ssh://codeany@${WORKSPACE_ID}.ssh.app.codeanywhere.com:30000/workspaces/recruiterlangflow"
else
    # Unix-like systems
    echo "🖥️ Launching IDEs..."
    cursor --folder-uri "vscode-remote://ssh-remote+${WORKSPACE_ID}@${WORKSPACE_ID}.ssh.app.codeanywhere.com:30000/workspaces/recruiterlangflow" &
    # For PyCharm, you might need to adjust the path
    pycharm ssh://codeany@${WORKSPACE_ID}.ssh.app.codeanywhere.com:30000/workspaces/recruiterlangflow &
fi

# 6. Print connection URLs
echo "
🎉 Development Environment Ready!
📱 Frontend: http://localhost:${FRONTEND_PORT}
🔌 Backend: http://localhost:${BACKEND_PORT}
🤖 OpenHands: http://localhost:${OPENHANDS_PORT}
🔄 LangFlow: http://localhost:${LANGFLOW_PORT}
"

# Create PowerShell version
cat > start-project.ps1 << 'EOF'
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
EOF

# Wait for all background processes
wait