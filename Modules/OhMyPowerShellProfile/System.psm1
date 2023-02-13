function Test-IsVirtualMachine {
    return (Get-WmiObject -Class Win32_ComputerSystem).Model -eq "Virtual Machine"
}
