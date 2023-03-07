function Install-WSL {
    if (Test-IsVirtualMachine) {
        Write-Host "Skipping WSL installation in the virtual machine."
        return
    }
    if ($null -eq $OMPSProfileConfiguration.wsl) { return }
    Write-Host "Installing WSL..."
    $Distribution = $OMPSProfileConfiguration.wsl.distribution
    Install-WSL $Distribution
}
