SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PageView_GetRecords]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[PageView_GetRecords]
GO

 /*
<summary>
Gets records from the PageView table with the specified id's
</summary>
<param name="ids">Ids of the records to retrieve</param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="false" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE dbo.PageView_GetRecords
	@ids	uniqueidentifierarray
AS
	SELECT p.*
	FROM
		PageView p INNER JOIN
		GetUniqueidentifiers(@ids) AS Keys ON p.Id = Keys.Id
	ORDER BY [Sequence]
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

