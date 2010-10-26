if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[EnumValue_GetRecordsByEnumTypeID]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[EnumValue_GetRecordsByEnumTypeID]
GO

 /*
<summary>
Gets records from the EnumValue table with the specified EnumType id
</summary>
<param name="ids">EnumType of the records to retrieve</param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE dbo.EnumValue_GetRecordsByEnumTypeID
	@enumType uniqueidentifier
AS
	SELECT e.*
	FROM
		EnumValue e 
	WHERE
		e.Type = @enumType
	AND	IsActive = 1
	ORDER BY
		e.Sequence, e.Code

GO
