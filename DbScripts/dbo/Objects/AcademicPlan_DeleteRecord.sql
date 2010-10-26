IF EXISTS (SELECT name 
	   FROM   sysobjects 
	   WHERE  name = N'AcademicPlan_DeleteRecord' 
	   AND 	  type = 'P')
    DROP PROCEDURE dbo.AcademicPlan_DeleteRecord
GO

 /*
<summary>
Deletes a AcademicPlan record
</summary>

<model isGenerated="False" returnType="System.Void" />
*/
CREATE PROCEDURE dbo.AcademicPlan_DeleteRecord
	@id uniqueidentifier
AS
	DELETE FROM
		Process
	WHERE
		TargetID = @id

	DELETE FROM 
		AcademicPlan
	WHERE
		Id = @id

GO