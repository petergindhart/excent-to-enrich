if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PrgActivitySchedule_GetActivItemSchedules]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[PrgActivitySchedule_GetActivItemSchedules]
GO

/*
<summary>
Gets records from the PrgActivitySchedule table for
active program items.
</summary>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[PrgActivitySchedule_GetActivItemSchedules]
	@schoolId uniqueidentifier,
	@rosterYearId uniqueidentifier,
	@activityDefId uniqueidentifier, 
	@programId uniqueidentifier
AS

declare @rosterYearEnd datetime
if( @rosterYearId is not null )
	select @rosterYearEnd = EndDate
	from RosterYear
	where ID = @rosterYearID

SELECT 
	sc.*,
	i.*
FROM PrgActivitySchedule sc JOIN
	PrgItemDef d ON d.ID = sc.ActivityDefID JOIN 
	
	PrgItemView i ON sc.ItemId = i.ID JOIN
	Student st ON i.StudentID = st.Id JOIN
	StudentSchoolHistory h ON h.StudentId = st.Id AND
		dbo.DateInRange(i.StartDate, h.StartDate, h.EndDate) = 1
WHERE i.EndDate IS NULL AND
	( @schoolId IS NULL OR h.SchoolId = @schoolId ) AND
	( @rosterYearEnd IS NULL OR i.StartDate < @rosterYearEnd ) AND 
	( @activityDefId IS NULL OR d.Id = @activityDefId ) AND
	( @programId IS NULL OR d.ProgramID = @programId )