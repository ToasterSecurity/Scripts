#Requires -RunAsAdministrator

# Start logging
$DefaultLogLocation = "C:\Windows\Logs\Rollback-DisableSSLv3-Log.txt"
Start-Transcript -Path $DefaultLogLocation

# This sets the registry to enable Secure Sockets Layer (SSL) v3 on the local system
#  A reboot is required for this to take effect

$response = Read-Host "This sets the registry to enable Secure Sockets Layer (SSL) v3 on the local system. 

WARNING: THIS SHOULD ONLY BE DONE IF YOU ARE ABSOLUTELY CERTAIN YOUR ENVIRONMENT NEEDS SSL v3 ENABLED!

Would you like to make the required registry changes? (Yes/No)"
If (($response -eq 'Y')  -or ($response -eq "Yes")){
    New-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 3.0\Server" -Force
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 3.0\Server" -Name "Enabled" -Value 1
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 3.0\Server" -Name "DisabledByDefault" -Value 0

    $rebootResponse = Read-Host "The registry changes have been made. A reboot is required before they will take effect. Do you want to reboot now? (Yes/No)"
    If (($rebootResponse -eq 'Y') -or ($rebootResponse -eq "Yes")){
        shutdown /g /c "Enable SSLv3" /d P:2:4
    } Else {
        Read-Host "The system will need to reboot before the changes will take effect."
    }
}

#Stop logging
Stop-Transcript