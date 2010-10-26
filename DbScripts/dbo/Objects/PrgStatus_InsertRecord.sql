SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PrgStatus_InsertRecord]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[PrgStatus_InsertRecord]
GO

 /*
<summary>
Inserts a new record into the PrgStatus table with the specified values
</summary>
<param name="programId">Value to assign to the ProgramID field of the record</param>
<param name="sequence">Value to assign to the Sequence field of the record</param>
<param name="name">Value to assign to the Name field of the record</param>
<param name="isExit">Value to assign to the IsExit field of the record</param>
<param name="isEntry">Value to assign to the IsEntry field of the record</param>
<param name="deletedDate">Value to assign to the DeletedDate field of the record</param>
<param name="statusStyleId">Value to assign to the StatusStyleID field of the record</param>
<returns>The identifiers for the inserted record</returns>
<model isGenerated="False" returnType="System.Guid" />
*/
CREATE PROCEDURE dbo.PrgStatus_InsertRecord	
	@programId uniqueidentifier, 
	@sequence int, 
	@name varchar(50), 
	@isExit bit, 
	@isEntry bit, 
	@deletedDate datetime, 
	@statusStyleId uniqueidentifier
AS
	DECLARE @id as uniqueidentifier
	SET @id = NewID()
	
	INSERT INTO PrgStatus
	(
		Id, 
		ProgramId, 
		Sequence, 
		Name, 
		IsExit, 
		IsEntry, 
		DeletedDate, 
		StatusStyleId
	)
	VALUES
	(
		@id, 
		@programId, 
		@sequence, 
		@name, 
		@isExit, 
		@isEntry, 
		@deletedDate, 
		@statusStyleId
	)

	IF @isExit = 0
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

	SELECT @id
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

