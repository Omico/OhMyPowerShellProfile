function Initialize-PowerShellModules {
    $Modules = @(
        "PSProfiler"
        "PSReadLine"
        "PSWindowsUpdate"
        "Terminal-Icons"
        "posh-git"
    )
    $Modules | ForEach-Object {
        pwsh -NoProfile -c "Install-Module -Name $_ -AllowClobber -Scope AllUsers -Force"
    }
}

function Initialize-PowerShellProfile($InstallScriptPath) {
    $UserPowershellDirectory = $PROFILE.TrimEnd("\") | Split-Path -Parent
    $UserPowershellModulesDirectory = "$UserPowershellDirectory\Modules"
    $OhMyPowerShellProfileDirectory = "$UserPowershellModulesDirectory\OhMyPowerShellProfile"
    $CanHardLink = (
        Test-CanHardLink `
            -Path $UserPowershellDirectory `
            -Target $InstallScriptPath
    )
    if (Test-Path $PROFILE) {
        $InputOption = Read-Host -Prompt "PowerShell profile already exists. Do you want to overwrite it? (y/n)"
        if ($InputOption -ne "y") {
            return
        }
        Remove-Item $PROFILE
    }

    New-ItemViaHardLinkOrCopy `
        -Path "$PROFILE" `
        -Target "$InstallScriptPath\Configurations\PowerShell\profile.ps1" `
        -CanHardLink $CanHardLink

    if (Test-Path "$OhMyPowerShellProfileDirectory") {
        Remove-Item "$OhMyPowerShellProfileDirectory" -Recurse -Force > $null
    }

    New-Item -Path $OhMyPowerShellProfileDirectory -Force -ItemType Directory > $null

    Get-ChildItem `
        -Path "$InstallScriptPath\Modules\OhMyPowerShellProfile" `
        -Recurse | ForEach-Object {
        if ($_.Extension -eq ".psm1") {
            New-ItemViaHardLinkOrCopy `
                -Path "$OhMyPowerShellProfileDirectory\$($_.Name)" `
                -Target "$($_.FullName)" `
                -CanHardLink $CanHardLink
        }
    }
}

function Test-CanHardLink($Path, $Target) {
    function Get-Directory($Path) {
        $Path = Get-Item $Path
        if ($Path.PSIsContainer) {
            return $Path.FullName
        }
        else {
            return $Path.Directory.FullName
        }
    }

    function Remove-ItemIfExist($Path) {
        if (Test-Path $Path) {
            Remove-Item $Path -Force -Recurse > $null
        }
    }

    $Path = Get-Directory -Path $Path
    $Target = Get-Directory -Path $Target
    $TestFile = "$Path\test~"
    $TargetTestFile = "$Target\test~"
    New-Item `
        -ItemType File `
        -Path "$TargetTestFile" `
        -Force > $null
    try {
        New-Item `
            -ItemType HardLink `
            -Path "$TestFile" `
            -Target "$TargetTestFile" `
            > $null
        return $true
    }
    catch { return $false }
    finally {
        Remove-ItemIfExist -Path $TestFile
        Remove-ItemIfExist -Path $TargetTestFile
    }
}

function New-ItemViaHardLinkOrCopy($Path, $Target, $CanHardLink) {
    if ($CanHardLink) {
        New-Item `
            -ItemType HardLink `
            -Path "$Path" `
            -Target "$Target" `
            > $null
    }
    else {
        Copy-Item `
            -Path "$Target" `
            -Destination "$Path" `
            -Force
    }
}
