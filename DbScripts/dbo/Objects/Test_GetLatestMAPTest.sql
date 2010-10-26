SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Test_GetLatestMAPTest]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Test_GetLatestMAPTest]
GO

/*
<summary>
Retrieves the latest MAP Test(s) for a student based on the Current Roster Year.
</summary>
<param name="studentID">The student to return tests for.</param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE dbo.Test_GetLatestMAPTest
	@studentID uniqueidentifier 
AS

/*
NOTE:
This SP has doesn't work correctly and needs to be fixed so I'm commenting it
all out.  the @studentID is not even used!?.  Also a date should be passed in
to support viewing historical plans. It shoud also be modified to use
dbo.DateInRAnge for date comparisons.

select Test.* FROM (
			SELECT T_MAP_2.*, TestDefinition.[ID] As TestDefinitionID 
				FROM T_MAP_2, TestDefinition 
				WHERE TestDefinition.[ID] IN (SELECT TestDefinition.[ID] WHERE TableName = 'T_MAP_2') 
		) As Test 
INNER JOIN RosterYear ON dbo.GetRosterYear(Test.DateTaken) = RosterYear.[ID] 
	AND  RosterYear.StartDate >= GETDATE() AND RosterYear.EndDate <= GETDATE()
select Test.* FROM (
			SELECT T_MAP_3.*, TestDefinition.[ID] As TestDefinitionID 
				FROM T_MAP_3, TestDefinition 
				WHERE TestDefinition.[ID] IN (SELECT TestDefinition.[ID] WHERE TableName = 'T_MAP_3') 
		) As Test 
INNER JOIN RosterYear ON dbo.GetRosterYear(Test.DateTaken) = RosterYear.[ID] AND RosterYear.StartDate >= GETDATE() AND RosterYear.EndDate <= GETDATE()
select Test.* FROM (
			SELECT T_MAP_4.*, TestDefinition.[ID] As TestDefinitionID 
				FROM T_MAP_4, TestDefinition 
				WHERE TestDefinition.[ID] IN (SELECT TestDefinition.[ID] WHERE TableName = 'T_MAP42') 
		) As Test 
INNER JOIN RosterYear ON dbo.GetRosterYear(Test.DateTaken) = RosterYear.[ID] AND RosterYear.StartDate >= GETDATE() AND RosterYear.EndDate <= GETDATE()
select Test.* FROM (
			SELECT T_MAP_5.*, TestDefinition.[ID] As TestDefinitionID 
				FROM T_MAP_5, TestDefinition 
				WHERE TestDefinition.[ID] IN (SELECT TestDefinition.[ID] WHERE TableName = 'T_MAP_5') 
		) As Test 
INNER JOIN RosterYear ON dbo.GetRosterYear(Test.DateTaken) = RosterYear.[ID] AND RosterYear.StartDate >= GETDATE() AND RosterYear.EndDate <= GETDATE()
select Test.* FROM (
			SELECT T_MAP_6.*, TestDefinition.[ID] As TestDefinitionID 
				FROM T_MAP_6, TestDefinition 
				WHERE TestDefinition.[ID] IN (SELECT TestDefinition.[ID] WHERE TableName = 'T_MAP_6') 
		) As Test 
INNER JOIN RosterYear ON dbo.GetRosterYear(Test.DateTaken) = RosterYear.[ID] AND RosterYear.StartDate >= GETDATE() AND RosterYear.EndDate <= GETDATE()
select Test.* FROM (
			SELECT T_MAP_7.*, TestDefinition.[ID] As TestDefinitionID 
				FROM T_MAP_7, TestDefinition 
				WHERE TestDefinition.[ID] IN (SELECT TestDefinition.[ID] WHERE TableName = 'T_MAP_7') 
		) As Test 
INNER JOIN RosterYear ON dbo.GetRosterYear(Test.DateTaken) = RosterYear.[ID] AND RosterYear.StartDate >= GETDATE() AND RosterYear.EndDate <= GETDATE()
select Test.* FROM (
			SELECT T_MAP_8.*, TestDefinition.[ID] As TestDefinitionID 
				FROM T_MAP_8, TestDefinition 
				WHERE TestDefinition.[ID] IN (SELECT TestDefinition.[ID] WHERE TableName = 'T_MAP_8') 
		) As Test 
INNER JOIN RosterYear ON dbo.GetRosterYear(Test.DateTaken) = RosterYear.[ID] AND RosterYear.StartDate >= GETDATE() AND RosterYear.EndDate <= GETDATE()
select Test.* FROM (
			SELECT T_MAP_9.*, TestDefinition.[ID] As TestDefinitionID 
				FROM T_MAP_9, TestDefinition 
				WHERE TestDefinition.[ID] IN (SELECT TestDefinition.[ID] WHERE TableName = 'T_MAP_9') 
		) As Test 
INNER JOIN RosterYear ON dbo.GetRosterYear(Test.DateTaken) = RosterYear.[ID] AND RosterYear.StartDate >= GETDATE() AND RosterYear.EndDate <= GETDATE()
*/

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

