if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FormTemplateInputComboFieldOption_GetAvailableOptionsForForFieldAndInstance]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[FormTemplateInputComboFieldOption_GetAvailableOptionsForForFieldAndInstance]
GO
