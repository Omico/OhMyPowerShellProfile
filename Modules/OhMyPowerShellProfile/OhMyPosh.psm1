function Initialize-OhMyPosh {
    if (-Not (Test-Command "oh-my-posh")) { return }
    oh-my-posh init pwsh --config $env:POSH_THEMES_PATH\agnoster.omp.json | Invoke-Expression
    if (Get-Module -ListAvailable -Name "posh-git") {
        if (Get-Module -ListAvailable -Name "lazy-posh-git") {
            Import-Module lazy-posh-git
        }
        else {
            Import-Module posh-git
        }
        $env:POSH_GIT_ENABLED = $true
    }
}
