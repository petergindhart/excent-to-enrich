IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[Test_GetRecordsByAdministrationAndStudents]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[Test_GetRecordsByAdministrationAndStudents]
GO

CREATE PROCEDURE [dbo].[Test_GetRecordsByAdministrationAndStudents]
	@ids UNIQUEIDENTIFIERARRAY,
	@testAdministrationID uniqueidentifier
AS
	DECLARE @sql VARCHAR(8000)

	

	SELECT
		@sql = ' select StudentID, T.*, cast( '''+ cast(def.Id as varchar(36)) + ''' as uniqueidentifier) AS TestDefinitionID' +
		' from ' + TableName + ' T join 
		Student stu on stu.ID = T.StudentID join	' +
		 ' GetUniqueIdentifiers(''' + cast(@ids as varchar(8000) )  + ''') keys on keys.id = T.StudentID AND T.AdministrationID = ''' + cast(@testAdministrationID as varchar(36)) + '''
		order by
			LastName asc, FirstName asc'
	From 
		TestDefinition def join
		TestAdministration ta on ta.TestDefinitionID = def.ID
	WHERE
		ta.ID = @testAdministrationID

	exec(@sql)