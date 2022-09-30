# Oh My PowerShell Profile

## Pre Install

First, run as administrator. Or, use the below command:

```powershell
Start-Process wt -verb RunAs
```

Make sure you have the right PowerShell execution policy.

```powershell
Set-ExecutionPolicy RemoteSigned -Force
```

Finally, run the below command to execute the pre-install script.

```powershell
./Pre-Install.ps1
```

## Install

```powershell
./Install.ps1
```
