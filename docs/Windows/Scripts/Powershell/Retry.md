Use this to get a command which could be fragile to retry repeateadly until it succeds instead of breaking

```
function Retry-Command {
    [CmdletBinding()]
    Param(
        [Parameter(Position=0, Mandatory=$true)]
        [scriptblock]$ScriptBlock,

        [Parameter(Position=1, Mandatory=$false)]
        [int]$Maximum = 10,

        
        [Parameter(Position=2, Mandatory=$false)]
        [int]$Sleep = 5
    )

    Begin {
        $cnt = 0
    }

    Process {
        do {
            $cnt++
            try {
                $ScriptBlock.Invoke()
                return
            } catch {
                Write-Error $_.Exception.InnerException.Message -ErrorAction Continue
                Write-Host "Sleeping for $sleep seconds and trying again"
                Start-Sleep $Sleep
            }
        } while ($cnt -lt $Maximum)

        # Throw an error after $Maximum unsuccessful invocations. Doesn't need
        # a condition, since the function returns upon successful invocation.
        throw 'Execution failed.'
    }
}

$installPs1 = $null

$installPs1 = Retry-Command -ScriptBlock {
    ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))
} -Maximum 3

$installPs1 -eq $null
```
