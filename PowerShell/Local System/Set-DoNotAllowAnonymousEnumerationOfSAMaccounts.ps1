#Requires -RunAsAdministrator

# Start logging
$DefaultLogLocation = "C:\Windows\Logs\Set-DoNotAllowAnonymousEnumerationOfSAMaccounts-Log.txt"
Start-Transcript -Path $DefaultLogLocation

# This sets the registry to not allow anonymous enumeration of Security Account Manager (SAM) accounts on the local system
#  A reboot is required for this to take effect

$response = Read-Host "This sets the registry to not allow anonymous enumeration of Security Account Manager (SAM) accounts on the local system. Would you like to make the required registry changes? (Yes/No)"

If (($response -eq 'Y')  -or ($response -eq "Yes")){
    New-Item -Path "HKLM:\SYSTEM\CurrentControlSet\LSA" -Force
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\LSA" -Name "RestrictAnonymous" -Value 1

    $rebootResponse = Read-Host "The registry changes have been made. A reboot is required before they will take effect. Do you want to reboot now? (Yes/No)"
    If (($rebootResponse -eq 'Y') -or ($rebootResponse -eq "Yes")){
        shutdown /g /c "Set do not allow annonymous enumeration of SAM accounts" /d P:2:4
    } Else {
        Read-Host "The system will need to reboot before the changes will take effect."
    }
}

#Stop logging
Stop-Transcript