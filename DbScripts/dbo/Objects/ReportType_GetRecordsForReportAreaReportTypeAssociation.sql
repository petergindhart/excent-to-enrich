SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ReportType_GetRecordsForReportAreaReportTypeAssociation]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[ReportType_GetRecordsForReportAreaReportTypeAssociation]
GO

 /*
<summary>
Gets records from the ReportType table for the specified association 
</summary>
<param name="ids">Ids of the ReportArea(s) </param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[ReportType_GetRecordsForReportAreaReportTypeAssociation]
	@ids uniqueidentifierarray
AS
	SELECT ab.ReportAreaId, a.*,
		v.Description,
		v.IsEditable,
		v.Name,
		v.PrimaryTable
	FROM
		ReportAreaReportType ab INNER JOIN
		GetUniqueidentifiers(@ids) AS Keys ON ab.ReportAreaId = Keys.Id INNER JOIN
		ReportType a ON ab.ReportTypeId = a.Id INNER JOIN
		VC3Reporting.ReportTypeView v ON v.Id = a.Id