function Copy-SSHPublicKeyToRemote() {
    param(
        [Parameter(Mandatory = $true)][string]$Remote,
        [string]$KeyName = 'id_rsa'
    )
    Get-Content "$HOME\.ssh\$KeyName.pub" | ssh $Remote "cat >> ~/.ssh/authorized_keys"
}

Set-Alias -Name ssh-copy-id -Value Copy-SSHPublicKeyToRemote
