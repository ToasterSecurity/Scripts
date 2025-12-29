#Requires -RunAsAdministrator

# Start logging
$DefaultLogLocation = "C:\Windows\Logs\Create-KerberosSupportedEncryptionTypesGPOs-Log.txt"
Start-Transcript -Path $DefaultLogLocation

# This creates two Group Policy Objects (GPO's)
#  GPO  1 sets the registry to Enforce AES Only Encryption Types
#  GPO  2 sets the registry to Disable Enforce AES Only Encryption Types

# Import the Group Policy Module
Import-Module GroupPolicy

# Create GPO 1
New-GPO -Name "PROD | Enforce AES Only Encryption Types for Kerberos" -Comment "Sets enforcement of AES Only Encryption Types for Kerberos"

# Set GPO 1
Set-GPPrefRegistryValue -Name "PROD | Enforce AES Only Encryption Types for Kerberos" -Context Computer -Key "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\System\Kerberos\Parameters" -ValueName "SupportedEncryptionTypes" -Value 0x7ffffff8 -Type "DWORD" -Order 1 -Action "Update"

# Create Rollback GPO 1
New-GPO -Name "Rollback | Enforce AES Only Encryption Types for Kerberos" -Comment "Rolls back enforcement of AES Only Encryption Types for Kerberos"

# Set Rollback GPO 1
Set-GPPrefRegistryValue -Name "Rollback | Enforce AES Only Encryption Types for Kerberos" -Context Computer -Key "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\System\Kerberos\Parameters" -ValueName "SupportedEncryptionTypes" -Value 0x7fffffff -Type "DWORD" -Order 1 -Action "Update"

#Stop logging
Stop-Transcript