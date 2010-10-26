SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[EnumType_InsertRecord]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[EnumType_InsertRecord]
GO


/*
<summary>
Inserts a new record into the EnumType table with the specified values
</summary>
<param name="type">Value to assign to the Type field of the record</param>
<param name="isCustom">Value to assign to the IsCustom field of the record</param>
<returns>The identifiers for the inserted record</returns>
<model isGenerated="False" returnType="System.Void" />
*/
CREATE PROCEDURE [dbo].[EnumType_InsertRecord] 
	@id as uniqueidentifier,
	@type varchar(50),
	@isCustom bit,
	@isEditable bit = 0,
	@displayName varchar(100) = NULL
AS
INSERT INTO EnumType
	(

		ID,
		Type,
		IsCustom,
		IsEditable, 
		DisplayName
	)
	VALUES
	(

		@id,
		@type,
		@isCustom, 
		@isEditable,
		@displayName
	)

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

