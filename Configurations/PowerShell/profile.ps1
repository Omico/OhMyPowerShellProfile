# Import-Module PSProfiler
# Measure-Script { }

Get-ChildItem -Path $PSScriptRoot\Modules\OhMyPowerShellProfile -Filter *.psm1 | Import-Module

Set-GlobalOMPSProfilesConfiguration $PSScriptRoot\Modules\OhMyPowerShellProfile\profiles.json
Set-GlobalOMPSProfileConfiguration

# If opened by Windows Terminal, change the default location to $HOME.
if ("$($PWD.Path)" -eq "$env:SystemRoot\System32") {
    Set-Location $HOME
}

$Modules = @(
    "Terminal-Icons"
    "PSWindowsUpdate"
)

foreach ($Module in $Modules) {
    if (Get-Module -ListAvailable -Name $Module) {
        Import-Module $Module
    }
}

Initialize-PSReadLine
Initialize-OhMyPosh
