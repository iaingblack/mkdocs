# Various Tips

## Restoring DBs Over Each Other and Avoiding Connection Issues

Makes single-user, restores and then makes multi-user again. Assumes E drive for Data and F drive for Logs.

```
USE [master]
ALTER DATABASE [MyDB] SET SINGLE_USER WITH ROLLBACK IMMEDIATE
RESTORE DATABASE [MyDB] FROM  DISK = N'X:\MyDB_2079394.bak' WITH  FILE = 1,  MOVE N'MyDB' TO N'E:\Data\MyDB.mdf',  MOVE N'MyDB_Log' TO N'F:\Logs\MyDB.LDF',  NOUNLOAD,  REPLACE,  STATS = 5
ALTER DATABASE [MyDB] SET MULTI_USER
```

## Get Files from Original DB and Use When Restoring New Ones

http://www.mikefal.net/2017/01/25/using-powershell-to-restore-to-a-new-location/

```
    #Amend Tools Folder as Necessary for SQL Version installed
    Import-Module -Name "C:\Program Files (x86)\Microsoft SQL Server\140\Tools\PowerShell\Modules\SQLPS\SQLPS" -Verbose -DisableNameChecking
    # All DBs
    $sqlDBs = @("DB1", "DB2", "DB3")
    $dbBackupsLocation = "\\db-backup-share\DBs"
    $dbBackups = Get-ChildItem -Path $dbBackupsLocation | Select -Property Name 
    
    Write-Host "DBBackups are;"	
    $dbBackups 
    
    foreach ($dbName in $sqlDBs) {
		$relocate = @()
        $dbBackupFile = $dbBackups | findstr $dbName | %{ "\\db-backup-share\DBs\$_" }
		# Need to check against server which already hosts these files, will try and improve as this is a bad dependency
		Write-Host "Gettindg DB $dbName File to restore - $dbBackupFile"
		$dbfiles = Invoke-Sqlcmd -ServerInstance localhost -Database $dbName -Query "RESTORE FILELISTONLY FROM DISK='$dbBackupFile';"

		#Loop through filelist files, replace old paths with new paths
		foreach($dbfile in $dbfiles){
		  $DbFileName = $dbfile.PhysicalName | Split-Path -Leaf
		  if($dbfile.Type -eq 'L'){
			$newfile = Join-Path -Path $NewLogPath -ChildPath $DbFileName
		  } else {
			$newfile = Join-Path -Path $NewDataPath -ChildPath $DbFileName
		  }
		  $relocate += New-Object Microsoft.SqlServer.Management.Smo.RelocateFile ($dbfile.LogicalName,$newfile)
		  
		}
		$relocate
		
		Write-Host "Restoring Database $dbName File $dbBackupFile to $($newDataPath)\$($dbName).mdf and $($newLogPath)\$($dbName)_Log.ldf"
		#Create Restore script (to test the single user modes on next restore attempt, currently get error about obtaining exclusive access)
		Invoke-Sqlcmd -ServerInstance localhost -Database $dbName -Query "ALTER DATABASE $dbName SET SINGLE_USER WITH ROLLBACK IMMEDIATE"
		Restore-SqlDatabase -ServerInstance localhost -Database $dbName -RelocateFile $relocate -BackupFile $dbBackupFile -RestoreAction Database -ReplaceDatabase
		Invoke-Sqlcmd -ServerInstance localhost -Database $dbName -Query "ALTER DATABASE [$dbName] SET MULTI_USER"
		
		# OR WE CAN DO THIS AND THERE IS NO ACCESS ISSUE TO CONTEND WITH - DELETE DBs FIRST. But, this is a bit drastic.
		# Invoke-Sqlcmd -ServerInstance localhost -Database $dbName -Query "DROP DATABASE [$dbName]"
		# Restore-SqlDatabase -ServerInstance localhost -Database $dbName -RelocateFile $relocate -BackupFile $dbBackupFile -RestoreAction Database
    }
```
