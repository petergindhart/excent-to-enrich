SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PrgActivity_GetAllRecords]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[PrgActivity_GetAllRecords]
GO


/*
<summary>
Gets all records from the PrgActivity table
	and inherited data from:PrgItem
</summary>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[PrgActivity_GetAllRecords]
AS
	SELECT
		i.*,
		a.*
	FROM
		PrgActivity a INNER JOIN
		PrgItemView i ON a.ID = i.ID
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

