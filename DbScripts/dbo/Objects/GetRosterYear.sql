SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[GetRosterYear]') and xtype in (N'FN', N'IF', N'TF'))
drop function [dbo].[GetRosterYear]
GO


CREATE FUNCTION dbo.GetRosterYear( @date datetime )
RETURNS uniqueidentifier
AS
BEGIN
	RETURN (
		select id
		from RosterYear
		where dbo.DateInRange(@date, StartDate, EndDate) = 1
	)
END

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

