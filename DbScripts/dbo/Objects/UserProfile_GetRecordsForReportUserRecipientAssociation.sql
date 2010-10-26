if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[UserProfile_GetRecordsForReportUserRecipientAssociation]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[UserProfile_GetRecordsForReportUserRecipientAssociation]
GO

 /*
<summary>
Gets records from the UserProfile table for the specified association 
</summary>
<param name="ids">Ids of the Report(s) </param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE dbo.UserProfile_GetRecordsForReportUserRecipientAssociation
	@ids uniqueidentifierarray
AS
	SELECT ab.ReportId, a.*
	FROM
		ReportUserRecipient ab INNER JOIN
		GetUniqueidentifiers(@ids) AS Keys ON ab.ReportId = Keys.Id INNER JOIN
		UserProfileView a ON ab.UserProfileId = a.Id