SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[TestImport_DuplicateTestImportCheck]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[TestImport_DuplicateTestImportCheck]
GO


/*
<summary>
Executes a Transact-SQL statement against TestImport Table 
for duplicate test import based on FileChecksum
</summary>
<param name="testDefinitionFamilyID">the test definition family to check</param>
<param name="fileCheckSum">file check sum to check</param>
<model returnType="System.Data.IDataReader"/>
*/
CREATE PROCEDURE dbo.TestImport_DuplicateTestImportCheck
	@testDefinitionFamilyID UNIQUEIDENTIFIER, @fileChecksum binary(20)
AS
	SELECT 
		i.* 
	FROM 
		TestImport i JOIN 
		TestImportHandler h on h.ID = i.HandlerID JOIN 
		TestImportHandlerTestDefinitionFamily hf on hf.HandlerID = h.ID  
	WHERE 
		FileChecksum =  @fileChecksum AND 
		hf.FamilyID = @testDefinitionFamilyID

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

