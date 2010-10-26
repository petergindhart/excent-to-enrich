SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[AcademicPlan_SearchRecordsForSchoolRosterYear]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[AcademicPlan_SearchRecordsForSchoolRosterYear]
GO

CREATE PROCEDURE dbo.AcademicPlan_SearchRecordsForSchoolRosterYear
	@schoolId		uniqueidentifier,
	@rosterYearId	uniqueidentifier,
	@gradeLevelId	uniqueidentifier,
	@subjectId		uniqueidentifier
AS
	
	SELECT
		ap.*
	FROM
		AcademicPlan ap
	WHERE
		ap.SchoolId = @schoolId AND
		ap.RosterYearId = @rosterYearId AND
		ap.GradeLevelId = @gradeLevelId AND
		( --subject
			@subjectId IS NULL OR
			ap.Id IN 
			(
				SELECT AcademicPlanId
				FROM AcademicPlanSubject
				WHERE SubjectId = @subjectId AND IsSelected = 1
				GROUP BY AcademicPlanId
			)
		)

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

