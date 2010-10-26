if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ReportSchemaColumn_GetRecords]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[ReportSchemaColumn_GetRecords]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/*
<summary>
Gets records from the ReportSchemaColumn table with the specified id's
</summary>
<param name="ids">Ids of the records to retrieve</param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE dbo.ReportSchemaColumn_GetRecords 
	@ids uniqueidentifierarray
AS
	SELECT 
		v.*,
		r.ViewTaskID
	FROM
		ReportSchemaColumn r INNER JOIN
		VC3Reporting.ReportSchemaColumn v on v.Id = r.Id INNER JOIN
		GetUniqueidentifiers(@ids) AS Keys ON r.Id = Keys.Id
	ORDER BY Sequence

GO