SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Student_CreateNewAcademicPlan]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Student_CreateNewAcademicPlan]
GO



/*
<summary>
Creates a new Academic Plan for a specific student.
</summary>
<param name="studentID">The current student id</param>
<param name="currentRosterYearID">The current roster year.</param>
<param name="userID">The User ID of the user who initiated the plan creation.</param>
<param name="reasonID">The AcademicPlanReason ID of the reason the plan is generated.</param>
<param name="detailedReason">A detailed reason why the plan is generated.</param>
<param name="returnID">Indicates whether to return the id of the academic plan</param>
<model isGenerated="False" returnType="System.Guid" />
*/
CREATE PROCEDURE dbo.Student_CreateNewAcademicPlan 
	@studentID uniqueidentifier, 
	@currentRosterYearID uniqueidentifier, 
	@userID uniqueidentifier, 
	@reasonID uniqueidentifier,
	@detailedReason varchar(200),
	@returnID bit = 0
AS
	
/* Procedure Variables */
DECLARE @newGUID as uniqueidentifier
DECLARE @studentStr as varchar(40)
DECLARE @schoolID as uniqueidentifier
DECLARE @gradeID as uniqueidentifier

/* Cursors */


/* Create a new Guid for the Academic Plan */
SELECT @newGUID = NEWID()

-- temporary to account for bad data
SELECT @schoolID = CurrentSchoolID from Student WHERE [ID] = @studentID
SELECT @gradeID = CurrentGradeLevelID FROM Student WHERE [ID] = @studentID

IF (@schoolID IS NOT NULL AND @gradeID IS NOT NULL)
BEGIN

/* Insert new Record into the Academic Plan Table */
INSERT INTO AcademicPlan ([ID], StudentID, RosterYearID, SchoolID, GradeLevelID, ReasonID, Street, City, State, ZipCode, PhoneNumber, DetailedReason) 
SELECT @newGUID, [ID], @currentRosterYearID, CurrentSchoolID, CurrentGradeLevelID, @reasonID, Street, City, State, ZipCode, PhoneNumber, @detailedReason
	FROM Student WHERE [ID] = @studentID --AND CurrentGradeLevelID = @currentGradeLevelID

IF (@@ROWCOUNT = 0)
BEGIN
	SET @studentStr = CAST(@studentID as varchar(40))
	RAISERROR('Unable to insert record into AcademicPlan for %s', 16, 1, @studentStr)
	RETURN
END

/* Create the Actions for the plan */
INSERT INTO AcademicPlanAction (AcademicPlanID, ActionID, IsSelected) 
SELECT @newGUID, [ID], IsDefault FROM Action WHERE IsCustom = 0

/* Create the initial ChangeHistory entry */
INSERT INTO ChangeHistory (AcademicPlanID, UserID, ChangeDate) 
VALUES (@newGUID, @userID, GETDATE())
--END

IF (@returnID = 1 )
BEGIN
	SELECT @newGUID
END
RETURN

END

ErrorOccurred:



GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

