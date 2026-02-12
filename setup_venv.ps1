# Create Python 3.11 virtual environment at project root (recommended for full package support)
# Run from project root: .\setup_venv.ps1
# If 3.11 is not installed: https://www.python.org/downloads/ or: winget install Python.Python.3.11

$ErrorActionPreference = "Stop"
$venvPath = Join-Path $PSScriptRoot ".venv"

# Try Python 3.11 first
try {
    py -3.11 -c "import sys; exit(0)" 2>$null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Creating virtual environment with Python 3.11..." -ForegroundColor Green
        py -3.11 -m venv $venvPath
    } else { throw "3.11 not found" }
} catch {
    Write-Host "Python 3.11 not found. Install it from https://www.python.org/downloads/ or run: winget install Python.Python.3.11" -ForegroundColor Yellow
    Write-Host "Checking for Python via 'py' launcher..." -ForegroundColor Yellow
    if (Get-Command py -ErrorAction SilentlyContinue) {
        $ver = py -c "import sys; print(sys.version)" 2>$null
        if ($ver) {
            Write-Host "Using $ver to create .venv instead." -ForegroundColor Yellow
            py -m venv $venvPath
        } else { $venvPath = $null }
    }
    if (-not $venvPath -or -not (Test-Path $venvPath)) {
        Write-Host "No Python found. Please install Python 3.11 and run this script again." -ForegroundColor Red
        exit 1
    }
}

Write-Host "Activating and installing dependencies..." -ForegroundColor Green
& "$venvPath\Scripts\Activate.ps1"
python -m pip install --upgrade pip -q
pip install -r (Join-Path $PSScriptRoot "requirements.txt") -q
Write-Host "Done. To activate later, run: .\.venv\Scripts\Activate.ps1" -ForegroundColor Green
