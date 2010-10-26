--#include GetHqStatusDetail.sql

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ClassRosterTeacherHistory_GetRecordsByStatusAndSchool]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[ClassRosterTeacherHistory_GetRecordsByStatusAndSchool]
GO

/*
<summary>Gets records from the ClassRosterTeacherHistory by date, school and status</summary>
<param name="statusDate">Status date input by user </param>
<param name="schoolId">School Id form query </param>
<param name="status">Status input by user </param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/

CREATE  PROCEDURE dbo.ClassRosterTeacherHistory_GetRecordsByStatusAndSchool
(@statusDate datetime,
@schoolId UniqueIdentifier,
@status int)

As

if @schoolID is null
	begin

	select
		crth.ClassRosterID, crth.TeacherID, crth.StartDate, crth.EndDate
	from
		ClassRosterTeacherHistory crth join
		dbo.GetHqStatusDetail(@statusDate) hq on
		hq.ClassRosterID = crth.ClassRosterID and
		hq.TeacherID = crth.TeacherID
	where
		crth.StartDate <= @statusDate and (crth.EndDate is null or @statusDate < crth.EndDate) and
		hq.Status = @status

	end
else
	begin
	
	select
		crth.ClassRosterID, crth.TeacherID, crth.StartDate, crth.EndDate
	from
		ClassRosterTeacherHistory crth join
		dbo.GetHqStatusDetail(@statusDate) hq on
		hq.ClassRosterID = crth.ClassRosterID and
		hq.TeacherID = crth.TeacherID
	where
		crth.StartDate <= @statusDate and (crth.EndDate is null or @statusDate < crth.EndDate) and
		hq.Status = @status and
		hq.SchoolID = @schoolID
	
	end

GO
/*
ClassRosterTeacherHistory_GetRecordsByStatusAndSchool '8/1/2005','076a88e5-723c-40dc-b47c-c279abb29a5c','Unknown'
*/