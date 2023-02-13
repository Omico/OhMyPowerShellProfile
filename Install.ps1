Set-Location $PSScriptRoot

if ([System.Environment]::OSVersion.Version.Build -lt 22621) {
    Write-Host "This script requires Windows 11 22H2 (OS build 22621) or later."
    exit 1
}

if (-Not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
        $Command = "-NoProfile -File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
        Start-Process -FilePath pwsh -Verb RunAs -ArgumentList $Command
        exit
    }
}

function Import-Modules([Parameter(Mandatory = $true)][string]$Path) {
    Get-ChildItem -Path $Path -Filter *.psm1 | ForEach-Object {
        Import-Module $_.FullName
    }
}

Import-Modules ".\Installer"
Import-Modules ".\Modules\OhMyPowerShellProfile"

Write-Host "Enabling Windows features..."
Enable-WindowsFeatures

Write-Host "Uninstalling provisioned packages..."
Uninstall-ProvisionedPackages

Write-Host "Installing WSL..."
Install-WSL

Write-Host "Installing PowerShell modules..."
Initialize-PowerShellModules

Write-Host "Initializing PowerShell profile..."
Initialize-PowerShellProfile -InstallScriptPath $PSScriptRoot

Write-Host "Initializing Oh My Posh..."
Initialize-OhMyPoshFont
Initialize-OhMyPosh

Write-Host "Initializing Windows Terminal..."
Initialize-WindowsTerminal

Write-Host "Installation complete. Please restart your computer."
$Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") | Out-Null
