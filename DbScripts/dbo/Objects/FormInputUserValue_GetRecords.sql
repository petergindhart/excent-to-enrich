IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[FormInputUserValue_GetRecords]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[FormInputUserValue_GetRecords]
GO

/*
<summary>
Gets records from the FormInputUserValue table
	and inherited data from:FormInputValue
with the specified id's
</summary>
<param name="ids">Ids of the records to retrieve</param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="True" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[FormInputUserValue_GetRecords]
	@ids	uniqueidentifierarray
AS
	SELECT	
		f1.*,
		f.*,
		i.TypeId
	FROM
		FormInputUserValue f INNER JOIN
		FormInputValue f1 ON f.Id = f1.Id INNER JOIN
		FormTemplateInputItem i on f1.InputFieldId = i.Id INNER JOIN
		GetUniqueidentifiers(@ids) Keys ON f.Id = Keys.Id
GO