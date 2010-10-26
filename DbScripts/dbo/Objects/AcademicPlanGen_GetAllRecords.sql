
IF EXISTS (SELECT name 
	   FROM   sysobjects 
	   WHERE  name = N'AcademicPlanGen_GetAllRecords' 
	   AND 	  type = 'P')
    DROP PROCEDURE dbo.AcademicPlanGen_GetAllRecords
GO

/*
<summary>
Get all AcademicPlanGen records
</summary>

<returns></returns>

<model  isGenerated="false" 
        returnType="System.Data.IDataReader" 
        />
*/
CREATE PROCEDURE dbo.AcademicPlanGen_GetAllRecords 
AS
	SELECT *
	from AcademicPlanGen
GO
