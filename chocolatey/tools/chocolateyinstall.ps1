$ErrorActionPreference = 'Stop'

$packageName = 'ctrl-v-terminal'
$url64       = 'https://github.com/it-worx-nl/ctrl-v-terminal-releases/releases/download/v1.2.16/Ctrl-V-Terminal-Setup-1.2.16.exe'
$checksum64  = '0f3e74d9b52f18a4a9a350668e36f94ee58a54995db71eba35a5030ca56fcaa2'

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
