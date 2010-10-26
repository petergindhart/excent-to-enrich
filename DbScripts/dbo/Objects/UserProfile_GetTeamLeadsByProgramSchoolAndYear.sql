if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[UserProfile_GetTeamLeadsByProgramSchoolAndYear]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[UserProfile_GetTeamLeadsByProgramSchoolAndYear]
GO


/*
<summary>
Gets records from the UserProfile table for users
that have been assigned as an item's PrimaryTeamMember
for the specified Program, School, and RosterYear
</summary>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[UserProfile_GetTeamLeadsByProgramSchoolAndYear]
	@programId uniqueidentifier,
	@schoolId uniqueidentifier,
	@rosterYearId uniqueidentifier
AS

SELECT *
FROM UserProfileView
WHERE 
	Id IN 
	(select m.PersonID
	from
		PrgItem p JOIN
		PrgItemDef d ON d.Id = p.DefId JOIN
		PrgItemTeamMember m ON m.ItemId = p.Id JOIN 
		RosterYear y ON dbo.DateInRange(p.StartDate, y.StartDate, y.EndDate) = 1 JOIN
		StudentSchoolHistory h ON h.StudentId = p.StudentId AND
			dbo.DateInRange(p.StartDate, h.StartDate, h.EndDate) = 1
	where
		m.IsPrimary = 1 AND
		(@programId IS NULL OR d.ProgramId = @programId) AND 
		(@schoolId IS NULL OR h.SchoolId = @schoolId) AND
		(@rosterYearId IS NULL OR y.Id = @rosterYearId))
GO
