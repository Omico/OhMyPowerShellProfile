function Update-WinGetSettings($InstallScriptPath) {
    $WinGetPackageFamilyName = (Get-AppxPackage -Name Microsoft.DesktopAppInstaller).PackageFamilyName
    $WinGetSettings = "$env:LocalAppData\Packages\$WinGetPackageFamilyName\LocalState\settings.json"
    if (Test-Path $WinGetSettings) { Remove-Item $WinGetSettings }
    New-Item `
        -ItemType HardLink `
        -Path "$WinGetSettings" `
        -Target "$InstallScriptPath\Configurations\WinGet\settings.json" `
        > $null
}
