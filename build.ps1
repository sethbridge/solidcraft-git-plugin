$ErrorActionPreference = "Stop"

Write-Host "Building SolidCraft Git Integration Plugin..." -ForegroundColor Cyan

# Step 1: Check cargo
Write-Host "`nChecking Rust installation..." -ForegroundColor Cyan
cargo --version 2>&1 | Out-Null
if ($LASTEXITCODE -ne 0) {
    Write-Host "Error: Rust not found. Install from https://rustup.rs/" -ForegroundColor Red
    exit 1
}
Write-Host "OK: Rust installed" -ForegroundColor Green

# Step 2: Install wasm-pack if needed
Write-Host "`nChecking wasm-pack..." -ForegroundColor Cyan
wasm-pack --version 2>&1 | Out-Null
if ($LASTEXITCODE -ne 0) {
    Write-Host "Installing wasm-pack..." -ForegroundColor Yellow
    cargo install wasm-pack
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Error: Failed to install wasm-pack" -ForegroundColor Red
        exit 1
    }
}
Write-Host "OK: wasm-pack ready" -ForegroundColor Green

# Step 3: Clean
Write-Host "`nCleaning previous builds..." -ForegroundColor Cyan
if (Test-Path "pkg") {
    Remove-Item -Recurse -Force "pkg" -ErrorAction SilentlyContinue
}
Write-Host "OK: Cleaned" -ForegroundColor Green

# Step 4: Build WASM
Write-Host "`nBuilding WASM..." -ForegroundColor Cyan
wasm-pack build --target web --release
if ($LASTEXITCODE -ne 0) {
    Write-Host "Error: WASM build failed" -ForegroundColor Red
    exit 1
}
Write-Host "OK: WASM built" -ForegroundColor Green

# Step 5: Package
Write-Host "`nPackaging plugin..." -ForegroundColor Cyan
$pluginDir = "dist\solidcraft-git"

if (Test-Path $pluginDir) {
    Remove-Item -Recurse -Force $pluginDir -ErrorAction SilentlyContinue
}

New-Item -ItemType Directory -Path $pluginDir -Force | Out-Null
Copy-Item "manifest.json" "$pluginDir\" -Force
Copy-Item "pkg/solidcraft_git_plugin_bg.wasm" "$pluginDir/index.wasm" -Force
Write-Host "OK: Plugin packaged" -ForegroundColor Green

# Step 6: Zip
Write-Host "`nCreating zip archive..." -ForegroundColor Cyan
$zipPath = "solidcraft-git-plugin.zip"
if (Test-Path $zipPath) {
    Remove-Item $zipPath -Force
}

Compress-Archive -Path "$pluginDir\*" -DestinationPath $zipPath -Force
Write-Host "OK: Created $zipPath" -ForegroundColor Green

# Step 7: Validate
Write-Host "`nValidating plugin..." -ForegroundColor Cyan
$solidcraftCli = "C:\Program Files\SolidCraft\solidcraft-cli.exe"

if (Test-Path $solidcraftCli) {
    & $solidcraftCli plugin check $pluginDir 2>&1 | Out-Null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "OK: Plugin validation passed" -ForegroundColor Green
    } else {
        Write-Host "Warning: Plugin has issues (non-fatal)" -ForegroundColor Yellow
    }
} else {
    Write-Host "Warning: SolidCraft CLI not found, skipping validation" -ForegroundColor Yellow
}

# Summary
Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "Build Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Plugin: $zipPath" -ForegroundColor White
Write-Host "Size: $(Get-Item $zipPath | Select-Object -ExpandProperty Length) bytes" -ForegroundColor Gray
Write-Host ""
Write-Host "Next: Install with:" -ForegroundColor Cyan
Write-Host "  solidcraft-cli plugin install $zipPath" -ForegroundColor Yellow
Write-Host ""
