IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[SystemSettings_BackupDatabase]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[SystemSettings_BackupDatabase]
GO

CREATE PROCEDURE SystemSettings_BackupDatabase 
(
	@name varchar(500)
)
AS

DECLARE @BackupDirectory VARCHAR(500) 
DECLARE @sql varchar(8000)

select @BackupDirectory = dbo.DbDirectory()

DECLARE @backupLocation varchar(500)
select @backupLocation = @BackupDirectory + replace(replace(@name,' ',''),'-','_') + '.bak' -- D:\mssql\data\MSSQL.1\MSSQL\Backup\TestView.bak

SELECT @sql = 'BACKUP DATABASE ' + db_name()  + ' TO  DISK = N''' +@backupLocation  + ''' WITH NOFORMAT, NOINIT,  NAME = N'''+ @name +''', SKIP, NOREWIND, NOUNLOAD,  STATS = 10'

exec (@sql)
select 0
