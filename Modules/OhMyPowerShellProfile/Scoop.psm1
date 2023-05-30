function Install-Scoop {
    Invoke-RestMethod get.scoop.sh | Invoke-Expression
    Initialize-Scoop
}

function Initialize-Scoop {
    scoop config aria2-warning-enabled false
    scoop bucket add extras
    Restore-Scoop
}

function Backup-Scoop {
    scoop export > "$OMPSPrivateDirectory\scoop-apps.json"
}

function Restore-Scoop {
    scoop update
    scoop import "$OMPSPrivateDirectory\scoop-apps.json"
}

function Update-Scoop {
    Write-Output "Updating Scoop packages"
    scoop update *
    scoop cleanup *
    scoop cache rm *
    scoop status
}
