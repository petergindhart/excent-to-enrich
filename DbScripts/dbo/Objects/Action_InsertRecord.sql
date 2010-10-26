if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Action_InsertRecord]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Action_InsertRecord]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO






/*
<summary>
Inserts a new record into the Action table with the specified values
</summary>
<param name="name">Value to assign to the Name field of the record</param>
<param name="abbreviation">Value to assign to the Abbreviation field of the record</param>
<param name="text">Value to assign to the Text field of the record</param>
<param name="isDefault">Value to assign to the IsDefault field of the record</param>
<param name="isCustom">Value to assign to the IsCustom field of the record</param>
<param name="actionCategoryID">Value to assign to the ActionCategoryID field of the record</param>
<returns>The id of the inserted record</returns>
<model isGenerated="False" returnType="System.Guid" />
*/
CREATE PROCEDURE dbo.Action_InsertRecord 
	@name varchar(1000),
	@abbreviation varchar(8),
	@text text,
	@isDefault bit,
	@isCustom bit,
	@actionCategoryID uniqueidentifier,
	@templateID uniqueidentifier
AS
	DECLARE @id as uniqueidentifier
	SET @id = NewID()

	INSERT INTO Action
	(
		Id,
		Name,
		Abbreviation,
		Text,
		IsDefault,
		IsCustom,
		ActionCategoryID,
		TemplateID
	)
	VALUES
	(
		@id,
		@name,
		@abbreviation,
		@text,
		@isDefault,
		@isCustom,
		@actionCategoryID,
		@templateID
	)

	IF(@isCustom = 0)
	BEGIN
		-- Add action to existing plans
		insert into AcademicPlanAction
		select newid(), ID, @id, 0
		from AcademicPlan
	END

	SELECT @id

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

