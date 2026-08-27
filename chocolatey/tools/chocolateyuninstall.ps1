$ErrorActionPreference = 'Stop'

$packageName  = 'ctrl-v-terminal'
$softwareName = 'Ctrl-V Terminal*'

[array]$key = Get-UninstallRegistryKey -SoftwareName $softwareName

if ($key.Count -eq 1) {
  $key | ForEach-Object {
    # electron-builder registers the uninstaller as
    #   UninstallString      "<dir>\Uninstall Ctrl-V Terminal.exe" /allusers
    #   QuietUninstallString "<dir>\Uninstall Ctrl-V Terminal.exe" /allusers /S
    # so the path has to be split off from its arguments; passing the whole
    # string as the file makes Windows look for a file with the arguments in
    # its name.
    $command = if ($_.QuietUninstallString) { $_.QuietUninstallString } else { $_.UninstallString }

    if ($command -match '^\s*"([^"]+)"\s*(.*)$') {
      $file = $Matches[1]
      $arguments = $Matches[2].Trim()
    } else {
      $file = $command.Trim()
      $arguments = ''
    }

    # /S is what makes the NSIS uninstaller silent; QuietUninstallString already has it.
    if ($arguments -notmatch '(?i)(^|\s)/S(\s|$)') {
      $arguments = "$arguments /S".Trim()
    }

    Write-Debug "Uninstalling with: $file $arguments"

    $packageArgs = @{
      packageName    = $packageName
      fileType       = 'exe'
      silentArgs     = $arguments
      validExitCodes = @(0)
      file           = $file
    }
    # Discard the return value: it is the uninstaller's exit code, and letting it
    # fall through to the output stream prints a bare "0" in the user's log.
    $null = Uninstall-ChocolateyPackage @packageArgs
  }
} elseif ($key.Count -eq 0) {
  Write-Warning "$packageName has already been uninstalled by other means."
} elseif ($key.Count -gt 1) {
  Write-Warning "$($key.Count) matches found!"
  Write-Warning "To prevent accidental data loss, no programs will be uninstalled."
  Write-Warning "Please alert package maintainer the following keys were matched:"
  $key | ForEach-Object { Write-Warning "- $($_.DisplayName)" }
}
