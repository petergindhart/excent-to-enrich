if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Report_GetRecordsByOwner]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Report_GetRecordsByOwner]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


/*
<summary>
Gets records from the Report table with the specified ids
</summary>
<param name="ids">Ids of the UserProfile(s) to retrieve</param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE dbo.Report_GetRecordsByOwner
	@ids	uniqueidentifierarray
AS
	SELECT 
		r.Owner, 
		r.*
	FROM
		ReportView r INNER JOIN
		GetUniqueidentifiers(@ids) AS Keys ON r.Owner = Keys.Id

GO
