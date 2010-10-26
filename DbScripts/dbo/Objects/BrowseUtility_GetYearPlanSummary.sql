/****** Object:  StoredProcedure [dbo].[BrowseUtility_GetYearPlanSummary]    Script Date: 08/28/2008 10:52:08 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[BrowseUtility_GetYearPlanSummary]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[BrowseUtility_GetYearPlanSummary]
GO

CREATE PROCEDURE [dbo].[BrowseUtility_GetYearPlanSummary]
	@schoolId uniqueidentifier
AS

select 
	RosterYearID,
	count(*) AS NumPlans 
From 
	AcademicPlan
where 
	SchoolID = @schoolId
group by
	RosterYearID

