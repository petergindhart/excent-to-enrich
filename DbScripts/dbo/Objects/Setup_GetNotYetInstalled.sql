
IF EXISTS (SELECT name 
	   FROM   sysobjects 
	   WHERE  name = N'Setup_GetNotYetInstalled' 
	   AND 	  type = 'P')
    DROP PROCEDURE dbo.Setup_GetNotYetInstalled
GO

/*
<summary>

</summary>

<returns></returns>

<model  isGenerated="false" 
        returnType="System.Data.IDataReader" 
        />
*/
CREATE PROCEDURE dbo.Setup_GetNotYetInstalled
AS
	SELECT s.*
	FROM 
		Setup s
	WHERE
		InstallDate IS NULL
GO
