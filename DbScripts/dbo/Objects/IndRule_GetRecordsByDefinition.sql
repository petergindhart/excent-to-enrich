SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[IndRule_GetRecordsByDefinition]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[IndRule_GetRecordsByDefinition]
GO

 /*
<summary>
Gets records from the IndRule table
with the specified ids
</summary>
<param name="ids">Ids of the IndDefinition(s) to retrieve</param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[IndRule_GetRecordsByDefinition]
	@ids	uniqueidentifierarray
AS
	SELECT
		i.DefinitionId,
		i.*
	FROM
		IndRule i INNER JOIN
		GetUniqueidentifiers(@ids) Keys ON i.DefinitionId = Keys.Id JOIN 
		IndStatus s on s.ID = i.StatusID
	ORDER BY 
		s.Sequence DESC
		
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

