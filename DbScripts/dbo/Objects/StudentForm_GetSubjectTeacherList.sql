SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[StudentForm_GetSubjectTeacherList]') and xtype in (N'FN', N'IF', N'TF'))
drop function [dbo].[StudentForm_GetSubjectTeacherList]
GO



/*
<summary>
Returns a delimitted list of teachers for a particular
student, roster year, and subject
</summary>
*/
CREATE FUNCTION dbo.StudentForm_GetSubjectTeacherList
(
	@studentId uniqueidentifier,
	@rosterYearId uniqueidentifier,
	@subjectId uniqueidentifier
)
RETURNS varchar(255) AS
BEGIN

	declare @teachers varchar(255)

	if(@subjectId is null)
	begin
		select @teachers = coalesce(@teachers + ', ', '') + t.FirstName + ' ' + t.LastName
		from
			StudentTeacherClassRoster x join
			Teacher t on x.TeacherId = t.Id join
			ClassRoster cr on x.ClassRosterId = cr.Id
		where
			x.StudentId = @studentId and
			x.RosterYearId = @rosterYearId
		group by t.FirstName, t.LastName
	end
	else
	begin
		select @teachers = coalesce(@teachers + ', ', '') + t.FirstName + ' ' + t.LastName
		from
			StudentTeacherClassRoster x join
			Teacher t on x.TeacherId = t.Id join
			ClassRoster cr on x.ClassRosterId = cr.Id join
			ContentArea ca on cr.ContentAreaId = ca.Id
		where
			x.StudentId = @studentId and
			x.RosterYearId = @rosterYearId and
			ca.SubjectId = @subjectId
		group by t.FirstName, t.LastName
	end

	RETURN @teachers
END

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

