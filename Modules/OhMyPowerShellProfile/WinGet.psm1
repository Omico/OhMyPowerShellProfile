function Update-WinGetPackages {
    $AvailableUpgradesOutput = winget upgrade
    $CurrentPackagesOutput = winget list

    # profiles core packages
    _CheckApps $OMPSProfilesConfiguration.winget.core $CurrentPackagesOutput $AvailableUpgradesOutput

    # profiles group packages
    $OMPSProfilesConfiguration.winget.groups `
    | Where-Object { $OMPSProfileConfiguration.winget.groups -contains $_.id } `
    | ForEach-Object { _CheckApps $_.packages $CurrentPackagesOutput $AvailableUpgradesOutput }

    # profile extra packages
    _CheckApps $OMPSProfileConfiguration.winget.packages $CurrentPackagesOutput $AvailableUpgradesOutput
}

function _CheckApps($Apps, $CurrentPackagesOutput, $AvailableUpgradesOutput) {
    foreach ($App in $Apps) {
        if (-Not ($CurrentPackagesOutput -match $App)) {
            Write-Output "Installing $App..."
            winget install $App
            continue
        }
        if (-Not ($AvailableUpgradesOutput -match $App)) { continue }
        Write-Output "Upgrading $App..."
        winget upgrade $App
    }
}

# https://learn.microsoft.com/en-us/windows/package-manager/winget/tab-completion
# @formatter:off
# Turn off formatting because IntelliJ plugin let `--word="$Local:word"` become `--word = "$Local:word"`.
Register-ArgumentCompleter -Native -CommandName winget -ScriptBlock {
    param($wordToComplete, $commandAst, $cursorPosition)
    [Console]::InputEncoding = [Console]::OutputEncoding = $OutputEncoding = [System.Text.Utf8Encoding]::new()
    $Local:word = $wordToComplete.Replace('"', '""')
    $Local:ast = $commandAst.ToString().Replace('"', '""')
    winget complete --word="$Local:word" --commandline "$Local:ast" --position $cursorPosition | ForEach-Object {
        [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
    }
}
# @formatter:on
