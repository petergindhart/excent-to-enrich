IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = OBJECT_ID(N'[dbo].[IndValue_GetRecordsByInstance]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[IndValue_GetRecordsByInstance]
GO

/*
<summary>
Gets records from the IndValue table
with the specified ids
</summary>
<param name="ids">Ids of the Instance(s) to retrieve</param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[IndValue_GetRecordsByInstance]
	@ids	uniqueidentifierarray
AS
	SELECT
		i.InstanceId,
		i.*
	FROM
		IndValue i INNER JOIN
		GetUniqueidentifiers(@ids) Keys ON i.InstanceId = Keys.Id