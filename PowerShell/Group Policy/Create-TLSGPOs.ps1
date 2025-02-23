#Requires -RunAsAdministrator

# Start logging
$DefaultLogLocation = "C:\Windows\Logs\Create-TLSGPOs-Log.txt"
Start-Transcript -Path $DefaultLogLocation

# This creates eleven Group Policy Objects (GPO's)
#  GPO  0 sets the registry to Disable Secure Sockets Layer (SSL) v3 (there is no rollback for this as SSL v3 is disabled by default on all modern Windows Operating Systems, this is an enforcement policy to keep SSL v3 disabled)
#  GPO  1 sets the registry to Enable .net to use the Windows SCHANNEL configuration instead of the native .net TLS configuration
#  GPO  2 sets the registry to Disable Transport Layer Security (TLS) 1.0 and 1.1
#  GPO  3 sets the registry to Set the TLS Cipher Suite Order for Windows Server 2016 servers
#  GPO  4 sets the registry to Set the TLS Cipher Suite Order for Windows Server 2019 servers
#  GPO  5 sets the registry to Set the TLS Cipher Suite Order for Windows Server 2022 servers
#  GPO  6 sets the registry to Disable the user of SCHANNEL for .net as a rollback for if GPO 1 creates issues in the environment
#  GPO  7 sets the registry to Enable TLS 1.0 and 1.1 as a rollback for if GPO 2 creates issues in the environment
#  GPO  8 sets the registry to Delete the TLS Cipher Suite Order registry item as a rollback for if GPO 3 creates issues in the environment
#  GPO  9 sets the registry to Delete the TLS Cipher Suite Order registry item as a rollback for if GPO 4 creates issues in the environment
#  GPO 10 sets the registry to Delete the TLS Cipher Suite Order registry item as a rollback for if GPO 5 creates issues in the environment

# Import the Group Policy Module
Import-Module GroupPolicy

# Create GPO 0
New-GPO -Name "Disable SSL v3" -Comment "Sets the registry values to disable SSL v3 for shannel"
# Create GPO 1
New-GPO -Name "Enable SCHANNEL for .net" -Comment "Sets the registry values to enable the .net framework to use shannel and strong cryptographic ciphers"
# Create GPO 2
New-GPO -Name "Disable TLS 1.0/1.1" -Comment "Sets the registry values to disable the TLS 1.0 and 1.1 for shannel"
# Create GPO 3
New-GPO -Name "Set Cipher Suite Order 2016" -Comment "Sets the registry values to set the cipher suite order for server 2016"
# Create GPO 4
New-GPO -Name "Set Cipher Suite Order 2019" -Comment "Sets the registry values to set the cipher suite order for server 2019"
# Create GPO 5
New-GPO -Name "Set Cipher Suite Order 2022" -Comment "Sets the registry values to set the cipher suite order for server 2022"

# Set GPO 0
Set-GPPrefRegistryValue -Name "Disable SSL v3" -Context Computer -Key "HKLM\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 3.0" -Order 1 -Action "Update"
Set-GPPrefRegistryValue -Name "Disable SSL v3" -Context Computer -Key "HKLM\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 3.0\Server" -Order 2 -Action "Update"
Set-GPPrefRegistryValue -Name "Disable SSL v3" -Context Computer -Key "HKLM\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 3.0\Server" -ValueName "Enabled" -Value 0 -Type "DWORD" -Order 3 -Action "Update"
Set-GPPrefRegistryValue -Name "Disable SSL v3" -Context Computer -Key "HKLM\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 3.0\Server" -ValueName "DisabledByDefault" -Value 1 -Type "DWORD" -Order 4 -Action "Update"

# Set GPO 1
Set-GPPrefRegistryValue -Name "Enable SCHANNEL for .net" -Context Computer -Key "HKLM\SOFTWARE\WOW6432Node\Microsoft\.NETFramework\v2.0.50727" -ValueName "SystemDefaultTlsVersions" -Value 1 -Type "DWORD" -Order 1 -Action "Update"
Set-GPPrefRegistryValue -Name "Enable SCHANNEL for .net" -Context Computer -Key "HKLM\SOFTWARE\WOW6432Node\Microsoft\.NETFramework\v2.0.50727" -ValueName "SchUseStrongCrypto" -Value 1 -Type "DWORD" -Order 2 -Action "Update"
Set-GPPrefRegistryValue -Name "Enable SCHANNEL for .net" -Context Computer -Key "HKLM\SOFTWARE\WOW6432Node\Microsoft\.NETFramework\v4.0.30319" -ValueName "SystemDefaultTlsVersions" -Value 1 -Type "DWORD" -Order 3 -Action "Update"
Set-GPPrefRegistryValue -Name "Enable SCHANNEL for .net" -Context Computer -Key "HKLM\SOFTWARE\WOW6432Node\Microsoft\.NETFramework\v4.0.30319" -ValueName "SchUseStrongCrypto" -Value 1 -Type "DWORD" -Order 4 -Action "Update"
Set-GPPrefRegistryValue -Name "Enable SCHANNEL for .net" -Context Computer -Key "HKLM\SOFTWARE\Microsoft\.NETFramework\v2.0.50727" -ValueName "SystemDefaultTlsVersions" -Value 1 -Type "DWORD" -Order 5 -Action "Update"
Set-GPPrefRegistryValue -Name "Enable SCHANNEL for .net" -Context Computer -Key "HKLM\SOFTWARE\Microsoft\.NETFramework\v2.0.50727" -ValueName "SchUseStrongCrypto" -Value 1 -Type "DWORD" -Order 6 -Action "Update"
Set-GPPrefRegistryValue -Name "Enable SCHANNEL for .net" -Context Computer -Key "HKLM\SOFTWARE\Microsoft\.NETFramework\v4.0.30319" -ValueName "SystemDefaultTlsVersions" -Value 1 -Type "DWORD" -Order 7 -Action "Update"
Set-GPPrefRegistryValue -Name "Enable SCHANNEL for .net" -Context Computer -Key "HKLM\SOFTWARE\Microsoft\.NETFramework\v4.0.30319" -ValueName "SchUseStrongCrypto" -Value 1 -Type "DWORD" -Order 8 -Action "Update"

# Set GPO 2
Set-GPPrefRegistryValue -Name "Disable TLS 1.0/1.1" -Context Computer -Key "HKLM\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0" -Order 1 -Action "Update"
Set-GPPrefRegistryValue -Name "Disable TLS 1.0/1.1" -Context Computer -Key "HKLM\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0\Server" -Order 2 -Action "Update"
Set-GPPrefRegistryValue -Name "Disable TLS 1.0/1.1" -Context Computer -Key "HKLM\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0\Server" -ValueName "Enabled" -Value 0 -Type "DWORD" -Order 3 -Action "Update"
Set-GPPrefRegistryValue -Name "Disable TLS 1.0/1.1" -Context Computer -Key "HKLM\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0\Server" -ValueName "DisabledByDefault" -Value 1 -Type "DWORD" -Order 4 -Action "Update"
Set-GPPrefRegistryValue -Name "Disable TLS 1.0/1.1" -Context Computer -Key "HKLM\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.1" -Order 5 -Action "Update"
Set-GPPrefRegistryValue -Name "Disable TLS 1.0/1.1" -Context Computer -Key "HKLM\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.1\Server" -Order 6 -Action "Update"
Set-GPPrefRegistryValue -Name "Disable TLS 1.0/1.1" -Context Computer -Key "HKLM\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.1\Server" -ValueName "Enabled" -Value 0 -Type "DWORD" -Order 7 -Action "Update"
Set-GPPrefRegistryValue -Name "Disable TLS 1.0/1.1" -Context Computer -Key "HKLM\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.1\Server" -ValueName "DisabledByDefault" -Value 1 -Type "DWORD" -Order 8 -Action "Update"

# Set GPO 3
Set-GPPrefRegistryValue -Name "Set Cipher Suite Order 2016" -Context Computer -Key "HKLM\SOFTWARE\Policies\Microsoft\Cryptography\Configuration\SSL\00010002" -ValueName "Functions" -Value "TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384" -Type "String" -Order 1 -Action "Update"

# Set GPO 4
Set-GPPrefRegistryValue -Name "Set Cipher Suite Order 2019" -Context Computer -Key "HKLM\SOFTWARE\Policies\Microsoft\Cryptography\Configuration\SSL\00010002" -ValueName "Functions" -Value "TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384" -Type "String" -Order 1 -Action "Update"

# Set GPO 5
Set-GPPrefRegistryValue -Name "Set Cipher Suite Order 2022" -Context Computer -Key "HKLM\SOFTWARE\Policies\Microsoft\Cryptography\Configuration\SSL\00010002" -ValueName "Functions" -Value "TLS_AES_256_GCM_SHA512,TLS_AES_256_GCM_SHA384,TLS_CHACHA20_POLY1305_SHA256,TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384" -Type "String" -Order 1 -Action "Update"

# Create Rollback GPO 1
New-GPO -Name "Rollback Enable SCHANNEL for .net" -Comment "Sets the registry values to enable the .net framework to use shannel and strong cryptographic ciphers"
# Create Rollback GPO 2
New-GPO -Name "Rollback Disable TLS 1.0/1.1" -Comment "Sets the registry values to disable the TLS 1.0 and 1.1 for shannel"
# Create Rollback GPO 3
New-GPO -Name "Rollback Set Cipher Suite Order 2016" -Comment "Sets the registry values to set the cipher suite order for server 2016"
# Create Rollback GPO 4
New-GPO -Name "Rollback Set Cipher Suite Order 2019" -Comment "Sets the registry values to set the cipher suite order for server 2019"
# Create Rollback GPO 5
New-GPO -Name "Rollback Set Cipher Suite Order 2022" -Comment "Sets the registry values to set the cipher suite order for server 2022"

# Set Rollback GPO 1
Set-GPPrefRegistryValue -Name "Rollback Enable SCHANNEL for .net" -Context Computer -Key "HKLM\SOFTWARE\WOW6432Node\Microsoft\.NETFramework\v2.0.50727" -ValueName "SystemDefaultTlsVersions" -Value 0 -Type "DWORD" -Order 1 -Action "Update"
Set-GPPrefRegistryValue -Name "Rollback Enable SCHANNEL for .net" -Context Computer -Key "HKLM\SOFTWARE\WOW6432Node\Microsoft\.NETFramework\v2.0.50727" -ValueName "SchUseStrongCrypto" -Value 0 -Type "DWORD" -Order 2 -Action "Update"
Set-GPPrefRegistryValue -Name "Rollback Enable SCHANNEL for .net" -Context Computer -Key "HKLM\SOFTWARE\WOW6432Node\Microsoft\.NETFramework\v4.0.30319" -ValueName "SystemDefaultTlsVersions" -Value 0 -Type "DWORD" -Order 3 -Action "Update"
Set-GPPrefRegistryValue -Name "Rollback Enable SCHANNEL for .net" -Context Computer -Key "HKLM\SOFTWARE\WOW6432Node\Microsoft\.NETFramework\v4.0.30319" -ValueName "SchUseStrongCrypto" -Value 0 -Type "DWORD" -Order 4 -Action "Update"
Set-GPPrefRegistryValue -Name "Rollback Enable SCHANNEL for .net" -Context Computer -Key "HKLM\SOFTWARE\Microsoft\.NETFramework\v2.0.50727" -ValueName "SystemDefaultTlsVersions" -Value 0 -Type "DWORD" -Order 5 -Action "Update"
Set-GPPrefRegistryValue -Name "Rollback Enable SCHANNEL for .net" -Context Computer -Key "HKLM\SOFTWARE\Microsoft\.NETFramework\v2.0.50727" -ValueName "SchUseStrongCrypto" -Value 0 -Type "DWORD" -Order 6 -Action "Update"
Set-GPPrefRegistryValue -Name "Rollback Enable SCHANNEL for .net" -Context Computer -Key "HKLM\SOFTWARE\Microsoft\.NETFramework\v4.0.30319" -ValueName "SystemDefaultTlsVersions" -Value 0 -Type "DWORD" -Order 7 -Action "Update"
Set-GPPrefRegistryValue -Name "Rollback Enable SCHANNEL for .net" -Context Computer -Key "HKLM\SOFTWARE\Microsoft\.NETFramework\v4.0.30319" -ValueName "SchUseStrongCrypto" -Value 0 -Type "DWORD" -Order 8 -Action "Update"

# Set Rollback GPO 2
Set-GPPrefRegistryValue -Name "Rollback Disable TLS 1.0/1.1" -Context Computer -Key "HKLM\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0" -Order 1 -Action "Update"
Set-GPPrefRegistryValue -Name "Rollback Disable TLS 1.0/1.1" -Context Computer -Key "HKLM\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0\Server" -Order 2 -Action "Update"
Set-GPPrefRegistryValue -Name "Rollback Disable TLS 1.0/1.1" -Context Computer -Key "HKLM\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0\Server" -ValueName "Enabled" -Value 1 -Type "DWORD" -Order 3 -Action "Update"
Set-GPPrefRegistryValue -Name "Rollback Disable TLS 1.0/1.1" -Context Computer -Key "HKLM\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0\Server" -ValueName "DisabledByDefault" -Value 0 -Type "DWORD" -Order 4 -Action "Update"
Set-GPPrefRegistryValue -Name "Rollback Disable TLS 1.0/1.1" -Context Computer -Key "HKLM\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.1" -Order 5 -Action "Update"
Set-GPPrefRegistryValue -Name "Rollback Disable TLS 1.0/1.1" -Context Computer -Key "HKLM\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.1\Server" -Order 6 -Action "Update"
Set-GPPrefRegistryValue -Name "Rollback Disable TLS 1.0/1.1" -Context Computer -Key "HKLM\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.1\Server" -ValueName "Enabled" -Value 1 -Type "DWORD" -Order 7 -Action "Update"
Set-GPPrefRegistryValue -Name "Rollback Disable TLS 1.0/1.1" -Context Computer -Key "HKLM\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.1\Server" -ValueName "DisabledByDefault" -Value 0 -Type "DWORD" -Order 8 -Action "Update"

# Set Rollback GPO 3
Set-GPPrefRegistryValue -Name "Rollback Set Cipher Suite Order 2016" -Context Computer -Key "HKLM\SOFTWARE\Policies\Microsoft\Cryptography\Configuration\SSL\00010002" -ValueName "Functions" -Value "TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384" -Type "String" -Order 1 -Action "Delete"

# Set Rollback GPO 4
Set-GPPrefRegistryValue -Name "Rollback Set Cipher Suite Order 2019" -Context Computer -Key "HKLM\SOFTWARE\Policies\Microsoft\Cryptography\Configuration\SSL\00010002" -ValueName "Functions" -Value "TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384" -Type "String" -Order 1 -Action "Delete"

# Set Rollback GPO 5
Set-GPPrefRegistryValue -Name "Rollback Set Cipher Suite Order 2022" -Context Computer -Key "HKLM\SOFTWARE\Policies\Microsoft\Cryptography\Configuration\SSL\00010002" -ValueName "Functions" -Value "TLS_AES_256_GCM_SHA512,TLS_AES_256_GCM_SHA384,TLS_CHACHA20_POLY1305_SHA256,TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384" -Type "String" -Order 1 -Action "Delete"

#Stop logging
Stop-Transcript