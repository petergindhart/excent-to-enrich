if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[AcademicPlan_SetGoalsForStudent]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[AcademicPlan_SetGoalsForStudent]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO



/*
<summary>
Creates the Curriculum Goals for a particular student
</summary>
<param name="studentID">The current student id</param>
<param name="currentRosterYearID">The current roster year.</param>
<model isGenerated="False" returnType="System.Void" />
*/
CREATE PROCEDURE dbo.AcademicPlan_SetGoalsForStudent
	@studentID uniqueidentifier, 
	@currentRosterYearID uniqueidentifier 
AS

DECLARE @rosterYear as int
DECLARE @planID as uniqueidentifier

/* Check to see if academic plans have been generated for the roster year already */
SELECT @rosterYear = StartYear FROM RosterYear WHERE [ID] = @currentRosterYearID

IF EXISTS(SELECT id from academicplan where RosterYearID = @currentRosterYearID AND StudentID = @studentID )
BEGIN
	DECLARE auTestCursor CURSOR FOR select id, IsDefault from action where iscustom=0
	DECLARE @actionID uniqueidentifier
	DECLARE @default bit

	SELECT @planID = [ID] FROM AcademicPlan WHERE RosterYearID = @currentRosterYearID AND StudentID = @studentID
	OPEN auTestCursor
	FETCH NEXT FROM auTestCursor INTO @actionID, @default

	WHILE (@@FETCH_STATUS = 0)
	BEGIN
		INSERT INTO AcademicPlanAction VALUES (newid(), @planID, @actionID, @default)
		FETCH NEXT FROM auTestCursor INTO @actionID, @default
	END

	CLOSE auTestCursor
	DEALLOCATE auTestCursor

END

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

