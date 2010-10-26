IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[StudentForm_GetRecordsByBatchSchoolAndTemplate]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[StudentForm_GetRecordsByBatchSchoolAndTemplate]
GO

 /*
<summary>
Gets records from the FormInstanceBatch table
that have instances at the specified school for the provided type
</summary>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[StudentForm_GetRecordsByBatchSchoolAndTemplate]
	@batchID			uniqueidentifier, 		
	@schoolID			uniqueidentifier,
	@formTemplateId		uniqueidentifier
AS
	SELECT 
		stuForm.*,
		inst.*,
		ft.TypeId		
	FROM		
		FormInstance inst join
		StudentForm stuForm on stuForm.ID = inst.Id join		
		Student stu on stuForm.StudentID = stu.ID join
		FormTemplate ft on inst.TemplateId = ft.ID
	where
		inst.TemplateId = @formTemplateId and stu.CurrentSchoolID = @schoolID and inst.FormInstanceBatchID  = @batchId 
	order by
		stu.LastName