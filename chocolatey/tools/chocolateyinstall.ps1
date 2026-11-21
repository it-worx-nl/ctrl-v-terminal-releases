$ErrorActionPreference = 'Stop'

$packageName = 'ctrl-v-terminal'
$url64       = 'https://github.com/it-worx-nl/ctrl-v-terminal-releases/releases/download/v1.2.38/Ctrl-V-Terminal-Setup-1.2.38.exe'
$checksum64  = '35e811426d166f4ee0cea70be816026f3728d57ae9db274762196fcedbaaa667'

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
