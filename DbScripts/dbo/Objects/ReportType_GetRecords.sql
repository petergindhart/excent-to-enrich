SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ReportType_GetRecords]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[ReportType_GetRecords]
GO

 /*
<summary>
Gets records from the ReportType table with the specified id's
</summary>
<param name="ids">Ids of the records to retrieve</param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE dbo.ReportType_GetRecords 
	@ids char1array
AS
	SELECT r.*
	FROM
		ReportTypeView r INNER JOIN
		GetChar1s(@ids) AS Keys ON r.Id = Keys.Id
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

