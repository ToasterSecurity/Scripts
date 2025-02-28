#Requires -RunAsAdministrator

<# 
.SYNOPSIS

This script will disable the PowerShell v2 Engine on any windows version where it is an optional feature.

.DESCRIPTION

This script will disable the PowerShell v2 Engine on any windows version where it is an optional feature.

Script flow:
- Check the current OS version.
    - Check if PowerShell v2 is enabled and if so disable.

Script log data saved to: C:\Windows\Logs\Disable-PowerShellv2.txt

This script is designed to be run locally and will not work as a Startup/Shutdown script.
Disable-WindowsOptionalFeature does not work correctly when used as a startup script.

Script Name: Set-Disable-PowerShellv2.ps1
Parameters: -ExecutionPolicy Bypass -NonInteractive -NoProfile

.EXAMPLE

C:\PS> powershell.exe -ExecutionPolicy Bypass -NoProfile -NonInteractive -WindowsStyle Hidden .\Set-Disable-PowerShellv2.ps1

#>

# Start logging
$DefaultLogLocation = "C:\Windows\Logs\Disable-PowerShellv2.txt"
Start-Transcript -Path $DefaultLogLocation

# Get the Current PowerShell v2 status
$CurrentStatus = (Get-WindowsOptionalFeature -Online -FeatureName MicrosoftWindowsPowerShellv2)

# Check if PowerShell v2 is enabled and if so disable
if ($CurrentStatus.State -eq 'Enabled') {
    Disable-WindowsOptionalFeature -Online -FeatureName MicrosoftWindowsPowerShellv2 -NoRestart
}

#Stop logging
Stop-Transcript