SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ExtendedPropertyDefinition_GetAllRecords]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[ExtendedPropertyDefinition_GetAllRecords]
GO


/*
<summary>
Gets all records from the ExtendedPropertyDefinition table 
</summary>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE dbo.ExtendedPropertyDefinition_GetAllRecords 
AS
	SELECT e.*
	FROM
		ExtendedPropertyDefinition e
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

