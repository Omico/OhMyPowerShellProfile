function Initialize-OhMyPoshFont {
    if (-Not (Test-Command "oh-my-posh")) {
        Write-Warning "Oh My Posh is not installed."
        return
    }
    [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") | Out-Null
    $Families = (New-Object System.Drawing.Text.InstalledFontCollection).Families
    if ($Families -notcontains "FiraCode Nerd Font") {
        oh-my-posh font install FiraCode
    }
}
