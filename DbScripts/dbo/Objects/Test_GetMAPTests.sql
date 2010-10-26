SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Test_GetMAPTests]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Test_GetMAPTests]
GO

/*
<summary>
Gets all MAP Tests for a particular student.
</summary>
<param name="studentID">The student to return tests for.</param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE dbo.Test_GetMAPTests 
	@studentID uniqueidentifier 
AS
/*
DECLARE @studentID uniqueidentifier
SELECT @studentID = '40E5A008-351C-4E20-92C9-7211C94B50FC'
*/
select T_MAP_2.*, TestDefinition.[ID] As TestDefinitionID FROM T_MAP_2, TestDefinition WHERE TestDefinition.[ID] IN (SELECT TestDefinition.[ID] WHERE TableName = 'T_MAP_2') AND T_MAP_2.StudentId = @studentID 
select T_MAP_3.*, TestDefinition.[ID] As TestDefinitionID FROM T_MAP_3, TestDefinition WHERE TestDefinition.[ID] IN (SELECT TestDefinition.[ID] WHERE TableName = 'T_MAP_3') AND T_MAP_3.StudentId = @studentID 
select T_MAP_4.*, TestDefinition.[ID] As TestDefinitionID FROM T_MAP_4, TestDefinition WHERE TestDefinition.[ID] IN (SELECT TestDefinition.[ID] WHERE TableName = 'T_MAP_4') AND T_MAP_4.StudentId = @studentID 
select T_MAP_5.*, TestDefinition.[ID] As TestDefinitionID FROM T_MAP_5, TestDefinition WHERE TestDefinition.[ID] IN (SELECT TestDefinition.[ID] WHERE TableName = 'T_MAP_5') AND T_MAP_5.StudentId = @studentID 
select T_MAP_6.*, TestDefinition.[ID] As TestDefinitionID FROM T_MAP_6, TestDefinition WHERE TestDefinition.[ID] IN (SELECT TestDefinition.[ID] WHERE TableName = 'T_MAP_6') AND T_MAP_6.StudentId = @studentID 
select T_MAP_7.*, TestDefinition.[ID] As TestDefinitionID FROM T_MAP_7, TestDefinition WHERE TestDefinition.[ID] IN (SELECT TestDefinition.[ID] WHERE TableName = 'T_MAP_7') AND T_MAP_7.StudentId = @studentID 
select T_MAP_8.*, TestDefinition.[ID] As TestDefinitionID FROM T_MAP_8, TestDefinition WHERE TestDefinition.[ID] IN (SELECT TestDefinition.[ID] WHERE TableName = 'T_MAP_8') AND T_MAP_8.StudentId = @studentID 
select T_MAP_9.*, TestDefinition.[ID] As TestDefinitionID FROM T_MAP_9, TestDefinition WHERE TestDefinition.[ID] IN (SELECT TestDefinition.[ID] WHERE TableName = 'T_MAP_9') AND T_MAP_9.StudentId = @studentID 

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

