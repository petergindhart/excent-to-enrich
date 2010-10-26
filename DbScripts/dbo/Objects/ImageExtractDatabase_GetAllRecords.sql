IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[ImageExtractDatabase_GetAllRecords]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[ImageExtractDatabase_GetAllRecords]
GO

 /*
<summary>
Gets all records from the ImageExtractDatabase table
</summary>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[ImageExtractDatabase_GetAllRecords]
AS
	SELECT
		p1.*,		
		i.DataHandler
	FROM
		ImageExtractDatabase i INNER JOIN
		VC3ETL.ExtractDatabase p1 ON i.ID = p1.ID