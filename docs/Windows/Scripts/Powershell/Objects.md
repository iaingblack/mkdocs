# Object Snippets

## How to Modify an Object

### Add members
If we pull in some JSON, we get a native powershell object.We can add some fileds as requried and then output it again.

#### Program
```
$json = @"
{
    "id": 1,
    "name": "A green door"
}
"@
$json

$obj = $json | ConvertFrom-JSON 
$obj 

foreach ($item in $obj) {
    $item | Add-Member -NotePropertyName "DoorBell" -NotePropertyValue "Yes"
}

$obj | ConvertTo-JSON
```
#### Output
```
{
    "id": 1,
    "name": "A green door"
}

id name        
-- ----        
 1 A green door
 
{
    "id":  1,
    "name":  "A green door",
    "DoorBell":  "Yes"
}
```

### Convert to CSV and Exclude Some Members
```
$newObj = $newObj | Select-Object -Property * -ExcludeProperty field1, field3
$newObj | ConvertTo-CSV -NoTypeInformation | Out-File -Encoding ascii newFile.csv
```