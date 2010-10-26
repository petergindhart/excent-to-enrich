IF EXISTS(
	SELECT * 
	FROM SYSOBJECTS 
	WHERE ID = OBJECT_ID('dbo.PrgSimplePlan_UpdateRecord') AND
	TYPE = 'P')
DROP PROCEDURE dbo.PrgSimplePlan_UpdateRecord
GO

/*
<summary>
Updates a record in the PrgSimplePlan table with the specified values
</summary>
<param name="id">Value to assign to the ID field of the record</param>

<model isGenerated="False" returnType="System.Void" />
*/
CREATE PROCEDURE dbo.PrgSimplePlan_UpdateRecord
	@id uniqueidentifier
AS
GO

