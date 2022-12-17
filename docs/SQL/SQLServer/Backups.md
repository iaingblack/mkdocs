To backup multiple DBs, run this command

```
DECLARE @name VARCHAR(50) -- database name
DECLARE @path VARCHAR(256) -- path for backup files
DECLARE @fileName VARCHAR(256) -- filename for backup
DECLARE @fileDate VARCHAR(20) -- used for file name

-- specify database backup directory
SET @path = 'C:\SQL_Backups_Temp\'

-- specify filename format
-- SELECT @fileDate = CONVERT(VARCHAR(20),GETDATE(),112) -- DBname_YYYYDDMM.BAK
SELECT @fileDate = CONVERT(VARCHAR(20),GETDATE(),112) + '_' + REPLACE(CONVERT(VARCHAR(20),GETDATE(),108),':','') -- DBname_YYYYDDMM_HHMMSS.BAK

DECLARE db_cursor CURSOR READ_ONLY FOR
SELECT name
FROM master.sys.databases
WHERE name NOT IN ('master','model','msdb','tempdb') -- exclude these databases
AND name like 'DB_Name_00%' -- % means any chars afterwards. Remove if no filter needed
AND state = 0 -- database is online
AND is_in_standby = 0 -- database is not read only for log shipping

OPEN db_cursor
FETCH NEXT FROM db_cursor INTO @name

WHILE @@FETCH_STATUS = 0
BEGIN
  PRINT @name
  SET @fileName = @path + @name + '_' + @fileDate + '.BAK'
  BACKUP DATABASE @name TO DISK = @fileName WITH COMPRESSION
  FETCH NEXT FROM db_cursor INTO @name
END

CLOSE db_cursor
DEALLOCATE db_cursor
```