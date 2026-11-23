$ErrorActionPreference = 'Stop'

$packageName = 'ctrl-v-terminal'
$url64       = 'https://github.com/it-worx-nl/ctrl-v-terminal-releases/releases/download/v1.2.39/Ctrl-V-Terminal-Setup-1.2.39.exe'
$checksum64  = '1a3b82a95ad899b7b893ccc5abe78a44c4cbec49635bd37723b2f4e3c8a1f84b'

$packageArgs = @{
  packageName    = $packageName
  fileType       = 'exe'
  url64bit       = $url64
  checksum64     = $checksum64
  checksumType64 = 'sha256'
  softwareName   = 'CtrlVTerm*'
  # NSIS installer built by electron-builder (oneClick: false, perMachine: true)
  silentArgs     = '/S'
  validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
