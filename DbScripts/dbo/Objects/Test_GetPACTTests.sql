SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Test_GetPACTTests]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Test_GetPACTTests]
GO

/*
<summary>
Gets all Action Categories
</summary>
<param name="studentID">The student to return tests for.</param>
<param name="startDate">The start date for the search, typically the start date of the current roster year.</param>
<param name="endDate">The end date for the search, typically the start date of the roster year three years ago</param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE dbo.Test_GetPACTTests 
	@studentID uniqueidentifier 
AS

select T_PACT.*, TestDefinition.[ID] As TestDefinitionID FROM T_PACT, TestDefinition WHERE TestDefinition.[ID] IN (SELECT TestDefinition.[ID] WHERE TableName = 'T_PACT') AND T_PACT.StudentId = @studentID 

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

