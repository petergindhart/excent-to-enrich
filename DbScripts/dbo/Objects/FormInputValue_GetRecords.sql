/****** Object:  StoredProcedure [dbo].[FormInputValue_GetRecords]    Script Date: 05/13/2008 09:50:33 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[FormInputValue_GetRecords]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[FormInputValue_GetRecords]
GO

/****** Object:  StoredProcedure [dbo].[FormInputValue_GetRecords]    Script Date: 04/22/2008 15:53:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 /*
<summary>
Gets records from the FormInputValue table
with the specified id's
</summary>
<param name="ids">Ids of the records to retrieve</param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[FormInputValue_GetRecords]
	@ids	uniqueidentifierarray
AS
	SELECT	
		f.*,
		fi.TypeId		
	FROM
		FormInputValue f JOIN
		FormTemplateInputItem fi on f.InputFieldId = fi.Id INNER JOIN
		GetUniqueidentifiers(@ids) Keys ON f.Id = Keys.Id