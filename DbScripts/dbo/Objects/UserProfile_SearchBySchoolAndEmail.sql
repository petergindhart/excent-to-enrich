if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[UserProfile_SearchBySchoolAndEmail]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[UserProfile_SearchBySchoolAndEmail]
GO

/*
<summary>
Locates a user by email address
</summary>
<param name="currentSchool">Compared to the teachers current school</param>
<param name="emailAddress">Compared to the teachers email address</param>
<returns>Matching users</returns>
<model isGenerated="false" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE dbo.UserProfile_SearchBySchoolAndEmail
	@currentSchool uniqueidentifier,
	@emailAddress varchar(60)
AS
	SELECT *
	FROM UserProfileView
	WHERE 
		EmailAddress = @emailAddress AND
		SchoolID IS NOT NULL AND SchoolID = @currentSchool AND
		Deleted is null
GO
