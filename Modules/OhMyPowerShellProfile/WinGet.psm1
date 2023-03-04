function Update-WinGetPackages {
    $AvailableUpgradesOutput = winget upgrade

    # profiles core packages
    _CheckApps $OMPSProfilesConfiguration.winget.core $AvailableUpgradesOutput

    # profiles group packages
    $OMPSProfilesConfiguration.winget.groups `
    | Where-Object { $OMPSProfileConfiguration.winget.groups -contains $_.id } `
    | ForEach-Object { _CheckApps $_.packages $AvailableUpgradesOutput }

    # profile extra packages
    _CheckApps $OMPSProfileConfiguration.winget.packages $AvailableUpgradesOutput
}

function _CheckApps($Apps, $AvailableUpgradesOutput) {
    foreach ($App in $Apps) {
        if (-Not ($AvailableUpgradesOutput -match $App)) {
            continue
        }
        Write-Output "Upgrading $App..."
        winget upgrade $App
    }
}
