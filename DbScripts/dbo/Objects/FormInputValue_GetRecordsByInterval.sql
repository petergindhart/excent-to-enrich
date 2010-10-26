/****** Object:  StoredProcedure [dbo].[FormInputValue_GetRecordsByInterval]    Script Date: 05/13/2008 09:51:09 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[FormInputValue_GetRecordsByInterval]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[FormInputValue_GetRecordsByInterval]
GO

/****** Object:  StoredProcedure [dbo].[FormInputValue_GetRecordsByInterval]    Script Date: 04/22/2008 15:55:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 /*
<summary>
Gets records from the FormInputValue table
with the specified ids
</summary>
<param name="ids">Ids of the FormInstanceInterval(s) to retrieve</param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[FormInputValue_GetRecordsByInterval]
	@ids	uniqueidentifierarray
AS
	SELECT
		f.IntervalId,
		f.*,
		fi.TypeId
	FROM
		FormInputValue f JOIN
		FormTemplateInputItem fi on f.InputFieldId = fi.Id INNER JOIN
		GetUniqueidentifiers(@ids) Keys ON f.IntervalId = Keys.Id