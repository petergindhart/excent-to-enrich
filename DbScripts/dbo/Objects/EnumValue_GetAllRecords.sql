SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[EnumValue_GetAllRecords]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[EnumValue_GetAllRecords]
GO


/*
<summary>
Gets all records from the EnumValue table 
</summary>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE dbo.EnumValue_GetAllRecords
AS
	SELECT e.*
	FROM
		EnumValue e
	ORDER BY
		e.Type, e.Sequence, e.Code
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

