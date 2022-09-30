if (-Not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
        $Command = "-NoProfile -File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
        Start-Process -FilePath pwsh -Verb RunAs -ArgumentList $Command
        Exit;
    }
}

$RequiredPackages = @(
    "Git.Git"
    "JanDeDobbeleer.OhMyPosh"
    "Microsoft.PowerShell"
    "Microsoft.VisualStudioCode"
    "Microsoft.WindowsTerminal"
)

$InstalledPackages = $(winget list --accept-source-agreements)
$UpgradablePackages = $(winget upgrade)

foreach ($Package in $RequiredPackages) {
    if ($InstalledPackages -match $Package) {
        if ($UpgradablePackages -match $Package) {
            Write-Output "Upgrading [$Package]"
            winget upgrade $Package
        }
    }
    else {
        Write-Output "Installing [$Package]"
        winget install $Package --scope machine
    }
}

Write-Host "Press any key to continue..."
$Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") | Out-Null
