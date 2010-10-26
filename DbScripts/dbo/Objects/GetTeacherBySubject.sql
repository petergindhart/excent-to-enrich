IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[GetTeacherBySubject]') AND xtype in (N'FN', N'IF', N'TF'))
DROP FUNCTION [dbo].[GetTeacherBySubject]
GO

CREATE FUNCTION dbo.GetTeacherBySubject(
	@student	uniqueidentifier,
	@date		datetime,
	@subject	uniqueidentifier
)
RETURNS uniqueidentifier
AS
BEGIN
	return
	(
		select 
			top 1 thist.TeacherID
		FRom
			StudentClassRosterHistory hist join
			ClassRoster cr on hist.ClassRosterID = cr.ID join
			COntentArea ca on cr.ContentAreaID = ca.ID join
			ClassRosterTeacherHIstory tHist on thist.ClassRosterID = cr.ID join
			Teacher tch on tch.ID = thist.TeacherID 
		WHERE
			hist.StudentID =  @student AND						
			(
				ca.SubjectID = @subject
				--(@subject IS NOT NULL AND ca.SubjectID = @subject) OR
				--(@subject IS NULL AND cr.ClassName like '%Homeroom%') 
			) AND
			dbo.DateInRange(@date,hist.StartDate,hist.EndDate) = 1 and	
			dbo.DateInRange(@date,thist.StartDate,thist.EndDate) = 1
	)
END