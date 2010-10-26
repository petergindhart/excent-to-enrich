IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[TestDefinitionViewScore_GetRecordsByView]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[TestDefinitionViewScore_GetRecordsByView]
GO

 /*
<summary>
Gets records from the TestDefinitionViewScore table
with the specified ids
</summary>
<param name="ids">Ids of the TestDefinitionView(s) to retrieve</param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[TestDefinitionViewScore_GetRecordsByView]
	@ids	uniqueidentifierarray
AS
	SELECT
		t.ViewId,
		t.*
	FROM
		TestDefinitionViewScore t INNER JOIN
		GetUniqueidentifiers(@ids) Keys ON t.ViewId = Keys.Id
	ORDER BY
		Sequence