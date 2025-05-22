#Requires -RunAsAdministrator

# Start logging
$DefaultLogLocation = "C:\Windows\Logs\Create-NTLMv1GPOs-Log.txt"
Start-Transcript -Path $DefaultLogLocation

# This creates two Group Policy Objects (GPO's)
#  GPO 1 sets the registry to Disable NTLMv1 and older authentication methods
#  GPO 2 sets the registry to Enable NTLMv1 and older authentication methods as a rollback for if GPO 1 creates issues in the environment

# Import the Group Policy Module
Import-Module GroupPolicy

# Create GPO 1
New-GPO -Name "PROD | Disable NTLMv1 and older" -Comment "Sets Computer Configuration variable Network security: LAN Manager authentication level"

# Set GPO 1
Set-GPPrefRegistryValue -Name "PROD | Disable NTLMv1 and older" -Context Computer -Key "HKLM\System\CurrentControlSet\Control\Lsa" -ValueName "LmCompatibilityLevel" -Value 5 -Type "DWORD" -Order 1 -Action "Update"

# Create Rollback GPO 1
New-GPO -Name "Rollback | Disable NTLMv1 and older" -Comment "Sets Computer Configuration variable Network security: LAN Manager authentication level"

# Set Rollback GPO 1
Set-GPPrefRegistryValue -Name "Rollback | Disable NTLMv1 and older" -Context Computer -Key "HKLM\System\CurrentControlSet\Control\Lsa" -ValueName "LmCompatibilityLevel" -Value 1 -Type "DWORD" -Order 1 -Action "Update"

#Stop logging
Stop-Transcript