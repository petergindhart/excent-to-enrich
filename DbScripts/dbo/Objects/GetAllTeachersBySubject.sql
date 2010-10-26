IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[GetAllTeachersBySubject]') AND xtype in (N'FN', N'IF', N'TF'))
DROP FUNCTION [dbo].[GetAllTeachersBySubject]
GO

CREATE FUNCTION dbo.GetAllTeachersBySubject
(
	@subject	uniqueidentifier
)
RETURNS Table
AS RETURN

select 
	distinct tHist.TeacherID, LastName, FirstName
FRom	
	COntentArea ca join					
	ClassRoster cr on cr.ContentAreaID = ca.ID join
	ClassRosterTeacherHIstory tHist on thist.ClassRosterID = cr.ID	join
	Teacher tch on thist.TeacherID = tch.ID		
WHERE			
	ca.SubjectID = @subject
	--(@subject IS NOT NULL AND ca.SubjectID = @subject) --OR
	--(@subject IS NULL AND cr.ClassName like '%Homeroom%')

