if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Report_GetRecords]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Report_GetRecords]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


/*
<summary>
Gets records from the Report table with the specified id's
</summary>
<param name="ids">Ids of the records to retrieve</param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE dbo.Report_GetRecords
	@ids	uniqueidentifierarray
AS
	SELECT
		r.*
	FROM
		ReportView r INNER JOIN
		GetUniqueidentifiers(@ids) AS Keys ON r.Id = Keys.Id

GO
