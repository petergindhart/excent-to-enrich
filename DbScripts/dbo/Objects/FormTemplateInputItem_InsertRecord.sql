if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FormTemplateInputItem_InsertRecord]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[FormTemplateInputItem_InsertRecord]
GO

 /*
<summary>
Inserts a new record into the FormTemplateInputItem table with the specified values
</summary>
<param name="inputAreaId">Value to assign to the InputAreaId field of the record</param>
<param name="label">Value to assign to the Label field of the record</param>
<param name="sequence">Value to assign to the Sequence field of the record</param>
<param name="parentId">Value to assign to the ParentId field of the record</param>
<param name="typeId">Value to assign to the TypeId field of the record</param>
<param name="enabledCondition">Value to assign to the EnabledCondition field of the record</param>
<param name="code">Value to assign to the Code field of the record</param>
<returns>The identifiers for the inserted record</returns>
<model isGenerated="False" returnType="System.Guid" />
*/
CREATE PROCEDURE [dbo].[FormTemplateInputItem_InsertRecord]	
	@inputAreaId uniqueidentifier, 
	@label varchar(500), 
	@sequence int, 
	@parentId uniqueidentifier, 
	@typeId uniqueidentifier, 
	@enabledCondition varchar(200),
	@control varchar(50),
	@code varchar(25),
	@isRequired bit,
	@format VARCHAR(25)
AS
	DECLARE @id as uniqueidentifier
	SET @id = NewID()

	INSERT INTO FormTemplateInputItem
	(
		Id, 
		InputAreaId, 
		Label, 
		Sequence, 
		ParentId, 
		TypeId, 
		EnabledCondition,
		[Control],
		Code,
		IsRequired,
		Format
	)
	VALUES
	(
		@id, 
		@inputAreaId, 
		@label, 
		@sequence, 
		@parentId, 
		@typeId, 
		@enabledCondition,
		@control,
		@code,
		@isRequired,
		@format
	)



	if @typeId <> '1A34E676-A018-462B-86D1-3F9A879DC4EF'
	BEGIN
		-- Add input values to all templates that use this input item (except for Sections)
		insert into FormInputValue(Id, IntervalId, InputFieldId)
		select newid(), fii.ID, @id
		from
			FormInterval i join
			FormInstanceInterval fii on i.ID = fii.IntervalID join
			FormInstance fi on fi.Id = fii.InstanceID join
			FormTemplateLayout layout on layout.TemplateId = fi.TemplateID left join
			FormTemplateControlProperty cci on cci.ControlID = layout.ControlID and cci.Name = 'CollectCummulativeIntervals'
		where
			layout.ControlID = @inputAreaId and (i.CumulativeUpTo is null or cci.Value = 'True')
	END

	if @typeId = 'FAB80418-B934-479D-B877-17A7FB3AC14B' -- Text
	begin
		insert FormInputTextValue(Id, Value)
		select Id, null
		from FormInputValue
		where InputFieldId = @id
	
	end

	else if @typeId = '5E0ABD0C-DF05-4582-9D5E-92F1C87C6C52' -- Flag
	begin
		insert FormInputFlagValue(Id, Value)
		select Id, 0
		from FormInputValue
		where InputFieldId = @id
	end

	else if @typeId = 'E519285A-41EA-45AE-9876-BE3EF2F29B3F' -- EnumValue
	begin
		insert FormInputEnumValue(Id, EnumValueId)
		select Id, null
		from FormInputValue
		where InputFieldId = @id
	end

	else if @typeId = '0398DDB0-10AE-4290-999A-9553FBC8F55B' -- DateValue
	begin
		insert FormInputDateValue(Id, Value)
		select Id, null
		from FormInputValue
		where InputFieldId = @id
	end
	
	else if @typeId = 'C370EAF0-2440-465B-9833-48B8D5A4C967' -- SingleSelectValue
	begin
		insert FormInputSingleSelectValue(Id, SelectedOptionId)
		select Id, null
		from FormInputValue
		where InputFieldId = @id
	end
	
	else if @typeId = 'DFA147B7-C16D-4422-86DA-F2F2D43E9A24' -- MultiSelectValue
	begin
		-- no specific sub class table
		DECLARE @noOp INT
	end
	
	else if @typeId = '645E64CE-6380-497C-AFC7-A629B23EDD9A' -- PersonValue
	begin
		insert FormInputPersonValue(Id, ValueID)
		select Id, null
		from FormInputValue
		where InputFieldId = @id
	end
	
	else if @typeId = '7F437BDE-91CE-4304-AD03-0CB2097CE62A' -- UserValue
	begin
		insert FormInputUserValue(Id, ValueID)
		select Id, null
		from FormInputValue
		where InputFieldId = @id
	end
	
	else if @typeId <> '1A34E676-A018-462B-86D1-3F9A879DC4EF' -- Section
	begin
		DECLARE @error varchar(1000)
		SET @error = 'Cannot create instance field for this FormTemplateInputItemType: ' + CAST(@typeId AS VARCHAR(40))
		raiserror(@error, 16, 1)
	end
	
SELECT @id
