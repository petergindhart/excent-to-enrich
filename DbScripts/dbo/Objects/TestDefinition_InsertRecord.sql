SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[TestDefinition_InsertRecord]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[TestDefinition_InsertRecord]
GO


/*
<summary>
Inserts a new record into the TestDefinition table with the specified values
</summary>
<param name="name">Value to assign to the Name field of the record</param>
<param name="tableName">Value to assign to the TableName field of the record</param>
<param name="reportTableId">Value to assign to the ReportTableID field of the record</param>
<param name="familyId">Value to assign to the FamilyID field of the record</param>
<returns>The identifiers for the inserted record</returns>
<model isGenerated="False" returnType="System.Void" />
*/
CREATE PROCEDURE dbo.TestDefinition_InsertRecord 
	@id as uniqueidentifier,
	@name varchar(50),
	@tableName varchar(128),
	@reportTableId uniqueidentifier,
	@familyId uniqueidentifier
AS
INSERT INTO TestDefinition
	(
		ID,
		Name,
		TableName,
		ReportTableID,
		FamilyID
	)
	VALUES
	(

		@id,
		@name,
		@tableName,
		@reportTableId,
		@familyId
	)
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

