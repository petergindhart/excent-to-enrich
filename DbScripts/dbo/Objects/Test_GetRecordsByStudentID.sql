SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Test_GetRecordsByStudentID]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Test_GetRecordsByStudentID]
GO


/*
<summary>
Retrieves all tests for the given students.
</summary>
<param name="ids">Idenifies the students to retrieve the tests for</param>
<returns>Tests that the student has taken.  Returns 1 result set per test type.</returns>
<model isGenerated="false" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE dbo.Test_GetRecordsByStudentID 
	@ids UNIQUEIDENTIFIERARRAY
AS
	declare @sql varchar(8000)

	declare @idStr varchar(37) -- yes, 36+1 to detect more than 1 key
	set @idStr = cast(@ids as varchar(37))

	if len(@idStr) != 36
	begin
		SELECT ID
		INTO #keys
		FROM GetIds(@ids)
	
		SET @sql = ' select StudentID, T.*, @ID TestDefinitionID' +
			' from @tableName T join' +
			' #keys keys on keys.id = T.StudentID'
	end
	else
	begin
		SET @sql = ' select StudentID, T.*, @ID TestDefinitionID' +
			' from @tableName T' +
			' where T.StudentID = ''' + @idStr + ''''
	end

	EXEC TestDefinition_ExecForEach @sql
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO