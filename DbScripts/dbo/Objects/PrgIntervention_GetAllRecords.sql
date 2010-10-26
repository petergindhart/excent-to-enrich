SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PrgIntervention_GetAllRecords]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[PrgIntervention_GetAllRecords]
GO

 /*
<summary>
Gets all records from the PrgIntervention table
	and inherited data from:PrgItem
</summary>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE dbo.PrgIntervention_GetAllRecords
AS
	SELECT
		p1.*,
		p.*
	FROM
		PrgIntervention p INNER JOIN
		PrgItemView p1 ON p.ID = p1.ID
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

