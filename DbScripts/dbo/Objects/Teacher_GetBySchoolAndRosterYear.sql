SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Teacher_GetBySchoolAndRosterYear]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Teacher_GetBySchoolAndRosterYear]
GO


/*
<summary>
Gets the teachers that taught at the specified school during the specified roster year.
</summary>
<param name="school">Id of the school</param>
<param name="year">Id of the roster year</param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/

CREATE PROCEDURE dbo.Teacher_GetBySchoolAndRosterYear
	@school	uniqueidentifier,
	@year uniqueidentifier
AS

select distinct
	t.*
from
	ClassRoster c join
	ClassRosterTeacherHistory h on h.ClassRosterID = c.ID join
	Teacher t on h.TeacherID = t.ID
where
	c.SchoolID = @school and
	c.RosterYearID = @year
order by t.LastName, t.FirstName
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

