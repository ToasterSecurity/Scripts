#Requires -RunAsAdministrator

# This sets the registry to set the default cipher suite order on the local system
#  A reboot is required for this to take effect

$response = Read-Host "This sets the registry to set the default cipher suite order on the local system. Would you like to make the required registry changes? (Yes/No)"
If (($response -eq 'Y')  -or ($response -eq "Yes")){

    New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Cryptography\Configuration\SSL\00010002" -Force
    Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Cryptography\Configuration\SSL\00010002" -Name "Functions"

    $rebootResponse = Read-Host "This sets the registry to set the default cipher suite order on the local system. Would you like to make the required registry changes? (Yes/No)"
    If (($rebootResponse -eq 'Y') -or ($rebootResponse -eq "Yes")){
        shutdown /g /c "Set the cipher suite order" /d P:2:4
    } Else {
        Read-Host "The system will need to reboot before the changes will take effect."
    }
}