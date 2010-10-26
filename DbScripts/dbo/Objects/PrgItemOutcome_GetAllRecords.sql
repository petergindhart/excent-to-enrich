IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[PrgItemOutcome_GetAllRecords]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[PrgItemOutcome_GetAllRecords]
GO

/*
<summary>
Gets all records from the PrgItemOutcome table
</summary>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[PrgItemOutcome_GetAllRecords]
AS
	SELECT
		p.*
	FROM
		PrgItemOutcome p 
	WHERE 
		p.DeletedDate IS NULL 
	ORDER BY 
		p.Sequence
GO