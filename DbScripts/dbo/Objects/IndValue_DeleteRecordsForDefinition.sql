if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[IndValue_DeleteRecordsForDefinition]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[IndValue_DeleteRecordsForDefinition]
GO


/*
<summary>
Deletes records from the IndValue table for the given ids
</summary>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[IndValue_DeleteRecordsForDefinition]
	@definitionId uniqueidentifier
AS
	DELETE FROM 
		IndValue 
	WHERE 
		DefinitionID = @definitionId 

GO
