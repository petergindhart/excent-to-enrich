IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[Student_EnsureActiveStatuses]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].Student_EnsureActiveStatuses
GO

CREATE PROCEDURE dbo.Student_EnsureActiveStatuses
AS

-- Only update students who are inactive according to the SIS, and are also not being managed by the SIS
UPDATE Student
SET IsActive = 0
WHERE
	CurrentSchoolID is null and CurrentGradeLevelID is null and
	ManuallyEntered = 0
		
UPDATE Student
SET IsActive = 1
WHERE
	CurrentSchoolID is not null and CurrentGradeLevelID is not null and
	ManuallyEntered = 0