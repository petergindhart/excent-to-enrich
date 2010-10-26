if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Report_GetRecordsForReportUserRecipientAssociation]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Report_GetRecordsForReportUserRecipientAssociation]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/*
<summary>
Gets records from the Report table for the specified association 
</summary>
<param name="ids">Ids of the UserProfile(s) </param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE dbo.Report_GetRecordsForReportUserRecipientAssociation
	@ids uniqueidentifierarray
AS
	SELECT
		f.UserProfileId,
		r.*
	FROM
		ReportUserRecipient f INNER JOIN
		GetUniqueidentifiers(@ids) AS Keys ON f.UserProfileId = Keys.Id INNER JOIN
		ReportView r ON f.ReportId = r.ID
	ORDER BY
		r.Title
GO