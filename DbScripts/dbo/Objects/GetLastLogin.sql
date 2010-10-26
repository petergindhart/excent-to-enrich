SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[GetLastLogin]') and xtype in (N'FN', N'IF', N'TF'))
drop function [dbo].[GetLastLogin]
GO

CREATE FUNCTION dbo.GetLastLogin( @userId uniqueidentifier )
RETURNS datetime
AS
BEGIN
	RETURN (
		select
			max(a.EventTime) [LastLogin]
		from
			UserProfile u join
			AuditLogEntry a on a.UserProfileId = u.Id
		where
			a.Message = 'Sign in successful' and
			u.Id = @userId
	)
END
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

