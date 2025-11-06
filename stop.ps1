# stop.ps1 - stop MatchCards WebServer and App
# Usage: .\stop.ps1

$root = Split-Path -Parent $MyInvocation.MyCommand.Definition
Push-Location $root

$pidFile = Join-Path $root ".matchcards_pids"
if (Test-Path $pidFile) {
  try {
    $data = Get-Content $pidFile | ConvertFrom-Json
    if ($data.web) {
      Stop-Process -Id $data.web -Force -ErrorAction SilentlyContinue
    }
    if ($data.app) {
      Stop-Process -Id $data.app -Force -ErrorAction SilentlyContinue
    }
    Remove-Item $pidFile -ErrorAction SilentlyContinue
    Write-Host "Stopped processes recorded in $pidFile"
  } catch {
    Write-Warning "Failed to read pid file; falling back to name-based stop."
  }
} else {
  Write-Host "No PID file found; stopping by process name..."
}

# fallback: stop any java processes mentioning WebServer or App on the command line
$procs = Get-CimInstance Win32_Process | Where-Object { $_.CommandLine -and ($_.CommandLine -match 'WebServer' -or $_.CommandLine -match 'App') }
if ($procs) {
  $procs | ForEach-Object { Stop-Process -Id $_.ProcessId -Force -ErrorAction SilentlyContinue }
  Write-Host "Stopped processes matched by name."
} else {
  Write-Host "No matching processes found."
}

Pop-Location
