SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[SecurityTaskCategory_GetRecordsByParentId]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[SecurityTaskCategory_GetRecordsByParentId]
GO

 /*
<summary>
Gets records from the SecurityTaskCategory table for the specified ids 
</summary>
<param name="ids">Ids of the SecurityTaskCategory's </param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE dbo.SecurityTaskCategory_GetRecordsByParentId 
	@ids uniqueidentifierarray
AS
	SELECT s.ParentID, s.*
	FROM
		SecurityTaskCategory s INNER JOIN
		GetUniqueidentifiers(@ids) AS Keys ON s.ParentID = Keys.Id
	ORDER BY Sequence, Name
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

