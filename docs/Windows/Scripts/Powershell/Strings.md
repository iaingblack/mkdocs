

Check a string passed is A-Z or a-z and then loop through all letters

```
[Parameter(Mandatory=$False)]
[ValidatePattern('^[A-Za-z]$')]
[string]$diskLetterStartingPlace="E",

$letters = [int][char]$diskLetterStartingPlace..89 | ForEach-Object { [char]$_ }

e
f
g
...
```
