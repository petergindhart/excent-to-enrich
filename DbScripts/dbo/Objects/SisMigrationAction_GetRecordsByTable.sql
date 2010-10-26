IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[SisMigrationAction_GetRecordsByTable]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[SisMigrationAction_GetRecordsByTable]
GO

 /*
<summary>
Gets records from the SisMigrationAction table
with the specified ids
</summary>
<param name="ids">Ids of the SisMigrationTable(s) to retrieve</param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="false" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[SisMigrationAction_GetRecordsByTable]
	@ids	uniqueidentifierarray
AS
	SELECT
		s.MigrationTableId,
		s.*
	FROM
		SisMigrationAction s INNER JOIN
		GetUniqueidentifiers(@ids) Keys ON s.MigrationTableId = Keys.Id
	ORDER BY
		s.Sequence asc