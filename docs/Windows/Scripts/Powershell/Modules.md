# Modules

## General Handy Tricks

### Find the usage of module cmdlets in a set of files (non-recursive, only current folder)

```
foreach ($cmd in (get-command -Module Carbon).Name) { select-string -path *.ps1 -Pattern $cmd }
```

```
$files = Get-Childitem -Recurse *
$carbonCmdlets  = (get-command -Module Carbon).Name
foreach ($carbonCmdlet in $carbonCmdlets) { 
    Write-Host ": Checking cmdlet $carbonCmdlet"
    foreach ($file in $files) {
        Write-Host ": Checking file $file"
        select-string -path *.ps1 -Pattern $carbonCmdlet Format-List
    }
}
```