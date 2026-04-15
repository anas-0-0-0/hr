$ErrorActionPreference = "Stop"
Set-Location -Path $PSScriptRoot

$logFile = Join-Path $PSScriptRoot "run-site.log"
"==========================================" | Out-File -FilePath $logFile -Encoding utf8
"HR Dashboard Runner" | Out-File -FilePath $logFile -Encoding utf8 -Append
"Started: $(Get-Date)" | Out-File -FilePath $logFile -Encoding utf8 -Append
"Path: $PSScriptRoot" | Out-File -FilePath $logFile -Encoding utf8 -Append
"==========================================" | Out-File -FilePath $logFile -Encoding utf8 -Append

Write-Host "Starting HR Dashboard..."
Write-Host "Project: $PSScriptRoot"
Write-Host "Log file: $logFile"

if (-not (Get-Command npm -ErrorAction SilentlyContinue)) {
  "ERROR: npm not found in PATH" | Out-File -FilePath $logFile -Encoding utf8 -Append
  Write-Host "Node.js/NPM not installed. Install from https://nodejs.org" -ForegroundColor Red
  Read-Host "Press Enter to close"
  exit 1
}

if (-not (Test-Path (Join-Path $PSScriptRoot "package.json"))) {
  "ERROR: package.json not found" | Out-File -FilePath $logFile -Encoding utf8 -Append
  Write-Host "package.json not found in project folder." -ForegroundColor Red
  Read-Host "Press Enter to close"
  exit 1
}

if (-not (Test-Path (Join-Path $PSScriptRoot "node_modules"))) {
  Write-Host "Installing packages first..."
  npm install *>> $logFile
}

# Ensure port 5173 is free to avoid stale 404/errors.
$portConnections = Get-NetTCPConnection -LocalPort 5173 -ErrorAction SilentlyContinue
if ($portConnections) {
  $owners = $portConnections | Select-Object -ExpandProperty OwningProcess -Unique
  foreach ($owner in $owners) {
    "KILL PID: $owner (port 5173)" | Out-File -FilePath $logFile -Encoding utf8 -Append
    taskkill /PID $owner /F *>> $logFile
  }
}

if (Test-Path (Join-Path $PSScriptRoot "node_modules/.vite")) {
  Remove-Item -Recurse -Force (Join-Path $PSScriptRoot "node_modules/.vite")
}

"COMMAND: npm run dev -- --host 127.0.0.1 --port 5173 --strictPort" | Out-File -FilePath $logFile -Encoding utf8 -Append

Start-Process "powershell.exe" -ArgumentList @(
  "-NoExit",
  "-Command",
  "Set-Location -Path '$PSScriptRoot'; npm run dev -- --force --host 127.0.0.1 --port 5173 --strictPort"
)

Start-Sleep -Seconds 3
Start-Process "http://127.0.0.1:5173"

Write-Host "Done. If site does not open, send me run-site.log."
