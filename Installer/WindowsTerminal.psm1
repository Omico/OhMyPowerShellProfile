function Initialize-WindowsTerminal {
    $WindowsTerminalPackageFamilyName = $((Get-AppxPackage -Name Microsoft.WindowsTerminal).PackageFamilyName)
    $WindowsTerminalSettingsFile = "$env:LocalAppData\Packages\$WindowsTerminalPackageFamilyName\LocalState\settings.json"
    $WindowsTerminalSettings = Get-Content -Raw $WindowsTerminalSettingsFile | ConvertFrom-Json

    $WindowsTerminalSettings.profiles.defaults = @{
        "colorScheme" = "One Half Dark"
        "font" = @{
            "face" = "FiraCode NF"
        }
        "opacity" = 70
        "useAcrylic" = $true
        "startingDirectory" = $null
    }

    $HiddenProfiles = @(
        "Azure Cloud Shell"
        "Windows PowerShell"
    )
    $WindowsTerminalSettings.profiles.list | ForEach-Object {
        if ($HiddenProfiles -ccontains $_.name) {
            $_ | Add-Member -Name "hidden" -Value $true -MemberType NoteProperty -Force
        }
        if ($_.name -eq "PowerShell") {
            $WindowsTerminalSettings `
            | Add-Member `
                -Name "defaultProfile" `
                -Value $_.guid `
                -MemberType NoteProperty `
                -Force
        }
    }

    $WindowsTerminalSettings `
    | Add-Member `
        -Name "useAcrylicInTabRow" `
        -Value $True `
        -MemberType NoteProperty `
        -Force

    $WindowsTerminalSettings `
    | ConvertTo-Json -Depth 5 `
    | Set-Content -Path $WindowsTerminalSettingsFile
}
