# Import-Module PSProfiler
# Measure-Script { }

$Global:OMPSModuleDirectory = "$PSScriptRoot\Modules\OhMyPowerShellProfile"

Get-ChildItem -Path $OMPSModuleDirectory -Filter *.psm1 | Import-Module

Set-GlobalOMPSProfilesConfiguration $OMPSModuleDirectory\profiles.json
Set-GlobalOMPSProfileConfiguration

# If opened by Windows Terminal, change the default location to $HOME.
if ("$($PWD.Path)" -eq "$env:SystemRoot\System32") {
    Set-Location $HOME
}

$Modules = @(
    "PSWindowsUpdate"
)

foreach ($Module in $Modules) {
    if (Get-Module -ListAvailable -Name $Module) {
        Import-Module $Module
    }
}

Initialize-PSReadLine
Initialize-OhMyPosh
