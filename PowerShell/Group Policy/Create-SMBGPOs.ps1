#Requires -RunAsAdministrator

# Start logging
$DefaultLogLocation = "C:\Windows\Logs\Create-SMBGPOs-Log.txt"
Start-Transcript -Path $DefaultLogLocation

# This creates fourteen Group Policy Objects (GPO's)
#  GPO  1 sets the registry to Disable Server Message Block (SMB) v1 Server
#  GPO  2 sets the registry to Disable SMB v2
#  GPO  3 sets the registry to Enable SMB signing as available
#  GPO  4 sets the registry to Require/Force SMB signing
#  GPO  5 sets the registry to Disable SMB v1 Client
#  GPO  6 sets the registry to Disable SMB v2 Client
#  GPO  7 sets the registry to Require SMB Encryption
#  GPO  8 sets the registry to Enable SMB v1 as a rollback for if GPO 1 creates issues in the environment
#  GPO  9 sets the registry to Enable SMB v2 as a rollback for if GPO 2 creates issues in the environment
#  GPO 10 sets the registry to Disable SMB signing as a rollback for if GPO 3 creates issues in the environment
#  GPO 11 sets the registry to Disable requiring/forcing SMB signing as a rollback for if GPO 4 creates issues in the environment
#  GPO 12 sets the registry to Enable SMB v1 Client as a rollback for if GPO 5 creates issues in the environment
#  GPO 13 sets the registry to Enable SMB v2 Client as a rollback for if GPO 6 creates issues in the environment
#  GPO 14 sets the registry to Not Require SMB Encryption as a rollback for if GPO 7 Creates issues in the environment

# Import the Group Policy Module
Import-Module GroupPolicy

# Create GPO 1
New-GPO -Name "PROD | Disable SMB v1 Server" -Comment "Sets the registry to Disable SMB v1 Server"

# Create GPO 2
New-GPO -Name "PROD | Disable SMB v2 Server" -Comment "Sets the registry to Disable SMB v2 Server"

# Create GPO 3
New-GPO -Name "PROD | Enable SMB Signing" -Comment "Enables SMB Signing via the registry"

# Create GPO 4
New-GPO -Name "PROD | Require SMB Signing" -Comment "Requires SMB Signing via the registry"

# Create GPO 5
New-GPO -Name "PROD | Disable SMB v1 Client" -Comment "Sets the registry to Disable SMB v1 Client"

# Create GPO 6
New-GPO -Name "PROD | Disable SMB v2 Client" -Comment "Sets the registry to Disable SMB v2 Client"

# Create GPO 7
New-GPO -Name "PROD | Require SMB Encryption" -Comment "Sets the registry to Require SMB Encryption"

# Set GPO 1
Set-GPPrefRegistryValue -Name "PROD | Disable SMB v1 Server" -Context Computer -Key "HKLM\SYSTEM\CurrentControlSet\Services\S\Parameters" -ValueName "SMB1" -Value 0 -Type "DWORD" -Order 1 -Action "Update"

# Set GPO 2
Set-GPPrefRegistryValue -Name "PROD | Disable SMB v2 Server" -Context Computer -Key "HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" -ValueName "SMB2" -Value 0 -Type "DWORD" -Order 1 -Action "Update"

# Set GPO 3
Set-GPPrefRegistryValue -Name "PROD | Enable SMB Signing" -Context Computer -Key "HKLM\SYSTEM\CurrentControlSet\Services\LanManWorkstation\Parameters" -Order 1 -Action "Update"
Set-GPPrefRegistryValue -Name "PROD | Enable SMB Signing" -Context Computer -Key "HKLM\SYSTEM\CurrentControlSet\Services\LanManWorkstation\Parameters" -ValueName "EnableSecuritySignature" -Value 1 -Type "DWORD" -Order 2 -Action "Update"
Set-GPPrefRegistryValue -Name "PROD | Enable SMB Signing" -Context Computer -Key "HKLM\SYSTEM\CurrentControlSet\Services\LanManServer\Parameters" -Order 3 -Action "Update"
Set-GPPrefRegistryValue -Name "PROD | Enable SMB Signing" -Context Computer -Key "HKLM\SYSTEM\CurrentControlSet\Services\LanManServer\Parameters" -ValueName "EnableSecuritySignature" -Value 1 -Type "DWORD" -Order 4 -Action "Update"

# Set GPO 4
Set-GPPrefRegistryValue -Name "PROD | Require SMB Signing" -Context Computer -Key "HKLM\SYSTEM\CurrentControlSet\Services\LanManWorkstation\Parameters" -Order 1 -Action "Update"
Set-GPPrefRegistryValue -Name "PROD | Require SMB Signing" -Context Computer -Key "HKLM\SYSTEM\CurrentControlSet\Services\LanManWorkstation\Parameters" -ValueName "RequireSecuritySignature" -Value 1 -Type "DWORD" -Order 2 -Action "Update"
Set-GPPrefRegistryValue -Name "PROD | Require SMB Signing" -Context Computer -Key "HKLM\SYSTEM\CurrentControlSet\Services\LanManServer\Parameters" -Order 3 -Action "Update"
Set-GPPrefRegistryValue -Name "PROD | Require SMB Signing" -Context Computer -Key "HKLM\SYSTEM\CurrentControlSet\Services\LanManServer\Parameters" -ValueName "RequireSecuritySignature" -Value 1 -Type "DWORD" -Order 4 -Action "Update"

# Set GPO 5
Set-GPPrefRegistryValue -Name "PROD | Disable SMB v1 Client" -Context Computer -Key "HKLM\SYSTEM\CurrentControlSet\services\mrxsmb10" -ValueName "Start" -Value 4 -Type "DWORD" -Order 1 -Action "Update"
Set-GPPrefRegistryValue -Name "PROD | Disable SMB v1 Client" -Context Computer -Key "HKLM\SYSTEM\CurrentControlSet\Services\LanmanWorkstation" -ValueName "DependOnService" -Value "Bowser","MRxSmb20","NSI" -Type "MultiString" -Order 2 -Action "Update"

# Set GPO 6
Set-GPPrefRegistryValue -Name "PROD | Disable SMB v2 Client" -Context Computer -Key "HKLM\SYSTEM\CurrentControlSet\services\mrxsmb20" -ValueName "Start" -Value 4 -Type "DWORD" -Order 1 -Action "Update"
Set-GPPrefRegistryValue -Name "PROD | Disable SMB v2 Client" -Context Computer -Key "HKLM\SYSTEM\CurrentControlSet\Services\LanmanWorkstation" -ValueName "DependOnService" -Value "Bowser","NSI" -Type "MultiString" -Order 2 -Action "Update"

# Set GPO 7
Set-GPPrefRegistryValue -Name "PROD | Require SMB Encryption" -Context Computer -Key "HKLM\SOFTWARE\Policies\Microsoft\Windows\LanmanWorkstation" -ValueName "RequireEncryption" -Value 1 -Type "DWORD" -Order 1 -Action "Update"

# Create Rollback GPO 1
New-GPO -Name "Rollback | Disable SMB v1" -Comment "Sets the LAN Manager authentication level in the Computer Configuration"

# Create Rollback GPO 2
New-GPO -Name "Rollback | Disable SMB v2" -Comment "Sets the LAN Manager authentication level in the Computer Configuration"

# Create Rollback GPO 3
New-GPO -Name "Rollback | Enable SMB Signing" -Comment "Disables SMB Signing via the registry"

# Create Rollback GPO 4
New-GPO -Name "Rollback | Require SMB Signing" -Comment "Removes requirement for SMB Signing via the registry"

# Create Rollback GPO 5
New-GPO -Name "Rollback | Disable SMB v1 Client" -Comment "Sets the registry to Enable SMB v1 Client"

# Create Rollback GPO 6
New-GPO -Name "Rollback | Disable SMB v2 Client" -Comment "Sets the registry to Enable SMB v2 Client"

# Create Rollback GPO 7
New-GPO -Name "Rollback | Require SMB Encryption" -Comment "Sets the registry to Not Require SMB Encryption"

# Set Rollback GPO 1
Set-GPPrefRegistryValue -Name "Rollback | Disable SMB v1" -Context Computer -Key "HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" -ValueName "SMB1" -Value 1 -Type "DWORD" -Order 1 -Action "Update"

# Set Rollback GPO 2
Set-GPPrefRegistryValue -Name "Rollback | Disable SMB v2" -Context Computer -Key "HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" -ValueName "SMB2" -Value 1 -Type "DWORD" -Order 1 -Action "Update"

# Set Rollback GPO 3
Set-GPPrefRegistryValue -Name "Rollback | Enable SMB Signing" -Context Computer -Key "HKLM\SYSTEM\CurrentControlSet\Services\LanManWorkstation\Parameters" -Order 1 -Action "Update"
Set-GPPrefRegistryValue -Name "Rollback | Enable SMB Signing" -Context Computer -Key "HKLM\SYSTEM\CurrentControlSet\Services\LanManWorkstation\Parameters" -ValueName "EnableSecuritySignature" -Value 0 -Type "DWORD" -Order 2 -Action "Update"
Set-GPPrefRegistryValue -Name "Rollback | Enable SMB Signing" -Context Computer -Key "HKLM\SYSTEM\CurrentControlSet\Services\LanManServer\Parameters" -Order 3 -Action "Update"
Set-GPPrefRegistryValue -Name "Rollback | Enable SMB Signing" -Context Computer -Key "HKLM\SYSTEM\CurrentControlSet\Services\LanManServer\Parameters" -ValueName "EnableSecuritySignature" -Value 0 -Type "DWORD" -Order 4 -Action "Update"

# Set Rollback GPO 4
Set-GPPrefRegistryValue -Name "Rollback | Require SMB Signing" -Context Computer -Key "HKLM\SYSTEM\CurrentControlSet\Services\LanManWorkstation\Parameters" -Order 1 -Action "Update"
Set-GPPrefRegistryValue -Name "Rollback | Require SMB Signing" -Context Computer -Key "HKLM\SYSTEM\CurrentControlSet\Services\LanManWorkstation\Parameters" -ValueName "RequireSecuritySignature" -Value 0 -Type "DWORD" -Order 2 -Action "Update"
Set-GPPrefRegistryValue -Name "Rollback | Require SMB Signing" -Context Computer -Key "HKLM\SYSTEM\CurrentControlSet\Services\LanManServer\Parameters" -Order 3 -Action "Update"
Set-GPPrefRegistryValue -Name "Rollback | Require SMB Signing" -Context Computer -Key "HKLM\SYSTEM\CurrentControlSet\Services\LanManServer\Parameters" -ValueName "RequireSecuritySignature" -Value 0 -Type "DWORD" -Order 4 -Action "Update"

# Set Rollback GPO 5
Set-GPPrefRegistryValue -Name "Rollback | Disable SMB v1 Client" -Context Computer -Key "HKLM\SYSTEM\CurrentControlSet\services\mrxsmb10" -ValueName "Start" -Value 3 -Type "DWORD" -Order 1 -Action "Update"
Set-GPPrefRegistryValue -Name "Rollback | Disable SMB v1 Client" -Context Computer -Key "HKLM\SYSTEM\CurrentControlSet\Services\LanmanWorkstation" -ValueName "DependOnService" -Value "Bowser","MRxSmb10","MRxSmb20","NSI" -Type "MultiString" -Order 2 -Action "Update"

# Set Rollback GPO 6
Set-GPPrefRegistryValue -Name "Rollback | Disable SMB v2 Client" -Context Computer -Key "HKLM\SYSTEM\CurrentControlSet\services\mrxsmb20" -ValueName "Start" -Value 3 -Type "DWORD" -Order 1 -Action "Update"
Set-GPPrefRegistryValue -Name "Rollback | Disable SMB v2 Client" -Context Computer -Key "HKLM\SYSTEM\CurrentControlSet\Services\LanmanWorkstation" -ValueName "DependOnService" -Value "Bowser","MRxSmb20","NSI" -Type "MultiString" -Order 2 -Action "Update"

# Set GPO 7
Set-GPPrefRegistryValue -Name "Rollback | Require SMB Encryption" -Context Computer -Key "HKLM\SOFTWARE\Policies\Microsoft\Windows\LanmanWorkstation" -ValueName "RequireEncryption" -Value 0 -Type "DWORD" -Order 1 -Action "Update"

#Stop logging
Stop-Transcript