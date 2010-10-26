IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[GetSubjectPercentage]') AND xtype in (N'FN', N'IF', N'TF'))
DROP FUNCTION [dbo].[GetSubjectPercentage]
GO

CREATE FUNCTION [dbo].[GetSubjectPercentage]
(
	@subjectID uniqueidentifier,
	@formTemplateId uniqueidentifier,
	@schoolID uniqueidentifier,
	@batchID uniqueidentifier
)
RETURNS float
AS
BEGIN
	DECLARE @percentage float
	SET @percentage = 0.0

	select 
		@percentage = ( cast(SUM( counts.Complete) as float) / cast(SUM(counts.Total) as float))
	FROM
	(
		select 
			Complete = case when status.CompletedDate is not null then 1 else 0 end,
			Total = 1	
		From
			FormInstance ins join 
			StudentForm form on form.ID = ins.ID join
			FormInstanceBatch batch on ins.FormInstanceBatchID = batch.ID join		
			Student stu on 	stu.ID = form.StudentID join	
			FormInstanceInterval interval on interval.InstanceID = ins.ID and interval.intervalID = CurrentIntervalID join
			SubjectFormInputStatus status on status.IntervalID = interval.ID join
			Subject sub on status.SubjectID = sub.ID
		where
			batch.ID = @batchID and  stu.CurrentSchoolID = @schoolId and (@subjectID is null OR sub.ID = @subjectID) and ins.TemplateId = @formTemplateId
	) counts

	return @percentage
END
