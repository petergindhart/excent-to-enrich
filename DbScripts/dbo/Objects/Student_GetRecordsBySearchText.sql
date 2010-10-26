if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Student_GetRecordsBySearchText]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Student_GetRecordsBySearchText]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
<summary>
Gets records from the Student table that match the specified search text
</summary>
<param name="searchText">The text to search for</param>
<param name="includeHistoricalData">Indicates whether to search for students who are not currently enrolled</param>
<param name="userProfileID">The user who is performing the search</param>
<returns>List of matching students</returns>
<model returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[Student_GetRecordsBySearchText]
	@searchText VARCHAR(100), @includeHistoricalData BIT, @fetchAll BIT, @userProfileID UNIQUEIDENTIFIER
AS
	DECLARE @now DATETIME
	SET @now = GETDATE()

	DECLARE @searchTextNormal VARCHAR(200)
	SET @searchTextNormal = REPLACE(REPLACE(LTRIM(RTRIM(@searchText)), ',', ''), '-', ' ')	
	

	-- 1) get the list of students that this user can view (except for users in the district zone) --
	-------------------------------------------------------------------------------------------------
	DECLARE @districtzone UNIQUEIDENTIFIER
	SET @districtZone = 'CAC5D55A-794F-4FBE-9D91-8B9E2CE13DD2'
	DECLARE @schoolzone UNIQUEIDENTIFIER
	SET @schoolZone = '8ED30018-EFEC-4D22-9E46-8C72EB22AF5A'
	DECLARE @recentSchoolZone UNIQUEIDENTIFIER
	SET @recentSchoolZone = '308E1B1B-DB6C-47EF-B4BD-690D1645ABDE'
	DECLARE @studentZone UNIQUEIDENTIFIER
	SET @studentZone = 'B46252C8-FE46-423A-ACB7-13A1753C04CE'
	DECLARE @recentStudentZone UNIQUEIDENTIFIER
	SET @recentStudentZone = 'ED8587DF-06A3-48A2-BEB6-BC84D42BB77C'

	DECLARE @securityzone UNIQUEIDENTIFIER
	SELECT @securityzone = ID FROM dbo.GetUserZoneForStudents(@userProfileId)

	DECLARE @visibleStudents TABLE(ID UNIQUEIDENTIFIER)
	
	IF @securityZone = @schoolZone
	BEGIN
		INSERT INTO @visibleStudents
		SELECT DISTINCT StudentID from dbo.CurrentSchoolZoneStudents(@userProfileID, @now)
	END
	ELSE IF @securityZone = @recentSchoolZone
	BEGIN
		INSERT INTO @visibleStudents
		SELECT DISTINCT StudentID from dbo.RecentSchoolZoneStudents(@userProfileID, @now)
	END
	ELSE IF @securityZone = @studentZone
	BEGIN
		INSERT INTO @visibleStudents
		SELECT DISTINCT StudentID FROM dbo.CurrentStudentsZoneStudents(@userProfileID, @now)
	END
	ELSE IF @securityZone = @recentStudentZone
	BEGIN
		INSERT INTO @visibleStudents
		SELECT DISTINCT StudentID FROM dbo.RecentStudentsZoneStudents(@userProfileID, @now)
	END

	-- 2) do a first pass filter based on simple token matches --
	----------------------------------------------------------
	declare @tokens table (Sequence int identity primary key, Raw varchar(100), Cleaned varchar(100))
	insert into @tokens select Item, dbo.Clean(Item, '\') from dbo.Split(@searchTextNormal, ' ') WHERE RTRIM(LTRIM(Item)) != ''
	
	DECLARE @students TABLE(ID UNIQUEIDENTIFIER primary key, SearchText varchar(500))
	INSERT INTO @students 
	SELECT s.ID, REPLACE(REPLACE(s.FirstName + ' ' + s.LastName, ',', ''), '-', ' ')
	FROM
		Student s JOIN 
		@tokens t on REPLACE(REPLACE(s.FirstName + ' ' + s.LastName, ',', ''), '-', ' ') LIKE '%' + t.Cleaned + '%' LEFT OUTER JOIN 
		@visibleStudents v ON v.ID = s.ID
	WHERE 
		(@includeHistoricalData = 1 OR IsActive = 1) and
		(@securityZone = @districtzone or v.ID IS NOT NULL) -- Enforce security permissions
	GROUP BY
		s.ID, s.FirstName, s.LastName
	HAVING
		-- make sure the student matches all tokens (in any order)
		count(*) = (select count(*) from @tokens)
		

	-- 3) final filtering step which includes more sophisticated pattern matching and ranking --
	--------------------------------------------------------------------------------------------
	IF @fetchAll = 1
	BEGIN
		SELECT 
			s.* 
		FROM 
			Student s JOIN
			(
				SELECT 
					s.ID, 
					Confidence = MAX(Confidence)
				FROM 
					@students s JOIN 
					dbo.GetPermutationsOfSearchTerms(@searchTextNormal) terms on s.SearchText LIKE terms.Pattern
				GROUP BY 
					s.Id, SearchText
			) t ON t.ID = s.ID
		ORDER BY 
			Confidence DESC, FirstName, LastName

	END
	ELSE
	BEGIN
		SELECT 
			s.* 
		FROM 
			Student s JOIN
			(
				SELECT 
					TOP 5 s.ID, 
					Confidence = MAX(Confidence)
				FROM 
					@students s JOIN 
					dbo.GetPermutationsOfSearchTerms(@searchTextNormal) terms on s.SearchText LIKE terms.Pattern
				GROUP BY 
					s.Id, SearchText
				ORDER BY 
					MAX(Confidence) DESC, SearchText
			) t ON t.ID = s.ID
		ORDER BY 
			Confidence DESC, FirstName, LastName
	END
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
