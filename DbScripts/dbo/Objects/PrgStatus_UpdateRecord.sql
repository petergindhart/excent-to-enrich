SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PrgStatus_UpdateRecord]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[PrgStatus_UpdateRecord]
GO

 /*
<summary>
Updates a record in the PrgStatus table with the specified values
</summary>
<param name="id">Value to assign to the ID field of the record</param>
<param name="programId">Value to assign to the ProgramID field of the record</param>
<param name="sequence">Value to assign to the Sequence field of the record</param>
<param name="name">Value to assign to the Name field of the record</param>
<param name="isExit">Value to assign to the IsExit field of the record</param>
<param name="isEntry">Value to assign to the IsEntry field of the record</param>
<param name="deletedDate">Value to assign to the DeletedDate field of the record</param>
<param name="statusStyleId">Value to assign to the StatusStyleID field of the record</param>

<model isGenerated="False" returnType="System.Void" />
*/
CREATE PROCEDURE dbo.PrgStatus_UpdateRecord
	@id uniqueidentifier, 
	@programId uniqueidentifier, 
	@sequence int, 
	@name varchar(50), 
	@isExit bit, 
	@isEntry bit, 
	@deletedDate datetime, 
	@statusStyleId uniqueidentifier
AS
	UPDATE PrgStatus
	SET
		ProgramID = @programId, 
		Sequence = @sequence, 
		Name = @name, 
		IsExit = @isExit, 
		IsEntry = @isEntry, 
		DeletedDate = @deletedDate, 
		StatusStyleID = @statusStyleId
	WHERE 
		ID = @id

	IF @isExit = 1
	BEGIN
		-- delete any IntvToolDefStatus records
		DELETE IntvToolDefStatus
		WHERE StatusID = @id
	END
	ELSE IF NOT EXISTS ( SELECT * FROM IntvToolDefStatus WHERE StatusID = @id )
	BEGIN
		-- create IntvToolDefStatus records
		INSERT INTO IntvToolDefStatus
		SELECT
			newid()	[ID],
			ID		[DefinitionID],
			@id		[StatusID],
			null	[SettingID],
			0		[AllowCustomSchedules]
		FROM IntvToolDef
	END
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

