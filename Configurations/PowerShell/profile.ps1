# Import-Module PSProfiler
# Measure-Script { }

Get-ChildItem -Path $PSScriptRoot\Modules\OhMyPowerShellProfile -Filter *.psm1 | Import-Module

Set-GlobalOMPSProfilesConfiguration $PSScriptRoot\Modules\OhMyPowerShellProfile\profiles.json
Set-GlobalOMPSProfileConfiguration

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

if ("$($PWD.Path)" -eq "$env:SystemRoot\System32") {
    Set-Location $HOME
}
