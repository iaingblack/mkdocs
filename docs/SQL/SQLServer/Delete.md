To delete multiple DB's run something like this

```
use master
go

declare @dbnames nvarchar (max)
declare @statement nvarchar (max)
set @dbnames = ''
set @statement = ''

select @dbnames = @dbnames + ', [' + name + ']' from sys.databases where name like 'DB_Name_00%'
if len (@dbnames) = 0
  begin
    print 'No databases to drop.'
  end
else
  begin
    set @statement = 'DROP DATABASE ' + substring (@dbnames, 2, len (@dbnames)) -- The 2 is just to ignore the ', ' from the select above
    print @statement
    exec sp_executesql @statement -- Comment to show results first
end
```