SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[TestSectionDefinition_GetRecordsByTestDefinitionID]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[TestSectionDefinition_GetRecordsByTestDefinitionID]
GO


/*
<summary>
Gets records from the TestSectionDefinition table for the specified TestDefinitionIDs 
</summary>
<param name="ids">Ids of the TestDefinition's </param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
Create  PROCEDURE dbo.TestSectionDefinition_GetRecordsByTestDefinitionID 
	@ids uniqueidentifierarray
AS
	SELECT t.TestDefinitionID, t.*
	FROM
		TestSectionDefinition t INNER JOIN
		GetIds(@ids) AS Keys ON t.TestDefinitionID = Keys.Id
	WHERE t.Parent is null
	ORDER BY t.Sequence

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

