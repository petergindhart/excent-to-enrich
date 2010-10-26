IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[StudentRecordException_GetAllRecordsNotIgnored]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[StudentRecordException_GetAllRecordsNotIgnored]
GO

 /*
<summary>
Gets all records from the StudentRecordException table
</summary>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="false" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].StudentRecordException_GetAllRecordsNotIgnored
AS
	SELECT
		s.*
	FROM
		StudentRecordException s
	WHERE
		s.Ignore = 0
