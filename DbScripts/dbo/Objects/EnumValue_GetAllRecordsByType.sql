if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[EnumValue_GetAllRecordsByType]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[EnumValue_GetAllRecordsByType]
GO

 /*
<summary>
Gets all records from the EnumValue table with the specified ids
</summary>
<param name="ids">Ids of the EnumType(s) to retrieve</param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE dbo.EnumValue_GetAllRecordsByType
	@ids	uniqueidentifierarray
AS
	SELECT e.Type, e.*
	FROM
		EnumValue e INNER JOIN
		GetUniqueidentifiers(@ids) AS Keys ON e.Type = Keys.Id
	ORDER BY
		e.Sequence, e.Code

GO
