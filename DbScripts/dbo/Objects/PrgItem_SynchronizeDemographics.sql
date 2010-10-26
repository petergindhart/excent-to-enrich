IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[PrgItem_SynchronizeDemographics]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[PrgItem_SynchronizeDemographics]
GO

CREATE PROCEDURE dbo.PrgItem_SynchronizeDemographics
AS

UPDATE pri
SET 
	SchoolID = ISNULL(stu.CurrentSchoolID, pri.SchoolID), 
	GradeLevelID = IsNull(stu.CurrentGradeLevelID,pri.GradeLevelID)
FROM
	PrgItem pri join
	Student stu on pri.StudentID = stu.ID join
	PrgItemDef pid on pri.DefID = pid.ID
where	
	(
		(stu.CurrentSchoolID is not null AND pri.SchoolID <> stu.CurrentSchoolID) OR -- only update where they're are different to reduce the total number of records to update
		(stu.CurrentGradeLevelID is not null AND pri.GradeLevelID <> stu.CurrentGradeLevelID)
	)	AND -- where the Current school and the program item School are not the same
	pri.ItemOutcomeID is null -- where it is not ended
