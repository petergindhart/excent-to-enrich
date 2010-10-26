if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[TestSectionDefinition_InsertRecord]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[TestSectionDefinition_InsertRecord]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

 /*
<summary>
Inserts a new record into the TestSectionDefinition table with the specified values
</summary>
<param name="testDefinitionId">Value to assign to the TestDefinitionID field of the record</param>
<param name="parent">Value to assign to the Parent field of the record</param>
<param name="subjectId">Value to assign to the SubjectID field of the record</param>
<param name="sequence">Value to assign to the Sequence field of the record</param>
<param name="name">Value to assign to the Name field of the record</param>
<returns>The identifiers for the inserted record</returns>
<model returnType="System.Guid" />
*/
CREATE PROCEDURE dbo.TestSectionDefinition_InsertRecord
	@testDefinitionId uniqueidentifier, 
	@parent uniqueidentifier, 
	@subjectId uniqueidentifier, 
	@sequence int, 
	@name varchar(50), 
	@id uniqueidentifier
AS
	IF(@id is null) BEGIN
		SET @id = newid()
	END
	INSERT INTO TestSectionDefinition
	(
		Id, 
		TestDefinitionId, 
		Parent, 
		SubjectId, 
		Sequence, 
		Name
	)
	VALUES
	(
		@id, 
		@testDefinitionId, 
		@parent, 
		@subjectId, 
		@sequence, 
		@name
	)

	SELECT @id
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

