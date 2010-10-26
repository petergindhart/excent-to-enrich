if exists (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[ReportArea_GetAllRecords]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[ReportArea_GetAllRecords]
GO

 /*
<summary>
Gets all records from the ReportArea table
</summary>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[ReportArea_GetAllRecords]
AS
	SELECT
		r.*
	FROM
		ReportArea r
	ORDER BY Name