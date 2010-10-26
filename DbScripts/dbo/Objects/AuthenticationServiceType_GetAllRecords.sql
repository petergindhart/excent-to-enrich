
IF EXISTS (SELECT name 
	   FROM   sysobjects 
	   WHERE  name = N'AuthenticationServiceType_GetAllRecords' 
	   AND 	  type = 'P')
    DROP PROCEDURE dbo.AuthenticationServiceType_GetAllRecords
GO

/*
<summary>
Gets all AuthenticationServiceType records
</summary>

<returns>All AuthenticationServiceType</returns>

<model  isGenerated="false" 
        returnType="System.Data.IDataReader" 
        />
*/
CREATE PROCEDURE dbo.AuthenticationServiceType_GetAllRecords 
AS
	SELECT *
	FROM AuthenticationServiceType
	ORDER BY Name
GO
