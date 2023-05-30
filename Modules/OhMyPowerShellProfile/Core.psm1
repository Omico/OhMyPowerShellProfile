######################### Global Variables ###########################################
function Set-GlobalOMPSProfilesConfiguration($ProfilesFile = "profiles.json") {
    $Global:OMPSProfilesConfiguration = Get-OMPSProfilesConfiguration $ProfilesFile
    if ($null -eq $OMPSProfilesConfiguration) {
        Write-Error "Failed to initialize profiles configuration from $(Get-Item $ProfilesFile)." -ErrorAction Stop
    }
}

function Set-GlobalOMPSProfileConfiguration($ProfileId = $OMPSProfileId) {
    if ($null -eq $ProfileId) {
        Write-Error "Profile id cannot be null." -ErrorAction Stop
    }
    $Global:OMPSProfileConfiguration = Get-OMPSProfileConfiguration $ProfileId
}
######################################################################################

function Get-OMPSProfilesConfiguration($ProfilesFile = "profiles.json") {
    $ProfileNotExists = $null -eq $(Get-Item $ProfilesFile -ErrorAction SilentlyContinue)
    if ($ProfileNotExists) {
        Write-Error "Profiles does not exists." -ErrorAction Stop
    }
    return Get-Content $ProfilesFile | ConvertFrom-Json
}

function Get-OMPSProfileConfiguration($ProfileId = $OMPSProfileId) {
    if ($null -eq $ProfileId) {
        Write-Error "Profile id not found." -ErrorAction Stop
    }
    $OMPSProfile = $OMPSProfilesConfiguration.profiles | Where-Object { $_.id -eq $ProfileId } | Select-Object -First 1
    $ProfileNotExists = $null -eq $OMPSProfile
    if ($ProfileNotExists) {
        Write-Error "Profile [$ProfileId] not found." -ErrorAction Stop
    }
    return $OMPSProfile
}

function Update-OMPSEnvironments($ProfileId, $OMPSModuleDirectory) {
    $EnvironmentsContent = "`$Global:OMPSProfileId = `"$ProfileId`"`n"
    foreach ($Environment in $OMPSProfileConfiguration.environments) {
        $EnvironmentsContent += "`$Global:$($Environment.psobject.properties.name) = `"$($Environment.psobject.properties.value)`"`n"
    }
    New-Item -Path "$OMPSModuleDirectory\Environments.psm1" -Force -Value "$EnvironmentsContent" > $null
}
