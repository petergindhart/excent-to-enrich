SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[TestDefinition_GetAllRecords]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[TestDefinition_GetAllRecords]
GO


/*
<summary>
Retrieves all TestDefinition records
</summary>
<returns>All TestDefinition records</returns>
<model isGenerated="false" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE dbo.TestDefinition_GetAllRecords
AS
	SELECT *
	FROM TestDefinition
	ORDER BY Name

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

