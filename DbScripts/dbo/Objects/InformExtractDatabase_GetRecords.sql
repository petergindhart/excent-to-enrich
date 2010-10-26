IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[InformExtractDatabase_GetRecords]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[InformExtractDatabase_GetRecords]
GO

/*
<summary>
Gets records from the InformExtractDatabase table
with the specified id's
</summary>
<param name="ids">Ids of the records to retrieve</param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="false" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[InformExtractDatabase_GetRecords]
	@ids	uniqueidentifierarray
AS
	SELECT	
		ed.*,
		ffed.LocalCopyPath,
		i.lastExtractRosterYear,
		i.lastLoadRosterYear		
	FROM
		InformExtractDatabase i INNER JOIN
		VC3ETL.FlatFileExtractDatabase ffed on ffed.ID = i.ID JOIN
		VC3ETL.ExtractDatabase ed ON i.ID = ed.ID INNER JOIN
		GetUniqueidentifiers(@ids) Keys ON i.Id = Keys.Id


