if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[BrowseUtility_GetAcademicPlanSummary]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[BrowseUtility_GetAcademicPlanSummary]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE PROCEDURE dbo.BrowseUtility_GetAcademicPlanSummary
	@schoolId uniqueidentifier,
	@rosterYearId uniqueidentifier
AS

select
	ap.GradeLevelId,
	sum(cast(ELA.IsSelected as int)) [ELA],
	sum(cast(MAT.IsSelected as int)) [MAT],
	sum(cast(SCI.IsSelected as int)) [SCI],
	sum(cast(SOC.IsSelected as int)) [SOC],
	count(*) [Total]
from
	AcademicPlan ap join
	AcademicPlanSubject ELA on ELA.AcademicPlanId = ap.Id and ELA.SubjectId = 'DF2274C7-1714-44C1-A8FC-61F29D5504AC' join
	AcademicPlanSubject MAT on MAT.AcademicPlanId = ap.Id and MAT.SubjectId = '7BC1F354-2787-4C88-83F1-888D93F0E71E' join
	AcademicPlanSubject SCI on SCI.AcademicPlanId = ap.Id and SCI.SubjectId = '0351CAC6-40EE-479C-A506-DC84E77C6665' join
	AcademicPlanSubject SOC on SOC.AcademicPlanId = ap.Id and SOC.SubjectId = 'C90E81B1-30CB-4D2D-B301-F4AB6A1F5E75'
where
	ap.SchoolId = @schoolId and
	ap.RosterYearId = @rosterYearId
group by ap.GradeLevelId

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO