
# Installed Windows Roles and Features

## Write Existing Roles and Features to a Features.txt File

```
Import-Module ServerManager
Get-WindowsFeature | 
  ? { $_.Installed } | 
  Sort-Object Name | 
  Select Name | 
  ForEach-Object { $_.Name } | 
  Out-File .\Features.txt
```

## Install Roles and Features from a Features.txt File

```
Import-Module ServerManager
$(Get-Content .\Features.txt) | 
  Add-WindowsFeature
```