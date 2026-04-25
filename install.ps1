$Repo = "OmarAly92/victor"
$BinaryName = "victor.exe"
$InstallDir = "$env:LOCALAPPDATA\Microsoft\WindowsApps"

if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
    Write-Host "GitHub CLI (gh) is required. Install it from: https://cli.github.com"
    exit 1
}

$AuthStatus = gh auth status 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "Not logged in to GitHub. Run: gh auth login"
    exit 1
}

Write-Host "Downloading victor (windows)..."
$TmpDir = Join-Path $env:TEMP "victor-install"
New-Item -ItemType Directory -Force -Path $TmpDir | Out-Null

gh release download latest `
    --repo $Repo `
    --pattern "agent-windows.zip" `
    --dir $TmpDir

Write-Host "Installing..."
Expand-Archive -Path "$TmpDir\agent-windows.zip" -DestinationPath $TmpDir -Force
Copy-Item "$TmpDir\agent\victor.exe" "$InstallDir\$BinaryName" -Force
Remove-Item $TmpDir -Recurse -Force

Write-Host "Done. Run: victor"
