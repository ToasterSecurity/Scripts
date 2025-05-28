Require LDAP Signing

#Requires -RunAsAdministrator

# Start logging
$DefaultLogLocation = "C:\Windows\Logs\Create-LDAPGPOs-Log.txt"
Start-Transcript -Path $DefaultLogLocation

# This creates three Group Policy Objects (GPO's)
#  GPO  1 sets the registry to Enable LDAP Signing
#  GPO  2 sets the registry to Require LDAP Signing
#  GPO  3 sets the registry to Disable LDAP Signing 

# Import the Group Policy Module
Import-Module GroupPolicy

# Create GPO 1
New-GPO -Name "PROD | Enable LDAP Signing" -Comment "Disables LLMNR via the registry"

# Set GPO 1
Set-GPPrefRegistryValue -Name "PROD | Enable LDAP Signing" -Context Computer -Key "HKLM\SYSTEM\CurrentControlSet\Services\NTDS\Parameters" -Order 1 -Action "Update"
Set-GPPrefRegistryValue -Name "PROD | Enable LDAP Signing" -Context Computer -Key "HKLM\SYSTEM\CurrentControlSet\Services\NTDS\Parameters" -ValueName "LDAPServerIntegrity" -Value 1 -Type "DWORD" -Order 1 -Action "Update"

# Create GPO 2
New-GPO -Name "PROD | Require LDAP Signing" -Comment "Disables LLMNR via the registry"

# Set GPO 2
Set-GPPrefRegistryValue -Name "PROD | Require LDAP Signing" -Context Computer -Key "HKLM\SYSTEM\CurrentControlSet\Services\NTDS\Parameters" -Order 1 -Action "Update"
Set-GPPrefRegistryValue -Name "PROD | Require LDAP Signing" -Context Computer -Key "HKLM\SYSTEM\CurrentControlSet\Services\NTDS\Parameters" -ValueName "LDAPServerIntegrity" -Value 2 -Type "DWORD" -Order 1 -Action "Update"

# Create Rollback GPO 2
New-GPO -Name "Rollback | Enable LDAP Signing" -Comment "Enables LLMNR via the registry"

# Set Rollback GPO 2
Set-GPPrefRegistryValue -Name "Rollback | Enable LDAP Signing" -Context Computer -Key "HKLM\SYSTEM\CurrentControlSet\Services\NTDS\Parameters" -Order 1 -Action "Update"
Set-GPPrefRegistryValue -Name "Rollback | Enable LDAP Signing" -Context Computer -Key "HKLM\SYSTEM\CurrentControlSet\Services\NTDS\Parameters" -ValueName "LDAPServerIntegrity" -Value 0 -Type "DWORD" -Order 1 -Action "Update"

#Stop logging
Stop-Transcript