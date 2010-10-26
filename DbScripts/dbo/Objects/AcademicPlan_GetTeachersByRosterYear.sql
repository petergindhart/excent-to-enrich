SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[AcademicPlan_GetTeachersByRosterYear]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[AcademicPlan_GetTeachersByRosterYear]
GO



/*
<summary>
Gets all Teachers associated with Students who have Academic Plans for the specified Roster Year.
</summary>
<param name="rosterYearID">The Roster Year ID for the specified roster year.</param>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE dbo.AcademicPlan_GetTeachersByRosterYear
	@rosterYearID uniqueidentifier 
AS


SELECT DISTINCT t.* 
FROM 
	Teacher t INNER JOIN 
	ClassRosterTeacherHistory crth ON t.ID = crth.TeacherID INNER JOIN 
	ClassRoster cr ON crth.ClassRosterId = cr.ID AND cr.RosterYearID = @rosterYearID INNER JOIN 
	StudentClassRosterHistory scrh ON cr.ID = scrh.ClassRosterID INNER JOIN 
	AcademicPlan ap ON scrh.StudentID = ap.StudentID AND ap.RosterYearID = @rosterYearID

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

