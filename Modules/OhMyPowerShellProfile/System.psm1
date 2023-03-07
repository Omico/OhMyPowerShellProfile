function Test-IsVirtualMachine {
    return (Get-WmiObject -Class Win32_ComputerSystem).Model -eq "Virtual Machine"
}

function Test-IsAdministrator {
    $User = [Security.Principal.WindowsIdentity]::GetCurrent()
    ([Security.Principal.WindowsPrincipal]$User).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}
