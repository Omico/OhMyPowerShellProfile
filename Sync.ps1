$DefaultOMPSModuleDirectory = "$HOME\Documents\PowerShell\Modules\OhMyPowerShellProfile"

if ($null -eq $OMPSModuleDirectory) {
    Write-Output "`$OMPSModuleDirectory is not set."
    if (Test-Path $DefaultOMPSModuleDirectory) {
        Write-Output "Setting `$OMPSModuleDirectory = $DefaultOMPSModuleDirectory."
        $Global:OMPSModuleDirectory = $DefaultOMPSModuleDirectory
    }
}

if ($null -eq $OMPSModuleDirectory) {
    Write-Output "Did you install OhMyPowerShellProfile? If not, please follow the instructions in README.md."
    Write-Output "Please set `$OMPSModuleDirectory to the path of the OhMyPowerShellProfile module directory."
    Write-Output "Default should be $HOME\Documents\PowerShell\Modules\OhMyPowerShellProfile."
    Write-Output "Exiting..."
    return
}

git -C "$PSScriptRoot" pull

$PSModules = Get-ChildItem -Path "$PSScriptRoot\Modules\OhMyPowerShellProfile" -Filter *.psm1
$PSModules | Import-Module

foreach ($PSModule in $PSModules) {
    Copy-Item -Path "$PSModule" -Destination "$OMPSModuleDirectory\$($PSModule.Name)" -Force
}
