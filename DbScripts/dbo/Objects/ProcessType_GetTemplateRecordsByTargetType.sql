if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ProcessType_GetTemplateRecordsByTargetType]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[ProcessType_GetTemplateRecordsByTargetType]
GO

/*
<summary>
Gets records from the ProcessType table with the specified ids
</summary>
<param name="ids">Ids of the ProcessTargetType(s) to retrieve</param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE dbo.ProcessType_GetTemplateRecordsByTargetType
	@ids	uniqueidentifierarray
AS
	SELECT p.TargetTypeId, p.*
	FROM
		ProcessType p INNER JOIN
		GetUniqueidentifiers(@ids) AS Keys ON p.TargetTypeId = Keys.Id
	WHERE IsTemplate = 1

GO