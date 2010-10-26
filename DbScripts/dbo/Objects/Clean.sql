SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Clean]') and xtype in (N'FN', N'IF', N'TF'))
drop function [dbo].[Clean]
GO



/*
Escapes special characters from a string.  Should be used
when building dynamic sql that contains user-suppier values.
*/
CREATE FUNCTION dbo.Clean (@sql VARCHAR(8000), @escapeChar CHAR(1)=NULL)
RETURNS VARCHAR(8000)
AS
BEGIN
	DECLARE @clean VARCHAR(8000)

	SET @clean = REPLACE(@sql, '''', '''''' )

	IF @escapeChar IS NOT NULL
	BEGIN
		SET @clean = REPLACE( @clean, @escapeChar, @escapeChar + @escapeChar )
		SET @clean = REPLACE( @clean, '%', @escapeChar + '%' )
		SET @clean = REPLACE( @clean, '[', @escapeChar + ']' )
		SET @clean = REPLACE( @clean, ']', @escapeChar + ']' )
		SET @clean = REPLACE( @clean, '_', @escapeChar + '_' )
	END

	RETURN @clean
END

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

