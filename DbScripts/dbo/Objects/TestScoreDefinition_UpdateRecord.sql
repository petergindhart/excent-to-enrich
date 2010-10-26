/****** Object:  StoredProcedure [dbo].[TestScoreDefinition_UpdateRecord]    Script Date: 09/02/2009 14:24:16 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[TestScoreDefinition_UpdateRecord]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[TestScoreDefinition_UpdateRecord]
GO

 /*
<summary>
Updates a record in the TestScoreDefinition table with the specified values
</summary>
<param name="id">Value to assign to the ID field of the record</param>
<param name="testSectionDefinitionId">Value to assign to the TestSectionDefinitionID field of the record</param>
<param name="resultReportColumnId">Value to assign to the ResultReportColumnID field of the record</param>
<param name="dataTypeId">Value to assign to the DataTypeID field of the record</param>
<param name="importanceId">Value to assign to the ImportanceID field of the record</param>
<param name="sequence">Value to assign to the Sequence field of the record</param>
<param name="columnName">Value to assign to the ColumnName field of the record</param>
<param name="name">Value to assign to the Name field of the record</param>
<param name="minValue">Value to assign to the MinValue field of the record</param>
<param name="maxValue">Value to assign to the MaxValue field of the record</param>
<param name="enumType">Value to assign to the EnumType field of the record</param>
<param name="categorizationInterval">Value to assign to the CategorizationInterval field of the record</param>

<model isGenerated="False" returnType="System.Void" />
*/
CREATE PROCEDURE [dbo].[TestScoreDefinition_UpdateRecord]
	@id uniqueidentifier, 
	@testSectionDefinitionId uniqueidentifier, 
	@resultReportColumnId uniqueidentifier, 
	@dataTypeId uniqueidentifier, 
	@importanceId int, 
	@sequence int, 
	@columnName varchar(128), 
	@name varchar(50), 
	@minValue float, 
	@maxValue float, 
	@enumType uniqueidentifier, 
	@categorizationInterval int = null
AS
	UPDATE TestScoreDefinition
	SET
		TestSectionDefinitionID = @testSectionDefinitionId, 
		ResultReportColumnID = @resultReportColumnId, 
		DataTypeID = @dataTypeId, 
		ImportanceID = @importanceId, 
		Sequence = @sequence, 
		ColumnName = @columnName, 
		Name = @name, 
		MinValue = @minValue, 
		MaxValue = @maxValue, 
		EnumType = @enumType, 
		CategorizationInterval = @categorizationInterval
	WHERE 
		ID = @id