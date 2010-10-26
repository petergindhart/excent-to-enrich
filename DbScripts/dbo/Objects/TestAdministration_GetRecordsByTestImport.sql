IF EXISTS (SELECT name 
	   FROM   sysobjects 
	   WHERE  name = N'TestAdministration_GetRecordsByTestImport ' 
	   AND 	  type = 'P')
    DROP PROCEDURE dbo.TestAdministration_GetRecordsByTestImport
GO

/*
<summary>
Get all the records in TestDefinitionFamily table having the same family status. 
</summary>
<param name="testImports">The ID of the test import</param>
<model returnType="System.Data.IDataReader"/>
*/

CREATE PROCEDURE dbo.TestAdministration_GetRecordsByTestImport 
	@testImport uniqueidentifier
AS

	
	declare @family uniqueidentifier
	declare @testId uniqueidentifier
	declare @testTable varchar(128)
	declare @sql varchar(8000)

	select @family = fam.id 
		from 
			testDefinitionFamily fam join
			TestImportHandlerTestDefinitionFamily x on fam.id = x.familyid join
			TestImporthandler y on x.handlerid = y.id join
			testImport import on import.handlerid = y.id
		where
			import.id = @testImport
		 	

	declare test cursor for (
		SELECT def.TableName, def.id
		FROM 
			testdefinition def join 
			testdefinitionFamily fam on def.familyid = fam.id
		WHERE
			fam.id = @family
		)

	
	set @sql='declare @adminIds table(id uniqueidentifier)

	'
	open test
	fetch next from test into @testTable, @testId
	WHILE @@fetch_status = 0
	BEGIN
		set @sql= @sql+'insert @adminids (id) select distinct administrationid from '+@testTable+' where importid = '''+cast(@testImport as varchar(36))+'''
	'
		fetch next from test into @testTable, @testId
	END
	close test
	deallocate test

	set @sql=@sql + '
select * from testAdministration where id in (select * from @adminIds)'

	exec(@sql)
GO
