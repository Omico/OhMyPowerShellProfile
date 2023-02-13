function Install-WSL($Distribution = "Ubuntu") {
    wsl --install -d $Distribution
}
