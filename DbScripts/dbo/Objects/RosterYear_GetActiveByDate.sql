SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[RosterYear_GetActiveByDate]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[RosterYear_GetActiveByDate]
GO


/*
<summary>
Used to determine what roster year was active on a given date.
</summary>
<returns>The roster year that was active on the specified date.</returns>
<model isGenerated="false" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE dbo.RosterYear_GetActiveByDate 
	@date DATETIME
AS
	SELECT *
	FROM RosterYear
	WHERE ID = dbo.GetRosterYear(@date)


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

