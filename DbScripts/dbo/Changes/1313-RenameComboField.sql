-- Rename input item type and add new record
INSERT INTO FormTemplateInputItemType SELECT 'C370EAF0-2440-465B-9833-48B8D5A4C967', 'SingleSelect'
UPDATE FormTemplateInputItemType SET Name = 'MultiSelect' WHERE ID = 'DFA147B7-C16D-4422-86DA-F2F2D43E9A24'

-- Rename field and option tables
EXEC SP_RENAME @objname = '[FormTemplateInputComboField]', @newname = 'FormTemplateInputSelectField'
GO
EXEC SP_RENAME @objname = '[FormTemplateInputComboFieldOption]', @newname = 'FormTemplateInputSelectFieldOption'
GO
EXEC SP_RENAME @objname = '[FormInputComboSelection]', @newname = 'FormInputSelection'
GO

-- rename constraints
exec sp_rename @objname = 'PK_FormTemplateInputComboField', @newname = 'PK_FormTemplateInputSelectField'
GO
exec sp_rename @objname = 'FK_FormTemplateInputComboField_FormTemplateInputItem', @newname = 'FK_FormTemplateInputSelectField_FormTemplateInputItem'
GO
exec sp_rename @objname = 'FormTemplateInputSelectFieldOption.ComboFieldId', @newname = 'SelectFieldId'
GO
exec sp_rename @objname = 'PK_FormTemplateInputComboFieldOption', @newname = 'PK_FormTemplateInputSelectFieldOption'
GO
exec sp_rename @objname = 'FK_FormTemplateInputComboFieldOption#ComboField#Options', @newname = 'FK_FormTemplateInputSelectFieldOption#SelectField#Options'
GO
exec sp_rename @objname = 'FK_FormTemplateInputComboFieldOption#Instance', @newname = 'FK_FormTemplateInputSelectFieldOption#Instance'
GO
exec sp_rename @objname = 'PK_FormInputComboSelection', @newname = 'PK_FormInputSelection'
GO
exec sp_rename @objname = 'FK_FormInputComboSelection#Option#Selections', @newname = 'FK_FormInputSelection#Option#Selections'
GO
exec sp_rename @objname = 'FK_FormInputComboSelection#Value#SelectedOptions', @newname = 'FK_FormInputSelection#Value#SelectedOptions'
GO

-- drop sprocs
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[FormTemplateInputComboFieldOption_DeleteRecordsForFormInputComboSelectionAssociation]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[FormTemplateInputComboFieldOption_DeleteRecordsForFormInputComboSelectionAssociation]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[FormTemplateInputComboFieldOption_GetRecordsByComboField]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[FormTemplateInputComboFieldOption_GetRecordsByComboField]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[FormTemplateInputComboFieldOption_GetRecordsForFormInputComboSelectionAssociation]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[FormTemplateInputComboFieldOption_GetRecordsForFormInputComboSelectionAssociation]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[FormTemplateInputComboField_DeleteRecord]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[FormTemplateInputComboField_DeleteRecord]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[FormTemplateInputComboField_GetAllRecords]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[FormTemplateInputComboField_GetAllRecords]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[FormTemplateInputComboField_GetRecords]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[FormTemplateInputComboField_GetRecords]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[FormTemplateInputComboField_InsertRecord]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[FormTemplateInputComboField_InsertRecord]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[FormTemplateInputComboField_UpdateRecord]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[FormTemplateInputComboField_UpdateRecord]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[FormTemplateInputComboFieldOption_DeleteRecord]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[FormTemplateInputComboFieldOption_DeleteRecord]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[FormTemplateInputComboFieldOption_GetAllRecords]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[FormTemplateInputComboFieldOption_GetAllRecords]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[FormTemplateInputComboFieldOption_GetRecords]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[FormTemplateInputComboFieldOption_GetRecords]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[FormTemplateInputComboFieldOption_GetRecordsByFormInstanceId]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[FormTemplateInputComboFieldOption_GetRecordsByFormInstanceId]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[FormTemplateInputComboFieldOption_InsertRecord]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[FormTemplateInputComboFieldOption_InsertRecord]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[FormTemplateInputComboFieldOption_InsertRecordsForFormInputComboSelectionAssociation]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[FormTemplateInputComboFieldOption_InsertRecordsForFormInputComboSelectionAssociation]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[FormTemplateInputComboFieldOption_UpdateRecord]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[FormTemplateInputComboFieldOption_UpdateRecord]
GO

-- Add single select value
CREATE TABLE [dbo].[FormInputSingleSelectValue](
	[Id] [UNIQUEIDENTIFIER] NOT NULL,
	[SelectedOptionId] [UNIQUEIDENTIFIER] NULL,
CONSTRAINT [PK_FormInputSingleSelectValue] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[FormInputSingleSelectValue]
WITH CHECK ADD CONSTRAINT [FK_FormInputSingleSelectValue#SelectedOption#]
FOREIGN KEY([SelectedOptionId])
REFERENCES [dbo].[FormTemplateInputSelectFieldOption] ([ID])
GO

ALTER TABLE [dbo].[FormInputSingleSelectValue] CHECK CONSTRAINT [FK_FormInputSingleSelectValue#SelectedOption#]
GO

ALTER TABLE [dbo].[FormInputSingleSelectValue]
WITH NOCHECK ADD CONSTRAINT [FK_FormInputSingleSelectValue_FormInputValue]
FOREIGN KEY([Id])
REFERENCES [dbo].[FormInputValue] ([Id])
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[FormInputSingleSelectValue] CHECK CONSTRAINT [FK_FormInputSingleSelectValue_FormInputValue]
GO
