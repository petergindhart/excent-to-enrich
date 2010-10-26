/****** Object:  StoredProcedure [dbo].[Teacher_SearchRecordsForSchoolBatch]    Script Date: 05/16/2008 16:50:41 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[Teacher_SearchRecordsForSchoolBatch]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[Teacher_SearchRecordsForSchoolBatch]
GO

CREATE PROCEDURE Teacher_SearchRecordsForSchoolBatch
	@schoolId		uniqueidentifier,	
	@templateId		uniqueidentifier,
	@batchId	uniqueidentifier
AS
	SELECT
		distinct t.*
	FROM			
		FormInstance inst join
		StudentForm stuForm on stuForm.ID = inst.Id join		
		Student stu on stuForm.StudentID = stu.ID join		
		studentClassRosterHIstory classhist on classhist.StudentID = stu.ID join
		ClassRoster cr on classhist.CLassRosterID = cr.Id	join	
		ClassRosterTEacherHistory teacHist on teacHist.CLassRosterID = classhist.ClassRosterID join
		Teacher t on teacHist.TeacherID = t.ID
	where		
		inst.FormInstanceBatchID = @batchId and 
		cr.SchoolId = @schoolId and 
		(@templateId is null OR @templateId = inst.TemplateID)
	order by
		t.LastName asc