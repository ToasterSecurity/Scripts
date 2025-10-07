#Requires -RunAsAdministrator

# Start logging
$DefaultLogLocation = "C:\Windows\Logs\Create-DoNotAllowAnonymousEnumerationOfSAMaccounts-Log.txt"
Start-Transcript -Path $DefaultLogLocation

# This creates two Group Policy Objects (GPO's)
#  GPO  1 sets the registry to not allow anonymous enumeration of SAM accounts
#  GPO  2 sets the registry to allow anonymous enumeration of SAM accounts

# Import the Group Policy Module
Import-Module GroupPolicy

# Create GPO 1
New-GPO -Name "PROD | Do not allow anonymous enumeration of SAM accounts" -Comment "Sets enforcement of strong certificate binding for KDC"

# Set GPO 1
Set-GPPrefRegistryValue -Name "PROD | Do not allow anonymous enumeration of SAM accounts" -Context Computer -Key "HKLM\SYSTEM\CurrentControlSet\LSA" -ValueName "RestrictAnonymous" -Value 1 -Type "DWORD" -Order 1 -Action "Update"

# Create Rollback GPO 1
New-GPO -Name "Rollback | Disable Do not allow anonymous enumeration of SAM accounts" -Comment "Rolls back enforcement of strong certificate binding for KDC"

# Set Rollback GPO 1
Set-GPPrefRegistryValue -Name "Rollback | Disable Do not allow anonymous enumeration of SAM accounts" -Context Computer -Key "HKLM\SYSTEM\CurrentControlSet\LSA" -ValueName "RestrictAnonymous" -Value 0 -Type "DWORD" -Order 1 -Action "Update"

#Stop logging
Stop-Transcript