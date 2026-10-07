# ==============================================================================
# Script Name: export.ps1
# Description: Exports NAF Minecraft Modpack to standard .mrpack and .zip formats.
# Usage:
#   .\export.ps1 [-OutDir <path>]
# ==============================================================================

[CmdletBinding()]
param(
    [string]$OutDir = "."
)

$ErrorActionPreference = "Stop"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$manifestPath = Join-Path $scriptDir "modrinth.index.json"
$overridesDir = Join-Path $scriptDir "overrides"

if (-not (Test-Path $manifestPath)) {
    Write-Error "modrinth.index.json not found in $scriptDir"
    exit 1
}

$manifest = Get-Content $manifestPath -Raw | ConvertFrom-Json
$version = $manifest.versionId
$packBase = "NAF-Minecraft-Modpack-$version"

$resolvedOutDir = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($OutDir)
if (-not (Test-Path $resolvedOutDir)) {
    New-Item -ItemType Directory -Path $resolvedOutDir | Out-Null
}

$mrpackTarget = Join-Path $resolvedOutDir "$packBase.mrpack"
$zipTarget = Join-Path $resolvedOutDir "$packBase.zip"

Write-Host "Exporting Modpack: $packBase" -ForegroundColor Cyan

if (Test-Path $mrpackTarget) { Remove-Item $mrpackTarget -Force }
if (Test-Path $zipTarget) { Remove-Item $zipTarget -Force }

$stagingDir = Join-Path $env:TEMP "mrpack_build_$([System.Guid]::NewGuid().ToString('N'))"
New-Item -ItemType Directory -Path $stagingDir | Out-Null

try {
    Copy-Item -Path $manifestPath -Destination (Join-Path $stagingDir "modrinth.index.json")

    if (Test-Path $overridesDir) {
        Copy-Item -Path $overridesDir -Destination (Join-Path $stagingDir "overrides") -Recurse
    }

    Add-Type -AssemblyName System.IO.Compression.FileSystem
    [System.IO.Compression.ZipFile]::CreateFromDirectory($stagingDir, $mrpackTarget)
    Write-Host "  [+] Generated: $mrpackTarget" -ForegroundColor Green

    Copy-Item -Path $mrpackTarget -Destination $zipTarget -Force
    Write-Host "  [+] Generated: $zipTarget" -ForegroundColor Green
}
finally {
    if (Test-Path $stagingDir) {
        Remove-Item -Path $stagingDir -Recurse -Force -ErrorAction SilentlyContinue
    }
}

Write-Host "`nModpack export completed successfully!" -ForegroundColor Green
