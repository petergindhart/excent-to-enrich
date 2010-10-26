SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[StudentGroup_GetRecords]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[StudentGroup_GetRecords]
GO


/*
<summary>
Gets records from the StudentGroup table with the specified id's
</summary>
<param name="ids">Ids of the records to retrieve</param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE dbo.StudentGroup_GetRecords 
	@ids uniqueidentifierarray
AS
	SELECT s.*
	FROM
		StudentGroup s INNER JOIN
		GetIds(@ids) AS Keys ON s.Id = Keys.Id
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

