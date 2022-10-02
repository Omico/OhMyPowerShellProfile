function Initialize-OhMyPosh {
    if (-Not (Test-Command "oh-my-posh")) {
        return
    }
    oh-my-posh init pwsh --config $env:POSH_THEMES_PATH\agnoster.omp.json | Invoke-Expression
    if (Get-Module -ListAvailable -Name "posh-git") {
        Import-Module posh-git
        $env:POSH_GIT_ENABLED = $true
    }
}
