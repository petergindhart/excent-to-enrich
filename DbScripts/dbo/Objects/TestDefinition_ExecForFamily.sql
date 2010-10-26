SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (
	select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[TestDefinition_ExecForFamily]') and OBJECTPROPERTY(id, N'IsProcedure') = 1
)
	drop procedure [dbo].[TestDefinition_ExecForFamily]
GO

/*
<summary>
This SP simplifies running dynamic SQL statements against all of 
the test tables that belong to the given TestDefinitionFamily. 
The statement passed into it will be executed once per test table
in the given TestDefinitionFamily.
</summary>
<param name="FamilyID">
The uniqueidentifier of the TestDefinitionFamily
</param>
<param name="sql">
The statement to execute once per test table in the given 
TestDefinitionFamily.  The statement can contain any column from 
TestDefinition table. Prefixed by a '@'.  
</param>
<example>
Selects top 10 tests from every test table in for the test definition
family that has ID=''
TestDefinitionData.ExecForFamily
(
	"80F4B336-067D-4186-A88F-EE35741B177B", 
	"select TOP 10 * from @tableName"
)
</example>
<returns>One result set per test definition</returns>
<model isGenerated="false" returnType="System.Data.IDataReader" />
*/

CREATE PROCEDURE dbo.TestDefinition_ExecForFamily
	@FamilyID uniqueidentifier, 
	@sql varchar(1024)
AS

	set nocount on
	declare @replacedSql varchar(1024)
	declare @id uniqueidentifier
	declare @tableName nvarchar(128)

	declare cr_testDef cursor for
	select ID, TableName
	from TestDefinition	
	where FamilyID = @FamilyID
	open cr_testDef

	fetch next from cr_testDef
	into @id, @tableName


	-- Execute @sql for each test
	while @@FETCH_STATUS = 0
	begin
		set @replacedSql = replace(@sql, '@id', 'CAST(''' + cast(@id as varchar(36)) + ''' AS UNIQUEIDENTIFIER)' )
		set @replacedSql = replace(@replacedSql, '@tableName', @tableName )

		exec( @replacedSql )

		fetch next from cr_testDef
		into @id, @tableName
	end

	close cr_testDef
	deallocate cr_testDef

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO