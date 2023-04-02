# Oh My PowerShell Profile

## Pre Install

First, run as administrator. Or, use the below command:

```powershell
Start-Process wt -verb RunAs
```

Make sure you have the right PowerShell execution policy.

```powershell
Set-ExecutionPolicy Bypass -Force
```

Run the below command to execute pre-install script.

```powershell
./Pre-Install.ps1
```

Finally, close the terminal.

## Install

Start a new terminal and run as administrator. Or, use the below command:

```powershell
Start-Process wt -verb RunAs pwsh
```

Run the following command and modify the `profiles.json` to fit your need. For more details, please see [Customization](#customization).

```shell
cp profiles.json.example profiles.json
```

```powershell
./Install.ps1 <your-profile-id>
```

## Customization

### Generate you own profile

Requirements:

- Kotlin
  - Via [SDKMAN!](https://sdkman.io/): `sdk install kotlin`
  - Via [Chocolatey](https://chocolatey.org/): `choco install kotlin`
  - Via [Homebrew](https://brew.sh/): `brew install kotlin`
  - Via [Scoop](https://scoop.sh/): `scoop install kotlin`

```powershell
cp profiles.example.main.kts profiles.main.kts
```

Modify the `profiles.main.kts` to fit your need. Then, run the following command to generate your own profile.

```powershell
# For example, if you installed Kotlin via Scoop，
# the Kotlin home path is $HOME\scoop\apps\kotlin\current
kotlinc -script profiles.main.kts -Xplugin="<your-kotlin-home>\lib\kotlinx-serialization-compiler-plugin.jar"
```
