IF EXISTS (SELECT name
		FROM sysobjects
		WHERE name = N'Report_InsertRecord'
		AND type = 'P')
DROP PROCEDURE dbo.Report_InsertRecord
GO

/*
<summary>
Inserts a new record into the Report table with the specified values
</summary>
<param name="owner">Value to assign to the Owner field of the record</param>
<param name="isPublished">Value to assign to the IsPublished field of the record</param>
<param name="securityZone">Value to assign to the SecurityZone field of the record</param>
<param name="isSharingEnabled">Value to assign to the IsSharingEnabled field of the record</param>
<param name="isSharedWithEveryone">Value to assign to the IsSharedWithEveryone field of the record</param>
<param name="runAsOwner">Value to assign to the RunAsOwner field of the record</param>
<returns>The identifiers for the inserted record</returns>
<model isGenerated="False" returnType="System.Guid" />
*/
CREATE PROCEDURE dbo.Report_InsertRecord
	@id uniqueidentifier,
	@owner uniqueidentifier, 
	@isPublished bit, 
	@securityZone uniqueidentifier, 
	@isSharingEnabled bit, 
	@isSharedWithEveryone bit, 
	@runAsOwner bit,
	@isHidden bit,
	@omitNulls bit
AS

INSERT INTO Report
	(
		Id, 
		Owner, 
		IsPublished, 
		SecurityZone, 
		IsSharingEnabled, 
		IsSharedWithEveryone, 
		RunAsOwner, 
		IsHidden,
		OmitNulls
	)
	VALUES
	(
		@id, 
		@owner, 
		@isPublished, 
		@securityZone, 
		@isSharingEnabled, 
		@isSharedWithEveryone, 
		@runAsOwner, 
		@isHidden,
		@omitNulls
	)

	SELECT @id

GO

