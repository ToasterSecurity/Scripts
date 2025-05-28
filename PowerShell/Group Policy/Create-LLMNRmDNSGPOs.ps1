#Requires -RunAsAdministrator

# Start logging
$DefaultLogLocation = "C:\Windows\Logs\Create-LLMNRmDNS-Log.txt"
Start-Transcript -Path $DefaultLogLocation

# This creates four Group Policy Objects (GPO's)
#  GPO  1 sets the registry to Disable Link-Local Multicast Name Resolution (LLMNR)
#  GPO  2 sets the registry to Disable Multicast Dynamic Name Resolution (mDNS)
#  GPO  3 sets the registry to Enable LLMNR as a rollback for if GPO 5 creates issues in the environment
#  GPO  4 sets the registry to Enable Multicast Dynamic Name Resolution (mDNS)

# Import the Group Policy Module
Import-Module GroupPolicy

# Create GPO 1
New-GPO -Name "PROD | Disable LLMNR" -Comment "Disables LLMNR via the registry"

# Set GPO 1
Set-GPPrefRegistryValue -Name "PROD | Disable LLMNR" -Context Computer -Key "HKLM\Software\policies\Microsoft\Windows NT\DNSClient" -Order 1 -Action "Update"
Set-GPPrefRegistryValue -Name "PROD | Disable LLMNR" -Context Computer -Key "HKLM\Software\policies\Microsoft\Windows NT\DNSClient" -ValueName "EnableMulticast" -Value 0 -Type "DWORD" -Order 1 -Action "Update"

# Create GPO 2
New-GPO -Name "PROD | Disable mDNS" -Comment "Disables mDNS via the registry"

# Set GPO 2
Set-GPPrefRegistryValue -Name "PROD | Disable mDNS" -Context Computer -Key "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" -Order 1 -Action "Update"
Set-GPPrefRegistryValue -Name "PROD | Disable mDNS" -Context Computer -Key "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" -ValueName "EnableMDNS" -Value 0 -Type "DWORD" -Order 2 -Action "Update"

# Create Rollback GPO 3
New-GPO -Name "Rollback | Disable LLMNR" -Comment "Enables LLMNR via the registry"

# Set Rollback GPO 3
Set-GPPrefRegistryValue -Name "Rollback | Disable LLMNR" -Context Computer -Key "HKLM\Software\policies\Microsoft\Windows NT\DNSClient" -Order 1 -Action "Update"
Set-GPPrefRegistryValue -Name "Rollback | Disable LLMNR" -Context Computer -Key "HKLM\Software\policies\Microsoft\Windows NT\DNSClient" -ValueName "EnableMulticast" -Value 1 -Type "DWORD" -Order 1 -Action "Update"

# Create Rollback GPO 4
New-GPO -Name "Rollback | Disable mDNS" -Comment "Enables mDNS via the registry"

# Set Rollback GPO 4
Set-GPPrefRegistryValue -Name "Rollback | Disable mDNS" -Context Computer -Key "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" -Order 1 -Action "Update"
Set-GPPrefRegistryValue -Name "Rollback | Disable mDNS" -Context Computer -Key "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" -ValueName "EnableMDNS" -Value 1 -Type "DWORD" -Order 2 -Action "Update"

#Stop logging
Stop-Transcript