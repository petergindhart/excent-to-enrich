SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[RosterYear_GetRosterYear]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[RosterYear_GetRosterYear]
GO

/*
<summary>
Gets the roster year id for a specified date.
</summary>
<param name="date">The date which should include a roster year.</param>
<returns>The Id of the Roster Year</returns>
<model isGenerated="False" returnType="System.Guid" />
*/
CREATE PROCEDURE dbo.RosterYear_GetRosterYear 
	@date datetime 
AS
	SELECT dbo.GetRosterYear(@date) as id


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

