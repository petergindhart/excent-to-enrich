/****** Object:  StoredProcedure [dbo].[BrowseUtility_GetGradeLevelStandardsSummary]    Script Date: 05/15/2008 13:42:05 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[BrowseUtility_GetFormTemplateStandardsSummaries]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[BrowseUtility_GetFormTemplateStandardsSummaries]
GO

CREATE Procedure [dbo].[BrowseUtility_GetFormTemplateStandardsSummaries]
	@schoolId uniqueidentifier,
	@batchId uniqueidentifier
AS

SELECt	
	TemplateID,
	ELA = dbo.GetSubjectPercentage('DF2274C7-1714-44C1-A8FC-61F29D5504AC', TemplateID, @schoolId, @batchID),
	MAT = dbo.GetSubjectPercentage('7BC1F354-2787-4C88-83F1-888D93F0E71E', TemplateID, @schoolId, @batchID),
	SCI = dbo.GetSubjectPercentage('0351CAC6-40EE-479C-A506-DC84E77C6665', TemplateID, @schoolId, @batchID),
	SOC = dbo.GetSubjectPercentage('C90E81B1-30CB-4D2D-B301-F4AB6A1F5E75', TemplateID, @schoolId, @batchID),
	[All] = dbo.GetSubjectPercentage(null, TemplateID, @schoolId, @batchID)
FROM
	FormInstance ins join 
	StudentFOrm form on form.ID = ins.ID join
	FormInstanceBatch batch on ins.FormInstanceBatchID = batch.ID join		
	Student stu on 	stu.ID = form.StudentID left join	
	FormInstanceInterval interval on interval.InstanceID = ins.ID	
where
	batch.ID = @batchID and stu.CurrentSchoolID = @schoolId  and 
	(interval.ID is null OR interval.intervalID = CurrentIntervalID)
group by
	TemplateID


