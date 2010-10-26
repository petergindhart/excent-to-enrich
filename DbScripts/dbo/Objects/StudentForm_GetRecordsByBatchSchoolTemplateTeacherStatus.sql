IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[StudentForm_GetRecordsByBatchSchoolTemplateTeacherStatus]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[StudentForm_GetRecordsByBatchSchoolTemplateTeacherStatus]
GO

 /*
<summary>
Gets records from the FormInstanceBatch table
that have instances at the specified school for the provided type
</summary>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[StudentForm_GetRecordsByBatchSchoolTemplateTeacherStatus]
	@batchID			uniqueidentifier, 		
	@schoolID			uniqueidentifier,
	@formTemplateId		uniqueidentifier,
	@teacherId			uniqueidentifier,
	@onlyComplete		bit
	
AS
	SELECT distinct
		stuForm.*,
		inst.*,
		ft.TypeId,
		stu.LastName,
		stu.FirstName,
		CurrentGradeLevelID		
	FROM		
		FormInstance inst join
		FormInstanceInterval instInt on instInt.InstanceId = inst.Id left join
		StudentForm stuForm on stuForm.ID = inst.Id join
		Student stu on stuForm.StudentID = stu.ID join
		FormTemplate ft on inst.TemplateId = ft.ID			
	where						
		stu.CurrentSchoolID = @schoolID and 
		inst.FormInstanceBatchID = @batchId and				
		(@formTemplateId is null OR inst.TemplateId = @formTemplateId) and
		(instInt.CompletedDate is not null OR @onlyComplete = 0)
		AND 
		(
			@teacherId is null 
				OR
			StudentID in 
			(
				SELECT 
					STudentID 
				from 
					StudentTeacher
				WHERE 
					TeacherID = @teacherId
			)
		)			
	ORDER BY
		stu.LastName asc,
		stu.FirstName asc,
		CurrentGradeLevelID asc