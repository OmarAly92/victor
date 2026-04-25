$Repo = "OmarAly92/victor"
$InstallDir = "$env:LOCALAPPDATA\Programs\Victor"
$BinShim = "$env:LOCALAPPDATA\Microsoft\WindowsApps\victor.cmd"
$DownloadUrl = "https://github.com/$Repo/releases/latest/download/agent-windows.zip"

Write-Host "Downloading victor (windows)..."
$TmpDir = Join-Path $env:TEMP "victor-install"
if (Test-Path $TmpDir) { Remove-Item $TmpDir -Recurse -Force }
New-Item -ItemType Directory -Force -Path $TmpDir | Out-Null

$ZipPath = Join-Path $TmpDir "agent.zip"
Invoke-WebRequest $DownloadUrl -OutFile $ZipPath

Write-Host "Installing..."
Expand-Archive -Path $ZipPath -DestinationPath $TmpDir -Force

$BundleDir = Get-ChildItem -Path $TmpDir -Recurse -Directory -Filter "bundle" | Select-Object -First 1
if (-not $BundleDir) {
    Write-Host "Could not find bundle in zip"
    exit 1
}

$Telegram = Join-Path $BundleDir.FullName "bin\telegram.exe"
$Victor = Join-Path $BundleDir.FullName "bin\victor.exe"
if (Test-Path $Telegram) {
    Move-Item $Telegram $Victor -Force
}

if (Test-Path $InstallDir) { Remove-Item $InstallDir -Recurse -Force }
New-Item -ItemType Directory -Force -Path (Split-Path $InstallDir) | Out-Null
Move-Item $BundleDir.FullName $InstallDir -Force

Set-Content -Path $BinShim -Value "@echo off`r`n`"$InstallDir\bin\victor.exe`" %*"

Remove-Item $TmpDir -Recurse -Force

Write-Host "Done. Run: victor"
