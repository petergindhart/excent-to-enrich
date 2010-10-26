/****** Object:  StoredProcedure [dbo].[FormInputDateValue_GetAllRecords]    Script Date: 01/28/2009 12:50:10 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[FormInputDateValue_GetAllRecords]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[FormInputDateValue_GetAllRecords]
GO

 /*
<summary>
Gets all records from the FormInputDateValue table
</summary>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="FALSE" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[FormInputDateValue_GetAllRecords]
AS
	SELECT
		f1.*,
		f.*,
		i.TypeId
	FROM
		FormInputDateValue f  INNER JOIN
		FormInputValue f1 ON f.Id = f1.Id JOIN
		FormTemplateInputItem i on f1.InputFieldId = i.Id