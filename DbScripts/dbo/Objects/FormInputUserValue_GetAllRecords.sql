IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[FormInputUserValue_GetAllRecords]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[FormInputUserValue_GetAllRecords]
GO

/*
<summary>
Gets all records from the FormInputUserValue table
	and inherited data from:FormInputValue
</summary>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="True" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[FormInputUserValue_GetAllRecords]
AS
	SELECT
		f1.*,
		f.*,
		i.TypeId
	FROM
		FormInputUserValue f INNER JOIN
		FormInputValue f1 ON f.Id = f1.Id INNER JOIN
		FormTemplateInputItem i on f1.InputFieldId = i.Id
GO
