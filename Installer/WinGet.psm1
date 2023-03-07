function Update-WinGetSettings {
    $WinGetPackageFamilyName = (Get-AppxPackage -Name Microsoft.DesktopAppInstaller).PackageFamilyName
    $WinGetSettingsFile = "$env:LocalAppData\Packages\$WinGetPackageFamilyName\LocalState\settings.json"
    $WinGetSettings = Get-Content $WinGetSettingsFile | ConvertFrom-Json

    function Add-WinGetSettingsMember($Name, $Value) {
        $WinGetSettings | Add-Member -Name $Name -Value $Value -MemberType NoteProperty -Force
    }

    $InstallBehavior = @{
        "preferences" = @{
            "scope" = "machine"
        }
    }
    Add-WinGetSettingsMember "installBehavior" $InstallBehavior

    $Telemetry = @{
        "disable" = $true
    }
    Add-WinGetSettingsMember "telemetry" $Telemetry

    $WinGetSettings | ConvertTo-Json | Set-Content $WinGetSettingsFile
}
