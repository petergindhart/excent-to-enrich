if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PrgActivity_GetActiveStudentActivities]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[PrgActivity_GetActiveStudentActivities]
GO

/*
<summary>
Gets records from the PrgActivity table for active
student activities matching the specified criteria
</summary>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[PrgActivity_GetActiveStudentActivities]
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

select
	i.*, 
	a.*,
	ItemTypeId = d.TypeID 
from
	PrgActivity a JOIN 
	PrgItem i on i.ID = a.ID JOIN 
	PrgItemDef d on d.ID = i.DefID JOIN 
	Student s on i.StudentID = s.Id JOIN
	StudentSchoolHistory h on h.StudentId = s.Id and
		dbo.DateInRange(i.StartDate, h.StartDate, h.EndDate) = 1
where 
	i.ItemOutcomeID is null and
	( @schoolId is null or h.SchoolId = @schoolId ) and
	( @rosterYearEnd is null or i.StartDate < @rosterYearEnd ) and 
	( @activityDefId is null or d.Id = @activityDefId ) and 
	( @programId is null or d.ProgramID = @programId )

