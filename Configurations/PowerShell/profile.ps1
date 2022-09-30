Get-ChildItem -Path $PSScriptRoot\Modules\OhMyPowerShellProfile -Filter *.psm1 | ForEach-Object {
    Import-Module $_.FullName
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
