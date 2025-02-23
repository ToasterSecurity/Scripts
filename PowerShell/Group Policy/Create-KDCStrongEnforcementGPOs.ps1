#Requires -RunAsAdministrator

# Start logging
$DefaultLogLocation = "C:\Windows\Logs\Create-KDCStrongEnforcementGPOs-Log.txt"
Start-Transcript -Path $DefaultLogLocation

# This creates ten Group Policy Objects (GPO's)
#  GPO  1 sets the registry to Enforce Strong Certificate Binidng
#  GPO  2 sets the registry to Disable Enforcement of Strong Certificate Binidng

# Import the Group Policy Module
Import-Module GroupPolicy

# Create GPO 1
New-GPO -Name "PROD | Enforce KDC Strong Certificate Binding" -Comment "Sets enforcement of strong certificate binding for KDC"

# Set GPO 1
Set-GPPrefRegistryValue -Name "PROD | Enforce KDC Strong Certificate Binding" -Context Computer -Key "HKLM\SYSTEM\CurrentControlSet\Services\Kdc" -ValueName "StrongCertificateBindingEnforcement" -Value 2 -Type "DWORD" -Order 1 -Action "Update"

# Create Rollback GPO 1
New-GPO -Name "Rollback | Disable Enforce KDC Strong Certificate Binding" -Comment "Rolls back enforcement of strong certificate binding for KDC"

# Set Rollback GPO 1
Set-GPPrefRegistryValue -Name "Rollback | Disable Enforce KDC Strong Certificate Binding" -Context Computer -Key "HKLM\SYSTEM\CurrentControlSet\Services\Kdc" -ValueName "StrongCertificateBindingEnforcement" -Value 1 -Type "DWORD" -Order 1 -Action "Update"

#Stop logging
Stop-Transcript