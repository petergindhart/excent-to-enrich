if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[TestScoreDefinition_InsertRecord]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[TestScoreDefinition_InsertRecord]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

 /*
<summary>
Inserts a new record into the TestScoreDefinition table with the specified values
</summary>
<param name="testSectionDefinitionId">Value to assign to the TestSectionDefinitionID field of the record</param>
<param name="resultReportColumnId">Value to assign to the ResultReportColumnID field of the record</param>
<param name="dataTypeId">Value to assign to the DataTypeID field of the record</param>
<param name="sequence">Value to assign to the Sequence field of the record</param>
<param name="columnName">Value to assign to the ColumnName field of the record</param>
<param name="name">Value to assign to the Name field of the record</param>
<param name="minValue">Value to assign to the MinValue field of the record</param>
<param name="maxValue">Value to assign to the MaxValue field of the record</param>
<param name="enumType">Value to assign to the EnumType field of the record</param>
<param name="importance">Value to assign to the Importance field of the record</param>
<returns>The identifiers for the inserted record</returns>
<model returnType="System.Guid" />
*/
CREATE PROCEDURE dbo.TestScoreDefinition_InsertRecord
	@testSectionDefinitionId uniqueidentifier, 
	@resultReportColumnId uniqueidentifier, 
	@dataTypeId uniqueidentifier, 
	@sequence int, 
	@columnName varchar(128), 
	@name varchar(50), 
	@minValue float, 
	@maxValue float, 
	@enumType uniqueidentifier, 
	@importanceId int,
	@id uniqueidentifier
AS
	
	INSERT INTO TestScoreDefinition
	(
		Id, 
		TestSectionDefinitionId, 
		ResultReportColumnId, 
		DataTypeId, 
		Sequence, 
		ColumnName, 
		Name, 
		MinValue, 
		MaxValue, 
		EnumType, 
		ImportanceID
	)
	VALUES
	(
		@id, 
		@testSectionDefinitionId, 
		@resultReportColumnId, 
		@dataTypeId, 
		@sequence, 
		@columnName, 
		@name, 
		@minValue, 
		@maxValue, 
		@enumType, 
		@importanceId
	)

	SELECT @id
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

