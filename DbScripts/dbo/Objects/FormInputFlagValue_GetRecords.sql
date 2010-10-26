SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FormInputFlagValue_GetRecords]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[FormInputFlagValue_GetRecords]
GO


/*
<summary>
Gets records from the FormInputFlagValue table
	and inherited data from:FormInputValue
with the specified id's
</summary>
<param name="ids">Ids of the records to retrieve</param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="True" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE dbo.FormInputFlagValue_GetRecords
	@ids	uniqueidentifierarray
AS
	SELECT	
		f1.*,
		f.*,
		i.TypeID
	FROM
		FormInputFlagValue f INNER JOIN
		FormInputValue f1 ON f.Id = f1.Id JOIN
		FormTemplateInputItem i on f1.InputFieldId = i.Id INNER JOIN
		GetUniqueidentifiers(@ids) Keys ON f.Id = Keys.Id

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
