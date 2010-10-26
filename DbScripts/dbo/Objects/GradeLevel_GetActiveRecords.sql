SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[GradeLevel_GetActiveRecords]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[GradeLevel_GetActiveRecords]
GO


/*
<summary>
Gets active records from the GradeLevel table 
</summary>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE dbo.GradeLevel_GetActiveRecords 
AS
	SELECT g.*
	FROM
		GradeLevel g
	WHERE g.Active = 1 
	ORDER BY Sequence
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

