<#
.SYNOPSIS
    Packs, test-installs and optionally pushes the Ctrl-V Terminal Chocolatey package.

.DESCRIPTION
    Runs on Windows with the Chocolatey CLI available. Version, id and download URL
    come from the nuspec and tools/chocolateyinstall.ps1, so run `npm run choco:sync`
    on the build machine first.

    The test install is the point of this script: it runs the same check the Chocolatey
    verifier runs, on a machine you control, and proves the NSIS installer really goes
    through unattended with /S.

.PARAMETER Push
    Push the .nupkg to the Chocolatey Community Repository after packing.
    Needs an API key: either -ApiKey, or $env:CHOCO_API_KEY, or one stored earlier
    with `choco apikey add --source https://push.chocolatey.org/ --key <key>`.

.PARAMETER SkipTest
    Skip the install/uninstall test. Only sensible when a previous run already
    tested this exact package.

.EXAMPLE
    .\publish.ps1                 # pack + test, no push (run elevated)

.EXAMPLE
    .\publish.ps1 -Push           # pack + test + push
#>
[CmdletBinding()]
param(
    [switch]$Push,
    [string]$ApiKey,
    [switch]$SkipTest
)

$ErrorActionPreference = 'Stop'

$here = Split-Path -Parent $MyInvocation.MyCommand.Definition
Push-Location $here

function Assert-LastExitCode($what) {
    if ($LASTEXITCODE -ne 0) { throw "$what failed with exit code $LASTEXITCODE" }
}

try {
    if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
        throw @"
Chocolatey CLI not found. Install it in an elevated PowerShell with:

  Set-ExecutionPolicy Bypass -Scope Process -Force
  [System.Net.ServicePointManager]::SecurityProtocol = 3072
  iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
"@
    }

    $nuspecPath = Join-Path $here 'ctrl-v-terminal.nuspec'
    [xml]$nuspec = Get-Content -Path $nuspecPath -Encoding UTF8
    $id      = $nuspec.package.metadata.id
    $version = $nuspec.package.metadata.version
    $nupkg   = Join-Path $here "$id.$version.nupkg"

    $match = Select-String -Path (Join-Path $here 'tools\chocolateyinstall.ps1') `
                           -Pattern "^\`$url64\s*=\s*'(.+)'"
    if (-not $match) { throw 'Could not read $url64 from tools\chocolateyinstall.ps1' }
    $url = $match.Matches[0].Groups[1].Value
    Write-Host "Package : $id $version"     -ForegroundColor Cyan
    Write-Host "Installer: $url"            -ForegroundColor Cyan

    if ($version -notmatch '\d+\.\d+\.\d+' -or $url -notmatch [regex]::Escape($version)) {
        throw "The nuspec version ($version) does not appear in the installer URL. Run 'npm run choco:sync' first."
    }

    Write-Host "`n== choco pack ==" -ForegroundColor Yellow
    Remove-Item -Path (Join-Path $here "$id.*.nupkg") -Force -ErrorAction SilentlyContinue
    choco pack $nuspecPath --out $here
    Assert-LastExitCode 'choco pack'
    if (-not (Test-Path $nupkg)) { throw "Expected $nupkg but it was not produced" }

    if (-not $SkipTest) {
        $isAdmin = ([Security.Principal.WindowsPrincipal] `
            [Security.Principal.WindowsIdentity]::GetCurrent()
        ).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
        if (-not $isAdmin) {
            throw 'The install test needs an elevated shell (the package installs per-machine). Re-run as administrator, or pass -SkipTest.'
        }

        Write-Host "`n== choco install (test) ==" -ForegroundColor Yellow
        Write-Host 'A hang here would mean the installer is showing a dialog in silent mode, which is a blocker.' -ForegroundColor DarkGray
        choco install $id --source "$here" --yes --no-progress --debug
        Assert-LastExitCode 'choco install'

        $exe = Join-Path $env:ProgramFiles 'Ctrl-V Terminal\Ctrl-V Terminal.exe'
        if (-not (Test-Path $exe)) { throw "Install reported success but $exe is missing" }
        Write-Host "Found $exe" -ForegroundColor Green

        Write-Host "`n== choco uninstall (test) ==" -ForegroundColor Yellow
        choco uninstall $id --yes --no-progress
        Assert-LastExitCode 'choco uninstall'
        if (Test-Path $exe) {
            Write-Warning "$exe still exists after uninstall. Check the uninstall script before pushing."
        } else {
            Write-Host 'Uninstall removed the application.' -ForegroundColor Green
        }
    }

    if ($Push) {
        if (-not $ApiKey) { $ApiKey = $env:CHOCO_API_KEY }

        Write-Host "`n== choco push ==" -ForegroundColor Yellow
        if ($ApiKey) {
            choco push $nupkg --source 'https://push.chocolatey.org/' --api-key $ApiKey
        } else {
            # Falls back to the key stored in chocolatey.config for this source.
            choco push $nupkg --source 'https://push.chocolatey.org/'
        }
        Assert-LastExitCode 'choco push'
        Write-Host "Pushed. Follow moderation at https://community.chocolatey.org/packages/$id/$version" -ForegroundColor Green
    } else {
        Write-Host "`nBuilt $nupkg (not pushed)." -ForegroundColor Green
    }
}
finally {
    Pop-Location
}
