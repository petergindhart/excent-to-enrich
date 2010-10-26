/****** Object:  StoredProcedure [dbo].[PrgMeeting_GetRecords]    Script Date: 12/29/2009 09:22:14 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PrgMeeting_GetRecords]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[PrgMeeting_GetRecords]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 /*
<summary>
Gets records from the PrgMeeting table
	and inherited data from:PrgItem
with the specified id's
</summary>
<param name="ids">Ids of the records to retrieve</param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[PrgMeeting_GetRecords]
	@ids	uniqueidentifierarray
AS
	SELECT	
		p1.*,
		p.*
	FROM
		PrgMeeting p INNER JOIN
		PrgItemView p1 ON p.ID = p1.ID INNER JOIN
		GetUniqueidentifiers(@ids) Keys ON p.Id = Keys.Id