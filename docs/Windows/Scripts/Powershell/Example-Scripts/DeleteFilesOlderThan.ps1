#----- define parameters -----#
#----- get current date ----#
$Now = Get-Date
#----- define amount of days ----#
$Days = "442"
$filecount = 0
#----- test mode on or off ----#
$deletemode = $false
$paths = "c:\windows\temp"
#----- define extension ----#
$Extension = "*.*"
#----- define LastWriteTime parameter based on $Days ---#
$LastWrite = $Now.AddDays(-$Days)

$log = "DELETING FILES OLDER THAN $LastWrite `r`n"
try {
    foreach ($path in $paths){
    #----- get files based on lastwrite filter and specified folder ---#
    $Files = Get-Childitem $path -Include $Extension -Recurse | Where {$_.LastWriteTime -le "$LastWrite"}
  
    foreach ($File in $Files) 
        {
        if ($File -ne $NULL)
            {
            if ((Get-Item $File) -is [System.IO.DirectoryInfo]) {
                write-host $File is a directory, skipping
                $log = $log + " " + $File + "is a directory, skipping`r`n"
            }
            else {
                write-host "Would Delete File $File with date " $file.LastWriteTime -ForegroundColor "DarkRed"
                $log = $log + "Deleting File $File with date " + $file.LastWriteTime + "`r`n"
                $filecount = $filecount + 1
			        if ($deletemode) {
				        Remove-Item $File.FullName | out-null
                        Write-Host "Deleted File $File with date " + $file.LastWriteTime
                        $log = $log + "Deleted File $File with date " + $file.LastWriteTime + "`r`n"
			        }
                }
            }
        else
            {
            Write-Host "No more files to delete!" -foregroundcolor "Green"
            }
        }
    }
    $log = $log + "Would delete $filecount files`r`n"
    $log | Set-Content 'c:\Windows\Temp\results.txt'
    Write-Host "Would delete $filecount files"
    Write-Host $LastWrite
}
Catch
{
    $ErrorMessage = $_.Exception.Message
    $FailedItem = $_.Exception.ItemName
    Write-Host "We failed to read file $FailedItem. The error message was $ErrorMessage"
    Break
}