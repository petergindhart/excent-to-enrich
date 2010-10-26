IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[ImageExtractDatabase_GetRecordsByDataHandler]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[ImageExtractDatabase_GetRecordsByDataHandler]
GO

 /*
<summary>
Gets records from the ImageExtractDatabase table
with the specified ids
</summary>
<param name="ids">Ids of the ImageDataHandler(s) to retrieve</param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[ImageExtractDatabase_GetRecordsByDataHandler]
	@ids	uniqueidentifierarray
AS
	SELECT
		p1.*,
		i.DataHandler		
	FROM
		ImageExtractDatabase i INNER JOIN	
		VC3ETL.ExtractDatabase p1 ON i.ID = p1.ID INNER JOIN
		GetUniqueidentifiers(@ids) Keys ON i.DataHandler = Keys.Id