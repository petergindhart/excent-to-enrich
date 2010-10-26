-- =============================================
-- Create procedure basic template
-- =============================================
-- creating the store procedure
IF EXISTS (SELECT name 
	   FROM   sysobjects 
	   WHERE  name = N'DbTableAuthenticator_Authenticate' 
	   AND 	  type = 'P')
    DROP PROCEDURE DbTableAuthenticator_Authenticate
GO


/*
<summary>Validates a user's password</summary>
<param name="userProfileId">The user profile to authenticate</param>
<param name="password">The password to verify</param>
<returns>User record, if any, of the user that matches the specified credentials</returns>
<model returnType="System.Data.IDataReader"></model>
*/
CREATE PROCEDURE dbo.DbTableAuthenticator_Authenticate 
	@username varchar(200), 
	@password binary(20)
AS

	select u.*, p.DateChanged
	from 
		UserProfileView u join
		UserPassword p on p.UserProfileID = u.ID join
		(
			select UserProfileID, max(DateChanged) DateChanged
			from UserPassword
			group by UserProfileID
		) Latest on Latest.DateChanged = p.DateChanged and 
			Latest.UserProfileID = p.UserProfileID
	where
		u.Username = @username and
		p.Password = @password	
GO