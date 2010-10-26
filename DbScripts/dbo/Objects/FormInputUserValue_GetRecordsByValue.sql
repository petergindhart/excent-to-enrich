IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[FormInputUserValue_GetRecordsByValue]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[FormInputUserValue_GetRecordsByValue]
GO

/*
<summary>
Gets records from the FormInputUserValue table
	and inherited data from:FormInputValue
with the specified ids
</summary>
<param name="ids">Ids of the UserProfile(s) to retrieve</param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="True" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[FormInputUserValue_GetRecordsByValue]
	@ids	uniqueidentifierarray
AS
	SELECT
		f.ValueId,
		f1.*,
		f.*,
		i.TypeId
	FROM
		FormInputUserValue f INNER JOIN
		FormInputValue f1 ON f.Id = f1.Id INNER JOIN
		FormTemplateInputItem i on f1.InputFieldId = i.Id INNER JOIN
		GetUniqueidentifiers(@ids) Keys ON f.ValueId = Keys.Id
GO