if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[SecurityZone_GetContextIdentifiersByUserProfileID]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[SecurityZone_GetContextIdentifiersByUserProfileID]
GO

/*
<summary>
Gets context identifiers for the specified user
</summary>
<param name="@userProfileID">Ids of the records to retrieve</param>
<model returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE dbo.SecurityZone_GetContextIdentifiersByUserProfileID
	@userProfileId uniqueidentifier
AS
	DECLARE @idTable table(id uniqueidentifier)

	DECLARE @currentDate DATETIME
	SET @currentDate = GETDATE()

	DECLARE @districtzone 		uniqueidentifier
	DECLARE @schoolzone 		uniqueidentifier
	DECLARE @studentszone 		uniqueidentifier
	DECLARE @recentstudentszone 	uniqueidentifier
	DECLARE @recentschoolszone 	uniqueidentifier

	DECLARE @startDate		datetime
	DECLARE @endDate		datetime
	DECLARE @securityzone 		uniqueidentifier
	DECLARE @schoolid 		uniqueidentifier	
	DECLARE @emailaddress 		varchar(50)
	
	SET @districtzone 		= 'CAC5D55A-794F-4FBE-9D91-8B9E2CE13DD2'
	SET @schoolzone			= '8ED30018-EFEC-4D22-9E46-8C72EB22AF5A'
	SET @studentszone		= 'B46252C8-FE46-423A-ACB7-13A1753C04CE'
	SET @recentstudentszone		= 'ED8587DF-06A3-48A2-BEB6-BC84D42BB77C'
	SET @recentschoolszone		= '308E1B1B-DB6C-47EF-B4BD-690D1645ABDE'
	
	SELECT	@securityzone = SZ.ID, 
		@schoolid = UP.SchoolID, 
		@emailaddress = UP.EmailAddress 
	FROM	UserProfileView UP JOIN
		SecurityRole SR ON UP.RoleID = SR.ID JOIN
		SecurityRoleZone SRZ ON SR.ID = SRZ.SecurityRoleID JOIN
		SecurityZone SZ ON SRZ.SecurityZoneID = SZ.ID
	WHERE	UP.ID = @userProfileId AND
		SZ.ContextTypeID = 'F069CEA9-B0F4-44E2-AD7D-EE03E3F7C0D4'

	-- my school zone, recent school zone
	IF @securityzone in (@schoolzone, @recentschoolszone)
	BEGIN
		INSERT @idTable VALUES (@schoolid)
	END

	-- my students zone
	ELSE IF @securityzone = @studentszone
	BEGIN	
		-- insert the class roster identifies in the idTable
		INSERT @idTable 

			SELECT i.StudentID -- interventionist / team member
				FROM
					PrgItem i JOIN 
					PrgIntervention intv ON intv.ID = i.ID JOIN 
					PrgItemTeamMember t on t.ItemID = i.ID
				WHERE
					@userProfileId = t.PersonID and
					dbo.DateInRange(@currentDate, i.StartDate, i.EndedDate) = 1
				GROUP BY i.StudentID
			union
			SELECT c.ClassRosterID
				FROM
					ClassRosterTeacherHistory c  WHERE
					( dbo.DateInRange(@currentDate, c.startDate, c.endDate) = 1 ) AND
					(  c.TeacherId in (SELECT Id FROM Teacher WHERE UserProfileID = @userProfileId) )
			union
			SELECT r.SchoolId
				FROM
					ClassRosterTeacherHistory c join
					ClassRoster r on c.ClassRosterID = r.ID
				WHERE
					( dbo.DateInRange(@currentDate, c.startDate, c.endDate) = 1 ) AND
					(  c.TeacherId in (SELECT Id FROM Teacher WHERE UserProfileID = @userProfileId) )
				group by r.SchoolId
			union
			SELECT u.schoolId 
				from UserProfile u where u.ID = @userProfileId
			union
			SELECT h.schoolId 
				from 
					TeacherSchoolHistory h join
					Teacher t on h.TeacherID = t.ID
				where 
					t.userprofileid = @userProfileId and
					dbo.DateInRange(@currentDate, h.startDate, h.endDate) = 1
	END

	-- my recents students zone
	ELSE IF @securityzone = @recentstudentszone
	BEGIN
		SELECT @startdate = StartDate, @enddate = EndDate FROM dbo.GetRosterYearsDateRange(@currentDate, -1, 0)

		-- insert the class roster identifies in the idTable and school ids
		INSERT @idTable 

			SELECT i.StudentID -- interventionist / team member
				FROM
					PrgItem i JOIN 
					PrgIntervention intv on intv.ID = i.ID left join
					PrgItemTeamMember t on t.ItemID = i.ID
				WHERE
					@userProfileId = t.PersonID and
					dbo.DateRangesOverlap(@startdate, @enddate, i.StartDate, i.EndedDate, @currentDate )  = 1
				GROUP BY i.StudentID
			union
			SELECT c.ClassRosterID
				FROM
					ClassRosterTeacherHistory c  WHERE
					( dbo.DateRangesOverlap(@startdate, @enddate, c.startDate, c.EndDate, @currentDate )  = 1) AND
					(  c.TeacherId in (SELECT Id FROM Teacher WHERE UserProfileID = @userProfileId) )
			union
			SELECT r.SchoolId
				FROM
					ClassRosterTeacherHistory c join
					ClassRoster r on c.ClassRosterID = r.ID
				WHERE
					( dbo.DateRangesOverlap(@startdate, @enddate, c.startDate, c.EndDate, @currentDate )  = 1) AND
					(  c.TeacherId in (SELECT Id FROM Teacher WHERE UserProfileID = @userProfileId) )
				group by r.SchoolId
			union
			SELECT u.schoolId 
				from UserProfile u where u.ID = @userProfileId
			union
			SELECT h.schoolId 
				from 
					TeacherSchoolHistory h join
					Teacher t on h.TeacherID = t.ID
				where 
					t.userprofileid = @userProfileId and
					dbo.DateRangesOverlap(@startdate, @enddate, h.StartDate, h.EndDate, @currentDate ) = 1
	END
	
	SELECT * FROM @idTable
GO
