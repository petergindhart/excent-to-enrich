
IF EXISTS (SELECT name 
	   FROM   sysobjects 
	   WHERE  name = N'TestBinding_BindByColumn' 
	   AND 	  type = 'P')
    DROP PROCEDURE dbo.TestBinding_BindByColumn
GO

/*
<summary>
Attempts to bind a test to a student in the system
</summary>
<param name="column">Name of the column to search against</param>
<param name="value">Value to search for</param>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/


CREATE PROCEDURE dbo.TestBinding_BindByColumn
	@column		VARCHAR(1000),
	@value		VARCHAR(1000)
AS

	declare @sql varchar(1000)
	set @sql = '
		SELECT *
		FROM Student 
		WHERE ' + @column + ' = ''' + @value + ''''

	exec(@sql)
GO

