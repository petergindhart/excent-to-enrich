IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[StudentRecordException_GetRecordsByStudent]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[StudentRecordException_GetRecordsByStudent]
GO

/*
<summary>
Gets records from the StudentRecordException table
with the specified id
</summary>
<param name="ids">Id of the Student to retrieve</param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE dbo.StudentRecordException_GetRecordsByStudent
	@ids	uniqueidentifierarray
AS
	SELECT	
		s.ID,
		s.*
	FROM
		StudentRecordException s INNER JOIN
		GetUniqueidentifiers(@ids) Keys ON s.Student1Id = Keys.Id OR s.Student2Id = Keys.Id
GO