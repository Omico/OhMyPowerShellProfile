######################### Global Variables ###########################################
function Set-GlobalOMPSProfilesConfiguration($ProfilesFile = "profiles.json") {
    $global:OMPSProfilesConfiguration = Get-OMPSProfilesConfiguration $ProfilesFile
    if ($null -eq $OMPSProfilesConfiguration) {
        Write-Error "Failed to initialize profiles configuration from $(Get-Item $ProfilesFile)." -ErrorAction Stop
    }
}

function Set-GlobalOMPSProfileConfiguration($ProfileId = $OMPSProfileId) {
    if ($null -eq $ProfileId) {
        Write-Error "Profile id cannot be null." -ErrorAction Stop
    }
    $global:OMPSProfileConfiguration = Get-OMPSProfileConfiguration $ProfileId
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
