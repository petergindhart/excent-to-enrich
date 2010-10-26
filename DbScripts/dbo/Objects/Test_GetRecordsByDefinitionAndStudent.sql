IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[Test_GetRecordsByDefinitionAndStudent]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[Test_GetRecordsByDefinitionAndStudent]
GO

 /*
<summary>
Gets all Tests for a particular student and test definition.
</summary>
<param name="studentID">The student to return tests for.</param>
<param name="studentID">The test definition to return tests for.</param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[Test_GetRecordsByDefinitionAndStudent] 	
	@testDefId uniqueidentifier,
	@studentId uniqueidentifier
AS	
	
	DECLARE @sql VARCHAR(8000)
 
	SELECT
		@sql = '
			select 
				T.*, cast(''' + cast( @testDefId as varchar(36)) +  ''' as uniqueidentifier) AS TestDefinitionID
			from ' + TableName + ' T 
			WHERE StudentID = ''' + Cast(@studentId as varchar(36)) + '''
			ORder by
				DateTaken Desc'
	From 
		TestDefinition def join
		TestAdministration ta on ta.TestDefinitionID = def.ID
	WHERE
		def.ID = @testDefId

	exec(@sql)	