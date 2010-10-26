/****** Object:  StoredProcedure [dbo].[FormInputTextValue_GetRecords]    Script Date: 05/13/2008 09:49:34 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[FormInputTextValue_GetRecords]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[FormInputTextValue_GetRecords]
GO

/****** Object:  StoredProcedure [dbo].[FormInputTextValue_GetRecords]    Script Date: 04/22/2008 17:44:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 /*
<summary>
Gets records from the FormInputTextValue table
	and inherited data from:FormInputValue
with the specified id's
</summary>
<param name="ids">Ids of the records to retrieve</param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[FormInputTextValue_GetRecords]
	@ids	uniqueidentifierarray
AS
	SELECT	
		f1.*,
		f.*,
		i.TypeId	
	FROM
		FormInputTextValue f INNER JOIN
		FormInputValue f1 ON f.Id = f1.Id JOIN
		FormTemplateInputItem i on f1.InputFieldId = i.Id INNER JOIN
		GetUniqueidentifiers(@ids) Keys ON f.Id = Keys.Id