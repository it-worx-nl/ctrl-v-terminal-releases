$ErrorActionPreference = 'Stop'

$packageName = 'ctrl-v-terminal'
$url64       = 'https://github.com/it-worx-nl/ctrl-v-terminal-releases/releases/download/v1.2.36/Ctrl-V-Terminal-Setup-1.2.36.exe'
$checksum64  = '0a1f0ff061015bd225b12ee8520af416faf008017d02a12e857ac206a656eea6'

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
