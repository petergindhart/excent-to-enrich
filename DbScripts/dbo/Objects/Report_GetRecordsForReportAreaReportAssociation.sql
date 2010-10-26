if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Report_GetRecordsForReportAreaReportAssociation]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Report_GetRecordsForReportAreaReportAssociation]
GO

 /*
<summary>
Gets records from the Report table for the specified association 
</summary>
<param name="ids">Ids of the ReportArea(s) </param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[Report_GetRecordsForReportAreaReportAssociation]
	@ids uniqueidentifierarray
AS
	SELECT ab.ReportAreaId, a.*, 
		v.Description,
		v.Format,
		v.Path,
		v.Query,
		v.Title,
		v.Type
	FROM
		ReportAreaReport ab INNER JOIN
		GetUniqueidentifiers(@ids) AS Keys ON ab.ReportAreaId = Keys.Id INNER JOIN
		Report a ON ab.ReportId = a.Id JOIN
		VC3Reporting.Report v ON a.Id = v.Id