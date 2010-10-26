if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Util_RefreshViews]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Util_RefreshViews]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS OFF 
GO

CREATE PROCEDURE Util_RefreshViews AS

DECLARE @viewname varchar(256)
DECLARE sqlcursor CURSOR FOR
	SELECT '[' + TABLE_SCHEMA + '].[' + TABLE_NAME + ']'
	FROM INFORMATION_SCHEMA.TABLES 
	WHERE TABLE_TYPE = 'VIEW'
OPEN sqlcursor

FETCH NEXT FROM sqlcursor INTO @viewname

WHILE @@FETCH_STATUS = 0
BEGIN
	PRINT 'refreshing: ' + @viewname
	exec sp_refreshview @viewname
	FETCH NEXT FROM sqlcursor INTO @viewname
END

CLOSE sqlcursor
DEALLOCATE sqlcursor
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

