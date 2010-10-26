if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[TestImportHandler_GetRecordsForTestImportHandlerTestDefinitionFamilyAssociation]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[TestImportHandler_GetRecordsForTestImportHandlerTestDefinitionFamilyAssociation]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

 /*
<summary>
Gets records from the TestImportHandler table for the specified association 
</summary>
<param name="ids">Ids of the TestDefinitionFamily(s) </param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE dbo.TestImportHandler_GetRecordsForTestImportHandlerTestDefinitionFamilyAssociation
	@ids uniqueidentifierarray
AS
	SELECT ab.FamilyId, a.*
	FROM
		TestImportHandlerTestDefinitionFamily ab INNER JOIN
		GetUniqueidentifiers(@ids) AS Keys ON ab.FamilyId = Keys.Id INNER JOIN
		TestImportHandler a ON ab.HandlerId = a.Id
ORDER BY
	a.Name DESC
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

