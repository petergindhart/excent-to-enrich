/****** Object:  StoredProcedure [dbo].[FormInputTextValue_GetAllRecords]    Script Date: 05/13/2008 09:49:10 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[FormInputTextValue_GetAllRecords]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[FormInputTextValue_GetAllRecords]
GO

/****** Object:  StoredProcedure [dbo].[FormInputTextValue_GetAllRecords]    Script Date: 04/22/2008 17:43:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 /*
<summary>
Gets all records from the FormInputTextValue table
	and inherited data from:FormInputValue
</summary>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[FormInputTextValue_GetAllRecords]
AS
	SELECT
		f1.*,
		f.*,
		i.TypeId
	FROM
		FormInputTextValue f INNER JOIN
		FormInputValue f1 ON f.Id = f1.Id JOIN
		FormTemplateInputItem i on f1.InputFieldId = i.Id