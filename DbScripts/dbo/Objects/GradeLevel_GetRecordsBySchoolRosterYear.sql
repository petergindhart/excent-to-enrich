SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[GradeLevel_GetRecordsBySchoolRosterYear]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[GradeLevel_GetRecordsBySchoolRosterYear]
GO


CREATE PROCEDURE dbo.GradeLevel_GetRecordsBySchoolRosterYear
	@schoolId uniqueidentifier,
	@rosterYearId uniqueidentifier
AS
	select
		g.ID, g.Name, g.Active, g.Sequence, MAX(g.BitMask) as BitMask
	from
		ClassRoster c join
		GradeLevel g on g.BitMask & c.GradeBitMask > 0
	where
		( @schoolId is null or c.SchoolId = @schoolId ) and
		( @rosterYearId is null or c.RosterYearId = @rosterYearId ) and
		Active = 1
	group by g.ID, g.Name, g.Active, g.Sequence
	order by g.Sequence

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

