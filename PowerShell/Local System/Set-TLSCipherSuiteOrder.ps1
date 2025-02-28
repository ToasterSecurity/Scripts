#Requires -RunAsAdministrator

# Start logging
$DefaultLogLocation = "C:\Windows\Logs\Set-TLSCipherSuiteOrder-Log.txt"
Start-Transcript -Path $DefaultLogLocation

# This sets the registry to set the cipher suite order on the local system
#  A reboot is required for this to take effect

$response = Read-Host "This sets the registry to set the cipher suite order on the local system. Would you like to make the required registry changes? (Yes/No)"
If (($response -eq 'Y')  -or ($response -eq "Yes")){

    $OSName = (Get-ComputerInfo | Select-Object OSName)
    If ($OSName -like "*2016*"){
        New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Cryptography\Configuration\SSL\00010002" -Force
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Cryptography\Configuration\SSL\00010002" -Name "Functions" -Value "TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384"
    } ElseIf ($OSName -like "*2019*"){
        New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Cryptography\Configuration\SSL\00010002" -Force
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Cryptography\Configuration\SSL\00010002" -Name "Functions" -Value "TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384"
    } ElseIf ($OSName -like "*2022*"){
        New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Cryptography\Configuration\SSL\00010002" -Force
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Cryptography\Configuration\SSL\00010002" -Name "Functions" -Value "TLS_AES_256_GCM_SHA512,TLS_AES_256_GCM_SHA384,TLS_CHACHA20_POLY1305_SHA256,TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384"
    } ElseIf ($OSName -like "*2025*"){
        New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Cryptography\Configuration\SSL\00010002" -Force
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Cryptography\Configuration\SSL\00010002" -Name "Functions" -Value "TLS_AES_256_GCM_SHA512,TLS_AES_256_GCM_SHA384,TLS_CHACHA20_POLY1305_SHA256,TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384"
    } Else {
        Read-Host "Server OS version not detected as available to be automatically configured. Please manually configure HKLM:\SOFTWARE\Policies\Microsoft\Cryptography\Configuration\SSL\00010002\Functions with the desired cipher suites" 
        Break
    }

    $rebootResponse = Read-Host "The registry changes have been made. A reboot is required before they will take effect. Do you want to reboot now? (Yes/No)"
    If (($rebootResponse -eq 'Y') -or ($rebootResponse -eq "Yes")){
        shutdown /g /c "Set the cipher suite order" /d P:2:4
    } Else {
        Read-Host "The system will need to reboot before the changes will take effect."
    }
}

#Stop logging
Stop-Transcript