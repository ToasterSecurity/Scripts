#Requires -RunAsAdministrator

# Start logging
$DefaultLogLocation = "C:\Windows\Logs\Rollback-DisableSMB1.0-Log.txt"
Start-Transcript -Path $DefaultLogLocation

# This sets the registry to enable Server Message Block (SMB) v1.0 on the local system
#  A reboot is required for this to take effect

$response = Read-Host "This sets the registry to enable Server Message Block (SMB) v1.0 on the local system. Would you like to make the required registry changes? (Yes/No)

WARNING: THIS SHOULD ONLY BE DONE IF YOU ARE ABSOLUTELY CERTAIN YOUR ENVIRONMENT NEEDS SMB v1.0 ENABLED!

Would you like to make the required registry changes? (Yes/No)"

If (($response -eq 'Y')  -or ($response -eq "Yes")){
    New-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Services\S\Parameters" -Force
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\S\Parameters" -Name "SMB1" -Value 1

    $rebootResponse = Read-Host "The registry changes have been made. A reboot is required before they will take effect. Do you want to reboot now? (Yes/No)"
    If (($rebootResponse -eq 'Y') -or ($rebootResponse -eq "Yes")){
        shutdown /g /c "Enable SMBv1.0" /d P:2:4
    } Else {
        Read-Host "The system will need to reboot before the changes will take effect."
    }
}

#Stop logging
Stop-Transcript