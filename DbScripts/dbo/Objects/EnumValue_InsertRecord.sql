if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[EnumValue_InsertRecord]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[EnumValue_InsertRecord]
GO

/*
<summary>
Inserts a new record into the EnumValue table with the specified values
</summary>
<param name="type">Value to assign to the Type field of the record</param>
<param name="displayValue">Value to assign to the DisplayValue field of the record</param>
<param name="code">Value to assign to the Code field of the record</param>
<param name="isActive">Value to assign to the IsActive field of the record</param>
<returns>The id of the inserted record</returns>
<model isGenerated="False" returnType="System.Void" />
*/
CREATE PROCEDURE dbo.EnumValue_InsertRecord 
	@id as uniqueidentifier,
	@type uniqueidentifier,
	@displayValue varchar(50),
	@code varchar(8),
	@isActive bit,
	@sequence int
AS
	INSERT INTO EnumValue
	(
		Id,
		Type,
		DisplayValue,
		Code,
		IsActive,
		Sequence
	)
	VALUES
	(
		@id,
		@type,
		@displayValue,
		@code,
		@isActive,
		@sequence
	)
GO