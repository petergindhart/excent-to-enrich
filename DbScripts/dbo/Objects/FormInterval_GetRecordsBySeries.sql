SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FormInterval_GetRecordsBySeries]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[FormInterval_GetRecordsBySeries]
GO

/*
<summary>
Gets records from the FormInterval table
with the specified ids
</summary>
<param name="ids">Ids of the FormIntervalSeries(s) to retrieve</param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[FormInterval_GetRecordsBySeries]
	@ids	uniqueidentifierarray
AS
	SELECT
		f.SeriesId,
		f.*
	FROM
		FormInterval f INNER JOIN
		GetUniqueidentifiers(@ids) Keys ON f.SeriesId = Keys.Id
	ORDER BY
		f.Sequence

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

