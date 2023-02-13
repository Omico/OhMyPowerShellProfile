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

```powershell
./Install.ps1
```
