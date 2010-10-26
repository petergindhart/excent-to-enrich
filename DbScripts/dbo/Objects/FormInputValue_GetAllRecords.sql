/****** Object:  StoredProcedure [dbo].[FormInputValue_GetAllRecords]    Script Date: 05/13/2008 09:50:17 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[FormInputValue_GetAllRecords]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[FormInputValue_GetAllRecords]
GO

/****** Object:  StoredProcedure [dbo].[FormInputValue_GetAllRecords]    Script Date: 04/22/2008 15:50:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 /*
<summary>
Gets all records from the FormInputValue table
</summary>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[FormInputValue_GetAllRecords]
AS
	SELECT
		f.*,
		fi.TypeId
	FROM
		FormInputValue f JOIN
		FormTemplateInputItem fi on f.InputFieldId = fi.Id