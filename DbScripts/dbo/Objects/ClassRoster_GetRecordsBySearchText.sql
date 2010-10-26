if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ClassRoster_GetRecordsBySearchText]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[ClassRoster_GetRecordsBySearchText]
GO

/*
<summary>
Gets records from the Class Roster table that match the specified search text
</summary>
<param name="searchText">The user's search text</param>
<param name="rosterYearID">The roster year to search in</param>
<param name="userProfileID">The user who is performing the search</param>
<returns>List of matching class rosters</returns>
<model returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[ClassRoster_GetRecordsBySearchText]
	@searchText VARCHAR(100), @rosterYearID UNIQUEIDENTIFIER, @fetchAll BIT, @userProfileID UNIQUEIDENTIFIER
AS
	-- trim search text and remove commas --
	----------------------------------------
	DECLARE @searchTextNormal VARCHAR(200)
	SET @searchTextNormal = REPLACE(LTRIM(RTRIM(@searchText)), ',', '')

	-- define security zones --
	---------------------------
	DECLARE @districtZone UNIQUEIDENTIFIER
	SET @districtZone = 'CAC5D55A-794F-4FBE-9D91-8B9E2CE13DD2'
	DECLARE @schoolzone UNIQUEIDENTIFIER
	SET @schoolZone = '8ED30018-EFEC-4D22-9E46-8C72EB22AF5A'
	DECLARE @recentSchoolZone UNIQUEIDENTIFIER
	SET @recentSchoolZone = '308E1B1B-DB6C-47EF-B4BD-690D1645ABDE'
	DECLARE @studentZone UNIQUEIDENTIFIER
	SET @studentZone = 'B46252C8-FE46-423A-ACB7-13A1753C04CE'
	DECLARE @recentStudentZone UNIQUEIDENTIFIER
	SET @recentStudentZone = 'ED8587DF-06A3-48A2-BEB6-BC84D42BB77C'

	DECLARE @now DATETIME
	SET @now = GETDATE()

	-- get the user's current security zone for students --
	-------------------------------------------------------
	DECLARE @securityzone UNIQUEIDENTIFIER
	SELECT @securityzone = ID FROM dbo.GetUserZoneForStudents(@userProfileId)
	
	declare @tokens table (Sequence int identity primary key, Raw varchar(100), Cleaned varchar(100))
	insert into @tokens select Item, dbo.Clean(Item, '\') from dbo.Split(@searchTextNormal, ' ') WHERE RTRIM(LTRIM(Item)) != ''
	
	DECLARE @classRosters TABLE(ID UNIQUEIDENTIFIER primary key, SearchText varchar(500))
	INSERT INTO @classRosters 
	SELECT cr.ID, cr.SearchText
	FROM 
		ClassRoster cr JOIN 
		@tokens t on cr.SearchText LIKE '%' + t.Cleaned + '%'
	WHERE 
		(@rosterYearID IS NULL OR @rosterYearID = cr.RosterYearID ) and
		-- Enforce security permissions
		(
			@securityZone = @districtZone or
			(@securityZone = @schoolZone AND 
				cr.ID in (
					select ClassRosterID 
					from dbo.CurrentSchoolZoneClassRosters(@userProfileID, @now)
				)
			) OR 
			(@securityZone = @recentSchoolZone AND
				cr.ID in (
					select ClassRosterID 
					from dbo.RecentSchoolZoneClassRosters(@userProfileID, @now)
				)
			) OR
			(@securityZone = @studentZone AND 
				cr.ID IN (
					SELECT ClassRosterID 
					FROM dbo.CurrentStudentsZoneClassRosters(@userProfileID, @now)
				)
			) OR
			(@securityZone = @recentStudentZone AND 
				cr.ID IN (
					SELECT ClassRosterID 
					FROM dbo.RecentStudentsZoneClassRosters(@userProfileID, @now)
				)
			)
		)
	GROUP BY
		cr.ID, cr.SearchText
	HAVING
		count(*) = (select count(*) from @tokens)

	IF @fetchAll = 1
	BEGIN
		SELECT 
			cr.*
		FROM 
			ClassRoster cr JOIN 
			(
				SELECT 
					cr.ID, Confidence = MAX(Confidence)
				FROM 
					@classRosters cr
				JOIN 
					dbo.GetPermutationsOfSearchTerms(@searchTextNormal) terms on 
						cr.SearchText LIKE terms.Pattern
				GROUP BY 
					cr.ID
			) c on c.ID = cr.ID 
		ORDER BY 
			Confidence DESC, cr.SearchText
	END
	ELSE
	BEGIN
		SELECT 
			cr.*
		FROM 
			ClassRoster cr JOIN 
			(
				SELECT 
					TOP 5 cr.ID, cr.SearchText, Confidence = MAX(Confidence)
				FROM 
					@classRosters cr
				JOIN 
					dbo.GetPermutationsOfSearchTerms(@searchTextNormal) terms on 
						cr.SearchText LIKE terms.Pattern
				GROUP BY 
					cr.ID, cr.SearchText
				ORDER BY 
					MAX(Confidence) DESC, SearchText
			) c on c.ID = cr.ID 
		ORDER BY 
			Confidence DESC, cr.SearchText
	END


GO
