
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[TestDefinitionFamily_InsertRecord]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[TestDefinitionFamily_InsertRecord]
GO
 /*
<summary>
Inserts a new record into the TestDefinitionFamily table with the specified values
</summary>
<param name="name">Value to assign to the Name field of the record</param>
<param name="status">Value to assign to the Status field of the record</param>
<param name="helpText">Value to assign to the HelpText field of the record</param>
<param name="importUploadText">Value to assign to the ImportUploadText field of the record</param>
<param name="serviceUserName">Value to assign to the ServiceUserName field of the record</param>
<param name="servicePassword">Value to assign to the ServicePassword field of the record</param>
<param name="serviceTypeName">Value to assign to the ServiceTypeName field of the record</param>
<returns>The identifiers for the inserted record</returns>
<model isGenerated="False" returnType="System.Void" />
*/
CREATE PROCEDURE [dbo].[TestDefinitionFamily_InsertRecord]	
	@id uniqueidentifier,
	@name varchar(20), 
	@status char(1), 
	@helpText text, 
	@importUploadText text, 
	@serviceUserName varchar(100) = NULL, 
	@servicePassword varchar(100) = NULL, 
	@serviceTypeName varchar(500) = NULL
AS

	INSERT INTO TestDefinitionFamily
	(
		Id, 
		Name, 
		Status, 
		HelpText, 
		ImportUploadText, 
		ServiceUserName, 
		ServicePassword, 
		ServiceTypeName
	)
	VALUES
	(
		@id, 
		@name, 
		@status, 
		@helpText, 
		@importUploadText, 
		@serviceUserName, 
		@servicePassword, 
		@serviceTypeName
	)