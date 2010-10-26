-- =============================================
-- Create procedure basic template
-- =============================================
-- creating the store procedure
IF EXISTS (SELECT name 
	   FROM   sysobjects 
	   WHERE  name = N'Util_DropConstraints' 
	   AND 	  type = 'P')
    DROP PROCEDURE dbo.Util_DropConstraints
GO

CREATE PROCEDURE dbo.Util_DropConstraints 
	@table 				sysname,
	@column 			sysname		= NULL,
	@constraintType 	char(2)		= NULL,
	@owner				sysname		= 'dbo'
AS
	DECLARE @crlf varchar(2); 	
	set @crlf = char(10) + char(13)

	DECLARE @cmd VARCHAR(8000)

	SELECT 
		@cmd = isnull(@cmd + @crlf, '') + 'ALTER TABLE ' + @owner + '.[' + @table + '] DROP CONSTRAINT [' + name + ']'
--	*
	FROM 
		sysobjects so 
		JOIN sysconstraints sc ON so.id = sc.constid 
	WHERE 
		object_name(so.parent_obj) = @table AND 
		(@constraintType is null OR so.xtype = @constraintType) AND
		(
			--include the primary key constaints
			(sc.colid = 0 AND (@column is null OR name = @column)) OR
			--include foreign and default constraints
			(sc.colid in 
				(SELECT colid 
				FROM syscolumns 
			 	WHERE id = object_id(@owner + '.' + @table) AND (@column is null OR name = @column)))
		)
		-- order by colid to ensure pk are drop last
		ORDER BY sc.colid DESC

	--PRINT @cmd
	exec(@cmd)
GO

