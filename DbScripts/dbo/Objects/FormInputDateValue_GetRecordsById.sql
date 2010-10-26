/****** Object:  StoredProcedure [dbo].[FormInputDateValue_GetRecordsById]    Script Date: 01/28/2009 12:53:34 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[FormInputDateValue_GetRecordsById]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[FormInputDateValue_GetRecordsById]
GO

 /*
<summary>
Gets records from the FormInputDateValue table
with the specified ids
</summary>
<param name="ids">Ids of the FormInputValue(s) to retrieve</param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="FALSE" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[FormInputDateValue_GetRecordsById]
	@ids	uniqueidentifierarray
AS
	SELECT
		f1.*,
		f.*,
		i.TypeId		
	FROM
		FormInputDateValue f INNER JOIN
		FormInputValue f1 ON f.ID = f1.Id  JOIN
		FormTemplateInputItem i on f1.InputFieldId = i.Id INNER JOIN
		Gets(@ids) Keys ON f.Id = Keys.Id