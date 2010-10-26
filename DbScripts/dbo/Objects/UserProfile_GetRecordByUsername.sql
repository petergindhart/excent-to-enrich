SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[UserProfile_GetRecordByUsername]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[UserProfile_GetRecordByUsername]
GO


/*
<summary>
Retrieves a user profile by a username.
</summary>
<param name="username">Username to search by</param>
<returns>Either 0 or 1 user profile records</returns>
<model isGenerated="false" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE dbo.UserProfile_GetRecordByUsername 
	@username varchar(300)
AS
	SELECT *
	FROM UserProfileView
	WHERE Username = @username and Deleted IS NULL

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

