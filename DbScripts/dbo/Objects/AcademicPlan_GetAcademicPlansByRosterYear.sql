SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[AcademicPlan_GetAcademicPlansByRosterYear]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[AcademicPlan_GetAcademicPlansByRosterYear]
GO



/*
<summary>
Gets all Academic Plans for a specific Roster Year.
</summary>
<param name="rosterYearID">The Roster Year ID for the current roster year.</param>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE dbo.AcademicPlan_GetAcademicPlansByRosterYear
	@rosterYearID uniqueidentifier 
AS

SELECT * FROM AcademicPlan WHERE RosterYearID = @rosterYearID


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

