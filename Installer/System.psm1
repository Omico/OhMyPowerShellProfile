function Enable-WindowsFeatures {
    if (Test-IsVirtualMachine) { return }
    Write-Host "Enabling Windows features..."
    $WindowsFeatures = $OMPSProfileConfiguration.features
    $WindowsFeatures | ForEach-Object {
        $WindowsFeaturesState = (
            Get-WindowsOptionalFeature -Online -FeatureName $_ `
            | Select-Object State -ExpandProperty State
        )
        Write-Output "Windows feature `"$_`" ($WindowsFeaturesState)"
        if ($WindowsFeaturesState -ne "Enabled") {
            Write-Output "Enabling Windows feature `"$_`""
            Enable-WindowsOptionalFeature -Online -FeatureName $_ -NoRestart
            if ($?) { Write-Host "Windows Feature `"$_`" was activated successfully" }
            else { throw "Failed to activate Windows Feature `"$_`"" }
        }
    }
}

function Enable-DeveloperMode {
    $RegistryKeyPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock"
    if (-Not (Test-Path -Path $RegistryKeyPath)) {
        New-Item -Path $RegistryKeyPath -ItemType Directory -Force | Out-Null
    }
    New-ItemProperty `
        -Path $RegistryKeyPath `
        -Name AllowDevelopmentWithoutDevLicense `
        -PropertyType DWORD `
        -Value 1 -Force | Out-Null
}

function Uninstall-ProvisionedPackages {
    $Packages = @(
        "Clipchamp.Clipchamp"
        "Microsoft.MicrosoftOfficeHub"
        "Microsoft.MicrosoftSolitaireCollection"
        "MicrosoftTeams"
    )
    $AppProvisionedPackage = Get-AppProvisionedPackage -Online
    foreach ($Package in $Packages) {
        $PackageInfo = $AppProvisionedPackage | Where-Object DisplayName -Like $Package
        if ($null -ne $PackageInfo) {
            Write-Output "Uninstalling $Package"
            Remove-AppxProvisionedPackage -PackageName $PackageInfo.PackageName -AllUsers -Online > $null
        }
    }
}
