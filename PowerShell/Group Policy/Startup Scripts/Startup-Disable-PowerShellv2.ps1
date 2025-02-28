<# 
.SYNOPSIS

This script will disable the PowerShell v2 Engine on any windows version where it is an optional feature.

.DESCRIPTION

This script will disable the PowerShell v2 Engine on any windows version where it is an optional feature.

Disable-WindowsOptionalFeature does not work correctly when used as a startup script, so instead dism.exe is called directly in this
script.

Script flow:
- Check the current OS version.
    - Check if Windows Vista/7/Server 2008, PowerShell v2 is not optional on these.
    - All others, Check if PowerShell v2 is enabled and if so disable.

Script log data saved to: C:\Windows\Logs\Disable-PowerShellv2.txt

This script is designed to be deployed as a Group Policy Startup Script.
Policy: Computer Configuration > Policies > Windows Settings > Scripts (Startup/Shutdown)
Script Name: Startup-Disable-PowerShellv2.ps1
Parameters: -ExecutionPolicy Bypass -NonInteractive -NoProfile

.EXAMPLE

C:\PS> powershell.exe -ExecutionPolicy Bypass -NoProfile -NonInteractive -WindowsStyle Hidden .\Startup-Disable-PowerShellv2.ps1

#>

Start-Transcript -Path "C:\Windows\Logs\Disable-PowerShellv2.txt"

# Get the current OS version
$OSVersion = (get-itemproperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name ProductName).ProductName
# Disable PowerShell v2 based off the OS version
switch -regex ($OSVersion) {   
    "(?i)7|Vista|2008" {
        Write-Host "Detected Windows 7/Vista/Server 2008, no changes will be made."
    }
    default {
        Write-Host "Checking to see if PowerShell v2 is currently enabled..."
        $PSv2PreCheck = dism.exe /Online /Get-Featureinfo /FeatureName:"MicrosoftWindowsPowerShellv2" | findstr "State"
        If ( $PSv2PreCheck -like "State : Enabled" ) {
            Write-Host "PowerShell v2 appears to be enabled, disabling via dism..." 
            dism.exe /Online /Disable-Feature /FeatureName:"MicrosoftWindowsPowerShellv2" /NoRestart
            $PSv2PostCheck = dism.exe /Online /Get-Featureinfo /FeatureName:"MicrosoftWindowsPowerShellv2" | findstr "State"
            If ( $PSv2PostCheck -like "State : Enabled" ) {
                Write-Host "PowerShell v2 still seems to be enabled, check the log for errors: $DefaultLogLocation"
            } Else {
                Write-Host "PowerShell v2 disabled successfully."
            }
        } Else {
            Write-Host "PowerShell v2 is already disabled, no changes will be made."
        }
    }
}

Stop-Transcript
