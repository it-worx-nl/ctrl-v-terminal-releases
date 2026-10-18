$ErrorActionPreference = 'Stop'

$packageName = 'ctrl-v-terminal'
$url64       = 'https://github.com/it-worx-nl/ctrl-v-terminal-releases/releases/download/v1.2.11/Ctrl-V-Terminal-Setup-1.2.11.exe'
$checksum64  = '5602f30743d58afa6140df2e82efd82f25d85b2276a70e66352f490800256d88'

$packageArgs = @{
  packageName    = $packageName
  fileType       = 'exe'
  url64bit       = $url64
  checksum64     = $checksum64
  checksumType64 = 'sha256'
  softwareName   = 'Ctrl-V Terminal*'
  # NSIS installer built by electron-builder (oneClick: false, perMachine: true)
  silentArgs     = '/S'
  validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
