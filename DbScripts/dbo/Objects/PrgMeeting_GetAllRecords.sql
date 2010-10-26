/****** Object:  StoredProcedure [dbo].[PrgMeeting_GetAllRecords]    Script Date: 12/29/2009 09:32:29 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[PrgMeeting_GetAllRecords]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[PrgMeeting_GetAllRecords]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 /*
<summary>
Gets all records from the PrgMeeting table
	and inherited data from:PrgItem
</summary>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[PrgMeeting_GetAllRecords]
AS
	SELECT
		p1.*,
		p.*
	FROM
		PrgMeeting p INNER JOIN
		PrgItemView p1 ON p.ID = p1.ID
GO


