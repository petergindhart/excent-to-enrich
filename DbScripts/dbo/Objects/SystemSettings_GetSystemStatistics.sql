-- =============================================
-- Create procedure basic template
-- =============================================
-- creating the store procedure
IF EXISTS (SELECT name 
	   FROM   sysobjects 
	   WHERE  name = N'SystemSettings_GetSystemStatistics' 
	   AND 	  type = 'P')
    DROP PROCEDURE dbo.SystemSettings_GetSystemStatistics
GO


/*
<summary>
Gets system statistics
</summary>

<model  isGenerated="false" 
        returnType="System.Data.IDataReader" 
        />
*/
CREATE PROCEDURE dbo.SystemSettings_GetSystemStatistics 
AS

	declare @end datetime
	set @end = DATEADD(DAY,DATEDIFF(DAY,'20000101' , getdate()), '20000101')	

	declare @start datetime
	set @start = DateAdd(day, -1, @end)



	-- STUDENTS
	select
		Name	= 'ActiveStudents',
		Value	= count(*)
	from
		Student
	where
		CurrentSchoolID is not null

	union all
	select
		Name	= 'InactiveStudents',
		Value	= count(*)
	from
		Student
	where
		CurrentSchoolID is null

	-- TEACHERS
	union all
	select
		Name	= 'ActiveTeachers',
		Value	= count(*)
	from
		Teacher
	where
		CurrentSchoolID is not null

	union all
	select
		Name	= 'InactiveTeachers',
		Value	= count(*)
	from
		Teacher
	where
		CurrentSchoolID is null


	-- USERS
	union all
	select
		Name	= 'Logins24',
		Value	= count(logins.EventTime)
	from
		AuditLogEntry logins
	where
		logins.EventTime between @start and @end and
		logins.Message = 'Sign in successful'

	union all
	select
		Name	= 'ActiveUsers',
		Value	= count(*)
	from
		UserProfileView
	where
		Deleted is null

GO

-- =============================================
-- example to execute the store procedure
-- =============================================
--EXECUTE dbo.SystemSettings_GetSystemStatistics
GO

