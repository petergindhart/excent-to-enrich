if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[TestImportHandler_GetRecordsByFamily]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[TestImportHandler_GetRecordsByFamily]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS OFF 
GO

 /*
<summary>
Gets records from the TestImportHandler table that handle the
tests belonging to a specific family with the specified familyId
</summary>
<param name="familyId">Id the TestDefinitionFamily</param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE dbo.TestImportHandler_GetRecordsByFamily
	@familyId uniqueidentifier
AS

SELECT 
	* 
FROM
	TestImportHandler
WHERE 
	ID
IN
	(
	SELECT 
		TestImportHandlerID
	FROM 
		TestImportHandlerTestDefinition HandlerDef 
	JOIN 
		TestDefinition Def
	ON
		HandlerDef.TestDefinitionID = Def.ID
	WHERE 
		Def.FamilyID = @familyId
	)

ORDER BY TestImportHandler.Name ASC

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

