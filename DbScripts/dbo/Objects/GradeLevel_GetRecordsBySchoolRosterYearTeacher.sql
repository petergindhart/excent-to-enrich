SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[GradeLevel_GetRecordsBySchoolRosterYearTeacher]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[GradeLevel_GetRecordsBySchoolRosterYearTeacher]
GO


CREATE PROCEDURE dbo.GradeLevel_GetRecordsBySchoolRosterYearTeacher
	@schoolId uniqueidentifier,
	@rosterYearId uniqueidentifier,
	@teacherId uniqueidentifier
AS

select distinct
	g.*
from
	ClassRosterTeacherHistory crth join
	ClassRoster cr on crth.ClassRosterID = cr.ID join
	GradeLevel g on
		g.BitMask & cr.GradeBitMask > 0
where
	cr.SchoolId = @schoolId and
	cr.RosterYearId = @rosterYearId and
	crth.TeacherID = @teacherId



GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

