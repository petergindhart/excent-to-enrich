if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ClassRoster_GetReportCountsByClassRoster]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[ClassRoster_GetReportCountsByClassRoster]
GO

CREATE PROCEDURE dbo.ClassRoster_GetReportCountsByClassRoster
	@classRoster	uniqueidentifier,
	@scope			varchar(20)
AS

--DECLARE @countSet table (StudentCount int, ClassCount int, SchoolCount int)

DECLARE @school uniqueidentifier
DECLARE @rosterYear uniqueidentifier
DECLARE @courseCode varchar(10)

select 
	@school = SchoolID,
	@rosterYear = RosterYearID,
	@courseCode = CourseCode 
from 
	ClassRoster where id = @classRoster

SELECT
	StudentCount = count(distinct cast(student as varchar(36))),
	ClassCount = count(distinct cast(ClassRoster as varchar(36))),
	SchoolCount = count(distinct cast(SchoolId as varchar(36)))
FROM 
	ReportCardScore rcs join
	ClassRoster cr on rcs.ClassRoster = cr.ID join
	School sch on cr.SchoolId = sch.Id
where 
	ClassRoster IN
	(
		
		select ID 
		From ClassRoster 
		where
			(ID = @classRoster) or 
			(@scope = 'school' and SchoolID = @school and CourseCode = @courseCode and RosterYearID = @rosterYear) or
			(@scope = 'district' and CourseCode = @courseCode and RosterYearID = @rosterYear)
	)

