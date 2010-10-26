/****** Object:  StoredProcedure [dbo].[FormInstanceBatch_GetRecordsBySchoolAndType]    Script Date: 05/15/2008 15:32:53 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[FormInstanceBatch_GetRecordsBySchoolAndType]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[FormInstanceBatch_GetRecordsBySchoolAndType]
GO

 /*
<summary>
Gets records from the FormInstanceBatch table
that have instances at the specified school for the provided type
</summary>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[FormInstanceBatch_GetRecordsBySchoolAndType]
	@schoolID			uniqueidentifier,
	@formInstanceTypeID	uniqueidentifier,
	@rosterYearId		uniqueidentifier
AS
	SELECT distinct
		batch.*,
		stuBatch.*
	FROM
		FormInstanceBatch batch JOIN
		StudentFormInstanceBatch stuBatch on batch.Id = stuBatch.Id join
		FormInstance inst on inst.FormInstanceBatchID = batch.ID join
		StudentForm stuForm on stuForm.ID = inst.Id join
		Student stu on stuForm.StudentID = stu.ID 
	where
		stu.CurrentSchoolID = @schoolID and 
		stuBatch.RosterYearId = @rosterYearId and 		
		batch.FormTemplateTypeID = @formInstanceTypeID