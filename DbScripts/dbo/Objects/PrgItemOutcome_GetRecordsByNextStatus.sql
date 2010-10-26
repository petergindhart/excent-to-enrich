if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PrgItemOutcome_GetRecordsByNextStatus]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[PrgItemOutcome_GetRecordsByNextStatus]
GO

/*
<summary>
Gets records from the PrgItemOutcome table
with the specified ids
</summary>
<param name="ids">Ids of the PrgStatus(s) to retrieve</param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[PrgItemOutcome_GetRecordsByNextStatus]
	@ids	uniqueidentifierarray
AS
	SELECT
		p.NextStatusId,
		p.*
	FROM
		PrgItemOutcome p INNER JOIN
		GetUniqueidentifiers(@ids) Keys ON p.NextStatusId = Keys.Id
	WHERE 
		DeletedDate IS NULL
	ORDER BY 
		p.Sequence