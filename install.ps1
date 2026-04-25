$Repo = "OmarAly92/victor"
$BinaryName = "victor.exe"
$InstallDir = "$env:LOCALAPPDATA\Microsoft\WindowsApps"

$DownloadUrl = "https://github.com/$Repo/releases/latest/download/agent-windows.zip"

Write-Host "Downloading victor (windows)..."
$TmpDir = Join-Path $env:TEMP "victor-install"
New-Item -ItemType Directory -Force -Path $TmpDir | Out-Null

$ZipPath = Join-Path $TmpDir "agent.zip"
Invoke-WebRequest $DownloadUrl -OutFile $ZipPath

Write-Host "Installing..."
Expand-Archive -Path $ZipPath -DestinationPath $TmpDir -Force
Copy-Item "$TmpDir\agent\victor.exe" "$InstallDir\$BinaryName" -Force
Remove-Item $TmpDir -Recurse -Force

Write-Host "Done. Run: victor"
