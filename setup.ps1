# ==============================================================================
# Script Name: setup.ps1
# Description: Downloads all mods and resource packs declared in modrinth.index.json
#              into .minecraft/ directory for local developer testing.
# Usage:
#   .\setup.ps1 [-TargetDir <path>] [-Force]
# ==============================================================================

[CmdletBinding()]
param(
    [string]$TargetDir = ".minecraft",
    [switch]$Force
)

$ErrorActionPreference = "Stop"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$manifestPath = Join-Path $scriptDir "modrinth.index.json"
$overridesDir = Join-Path $scriptDir "overrides"

if (-not (Test-Path $manifestPath)) {
    Write-Error "modrinth.index.json not found in $scriptDir"
    exit 1
}

$resolvedTarget = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($TargetDir)
if (-not (Test-Path $resolvedTarget)) {
    New-Item -ItemType Directory -Path $resolvedTarget | Out-Null
}

# 1. Copy overrides into target instance
if (Test-Path $overridesDir) {
    Write-Host "Syncing overrides into $resolvedTarget..." -ForegroundColor Cyan
    Copy-Item -Path "$overridesDir\*" -Destination $resolvedTarget -Recurse -Force
}

# 2. Download mods and resourcepacks from manifest
$manifest = Get-Content $manifestPath -Raw | ConvertFrom-Json
$total = $manifest.files.Count
$current = 0

Write-Host "Downloading $total declared modpack assets..." -ForegroundColor Cyan

foreach ($file in $manifest.files) {
    $current++
    $relPath = $file.path
    $destPath = Join-Path $resolvedTarget $relPath
    $destFolder = Split-Path -Parent $destPath

    if (-not (Test-Path $destFolder)) {
        New-Item -ItemType Directory -Path $destFolder | Out-Null
    }

    if ((Test-Path $destPath) -and (-not $Force)) {
        Write-Host "  [$current/$total] [OK] $relPath already exists." -ForegroundColor DarkGray
        continue
    }

    $downloadUrl = $file.downloads[0]
    Write-Host "  [$current/$total] -> Downloading $relPath..." -ForegroundColor Yellow

    try {
        $tempPath = "$destPath.tmp"
        Invoke-WebRequest -Uri $downloadUrl -OutFile $tempPath -UserAgent "NAF-Modpack-Setup/1.0"
        Move-Item -Path $tempPath -Destination $destPath -Force
        Write-Host "  [$current/$total] [+] $relPath downloaded." -ForegroundColor Green
    }
    catch {
        Write-Warning "Failed to download $relPath : $_"
        if (Test-Path $tempPath) {
            Remove-Item $tempPath -Force -ErrorAction SilentlyContinue
        }
    }
}

Write-Host "`nSetup complete! Modpack instance prepared in $resolvedTarget" -ForegroundColor Green
