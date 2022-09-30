function Enable-WindowsFeatures {
    $WindowsFeatures = @(
        "Client-ProjFS"
        "Containers"
        "HypervisorPlatform"
        "Microsoft-Hyper-V-All"
        "Microsoft-Windows-Subsystem-Linux"
        "NetFx3"
        "NetFx4-AdvSrvs"
        "VirtualMachinePlatform"
        "WorkFolders-Client"
    )
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

function Uninstall-ProvisionedPackages {
    $Packages = @(
        "Clipchamp.Clipchamp"
        "Microsoft.MicrosoftSolitaireCollection"
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
