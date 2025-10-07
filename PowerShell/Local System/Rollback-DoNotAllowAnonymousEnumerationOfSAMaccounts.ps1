#Requires -RunAsAdministrator

# Start logging
$DefaultLogLocation = "C:\Windows\Logs\Rollback-DoNotAllowAnonymousEnumerationOfSAMaccounts-Log.txt"
Start-Transcript -Path $DefaultLogLocation

# This sets the registry to allow anonymous enumeration of Security Account Manager (SAM) accounts on the local system
#  A reboot is required for this to take effect

$response = Read-Host "This sets the registry to allow anonymous enumeration of Security Account Manager (SAM) accounts on the local system. Would you like to make the required registry changes? (Yes/No)

WARNING: THIS SHOULD ONLY BE DONE IF YOU ARE ABSOLUTELY CERTAIN YOUR ENVIRONMENT NEEDS Anonymous enumeration of SAM accounts ENABLED!

Would you like to make the required registry changes? (Yes/No)"

If (($response -eq 'Y')  -or ($response -eq "Yes")){
    New-Item -Path "HKLM:\SYSTEM\CurrentControlSet\LSA" -Force
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\LSA" -Name "RestrictAnonymous" -Value 0

    $rebootResponse = Read-Host "The registry changes have been made. A reboot is required before they will take effect. Do you want to reboot now? (Yes/No)"
    If (($rebootResponse -eq 'Y') -or ($rebootResponse -eq "Yes")){
        shutdown /g /c "Set allow annonymous enumeration of SAM accounts" /d P:2:4
    } Else {
        Read-Host "The system will need to reboot before the changes will take effect."
    }
}

#Stop logging
Stop-Transcript