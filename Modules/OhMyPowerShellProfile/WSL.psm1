function Install-WSL($Distribution = $null) {
    if ($null -eq $Distribution) {
        wsl --install
    }
    else {
        wsl --install --distribution $Distribution
    }
}

function Update-WSL {
    wsl --update
}

function Optimize-WSL {
    if (-Not (Test-IsAdministrator)) {
        Write-Error "You must run this script as an administrator." -ErrorAction Stop
    }

    wsl --shutdown

    $DockerWSLVHDX = "$env:LOCALAPPDATA\Docker\wsl\data\ext4.vhdx"
    if (Test-Path $DockerWSLVHDX) {
        Write-Output "Optimizing Docker..."
        Optimize-VHD -Path $DockerWSLVHDX -Mode full
    }

    $WSLDistributions = @(
        "Canonical.Ubuntu.1604"
        "Canonical.Ubuntu.1804"
        "Canonical.Ubuntu.2004"
        "Canonical.Ubuntu.2204"
        "Debian.Debian"
        "TheDebianProject.DebianGNULinux"
        "kalilinux.kalilinux"
    )
    foreach ($Distribution in $WSLDistributions) {
        $DistributionFamilyName = (Get-AppxPackage -Name $Distribution).PackageFamilyName
        $DistributionVHDX = "$env:LocalAppData\Packages\$DistributionFamilyName\LocalState\ext4.vhdx"
        if (Test-Path "$DistributionVHDX") {
            Write-Output "Optimizing $Distribution..."
            Optimize-VHD -Path "$DistributionVHDX" -Mode full
        }
    }
}
