
# Jobs



## General

```
$rgVMs = @("TEST01", "test02")
$bleh2 = "____"

# Clear any existing jobs in session (should be none, but you never know)
Get-Job | Remove-Job -Force

# Do on each VM
foreach ($vm in $rgvms) {
    $scriptblock = {
    param(
        $vm,
        $bleh2
    )
        Write-Host "Getting vm $vm and $bleh2"
        Start-Sleep 1
        Write-Host "$vm - 1"
        Start-Sleep 1
        Write-Host "$vm - 2"
    }
    Start-Job -ScriptBlock $scriptBlock -ArgumentList $vm,$bleh2
}

$timeoutInMinutes = 5
$starTime = GetDate
# Loop until the jobs are finished or timeout happens
While (Get-Job -State "Running") {
    $elapsedTime = ((Get-Date) - $startTime).TotalMinutes
    if ($elapsedTime -gt $timeoutInMinutes) {
      throw "Something went wrong. Shouldnt take as long as $timeoutInMinutes minutes."
    } else {
      # Will show us updates of whats happening on each VM
      Get-Job | Receive-Job
      Start-Sleep 1
    }
} 
# Get all the complete/failed jobs output
Get-Job | Receive-Job
# Clear the history once done
Get-Job | Remove-Job -Force
```
## Azure

### Pass Login Context

It may be necessary to login and pass the login session tot he job as it will not retain the login information by default. Get around this by using;

```
# https://github.com/Azure/azure-powershell/wiki/Automatic-Context-Autosave

Enable-AzureRMContextAutosave                 # Load in all new sessions (may cause overwrites in seperate logins on same system)
Enable-AzureRMContextAutosave -scope Process  # Keeps in memory so should avoid token.dat overwrites
```

Or, pass current context into a cmdlet that accepts a job already (most long running ones do already)

```
$job = Start-Job { param ($ctx) New-AzVm -AzureRmContext $ctx [... Additional parameters ...]} -ArgumentList (Get-AzContext)
```