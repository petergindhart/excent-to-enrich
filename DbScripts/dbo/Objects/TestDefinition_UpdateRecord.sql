IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[TestDefinition_UpdateRecord]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[TestDefinition_UpdateRecord]
GO

 /*
<summary>
Updates a record in the TestDefinition table with the specified values
</summary>
<param name="id">Value to assign to the ID field of the record</param>
<param name="familyId">Value to assign to the FamilyID field of the record</param>
<param name="name">Value to assign to the Name field of the record</param>
<param name="tableName">Value to assign to the TableName field of the record</param>
<param name="reportTableId">Value to assign to the ReportTableID field of the record</param>
<param name="scoreCalculatorClassName">Value to assign to the ScoreCalculatorClassName field of the record</param>
<model isGenerated="False" returnType="System.Void" />
*/
CREATE PROCEDURE [dbo].[TestDefinition_UpdateRecord]
	@id uniqueidentifier, 
	@familyId uniqueidentifier, 
	@name varchar(50), 
	@tableName varchar(128), 
	@reportTableId uniqueidentifier	
AS
	UPDATE TestDefinition
	SET
		FamilyID = @familyId, 
		Name = @name, 
		TableName = @tableName, 
		ReportTableID = @reportTableId		
	WHERE 
		ID = @id