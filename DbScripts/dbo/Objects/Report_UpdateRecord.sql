if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Report_UpdateRecord]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Report_UpdateRecord]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


/*
<summary>
Updates a record in the Report table with the specified values
</summary>
<param name="id">Value to assign to the Id field of the record</param>
<param name="owner">Value to assign to the Owner field of the record</param>
<param name="isPublished">Value to assign to the IsPublished field of the record</param>
<param name="securityZone">Value to assign to the SecurityZone field of the record</param>
<param name="isSharingEnabled">Value to assign to the IsSharingEnabled field of the record</param>
<param name="isSharedWithEveryone">Value to assign to the IsSharedWithEveryone field of the record</param>
<param name="runAsOwner">Value to assign to the RunAsOwner field of the record</param>
<param name="isHidden">Value to assign to the IsHidden field of the record</param>
<param name="omitNulls">Value to assign to the OmitNulls field of the record</param>

<model isGenerated="False" returnType="System.Void" />
*/
CREATE PROCEDURE dbo.Report_UpdateRecord
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
	UPDATE Report
	SET
		Owner = @owner, 
		IsPublished = @isPublished, 
		SecurityZone = @securityZone, 
		IsSharingEnabled = @isSharingEnabled, 
		IsSharedWithEveryone = @isSharedWithEveryone, 
		RunAsOwner = @runAsOwner, 
		IsHidden = @isHidden, 
		OmitNulls = @omitNulls
	WHERE 
		Id = @id

GO
