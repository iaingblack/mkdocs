# Local Users And Groups

## Group Membership

### List all members of a local group

This returns all members of Local Administrators. All the CIM/WMI methods take forever. This works via net localgroup command

get-localgroupmembers -localgroup administrators

```
get-localgroupmembers -localgroup administrators
function get-localgroupmembers {  
    [cmdletBinding()] 
    param (
        [Parameter(Mandatory=$True)] 
        [string] $localgroup
    )  
      
    $members = net localgroup $localgroup | 
    where {$_ -AND $_ -notmatch "command completed successfully"} | 
    select -skip 4
    New-Object PSObject -Property @{
    Computername = $env:COMPUTERNAME
    Group = "$localgroup"
    Members=$members
    } | Out-Null
    $members
}
```

Show available local groups on the machine
```
get-localgroups
function get-localgroups {  
    net localgroup | 
    where {$_ -AND $_ -notmatch "command completed successfully"} | 
    select -skip 2 | 
    ForEach-Object { $_.substring(1,$_.Length - 1) }
}
```

Example Usage

```
$users  = "usera","userb"
$groups = "administrators","HPCUsers"
foreach ($localgroup in $localgroups) {  
    Write-Host "Checking group '$localgroup' exists"
    if ((get-localgroups) -contains $localgroup) {
        Write-Host "Group '$localgroup' exists. Adding users"
        foreach ($user in $users) {  
            if ((get-localgroupmembers -localgroup $localgroup) -contains "$user") {
                net localgroup localgroup $user /add
                Write-Host "$($localgroup): User $user added"
            } else {
                Write-Host "$($localgroup): User $user already added"
            }
        }
    }
    else { Write-Host "Group '$localgroup' does not exist. Skipping adding users" }
}
```    

Add user/group to remove machines local admin group

```
$ComputerNames = @("gla-rs5-ria-vm1","gla-rs5-app-vm1","gla-rs5-web-vm1","gla-rs5-sql-vm1")

$DomainName = "ctopad"
foreach ($computername in $computernames) {
    $UserName = "RemoteLogin_Rights_Gla-rs5"
    $computername
    $AdminGroup = [ADSI]"WinNT://$ComputerName/Administrators,group"
    $User = [ADSI]"WinNT://$DomainName/$UserName,group"
    $AdminGroup.Add($User.Path)
}
```