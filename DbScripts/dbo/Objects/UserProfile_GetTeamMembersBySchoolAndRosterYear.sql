SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[UserProfile_GetTeamMembersBySchoolAndRosterYear]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[UserProfile_GetTeamMembersBySchoolAndRosterYear]
GO


/*
<summary>
Gets records from the UserProfile table for users
that have been assigned as an intervention Team Member
for the specified School and RosterYear
</summary>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE dbo.UserProfile_GetTeamMembersBySchoolAndRosterYear
	@schoolId uniqueidentifier,
	@rosterYearId uniqueidentifier,
	@includePrimaryTeamMember bit,
	@includeNonPrimaryTeamMember bit
AS

select *
from
	UserProfileView
where 
	ID in (
		select m.PersonID
		from
			PrgItem p join
			PrgIntervention i on i.ID = p.ID join 
			PrgItemTeamMember m on m.ItemID = p.ID join 
			RosterYear y on dbo.DateInRange(p.StartDate, y.StartDate, y.EndDate) = 1 join
			StudentSchoolHistory h on h.StudentID = p.StudentID and
				dbo.DateInRange(p.StartDate, h.StartDate, h.EndDate) = 1
		where
			(
				(@includePrimaryTeamMember = 1 and m.IsPrimary = 1) or
				(@includeNonPrimaryTeamMember = 1 and m.IsPrimary = 0)
			)and
			( @schoolId is null or h.SchoolId = @schoolId ) and
			( @rosterYearId is null or y.Id = @rosterYearId )
	)
ORDER BY FirstName


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

