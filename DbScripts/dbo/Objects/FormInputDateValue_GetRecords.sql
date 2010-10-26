/****** Object:  StoredProcedure [dbo].[FormInputDateValue_GetRecords]    Script Date: 01/28/2009 12:53:16 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[FormInputDateValue_GetRecords]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[FormInputDateValue_GetRecords]
GO

 /*
<summary>
Gets records from the FormInputDateValue table
	and inherited data from:FormInputValue
with the specified id's
</summary>
<param name="ids">Ids of the records to retrieve</param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="FALSE" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[FormInputDateValue_GetRecords]
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
		GetUniqueidentifiers(@ids) Keys ON f.Id = Keys.Id