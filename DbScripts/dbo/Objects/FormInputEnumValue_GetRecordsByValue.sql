/****** Object:  StoredProcedure [dbo].[FormInputEnumValue_GetRecordsByValue]    Script Date: 04/22/2008 17:43:06 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[FormInputEnumValue_GetRecordsByValue]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[FormInputEnumValue_GetRecordsByValue]
GO

/****** Object:  StoredProcedure [dbo].[FormInputEnumValue_GetRecordsByValue]    Script Date: 04/22/2008 17:42:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 /*
<summary>
Gets records from the FormInputEnumValue table
	and inherited data from:FormInputValue
with the specified ids
</summary>
<param name="ids">Ids of the EnumValue(s) to retrieve</param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[FormInputEnumValue_GetRecordsByValue]
	@ids	uniqueidentifierarray
AS
	SELECT
		f.EnumValueId,
		f1.*,
		f.*,
		i.TypeId
	FROM
		FormInputEnumValue f INNER JOIN
		FormInputValue f1 ON f.Id = f1.Id JOIN
		FormTemplateInputItem i on f1.InputFieldId = i.Id INNER JOIN
		GetUniqueidentifiers(@ids) Keys ON f.EnumValueId = Keys.Id