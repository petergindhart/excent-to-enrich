if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[IndValue_DeleteRecordsForType]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[IndValue_DeleteRecordsForType]
GO

/*
<summary>
Deletes records from the IndValue table for the given ids
</summary>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[IndValue_DeleteRecordsForType]
	@typeId uniqueidentifier
AS
	DELETE FROM 
		IndValue 
	WHERE 
		DefinitionID IN 
			(SELECT ID FROM IndDefinition WHERE TypeID = @typeId) 

GO
