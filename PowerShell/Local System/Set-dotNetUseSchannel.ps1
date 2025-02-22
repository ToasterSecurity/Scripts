#Requires -RunAsAdministrator

# This sets the registry to enable .net to use the Windows SCHANNEL configuration instead of the native .net TLS configuration on the local system
#  A reboot is required for this to take effect

$response = Read-Host "This sets the registry to enable .net to use the Windows SCHANNEL configuration instead of the native .net TLS configuration on the local system. Would you like to make the required registry changes? (Yes/No)"
If (($response -eq 'Y')  -or ($response -eq "Yes")){
    New-Item -Path "HKLM:\SOFTWARE\WOW6432Node\Microsoft\.NETFramework\v2.0.50727" -Force
    Set-ItemProperty -Path "HKLM:\SOFTWARE\WOW6432Node\Microsoft\.NETFramework\v2.0.50727" -Name "SystemDefaultTlsVersions" -Value 1
    Set-ItemProperty -Path "HKLM:\SOFTWARE\WOW6432Node\Microsoft\.NETFramework\v2.0.50727" -Name "SchUseStrongCrypto" -Value 1

    New-Item -Path "HKLM:\SOFTWARE\WOW6432Node\Microsoft\.NETFramework\v4.0.30319" -Force
    Set-ItemProperty -Path "HKLM:\SOFTWARE\WOW6432Node\Microsoft\.NETFramework\v4.0.30319" -Name "SystemDefaultTlsVersions" -Value 1
    Set-ItemProperty -Path "HKLM:\SOFTWARE\WOW6432Node\Microsoft\.NETFramework\v4.0.30319" -Name "SchUseStrongCrypto" -Value 1

    New-Item -Path "HKLM:\SOFTWARE\Microsoft\.NETFramework\v2.0.50727" -Force
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\.NETFramework\v2.0.50727" -Name "SystemDefaultTlsVersions" -Value 1
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\.NETFramework\v2.0.50727" -Name "SchUseStrongCrypto" -Value 1

    New-Item -Path "HKLM:\SOFTWARE\Microsoft\.NETFramework\v4.0.30319" -Force
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\.NETFramework\v4.0.30319" -Name "SystemDefaultTlsVersions" -Value 1
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\.NETFramework\v4.0.30319" -Name "SchUseStrongCrypto" -Value 1

    $rebootResponse = Read-Host "This sets the registry to enable .net to use the Windows SCHANNEL configuration instead of the native .net TLS configuration on the local system. Would you like to make the required registry changes? (Yes/No)"
    If (($rebootResponse -eq 'Y') -or ($rebootResponse -eq "Yes")){
        shutdown /g /c " Enable .net to use the Windows SCHANNEL configuration instead of the native .net TLS configuration" /d P:2:4
    } Else {
        Read-Host "The system will need to reboot before the changes will take effect."
    }
}