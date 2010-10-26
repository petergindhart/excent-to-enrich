SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[TestDefinition_ExecForEach]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[TestDefinition_ExecForEach]
GO



/*
<summary>
This SP simplifies running dynamic SQL statements against all of 
the test tables (as defined in TestDefinition).  The statement 
passed into it will be executed once per test table.
</summary>
<param name="sql">
The statement to execute once per test table.  The statement can contain 
any column from TestDefinition table. Prefixed by a '@'.  
</param>
<example>
// Selects all tests from every test table
TestDefinitionData.ExecForEach( "select * from @tableName" )
</example>
<returns>One result set per test definition</returns>
<model isGenerated="false" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE dbo.TestDefinition_ExecForEach
	@sql varchar(8000),
	@expectedRowCount int = null
AS
	set nocount on

	declare @replacedSql varchar(8000)
	declare @id uniqueidentifier
	declare @tableName nvarchar(128)

	-- OPTIMIZATION: Only scan tables that have an one or more administrations
	declare cr_testDef cursor for
	select ID, TableName
	from TestDefinition def
	where def.ID in (select TestDefinitionID from TestAdministration)

	open cr_testDef

	fetch next from cr_testDef
	into @id, @tableName

	declare @count int
	set @count = 0

	-- Execute @sql for each test
	while @@FETCH_STATUS = 0
	begin
		set @replacedSql = replace(@sql, '@id', 'CAST(''' + cast(@id as varchar(36)) + ''' AS UNIQUEIDENTIFIER)' )
		set @replacedSql = replace(@replacedSql, '@tableName', @tableName )

		exec( @replacedSql )
		set @count = @count + @@ROWCOUNT

		if @expectedRowCount is not null
			if @count >= @expectedRowCount
				goto Done

		fetch next from cr_testDef
		into @id, @tableName
	end

Done:
	close cr_testDef
	deallocate cr_testDef

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

