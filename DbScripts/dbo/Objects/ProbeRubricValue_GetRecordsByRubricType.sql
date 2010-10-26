SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ProbeRubricValue_GetRecordsByRubricType]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[ProbeRubricValue_GetRecordsByRubricType]
GO

 /*
<summary>
Gets records from the ProbeRubricValue table
with the specified ids
</summary>
<param name="ids">Ids of the ProbeRubricType(s) to retrieve</param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[ProbeRubricValue_GetRecordsByRubricType]
	@ids	uniqueidentifierarray
AS
	SELECT
		p.TypeId,
		p.*
	FROM
		ProbeRubricValue p INNER JOIN
		GetUniqueidentifiers(@ids) Keys ON p.TypeId = Keys.Id
	ORDER BY p.Sequence, p.Name