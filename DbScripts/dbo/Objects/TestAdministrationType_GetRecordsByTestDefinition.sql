/****** Object:  StoredProcedure [dbo].[TestAdministrationType_GetRecordsByTestDefinition]    Script Date: 11/06/2008 13:38:36 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[TestAdministrationType_GetRecordsByTestDefinition]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[TestAdministrationType_GetRecordsByTestDefinition]
GO

 /*
<summary>
Gets records from the TestAdministrationType table
with the specified ids
</summary>
<param name="ids">Ids of the TestDefinition(s) to retrieve</param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="FALSE" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[TestAdministrationType_GetRecordsByTestDefinition]
	@ids	uniqueidentifierarray
AS
	SELECT
		t.TestDefinitionId,
		t.*
	FROM
		TestAdministrationType t INNER JOIN
		GetUniqueidentifiers(@ids) Keys ON t.TestDefinitionId = Keys.Id
	ORDER BY
		Sequence asc