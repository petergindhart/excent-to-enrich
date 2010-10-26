/****** Object:  StoredProcedure [dbo].[SisMigrationTable_GetRecordsBySisMigration]    Script Date: 08/18/2009 13:58:50 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[SisMigrationTable_GetRecordsBySisMigration]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[SisMigrationTable_GetRecordsBySisMigration]
GO

 /*
<summary>
Gets records from the SisMigrationTable table
with the specified ids
</summary>
<param name="ids">Ids of the SisMigration(s) to retrieve</param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[SisMigrationTable_GetRecordsBySisMigration]
	@ids	uniqueidentifierarray
AS
	SELECT
		s.SisMigrationId,
		s.*
	FROM
		SisMigrationTable s INNER JOIN
		GetUniqueidentifiers(@ids) Keys ON s.SisMigrationId = Keys.Id
	ORDER BY
		s.Sequence asc