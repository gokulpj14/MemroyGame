# run.ps1 - compile and start the MatchCards WebServer and App
# Usage: .\run.ps1

$root = Split-Path -Parent $MyInvocation.MyCommand.Definition
Push-Location $root

Write-Host "Compiling Java sources..."
javac -d bin src\*.java
if ($LASTEXITCODE -ne 0) {
  Write-Error "Compilation failed (javac returned $LASTEXITCODE)."
  Pop-Location
  exit 1
}

# Stop any existing processes by class name to avoid duplicates
$existing = Get-CimInstance Win32_Process | Where-Object { $_.CommandLine -and ($_.CommandLine -match 'WebServer' -or $_.CommandLine -match 'App') }
if ($existing) {
  Write-Host "Stopping existing MatchCards processes..."
  $existing | ForEach-Object { Stop-Process -Id $_.ProcessId -Force -ErrorAction SilentlyContinue }
  Start-Sleep -Milliseconds 300
}

Write-Host "Starting WebServer..."
$ws = Start-Process -FilePath java -ArgumentList '-cp','bin','WebServer' -PassThru
Start-Sleep -Milliseconds 300
Write-Host "Starting App (desktop)..."
$app = Start-Process -FilePath java -ArgumentList '-cp','bin','App' -PassThru

# Save PIDs to a file so stop.ps1 can use them
$pidFile = Join-Path $root ".matchcards_pids"
@{ web = $ws.Id; app = $app.Id } | ConvertTo-Json | Out-File -Encoding utf8 $pidFile

Write-Host "WebServer PID: $($ws.Id)"
Write-Host "App PID: $($app.Id)"

Pop-Location
