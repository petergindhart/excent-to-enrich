
IF EXISTS (SELECT name 
	   FROM   sysobjects 
	   WHERE  name = N'Setup_GetAllRecords' 
	   AND 	  type = 'P')
    DROP PROCEDURE dbo.Setup_GetAllRecords
GO

/*
<summary>

</summary>

<returns></returns>

<model  isGenerated="false" 
        returnType="System.Data.IDataReader" 
        />
*/
CREATE PROCEDURE dbo.Setup_GetAllRecords 
AS
	SELECT *
	FROM Setup
GO
