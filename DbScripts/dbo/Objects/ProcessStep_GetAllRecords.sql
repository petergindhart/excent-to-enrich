IF EXISTS (SELECT name 
	   FROM   sysobjects 
	   WHERE  name = N'ProcessStep_GetAllRecords' 
	   AND 	  type = 'P')
    DROP PROCEDURE dbo.ProcessStep_GetAllRecords
GO

/*
<summary>
</summary>

<returns></returns>

<model  isGenerated="false" 
        returnType="System.Data.IDataReader" 
        />
*/
CREATE PROCEDURE dbo.ProcessStep_GetAllRecords 
AS
	SELECT *
	FROM ProcessStep

GO
