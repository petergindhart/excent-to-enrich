SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FormInputFlagValue_GetAllRecords]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[FormInputFlagValue_GetAllRecords]
GO


/*
<summary>
Gets all records from the FormInputFlagValue table
	and inherited data from:FormInputValue
</summary>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="True" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE dbo.FormInputFlagValue_GetAllRecords
AS
	SELECT
		f1.*,
		f.*,
		i.TypeId
	FROM
		FormInputFlagValue f INNER JOIN
		FormInputValue f1 ON f.Id = f1.Id JOIN
		FormTemplateInputItem i on f1.InputFieldId = i.Id

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
