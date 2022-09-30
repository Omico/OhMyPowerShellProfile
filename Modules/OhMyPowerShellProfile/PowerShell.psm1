function Test-Command($Command = $null) {
    if ($null -eq $Command) {
        return $false
    }
    $oldPreference = $ErrorActionPreference
    $ErrorActionPreference = "stop"
    try { if (Get-Command $Command) { return $true } }
    catch { Write-Host "$Command does not exist"; return $false }
    finally { $ErrorActionPreference = $oldPreference }
}

function Uninstall-DuplicatedModules {
    $InstalledModules = Get-InstalledModule
    foreach ($Module in $InstalledModules) {
        Get-InstalledModule -Name $Module.Name -AllVersions `
        | Where-Object { $_.Version -ne $Module.Version } `
        | Uninstall-Module
    }
}
