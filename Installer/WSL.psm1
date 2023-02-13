function Install-WSL($Distribution = "Ubuntu") {
    if (Test-IsVirtualMachine) { return }
    Write-Host "Installing WSL..."
    wsl --install -d $Distribution
}
