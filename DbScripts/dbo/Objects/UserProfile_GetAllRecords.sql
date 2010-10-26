
IF EXISTS (SELECT name 
	   FROM   sysobjects 
	   WHERE  name = N'UserProfile_GetAllRecords' 
	   AND 	  type = 'P')
    DROP PROCEDURE dbo.UserProfile_GetAllRecords
GO

/*
<summary>
Retrieves all UserProfile records
</summary>

<returns></returns>

<model  isGenerated="false" 
        returnType="System.Data.IDataReader" 
        />
*/
CREATE PROCEDURE dbo.UserProfile_GetAllRecords 
AS
	SELECT *
	FROM UserProfileView u
	WHERE u.Deleted IS NULL
GO
