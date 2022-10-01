Set-Location $PSScriptRoot

if (-Not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
        $Command = "-NoProfile -File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
        Start-Process -FilePath pwsh -Verb RunAs -ArgumentList $Command
        Exit;
    }
}

Get-ChildItem -Path .\Installer -Filter *.psm1 | ForEach-Object {
    Import-Module $_.FullName
}

Get-ChildItem -Path .\Modules\OhMyPowerShellProfile -Filter *.psm1 | ForEach-Object {
    Import-Module $_.FullName
}

Write-Host "Enabling Windows features..."
Enable-WindowsFeatures

Write-Host "Uninstalling provisioned packages..."
Uninstall-ProvisionedPackages

Write-Host "Installing PowerShell modules..."
Initialize-PowerShellModules

Write-Host "Initializing PowerShell profile..."
Initialize-PowerShellProfile -InstallScriptPath $PSScriptRoot

Write-Host "Initializing Oh My Posh..."
Initialize-OhMyPoshFont
Initialize-OhMyPosh

Write-Host "Installing Windows Terminal..."
Initialize-WindowsTerminal

Write-Host "Installation complete. Please restart your computer."
$Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") | Out-Null
