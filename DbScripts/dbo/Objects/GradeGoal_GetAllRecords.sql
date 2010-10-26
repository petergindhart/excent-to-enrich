
IF EXISTS (SELECT name 
	   FROM   sysobjects 
	   WHERE  name = N'GradeGoal_GetAllRecords' 
	   AND 	  type = 'P')
    DROP PROCEDURE dbo.GradeGoal_GetAllRecords
GO

/*
<summary>
</summary>

<returns></returns>

<model  isGenerated="false" 
        returnType="System.Data.IDataReader" 
        />
*/
CREATE PROCEDURE dbo.GradeGoal_GetAllRecords 
AS
	SELECT *
	FROM GradeGoal
GO
