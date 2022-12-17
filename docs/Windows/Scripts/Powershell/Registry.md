# Registry Snippets

## How to Modify a RegKey

### Change value Existing Key
For example, turn FIPS off

#### Program
Set-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\FipsAlgorithmPolicy\ -Name Enabled -Value 0